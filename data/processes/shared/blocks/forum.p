^if($lparams.param.admin){^mForumAdmin[]}{^mForumAdmin[]}



####################################################################################################
# Вывод последних 15 сообщений форума
@mForumLast[hParams][result]
$result[
$hParams.body
<channel title="Mouse CMS - Forum" description="Mouse CMS - Форум" link="http://$SYSTEM.siteUrl/forum/" rsslink="http://$SYSTEM.siteUrl/forum/rss/" generator="Mouse CMS" webmaster="horneds@gmail.com" date="$SYSTEM.date"/>
<block_content>
$crdLastMessages[^mLoader[	^rem{ Получение данных }
	$.action[last_messages]
	$.t(1)
	$.limit(10)
]]
^crdLastMessages.list[	^rem{ Вывод данных }
	$.attr[$.id[id]$.name[title]$.author[author]$.is_empty[is_empty]$.date[dt]]
	$.value[body]
	$.added[uri="$hParams.param.uri"]
	$.tag[forum_last]
]
</block_content>
]
#end @mForumLast[hParams]



####################################################################################################
# Вывод форума
@mForumView[hParams][crdMessageById;crdMessageByThread;crdMessagesByThread]
# -----------------------------------------------------------------------------------------------
# если пришел submit - добавляем сообщение в БД
^if(def $form:submit){^mAddMessage[$crdMessageById.table.author]}
# -----------------------------------------------------------------------------------------------
$hParams.body
<block_content>
	<forum parent_id="^form:id.int(0)" dt="$SYSTEM.date">
		<buttons>
			<button image="24_home.gif" name="forum_home" alt="Перейти к корневым сообщениям" href="$hObjectNow.full_path"/>
			<button image="24_configure.gif" name="forum_config" alt="Настройка форума" onClick="forumhide()" />
			<button image="24_search.gif" name="forum_search" alt="Поиск по форуму" onClick="^$('#forum_search').slideToggle('slow')" />
		</buttons>
^if(def $form:id){
#	-----------------------------------------------------------------------------------------------
#	если пришел ID... загружаем курд сообщения
	$crdMessageById[^mLoader[
		$.action[message_by_id]
		$.t(1)
		$.where[
			forum_message_id = $form:id
			AND is_published = 1
	]]]
#	редактирование сообщения
	^if($form:action eq 'edit'){
		<param id="$form:id" title="$crdMessageById.table.title">$crdMessageById.table.body</param>
	}{
	<button image="24_edit.gif"  name="forum_repeat"  alt="Ответить на сообщение" onClick="ForumPost('^form:id.int(0)')" />
	}
	<thread_id>$crdMessageById.table.thread_id</thread_id>
#	если сообщение принадлежит текущему пользователю - пусть редактирует
	^if($MAIN:objAuth.is_logon && $crdMessageById.table.author eq $MAIN:objAuth.user.name){
		<button image="24_articles.gif"  name="forum_edit"  alt="Редактировать" onClick="ForumPost('^form:id.int(0)','postedit')"/>
	}
#	выводим сообщение
	<article in="1" date="$crdMessageById.table.dt" id="$crdMessageById.table.id" name="$crdMessageById.table.title" author="$crdMessageById.table.author">
		^crdMessageById.table.body.replace[^bbcode[]]
	</article>
#	загружаем ветвь сообщения
	$crdMessagesByThread[^mLoader[
		$.action[message_by_thread]
		$.t(1)
		$.where[
			is_published = 1
			AND thread_id = ^crdMessageById.table.thread_id.int(0)
	]]]
}{
#	-----------------------------------------------------------------------------------------------
#	если не пришел ID загружаем сообщения согласно запросу (по умолчанию 20 последних)
#	поиск:
	^if(def $form:action && $form:action eq 'search'){
		$crdMessageByThread[^mLoader[
			$.action[message_by_thread]
			$.t(1)
			$.s(15)
			$.where[
				is_published = 1
				^if(def $form:search){AND forum_message.title LIKE "%$form:search%" OR forum_message.body LIKE "%$form:search%"}
				^if(def $form:author){AND forum_message.author LIKE "%$form:author%"}
		]]]
	}{
#		-----------------------------------------------------------------------------------------------
#		загрузка по скроллеру
		$crdMessageByThread[^mLoader[
			$.action[message_by_thread]
			$.t(1)
			$.s(15)
			$.where[
				is_published = 1
				AND parent_id = 0
		]]]
	}
# 	-----------------------------------------------------------------------------------------------
#	загрузка всех полученных сообщений
	$crdMessagesByThread[^mLoader[
		$.action[message_by_thread]
		$.t(1)
		$.where[thread_id IN ( ^crdMessageByThread.table.menu{$crdMessageByThread.table.thread_id}[,] )]]]
#	<button image="24_edit.gif"  name="forum_new"  alt="Новое сообщение" onClick="^$('#forum_repeat').slideToggle('slow')" />
	<button image="24_edit.gif"  name="forum_new"  alt="Новое сообщение" onClick="ForumPost('^form:id.int(0)')" />
}
# -----------------------------------------------------------------------------------------------
# вывод результатов поиска
^if(def $form:action && $form:action eq 'search'){
	^crdMessageByThread.table.menu{<forum_message id="$crdMessageByThread.table.id" title="$crdMessageByThread.table.title" author="$crdMessageByThread.table.author" dt="$crdMessageByThread.table.dt" is_empty="$crdMessageByThread.table.is_empty" />}
}{
# -----------------------------------------------------------------------------------------------
# вывод дерева
	^crdMessagesByThread.tree[
		$.tag[forum_message]
		$.attributes[^table::create{name^#OAid^#OAtitle^#OAauthor^#OAdt^#OAis_empty}]
		$.id($form:id)
	]
}
	^form_engine[
		^$.tables[^$.main[forum_message]]
		^$.where[forum_message_id]
		^$.forum_message_id[$form:id]
		^if($form:action eq edit){^$.action[update]}{^$.action[insert]}
	]
#	вывод скроллера
	^if(!def $form:id){^crdMessageByThread.scroller[$.uri[$SYSTEM.path]$.tag[forum_scroller]]}
	</forum>
</block_content>
#end @mForumRun[hParams]



#################################################################################################
# добавление сообщения в форум
@mAddMessage[sAuthor][iCount;sLocation;result]
^use[vforms.p]
$oForm[^vforms::init[
	$.oAuth[$MAIN:objAuth]
	$.oSql[$MAIN:objSQL]
	$.rights[$.logon(0)]
]]
^if(def $oForm.hRequest.parent_id){
	$oForm.hRequest.author[$MAIN:objAuth.user.name]
	^if(!def $oForm.hRequest.author){$oForm.hRequest.author[Гость]}
	^if(!def $oForm.hRequest.title){$oForm.hRequest.title[Без темы]}
	$oForm.hRequest.is_published(1)
	$result[^oForm.go[$.last_insert_id(1)]]
#	новое сообщение - расчитываем thread_id
	^if(!$oForm.hRequest.thread_id){^MAIN:objSQL.void[UPDATE $oForm.hForm.param.tables.main SET thread_id = $result.last_insert_id WHERE forum_message_id = $result.last_insert_id ]}
	^location[$oForm.hForm.param.location?id=$result.last_insert_id;$.is_external(1)]
}{
	$result[^oForm.go[]]
	^location[$oForm.hForm.param.location?id=$oForm.hForm.param.forum_message_id;$.is_external(1)]
}
$result[]
#end @mAddMessage[sAuthor][iCount;sLocation;result]



#################################################################################################
# Загрузчик курдов
@mLoader[hParams][result]
$result[
	^curd::init[
		$.name[forum_message]
		$.where[$hParams.where]
		$.limit($hParams.limit)
		$.offset($hParams.offset)
		$.h($hParams.h)
		$.t($hParams.t)
		$.s($hParams.s)
		$.order[dt_published DESC]
		^switch[$hParams.action]{
			^case[message_by_id]{
				$.names[
					$.[forum_message.forum_message_id][id]
					$.[forum_message.parent_id][]
					$.[forum_message.thread_id][]
					$.[forum_message.title][]
					$.[forum_message.author][]
					$.[forum_message.email][]
					$.[DATE_FORMAT(forum_message.dt_published, '%e.%c.%y %H:%i')][dt]
					$.[forum_message.body][]
				]
			}
			^case[message_by_thread]{
				$.names[
					$.[forum_message.forum_message_id][id]
					$.[forum_message.parent_id][]
					$.[forum_message.thread_id][]
					$.[forum_message.title][]
					$.[forum_message.author][]
					$.[forum_message.email][]
					$.[DATE_FORMAT(forum_message.dt_published, '%e.%c.%y %H:%i')][dt]
					$.[IF(body IS NULL, 1, 0)][is_empty]
				]
			}
			^case[last_messages]{
				$.names[
					$.[forum_message.forum_message_id][id]
					$.[forum_message.title][]
					$.[forum_message.author][]
					$.[forum_message.body][]
					$.[DATE_FORMAT(forum_message.dt_published, '%e.%c.%y %H:%i')][dt]
					$.[IF(body IS NULL, 1, 0)][is_empty]
				]
			}
		}
	]
]
#end @mLoader[hParams][result]



#################################################################################################
# Преоразования bb кода
@bbcode[][result]
$result[^table::create{from	to
^taint[^#0A]	<br/>
[b]	<b>
[/b]	</b>
[i]	<i>
[/i]	</i>
[quote]	<blockquote>
[/quote]	</blockquote>
[code]	<code>
[/code]	</code>
}]
#end form_engine[sStr]



#################################################################################################
# Администрирование форума
@mForumAdmin[hParams][hAction;crdForum]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
#	загрузка данных
	$crdForum[^curd::init[
		$.name[forum_message]
		$.order[]
		$.names[
			$.[forum_message.forum_message_id][id]
			$.[forum_message.title][]
			$.[forum_message.thread_id][]
			$.[forum_message.is_published][]
			$.[forum_message.dt_published][]
			$.[forum_message.author][]
			$.[forum_message.body][]
		]
	$.h(1)
	]]
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
	^if($hAction.i & 7){
		$hAction.title[$crdForum.hash.[$form:id].title]
		$hAction.body[$crdForum.hash.[$form:id].body]
	}
	^if($hAction.i & 8){
		$hAction.title[^if(^form:id.int(0)){Re: $crdForum.hash.[$form:id].title}]
		$hAction.body[^if(^form:id.int(0) && def $crdForum.hash.[$form:id].body){[quote] $crdForum.hash.[$form:id].body [/quote]^#OA}]
	}
	^if($hAction.i & 16){
		^if($crdForum.hash.[$form:id].author ne $MAIN:objAuth.user.name){^throw[forum;Access deny]}
		$hAction.title[^if(^form:id.int(0)){$crdForum.hash.[$form:id].title}]
		$hAction.body[^if(^form:id.int(0) && def $crdForum.hash.[$form:id].body){$crdForum.hash.[$form:id].body}]
	}
	<form method="post" action="$crdObject.hash.6.full_path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Форум | $hAction.label" >
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="text" name="title" label="Название" description=" Заголовок сообщения " class="long">$hAction.title</field>
		^if($hAction.i & 7){<field type="checkbox" name="is_published"  label="Опубликовать">$crdForum.hash.[$form:id].is_published</field>}
		<field type="textarea" name="body" label="Текст"   description="Содержание сообщения">$hAction.body</field>
		^if($hAction.i & 14){<field type="hidden" name="dt_published">$SYSTEM.date</field>}
		^if($hAction.i & 8){
			<field type="hidden" name="parent_id">^form:id.int(0)</field>
			<field type="hidden" name="thread_id">^crdForum.hash.[^form:id.int(0)].thread_id.int(0)</field>
		}
		^if($hAction.i & 24){<field type="submit" name="submit" value="Отправить"/>}
	</tab>
	</tabs>
	^form_engine[
		^$.where[forum_message_id]
		^$.forum_message_id[$form:id]
		^$.tables[^$.main[forum_message]]
		^if($hAction.i & 24){^$.location[/close.html]}
		^if($form:action eq edit || $form:action eq postedit){^$.action[update]}{^$.action[insert]}
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
#end @mForumAdmin[][hAction;crdForum]



#################################################################################################
# Определение действия
@mGetAction[sTemp][result]
^switch[$sTemp]{
	^case[edit]{$result[$.i(1)$.label[Редактирование]]}
	^case[copy]{$result[$.i(2)$.label[Копирование]]}
	^case[add]{$result[$.i(4)$.label[Удаление]]}
	^case[post]{$result[$.i(8)$.label[Добавление сообщения]]}
	^case[postedit]{$result[$.i(16)$.label[Редактирование сообщения]]}
	^case[DEFAULT]{$result[$.i(0)$.label[]]}
}
#end @mGetAction[sTemp]