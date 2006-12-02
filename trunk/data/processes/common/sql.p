###########################################################################
# $Id: sql.p,v 1.48 2006/05/17 16:33:33 misha Exp $
###########################################################################


@CLASS
sql



###########################################################################
@auto[][i]
$tType[^table::create{name
void
table
hash
string
int
double
file}]

$sHeadDivider[^for[i](1;50){=}]
$sQueryDivider[^for[i](1;50){-}]
#end @auto[]



###########################################################################
# $.is_debug(1) if specified queries statistics will collected (time/memory usage)
# $.cache_dir[directory where cache files will be located]
# $.cache_interval(cache expiration interval, days)
@init[sConnectString;hParam]
$dtNow[^date::now[]]

# backward: hParam can be string
^if($hParam is "string" && def $hParam){
	$hParam[$.iIsDebug(1)]
}{
	$hParam[^hash::create[$hParam]]
}

$self.sConnectString[$sConnectString]
$self.sCacheDir[$hParam.cache_dir]
$self.iIsDebug(^if($hParam.is_debug){1}{0})
$self.dDefaultCacheInterval(^hParam.cache_interval.double(1))
$self.iConnectEstablished(0)
$self.iConnectionsCount(0)

# hash for keeping info about all queries (key - query number, from 1).
#	.type	- int/double/string etc
#	.query	- query text
#	.result	- query results (for int/double/string) or number of rows (for table/hash)
#	.result_count	- number of rows
#	.query_detail	- extended info (explain)
#	.statistics		- query statistics (time/memory usage, from operator @run_time{})
#	.cache_options	- cache params
#	.sql_options	- query params (limit/offset)
#	.sql_options_string	- query params as string
$hQueryInfo[^hash::create[]]

# hash for summary statistics
$hStatistics[
	$.total[^_initStatistics[]]
	^tType.menu{$.[$tType.name][^_initStatistics[]]}
]
#end @init[]



###########################################################################
@server[jBody]
^iConnectionsCount.inc(1)
^try{
	^connect[$sConnectString]{
		^iConnectEstablished.inc(1)
		^self.setServerEnviroment[]
		$result[$jBody]
		^iConnectEstablished.dec(1)
	}
}{
	^iConnectEstablished.dec(1)
	$result[]
}
#end @server[]



###########################################################################
# in this this method we can set server enviroments
@setServerEnviroment[]
$result[]
#end @setServerEnviroment[]



###########################################################################
# in $hCacheOptions available:
# $.is_force(1) - execute query without clearing cache
# $.file[path-to/query-cache-file.ext]. path to query cache time from $sCacheDir
# $.cache_interval(cache interval, days [default 1]). 0 mean query not cached
# $.cache_expiration_time[time when cache expired]
# $.cache_threshold(value in % [default 100%])
# in any cases cache file will be cleared after 1.5 * cache_interval


###########################################################################
@void[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[void;$sQuery;$hSqlOptions;$hCacheOptions]{
	$result[]
	^self._execute{
		^void:sql{$sQuery}
	}
}
#end @void[]



###########################################################################
@int[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[int;$sQuery;$hSqlOptions;$hCacheOptions]{
	^_sql[int;$hCacheOptions]{$result(^int:sql{$sQuery}[$hSqlOptions])}
}
#end @int[]



###########################################################################
@double[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[double;$sQuery;$hSqlOptions;$hCacheOptions]{
	^_sql[double;$hCacheOptions]{$result(^double:sql{$sQuery}[$hSqlOptions])}
}
#end @double[]



###########################################################################
@string[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[double;$sQuery;$hSqlOptions;$hCacheOptions]{
	^_sql[string;$hCacheOptions]{$result[^string:sql{$sQuery}[$hSqlOptions]]}
}
#end @string[]



###########################################################################
@table[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[table;$sQuery;$hSqlOptions;$hCacheOptions]{
	^_sql[table;$hCacheOptions]{$result[^table::sql{$sQuery}[$hSqlOptions]]}
}
#end @table[]



###########################################################################
@hash[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[hash;$sQuery;$hSqlOptions;$hCacheOptions]{
	^_sql[hash;$hCacheOptions]{$result[^hash::sql{$sQuery}[$hSqlOptions]]}
}
#end @hash[]



###########################################################################
@file[jQuery;hSqlOptions;hCacheOptions][sQuery]
$sQuery[$jQuery]
^self._measure[file;$sQuery;$hSqlOptions;$hCacheOptions]{
	^_sql[file;$hCacheOptions]{$result[^file::sql{$sQuery}[$hSqlOptions]]}
}
#end @file[]



###########################################################################
# when you update database and want clear cache file immediately call: ^clear[path-to/query-cache-file.ext]
# or just ^clear[] to delete all files in $sCacheDir (method don't delete subdirectories and files in subdirectories)
@clear[sFileName][tFileList]
^if(def $sFileName){
	$tFileList[^table::create{name^#0A$sFileName}]
}{
	$tFileList[^file:list[$sCacheDir]]
}
^if($tFileList){
	^tFileList.menu{^self._clearCacheFile[$.file[$tFileList.name]]}
}
$result[]
#end @clear[]



###########################################################################
# save information about queries to file
@printStatistics[hParam][i;bIsHaveInfoForSave;bIsHaveParams;bQueriesLimitExceeded]
$hParam[^hash::create[$hParam]]
$bIsHaveInfoForSave(0)

^self._getQueriesDetails[$hParam]

# order by number of queries
^tType.sort($hStatistics.[$tType.name].count)[desc]

$bIsHaveParams(def $hParam.debug_time_limit || def $hParam.debug_queries_limit || def $hParam.debug_result_limit)
^if($hParam.debug_queries_limit && $hStatistics.total.count > ^hParam.debug_queries_limit.int(0)){
	$bQueriesLimitExceeded(1)
	$bIsHaveInfoForSave(1)
}
$result[^if($bIsHaveParams){$sHeadDivider
}TIME: ^dtNow.sql-string[], METHOD: $env:REQUEST_METHOD, URL: http://${env:SERVER_NAME}$request:uri
SQL connections while generating page: $iConnectionsCount
SQL requests while generating page^if($bIsHaveParams){ [debug time limit: ^hParam.debug_time_limit.int(0) ms, debug queries limit: ^hParam.debug_queries_limit.int(0), debug result limit: ^hParam.debug_result_limit.int(3000)]}

^tType.menu{^_printStatisticsLine[$tType.name;$hStatistics.[$tType.name]]}[^#0A]
$sQueryDivider
^_printStatisticsLine[TOTAL;$hStatistics.total]^if($bQueriesLimitExceeded){ [debug queries limit exceeded]}

^for[i](1;$hStatistics.total.count){^if($hQueryInfo.[$i] is "hash" && (($bQueriesLimitExceeded && $hParam.is_expand_exceeded_queries_to_log) || (!$hQueryInfo.[$i].statistics && !$bIsHaveParams) || ($hQueryInfo.[$i].statistics && $hQueryInfo.[$i].statistics.time >= $hParam.debug_time_limit) || ($hQueryInfo.[$i].result_count >= ^hParam.debug_result_limit.int(3000)))){$bIsHaveInfoForSave(1)^_printQueryInfo[$hQueryInfo.[$i];$hParam]}}

]

^if($bIsHaveInfoForSave && def $hParam.file){
	^if($bIsHaveParams){
		^result.save[append;$hParam.file]
	}{
		^result.save[$hParam.file]
	}
}
#end @printStatistics[]



###########################################################################
@_initStatistics[]
$result[
	$.count(0)
	$.time(0)
	$.utime(0)
	$.memory_kb(0)
	$.memory_block(0)
]
#end @_initStatistics[]



###########################################################################
@_printStatisticsLine[sTitle;hStatisticsInfo]
$result[^if($hStatisticsInfo.count){${sTitle}:^#20^#20^#09$hStatisticsInfo.count^if($iIsDebug){		[$hStatisticsInfo.time ms/$hStatisticsInfo.memory_kb KB/$hStatisticsInfo.memory_block blocks]}}]
#end @_printStatisticsLine[]



###########################################################################
# execute query and measure time/memory
@_measure[sType;sQuery;hSqlOptions;hCacheOptions;jBody][hStatistics]
$bIsSql(1)
^run_time{$jBody}[^if($iIsDebug){hStatistics}]
^if($bIsSql){
	^_storeQueryStatistics[$sType;$sQuery;$hSqlOptions;$hCacheOptions;$hStatistics;$caller.result]
}
#end @_measure[]



###########################################################################
@_sql[sType;hOption;jSql]
^if($hOption is "hash" && def $hOption.file){
	$bIsSql(0)
	^if($hOption.clear){
		^self._clearCacheFile[$hOption]
	}{
		^try{
			^self._checkCacheExpiration[$hOption]
			$caller.result[^self._load[$sType;$sCacheDir/$hOption.file]]
		}{
			$exception.handled(1)
			^self._clearCacheFile[$hOption]
			$bIsSql(1)
			^self._execute{$jSql}
			^if(!$hOption.is_force){
				^self._save[$sType;$sCacheDir/$hOption.file;$caller.result]
			}
		}
	}
}{
	^self._execute{$jSql}
}
$result[]
#end @_sql[]



###########################################################################
@_execute[jSql]
$result[^if($iConnectEstablished){$jSql}{^self.server{$jSql}}]
#end @_execute[]



###########################################################################
@_clearCacheFile[hOptions][result]
$result[]
^if(!$hOptions.is_force && -f "$sCacheDir/$hOptions.file"){
	^try{
		^file:delete[$sCacheDir/$hOptions.file]
	}{
		$exception.handled(1)
	}
}
#end @_clearCacheFile[]



###########################################################################
@_checkCacheExpiration[hOptions][iCacheInterval;fStat;uExpire;dtExpire]
$result[]
^if($hOptions.is_force){
	^throw[cache.force;Cache expiration breaked by ^$.is_force value]
}{
	^if(-f "$sCacheDir/$hOptions.file"){
		$iCacheInterval(^hOptions.cache_interval.double($dDefaultCacheInterval))
		$uExpire[$hOptions.cache_expiration_time]
		$fStat[^file::stat[$sCacheDir/$hOptions.file]]
		^if(($fStat.mdate < ($dtNow - $iCacheInterval)) && (($fStat.mdate < ($dtNow - 1.5 * $iCacheInterval)) || (^math:random(100) < ^hOptions.cache_threshold.int(100)))){
			^throw[cache.interval;Cache expired according to ^$.cache_interval value]
		}{
			^if(def $uExpire){
				^if($uExpire is "date"){
					$dtExpire[^date::create($dtNow.year;$dtNow.month;$dtNow.day;$uExpire.hour;$uExpire.minute;$uExpire.second)]
				}{
					$dtExpire[^date::create[$uExpire]]
				}
				^if($dtNow > $dtExpire && $fStat.mdate < $dtExpire){
					^throw[cache.expiration_time;Cache expired according to ^$.cache_expiration_time value]
				}
			}
		}
	}{
		^throw[cache.no_file;File not found]
	}
}
#end @_is_cache_expire[]



###########################################################################
@_storeQueryStatistics[sType;sQuery;hSqlOptions;hCacheOptions;hQueryStat;uResult][sKey;uValue]
^self._updateStatistics[total;$hQueryStat]
^hQueryInfo.add[
	$.[$hStatistics.total.count][
		$.type[$sType]
		$.query[$sQuery]
		$.sql_options[$hSqlOptions]
		$.sql_options_string[^if($hSqlOptions is "hash"){^hSqlOptions.foreach[sKey;uValue]{^$.$sKey^if($uValue is "int" || $uValue is "double"){^($uValue^)}{^if($uValue is "junction"){^{$uValue^}}{^[$uValue^]}}}[ ]}{$hSqlOptions}]
		$.cache_options[$hCacheOptions]
		$.result[^switch[$sType]{
			^case[table]{^uResult.count[]}
			^case[hash]{^uResult._count[]}
			^case[int;double]{$uResult}
			^case[string]{^if(def $uResult){^uResult.left(40)}}
		}]
		$.result_count[^switch[$sType]{
			^case[table]{^uResult.count[]}
			^case[hash]{^uResult._count[]}
			^case[void]{0}
			^case[DEFAULT]{1}
		}]
		$.statistics[$hQueryStat]
	]
]
^self._updateStatistics[$sType;$hQueryStat]
#end @_storeQueryStatistics[]



###########################################################################
@_updateStatistics[sType;hQueryStat]
^hStatistics.[$sType].count.inc(1)
^if(def $hQueryStat && $hQueryStat is "hash"){
	^hStatistics.[$sType].time.inc($hQueryStat.time)
	^hStatistics.[$sType].utime.inc($hQueryStat.utime)
	^hStatistics.[$sType].memory_kb.inc($hQueryStat.memory_kb)
	^hStatistics.[$sType].memory_block.inc($hQueryStat.memory_block)
}
#end @_updateStatistics[]



###########################################################################
@_printQueryInfo[hInfo;hParam]
$result[TYPE: $hInfo.type^if($hInfo.statistics){
EXECUTION TIME: $hInfo.statistics.time ms
MEMORY USAGE: ^hInfo.statistics.memory_kb.int(0) KB/^hInfo.statistics.memory_block.int(0) blocks}
^switch[$hInfo.type]{
	^case[table;hash]{ROWS SELECTED: $hInfo.result^if($hInfo.result_count >= ^hParam.debug_result_limit.int(3000)){ [debug result limit exceeded]}}
	^case[int;double;string]{RESULT: $hInfo.result}
	^case[void]{RESULT: VOID}
	^case[DEFAULT]{}
}^if(def $hInfo.sql_options_string){^#0ASQL OPTIONS: $hInfo.sql_options_string}
QUERY:
^self._normalizeQuery[$hInfo.query]^if(def $hInfo.query_detail){^#0A$hInfo.query_detail}


]
#end @_printQueryInfo[]



###########################################################################
@_normalizeQuery[sQuery]
$result[$sQuery]
^if(def $result){
	$result[^result.match[\s+][g]{ }]
	$result[^result.match[\s(?=,)][g]{}]
	$result[^result.trim[]]
}
#end @_normalizeQuery[]



###########################################################################
@_getQueriesDetails[hParam][tAnalyzable;i]
^if($iIsDebug && $hStatistics.total.count){
	$hParam[^hash::create[$hParam]]
	$tAnalyzable[^table::create{num}]
	^for[i](1;$hStatistics.total.count){
		^if(
			$hQueryInfo.[$i] is "hash"
			&& (!$hQueryInfo.[$i].is_have_query_detail)
			&&
				(
					$hQueryInfo.[$i].statistics.time >= $hParam.debug_time_limit
					|| $hQueryInfo.[$i].result_count >= ^hParam.debug_result_limit.int(3000)
				)
		){
			^tAnalyzable.append{$i}
		}
	}
	^if($tAnalyzable){
		^self.server{
			^tAnalyzable.menu{
				^hQueryInfo.[$tAnalyzable.num].add[
					$.is_have_query_detail(1)
					$.query_detail[^self._getQueryDetail[$hQueryInfo.[$tAnalyzable.num].type;$hQueryInfo.[$tAnalyzable.num].query;$hQueryInfo.[$tAnalyzable.num].sql_options]]
				]
			}
		}
		^iConnectionsCount.dec(1)
	}
}
#end @_getQueriesDetails[]



###########################################################################
# must return text with details about query $sQuery (explain for mysql)
@_getQueryDetail[sType;sQuery;hSqlOptions]
$result[]
#end @_getQueryDetail[]



###########################################################################
# return options for save/load table
@_getSaveOptions[sType]
^switch[$sType]{
	^case[table]{
		$result[
			$.encloser["]
		]
	}
	^case[DEFAULT]{
		$result[]
	}
}
#end @_getSaveOptions[]



###########################################################################
@_save[sType;sFileName;oValue][tKeys;tTable;sKey;sValue]
$result[]
^switch[$sType]{
	^case[int]{
		^oValue.save[$sFileName]
	}
	^case[double]{
		^oValue.save[$sFileName]
	}
	^case[string]{
		^oValue.save[$sFileName]
	}
	^case[table]{
		^oValue.save[$sFileName;^_getSaveOptions[table]]
	}
	^case[hash]{
		$tKeys[^oValue._keys[]]
		^if($oValue.[$tKeys.key] is "hash"){
			$tTable[^table::create{key^oValue.[$tKeys.key].foreach[sKey;]{^#09$sKey}}]
			^tKeys.menu{^tTable.append{$tKeys.key^oValue.[$tKeys.key].foreach[;sValue]{^#09$sValue}}}
		}{
			$tTable[^table::create{key}]
			^tKeys.menu{^tTable.append{$tKeys.key}}
		}
		^self._save[table;$sFileName;$tTable]
	}
	^case[file]{
	}
}
#end @_save[]



###########################################################################
@_load[sType;sFileName][fFile;tTable;tColumn]
^switch[$sType]{
	^case[int]{
		$fFile[^file::load[text;$sFileName]]
		$result(^fFile.text.int(0))
	}
	^case[double]{
		$fFile[^file::load[text;$sFileName]]
		$result(^fFile.text.double(0))
	}
	^case[string]{
		$fFile[^file::load[text;$sFileName]]
		$result[$fFile.text]
	}
	^case[table]{
		$result[^table::load[$sFileName;^_getSaveOptions[table]]]
	}
	^case[hash]{
		$tTable[^self._load[table;$sFileName]]
		$tColumn[^tTable.columns[]]
		$result[^tTable.hash[$tColumn.column]]
	}
	^case[void]{
		$result[]
	}
	^case[file]{
		$result[]
	}
}
#end @_load[]




###########################################################################
######
# DEPRECATED (for backward compatibility for a while)

# use direct methods like ^oSQL.table{...} instead of ^oSQL.sql[table]{...}
@sql[sType;jQuery;hSqlOptions;hCacheOptions]
^switch[$sType]{
	^case[int]{
		$result[^self.int{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[double]{
		$result[^self.double{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[string]{
		$result[^self.string{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[table]{
		$result[^self.table{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[hash]{
		$result[^self.hash{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[void]{
		$result[^self.void{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[file]{
		$result[^self.file{$jQuery}[$hSqlOptions;$hCacheOptions]]
	}
	^case[DEFAULT]{
		^throw[sql.p;Unknown type '$sType']
	}
}
#end @sql[]



@getStatistics[sFileName]
^printStatistics[$.file[$sFileName]]
#end @getStatistics[]



@print_statistic[hParam]
^printStatistics[$hParam]
#end @print_statistic[]
