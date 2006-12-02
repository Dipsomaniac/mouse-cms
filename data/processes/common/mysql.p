############################################################
# $Id: mysql.p,v 1.31 2006/05/16 15:02:46 misha Exp $
############################################################


@CLASS
mysql

@USE
sql.p

@BASE
sql



############################################################
@auto[]
$server_name[mysql]
#end @auto[]



############################################################
@init[sConnectString;hParam]
^BASE:init[$sConnectString;$hParam]
#end @init[]



# DATE functions

############################################################
@today[]
$result[CURDATE()]
#end @today[]



############################################################
@now[]
$result[NOW()]
#end @now[]



############################################################
@year[sSource]
$result[YEAR($sSource)]
#end @year[]



############################################################
@month[sSource]
$result[MONTH($sSource)]
#end @month[]



############################################################
@day[sSource]
$result[DATE_FORMAT($sSource,'%d')]
#end @day[]



############################################################
@ymd[sSource]
$result[DATE_FORMAT($sSource,'%Y-%m-%d')]
#end @ymd[]



############################################################
@time[sSource]
$result[DATE_FORMAT($sSource,'%H:%i:%S')]
#end @time[]



############################################################
@date_diff[t;sDateFrom;sDateTo]
$result[^if(def $sDateTo){TO_DAYS($sDateTo)}{^self.now[]} - TO_DAYS($sDateFrom)]
#end @date_diff[]



############################################################
@date_sub[sDate;iDays]
$result[DATE_SUB(^if(def $sDate){$sDate}{^self.today[]},INTERVAL $iDays DAY)]
#end @date_sub[]



############################################################
@date_add[sDate;iDays]
$result[DATE_ADD(^if(def $sDate){$sDate}{^self.today[]},INTERVAL $iDays DAY)]
#end @date_add[]



# functions available not for all sql servers
############################################################
# MSSQL havn't anything like this
@date_format[sSource;sFormatString]
$result[DATE_FORMAT($sSource, '^if(def $sFormatString){$sFormatString}{%Y-%m-%d}')]
#end @date_format[]



# LAST_INSERT_ID()

############################################################
@last_insert_id[sTable]
^self._execute{
	$result(^int:sql{SELECT DISTINCT last_insert_id() FROM $sTable}[$.default{0}])
}
#end @last_insert_id[]



############################################################
@set_last_insert_id[sTable;sField]
^self._execute{
	$result(^self.last_insert_id[$sTable])
	^void:sql{UPDATE $sTable SET ^if(def $sField){$sField}{sort_order} = $result WHERE ${sTable}_id = $result}
}
#end @set_last_insert_id[]



# STRING functions

############################################################
@substring[sSource;iPos;iLength]
$result[SUBSTRING($sSource,^if(def $iPos){$iPos}{1},^if(def $iLength){$iLength}{1})]
#end @substring[]



############################################################
@upper[sField]
$result[UPPER($sField)]
#end @upper[]



############################################################
@lower[sField]
$result[LOWER($sField)]
#end @lower[]



############################################################
@concat[sSource]
$result[CONCAT($sSource)]
#end @concat[]



# MISC functions

############################################################
@password[sPassword]
$result[PASSWORD($sPassword)]
#end @password[]



############################################################
@left_join[sType;sTable;sJoinConditions;last]
^switch[^sType.lower[]]{
	^case[from]{
		$result[LEFT JOIN $sTable ON ($sJoinConditions)]
	}
	^case[where]{
		$result[1 = 1 ^if(!def $last){ AND}]
	}
	^case[DEFAULT]{
		^throw[mysql.p;Unknown join type '$sType']
	}
}
#end @left_join[]



############################################################
# override for get explain information
@_getQueryDetail[sType;sQuery;hSqlOptions][tExplain;tColumn]
$result[]
^if(def $sQuery && $sType ne "void"){
	^try{
		$tExplain[^table::sql{EXPLAIN $sQuery}[^if($hSqlOptions is "hash"){
			^if($hSqlOptions.offset){
				$.offset($hSqlOptions.offset)
			}
			^if($hSqlOptions.limit){
				$.limit($hSqlOptions.limit)
			}
		}]]
		$tColumn[^tExplain.columns[]]
		$result[EXPLAIN:^#0A^tColumn.menu{$tColumn.column}[^#09]^#0A^tExplain.menu{^tColumn.menu{$tExplain.[$tColumn.column]}[^#09]}[^#0A]]
	}{
		$exception.handled(1)
	}
}
#end @_getQueryDetail[]


