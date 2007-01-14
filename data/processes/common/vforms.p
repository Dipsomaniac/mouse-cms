@CLASS
vforms



####################################################################################################
@auto[]
$hHandlers[
    $.insert[$insert]
    $.update[$update]
    $.delete[$delete]
]
$tDecode[^self._getDecodeTable[]]
$hRequest[^form:fields.foreach[field;value]{$.[^self._decode[$field]][^self._decode[$value]]}]
# проверка ключа секретности
^if(^math:md5[${hRequest.form_engine}$MAIN:oEngine.SYSTEM.key] ne $hRequest.form_security){^throw[vforms;Security failure.]}
#end @auto[]



####################################################################################################
@init[hParams]
^if(!def $hParams.oAuth){^throw[vforms;Initialization failure. ^$.oAuth option MUST be specified.]}
^if(!def $hParams.oSql){^throw[vforms;Initialization failure. ^$.oSql option MUST be specified.]}
^if(!def $hParams.rights){^throw[vforms;Initialization failure. ^$.rights option MUST be specified.]}
$hForm[^hash::create[$hParams]]
# выполнен ли вход
^if(^hForm.rights.logon.int(0) && !$hForm.oAuth.is_logon){^throw[ajax;Action failure. User must be logon.]}
^if(def $hForm.rights.group && !^hForm.oAuth.user.groups.locate[name;$hForm.rights.group]){^throw[ajax;Action failure. User group must be in ${hForm.rights.group}.]}
# получаем параметры запроса
$hForm.param[^getStrToHash[$hRequest.form_engine]]
# очистка кэша SQL
^hForm.oSql.clear[]
# удаляем поле параметров
^hRequest.delete[form_engine]
^hRequest.delete[form_security]
# удаляем кнопалки
^hRequest.delete[submit]
#end @init[hParams][hForm]



####################################################################################################
# проверка заполнения полей формы
@rules[hParams][result]
$result[ok]
^try{
^hParams.foreach[key;value]{
	^switch[$value]{
		^case[text]{^if(!def $hRequest.$key){$result[Error: $key is be text]}}
		^case[number]{^try{^hRequest.$key.int[]}{$exception.handled(1)$result[Error: $key is be number]}}
		^case[DEFAULT]{^if(!def $hRequest.$key){$result[Error: $key is be defined]}}
	}
}}{$exception.handled(1)}
#end @rules[hParams]



####################################################################################################
@go[hParams][sRequest;tWhere;result]
^if(^rules[$hForm.param.rules] ne ok){$result[$.done[^rules[$hForm.param.rules]]]}{
# составляем запрос
$sRequest[
^taint[# -----------------------------------------------------------------------------------------------]
^taint[# ^MAIN:dtNow.sql-string[] ]
]
^mSaveLog[$sRequest]
^if(^hRequest.[$hForm.param.where].pos[,] > 0){
	$tWhere[^hRequest.[$hForm.param.where].split[,]]
	^tWhere.menu{	
		$hForm.param.[$hForm.param.where][$tWhere.piece]
		^hForm.param.tables.foreach[key;table]{
			$sRequest[^hHandlers.[$hForm.param.action][$table;$hForm.param]]
			^mSaveLog[$sRequest]
			^hForm.oSql.void{$sRequest}
		}
	}
}{
	^hForm.param.tables.foreach[key;table]{
		$sRequest[^hHandlers.[$hForm.param.action][$table;$hForm.param]]
		^mSaveLog[$sRequest]
		^hForm.oSql.void{$sRequest}
	}
}
$result[
	^if($hParams.last_insert_id){$.last_insert_id(^hForm.oSql.last_insert_id[$hForm.param.tables.main])}
	$.done[Запрос выполнен.]]
}
#end go[]



####################################################################################################
# логирование запросов
@mSaveLog[sStr][result]
^if(def $hForm.log){^sStr.save[append;$hForm.log]}
$result[]
#end @mSaveLog[sStr]



####################################################################################################
# добавление данных
@insert[sTableName;hParam][sNames;sValues;result]
$sNames[^hRequest.foreach[field;value]{$field}[,]]
$sValues[^hRequest.foreach[field;value]{^if(def $value){'$value'}{NULL}}[,]]
$result[
	INSERT
		$sTableName
		($sNames)
	VALUES
		($sValues)
]
#end @insert[sTableName;hParam][sNames;sValues]



####################################################################################################
# редактирование данных
@update[sTableName;hParam][result]
$result[
	UPDATE
		$sTableName
	SET
		^hRequest.foreach[field;value]{$field="$value"}[,]
	WHERE
		$hParam.where="$hParam.[$hParam.where]"
]
#end @update[sTableName;hParam]



####################################################################################################
# удаление данных
@delete[sTableName;hParam][result]
$result[
	DELETE FROM
		$sTableName
	WHERE
		$hParam.where="$hParam.[$hParam.where]"
]
#end @delete[sTableName;hParam]



#################################################################################################
# декодирование UTF-8
@_decode[sText][result]
^if($sText is string){$result[^taint[^sText.replace[$tDecode]]]}{$result[$sText]}
#end @_decode[sText]



#################################################################################################
# таблица преобразований UTF-8
@_getDecodeTable[][result]
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