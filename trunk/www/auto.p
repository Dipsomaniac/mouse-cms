#################################################################################################
# ������������� ����������� ����� 
@auto[][_str;_tPath]
# ������� �����
$dtNow[^date::now[]]
# ������ ������� � ������
^if(^env:QUERY_STRING.pos[mode=nocache] >= 0){$NoCache(1)}
^if(^env:QUERY_STRING.pos[mode=noengine] >= 0){$Engine(0)}
^if(^env:QUERY_STRING.pos[mode=debug] >= 0){$Debug(1)}
^if(^env:QUERY_STRING.pos[mode=ncdebug] >= 0){$NoCache(1) $Debug(1)}
^if(^env:QUERY_STRING.pos[mode=xml] >= 0){$EngineXML(1)}
^if($Debug){
	$hUsageBegin[
		$.rusage[$status:rusage]
		$.memory[$status:memory]]}
# ���� � �������
$CLASS_PATH[^table::create{path
/../data
/../data/processes
/../data/processes/common
/../data/processes/shared}]

# ����������� �������� �������
^use[lib.p]						# ���������
^use[implode.p]				# ����������� ��������
^use[dtf.p]						# ������ � ������
^use[scroller.p]				# ��������
# ^use[visualization.p]		# = debug
# �������� ���������
# ������ ����������� � ��
$SQL.connect-string[mysql://root@localhost/mouse]
# ����������
# �������� �������
$CfgDir[/../data/]
# ������� � ����� ����� =work
$CacheDir[/../data/cache/]
# ����� ��� ����� ������� 
$TemplateDir[/../data/templates/]
# ����� ��� ����� ����������� ������ � ��������
$ProcessDir[/../data/processes/shared/blocks/]
# ����� ����������� �� ��������� (5 �����)
$iDefaultCacheTime(5*60)
# �������� ���� � ������������� ��������
$_str[$request:uri]
$_tPath[^_str.split[?;lh]]
$sPath[$_tPath.0]
# �����e HTTP_USER_AGENT 
^detectBrowser[]
^use[mysql.p]		# ������ � MySQL
# sql ������
$objSQL[^mysql::init[$SQL.connect-string; 
	$.is_debug($Debug)
	$.cache_dir[${CacheDir}sql]
	$.cache_interval(1/24)
]]
# ������������ � ��
^objSQL.server{
	^use[auth.p]		# �����������
# 	������ ����������� $objAuth
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
#		�������� ������
		^use[m_engine.p]
#		�������������
		$oEngine[^engine::init[]]
}
# ������������� ��������� ������
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
# �� ����� ��������� ������ ���������� mode=noengine
^if(^Engine.int(1)){
#	=debug
#	��������� ������� + �����������
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
# ��������� SQL ����������
@postprocess[body]
$result[$body]
# Debug �����
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
#	POST �����
	$env:REQUEST_METHOD eq "POST" || $NoCache
#	��������� ������ =debug (��������� ��� ����� ���������)
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
#			���� ���� ��� ���� ��������� � ��������
			$_tCacheCfg[^table::load[${CacheDir}_cache.cfg]]
			$bCacheFile(0)
#			��� ����������� ������ �� ������������(�� ������������ "���� �� ����") ��������
#			�� ������� ��������������
			$_sCacheTime(0)
			^_tCacheCfg.menu{
				^if($_tCacheCfg.full_path eq $sPath){$_sId[$_tCacheCfg.id] $_sCacheTime($_tCacheCfg.cache_time) }
			}
			$_sPath[^math:md5[$request:uri]]
			$.time[$_sCacheTime]
			$.key[${_sId}_${_sPath}_${platform}_${browser}.cache]
		}{
#			���� ��� ���� ������� ������ ��� ��� ���� �������
			$exception.handled(1)
			$bCacheFile(1)
#			� �������� ������ ������ ����
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