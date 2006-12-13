^mForumRun[$lparams]



####################################################################################################
# Вывод данных
@mForumRun[hParams][tMessage;tMessages;hMessageThread]
<block_content>
	<forum parent_id="^form:id.int(0)" dt="^MAIN:dtNow.sql-string[]">
		<buttons>
			<button image="24_home.gif" name="forum_home" alt="Перейти к корневым сообщениям" href="$OBJECT.full_path"/>
			<button image="24_configure.gif" name="forum_config" alt="Настройка форума" href="/forum/"/>
			<button image="24_search.gif" name="forum_search" alt="Поиск по форуму" onClick="^$('#forum_search').slideToggle('slow')" />
		</buttons>
^if(def $form:action && $form:action eq 'insert'){^mAddMessage[]}
^if(def $form:id){
	$tMessage[^mGetMessage[$.id[$form:id]]]
	^mPrintMessage[$tMessage]
	<button image="24_articles.gif"  name="forum_repeat"  alt="Ответить на сообщение" 
		onClick="^$('#forum_repeat').slideToggle('slow')^;
		document.form_forum_repeat.title.value = 'Re: $tMessage.title'" 
	/>
	<thread_id>$tMessage.thread_id</thread_id>
	$tMessages[^mGetMessagesByThread[$.thread[$tMessage.thread_id]]]
}{
	<button image="24_edit.gif"  name="forum_new"  alt="Новое сообщение" onClick="^$('#forum_repeat').slideToggle('slow')" />
	^if(def $form:action && $form:action eq 'search'){
		$tMessages[^mGetMessagesByThread[$.thread[^mGetMessagesBySearch[$.author[$form:author]$.search[$form:search] $.limit(20)]]]]
	}{	$tMessages[^mGetMessagesByThread[$.thread[^mGetMessagesByParent[$.parent_id(0) $.limit(20)]]]]}
}
^if(def $form:action && $form:action eq 'search'){
	^tMessages.menu{<forum_message id="$tMessages.id" title="$tMessages.title" author="$tMessages.author" dt="$tMessages.dt" is_empty="$tMessages.is_empty" />}
}{
	$hMessagesThread[^tMessages.hash[parent_id][$.distinct[tables]]]
	^ObjectByParent[$hMessagesThread;0;
		$.tag[forum_message]
		$.attributes[^table::create{name^#OAid^#OAtitle^#OAauthor^#OAdt^#OAis_empty}]
		$.id($form:id)
	]
}
	</forum>
</block_content>
#end @mForumRun[hParams]



#################################################################################################
# добавление сообщения в форум, здесь необходимо определять будущее ID
@mAddMessage[][tMessage]
^use[ajax.p]
$oAjax[^ajax::init[
	$.oAuth[$MAIN:objAuth]
	$.oSql[$MAIN:objSQL]
	$.rights[$.logon(0)]
	$.log[/../data/log/forum.log]
]]
$iCount(^MAIN:objSQL.sql[int]{SELECT (COUNT(*)+1) FROM forum_message})
^oAjax.hRequest.delete[id]
^if(!def $oAjax.hRequest.thread_id){$oAjax.hRequest.thread_id[$iCount]}
$oAjax.hRequest.author[$MAIN:objAuth.user.name]
^if(!def $oAjax.hRequest.author){$oAjax.hRequest.author[Гость]}
$oAjax.hRequest.is_published(1)
# раз уж сюда дошли то удалим весь кэш
^dir_delete[^MAIN:CacheDir.trim[end;/];$.is_recursive(1)]
# попытка выполнения действия
^oAjax.go[]
^location[$OBJECT.full_path?id=$iCount;$.is_external(1)]
#end @mAddMessage[][tMessage]



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
# загрузка данных статьи по ID
@mGetMessage[hParams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[forum_message.forum_message_id][id]
			$.[forum_message.parent_id][]
			$.[forum_message.thread_id][]
			$.[forum_message.title][]
			$.[forum_message.author][]
			$.[forum_message.email][]
#			$.[DATE_FORMAT(forum_message.dt_published, '%e-%c-%y %H:%i:%s')][dt]
			$.[forum_message.dt_published][dt]
			$.[forum_message.body][]
		]]
		$.table[forum_message]
		$.where[
			forum_message_id = $hParams.id
			AND is_published = 1
		]
	]
]
#end @getMessage[hParams]



#################################################################################################
# загрузка статей по треду или списку тредов
@mGetMessagesByThread[hParams][sCache]
$result[
	^getSql[
		$.names[^hash::create[
			$.[forum_message.forum_message_id][id]
			$.[forum_message.parent_id][]
			$.[forum_message.thread_id][]
			$.[forum_message.title][]
			$.[forum_message.author][]
			$.[forum_message.email][]
			$.[forum_message.dt_published][dt]
			$.[IF(body IS NULL, 1, 0)][is_empty]
		]]
		$.table[forum_message]
		$.where[
			is_published = 1
			^if($hParams.thread is "table"){
				^if($hParams.thread){$sCache[^hParams.thread.menu{$hParams.thread.thread_id}[,]]
					AND thread_id IN ($sCache)
				}
			}{
				$sCache[^hParams.thread.int(0)]
				AND thread_id = ^hParams.thread.int(0)
			}
		]
		$.order[dt_published DESC]
		$.cache[forum^math:md5[$sCache].cache]
		^if(def $hParams.limit){$.limit($params.limit)}
		^if(def $hParams.offset){$.offset($params.offset)}
	]
]
#end @mGetMessagesByThread[hParams]



#################################################################################################
# загрузка статей по родителю
@mGetMessagesByParent[hParams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[forum_message.forum_message_id][id]
			$.[forum_message.parent_id][]
			$.[forum_message.thread_id][]
			$.[forum_message.title][]
			$.[forum_message.author][]
			$.[forum_message.email][]
			$.[forum_message.dt_published][dt]
			$.[IF(body IS NULL, 1, 0)][is_empty]
		]]
		$.table[forum_message]
		$.where[
			is_published = 1
			^if(def $hParams.parent_id){AND parent_id = ^hParams.parent_id.int(0)}
		]
		$.order[dt_published DESC]
		$.cache[forum^math:md5[$hParams.parent_id].cache]
		^if(def $hParams.limit){$.limit($params.limit)}
		^if(def $hParams.offset){$.offset($params.offset)}
	]
]
#end @mGetMessagesByParent[hParams]



#################################################################################################
# загрузка статей по параметрам поиска
@mGetMessagesBySearch[hParams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[forum_message.forum_message_id][id]
			$.[forum_message.parent_id][]
			$.[forum_message.thread_id][]
			$.[forum_message.title][]
			$.[forum_message.author][]
			$.[forum_message.email][]
			$.[forum_message.dt_published][dt]
			$.[IF(body IS NULL, 1, 0)][is_empty]
		]]
		$.table[forum_message]
		$.where[
			is_published = 1
			^if(def $hParams.search){AND forum_message.title LIKE "%${hParams.search}%" OR forum_message.body LIKE "%${hParams.search}%"}
			^if(def $hParams.author){AND forum_message.author LIKE "%$hParams.author%"}
		]
		$.order[dt_published DESC]
		^if(def $hParams.limit){$.limit($params.limit)}
		^if(def $hParams.offset){$.offset($params.offset)}
	]
]
#end @mGetMessagesBySearch[hParams]
