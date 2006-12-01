#################################################################################################
# автоматически выполняемая часть 
@auto[][_str;_tPath]
# текущее время
$dtNow[^date::now[]]
# режимы отладки и вывода
^if(^env:QUERY_STRING.pos[mode=nocache] >= 0){$NoCache(1)}
^if(^env:QUERY_STRING.pos[mode=noengine] >= 0){$Engine(0)}
^if(^env:QUERY_STRING.pos[mode=debug] >= 0){$Debug(1)}
^if(^env:QUERY_STRING.pos[mode=ncdebug] >= 0){$NoCache(1) $Debug(1)}
^if(^env:QUERY_STRING.pos[mode=xml] >= 0){$EngineXML(1)}
^if($Debug){
	$hUsageBegin[
		$.rusage[$status:rusage]
		$.memory[$status:memory]]}
# пути к классам
$CLASS_PATH[^table::create{path
/../data
/../data/processes
/../data/processes/common
/../data/processes/shared}]

# подключение основных классов
^use[lib.p]						# операторы
^use[implode.p]				# определение браузера
^use[dtf.p]						# работа с датами
^use[scroller.p]				# скроллер
# ^use[visualization.p]		# = debug
# основные настройки
# строка подключения к БД
$SQL.connect-string[mysql://root@localhost/mouse]
# директории
# основной каталог
$CfgDir[/../data/]
# каталог с кэшем сайта =work
$CacheDir[/../data/cache/]
# папка где живут шаблоны 
$TemplateDir[/../data/templates/]
# папка где живут обработчики блоков и обьектов
$ProcessDir[/../data/processes/shared/blocks/]
# время кэширования по умолчанию (5 минут)
$iDefaultCacheTime(5*60)
# получаем путь к запрашиваемой странице
$_str[$request:uri]
$_tPath[^_str.split[?;lh]]
$sPath[$_tPath.0]
# данныe HTTP_USER_AGENT 
^detectBrowser[]
^use[mysql.p]		# работа с MySQL
# sql объект
$objSQL[^mysql::init[$SQL.connect-string; 
	$.is_debug($Debug)
	$.cache_dir[${CacheDir}sql]
	$.cache_interval(1/24)
]]
# подключаемся к БД
^objSQL.server{
	^use[auth.p]		# авторизация
# 	объект авторизации $objAuth
	$objAuth[^auth::init[
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
#		загрузка модуля
		^use[m_engine.p]
#		инициализация
		$oEngine[^engine::init[]]
}
# устанавливаем заголовки ответа
$response:cache-control[no-store, no-cache]
$response:pragma[no-cache]
$response:content-type[
	$.value[text/html]
	$.charset[windows-1251]
]
#		$response:expires[^date::now(-10)] 
#end @auto[]

#################################################################################################
@main[][_hCacheOptions;iIsExecuted]
# мы можем выключить движок параметром mode=noengine
^if(^Engine.int(1)){
#	=debug
#	обработка запроса + кэширование
	$_hCacheOptions[^cacheOptions[]]
	^cache[${CacheDir}$_hCacheOptions.key]($_hCacheOptions.time){
		$iIsExecuted(1) 
		^trim[^oEngine.execute[]]
	}
	^_comments[$_hCacheOptions.key;$_hCacheOptions.time;$iIsExecuted]
}
	^if($Debug){
		$hUsageAfter[
			$.rusage[$status:rusage]
			$.memory[$status:memory]
		]
	}
#end @main[]

#################################################################################################
# получение SQL статистики
@postprocess[body]
$result[$body]
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
#end @postprocess[body]

#################################################################################################
@cacheOptions[][_fDisableCache;_tCacheCfg;_tCacheTime;_sPath]
^if(
#	POST формы
	$env:REQUEST_METHOD eq "POST" || $NoCache
#	локальные адреса =debug (отключено ибо нужно проверить)
#	|| ^env:REMOTE_ADDR.match[^^127\.0\.0] || ^env:REMOTE_ADDR.match[^^192\.168][]
){
	$_fDisableCache(1)
}{
	$_fDisableCache(0)
}

^if($_fDisableCache){
	$result[
		$.time(0)
		$.key[dummy]
	]
}{
	$result[ 
		^try{ 
#			если есть кэш файл загружаем и работаем
			$_tCacheCfg[^table::load[${CacheDir}_cache.cfg]]
			$bCacheFile(0)
#			это кэширование только не динамических(не изменяющихся "сами по себе") объектов
#			на совести администратора
			$_sCacheTime(0)
			^_tCacheCfg.menu{
				^if($_tCacheCfg.full_path eq $sPath){$_sId[$_tCacheCfg.id] $_sCacheTime($_tCacheCfg.cache_time) }
			}
			$_sPath[^math:md5[$request:uri]]
			$.time[$_sCacheTime]
			$.key[${_sId}_${_sPath}_${platform}_${browser}.cache]
		}{
#			если его нету говорим движку что его надо создать
			$exception.handled(1)
			$bCacheFile(1)
#			и зажигаем пустые флажки кэша
			$.time(0)
			$.key[dummy]
		}
]}
#end @cacheOptions[]

#################################################################################################
@_comments[sKey;iTime;iIsExecuted][_dNow]
^if($iIsExecuted){
	^if(-f "$sCacheDir/$sKey"){
		$result[^self._print[Point generated.;$sKey]($iTime)]]
	}{
		$result[^self._print[Point generated. Storing to cache skipped.;$sKey]($iTime)]]
	}
}{
	$result[^self._print[Point taked from cache.;$sKey]($iTime)]]
}
#end @_comments[]

###########################################################################
@_print[sText;sKey;iTime]
$result[<!-- ^dtNow.sql-string[] $sText Cache key: $sKey, cache time: $iTime secs -->]
#end @_print[]

@stop[str]
^throw[stop;$str]