^use[vforms.p]
^mRun[$lparams]



####################################################################################################
# Обработка админки
@mRun[hParams][jMethod]
# инициализируем объект forms
$oForm[^vforms::init[
	$.oAuth[$MAIN:objAuth]
	$.oSql[$MAIN:objSQL]
	$.rights[
		$.logon(1)
		$.group[Admins]]
	$.log[/../data/log/admin.log]
]]

# проверка и обработка формы
^if(def $oForm.hForm.param.process){
	$jMethod[$[$oForm.hForm.param.process]]
	^jMethod[]
}
# раз уж сюда дошли то удалим весь кэш
^dir_delete[^MAIN:CacheDir.trim[end;/];$.is_recursive(1)]
# это баг, откуда он взялся? =debug
^oForm.hRequest.delete[uri]
# попытка выполнения действия
^oForm.go[]
#end @mRun[hParams][jMethod]



####################################################################################################
# =debug Работа с объектами, писалась на коленке, место очень слабое
@object[][tWhere;crdObject]
$crdObject[^curd::init[$.name[object]$.h(1)
	$.names[
		$.[object.object_id][id]
		$.[object.full_path][]
		$.[object.parent_id][]
		$.[object.thread_id][]
]]]
^if(^oForm.hRequest.parent_id.int(0)){
	$oForm.hRequest.full_path[^crdObject.hash.[$oForm.hRequest.parent_id].full_path.trim[end;/]]
	$oForm.hRequest.thread_id[$crdObject.hash.[$oForm.hRequest.parent_id].thread_id]
}{
	$oForm.hRequest.thread_id[^crdObject.hash.[$oForm.hForm.param.object_id].id.int(0)]
}
$oForm.hRequest.full_path[$oForm.hRequest.full_path/$oForm.hRequest.path/]
^if($oForm.hRequest.full_path eq '//'){$oForm.hRequest.full_path[/]}
^switch[$oForm.hForm.param.action]{
	^case[insert]{^createObject[$oForm.hRequest.full_path]}
	^case[delete]{
		^if(^oForm.hRequest.object_id.pos[,] > 0){
			$tWhere[^oForm.hRequest.object_id.split[,]]
			^tWhere.menu{^deleteObject[$crdObject.hash.[$tWhere.piece].full_path]}
		}
	}
	^case[update]{
		^moveObject[^crdObject.hash.[$oForm.hForm.param.object_id].full_path.trim[end;/];^oForm.hRequest.full_path.trim[end;/]]
	}
}
# обработка прав
^rights[]
#end @object[][tWhere]



####################################################################################################
# =debug в лом было думать (обработка прав) место очень слабое
@rights[]
^if(def $oForm.hRequest.rights_read){$oForm.hRequest.rights($oForm.hRequest.rights    + ($oForm.hRequest.rights_read))      ^oForm.hRequest.delete[rights_read]}
^if(def $oForm.hRequest.rights_edit){$oForm.hRequest.rights($oForm.hRequest.rights    + ($oForm.hRequest.rights_edit*2))    ^oForm.hRequest.delete[rights_edit]}
^if(def $oForm.hRequest.rights_delete){$oForm.hRequest.rights($oForm.hRequest.rights  + ($oForm.hRequest.rights_delete*4))  ^oForm.hRequest.delete[rights_delete]}
^if(def $oForm.hRequest.rights_comment){$oForm.hRequest.rights($oForm.hRequest.rights + ($oForm.hRequest.rights_comment*8))    ^oForm.hRequest.delete[rights_comment]}
^if(def $oForm.hRequest.rights_supervisory){$oForm.hRequest.rights($oForm.hRequest.rights + ($oForm.hRequest.rights_supervisory*128))   ^oForm.hRequest.delete[rights_supervisory]}
#end @rights[]



####################################################################################################
# =debug работа с блоками объекта
# а это опять блоки и это очень криво =debug
@block_to_object[][tFields;iId;sRequest]
$sRequest[
	DELETE FROM
		$oForm.hForm.param.tables.main
	WHERE
		object_id = $oForm.hForm.param.object_id
]
^MAIN:objSQL.void{$sRequest}
^if(def $oForm.hForm.log){^sRequest.save[append;$oForm.hForm.log]}
$tFields[^oForm.hRequest._keys[]]
^tFields.menu{
	^if(^tFields.key.pos[mode_] >= 0){
#		^stop[^oForm.hRequest.foreach[sKey;sValue]{$sKey = $sValue}]
		$iId[^tFields.key.mid(5)]
		^if($oForm.hRequest.block_id_$iId ne '0'){
			$sRequest[
				INSERT 
					$oForm.hForm.param.tables.main
					(object_id, block_id, sort_order, mode)
				VALUES
					('$oForm.hForm.param.object_id','$oForm.hRequest.block_id_$iId','$oForm.hRequest.sort_order_$iId','$oForm.hRequest.mode_$iId')
			]
			^if(def $oForm.hForm.log){^sRequest.save[append;$oForm.hForm.log]}
			^MAIN:objSQL.void{$sRequest}
		}
	}
}
$oForm.hForm.param.object_id[]
#end @block_to_object[]


####################################################################################################
# =debug работа с блоками
@block[]
^if(def $oForm.hRequest.data){$oForm.hRequest.is_not_empty(1)}{$oForm.hRequest.is_not_empty(0)}
#end @block[]



####################################################################################################
# =debug работа с пользователями
@auser[][sRequest]
^if(def $oForm.hRequest.passwd){$oForm.hRequest.passwd[^MAIN:objAuth.cryptPassword[$oForm.hRequest.passwd]]}
^if(^oForm.hRequest.auth_parent_id.int(0)){
	$sRequest[DELETE FROM auser_to_auser WHERE auser_id="$oForm.hRequest.auser_id"]
	^if(def $oForm.hForm.log){^sRequest.save[append;$oForm.hForm.log]}
	^MAIN:objSQL.void{$sRequest}
	$sRequest[INSERT auser_to_auser (auser_id, parent_id) VALUES ('$oForm.hRequest.auser_id' , '$oForm.hRequest.auth_parent_id')]
	^if(def $oForm.hForm.log){^sRequest.save[append;$oForm.hForm.log]}
	^MAIN:objSQL.void{$sRequest}
}
^oForm.hRequest.delete[auth_parent_id]
# обработка прав
^rights[]
#end @auser[]



####################################################################################################
# =debug работа со статьями
@article[]
$oForm.hRequest.is_not_empty(0)
# для совместимости с spaw
^if(def $oForm.hRequest.body){
	$oForm.hRequest.body[^oForm.hRequest.body.match[<br>][gi]{<br/>}]
	$oForm.hRequest.is_not_empty(1)
}
#end @article[]



####################################################################################################
# =debug работа с категориями
@article_type[]
# обработка прав
^rights[]
#end @article_type[]



####################################################################################################
# Создание объектов
@createObject[sFullPath][sDummy]
$sDummy[@dummy[]
^$result[bla-bla]]
^sDummy.save[${sFullPath}index.html]
#end @createObject[sFullPath][sDummy]



####################################################################################################
# Перемещение объектов 
@moveObject[sOldFullPath;sNewFullPath]
^if($sOldFullPath ne $sNewFullPath){^file:move[$sOldFullPath;$sNewFullPath]}
#end @moveObject[sOldFullPath;sNewFullPath]



####################################################################################################
# Удаление объектов
@deleteObject[sFullPath]
^dir_delete[$sFullPath]
#end @deleteObject[sFullPath]
