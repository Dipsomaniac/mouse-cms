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
# попытка выполнения действия
^oForm.go[]
#end @mRun[hParams][jMethod]



####################################################################################################
# =debug Работа с объектами, писалась на коленке, место очень слабое
@object[][tWhere]
$oForm.hRequest.full_path[^MAIN:oEngine.getFullPath[$oForm.hRequest.parent_id;$oForm.hRequest.path]]
$oForm.hRequest.thread_id[^MAIN:oEngine.getThreadId[$oForm.hRequest.parent_id;$oForm.hRequest.id]]
^switch[$oForm.hForm.param.action]{
	^case[insert]{^createObject[$oForm.hRequest.full_path]}
	^case[delete]{
		^if(^oForm.hRequest.object_id.pos[,] > 0){
			$tWhere[^oForm.hRequest.object_id.split[,]]
			^tWhere.menu{
				^deleteObject[$MAIN:oEngine.OBJECTS_HASH.[$tWhere.piece].full_path]
			}
		}
	}
	^case[update]{
		^moveObject[^MAIN:oEngine.OBJECTS_HASH.[$oForm.hRequest.object_id].full_path.trim[end;/];^oForm.hRequest.full_path.trim[end;/]]
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

# для совместимости с spaw
^if(def $oAjax.hRequest.body){$oAjax.hRequest.body[^oAjax.hRequest.body.match[<br>][gi]{<br/>}]}
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

# попытка выполнения действия
^oAjax.go[]

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