^mRun[$lparams]



#################################################################################################
# Админка
@mRun[hParams][jMethod]
<block_content>
$hParams.body
<buttons>
	<button image="24_sites.gif"      name="sites"     alt="Сайты"							onClick="Go('$SYSTEM.path?type=site','#container')" />
	<button image="24_objects.gif"    name="objects"   alt="Объекты"						onClick="Go('$SYSTEM.path?type=object','#container')" />
	<button image="24_blocks.gif"     name="blocks"    alt="Блоки"							onClick="Go('$SYSTEM.path?type=block','#container')" />
	<button image="24_process.gif"    name="process"   alt="Обработчики"					onClick="Go('$SYSTEM.path?type=process','#container')" />
	<button image="24_templates.gif"  name="templates" alt="Шаблоны"						onClick="Go('$SYSTEM.path?type=template','#container')" />
	<button image="24_users.gif"      name="users"     alt="Gользователи и группы"	onClick="Go('$SYSTEM.path?type=users','#container')" />
	<button image="24_rights.gif"     name="rigths"    alt="Назначение прав"			onClick="Go('$SYSTEM.path?type=rights','#container')" />
	<button image="24_configure.gif"  name="configure" alt="Обслуживание системы"		onClick="Go('$SYSTEM.path?type=config','#container')" />
	<button image="24_files.gif"      name="files"     alt="Загрузка файлов"			onClick="Go('$SYSTEM.path?type=files','#container')" />
	<button image="24_articles.gif"   name="articles"  alt="Работа со статьями"		onClick="Go('$SYSTEM.path?type=article','#container')" />
	<button image="24_category.gif"   name="categoey"  alt="Работа с категориями"		onClick="Go('$SYSTEM.path?type=category','#container')" />
	<button image="24_divider.gif" />
	^if(def $form:action && $form:action ne 'config'){
		<button image="24_save.gif"    name="save"      alt="Сохранить" onClick="saveForms('form_content','$SYSTEM.path?type=$form:type','#container')" />
		<button image="24_retype.gif"  name="retype"    alt="Сбросить"  onClick="resetForm()" />
		<button image="24_cancel.gif"  name="cancel"    alt="Отменить"  onClick="Cancel('$SYSTEM.path?type=$form:type')" />
	}
	^if(def $form:type && !def $form:action){
		<button image="24_add.gif"    name="add"    alt="Добавить"   onClick="Go('$SYSTEM.path?type=$form:type&amp^;action=add','#container')" />
		<button image="24_copy.gif"   name="copy"   alt="Копировать" onClick="CopyChecked('$SYSTEM.path?type=$form:type&amp^;action=copy')" />
		<button image="24_delete.gif" name="delete" alt="Удалить"    onClick="DeleteChecked('${form:type}_id','$SYSTEM.path?type=$form:type','#container')" />
	}
</buttons>
^switch[$form:type]{
	^case[article]{^executeSystemProcess[$.id[5] $.param[article]]}
	^case[category]{^executeSystemProcess[$.id[5] $.param[category]]}
	^case[DEFAULT]{
		$jMethod[$[$form:type]]
		^jMethod[]
	}
}
</block_content>
#end @mRun[hParams][jMethod]



#################################################################################################
# Управление сайтами
@site[][crdSite;hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
# вывод формы редактирования
$crdSite[^mLoader[$.name[site]$.h(1)]]
$crdObject[^mLoader[$.name[object]]]
$hAction[^mGetAction[$form:action]]
<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data" 
	label="MOUSE CMS | Сайты | $hAction.label | $crdSite.hash.[$form:id].name ">
<tabs>
	<tab id="section-1" name="Основное">
		<field type="text"   name="name"           label="Название"   description="Имя сайта"              class="long">$crdSite.hash.[$form:id].name</field>
		<field type="text"   name="domain"         label="Домен"      description="Доменное имя"           class="medium">$crdSite.hash.[$form:id].domain</field>
		<field type="select" name="lang_id"        label="Язык"       description="Язык сайта"             class="short"><option value="1">Русский</option></field>
	^if($hAction.i & 1){
		<field type="select" name="e404_object_id" label="Ошибки"     description="Страница ошибок"        class="medium">
			^crdObject.list[$.added[select="$crdSite.hash.[$form:id].e404_object_id"]]
		</field>
	}
		<field type="text"   name="cache_time"     label="Кэш"        description="Время кэширования (сек)" class="short">$crdSite.hash.[$form:id].cache_time</field>
		<field type="text"   name="sort_order"     label="Сортировка" description="Порядок сортировки"      class="short">$crdSite.hash.[$form:id].sort_order</field>
		
^form_engine[
	^$.where[site_id]
	^$.site_id[$form:id]
	^$.tables[^$.main[site]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
	]
	</tab>
</tabs>
</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод списка сайтов
$crdSite[^mLoader[$.name[site]]]
$crdObject[^mLoader[$.name[object]$.h(1)]]
<atable label="Mouse CMS | Сайты">
	^crdSite.draw[
		$.code[Язык: ^$hFields.lang_id <br />Сортировка: ^$hFields.sort_order]
		$.names[^table::create{name	id	object
ID	id
Название	name
Домен	domain
Время кэша	cache_time
Страница Ошибок	e404_object_id	crdObject.hash
}]]
	^added[]
^form_engine[
	^$.where[site_id]
	^$.action[delete]
	^$.tables[^$.main[site]]
]
</atable>
}
#end @sites[][hAction]



#################################################################################################
# Управление объектами
@object[][hAction;iCount;hRights;crdAuser;crdObjectType]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
# 	Работа с блоками объекта
	^if($form:action eq 'block_to_object'){
		$crdObject[^mLoader[$.name[object]]]
		$crdBlock[^mLoader[$.name[block]$.t(1)]]
		$crdBlockToObject[^mLoader[$.name[block_to_object]$.t(1)]]
		<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
		label="MOUSE CMS | Объект | Управление блоками | $crdObject.hash.[$form:id].name ">
		<tabs>
		<tab id="section-1" name="Блоки объекта $crdObject.hash.[$form:id].name">
			^crdBlockToObject.table.append{9	none	1	0} 
			<field type="none" label="$crdObject.hash.[$form:id].name" description="Блоки объекта">
				<br/><br/><br/>
				Mode: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Sort_order: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Name:<br/>
#				объекту можно присвоить до 10 блоков =debug
				^for[iCount](0;9){
					^if(^crdBlockToObject.table.count[] > $iCount){^crdBlockToObject.table.offset[set]($iCount)}
					<input  name="mode_$iCount" value="$crdBlockToObject.table.mode" class="input-text-short"/>
					<input  name="sort_order_$iCount" value="$crdBlockToObject.table.sort_order" class="input-text-short"/>
					<select name="block_id_$iCount" class="long">
						<option value="0">none</option>
						^crdBlock.list[$.added[select="$crdBlockToObject.table.id"]]
					</select>
					<br/>
				}
			</field>
			<field type="none" />
^form_engine[
	^$.where[object_id]
	^$.object_id[$form:id]
	^$.tables[^$.main[block_to_object]]
	^$.action[delete]
]
		</tab>
		</tabs>
		</form>
	}{
# -----------------------------------------------------------------------------------------------
#		вывод формы редактирования
		$hAction[^mGetAction[$form:action]]
#		загрузка данных
		$crdSite[^mLoader[$.name[site]$.t(1)]]
		$crdObject[^mLoader[$.name[object]]]
		$crdTemplate[^mLoader[$.name[template]$.t(1)]]
		$crdObjectType[^mLoader[$.name[object_type]$.t(1)]]
		$crdDataProcess[^mLoader[$.name[data_process]$.t(1)]]
		$crdAuser[^mLoader[$.name[auser]$.h(1)]]
		^if($hAction.i & 1){
			$hAction.path[$crdObject.hash.[$form:id].path]
			$hAction.is_published[$crdObject.hash.[$form:id].is_published]
			$hAction.description[$crdObject.hash.[$form:id].description]
		}
		^if($hAction.i & 3){
			$hAction.name[$crdObject.hash.[$form:id].name]
			$hAction.document_name[$crdObject.hash.[$form:id].document_name]
			$hAction.window_name[$crdObject.hash.[$form:id].window_name]
			$hAction.parent_id[$crdObject.hash.[$form:id].parent_id]
		}
		^if($hAction.i & 4){$hAction.parent_id[$form:id]}
		<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
		label="MOUSE CMS | Объекты | $hAction.label | $crdObject.hash.[$form:id].name | $request:uri">
		<tabs>
		<tab id="section-1" name="Основное">
			^if($hAction.i & 1){<field type="none" name="object_id" label="ID" description="ID объекта">$crdObject.hash.[$form:id].id</field>}
			<field type="text" name="name" label="Имя" description=" Имя объекта " class="medium">$hAction.name</field>
			<field type="text" name="document_name" label="Название" description=" Имя документа " class="long"  >$hAction.document_name</field>
			<field type="text" name="window_name" label="Окно" description=" Оконное имя: " class="long">$hAction.window_name</field>
			<field type="text" name="path" label="Путь" description="Имя файла/каталога (example, example.html)" class="medium">$hAction.path</field>
			<field type="text" name="cache_time" label="Кэш" description="Время кэширования (сек)" class="short">$crdObject.hash.[$form:id].cache_time</field>
			<field type="text" name="sort_order" label="Порядок" description="Порядок сортировки" class="short">$crdObject.hash.[$form:id].sort_order</field>
			<field type="checkbox" name="is_published"  label="Опубликовать" description="">$hAction.is_published</field>
			<field type="select" name="parent_id" label="Предок" description="Родительский объект" class="medium">
				<option id="0" value="0" select="$parent_id">Корневое пространство</option>
				^crdObject.list[$.added[select="$hAction.parent_id"]]
			</field>
			<field type="select" name="template_id" label="Шаблон" description="Шаблон дизайна объекта" class="medium">
				<option id="0" value="0" select="$crdObject.hash.[$form:id].template_id">Не задан</option>
				^crdTemplate.list[$.added[select="$crdObject.hash.[$form:id].template_id"]]
			</field>
			<field type="textarea" name="description" label="Описание" description="Описание объекта">$hAction.description</field>
		</tab>
		<tab id="section-2" name="Дополнительное">
			^if($hAction.i & 1){
				<field type="none" name="full_path" label="Полный путь" description="От корня сайта">$crdObject.hash.[$form:id].full_path</field>
			}
			<field name="thread_id" label="Ветвь объекта" description="" type="none">$crdObject.hash.[$crdObject.hash.[$form:id].thread_id].name</field>
			<field type="checkbox" name="is_show_on_sitemap" label="Карта" description="Показывать на карте сайта">$crdObject.hash.[$form:id].is_show_on_sitemap	</field>
			<field type="checkbox" name="is_show_in_menu" label="Меню" description="Показывать в меню">$crdObject.hash.[$form:id].is_show_in_menu</field>
			<field type="text" name="url" label="URL" description="Объект ссылка" class="long">$crdObject.hash.[$form:id].url</field>
			<field type="select" name="site_id" description="Сайт объекта" label="Сайт" class="medium">
				^crdSite.list[$.added[select="$crdObject.hash.[$form:id].site_id"]]
			</field>
			<field type="select" name="object_type_id" description="Тип объекта" label="Тип" class="long">
				^crdObjectType.list[$.added[select="$crdObject.hash.[$form:id].object_type_id"]]
			</field>
			<field type="select" name="data_process_id" description="Обработчик объекта" label="Обработчик" class="medium">
				<option id="0" value="0" select="$crdObject.hash.[$form:id].data_process_id">отсутствует</option>
				^crdDataProcess.list[$.added[select="$crdObject.hash.[$form:id].data_process_id"]]
			</field>
			<field type="select" name="link_to_object_id" description="Подменить содержимое, содержимым выбранного объекта" label="Ссылка"  class="medium">
				<option id="0" value="0" select="$crdObject.hash.[$form:id].link_to_object_id">не подменять</option>
				^crdObject.list[$.added[select="$crdObject.hash.[$form:id].link_to_object_id"]]
			</field>
		</tab>
		<tab id="section-3" name="Атрибуты">
			^if($hAction.i & 1){
				<field name="dt_update" label="Изменен" description="Дата последнего редактирования" type="none">$crdObject.hash.[$form:id].dt_update</field>
				<field name="auser_id" label="Владелец" description="Логин редактировавшего" type="none">$crdAuser.hash.[$crdObject.hash.[$form:id].auser_id].name</field>
			}
			$hRights[^getHashRights($crdObject.hash.[$form:id].rights)]
			<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
			<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
			<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
			<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="auser_id">$MAIN:objAuth.user.id</field>
^form_engine[
	^$.process[object]
	^$.where[object_id]
	^$.object_id[$form:id]
	^$.tables[^$.main[object]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
		</tab>
		</tabs>
		</form>
	}
}{
# -----------------------------------------------------------------------------------------------
# вывод списка объектов
# -----------------------------------------------------------------------------------------------
$crdObject[^mLoader[$.name[object]]]
$crdSite[^mLoader[$.name[site]$.h(1)]]
$crdDataProcess[^mLoader[$.name[data_process]$.h(1)]]
$crdTemplate[^mLoader[$.name[template]$.h(1)]]
<button image="24_object_blocks.gif"   name="object_blocks"   alt="Блоки объекта" onClick="CopyChecked('$SYSTEM.path?type=$form:type&amp^;action=block_to_object')" />
<atable label="Mouse CMS | Объекты">
	^crdObject.draw[
		$.code[
			Имя документа: ^$hFields.document_name <br />
			Оконное имя: ^$hFields.window_name <br />
			Описание: ^$hFields.description <br />
			<hr/>
			ID Ветви объекта: ^$hFields.thread_id
			rights: ^$hFields.rights, Порядок сортировки: ^$hFields.sort_order,
		Путь: ^$hFields.path <br/>
		Флажки: 
			^^if(^^hFields.is_show_on_sitemap.int(0)){SM }
			^^if(^^hFields.is_show_in_menu.int(0)){Mn }
			^^if(^^hFields.is_published.int(0)){Pb } 
		Изменен: ^$hFields.dt_update <br/>
		^^if(def ^$hFields.url){Объект-ссылка: ^$hFields.url }
		^^if(^^hFields.link_to_object_id.int(0)){Блоки объекта: ^$hFields.link_to_object_id }
		]
		$.names[^table::create{name	id	object
ID	id
Название	name
Тип	object_type_id	crdObjectType.hash
Полный путь	full_path
Сайт	site_id	crdSite.hash
Родитель	parent_id	crdObject.hash
Обработчик	data_process_id	crdDataProcess.hash
Шаблон	template_id	crdTemplate.hash
Время кэша	cache_time
}]]
	^added[]
^form_engine[
	^$.where[object_id]
	^$.action[delete]
	^$.tables[^$.main[object]]
	^$.process[object]
]
</atable>
}
#end @objects[][hAction;c]



#################################################################################################
# Управление объектами
@block[][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
	
}{
# -----------------------------------------------------------------------------------------------
# вывод списка блоков
$crdBlock[^mLoader[$.name[block]$.t(1)]]
$crdDataProcess[^mLoader[$.name[data_process]$.h(1)]]
$crdDataType[^mLoader[$.name[data_type]$.h(1)]]
<atable label="Mouse CMS | Блоки">
	^crdBlock.draw[
		$.code[
			Описание: ^$hFields.description <br/>
			^^if(^$hFields.is_not_empty){Содержит данные <br/>}
			^^if(^$hFields.is_published){Опубликован <br/>}
			Изменен: ^$hFields.dt_update <br/>
			Атрибуты: ^$hFields.attr <br/>
		]
		$.names[^table::create{name	id	object
ID	id
Название	name
Обработчик	data_process_id	crdDataProcess.hash
Тип данных	data_type_id	crdDataType.hash
}]]
	^added[]
^form_engine[
	^$.where[block_id]
	^$.action[delete]
	^$.tables[^$.main[block]^$.[block_to_object]]
]
</atable>
}
#end @block[][hAction]



#################################################################################################
# Определение действия
@mGetAction[sTemp]
^switch[$sTemp]{
	^case[edit]{$result[$.i(1)$.label[Редактирование]]}
	^case[copy]{$result[$.i(2)$.label[Копирование]]}
	^case[add]{$result[$.i(4)$.label[Удаление]]}
	^case[DEFAULT]{$result[$.i(0)$.label[]]}
}
#end @mGetAction[sTemp]



#################################################################################################
# Загрузчик курдов
@mLoader[hParams]
$result[
	^curd::init[
		$.name[$hParams.name]
		^switch[$hParams.name]{
#			сайты
			^case[site]{
				$.names[
					$.[site.site_id][id]
					$.[site.name][]
					$.[site.lang_id][]
					$.[site.domain][]
					$.[site.e404_object_id][]
					$.[site.cache_time][]
					$.[site.sort_order][]
				]
			}
#			объекты
			^case[object]{
				$.names[
					$.[object.object_id][id]
					$.[object.sort_order][]
					$.[object.parent_id][]
					$.[object.thread_id][]
					$.[object.site_id][]
					$.[object.template_id][]
					$.[object.data_process_id][]
					$.[object.object_type_id][]
					$.[object.link_to_object_type_id][]
					$.[object.link_to_object_id][]
					$.[object.auser_id][]
					$.[object.rights][]
					$.[object.cache_time][]
					$.[object.is_show_on_sitemap][]
					$.[object.is_show_in_menu][]
					$.[object.is_published][]
					$.[object.dt_update][]
					$.[object.path][]
					$.[object.full_path][]
					$.[object.url][]
					$.[object.name][]
					$.[object.document_name][]
					$.[object.window_name][]
					$.[object.description][]
				]
			}
#			типы объектов
			^case[object_type]{
				$.names[
					$.[object_type.object_type_id][id]
					$.[object_type.sort_order][]
					$.[object_type.is_show_on_sitemap][]
					$.[object_type.is_fake][]
					$.[object_type.abbr][]
					$.[object_type.name][]
					$.[object_type.constructor][]
				]
			}
#			обработчики
			^case[data_process]{
				$.names[
					$.[data_process.data_process_id][id]
					$.[data_process.data_process_type_id][]
					$.[data_process.name][]
					$.[data_process.description][]
					$.[data_process.filename][]
					$.[data_process.dt_update][]
					$.[data_process.sort_order][]
				]
			}
#			типы данных
			^case[data_type]{
				$.names[
					$.[data_type.data_type_id][id]
					$.[data_type.sort_order][]
					$.[data_type.name][]
				]
			}
#			шаблоны
			^case[template]{
				$.names[
					$.[template.template_id][id]
					$.[template.template_type_id][]
					$.[template.name][]
					$.[template.description][]
					$.[template.filename][]
					$.[template.params][]
					$.[template.dt_update][]
					$.[template.sort_order][]
				]
			}
#			блоки объекта
			^case[block_to_object]{
				$.leftjoin[block]
				$.using[block_id]
				$.where[object_id = '$form:id']
				$.names[
					$.[block_to_object.block_id][id]
					$.[block_to_object.sort_order][]
					$.[block_to_object.mode][]
					$.[block.name][]
				]
			}
#			блоки
			^case[block]{
				$.order[name]
				$.names[
					$.[block.block_id][id]
					$.[block.name][]
					$.[block.attr][]
					$.[block.description][]
					$.[block.data_type_id][]
					$.[block.data_process_id][]
					$.[block.data][]
					$.[block.dt_update][]
					$.[block.is_published][]
					$.[block.is_hide_published][]
					$.[block.is_not_empty][]
					$.[block.is_shared][]
					$.[block.is_parsed_manual][]
				]
			}
#			пользователи
			^case[auser]{
				$.leftjoin[asession]
				$.using[auser_id]
				$.order[name]
				$.group[auser.name]
				$.names[
					$.[auser.auser_id][id]
					$.[auser.auser_type_id][]
					$.[auser.name][]
					$.[auser.rights][]
					$.[auser.description][]
					$.[auser.email][]
					$.[auser.dt_register][]
					$.[auser.dt_logon][]
					$.[auser.dt_logout][]
					$.[auser.connections_limit][]
					$.[auser.event_type][]
					$.[auser.is_published][]
					$.[auser.is_default][]
					$.[MAX(asession.dt_access)][dt_access]
				]
			}
		}
		$.h($hParams.h)
		$.t($hParams.t)
	]
]
#end @mLoader[hParams]



#################################################################################################
# добавление стандартных элементов списков админки
@added[]
<th_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'order'){}{$key=$value&amp^;}}</th_attr>
<tr_attr>$SYSTEM.path?action=edit&amp^;type=$form:type&amp^;</tr_attr>
<scroller_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key ne 'number'){$key=$value&amp^;}}</scroller_attr>
<footer_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'find' || $key eq 'filter'){}{$key=$value&amp^;}}</footer_attr>
<form_find>$form:find</form_find>
<form_filter>$form:filter</form_filter>
#end @added[]



#################################################################################################
# генерация полей параметров формы и поля секретности
@form_engine[sStr]
$sStr[^sStr.match[\s+][g]{}]
<input type="hidden" name="form_engine" value="$sStr"/>
<input type="hidden" name="form_security" value="^MAIN:security[$sStr]"/>
#end form_engine[sStr]