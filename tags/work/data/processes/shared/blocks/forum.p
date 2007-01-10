^bbcode[]
^if(def $lparams.param.last){^mForumLast[$lparams]}{^mForumView[$lparams]}



####################################################################################################
# Вывод последних 15 сообщений форума
@mForumLast[hParams]
$hParams.body
<channel title="Mouse CMS - Forum" description="Mouse CMS - Форум" link="http://$SYSTEM.siteUrl/forum/" rsslink="http://$SYSTEM.siteUrl/forum/rss/" generator="Mouse CMS" webmaster="horneds@gmail.com" date="$SYSTEM.date"/>
<block_content>
$crdLastMessages[^mLoader[
	$.action[last_messages]
	$.t(1)
	$.limit(10)
]]
^crdLastMessages.list[
	$.attr[$.id[id]$.name[title]$.author[author]$.is_empty[is_empty]$.date[dt]]
	$.value[body]
	$.added[uri="$hParams.param.uri"]
	$.tag[forum_last]
]
</block_content>
#end @mForumLast[hParams]



####################################################################################################
# Вывод данных
@mForumView[hParams][crdMessageById;crdMessageByThread;crdMessagesByThread]
$hParams.body
<block_content>
	<forum parent_id="^form:id.int(0)" dt="$SYSTEM.date">
		<buttons>
			<button image="24_home.gif" name="forum_home" alt="Перейти к корневым сообщениям" href="$hObjectNow.full_path"/>
			<button image="24_configure.gif" name="forum_config" alt="Настройка форума" href="/forum/"/>
			<button image="24_search.gif" name="forum_search" alt="Поиск по форуму" onClick="^$('#forum_search').slideToggle('slow')" />
		</buttons>
^if(def $form:id){
# -----------------------------------------------------------------------------------------------
# если пришел ID...
# загружаем курд сообщения
	$crdMessageById[^mLoader[
		$.action[message_by_id]
		$.t(1)
		$.where[
			forum_message_id = $form:id
			AND is_published = 1
	]]]
# редактирование сообщения
^if($form:action eq 'edit'){
	<param id="$form:id" title="$crdMessageById.table.title">$crdMessageById.table.body</param>
}{
<button image="24_edit.gif"  name="forum_repeat"  alt="Ответить на сообщение" 
		onClick="^$('#forum_repeat').slideToggle('slow')^;
		document.form_forum_repeat.title.value = 'Re: $crdMessageById.table.title'"
/>
}
<thread_id>$crdMessageById.table.thread_id</thread_id>
# если сообщение принадлежит текущему пользователю - пусть редактирует
^if($MAIN:objAuth.is_logon && $crdMessageById.table.author eq $MAIN:objAuth.user.name){
	<button image="24_articles.gif"  name="forum_edit"  alt="Редактировать" onClick="window.location='${SYSTEM.path}?id=$form:id&amp^;action=edit'"/>
}
# выводим сообщение
<article in="1" date="$crdMessageById.table.dt" id="$crdMessageById.table.id" name="$crdMessageById.table.title" author="$crdMessageById.table.author">
^crdMessageById.table.body.replace[$bbreplace]
</article>

# загружаем ветвь сообщения
$crdMessagesByThread[^mLoader[
	$.action[message_by_thread]
	$.t(1)
	$.where[
		is_published = 1
		AND thread_id = ^crdMessageById.table.thread_id.int(0)
]]]
}{
# -----------------------------------------------------------------------------------------------
# если не пришел ID загружаем сообщения согласно запросу (по умолчанию 20 последних)
# поиск:
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
# -----------------------------------------------------------------------------------------------
# загрузка по скроллеру
		$crdMessageByThread[^mLoader[
			$.action[message_by_thread]
			$.t(1)
			$.s(15)
			$.where[
				is_published = 1
				AND parent_id = 0
		]]]
	}
# -----------------------------------------------------------------------------------------------
# загрузка всех полученных сообщений
	$crdMessagesByThread[^mLoader[
		$.action[message_by_thread]
		$.t(1)
		$.where[thread_id IN ( ^crdMessageByThread.table.menu{$crdMessageByThread.table.thread_id}[,] )]]]
	<button image="24_edit.gif"  name="forum_new"  alt="Новое сообщение" onClick="^$('#forum_repeat').slideToggle('slow')" />
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
# -----------------------------------------------------------------------------------------------
# если пришел ID родителя - добавляем сообщение в БД
^if(def $form:parent_id){^mAddMessage[$crdMessageById.table.author]}
</block_content>
#end @mForumRun[hParams]



#################################################################################################
# добавление сообщения в форум, здесь необходимо определять будущее ID
@mAddMessage[sAuthor][iCount;sLocation]
^use[vforms.p]
$oForm[^vforms::init[
	$.oAuth[$MAIN:objAuth]
	$.oSql[$MAIN:objSQL]
	$.rights[$.logon(0)]
# =debug после отладки форума убрать логирование
	$.log[/../data/log/forum.log]
]]
$iCount(^MAIN:objSQL.sql[int]{SELECT (COUNT(*)+1) FROM forum_message})
^if(def $oForm.hRequest.action){
#	=debug проверка принадлежности редактируемой формы автору
	^if($MAIN:objAuth.is_logon && $sAuthor eq $MAIN:objAuth.user.name){}{^throw[forum;error]}
	^oForm.hRequest.delete[action]
	^oForm.hRequest.delete[parent_id]
	^oForm.hRequest.delete[thread_id]
	$sLocation[$SYSTEM.path?id=$oForm.hRequest.id]
}{
	$sLocation[$SYSTEM.path?id=$iCount]
	^if(!def $oForm.hRequest.thread_id){$oForm.hRequest.thread_id[$iCount]}
	$oForm.hRequest.author[$MAIN:objAuth.user.name]
	^if(!def $oForm.hRequest.author){$oForm.hRequest.author[Гость]}
	^if(!def $oForm.hRequest.title){$oForm.hRequest.title[Без темы]}
	$oForm.hRequest.is_published(1)
}
^oForm.hRequest.delete[id]
# раз уж сюда дошли то удалим весь кэш
^dir_delete[$MAIN:CacheDir;$.is_recursive(1)]
# попытка выполнения действия
^oForm.go[]
^location[$sLocation;$.is_external(1)]
#end @mAddMessage[][iCount]



#################################################################################################
# Загрузчик курдов
@mLoader[hParams]
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



#################################################################################################
# генерация полей параметров формы и поля секретности
@form_engine[sStr]
$sStr[^sStr.match[\s+][g]{}]
<input type="hidden" name="form_engine" value="$sStr"/>
<input type="hidden" name="form_security" value="^MAIN:security[$sStr]"/>
#end form_engine[sStr]



#################################################################################################
# Преоразования bb кода
@bbcode[]
$bbreplace[^table::create{from	to
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