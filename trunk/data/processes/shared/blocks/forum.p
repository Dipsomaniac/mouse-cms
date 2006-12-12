^mForumRun[$lparams]



####################################################################################################
# Вывод данных
@mForumRun[hParams][tMessage;hMessageThread]
# загрузка всех сообщений 20 корневых веток
$tMessage[^mGetMessagesByThread[$.thread[^mGetMessagesByParent[$.parent_id(0) $.limit(20)]]]]
$hMessageThread[^tMessage.hash[parent_id][$.distinct[tables]]]
<block_content>
<forum>
^ObjectByParent[$hMessageThread;0;
	$.tag[forum_message]
	$.attributes[^table::create{name^#OAid^#OAtitle^#OAauthor^#OAdt^#OAis_empty}]
]
</forum>
</block_content>
#end @mForumRun[hParams]



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
		$.cache[forum^math:md5[$sCache].cache]
		^if(def $hParams.limit){$.limit($params.limit)}
		^if(def $hParams.offset){$.offset($params.offset)}
	]
]
#end @mGetMessagesByParent[hParams]