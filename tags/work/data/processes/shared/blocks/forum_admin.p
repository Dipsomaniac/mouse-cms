^forum[]


#################################################################################################
# управление статьями
@forum[][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
	$crdForum[^curd::init[
	$.name[forum_message]
	$.order[]
	$.names[
		$.[forum_message.forum_message_id][id]
		$.[forum_message.title][]
		$.[forum_message.is_published][]
		$.[forum_message.dt_published][]
		$.[forum_message.author][]
		$.[forum_message.body][]
	]
	$.h(1)
]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Форум | $hAction.label" >
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="text" name="title" label="Название" description=" Заголовок сообщения " class="long">$crdForum.hash.[$form:id].title</field>
		<field type="checkbox" name="is_published"  label="Опубликовать">$crdForum.hash.[$form:id].is_published</field>
		^if($hAction.i & 6){
			<field type="hidden" name="dt_published">$SYSTEM.date</field>
			<field type="hidden" name="author">$MAIN:objAuth.user.name</field>
		}
		</tab>
		<tab id="section-2" name="Содержание">
			<field type="textarea" name="body" ws="true"  label="Текст"   description="Содержание сообщения">$crdForum.hash.[$form:id].body</field>
		</tab>
	</tabs>
^form_engine[
	^$.where[forum_message_id]
	^$.forum_message_id[$form:id]
	^$.tables[^$.main[forum_message]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод статей
$crdForum[^curd::init[
	$.name[forum_message]
	$.order[]
	$.s(20)
	$.names[
		$.[forum_message.forum_message_id][id]
		$.[forum_message.title][]
		$.[forum_message.is_published][]
		$.[forum_message.dt_published][]
		$.[forum_message.author][]
	]
	$.t(1)
]]
$crdForum.table[^mFilter[$crdForum.table]]
<atable label="Mouse CMS | Форум ">
	^crdForum.draw[
		$.names[^table::create{name	id	object
ID	id
Название	title
Опубликована	is_published
Дата публикации	dt_published
Автор	author
}]]
	^added[]
^form_engine[
	^$.where[forum_message_id]
	^$.action[delete]
	^$.tables[^$.main[forum_message]]
]
^crdForum.scroller[$.uri[$SYSTEM.path]]
</atable>
}
#end @article[][hAction]