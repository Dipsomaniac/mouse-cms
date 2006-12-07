@CLASS
ajax

#################################################################################################
@auto[]
$hHandlers[
    $.insert[$insert]
    $.update[$update]
    $.delete[$delete]
]
$tDecode[^self._getDecodeTable[]]
$hRequest[^form:fields.foreach[field;value]{$.[^self._decode[$field]][^self._decode[$value]]}]
#end @auto[]

#################################################################################################
@init[hParams][_hParams]
$_hParams[^hash::create[$hParams]]
^if(def $_hParams.oAuth){$oAuth[$_hParams.oAuth]}{^throw[ajax;Initialization failure. ^$.oAuth option MUST be specified.]}
^if(def $_hParams.oSql){$oSql[$_hParams.oSql]}{^throw[ajax;Initialization failure. ^$.oSql option MUST be specified.]}
# выполнен ли вход
^if($oAuth.is_logon){
# 	проверка на права администратора
	^if(^oAuth.user.groups.locate[name;Admins]){
		# 		получаем параметры запроса
		$_sAction[$hRequest.action]
		$_sWhere[$hRequest.where]
# 		очистка кэша SQL
		^if(def $hRequest.cache){^oSql.clear[] }
# 		и удаляем их и лишнее
		^hRequest.delete[where]
		^hRequest.delete[action]
		^hRequest.delete[cache]
	}{
	^throw[ajax;Action failure. User must be in Admins.]
	}
}{
^throw[ajax;Action failure. User must be logon.]
}
#end @init[hParams][_hParams]

#################################################################################################
@go[][_sRequest][_hTables;_tWhere]
$_hTables[^getStrToHash[$hRequest.tables]]
^hRequest.delete[tables]
# составляем запрос
$_sRequest[
^taint[# -----------------------------------------------------------------------------------------------]
^taint[# ^MAIN:dtNow.sql-string[]]
]
^_sRequest.save[append;/../data/log/admin.log]
^if(^hRequest.[$_sWhere].pos[,] > 0){
	$_tWhere[^hRequest.[$_sWhere].split[,]]
	^_tWhere.menu{	
		$hRequest.[$_sWhere][$_tWhere.piece]
		^_hTables.foreach[key;table]{
			$_sRequest[^hHandlers.$_sAction[$hRequest;$table;$_sWhere]]
			^_sRequest.save[append;/../data/log/admin.log]
			^oSql.void{$_sRequest}
		}
	}
}{
		^_hTables.foreach[key;table]{
			$_sRequest[^hHandlers.$_sAction[$hRequest;$table;$_sWhere]]
			^_sRequest.save[append;/../data/log/admin.log]
			^oSql.void{$_sRequest}
		}
}
# если есть зависимая таблица, выполняем действие и в ней
$result[Запрос выполнен.]
#end go[]


#################################################################################################
# ну что вставим? - вставим!
@insert[hRequest;sTableName;sWhere][_hRequest;names;values]
$_hRequest[^hash::create[$hRequest]]
$names[^_hRequest.foreach[field;value]{$field}[,]]
$values[^_hRequest.foreach[field;value]{'$value'}[,]]
$result[
	INSERT
		$sTableName
		($names)
	VALUES
		($values)
]
#end @insert[hRequest]

#################################################################################################
@update[hRequest;sTableName;sWhere][_hRequest]
$_hRequest[^hash::create[$hRequest]]
$result[
	UPDATE
		$sTableName
	SET
		^_hRequest.foreach[field;value]{$field="$value"}[,]
	WHERE
		$sWhere="$hRequest.[$sWhere]"
]
#end @update[hRequest]

#################################################################################################
@delete[hRequest;sTableName;sWhere][_hRequest;_jCode;_iWhere;_tWhere]
$_hRequest[^hash::create[$hRequest]]
$result[
	DELETE FROM
		$sTableName
	WHERE
		$sWhere="$hRequest.[$sWhere]"
]
#end @delete[hRequest]

#################################################################################################
@_decode[sText]
$result[^taint[^sText.replace[$tDecode]]]
#end @_decode[]

#################################################################################################
@_getDecodeTable[]
$result[^table::create{from	to
%u2116	№
%u0430	а
%u0431	б
%u0432	в
%u0433	г
%u0434	д
%u0435	е
%u0451	ё
%u0436	ж
%u0437	з
%u0438	и
%u0439	й
%u043A	к
%u043B	л
%u043C	м
%u043D	н
%u043E	о
%u043F	п
%u0440	р
%u0441	с
%u0442	т
%u0443	у
%u0444	ф
%u0445	х
%u0446	ц
%u0447	ч
%u0448	ш
%u0449	щ
%u044A	ъ
%u044B	ы
%u044C	ь
%u044D	э
%u044E	ю
%u044F	я
%u0410	А
%u0411	Б
%u0412	В
%u0413	Г
%u0414	Д
%u0415	Е
%u0401	Ё
%u0416	Ж
%u0417	З
%u0418	И
%u0419	Й
%u041A	К
%u041B	Л
%u041C	М
%u041D	Н
%u041E	О
%u041F	П
%u0420	Р
%u0421	С
%u0422	Т
%u0423	У
%u0424	Ф
%u0425	Х
%u0426	Ц
%u0427	Ч
%u0428	Ш
%u0429	Щ
%u042A	Ъ
%u042B	Ы
%u042C	Ь
%u042D	Э
%u042E	Ю
%u042F	Я
%20	^#20
%21	!
%22	"
%23	#
%24	^$
%25	%
%26	&
%27	'
%28	(
%29	)
%2B	+
%2C	,
%3A	:
%3B	^;
%3C	<
%3D	=
%3E	>
%3F	?
%5B	^[
%5C	\
%5D	^]
%5E	^^
%60	`
%7B	^{
%7C	|
%7D	^}
%7E	~
%0D%0A	^taint[^#0A]
%0D	^taint[^#0A]
%0A	^taint[^#0A]
%09	^taint[^#09]
}]
#end @_getDecodeTable[]