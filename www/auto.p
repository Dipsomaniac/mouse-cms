#################################################################################################
# автоматически выполняемая часть 
@auto[][cTemp;sTemp]
# -----------------------------------------------------------------------------------------------
# устанавливаем заголовки ответа
$response:cache-control[no-store, no-cache]
$response:pragma[no-cache]
$request:charset[UTF-8]
$response:charset[windows-1251] 
$response:content-type[
	$.value[text/html]
   $.charset[$response:charset]
]
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
# получаем информацию о пользователе, сразу потому что маус ведет статистику и по кэшированным страницам
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

# -----------------------------------------------------------------------------------------------
# основные настройки
$SQL.connect-string[mysql://root:@localhost/mouse2?charset=utf8]	# строка подключения к БД
$CLASS_PATH[^table::create{path												# пути к классам
/../data
/../data/processes
/../data/processes/common
/../data/processes/shared}]
# пути к директориям
$CfgDir[/../data/]																# основной каталог
$CacheDir[${CfgDir}cache/]														# каталог с кэшем сайта
$TemplateDir[${CfgDir}templates/]											# папка где живут шаблоны 
$ProcessDir[${CfgDir}processes/shared/blocks/]							# папка где живут обработчики блоков и обьектов
$LogDir[${CfgDir}log/]															# папка где живут логи
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
# отладка
^if(^hUserInfo.Query.pos[mode=nocache] >= 0){$NoCache(1)}
^if(^hUserInfo.Query.pos[mode=debug] >= 0){$Debug(1)}
^if(^hUserInfo.Query.pos[mode=ncdebug] >= 0){$NoCache(1) $Debug(1)}
^if($Debug){$hUsageBegin[$.rusage[$status:rusage] $.memory[$status:memory]]}
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
# подключение основных классов
^use[lib.p]						# операторы
^use[dtf.p]						# работа с датами
^use[scroller.p]				# скроллер
^use[mysql.p]					# работа с MySQL
^use[auth.p]					# авторизация
^use[m_engine.p]				# движок mouse
# ^use[visualization.p]		# = debug
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
# прочее для совместимости =debug
$dtNow[^date::now[]]
# получаем путь к запрашиваемой странице
$sPath[^hUserInfo.Request.split[?;lh]]
$sPath[$sPath.0]
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
# создание основных объектов и инициализация engine
$objSQL[^mysql::init[$SQL.connect-string; # SQL object
	$.is_debug($Debug)
	$.cache_dir[${CacheDir}sql]
	$.cache_interval(1/24)
]]
^objSQL.server{
	$objAuth[^auth::init[	# 	объект авторизации $objAuth
		$cookie:CLASS;
		$form:fields;
		$.csql[$MAIN:objSQL]
		$.additional_fields[^table::create{select	update	field
fio	fio	fio
www	www	www
adress	adress	adress
work_place	work_place	work_place
work_position	work_position	work_position
dt_birth	dt_birth	dt_birth
telefon	telefon	telefon}]
]]
	$oEngine[^engine::init[]]
}
^mStatistic[]
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
# убираем грязь
$result[]
# -----------------------------------------------------------------------------------------------
#end @auto[]



#################################################################################################
# выполнение кода движка по дефолту
@main[][_hCacheOptions;iIsExecuted]
#	=debug
#	обработка запроса + кэширование
$_hCacheOptions[^mGetCacheOptions[]]
^cache[${CacheDir}$_hCacheOptions.key]($_hCacheOptions.time){
	$iIsExecuted(1) 
	^trim[^oEngine.execute[]]
}
^_comments[$_hCacheOptions.key;$_hCacheOptions.time;$iIsExecuted]
^if($Debug){$hUsageAfter[ $.rusage[$status:rusage] $.memory[$status:memory]]}
#end @main[]



#################################################################################################
# получение статистики да и вообще постпроцесс
@postprocess[sBody]
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



#################################################################################################
# получение ключа кэширования
@mGetCacheOptions[][_tCacheCfg;_tCacheTime;_sPath;_sId]
$result[
	$.time(0)
	$.key[dummy]
]
#	|| ^env:REMOTE_ADDR.match[^^127\.0\.0] || ^env:REMOTE_ADDR.match[^^192\.168][]
^if( $env:REQUEST_METHOD eq "POST" || $NoCache ){
# если идет отладка или POST формы ничего не делаем
}{
	$result[ 
		^try{ 
#			если есть кэш файл загружаем и работаем
			$_tCacheCfg[^table::load[${CacheDir}_cache.cfg]]
			$_sCacheTime(0)
			^_tCacheCfg.menu{^if($_tCacheCfg.full_path eq $sPath){$_sId[$_tCacheCfg.id] $_sCacheTime($_tCacheCfg.cache_time) }}
			$_sPath[^math:md5[$request:uri]]
			$.time[$_sCacheTime]
			$.key[${_sId}_${_sPath}_${hUserInfo.Os}_${hUserInfo.Browser}.cache]
		}{
#			если его нету говорим движку что его надо создать
			$exception.handled(1)
			$bCacheFile(1)
			$.time(0)
			$.key[dummy]
		}]
}
#end @mGetCacheOptions[]



#################################################################################################
@_comments[sKey;iTime;iIsExecuted][cTemp]
$cTemp{<!-- ^dtNow.sql-string[] $sText Cache key: $sKey, cache time: $iTime secs -->}
^if($iIsExecuted){
	^if(-f "$sCacheDir/$sKey"){$sText[Point generated.]}{$sText[Point generated. Storing to cache skipped]}
}{$sText[Point taked from cache.]}
$result[$cTemp]
#end @_comments[]



#################################################################################################
# метод собирает статистику по пользователям =debug решил сделать здесь
@mStatistic[][tHits;tHosts;cCounter;sFile;fFile;sCount;sStr;tLog]
$cCounter{
	^file:lock[${sFile}.lock]{
	$fFile[^file::load[text;$sFile]]
	$sCount[^eval($fFile.text+1)]
	^sCount.save[$sFile]
	}
}
^try{
	$tHits[^file::load[text;${LogDir}statistic/hits/^dtNow.day.format[%02d].cfg]]
	$tHosts[^file::load[text;${LogDir}statistic/hosts/^dtNow.day.format[%02d].cfg]]
	$sFile[${LogDir}statistic/hits/^dtNow.day.format[%02d].cfg]
	$cCounter
	$tLog[^table::load[nameless;${LogDir}statistic/^dtNow.day.format[%02d].cfg]]
	^if(^tLog.locate($tLog.2 eq $hUserInfo.Ip && $tLog.3 eq $hUserInfo.Proxy)){}{
		$sFile[${LogDir}statistic/hosts/^dtNow.day.format[%02d].cfg]
		$cCounter
	}
}{
	$sCount[1]
	$sFile[${LogDir}statistic/hits/^dtNow.day.format[%02d].cfg]
	^sCount.save[$sFile]
	$sFile[${LogDir}statistic/hosts/^dtNow.day.format[%02d].cfg]
	^sCount.save[$sFile]
	$exception.handled(1)
}
$sStr[^dtNow.sql-string[]	$sPath	$hUserInfo.Ip	$hUserInfo.Proxy	$hUserInfo.Os	$hUserInfo.Browser $hUserInfo.Browser_fullver	$hUserInfo.Referer^#0A]
^file:lock[${LogDir}statistic/^dtNow.day.format[%02d].cfg.lock]{^sStr.save[append;${LogDir}statistic/^dtNow.day.format[%02d].cfg]}
#end @mStatistic[]



#################################################################################################
# =debug отладка просто чтобы ^trow долго не писать - ^stop[bla bla bla]
@stop[str]
^throw[stop;$str]
#end @stop[str]

