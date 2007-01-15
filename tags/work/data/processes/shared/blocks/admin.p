^mRun[$lparams]



#################################################################################################
# Админка
@mRun[hParams][jMethod]
<block_content>
$hParams.body
<buttons>
	<button image="24_lang.gif"       name="lang"         alt="Языки"							onClick="Go('$SYSTEM.path?type=lang','#container')" />
	<button image="24_sites.gif"      name="site"         alt="Сайты"							onClick="Go('$SYSTEM.path?type=site','#container')" />
	<button image="24_objects.gif"    name="object"       alt="Объекты"						onClick="Go('$SYSTEM.path?type=object','#container')" />
	<button image="24_blocks.gif"     name="block"        alt="Блоки"							onClick="Go('$SYSTEM.path?type=block','#container')" />
	<button image="24_process.gif"    name="data_process" alt="Обработчики"					onClick="Go('$SYSTEM.path?type=data_process','#container')" />
	<button image="24_templates.gif"  name="template"     alt="Шаблоны"						onClick="Go('$SYSTEM.path?type=template','#container')" />
	<button image="24_users.gif"      name="auser"        alt="Gользователи и группы"	onClick="Go('$SYSTEM.path?type=auser','#container')" />
	<button image="24_rights.gif"     name="acl"          alt="Назначение прав"			onClick="Go('$SYSTEM.path?type=acl','#container')" />
	<button image="24_configure.gif"  name="configure"    alt="Обслуживание системы"		onClick="Go('$SYSTEM.path?type=config','#container')" />
	<button image="24_files.gif"      name="files"        alt="Загрузка файлов"			onClick="Go('$SYSTEM.path?type=files','#container')" />
	<button image="24_articles.gif"   name="articles"     alt="Работа со статьями"		onClick="Go('$SYSTEM.path?type=article','#container')" />
	<button image="24_category.gif"   name="category"     alt="Работа с категориями"		onClick="Go('$SYSTEM.path?type=article_type','#container')" />
	<button image="24_star.gif"       name="admin"        alt="Подключаемые модули"		onClick="Go('$SYSTEM.path?type=admin','#container')" />
	<button image="24_divider.gif" />
	^if(def $form:action && $form:action ne 'config'){
		<button image="24_back.gif"    name="back"      alt="Вернуться" onClick="Go('$SYSTEM.path?type=$form:type&amp^;process=$form:process','#container')" />
		<button image="24_save.gif"    name="save"      alt="Сохранить" onClick="saveForms('form_content','$SYSTEM.path?type=$form:type','#container')" />
		<button image="24_retype.gif"  name="retype"    alt="Сбросить"  onClick="resetForm()" />
		<button image="24_cancel.gif"  name="cancel"    alt="Отменить"  onClick="Cancel('$SYSTEM.path?type=$form:type')" />
	}
	^if(def $form:type && !def $form:action && $form:type ne files && $form:type ne 'admin'){
		<button image="24_add.gif"    name="add"    alt="Добавить"   onClick="Go('$SYSTEM.path?type=$form:type&amp^;action=add','#container')" />
		<button image="24_copy.gif"   name="copy"   alt="Копировать" onClick="CopyChecked('$SYSTEM.path?type=$form:type&amp^;action=copy')" />
		<button image="24_delete.gif" name="delete" alt="Удалить"    onClick="DeleteChecked('${form:type}_id','$SYSTEM.path?type=$form:type','#container')" />
	}
</buttons>
^if(def $form:type){
	$jMethod[$[$form:type]]
	^jMethod[]
}
<form action="$SYSTEM.path" name="lang" method="post">
<field type="select" name="lang_id" label="Язык" description="Выбор администрирования локализованных ресурсов" class="short" onChange="Go('$SYSTEM.path?type=$form:type&amp^;lang='+this.value,'#container')">
	^crdLang.list[$.attr[$.id[abbr]$.name[abbr]]$.added[select="$crdLang.hash.[$SYSTEM.lang].abbr"]]
</field>
</form>
</block_content>
#end @mRun[hParams][jMethod]



#################################################################################################
# Управление языками системы
@lang[][crdLang;hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
# вывод формы редактирования
$crdLang[^mLoader[$.name[lang]$.h(1)]]
$hAction[^mGetAction[$form:action]]
<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data" 
	label="MOUSE CMS | Языки | $hAction.label | $crdLang.hash.[$form:id].name ">
<tabs>
	<tab id="section-1" name="Основное">
		<field type="text" name="abbr"    label="Abbr" description="Двубуквенное сокращение языка" class="short">$crdLang.hash.[$form:id].abbr</field>
		<field type="text" name="charset" label="Charset" description="Кодировка" class="medium">$crdLang.hash.[$form:id].charset</field>
		<field type="text" name="sort_order" label="Sort_order" description="Порядок сортировки" class="short">$crdLang.hash.[$form:id].sort_order</field>
		
^form_engine[
	^$.where[lang_id]
	^$.rules[^$.abbr[text]^$.charset[text]^$.sort_order[number]]
	^$.lang_id[$form:id]
	^$.tables[^$.main[lang]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
	]
	</tab>
</tabs>
</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод списка языков
$crdLang[^mLoader[$.name[lang]$.s(20)]]
$crdLang.table[^mFilter[$crdLang.table]]
<atable label="Mouse CMS | Языки">
	^crdLang.draw[
		$.code[Сортировка: ^$hFields.sort_order]
		$.names[^table::create{name	id	object
ID	id
Абревиатура	abbr
Кодировка	charset
}]]
	^added[]
^form_engine[
	^$.where[lang_id]
	^$.action[delete]
	^$.tables[^$.main[lang]]
]
^crdLang.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @lang[][crdLang;hAction]



#################################################################################################
# Управление сайтами
@site[][crdSite;hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
# вывод формы редактирования
$crdLang[^mLoader[$.name[lang]]]
$crdSite[^mLoader[$.name[site]$.h(1)]]
$crdObject[^mLoader[$.name[object]$.where[site_id = $form:id]]]
$hAction[^mGetAction[$form:action]]
<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data" 
	label="MOUSE CMS | Сайты | $hAction.label | $crdSite.hash.[$form:id].name ">
<tabs>
	<tab id="section-1" name="Основное">
		<field type="text"   name="name"           label="Название"   description="Имя сайта"              class="long">$crdSite.hash.[$form:id].name</field>
		<field type="text"   name="domain"         label="Домен"      description="Доменное имя"           class="medium">$crdSite.hash.[$form:id].domain</field>
		<field type="select" name="lang_id"        label="Язык"       description="Язык сайта по умолчанию" class="short">
			^crdLang.list[$.attr[$.id[id]$.name[abbr]]$.added[select="$crdSite.hash.[$form:id].lang_id"]]
		</field>
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
$crdSite[^mLoader[$.name[site]$.s(20)]]
$crdObject[^mLoader[$.name[object]$.h(1)]]
$crdSite.table[^mFilter[$crdSite.table]]
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
^crdSite.scroller[$.uri[$SYSTEM.path]]
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
		$crdBlockToObject[^mLoader[$.name[block_to_object]$.t(1)]]
		$crdBlock[^mLoader[
			$.name[block]
			$.t(1)
			$.where[is_shared = 1 ^if($crdBlockToObject.table){OR block_id IN (^crdBlockToObject.table.menu{ $crdBlockToObject.table.id}[,])}]
		]]
		<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
		label="MOUSE CMS | Объект | Управление блоками | $crdObject.hash.[$form:id].name ">
		<tabs>
		<tab id="section-1" name="Блоки объекта $crdObject.hash.[$form:id].name">
			^crdBlockToObject.table.append{9	1	1	0} 
			<field type="none" label="$crdObject.hash.[$form:id].name" description="Блоки объекта">
				<br/><br/><br/>
				Mode: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Sort_order: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Name:<br/>
#				объекту можно присвоить до 10 блоков =debug
				^for[iCount](0;9){
					^if(^crdBlockToObject.table.count[] > $iCount){^crdBlockToObject.table.offset[set]($iCount)}
					<input  name="mode_$iCount" value="$crdBlockToObject.table.mode" class="input-text-short"/>
					<input  name="sort_order_$iCount" value="$crdBlockToObject.table.sort_order" class="input-text-short"/>
					<select name="block_id_$iCount" class="long">
						<option id="0" name="none" />
						^crdBlock.list[$.added[select="$crdBlockToObject.table.id"]]
					</select>
					<a href="#" onclick="Go('$SYSTEM.path?type=block&amp^;action=edit&amp^;id=$crdBlockToObject.table.id', '#container')">edit</a>
					<br/>
				}
			</field>
			<field type="none" />
^form_engine[
	^$.where[object_id]
	^$.object_id[$form:id]
	^$.tables[^$.main[block_to_object]]
	^$.action[delete]
	^$.process[block_to_object]
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
		<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
		label="MOUSE CMS | Объекты | $hAction.label | $crdObject.hash.[$form:id].name ">
		<tabs>
		<tab id="section-1" name="Основное">
			^if($hAction.i & 1){<field type="none" name="object_id" label="ID" description="ID объекта">$crdObject.hash.[$form:id].id</field>}
			<field type="text" name="name" label="Имя" description=" Имя объекта " class="medium">$hAction.name</field>
			<field type="text" name="document_name" label="Название" description=" Имя документа " class="long"  >$hAction.document_name</field>
			<field type="text" name="window_name" label="Окно" description=" Оконное имя: " class="long">$hAction.window_name</field>
			<field type="text" name="path" label="Путь" description="Имя каталога" class="medium">$hAction.path</field>
			<field type="text" name="cache_time" label="Кэш" description="Время кэширования (сек)" class="short">$crdObject.hash.[$form:id].cache_time</field>
			<field type="text" name="sort_order" label="Порядок" description="Порядок сортировки" class="short">$crdObject.hash.[$form:id].sort_order</field>
			<field type="checkbox" name="is_published"  label="Опубликовать" description="">$hAction.is_published</field>
			<field type="select" name="parent_id" label="Предок" description="Родительский объект" class="medium">
				<option id="0" select="$parent_id" name="Корневое пространство"/>
				^crdObject.list[$.added[select="$hAction.parent_id"]]
			</field>
			<field type="select" name="template_id" label="Шаблон" description="Шаблон дизайна объекта" class="medium">
				<option id="0" select="$crdObject.hash.[$form:id].template_id" name="Не задан" />
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
				<option id="0" select="$crdObject.hash.[$form:id].data_process_id" name="отсутствует"/>
				^crdDataProcess.list[$.added[select="$crdObject.hash.[$form:id].data_process_id"]]
			</field>
			<field type="select" name="link_to_object_id" description="Подменить содержимое, содержимым выбранного объекта" label="Ссылка"  class="medium">
				<option id="0" select="$crdObject.hash.[$form:id].link_to_object_id" name="не подменять"/>
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
			<field type="hidden" name="dt_update">$SYSTEM.date</field>
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
$crdObject[^mLoader[$.name[object]$.s(20)]]
$crdObject.table[^mFilter[$crdObject.table]]
$crdLang[^mLoader[$.name[lang]]]
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
	^$.tables[^$.main[object]^$.connect[block_to_object]^$.textconnect[object_text]]
	^$.process[object]
]
^crdObject.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @objects[][hAction;c]



#################################################################################################
# Управление блоками
@block[][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdBlock[^mLoader[$.name[block]$.h(1)]]
	$crdDataProcess[^mLoader[$.name[data_process]$.t(1)]]
	$crdDataType[^mLoader[$.name[data_type]$.t(1)]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Блоки | $hAction.label | $crdBlock.hash.[$form:id].name ">
	<tabs>
	<tab id="section-1" name="Основное">
		^if($hAction.i & 1){
			<field type="none"  name="block_id" label="ID" description="ID блока">$crdBlock.hash.[$form:id].id</field>
		}
		<field type="text" name="name" label="Имя" description="Название блока" class="medium">$crdBlock.hash.[$form:id].name</field>
		<field type="checkbox" name="is_published"  label="Опубликовать">$crdBlock.hash.[$form:id].is_published</field>
		<field type="select" name="data_process_id" label="Обработчик" description="Обработчик блока">
			<option id="0" select="$crdBlock.hash.[$form:id].data_process_id" name="отсутствует"/>
			^crdDataProcess.list[$.added[select="$crdBlock.hash.[$form:id].data_process_id"]]
		</field>
		<field type="textarea" name="description"   label="Описание"  description="Описание блока" >$crdBlock.hash.[$form:id].description</field>
	</tab>
	<tab id="section-2" name="Дополнительное">
		<field type="checkbox" name="is_parsed_manual" label="Ручной вызов">$crdBlock.hash.[$form:id].is_parsed_manual</field>
		<field type="checkbox" name="is_shared" label="Общий блок">$crdBlock.hash.[$form:id].is_shared</field>
		<field type="textarea" name="attr" label="Атрибуты" description="Атрибуты блока">$crdBlock.hash.[$form:id].attr</field>
		<field type="select" name="data_type_id" label="Данные" description="Тип данных блока">
			^crdDataType.list[$.added[select="$crdBlock.hash.[$form:id].data_type_id"]]
		</field>
	</tab>
	<tab id="section-3" name="Данные">
		<field type="textarea" name="data" label="Данные" ws="true" description="Данные блока">$crdBlock.hash.[$form:id].data</field>
	</tab>
	</tabs>
	<field type="hidden" name="dt_update">$SYSTEM.date</field>
^form_engine[
	^$.process[block]
	^$.where[block_id]
	^$.block_id[$form:id]
	^$.tables[^$.main[block]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
# -----------------------------------------------------------------------------------------------
#	запрет постпросессинга данных блока
	$SYSTEM.postProcess(0)
}{
# -----------------------------------------------------------------------------------------------
# вывод списка блоков
$crdBlock[^mLoader[$.name[block]$.t(1)$.s(20)]]
$crdBlock.table[^mFilter[$crdBlock.table]]
$crdDataProcess[^mLoader[$.name[data_process]$.h(1)]]
$crdDataType[^mLoader[$.name[data_type]$.h(1)]]
<atable label="Mouse CMS | Блоки ">
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
Общий	is_shared
}]]
	^added[]
^form_engine[
	^$.where[block_id]
	^$.action[delete]
	^$.tables[^$.main[block]^$.connect[block_to_object]]
]
^crdBlock.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @block[][hAction]



#################################################################################################
# Управление обработчиками
@data_process[][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdDataProcess[^mLoader[$.name[data_process]$.h(1)]]
	$crdDataProcessType[^mLoader[$.name[data_process_type]$.t(1)]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Обработчики | $hAction.label | $crdDataProcess.hash.[$form:id].name ">
	<tabs>
	<tab id="section-1" name="Основное">
		^if($hAction.i & 1){
			<field type="none"  name="data_process_id" label="ID" description="ID обработчика">$crdDataProcess.hash.[$form:id].id</field>
		}
		<field type="text" name="name" label="Имя" description="Имя обработчика" class="long">$crdDataProcess.hash.[$form:id].name</field>
		<field type="text" name="filename" label="Процесс" description=" Имя файла обработчика">$crdDataProcess.hash.[$form:id].filename</field>
		<field type="text" name="sort_order" label="Порядок" description="Сортировка">$crdDataProcess.hash.[$form:id].sort_order</field>
		<field type="select" name="data_process_type_id" label="Тип" description="Тип обработчика" class="long">
			^crdDataProcessType.list[$.added[select="$crdDataProcess.hash.[$form:id].data_process_type_id"]]
		</field>
		<field type="textarea" name="description" label="Описание" description="Функциональность обработчика">$crdDataProcess.hash.[$form:id].description</field>
		<field type="hidden" name="dt_update">$SYSTEM.date</field>
	</tab>
	</tabs>
^form_engine[
	^$.where[data_process_id]
	^$.data_process_id[$form:id]
	^$.tables[^$.main[data_process]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод списка обработчиков
$crdDataProcess[^mLoader[$.name[data_process]$.t(1)$.s(20)]]
$crdDataProcess.table[^mFilter[$crdDataProcess.table]]
$crdDataProcessType[^mLoader[$.name[data_process_type]$.h(1)]]
<atable label="Mouse CMS | Обработчики ">
	^crdDataProcess.draw[
		$.code[
			Описание: ^$hFields.description <br/>
			Изменен: ^$hFields.dt_update <br/>
			Сортировка: ^$hFields.sort_order <br/>
		]
		$.names[^table::create{name	id	object
ID	id
Название	name
Имя файла	filename
Тип данных	data_process_type_id	crdDataProcessType.hash
}]]
	^added[]
^form_engine[
	^$.where[data_process_id]
	^$.action[delete]
	^$.tables[^$.main[data_process]]
]
^crdDataProcess.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @data_process[][hAction]



#################################################################################################
# Управление шаблонами
@template[][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdTemplate[^mLoader[$.name[template]$.h(1)]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Шаблоны | $hAction.label | $crdTemplate.hash.[$form:id].name ">
	<tabs>
	<tab id="section-1" name="Основное">
		^if($hAction.i & 1){
			<field type="none"  name="template_id" label="ID" description="ID шаблона">$crdTemplate.hash.[$form:id].id</field>
		}
		<field type="text" name="name"       label="Имя"        description="Имя шаблона">$crdTemplate.hash.[$form:id].name</field>
		<field type="text" name="filename"   label="Шаблон"     description=" Имя файла шаблона"  class="medium">$crdTemplate.hash.[$form:id].filename</field>
		<field type="text" name="params"     label="Файл стиля" description=" Имя файла стиля"  class="medium">$crdTemplate.hash.[$form:id].params</field>
		<field type="text" name="sort_order" label="Порядок"    description="Сортировка" class="short">$crdTemplate.hash.[$form:id].sort_order</field>
		<field type="textarea" name="description" label="Описание" description="Функциональность шаблона">$crdTemplate.hash.[$form:id].description</field>
		<field type="hidden" name="dt_update">$SYSTEM.date</field>
	</tab>
	</tabs>
^form_engine[
	^$.where[template_id]
	^$.template_id[$form:id]
	^$.tables[^$.main[template]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод списка шаблонов
$crdTemplate[^mLoader[$.name[template]$.t(1)$.s(20)]]
$crdTemplate.table[^mFilter[$crdTemplate.table]]
<atable label="Mouse CMS | Шаблоны ">
	^crdTemplate.draw[
		$.code[
			Описание: ^$hFields.description <br/>
			Изменен: ^$hFields.dt_update <br/>
		]
		$.names[^table::create{name	id	object
ID	id
Название	name
Имя файла	filename
Имя файла стиля	params
}]]
	^added[]
^form_engine[
	^$.where[template_id]
	^$.action[delete]
	^$.tables[^$.main[template]]
]
^crdTemplate.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @template[][hAction]



#################################################################################################
# Управление пользователями
@auser[][hAction;hRights]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdAuser[^mLoader[$.name[auser]]]
	$crdAuserToAuser[^mLoader[$.name[auser_to_auser]$.h(1)]]
	^if($hAction.i & 2){$crdAuser.hash.[$form:id].name[]}
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Пользователи и группы | $hAction.label | $crdAuser.hash.[$form:id].name ">
	<tabs>
	<tab id="section-1" name="Основное">
		^if($hAction.i & 1){
			<field type="none"  name="auser_id" label="ID" description="ID пользователя" class="short">$crdAuser.hash.[$form:id].id</field>
		}
		<field type="text" name="name" label="Имя" description="Имя пользователя" class="medium">$crdAuser.hash.[$form:id].name</field>
		<field type="select" name="auser_type_id" label="Тип" description="Тип пользователя" class="medium">
			<option id="0" select="$crdAuser.hash.[$form:id].auser_type_id" name="Пользователь" />
			<option id="1" select="$crdAuser.hash.[$form:id].auser_type_id" name="Группа" />
			<option id="2" select="$crdAuser.hash.[$form:id].auser_type_id" name="Владелец" />
		</field>
		<field type="text" name="email" label="E-Mail" description="Электронная почта" class="medium">$crdAuser.hash.[$form:id].email</field>
		<field type="checkbox" name="is_published" label="Опубликовать" description="" class="medium">$crdAuser.hash.[$form:id].is_published</field>
		<field type="textarea" name="description" label="Описание" description="Описание пользователя">$crdAuser.hash.[$form:id].description</field>
		<field type="text" name="passwd" label="Пароль" description="Установить (сменить) пароль" class="medium"></field>
	</tab>
	<tab id="section-3" name="Атрибуты">
		<field type="select" name="auth_parent_id" label="Группа" description="Группа пользователя" class="medium">
			<option id="0" select="$crdAuserToAuser.hash.[$form:id].parent_id" name="none"/>
			^crdAuser.table.menu{^if($crdAuser.table.auser_type_id == 1){
				<option id="$crdAuser.table.id" select="$crdAuserToAuser.hash.[$form:id].parent_id" name="$crdAuser.table.name" />
			}}
		</field>
		$hRights[^getHashRights($crdAuser.hash.[$form:id].rights)]
		<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
		<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
		<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
		<field type="checkbox" name="rights_comment" label="Комментарии" description="Права по умолчанию">$hRights.comment</field>
		<field type="checkbox" name="rights_supervisory" label="Может все" description="Права по умолчанию">$hRights.supervisory</field>
		^if($hAction.i & 6){
			<field type="hidden" name="dt_register">$SYSTEM.date</field>
		}
	</tab>
	</tabs>
^form_engine[
	^$.process[auser]
	^$.where[auser_id]
	^$.auser_id[$form:id]
	^$.tables[^$.main[auser]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод списка пользователей
$crdAuser[^mLoader[$.name[auser]$.t(1)$.s(20)]]
$crdAuser.table[^mFilter[$crdAuser.table]]
$hAuser_type[
	$.0[$.name[user]]
	$.1[$.name[group]]
	$.2[$.name[owner]]
]
<atable label="Mouse CMS | Пользователи и группы ">
	^crdAuser.draw[
		$.code[
			Описание: ^$hFields.description <br/>
			Зарегистрировался: ^$hFields.dt_register <br/>
			Последний доступ: ^$hFields.dt_access <br/>
		]
		$.names[^table::create{name	id	object
ID	id
Имя	name
Тип	auser_type_id	hAuser_type
Права	rights
E-mail	email
Вход	dt_logon
Выход	dt_logout
Событие	event_type
}]]
	^added[]
^form_engine[
	^$.where[auser_id]
	^$.action[delete]
	^$.tables[^$.main[auser]^$.connect[asession]^$.connect2[aevent_log]^$.connect3[acl]]
]
^crdAuser.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @auser[][hAction]



#################################################################################################
# Управление правами
@acl[][hAction;hRights]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdAcl[^mLoader[$.name[acl]$.h(1)]]
	$crdAuser[^mLoader[$.name[auser]$.t(1)]]
	$crdObject[^mLoader[$.name[object]$.t(1)]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Управление правами | $hAction.label  ">
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="select" name="object_id" label="Объект" description="Выбор объекта" class="medium">
			^crdObject.list[$.added[select="$crdAcl.hash.[$form:id].object_id"]]
		</field>
		<field type="select" name="auser_id" label="Пользователь(группа)" description="Выбор пользователя" class="medium">
			^crdAuser.list[$.added[select="$crdAcl.hash.[$form:id].auser_id"]]
		</field>
		$hRights[^getHashRights($crdAcl.hash.[$form:id].rights)]
		<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
		<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
		<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
		<field type="checkbox" name="rights_comment" label="Комментарии" description="Права по умолчанию">$hRights.comment</field>
		<field type="checkbox" name="rights_supervisory" label="Может все" description="Права по умолчанию">$hRights.supervisory</field>
	</tab>
	</tabs>
^form_engine[
	^$.process[auser]
	^$.where[acl_id]
	^$.acl_id[$form:id]
	^$.tables[^$.main[acl]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод прав
$crdAcl[^mLoader[$.name[acl]$.t(1)$.s(20)]]
$crdAcl.table[^mFilter[$crdAcl.table]]
$crdAuser[^mLoader[$.name[auser]$.h(1)]]
$crdObject[^mLoader[$.name[object]$.h(1)]]
<atable label="Mouse CMS | Управление правами ">
	^crdAcl.draw[
		$.code[
			Описание: ^$hFields.description <br/>
			Зарегистрировался: ^$hFields.dt_register <br/>
			Последний доступ: ^$hFields.dt_access <br/>
		]
		$.names[^table::create{name	id	object
Объект	object_id	crdObject.hash
Пользователь(группа)	auser_id	crdAuser.hash
Права	rights
}]]
	^added[]
^form_engine[
	^$.where[acl_id]
	^$.action[delete]
	^$.tables[^$.main[acl]]
]
^crdAcl.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @acl[][hAction]



#################################################################################################
# управление статьями
@article[][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdArticle[^mLoader[$.name[article]$.h(1)]]
	$crdArticleType[^mLoader[$.name[article_type]$.t(1)]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Статьи | $hAction.label" >
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="text" name="title" label="Название" description=" Название статьи " class="medium">$crdArticle.hash.[$form:id].title</field>
		<field type="select" name="article_type_id" label="Категория" description="Категория статьи" class="medium">
			^crdArticleType.list[$.added[select="$crdArticle.hash.[$form:id].article_type_id"]]
		</field>
		<field type="text" name="image" label="Картинка" description=" Имя файла изображения (без пути) " class="medium">$crdArticle.hash.[$form:id].image</field>
		<field type="checkbox" name="is_published"  label="Опубликовать">$crdArticle.hash.[$form:id].is_published</field>
		<field type="textarea" name="lead"   label="Анонс"     description="Краткое содержание">$crdArticle.hash.[$form:id].lead</field>
		<field type="hidden" name="dt">$SYSTEM.date</field>
		^if($hAction.i & 6){
			<field type="hidden" name="dt_published">$SYSTEM.date</field>
			<field type="hidden" name="author">$MAIN:objAuth.user.name</field>
		}
		</tab>
		<tab id="section-2" name="Содержание">
			<field type="textarea" name="body" ws="true"  label="Текст"   description="Содержание статьи">$crdArticle.hash.[$form:id].body</field>
		</tab>
	</tabs>
^form_engine[
	^$.process[article]
	^$.where[article_id]
	^$.article_id[$form:id]
	^$.tables[^$.main[article]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод статей
$crdArticle[^mLoader[$.name[article]$.t(1)$.s(20)]]
$crdArticle.table[^mFilter[$crdArticle.table]]
$crdArticleType[^mLoader[$.name[article_type]$.h(1)]]
<atable label="Mouse CMS | Статьи ">
	^crdArticle.draw[
		$.code[
			Анонс: ^$hFields.lead <br/>
			^^if(^$hFields.is_not_empty){Содержит данные <br/>}
			Создана: ^$hFields.dt_published <br/>
		]
		$.names[^table::create{name	id	object
ID	id
Название	title
Опубликована	is_published
Дата публикации	dt_published
Категория	article_type_id	crdArticleType.hash
}]]
	^added[]
^form_engine[
	^$.where[article_id]
	^$.action[delete]
	^$.tables[^$.main[article]]
]
^crdArticle.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @article[][hAction]



#################################################################################################
# управление категориями
@article_type[][hAction;hRights]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdObject[^mLoader[$.name[object]$.t(1)]]
	$crdArticleType[^mLoader[$.name[article_type]$.h(1)]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Категории | $hAction.label" >
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="text" name="name" label="Название" description=" Название категории " class="medium">$crdArticleType.hash.[$form:id].name</field>
		<field type="select" name="object_id" label="Объект" description=" Выбор объекта " class="medium">
			^crdObject.list[$.added[select="$crdArticleType.hash.[$form:id].object_id"]]
		</field>
		$hRights[^getHashRights($crdArticleType.hash.[$form:id].rights)]
		<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
		<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
		<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
		<field type="checkbox" name="rights_comment" label="Комментарии" description="Права по умолчанию">$hRights.comment</field>
		<field type="checkbox" name="rights_supervisory" label="Может все" description="Права по умолчанию">$hRights.supervisory</field>
	</tab>
	</tabs>
^form_engine[
	^$.process[article_type]
	^$.where[article_type_id]
	^$.article_type_id[$form:id]
	^$.tables[^$.main[article_type]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод категорий
$crdObject[^mLoader[$.name[object]$.h(1)]]
$crdArticleType[^mLoader[$.name[article_type]$.t(1)$.s(20)]]
$crdArticleType.table[^mFilter[$crdArticleType.table]]
<atable label="Mouse CMS | Категории ">
	^crdArticleType.draw[
		$.names[^table::create{name	id	object
ID	id
Название	name
Объект	object_id	crdObject.hash
Права	rights
}]]
	^added[]
^form_engine[
	^$.where[article_type_id]
	^$.action[delete]
	^$.tables[^$.main[article_type]]
]
^crdArticleType.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @article_type[][hAction;hRights]



#################################################################################################
# Обслуживание системы
@config[]
<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Обслуживание системы" >
	<tabs>
		<tab id="section-1" name="Логи посещений">
		^logs[$MAIN:LogDir/static]
		^if(def $form:path){
			$fFile[^file::load[text;$form:path]]
			$sLog[$fFile.text]
$tReplace[^table::create{from	to
^taint[^#0A]	<br/>
}]
			<br/><br/><b>$form:path</b><br/>
			<pre>^sLog.replace[$tReplace]]</pre>
		}
		</tab>
	</tabs>
</form>
#end @config[]
@logs[sPath][tList]
<ul>
$tList[^file:list[$sPath]]
^tList.menu{
	^if(-f "$sPath/$tList.name" && (^tList.name.pos[lock] < 0)){
		<li><a href="#" onClick="Go('$SYSTEM.path?type=config&amp^;path=$sPath/$tList.name','#container')">$tList.name</a></li>
	}
	^if(-d "$sPath/$tList.name" && (($tList.name ne hosts) && ($tList.name ne hits))){
		<li>$sPath/$tList.name</li>
		^logs[$sPath/$tList.name]
	}
}
</ul>
#end logs[]



#################################################################################################
# Загрузка файлов
@files[][tList;sPath;hStat]
$crdObject[^mLoader[$.name[object]]]
<button image="24_save.gif"    name="save"      alt="Сохранить" onClick="submitForm()" />
<button image="24_retype.gif"  name="retype"    alt="Сбросить"  onClick="resetForm()" />
<form method="post" action="$crdObject.hash.10.full_path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Загрузка файлов " >
	<tabs>
		<tab id="section-1" name="Загрузка файлов">
		<field type="select" name="object_id" label="Объект" description=" Владелец изображения " class="medium">
			^crdObject.list[]
		</field>
		<field type="select" name="type" label="Тип файла" description=" файл/изображение " class="medium">
			<option id="file" name="Файл"/>
			<option id="image" name="Изображение"/>
		</field>
		<field type="text" name="name" label="Имя" description=" Имя сохранения файла " class="medium"></field>
		<field type="file" name="image" label="Файл" description=" Выберите файл" class="long"></field>
		</tab>
		<tab id="section-2" name="Параметры изображения">
		<field type="text" name="width" label="Изменение размера" description=" Введите ширину в px " class="short"></field>
		<field type="text" name="height" label="Изменение размера" description=" Введите высоту в px " class="short"></field>
		<field type="select" name="format" label="Формат" description=" Изменение формата изображения " class="medium">
			<option id="none" name="не менять" />
			<option id="jpg" name="jpg" />
			<option id="gif" name="gif" />
			<option id="png" name="png" />
		</field>
		<field type="text" name="preview" label="Превью" description=" Сгенерировать превью (ширина) " class="medium"></field>
		<field type="checkbox" name="meta" label="Удалить данные" description=" Удаление мета данных изображения "></field>
^form_engine[
	^$.process[files]
	^$.location[$crdObject.hash.9.full_path?type=files]
]
		</tab>
		<tab id="section-3" name="Диспетчер файлов">
		<field type="select" name="meneger_object_id" label="Объект" description=" Владелец файлов " class="medium" onChange="Go('$SYSTEM.path?type=files&amp^;object='+this.value,'#container')">
			^crdObject.list[$.added[select="$form:object"]]
		</field>
		<br/><br/>
		<ul>
^if(def $crdObject.hash.[$form:object].full_path){$sPath[$crdObject.hash.[$form:object].full_path]}{$sPath[/]}
$tList[^file:list[$sPath]]
^tList.menu{
	^if(-f "${sPath}$tList.name" && $tList.name ne index.html){
		<li>
			<a href="${sPath}$tList.name" target="New">$tList.name</a><br/>
			$hStat[^file::stat[${sPath}$tList.name]]
			Path: ${sPath}$tList.name, Mouse link: &lt^;mouse:method name="file"&gt^;^$.object_id[$crdObject.hash.[$form:object].id]^$.file[$tList.name]&lt^;/mouse:method&gt^;<br/>
			Size: $hStat.size b, Create: ^hStat.cdate.sql-string[]
		</li>
	}
}

</ul>
		</tab>
	</tabs>
</form>
#end files[]



#################################################################################################
# Администрирование дополнительных модулей
@admin[][tList;tResult;tTempTable]
^if(def $form:process){
^executeSystemProcess[$.id[$form:process]$.param[$.admin(1)]]
}{
$tList[^file:list[$MAIN:CfgDir/processes/shared/admin;\.cfg^$]]
$tResult[^table::create{name	process_id	comment	image}]
^tList.menu{
	$tTempTable[^table::load[$MAIN:CfgDir/processes/shared/admin/$tList.name]]
	^tResult.join[$tTempTable]
}
^tResult.menu{
	<button image="$tResult.image" name="$tResult.name" alt="$tResult.comment" onClick="Go('$SYSTEM.path?type=admin&amp^;process=$tResult.process_id','#container')" />
}
}
#end @admin[][tList;tResult;tTempTable]



#################################################################################################
# Определение действия
@mGetAction[sTemp][result]
^switch[$sTemp]{
	^case[edit]{$result[$.i(1)$.label[Редактирование]]}
	^case[copy]{$result[$.i(2)$.label[Копирование]]}
	^case[add]{$result[$.i(4)$.label[Удаление]]}
	^case[DEFAULT]{$result[$.i(0)$.label[]]}
}
#end @mGetAction[sTemp]



#################################################################################################
# Фильтры таблиц
@mFilter[tData][tParam;sParam;result]
^if(def $form:find){$tData[^tData.select(^tData.name.match[$form:find][i])]}
^if(def $form:order){
	^if(^tData.[$form:order].int(0)){
		^tData.sort($tData.[$form:order])
	}{
		^tData.sort{$tData.[$form:order]}
	}
}
^if(def $form:filter){
	$tParam[$form:filter]
	$tParam[^tParam.split[=]]
	$sParam[^tParam.piece.trim[]]
	^tParam.offset(1)
	$tData[^tData.select($tData.[$sParam] eq ^tParam.piece.trim[])]
}
$result[$tData]
#end @mFilter[tData][tParam;sParam;result]



#################################################################################################
# Загрузчик курдов
@mLoader[hParams][result]
$result[
	^curd::init[
		$.name[$hParams.name]
		$.h($hParams.h)
		$.t($hParams.t)
		$.s($hParams.s)
		$.where[$hParams.where]
		^switch[$hParams.name]{
#			языки
			^case[lang]{
				$.names[
					$.[lang.lang_id][id]
					$.[lang.sort_order][]
					$.[lang.abbr][]
					$.[lang.charset][]
				]
			}
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
				$.leftjoin[object_text]
				$.on[object.object_id = object_text.object_id AND object_text.lang_id = $SYSTEM.lang]
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
					$.[object_text.name][]
					$.[object_text.document_name][]
					$.[object_text.window_name][]
					$.[object_text.description][]
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
#			типы данных
			^case[data_type]{
				$.names[
					$.[data_type.data_type_id][id]
					$.[data_type.sort_order][]
					$.[data_type.name][]
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
#			типы обработчиков
			^case[data_process_type]{
				$.names[
					$.[data_process_type.data_process_type_id][id]
					$.[data_process_type.sort_order][]
					$.[data_process_type.name][]
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
#			связи пользователей
			^case[auser_to_auser]{
				$.order[]
				$.names[
					$.[auser_to_auser.auser_id][id]
					$.[auser_to_auser.parent_id][]
					$.[auser_to_auser.rights][]
				]
			}
#			права на объекты
			^case[acl]{
				$.order[]
				$.names[
					$.[acl.acl_id][id]
					$.[acl.object_id][]
					$.[acl.auser_id][]
					$.[acl.rights][]
				]
			}
#			статьи
			^case[article]{
				$.order[article_id]
				$.where[article.lang_id = '$SYSTEM.lang']
				$.names[
					$.[article.article_id][id]
					$.[article.article_type_id][]
					$.[article.title][]
					$.[article.lead][]
					$.[article.image][]
					$.[article.is_not_empty][]
					$.[article.is_published][]
					$.[article.body][]
					$.[article.dt][]
					$.[article.dt_published][]
				]
			}
#			категории статей
			^case[article_type]{
				$.order[article_type_id]
				$.names[
					$.[article_type.article_type_id][id]
					$.[article_type.object_id][]
					$.[article_type.name][]
					$.[article_type.rights][]
				]
			}
		}
	]
]
#end @mLoader[hParams]



#################################################################################################
# добавление стандартных элементов списков админки
@added[]
<th_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'order'){}{$key=$value&amp^;}}</th_attr>
<tr_attr>$SYSTEM.path?action=edit&amp^;type=$form:type&amp^;^if(def $form:process){process=$form:process&amp^;}</tr_attr>
<scroller_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key ne 'number'){$key=$value&amp^;}}</scroller_attr>
<footer_attr>$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'find' || $key eq 'filter'){}{$key=$value&amp^;}}</footer_attr>
<form_find>$form:find</form_find>
<form_filter>$form:filter</form_filter>
#end @added[]
