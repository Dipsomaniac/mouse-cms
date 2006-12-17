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
# для совместимости с spaw
^if(def $oForm.hRequest.body){$oForm.hRequest.body[^oForm.hRequest.body.match[<br>][gi]{<br/>}]}
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



@test[]
$sType[$form:cache]
# -----------------------------------------------------------------------------------------------
# =debug в лом было думать (авто заполнение полного пути и получение ветви и поля is_not_empty блока, работа с директориями объектов) место очень слабое
^if(def $sType){
	^switch[$sType]{
#		блоки
		^case[blocks]{
			^if(def $oAjax.hRequest.data){$oAjax.hRequest.is_not_empty(1)}{$oAjax.hRequest.is_not_empty(0)}
		}
	}
}
# установка пароля пользователю
^if(def $oAjax.hRequest.passwd){$oAjax.hRequest.passwd[^MAIN:objAuth.cryptPassword[$oAjax.hRequest.passwd]]}
# обработка тип пользователя(группа)
^if(^oAjax.hRequest.auth_parent_id.int(0)){
	^MAIN:objSQL.void{DELETE FROM auser_to_auser WHERE auser_id="$oAjax.hRequest.auser_id"}
	^MAIN:objSQL.void{INSERT auser_to_auser (auser_id, parent_id) VALUES ('$oAjax.hRequest.auser_id' , '$oAjax.hRequest.auth_parent_id') }
}
	^oAjax.hRequest.delete[auth_parent_id]
# а это опять блоки и это очень криво =debug
$_tTemp[^oAjax.hRequest._keys[]]
^_tTemp.menu{
	^if(^_tTemp.key.pos[mode_] >= 0){
		$_iTemp[^_tTemp.key.mid(5)]
		^if($oAjax.hRequest.block_id_$_iTemp ne '0'){
			^MAIN:objSQL.void{
				INSERT 
					m_block_to_object
					(object_id, block_id, sort_order, mode)
				VALUES
					('$oAjax.hRequest.object_id','$oAjax.hRequest.block_id_$_iTemp','$oAjax.hRequest.sort_order_$_iTemp','$oAjax.hRequest.mode_$_iTemp')
				}
		}
	}
}
#end @main[][_hRequest]



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



####################################################################################################
# Присваивание блоков
@blocks[]
	^oAjax.go[]
#end 