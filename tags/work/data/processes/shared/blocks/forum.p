^mForumRun[$lparams]



####################################################################################################
# Вывод данных
@mForumRun[hParams][crdMessageById;crdMessageByThread;hMessageThread]
<block_content>
	<forum parent_id="^form:id.int(0)" dt="$SYSTEM.date">
		<buttons>
			<button image="24_home.gif" name="forum_home" alt="Перейти к корневым сообщениям" href="$hObjectNow.full_path"/>
			<button image="24_configure.gif" name="forum_config" alt="Настройка форума" href="/forum/"/>
			<button image="24_search.gif" name="forum_search" alt="Поиск по форуму" onClick="^$('#forum_search').slideToggle('slow')" />
		</buttons>
^if(def $form:parent_id){^mAddMessage[]}
^if(def $form:id){
	$crdMessageById[^mLoader[
		$.action[message_by_id]
		$.t(1)
		$.where[
			forum_message_id = $form:id
			AND is_published = 1
	]]]
	^mPrintMessage[$crdMessageById.table]
	<button image="24_articles.gif"  name="forum_repeat"  alt="Ответить на сообщение" 
		onClick="^$('#forum_repeat').slideToggle('slow')^;
		document.form_forum_repeat.title.value = 'Re: $crdMessageById.table.title'" 
	/>
	<thread_id>$crdMessageById.table.thread_id</thread_id>
	$crdMessageByThread[^mLoader[
		$.action[message_by_thread]
		$.t(1)
		$.where[
			is_published = 1
			AND thread_id = ^crdMessageById.table.thread_id.int(0)
	]]]
}{
	<button image="24_edit.gif"  name="forum_new"  alt="Новое сообщение" onClick="^$('#forum_repeat').slideToggle('slow')" />
	^if(def $form:action && $form:action eq 'search'){
		$crdMessageByThread[^mLoader[
			$.action[message_by_thread]
			$.t(1)
			$.limit(20)
			$.where[
				is_published = 1
				^if(def $form:search){AND forum_message.title LIKE "%$form:search%" OR forum_message.body LIKE "%$form:search%"}
				^if(def $form:author){AND forum_message.author LIKE "%$form:author%"}
		]]]
	}{
		$crdMessageByThread[^mLoader[
			$.action[message_by_thread]
			$.t(1)
			$.limit(20)
			$.where[
				is_published = 1
				AND parent_id = 0
		]]]
	}
	$crdMessageByThread[^mLoader[
		$.action[message_by_thread]
		$.t(1)
		$.where[thread_id IN ( ^crdMessageByThread.table.menu{$crdMessageByThread.table.thread_id}[,] )]]]
}
^if(def $form:action && $form:action eq 'search'){
	^crdMessageByThread.table.menu{<forum_message id="$crdMessageByThread.table.id" title="$crdMessageByThread.table.title" author="$crdMessageByThread.table.author" dt="$crdMessageByThread.table.dt" is_empty="$crdMessageByThread.table.is_empty" />}
}{
	$hMessagesThread[^crdMessageByThread.table.hash[parent_id][$.distinct[tables]]]
	^ObjectByParent[$hMessagesThread;0;
		$.tag[forum_message]
		$.attributes[^table::create{name^#OAid^#OAtitle^#OAauthor^#OAdt^#OAis_empty}]
		$.id($form:id)
	]
}
	^form_engine[
		^$.tables[^$.main[forum_message]]
		^$.action[insert]
	]
	</forum>
</block_content>
#end @mForumRun[hParams]



#################################################################################################
# добавление сообщения в форум, здесь необходимо определять будущее ID
@mAddMessage[][iCount;tMessage]
^use[vforms.p]
$oForm[^vforms::init[
	$.oAuth[$MAIN:objAuth]
	$.oSql[$MAIN:objSQL]
	$.rights[$.logon(0)]
	$.log[/../data/log/forum.log]
]]
$iCount(^MAIN:objSQL.sql[int]{SELECT (COUNT(*)+1) FROM forum_message})
^oForm.hRequest.delete[id]
^if(!def $oForm.hRequest.thread_id){$oForm.hRequest.thread_id[$iCount]}
$oForm.hRequest.author[$MAIN:objAuth.user.name]
^if(!def $oForm.hRequest.author){$oForm.hRequest.author[Гость]}
^if(!def $oForm.hRequest.title){$oForm.hRequest.title[Без темы]}
$oForm.hRequest.is_published(1)
# раз уж сюда дошли то удалим весь кэш
^dir_delete[^MAIN:CacheDir.trim[end;/];$.is_recursive(1)]
# попытка выполнения действия
^oForm.go[]
^location[$hObjectNow.full_path?id=$iCount;$.is_external(1)]
#end @mAddMessage[][iCount;tMessage]



#################################################################################################
# вывод сообщения форума
@mPrintMessage[tMessage]
$result[
	<article>
		<date>^dtf:format[%d %B %Y;$tMessage.dt]</date>
		<name><a href="?id=$tArticles.id">$tMessage.title</a></name>
		<author>$tMessage.author</author>
		<body>$tMessage.body</body>
	</article>
]
#end @mPrintMessage[tMessage]



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
