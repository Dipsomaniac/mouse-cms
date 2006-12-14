^mControlInit[]
^mControlRun[$lparams]



# -----------------------------------------------------------------------------------------------
#                                    ЗАГРУЗКА ДАННЫХ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# загрузка данных в админку
@mControlInit[]
^executeSystemProcess[$.id[1]]
$result[]
#end @mControlInit[params]



#################################################################################################
# общая часть
@mControlRun[hParams]
$result[
<block_content>
#	выдача данных блока
	$hParams.body
	<buttons>
			<button image="24_sites.gif"      name="sites"     alt="Управление сайтами"        onClick="Go('$OBJECTS_HASH.80.full_path?type=sites','#container')" />
			<button image="24_objects.gif"    name="objects"   alt="Управление объектами"      onClick="Go('$OBJECTS_HASH.80.full_path?type=objects','#container')" />
			<button image="24_blocks.gif"     name="blocks"    alt="Управление блоками"        onClick="Go('$OBJECTS_HASH.80.full_path?type=blocks','#container')" />
			<button image="24_process.gif"    name="process"   alt="Управление обработчиками"  onClick="Go('$OBJECTS_HASH.80.full_path?type=process','#container')" />
			<button image="24_templates.gif"  name="templates" alt="Управление шаблонами"      onClick="Go('$OBJECTS_HASH.80.full_path?type=templates','#container')" />
			<button image="24_users.gif"      name="users"     alt="Управление пользователями и группами" onClick="Go('$OBJECTS_HASH.80.full_path?type=users','#container')" />
			<button image="24_rights.gif"     name="rigths"    alt="Назначение прав"           onClick="Go('$OBJECTS_HASH.80.full_path?type=rights','#container')" />
			<button image="24_configure.gif"  name="configure" alt="Обслуживание системы"      onClick="Go('$OBJECTS_HASH.80.full_path?type=config','#container')" />
			<button image="24_files.gif"      name="files"     alt="Загрузка файлов"           onClick="Go('$OBJECTS_HASH.80.full_path?type=files','#container')" />
			<button image="24_articles.gif"   name="articles"  alt="Работа со статьями"        onClick="Go('$OBJECTS_HASH.80.full_path?type=article','#container')" />
			<button image="24_category.gif"   name="articles"  alt="Работа с категориями"      onClick="Go('$OBJECTS_HASH.80.full_path?type=category','#container')" />
			<button image="24_divider.gif" />
		^if(def $form:action && $form:action ne 'config'){
			<button image="24_save.gif"    name="save"      alt="Сохранить" onClick="saveForm('form_content','${OBJECTS_HASH.80.full_path}?type=$form:type','#container')" />
			<button image="24_retype.gif"  name="retype"    alt="Сбросить"  onClick="resetForm()" />
			<button image="24_cancel.gif"  name="cancel"    alt="Отменить"  onClick="Cancel('$OBJECTS_HASH.80.full_path?type=$form:type')" />
		}
	</buttons>]
	^switch[$form:type]{
		^case[article]{$result[$result^executeSystemProcess[$.id[5] $.param[article]]]}
		^case[category]{$result[$result^executeSystemProcess[$.id[5] $.param[category]]]}
		^case[DEFAULT]{$_jMethod[$[$form:type]]$result[$result^#OA^_jMethod[]]}
	}
$result[$result ^#OA</block_content>]
#end @mControlRun[hParams]



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



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ САЙТАМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление сайтами
@sites[][hAction]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data" 
	label="MOUSE CMS | Сайты | $hAction.label | $SITES_HASH.[$form:id].name ">
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="text"   name="name"           label="Название"   description="Имя сайта"              class="long">$SITES_HASH.[$form:id].name</field>
		<field type="text"   name="domain"         label="Домен"      description="Доменное имя"           class="medium">$SITES_HASH.[$form:id].domain</field>
		<field type="select" name="lang_id"        label="Язык"       description="Язык сайта"             class="short"><option value="1">Русский</option></field>
	^if($hAction.i & 1){
		<field type="select" name="e404_object_id" label="Ошибки"     description="Страница ошибок"        class="medium">
			<system:method name="list">name[OBJECTS]added[select="$SITES_HASH.[$form:id].e404_object_id"]tag[option]</system:method>
		</field>
	}
		<field type="text"   name="cache_time"     label="Кэш"        description="Время кэширования (сек)" class="short">$SITES_HASH.[$form:id].cache_time</field>
		<field type="text"   name="sort_order"     label="Сортировка" description="Порядок сортировки"      class="short">$SITES_HASH.[$form:id].sort_order</field>
	^if($hAction.i & 6){
		<field type="hidden" name="action">insert</field>
	}
	^if($hAction.i & 1){
		<field type="hidden" name="action">update</field>
		<field type="hidden" name="site_id">$form:id</field>
		<field type="hidden" name="where">site_id</field>
	}
		<field type="hidden" name="tables">
			^$.main[m_site]
		</field>
		<field type="hidden" name="cache">sites</field>
	</tab>
	</tabs>
	</form>
}{
	^drawList[
		$.data[$SITES]
		$.names[^table::create{name	id	object
ID	id	
Название	name	
Домен	domain	
Время кэша	cache_time	
Страница Ошибок	e404_object_id	OBJECTS_HASH
}]
		$.description[
			Язык: $SITES.lang_id <br />
			Сортировка: $SITES.sort_order
		]
		$.added[
			<field type="hidden" name="where">site_id</field>
			<field type="hidden" name="cache">sites</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_site]
			</field>
		]
		$.where[site_id]
		$.label[Mouse CMS | Сайты]
	]
}
#end @sites[]



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ ОБЪЕКТАМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление объектами
@objects[][hAction;path;is_published;description;name;document_name;window_name;parent_id]
^if(def $form:action){

# -----------------------------------------------------------------------------------------------
# 	Работа с блоками объекта
	^if($form:action eq 'blocks'){$result[
		<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
		label="MOUSE CMS | Объекты | Управление блоками объекта | $OBJECTS_HASH.[$form:id].name ">
		<tabs>
		<tab id="section-1" name="Блоки объекта $OBJECTS_HASH.[$form:id].name">

#			параметры SQL запроса
			<field type="hidden" name="object_id">$form:id</field>
			<field type="hidden" name="tables">
				^$.main[m_block_to_object]
			</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="where">object_id</field>

			$BLOCK_TO_OBJECT[^getBLOCKS_TO_OBJECT[]]
			^BLOCK_TO_OBJECT.append{9	none	1	0} 
			<field type="none" label="$OBJECTS_HASH.[$form:id].name" description="Блоки объекта">
			<br/><br/>
			<br/>Mode: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Sort_order: &nbsp^; &nbsp^; &nbsp^; &nbsp^; Name:<br/>
# 			объекту можно присвоить до 10 блоков =debug
			^for[iCount](0;9){
				^if(^BLOCK_TO_OBJECT.count[] > $iCount){^BLOCK_TO_OBJECT.offset[set]($iCount)}
				<input  name="mode_$iCount" value="$BLOCK_TO_OBJECT.mode" class="input-text-short"/>
				<input  name="sort_order_$iCount" value="$BLOCK_TO_OBJECT.sort_order" class="input-text-short"/>
				<select name="block_id_$iCount" class="long">
					<option value="0">none</option>
					<system:method name="list">name[BLOCKS]added[select="$BLOCK_TO_OBJECT.id"]tag[option]</system:method>
				</select>
				<br/>
			}
			</field>
			<field type="none">
			</field>
		</tab>
		</tabs>
		</form>
	]}
# -----------------------------------------------------------------------------------------------

	$hAction[^mGetAction[$form:action]]
	^if($hAction.i & 1){
		$path[$OBJECTS_HASH.[$form:id].path]
		$is_published[$OBJECTS_HASH.[$form:id].is_published]
		$description[$OBJECTS_HASH.[$form:id].description]
	}
	^if($hAction.i & 3){
		$name[$OBJECTS_HASH.[$form:id].name]
		$document_name[$OBJECTS_HASH.[$form:id].document_name]
		$window_name[$OBJECTS_HASH.[$form:id].window_name]
		$parent_id[$OBJECTS_HASH.[$form:id].parent_id]
	}
	^if($hAction.i & 4){$parent_id[$form:id]}
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Объекты | $hAction.label | $OBJECTS_HASH.[$form:id].name ">
		<tabs>
			<tab id="section-1" name="Основное">
				^if($hAction.i & 1){
					<field type="none"     name="object_id"     label="ID"           description="ID объекта">$OBJECTS_HASH.[$form:id].id</field>
				}
				<field type="text"     name="name"          label="Имя"          description=" Имя объекта "           class="medium">
					$name
				</field>
				<field type="text"     name="document_name" label="Название"     description=" Имя документа "         class="long"  >
					$document_name
				</field>
				<field type="text"     name="window_name"   label="Окно"         description=" Оконное имя: "          class="long"  >
					$window_name
				</field>
				<field type="text"     name="path"          label="Путь"         description="Имя файла/каталога (example, example.html)" class="medium">
					$path
				</field>
				<field type="text"     name="cache_time"    label="Кэш"          description="Время кэширования (сек)" class="short" >
					$OBJECTS_HASH.[$form:id].cache_time
				</field>
				<field type="text"     name="sort_order"    label="Порядок"      description="Порядок сортировки"      class="short" >
					$OBJECTS_HASH.[$form:id].sort_order
				</field>
				<field type="checkbox" name="is_published"  label="Опубликовать" description="">$is_published</field>
				<field type="select" name="parent_id"       label="Предок"       description="Родительский объект"     class="medium">
					<option id="0" value="0" select="$parent_id">Корневое пространство</option>
					<system:method name="list">name[OBJECTS]added[select="$parent_id"]tag[option]</system:method>
				</field>
				<field type="select" name="template_id" label="Шаблон" description="Шаблон дизайна объекта" class="medium">
					<option id="0" value="0" select="$OBJECTS_HASH.[$form:id].template_id">Не задан</option>
					<system:method name="list">name[TEMPLATES]added[select="$OBJECTS_HASH.[$form:id].template_id"]tag[option]</system:method>
				</field>
				<field type="textarea" name="description"   label="Описание"     description="Описание объекта">$description</field>
			</tab>
			<tab id="section-2" name="Дополнительное">
				^if($hAction.i & 1){
					<field type="none" name="full_path" label="Полный путь" description="От корня сайта">$OBJECTS_HASH.[$form:id].full_path</field>
				}
				<field name="thread_id" label="Ветвь объекта" description="" type="none">$OBJECTS_HASH.[$OBJECTS_HASH.[$form:id].thread_id].name</field>
				<field type="checkbox" name="is_show_on_sitemap" label="Карта" description="Показывать на карте сайта">$OBJECTS_HASH.[$form:id].is_show_on_sitemap	</field>
				<field type="checkbox" name="is_show_in_menu" label="Меню" description="Показывать в меню">$OBJECTS_HASH.[$form:id].is_show_in_menu</field>
				<field type="text" name="url" label="URL" description="Объект ссылка" class="long">$OBJECTS_HASH.[$form:id].url</field>
				<field type="select" name="site_id" description="Сайт объекта" label="Сайт" class="medium">
					<system:method name="list">name[SITES]added[select="$OBJECTS_HASH.[$form:id].site_id"]tag[option]</system:method>
				</field>
				<field type="select" name="object_type_id" description="Тип объекта" label="Тип" class="long">
					<system:method name="list">name[TYPES]added[select="$OBJECTS_HASH.[$form:id].object_type_id"]tag[option]</system:method>
				</field>
				<field type="select" name="data_process_id" description="Обработчик объекта" label="Обработчик" class="medium">
					<option id="0" value="0" select="$OBJECTS_HASH.[$form:id].data_process_id">отсутствует</option>
					<system:method name="list">name[PROCESSES]added[select="$OBJECTS_HASH.[$form:id].data_process_id"]tag[option]</system:method>
				</field>
				<field type="select" name="link_to_object_id" description="Подменить содержимое, содержимым выбранного объекта" label="Ссылка"  class="medium">
					<option id="0" value="0" select="$OBJECTS_HASH.[$form:id].link_to_object_id">не подменять</option>
					<system:method name="list">name[OBJECTS]added[select="$OBJECTS_HASH.[$form:id].link_to_object_id"]tag[option]</system:method>
				</field>
			</tab>
			<tab id="section-3" name="Атрибуты">
				^if($hAction.i & 1){
					<field name="dt_update" label="Изменен" description="Дата последнего редактирования" type="none">$OBJECTS_HASH.[$form:id].dt_update</field>
					<field name="auser_id" label="Владелец" description="Логин редактировавшего" type="none">$USERS_HASH.[$OBJECTS_HASH.[$form:id].auser_id].name</field>
				}
				$hRights[^getHashRights($OBJECTS_HASH.[$form:id].rights)]
				<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
				<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
				<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
#				<field type="text" name="rights" label="rights" description="Маска прав на объект" class="short">$OBJECTS_HASH.[$form:id].rights</field>
				<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
				<field type="hidden" name="auser_id">$MAIN:objAuth.user.id</field>
				^if($hAction.i & 6){
					<field type="hidden" name="action">insert</field>
				}
				^if($hAction.i & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">object_id</field>
				<field type="hidden" name="object_id">$form:id</field>
				}
				<field type="hidden" name="tables">
					^$.main[m_object]
				</field>
				<field type="hidden" name="cache">objects</field>
			</tab>
		</tabs>
	</form>
	}{
		<button image="24_object_blocks.gif"   name="object_blocks"   alt="Блоки объекта" onClick="CopyChecked('$OBJECTS_HASH.80.full_path?type=$form:type&amp^;action=blocks')" />
		^drawList[
			$.data[$OBJECTS]
			$.names[^table::create{name	id	object
ID	id
Название	name
Тип	object_type_id	TYPES_HASH
Полный путь	full_path	
Сайт	site_id	SITES_HASH
Родитель	parent_id	OBJECTS_HASH
Обработчик	data_process_id	PROCESSES_HASH
Шаблон	template_id	TEMPLATES_HASH
Время кэша	cache_time
}]
			$.description{
				Имя документа: $_tData.document_name <br />
				Оконное имя: $_tData.window_name <br />
				Описание: $_tData.description <br />
				<hr/>
				Ветвь объекта: $OBJECTS_HASH.[$_tData.thread_id].name,
				rights: $_tData.rights, Порядок сортировки: $_tData.sort_order,
				Путь: $_tData.path <br/>
				Флажки: 
					^if(^_tData.is_show_on_sitemap.int(0)){SM }
					^if(^_tData.is_show_in_menu.int(0)){Mn }
					^if(^_tData.is_published.int(0)){Pb } 
				Изменен: $_tData.dt_update <br/>
				Владелец: $USERS_HASH.[$_tData.auser_id].name <br/>
				^if(def $_tData.url){Объект-ссылка: $_tData.url }
				^if(^_tData.link_to_object_id.int(0)){Блоки объекта: $_tData.link_to_object_id }
			}
			$.added[
				<field type="hidden" name="cache_time">0</field>
				<field type="hidden" name="where">object_id</field>
				<field type="hidden" name="cache">objects</field>
				<field type="hidden" name="action">delete</field>
				<field type="hidden" name="tables">
					^$.main[m_object]
					^$.connect[m_block_to_object]
				</field>
			]
			$.where[object_id]
			$.label[Mouse CMS | Объекты]
		]
}
#end @objects[]



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ БЛОКАМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление блоками
@blocks[][hAction]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Блоки | $hAction.label | $BLOCKS_HASH.[$form:id].name ">
		<tabs>
			<tab id="section-1" name="Основное">
				^if($hAction.i & 1){
					<field type="none"  name="block_id" label="ID" description="ID блока">$BLOCKS_HASH.[$form:id].id</field>
				}
				<field type="text"     name="name"          label="Имя"          description="Название блока" class="medium">
					$BLOCKS_HASH.[$form:id].name
				</field>
				<field type="checkbox" name="is_published"  label="Опубликовать">$BLOCKS_HASH.[$form:id].is_published</field>
				<field type="select" name="data_process_id" label="Обработчик" description="Обработчик блока">
					<option id="0" value="0" select="$BLOCKS_HASH.[$form:id].data_process_id">отсутствует</option>
^PROCESSES.menu{
					<option id="$PROCESSES.id" value="$PROCESSES.id" select="$BLOCKS_HASH.[$form:id].data_process_id">$PROCESSES.name</option>
}
				</field>
				<field type="textarea" name="description"   label="Описание"  description="Описание блока" >$BLOCKS_HASH.[$form:id].description</field>
			</tab>
			<tab id="section-2" name="Дополнительное">
				<field type="checkbox" name="is_parsed_manual" label="Ручной вызов">$BLOCKS_HASH.[$form:id].is_parsed_manual</field>
				<field type="checkbox" name="is_shared" label="Общий блок">$BLOCKS_HASH.[$form:id].is_parsed_manual</field>
				<field type="textarea" name="attr" label="Атрибуты" description="Атрибуты блока">$BLOCKS_HASH.[$form:id].attr</field>
				<field type="select" name="data_type_id" label="Данные" description="Тип данных блока">
^DATA_TYPES.menu{
					<option id="$DATA_TYPES.id" value="$DATA_TYPES.id" select="$BLOCKS_HASH.[$form:id].data_type_id">$DATA_TYPES.name</option>
}
				</field>
			</tab>
			<tab id="section-3" name="Данные">
				<field type="textarea" name="data" label="Данные" ws="true" description="Данные блока">$BLOCKS_HASH.[$form:id].data</field>
			</tab>
		</tabs>
		^if($hAction.i & 6){
					<field type="hidden" name="action">insert</field>
		}
		^if($hAction.i & 1){
			<field type="hidden" name="action">update</field>
			<field type="hidden" name="where">block_id</field>
			<field type="hidden" name="block_id">$form:id</field>
		}
		<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
		<field type="hidden" name="cache">blocks</field>
		<field type="hidden" name="tables">
			^$.main[m_block]
		</field>
	</form>
	$SYSTEM.postProcess(0)
}{
$IS_SHARED[
	$.1[$.name[общий]]
	$.0[$.name[]]
]
	^drawList[
		$.data[$BLOCKS]
		$.names[^table::create{name	id	object
ID	id
Название	name
^if($form:mode ne 'picker'){Тип	is_shared	IS_SHARED
Обработчик	data_process_id	PROCESSES_HASH
Тип данных	data_type_id	DATA_TYPES_HASH
}{Описание:	description}
}]
		$.description{
			Описание: $_tData.description <br/>
			^if($_tData.is_not_empty){Содержит данные <br/>}
			^if($_tData.is_published){Опубликован <br/>}
			Изменен: $_tData.dt_update <br/>
			Атрибуты: $_tData.attr <br/>
		}
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">block_id</field>
			<field type="hidden" name="cache">blocks</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_block]
				^$.connect[m_block_to_object]
			</field>
		]
		$.where[block_id]
		$.label[Mouse CMS | Блоки]
	]
}
#end @blocks[]



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ ОБРАБОТЧИКАМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление обработчиками
@process[][hAction]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Обработчики | $hAction.label | $PROCESSES_HASH.[$form:id].name ">
	<tabs>
		<tab id="section-1" name="Основное">
			^if($hAction.i & 1){
				<field type="none"  name="data_process_id" label="ID" description="ID обработчика">$PROCESSES_HASH.[$form:id].id</field>
			}
			<field type="text" name="name" label="Имя" description="Имя обработчика" class="long">$PROCESSES_HASH.[$form:id].name</field>
			<field type="text" name="filename" label="Процесс" description=" Имя файла обработчика">$PROCESSES_HASH.[$form:id].filename</field>
			<field type="text" name="sort_order" label="Порядок" description="Сортировка">$PROCESSES_HASH.[$form:id].sort_order</field>
			<field type="select" name="data_process_type_id" label="Тип" description="Тип обработчика" class="long">
				<system:method name="list">name[DATA_PROCESS_TYPES]tag[option]added[select="$PROCESSES_HASH.[$form:id].data_process_type_id"]</system:method>
			</field>
			<field type="textarea" name="description" label="Описание" description="Функциональность обработчика">$PROCESSES_HASH.[$form:id].description</field>
			^if($hAction.i & 6){
				<field type="hidden" name="action">insert</field>
			}
			^if($hAction.i & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">data_process_id</field>
				<field type="hidden" name="data_process_id">$form:id</field>
			}
			<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="cache">process</field>
			<field type="hidden" name="tables">
				^$.main[m_data_process]
			</field>
		</tab>
	</tabs>
	</form>
}{
	^drawList[
		$.names[^table::create{name	id	object
ID	id
Название	name
Имя файла	filename
Тип данных	data_process_type_id	DATA_PROCESS_TYPES_HASH
}]
		$.data[$PROCESSES]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">data_process_id</field>
			<field type="hidden" name="cache">process</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_data_process]
			</field>
		]
		$.where[data_process_id]
		$.description{
			Описание: $_tData.description <br/>
			Изменен: $_tData.dt_update <br/>
			Сортировка: $_tData.sort_order <br/>
		}
		$.label[Mouse CMS | Обработчики]
	]
}
#end @process[]



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ ШАБЛОНАМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление шаблонами
@templates[][hAction]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Шаблоны | $hAction.label | $TEMPLATES_HASH.[$form:id].name ">
	<tabs>
		<tab id="section-1" name="Основное">
			^if($hAction.i & 1){
				<field type="none"  name="template_id" label="ID" description="ID шаблона">$TEMPLATES_HASH.[$form:id].id</field>
			}
			<field type="text" name="name"       label="Имя"        description="Имя шаблона">$TEMPLATES_HASH.[$form:id].name</field>
			<field type="text" name="filename"   label="Шаблон"     description=" Имя файла шаблона"  class="medium">$TEMPLATES_HASH.[$form:id].filename</field>
			<field type="text" name="params"     label="Файл стиля" description=" Имя файла стиля"  class="medium">$TEMPLATES_HASH.[$form:id].params</field>
			<field type="text" name="sort_order" label="Порядок"    description="Сортировка" class="short">$TEMPLATES_HASH.[$form:id].sort_order</field>
			<field type="textarea" name="description" label="Описание" description="Функциональность шаблона">$TEMPLATES_HASH.[$form:id].description</field>
			^if($hAction.i & 6){
				<field type="hidden" name="action">insert</field>
			}
			^if($hAction.i & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">template_id</field>
				<field type="hidden" name="template_id">$form:id</field>
			}
			<field type="hidden" name="dt_update">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="cache">templates</field>
			<field type="hidden" name="tables">
				^$.main[m_template]
			</field>
		</tab>
	</tabs>
	</form>
}{
	^drawList[
		$.names[^table::create{name	id	object
ID	id
Название	name
Имя файла	filename
Имя файла стиля	params
}]
		$.data[$TEMPLATES]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">template_id</field>
			<field type="hidden" name="cache">templates</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_template]
			</field>
		]
		$.where[template_id]
		$.description{
			Описание: $_tData.description <br/>
			Изменен: $_tData.dt_update <br/>
		}
		$.label[Mouse CMS | Шаблоны]
	]
}
#end @templates[]



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ ПОЛЬЗОВАТЕЛЯМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление пользователями
@users[][hAction;hRights]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	^if($hAction.i & 2){$USERS_HASH.[$form:id].name[]}
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Пользователи и группы | $hAction.label | $USERS_HASH.[$form:id].name ">
	<tabs>
		<tab id="section-1" name="Основное">
			^if($hAction.i & 1){
				<field type="none"  name="auser_id" label="ID" description="ID пользователя" class="short">$USERS_HASH.[$form:id].id</field>
			}
			<field type="text" name="name" label="Имя" description="Имя пользователя" class="medium">$USERS_HASH.[$form:id].name</field>
			<field type="select" name="auser_type_id" label="Тип" description="Тип пользователя" class="medium">
				<option value="0" select="$USERS_HASH.[$form:id].auser_type_id">Пользователь</option>
				<option value="1" select="$USERS_HASH.[$form:id].auser_type_id">Группа</option>
				<option value="2" select="$USERS_HASH.[$form:id].auser_type_id">Владелец</option>
			</field>
			<field type="text" name="email" label="E-Mail" description="Электронная почта" class="medium">$USERS_HASH.[$form:id].email</field>
			<field type="checkbox" name="is_published" label="Опубликовать" description="" class="medium">$USERS_HASH.[$form:id].is_published</field>
			<field type="textarea" name="description" label="Описание" description="Описание пользователя">$USERS_HASH.[$form:id].description</field>
			<field type="text" name="passwd" label="Пароль" description="Установить (сменить) пароль" class="medium"></field>
		</tab>
		<tab id="section-3" name="Атрибуты">
			<field type="select" name="auth_parent_id" label="Группа" description="Группа пользователя" class="medium">
				<option value="0" select="$GROUPS_HASH.[$form:id].parent_id">none</option>
				^USERS.menu{^if($USERS.auser_type_id == 1){
					<option value="$USERS.id" select="$GROUPS_HASH.[$form:id].parent_id">$USERS.name</option>
				}}
			</field>
			$hRights[^getHashRights($USERS_HASH.[$form:id].rights)]
			<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
			<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
			<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
			<field type="checkbox" name="rights_comment" label="Комментарии" description="Права по умолчанию">$hRights.comment</field>
			<field type="checkbox" name="rights_supervisory" label="Может все" description="Права по умолчанию">$hRights.supervisory</field>
			^if($hAction.i & 6){
			<field type="hidden" name="action">insert</field>
			<field type="hidden" name="dt_register">^MAIN:dtNow.sql-string[]</field>
			}
			^if($hAction.i & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">auser_id</field>
				<field type="hidden" name="auser_id">$form:id</field>
			}
			<field type="hidden" name="cache">users</field>
			<field type="hidden" name="tables">
				^$.main[auser]
			</field>
		</tab>
	</tabs>
	</form>
}{
		^drawList[
		$.names[^table::create{name	id	object
ID	id
Имя	name
Тип	auser_type_id	USERS_TYPES_HASH
Права	rights
E-mail	email
Вход	dt_logon
Выход	dt_logout
Событие	event_type
}]
		$.data[$USERS]
		$.added[
			<field type="hidden" name="cache_time">0</field>
			<field type="hidden" name="where">auser_id</field>
			<field type="hidden" name="cache">users</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[auser]
				^$.connect[asession]
				^$.connect2[aevent_log]
				^$.connect3[acl]
			</field>
		]
		$.where[auser_id]
		$.description{
			Описание: $_tData.description <br/>
			Зарегистрировался: $_tData.dt_register <br/>
			Последний доступ: $_tData.dt_access <br/>
		}
		$.label[Mouse CMS | Пользователи и группы]
	]
}
#end @users[]



# -----------------------------------------------------------------------------------------------
#                                    УПРАВЛЕНИЕ ПРАВАМИ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Управление правами
@rights[][hAction;hRights]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Управление правами | $hAction.label  ">
	<tabs>
		<tab id="section-1" name="Основное">
			<field type="select" name="object_id" label="Объект" description="Выбор объекта" class="medium">
				<system:method name="list">name[OBJECTS]tag[option]added[select="$ACL_HASH.[$form:id].object_id"]</system:method>
			</field>
			<field type="select" name="auser_id" label="Пользователь(группа)" description="Выбор пользователя" class="medium">
				<system:method name="list">name[USERS]tag[option]added[select="$ACL_HASH.[$form:id].auser_id"]</system:method>
			</field>
			$hRights[^getHashRights($ACL_HASH.[$form:id].rights)]
			<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
			<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
			<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
			<field type="checkbox" name="rights_comment" label="Комментарии" description="Права по умолчанию">$hRights.comment</field>
			<field type="checkbox" name="rights_supervisory" label="Может все" description="Права по умолчанию">$hRights.supervisory</field>
			^if($hAction.i & 6){
			<field type="hidden" name="action">insert</field>
			}
			^if($hAction.i & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">acl_id</field>
				<field type="hidden" name="acl_id">$form:id</field>
			}
			<field type="hidden" name="cache">acl</field>
			<field type="hidden" name="tables">
				^$.main[acl]
			</field>
		</tab>
	</tabs>
	</form>
}{
^drawList[
		$.names[^table::create{name	id	object
Объект	object_id	OBJECTS_HASH
Пользователь(группа)	auser_id	USERS_HASH
Права	rights
}]
		$.data[$ACL]
		$.added[
			<field type="hidden" name="where">acl_id</field>
			<field type="hidden" name="cache">acl</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[acl]
			</field>
		]
		$.where[acl_id]
		$.label[Mouse CMS | Управление правами ]
	]
}
#end @rights[]



# -----------------------------------------------------------------------------------------------
#                                    ОТЛАДКА СИСТЕМЫ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Строим таблицу запрошенных объектов
@config[]
<button image="24_clear.gif"  name="clear"    alt="Очистить кэш"  onClick="saveForm('form_content','${OBJECTS_HASH.80.full_path}?type=$form:type','#container')" />
<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data" 
label="MOUSE CMS | Отладка системы ">
	<field type="hidden" name="cache">all</field>
	<field type="hidden" name="cache_time">all</field>
</form>
#end @config[]



# -----------------------------------------------------------------------------------------------
#                                    ЗАГРУЗКА ФАЙЛОВ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Загружаем файлы
@files[]
<form method="post" action="/ajax/go.html" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Загрузка файлов ">
	<tabs>
		<tab id="section-1" name="Загрузка файлов">
			<field type="hidden" name="object_id" />
			<input type="text" name="object_name" class="input-text-medium" />
			<img src="/themes/mouse/icons/16_select.gif"    title="Выбрать" alt="x" class="input-image" onClick="pickObject('$OBJECTS_HASH.84.full_path?type=blocks&amp^;mode=picker&amp^;elem=block_id_$BLOCK_TO_OBJECT.id')" />
		</tab>
	</tabs>
</form>
#end files[]



#################################################################################################
#                                    ВЫВОД ДАННЫХ                                               #
#################################################################################################
# -----------------------------------------------------------------------------------------------
#                                  СПИСОК ОБЪЕКТОВ
# -----------------------------------------------------------------------------------------------
#################################################################################################
# Строим таблицу запрошенных объектов
@drawList[hParams]
^if(def $form:find){$hParams.data[^hParams.data.select(^hParams.data.name.match[$form:find][i])]}
^if(def $form:order){
	^if(^hParams.data.[$form:order].int(0)){
		^hParams.data.sort($hParams.data.[$form:order])
	}{
		^hParams.data.sort{$hParams.data.[$form:order]}
	}
}
^if(def $form:filter){
	$_tParam[$form:filter]
	$_tParam[^_tParam.split[=]]
	$_sParam[^_tParam.piece.trim[]]
	^_tParam.offset(1)
	$hParams.data[^hParams.data.select($hParams.data.[$_sParam] eq ^_tParam.piece.trim[])]
}
$scroller[^scroller::create[
	$.path_param[page]
	$.request[]
	$.table_count(^hParams.data.count[])
	$.number_per_section(^form:number.int(20))
	$.section_per_page(5)
	$.type[page]
	$.r_selector[ next ]
	$.l_selector[ prev ]
	$.divider[ ]
	$.r_divider[^]]
	$.l_divider[^[]
]]
$_tData[^table::create[$hParams.data;$.limit($scroller.limit) $.offset($scroller.offset)]]
<form name="form_content" method="post" action="/ajax/go.html" label="$hParams.label">
	<button image="24_add.gif"    name="add"    alt="Добавить"   onClick="Go('$OBJECTS_HASH.80.full_path?type=$form:type&amp^;action=add','#container')" />
	<button image="24_copy.gif"   name="copy"   alt="Копировать" onClick="CopyChecked('$OBJECTS_HASH.80.full_path?type=$form:type&amp^;action=copy')" />
	<button image="24_delete.gif" name="delete" alt="Удалить"    onClick="DeleteChecked('$hParams.where','${OBJECTS_HASH.80.full_path}?type=$form:type','#container')" />
<table class="table-builder-spreadsheet">
	<thead class="table-builder-spreadsheet">
		<tr>
   		<td>
   			<div style="padding: 0px; margin: 0px;">
				<input type="checkbox" name="check_main" class="input-checkbox" onClick="checkAll();markAll()" />
				<span style="cursor: default;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}">
				</span>
				</div>
			</td>
			^hParams.names.menu{
			<![CDATA[<th onDblClick="Go('$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'order'){}{$key=$value&}}order=$hParams.names.id', '#container')" id="$hParams.names.id">$hParams.names.name</th>]]>
			}
		</tr>
	</thead>
	<tbody class="table-builder-spreadsheet">
	^_tData.menu{
		<tr id="tr_${_tData.id}"  onDblClick="doEdit('$MAIN:sPath?action=edit&amp^;type=$form:type&amp^;id=$_tData.id','#container')">
      		<td>
         		<div style="padding: 0px^; margin: 0px^;">
						<input type="checkbox" name="check_${_tData.id}" class="input-checkbox" onClick="markRow(${_tData.id})" />
						<span style="cursor: default^;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}">
						</span>
					</div>
					^if(def $hParams.description){<div class="div-system-info" id="sysinfo_$_tData.id">^process{$hParams.description}</div>}
				</td>
			^hParams.names.menu{
				<td onClick="doMark(${_tData.id})" >
      			<span onClick="setFilter('$hParams.names.id', '${_tData.[$hParams.names.id]}')" class="arrow" onMouseover="ShowLocate('sysinfo_$_tData.id', event)" onMouseout="Hide('sysinfo_$_tData.id')">
      				^if(def $hParams.names.object){
      					$[$hParams.names.object].[${_tData.[$hParams.names.id]}].name
      				}{
							$_tData.[$hParams.names.id]
      				}
      			</span>
				</td>
			}
		</tr>
	}
	</tbody>
	<tfoot class="table-builder-spreadsheet">
		<tr id="space"><td colspan="100"></td></tr>
		<tr id="pages">
			<td colspan="100">
				^scroller.optimize[<div class="scroller">^scroller.draw[]</div>]
			</td>
		</tr>
			<tr id="perpage">
				<td colspan="100">
					<div class="form">
    						<label for="sys-perpage">Объектов на страницу:</label>
    						<input type="text" id="sys-perpage" name="sys_perpage" value="$scroller.limit" class="input-text-short" size="2" />
   						<![CDATA[<input type="button" value="Показать" class="input-button" onClick="Go('$SYSTEM.path?^form:fields.foreach[key;value]{^if($key ne 'number'){$key=$value&}}number=' + document.getElementsByName('sys_perpage')[0].value , '#container')" />]]>
					</div>
					<div class="total">Общее количество: $scroller.offset $_iTemp($scroller.offset + $scroller.limit) - $_iTemp (^hParams.data.count[]) </div>
				</td>
			</tr>
			<tr id="search">
				<td colspan="100">
					<div>
						<label for="sys-search">Поиск:</label>
    					<input type="text" id="sys-search" name="sys_svalue" value="$form:find" class="input-text-long" size="50" />
    					<![CDATA[<input type="button" class="input-button" value="Показать" 
						onClick="Go('$SYSTEM.path?^form:fields.foreach[key;value]{^if($key eq 'find' || $key eq 'filter'){}{$key=$value&}}find=' + escape(document.getElementsByName('sys_svalue')[0].value) + '&filter=' + document.getElementsByName('fquery')[0].value, '#container')" />]]>
					</div>
					<div>
    					<label for="sys-filter">Фильтр:</label>
    					<input type="text" name="fquery" value="$form:filter" class="input-text-long" size="30" readonly="readonly" />
    					<input type="hidden" name="sys_ffield" value="" />
    					<input type="hidden" name="sys_fvalue" value="" />
    					<img src="/themes/mouse/buttons/clear.gif" alt="x" class="input-image" onClick="clearFilter()" />
    					(чтобы установить фильтр нажмите на значение в таблице)
				</div>
			</td>
		</tr>
	</tfoot>
</table>
$hParams.added
</form>
#end @drawList[hParams]
