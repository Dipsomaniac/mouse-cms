^use[vforms.p]
^mRun[$lparams]



####################################################################################################
# Обработка админки
@mRun[hParams][oForm;jMethod;result]
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
	$result[^jMethod[$oForm]]
}{
	$result[^common[$oForm]]
}
^if(def $oForm.hForm.param.location){^location[$oForm.hForm.param.location;$.is_external(1)]}
# раз уж сюда дошли то удалим весь кэш
^dir_delete[$MAIN:CacheDir;$.is_recursive(1)]
#end @mRun[hParams][jMethod]



####################################################################################################
# стандартное действие
@common[oForm][result]
# 	попытка выполнения действия
	$result[^oForm.go[]]
	$result[$result.done]
#end @common[]



####################################################################################################
# загрузка изображений и файлов
@files[oForm][crdObject;i;result]
# загрузка неполного курда объектов
$crdObject[^curd::init[$.name[object]$.h(1)
	$.names[
		$.[object.object_id][id]
		$.[object.full_path][]
		$.[object.parent_id][]
		$.[object.thread_id][]
]]]
^if($oForm.hRequest.type eq image){
	^use[images.p]
# 	сохранение изображения
	$i[^images:save[
		$.image[$oForm.hRequest.image]
		$.name[$oForm.hRequest.name]
		$.path[$crdObject.hash.[$oForm.hRequest.object_id].full_path]
		$.format[^if($oForm.hRequest.format ne none){$oForm.hRequest.format}]
		$.meta($oForm.hRequest.meta)
	]]
# 	изменение размеров изображения
	^if(def $oForm.hRequest.width || def $oForm.hRequest.height){^images:resize[$.source_name[$i.path/$i.name]$.name[$i.path/$i.name]$.width($oForm.hRequest.width)$.height($oForm.hRequest.height)]}
# 	генерация превью
	^if(def $oForm.hRequest.preview){^images:resize[$.source_name[$i.path/$i.name]$.name[$i.path/${oForm.hRequest.preview}_$i.name]$.width($oForm.hRequest.preview)]}
}{
	^oForm.hRequest.image.save[binary;$crdObject.hash.[$oForm.hRequest.object_id].full_path/$oForm.hRequest.image.name]
}
$result[]
#end @images[]



####################################################################################################
# =debug Работа с объектами, писалась на коленке, место очень слабое
@object[oForm][tWhere;crdObject;hLanguage;result]
# загрузка неполного курда объектов
$crdObject[^curd::init[$.name[object]$.h(1)
	$.names[
		$.[object.object_id][id]
		$.[object.full_path][]
		$.[object.parent_id][]
		$.[object.thread_id][]
]]]
# если получен ID родителя создаем полный путь и заполняем ветвь
^if(^oForm.hRequest.parent_id.int(0)){
	$oForm.hRequest.full_path[^crdObject.hash.[$oForm.hRequest.parent_id].full_path.trim[end;/]]
	$oForm.hRequest.thread_id[$crdObject.hash.[$oForm.hRequest.parent_id].thread_id]
}{
	$oForm.hRequest.thread_id[^crdObject.hash.[$oForm.hForm.param.object_id].id.int(0)]
}
$oForm.hRequest.full_path[$oForm.hRequest.full_path/$oForm.hRequest.path/]
^if($oForm.hRequest.full_path eq '//'){$oForm.hRequest.full_path[/]}
# выполняем физические действия с директориями объектов
^switch[$oForm.hForm.param.action]{
	^case[insert]{
		^createObject[$oForm.hRequest.full_path]}
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
# обработка прав сворачивает несколько checkbox в 1 поле Rights
$oForm[^rights[$oForm]]
# работа с текстом объектов (многоязычность)
# удаление старой информации
$hLanguage[
	$.name[$oForm.hRequest.name]
	$.document_name[$oForm.hRequest.document_name]
	$.window_name[$oForm.hRequest.window_name]
	$.description[$oForm.hRequest.description]
]
^oForm.hRequest.delete[name]
^oForm.hRequest.delete[document_name]
^oForm.hRequest.delete[window_name]
^oForm.hRequest.delete[description]
# выполнение SQL запроса
$result[^oForm.go[$.last_insert_id(1)]]
# выполнение SQL запроса с локальными полями языка
^if($oForm.hForm.param.action eq insert){
	$hLanguage.request[
		INSERT object_text (lang_id, object_id, name, document_name, window_name, description ) VALUES
		('$SYSTEM.lang','$result.last_insert_id','$hLanguage.name','$hLanguage.document_name','$hLanguage.window_name','$hLanguage.description')
	]
}
^if($oForm.hForm.param.action eq update){
	$hLanguage.request[
		UPDATE object_text SET 
			name = '$hLanguage.name', 
			document_name = '$hLanguage.document_name',
			window_name = '$hLanguage.window_name',
			description = '$hLanguage.description'
		WHERE object_id = $oForm.hForm.param.object_id AND lang_id = $SYSTEM.lang
	]
}
^if(def $hLanguage.request){
	^MAIN:objSQL.void{$hLanguage.request}
	^if(def $oForm.hForm.log){^hLanguage.request.save[append;$oForm.hForm.log]}
}
$result[$result.done]
#end @object[oForm][tWhere;crdObject;hLanguage;result]



####################################################################################################
# =debug в лом было думать (обработка прав) место очень слабое
@rights[oForm][result]
^if(def $oForm.hRequest.rights_read){$oForm.hRequest.rights($oForm.hRequest.rights    + ($oForm.hRequest.rights_read))      ^oForm.hRequest.delete[rights_read]}
^if(def $oForm.hRequest.rights_edit){$oForm.hRequest.rights($oForm.hRequest.rights    + ($oForm.hRequest.rights_edit*2))    ^oForm.hRequest.delete[rights_edit]}
^if(def $oForm.hRequest.rights_delete){$oForm.hRequest.rights($oForm.hRequest.rights  + ($oForm.hRequest.rights_delete*4))  ^oForm.hRequest.delete[rights_delete]}
^if(def $oForm.hRequest.rights_comment){$oForm.hRequest.rights($oForm.hRequest.rights + ($oForm.hRequest.rights_comment*8))    ^oForm.hRequest.delete[rights_comment]}
^if(def $oForm.hRequest.rights_supervisory){$oForm.hRequest.rights($oForm.hRequest.rights + ($oForm.hRequest.rights_supervisory*128))   ^oForm.hRequest.delete[rights_supervisory]}
$result[$oForm]
#end @rights[oForm][result]



####################################################################################################
# =debug работа с блоками объекта
# а это опять блоки и это очень криво =debug
@block_to_object[oForm][tFields;iId;sRequest;result]
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
$result[Запрос выполнен.]
#end @block_to_object[]


####################################################################################################
# =debug работа с блоками
@block[oForm][result]
^if(def $oForm.hRequest.data){$oForm.hRequest.is_not_empty(1)}{$oForm.hRequest.is_not_empty(0)}
$result[^common[$oForm]]
#end @block[oForm][result]



####################################################################################################
# =debug работа с пользователями
@auser[oForm][sRequest;result]
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
$oForm[^rights[$oForm]]
$result[^common[$oForm]]
#end @auser[]



####################################################################################################
# =debug работа со статьями
@article[oForm][result]
$oForm.hRequest.is_not_empty(0)
$oForm.hRequest.lang_id($SYSTEM.lang)
# для совместимости с spaw
^if(def $oForm.hRequest.body){
	$oForm.hRequest.body[^oForm.hRequest.body.match[<br>][gi]{<br/>}]
	$oForm.hRequest.is_not_empty(1)
}
$result[^common[$oForm]]
#end @article[]



####################################################################################################
# =debug работа с категориями
@article_type[oForm][result]
# обработка прав
$oForm[^rights[$oForm]]
$result[^common[$oForm]]
#end @article_type[]



####################################################################################################
# Создание объектов
@createObject[sFullPath][result]
$result[@dummy[]
^$result[bla-bla]]
^result.save[${sFullPath}index.html]
$result[]
#end @createObject[sFullPath][sDummy]



####################################################################################################
# Перемещение объектов 
@moveObject[sOldFullPath;sNewFullPath][result]
^if($sOldFullPath ne $sNewFullPath){^file:move[$sOldFullPath;$sNewFullPath]}
$result[]
#end @moveObject[sOldFullPath;sNewFullPath]



####################################################################################################
# Удаление объектов
@deleteObject[sFullPath][result]
^dir_delete[$sFullPath]
$result[]
#end @deleteObject[sFullPath]
