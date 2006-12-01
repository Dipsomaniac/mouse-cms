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
# �������� �� ����
^if($oAuth.is_logon){
# 	�������� �� ����� ��������������
	^if(^oAuth.user.groups.locate[name;Admins]){
		# 		�������� ��������� �������
		$_sTableName[$hRequest.table_name]
		$_sAction[$hRequest.action]
		$_sWhere[$hRequest.where]
		$_sConnectTableName[$hRequest.connect]
# 		������� ���� SQL
		^if(def $hRequest.cache){^oSql.clear[] }
# 		� ������� �� � ������
		^hRequest.delete[where]
		^hRequest.delete[action]
		^hRequest.delete[table_name]
		^hRequest.delete[button]
		^hRequest.delete[connect]
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
# ���������� ������
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
# ���� ���� ��������� �������, ��������� �������� � � ���
$result[������ ��������.]
#end go[]


#################################################################################################
# �� ��� �������? - �������!
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
%u2116	�
%u0430	�
%u0431	�
%u0432	�
%u0433	�
%u0434	�
%u0435	�
%u0451	�
%u0436	�
%u0437	�
%u0438	�
%u0439	�
%u043A	�
%u043B	�
%u043C	�
%u043D	�
%u043E	�
%u043F	�
%u0440	�
%u0441	�
%u0442	�
%u0443	�
%u0444	�
%u0445	�
%u0446	�
%u0447	�
%u0448	�
%u0449	�
%u044A	�
%u044B	�
%u044C	�
%u044D	�
%u044E	�
%u044F	�
%u0410	�
%u0411	�
%u0412	�
%u0413	�
%u0414	�
%u0415	�
%u0401	�
%u0416	�
%u0417	�
%u0418	�
%u0419	�
%u041A	�
%u041B	�
%u041C	�
%u041D	�
%u041E	�
%u041F	�
%u0420	�
%u0421	�
%u0422	�
%u0423	�
%u0424	�
%u0425	�
%u0426	�
%u0427	�
%u0428	�
%u0429	�
%u042A	�
%u042B	�
%u042C	�
%u042D	�
%u042E	�
%u042F	�
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