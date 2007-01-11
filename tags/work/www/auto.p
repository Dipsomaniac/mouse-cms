####################################################################################################
# автоматически выполняемая часть 
@auto[][cTemp;sTemp;hUserInfo;hfMouse;result]
$dtNow[^date::now[]]
# -----------------------------------------------------------------------------------------------
# получаем информацию о пользователе, сразу потому что маус ведет статистику и по кэшированным страницам
# присвоить это SYSTEM в поле engine и удалить
$hUserInfo[
	$.Os[unix]
	$.Browser[other]
	$.Browser_ver(0)
	$.Browser_subver(0)
	$.Ip[$env:REMOTE_ADDR]
	$.Proxy[$env:HTTP_X_FORWARDED_FOR]
	$.UserAgent[$env:HTTP_USER_AGENT]
	$.Referer[$env:HTTP_REFERER]
	$.Query[$env:QUERY_STRING]
	$.Request[$request:uri]
	$.siteUrl[$env:SERVER_NAME]
# обработка многоязычности
	^if(def $form:lang){
		$cookie:lang[$form:lang]
		$.langId[$form:lang]
	}{
		$.langId[$cookie:lang]
	}
]
^hUserInfo.UserAgent.match[mac][i]{$hUserInfo.Os[mac]}
^hUserInfo.UserAgent.match[win][i]{$hUserInfo.Os[win]}
$cTemp{
	^hUserInfo.UserAgent.match[(?:$sTemp).((?:\d+)(?:\.(\d+))?)][i]{
		$hUserInfo.Browser[$sTemp]
		$hUserInfo.Browser_ver[^match.2.int(0)]
		$hUserInfo.Browser_subver[^match.4.int(0)]
		$hUserInfo.Browser_fullver[^match.1.double(0)]
	}
}
$sTemp[opera]$cTemp
$sTemp[msie]$cTemp
$sTemp[mozilla]$cTemp
$sTemp[safari]$cTemp
$sTemp[netscape]$cTemp
# -----------------------------------------------------------------------------------------------
# основные настройки
$SQL.connect-string[mysql://root:@localhost/mouse?charset=utf8]
$CLASS_PATH[^table::create{path
/../data
/../data/processes
/../data/processes/common
/../data/processes/shared}]
# пути к директориям
# основной каталог
$CfgDir[/../data]
# каталог с кэшем сайта
$CacheDir[$CfgDir/cache]
# папка где живут шаблоны 
$TemplateDir[$CfgDir/templates]
# папка где живут обработчики блоков и обьектов
$ProcessDir[$CfgDir/processes/shared/blocks]
# папка где живут логи
$LogDir[$CfgDir/log]
# -----------------------------------------------------------------------------------------------
# отладка
^if(^hUserInfo.Query.pos[mode=nocache] >= 0){$NoCache(1)}
^if(^hUserInfo.Query.pos[mode=debug] >= 0){$Debug(1)}
^if(^hUserInfo.Query.pos[mode=ncdebug] >= 0){$NoCache(1) $Debug(1)}
^if($Debug){$hUsageBegin[$.rusage[$status:rusage] $.memory[$status:memory]]}
# -----------------------------------------------------------------------------------------------
# подключение основных классов
^use[lib.p]
^use[curd.p]
^use[mysql.p]
^use[auth.p]
^use[engine.p]
# -----------------------------------------------------------------------------------------------
# получаем путь к запрашиваемой странице
$hUserInfo.path[^hUserInfo.Request.split[?;lh]]
$hUserInfo.path[$hUserInfo.path.0]
# -----------------------------------------------------------------------------------------------
# создание уникального ключа системы
$hfMouse[^hashfile::open[$CfgDir/config.hf]]
^if(!def $hfMouse.key){^dir_delete[$CacheDir;$.is_recursive(1)] $hfMouse.key[$.value[^math:uuid[]]$.expires(1/12)]}
$hUserInfo.key[$hfMouse.key]
# -----------------------------------------------------------------------------------------------
# создание основных объектов и инициализация engine
$objSQL[^mysql::init[$SQL.connect-string;$.is_debug($Debug)$.cache_dir[$CacheDir/sql]$.cache_interval(1/24)]]
^objSQL.server{
	$objAuth[^auth::init[$cookie:CLASS;$form:fields;$.csql[$MAIN:objSQL]]]
	$oEngine[^engine::init[$hUserInfo]]
}
# собираем статистику
^mStatistic[$hUserInfo]
# -----------------------------------------------------------------------------------------------
# убираем грязь
$result[]
#end @auto[]



####################################################################################################
# выполнение кода движка по дефолту
@main[][hCacheOptions;iIsExecuted]
#	=debug
#	обработка запроса + кэширование
$hCacheOptions[^mGetCacheOptions[]]
^cache[$CacheDir/$hCacheOptions.key]($hCacheOptions.time){
	$iIsExecuted(1) 
	^oEngine.execute[]
}
^if($hCacheOptions.time){^_comments[$hCacheOptions.key;$hCacheOptions.time;$iIsExecuted]}
^if($Debug){$hUsageAfter[ $.rusage[$status:rusage] $.memory[$status:memory]]}
#end @main[]



####################################################################################################
# получение статистики да и вообще постпроцесс
@postprocess[sBody][result]
$result[$sBody]
# Debug режим
^if(def $objSQL && $objSQL.iIsDebug){^objSQL.getStatistics[/../data/log/sql.txt]}
^if($Debug){
		$sTime((^hUsageAfter.rusage.tv_sec.double[] - ^hUsageBegin.rusage.tv_sec.double[])*1000 + (^hUsageAfter.rusage.tv_usec.double[] - ^hUsageBegin.rusage.tv_usec.double[])/1000)
		$sUTime($hUsageAfter.rusage.utime - $hUsageBegin.rusage.utime)
		$sMemory_kb($hUsageAfter.memory.used - $hUsageBegin.memory.used)
$sPrefix[^dtNow.sql-string[]	$env:REMOTE_ADDR ]
$sMessage[Time(ms): ^sTime.format[%02.2f]   UTime(s): ^sUTime.format[%02.2f]   Memory(kb): $sMemory_kb]
$sLine[$sPrefix   $sMessage
]
^sLine.save[append;/../data/log/EngineUsage.log]
}
#end @postprocess[sBody]



####################################################################################################
# получение ключа кэширования
@mGetCacheOptions[][tCacheCfg;tCacheTime;sCachePath;sId;result]
$result[
	$.time(0)
	$.key[dummy]
]
# если идет отладка или POST формы ничего не делаем
^if( $env:REQUEST_METHOD eq "POST" || $NoCache ){}{
	$result[
		^try{ 
#			если есть кэш файл загружаем и работаем
			$tCacheCfg[^table::load[$CacheDir/_cache.cfg]]
			$sCacheTime(0)
			^tCacheCfg.menu{^if($tCacheCfg.full_path eq $sPath){$sId[$tCacheCfg.id] $sCacheTime($tCacheCfg.cache_time) }}
			$sCachePath[^math:md5[$request:uri]]
			$.time[$sCacheTime]
			$.key[${hUserInfo.lang}_${sId}_${sCachePath}_${hUserInfo.Os}_${hUserInfo.Browser}.cache]
		}{
#			если его нету говорим движку что его надо создать
			$exception.handled(1)
			$bCacheFile(1)
			$.time(0)
			$.key[dummy]
		}
	]
}
# ^stop[$result.key]
#end @mGetCacheOptions[]



####################################################################################################
@_comments[sKey;iTime;iIsExecuted][sText;result]
^if($iIsExecuted){
	^if(-f "$sCacheDir/$sKey"){
		$sText[Point generated. Storing to cache done.]
	}{
		$sText[Point generated. Storing to cache skipped.]
	}
}{
	$sText[Point taked from cache.]
}
$result[<!-- ^dtNow.sql-string[] | $sText | Key: $sKey, Time: $iTime secs -->]
#end @_comments[]



####################################################################################################
# метод собирает статистику по пользователям =debug решил сделать здесь
# debug - переделать на hashfile
@mStatistic[hUserInfo][hName;tHits;tHosts;cCounter;sFile;fFile;sCount;sStr;tLog;result]
$hName[
	$.main[$LogDir/static/$dtNow.year/$dtNow.month/^dtNow.day.format[%02d].cfg]
	$.hits[$LogDir/static/$dtNow.year/$dtNow.month/hits/^dtNow.day.format[%02d].cfg]
	$.hosts[$LogDir/static/$dtNow.year/$dtNow.month/hosts/^dtNow.day.format[%02d].cfg]
]
$cCounter{
	^file:lock[${sFile}.lock]{
	$fFile[^file::load[text;$sFile]]
	$sCount[^eval($fFile.text+1)]
	^sCount.save[$sFile]
	}
}
^try{
	$tHits[^file::load[text;$hName.hits]]
	$tHosts[^file::load[text;$hName.hosts]]
	$sFile[$hName.hits]
	$cCounter
	$tLog[^table::load[nameless;$hName.main]]
	^if(^tLog.locate($tLog.2 eq $hUserInfo.Ip && $tLog.3 eq $hUserInfo.Proxy)){}{
		$sFile[$hName.hosts]
		$cCounter
	}
}{
	$sCount[1]
	$sFile[$hName.hits]
	^sCount.save[$sFile]
	$sFile[$hName.hosts]
	^sCount.save[$sFile]
	$exception.handled(1)
}
$sStr[^dtNow.sql-string[]	$hUserInfo.Request	$hUserInfo.Ip	$hUserInfo.Proxy	$hUserInfo.Os	$hUserInfo.Browser $hUserInfo.Browser_fullver	$hUserInfo.Referer^#0A]
^file:lock[${hName.main}.lock]{^sStr.save[append;$hName.main]}
$result[]
#end @mStatistic[]



####################################################################################################
# =debug отладка просто чтобы ^trow долго не писать - ^stop[bla bla bla]
@stop[str][result]
^use[debug.p]
^debug:show[$str;/debug.html]
^throw[stop;stop: $str]
#end @stop[str]
