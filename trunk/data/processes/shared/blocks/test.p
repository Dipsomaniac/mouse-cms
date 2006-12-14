^mRun[$lparams]



#################################################################################################
# Админка
@mRun[hParams][jMethod]
^use[curd.p]
<block_content>
$hParams.body
<buttons>
	<button image="24_sites.gif"      name="sites"     alt="Сайты"							onClick="Go('$SYSTEM.path?type=sites','#container')" />
	<button image="24_objects.gif"    name="objects"   alt="Объекты"						onClick="Go('$SYSTEM.path?type=objects','#container')" />
	<button image="24_blocks.gif"     name="blocks"    alt="Блоки"							onClick="Go('$SYSTEM.path?type=blocks','#container')" />
	<button image="24_process.gif"    name="process"   alt="Обработчики"					onClick="Go('$SYSTEM.path?type=process','#container')" />
	<button image="24_templates.gif"  name="templates" alt="Шаблоны"						onClick="Go('$SYSTEM.path?type=templates','#container')" />
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
@sites[][crdSite;hAction;c]
# создание курдов сайтов и объектов
$crdSite[^mLoader[$.name[site]]]
$crdObject[^mLoader[$.name[object]]]
# определение вывода в зависимости от запроса
^if(def $form:action){
$hAction[^mGetAction[$form:action]]
# вывод формы редактирования
^crdSite.form[
	$.label[MOUSE CMS | Сайт | $hAction.label | $crdSite.hash.[$form:id].name]
	$.id[$form:id]
$c{name	label	type	description	class	default
name	Название	text	Имя сайта	long
domain	Домен	text	Доменнное имя	medium
lang_id	Язык	select	Язык сайта	medium	Vlang
^if($hAction.i & 1){e404_object_id	Ошибки	select	Страница ошибок	medium	Ve404_object_id}
cache_time	Кэш	text	Время кэша (сек)	short
sort_order	Сортировка	text	Порядок сортировки	short
}
	$.Vlang[<option value="1">Русский</option>]
	$.Ve404_object_id[
		^crdObject.list[
			$.simple(1)
			$.select($crdSite.hash.[$form:id].e404_object_id)
			$.tag[field_option]
			$.names[^table::create{name	id	object^#OAid	id^#OAname	name}]
	]]
	$.fields[^table::create{$c}]
	$.added[
		<form_engine>
			^$.where[site_id]
			^$.site_id[$form:id]
			^$.tables[^$.main[site]]
			^if($hAction.i & 6){^$.action[insert]}
			^if($hAction.i & 1){^$.action[update]}
		</form_engine>
]]
}{
# вывод списка сайтов
^crdSite.list[
	$.scroller(1)
	$.Vobject_hash[$crdObject.hash]
	$.label[Mouse CMS | Сайты]
	$.tags[alists]
	$.tag[alist]
	$.code[Язык: ^$table.lang_id <br />Сортировка: ^$table.sort_order]
	$.added[
		<th_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'order'){}{$key=$value&amp^;}}</th_attr>
		<tr_attr>$SYSTEM.path?action=edit&amp^;type=$form:type&amp^;</tr_attr>
		<scroller_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key ne 'number'){$key=$value&amp^;}}</scroller_attr>
		<footer_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'find' || $key eq 'filter'){}{$key=$value&amp^;}}</footer_attr>
		<form_find>$form:find</form_find>
		<form_filter>$form:filter</form_filter>
		<form_engine>
			^$.where[site_id]
			^$.action[delete]
			^$.tables[^$.main[site]]
		</form_engine>
	]
	$.names[^table::create{name	id	object
ID	id
Название	name
Домен	domain
Время кэша	cache_time
Страница Ошибок	e404_object_id	Vobject_hash
}]]
<button image="24_add.gif"    name="add"    alt="Добавить"   onClick="Go('$SYSTEM.path?type=$form:type&amp^;action=add','#container')" />
<button image="24_copy.gif"   name="copy"   alt="Копировать" onClick="CopyChecked('$SYSTEM.path?type=$form:type&amp^;action=copy')" />
<button image="24_delete.gif" name="delete" alt="Удалить"    onClick="DeleteChecked('site_id','$SYSTEM.path?type=$form:type','#container')" />
}
#end @sites[][hAction]



#################################################################################################
# Управление объектами
@objects[][crdSite;crdObject;crdObjectType;crdDataProcess;hAction;c]
# создание курдов сайтов, объектов, типов объектов, обработчиков, шаблонов
$crdSite[^mLoader[$.name[site]]]
$crdObject[^mLoader[$.name[object]]]
$crdObjectType[^mLoader[$.name[object_type]]]
$crdDataProcess[^mLoader[$.name[data_process]]]
$crdTemplate[^mLoader[$.name[template]]]
^if(def $form:action){
# редактирование объектов
$hAction[^mGetAction[$form:action]]
# вывод формы редактирования
^crdObject.form[
	$.label[MOUSE CMS | Объект | $hAction.label | $crdObject.hash.[$form:id].name]
	$.id[$form:id]
^if($hAction.i & 1){
	$.Vpath[$crdObject.hash.[$form:id].path]
	$.Vis_published[$crdObject.hash.[$form:id].is_published]
	$.Vdescription[$crdObject.hash.[$form:id].description]
}
^if($hAction.i & 3){
	$.Vname[$crdObject.hash.[$form:id].name]
	$.Vdocument_name[$crdObject.hash.[$form:id].document_name]
	$.Vwindow_name[$crdObject.hash.[$form:id].window_name]
	$.Vparent_id[$crdObject.hash.[$form:id].parent_id]
}
$c{name	label	type	description	class	default
^if($hAction.i & 1){object_id	ID	none	ID объекта}
name	Имя	text	Имя объекта	medium	Vname
document_name	Название	text	Имя документа	long	Vdocument_name
window_name	Окно	text	Оконное имя:	long	Vdocument_name
path	Путь	text	Имя файла/каталога (example, example.html)	medium	Vpath
cache_time	Кэш	text	Время кэширования (сек)	short
sort_order	Порядок	text	Порядок сортировки	short
is_published	Опубликовать	checkbox			Vis_published
}
	$.fields[^table::create{$c}]
	$.added[
		<form_engine>
			^$.where[object_id]
			^$.object_id[$form:id]
			^$.tables[^$.main[object]]
			^if($hAction.i & 6){^$.action[insert]}
			^if($hAction.i & 1){^$.action[update]}
		</form_engine>
	]
]
}{
# вывод списка объектов
^crdObject.list[
	$.scroller(1)
	$.Vobject_type_hash[$crdObjectType.hash]
	$.Vsite_hash[$crdSite.hash]
	$.Vobject_hash[$crdObject.hash]
	$.Vdata_process_hash[$crdDataProcess.hash]
	$.Vtemplate_hash[$crdTemplate.hash]
	$.label[Mouse CMS | Объекты ]
	$.tags[alists]
	$.tag[alist]
	$.code[
		Имя документа: ^$table.document_name <br />
		Оконное имя: ^$table.window_name <br />
		Описание: ^$table.description <br />
		<hr/>
		Ветвь объекта: ^$hList.Vobject_hash.[^$table.thread_id].name,
		rights: ^$table.rights, Порядок сортировки: ^$table.sort_order,
		Путь: ^$table.path <br/>
		Флажки: 
			^^if(^^table.is_show_on_sitemap.int(0)){SM }
			^^if(^^table.is_show_in_menu.int(0)){Mn }
			^^if(^^table.is_published.int(0)){Pb } 
		Изменен: ^$table.dt_update <br/>
		^^if(def ^$table.url){Объект-ссылка: ^$table.url }
		^^if(^^table.link_to_object_id.int(0)){Блоки объекта: ^$table.link_to_object_id }
	]
	$.added[
		<th_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'order'){}{$key=$value&amp^;}}</th_attr>
		<tr_attr>$SYSTEM.path?action=edit&amp^;type=$form:type&amp^;</tr_attr>
		<scroller_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key ne 'number'){$key=$value&amp^;}}</scroller_attr>
		<footer_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'find' || $key eq 'filter'){}{$key=$value&amp^;}}</footer_attr>
		<form_find>$form:find</form_find>
		<form_filter>$form:filter</form_filter>
		<form_engine>
			^$.where[object_id]
			^$.action[delete]
			^$.tables[^$.main[object]]
		</form_engine>
	]
	$.names[^table::create{name	id	object
ID	id
Название	name
Тип	object_type_id	Vobject_type_hash
Полный путь	full_path
Сайт	site_id	Vsite_hash
Родитель	parent_id	Vobject_hash
Обработчик	data_process_id	Vdata_process_hash
Шаблон	template_id	Vtemplate_hash
Время кэша	cache_time
}]]
}
#end @objects[][hAction;c]



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
^switch[$hParams.name]{
#	сайты
	^case[site]{
		$result[
			^curd::init[
				$.table[site]
				$.names[
					$.[site.site_id][id]
					$.[site.name][]
					$.[site.lang_id][]
					$.[site.domain][]
					$.[site.e404_object_id][]
					$.[site.cache_time][]
					$.[site.sort_order][]
			]]
		]
	}
#	объекты
	^case[object]{
		$result[
			^curd::init[
				$.table[object]
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
			]
		]
	}
#	типы объектов
	^case[object_type]{
		$result[
			^curd::init[
				$.table[object_type]
				$.names[
					$.[object_type.object_type_id][id]
					$.[object_type.sort_order][]
					$.[object_type.is_show_on_sitemap][]
					$.[object_type.is_fake][]
					$.[object_type.abbr][]
					$.[object_type.name][]
					$.[object_type.constructor][]
				]
			]
		]
	}
#	обработчики
	^case[data_process]{
		$result[
			^curd::init[
				$.table[data_process]
				$.names[
					$.[data_process.data_process_id][id]
					$.[data_process.data_process_type_id][]
					$.[data_process.name][]
					$.[data_process.description][]
					$.[data_process.filename][]
					$.[data_process.dt_update][]
					$.[data_process.sort_order][]
				]
			]
		]
	}
#	шаблоны
	^case[template]{
		$result[
			^curd::init[
				$.table[template]
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
			]
		]
	}
}
#end @mLoader[hParams]
