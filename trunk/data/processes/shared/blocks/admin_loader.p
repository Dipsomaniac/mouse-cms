^mLoaderInit[]
^mLoaderRun[$lparams]



#################################################################################################
# загрузка данных в админку
@mLoaderInit[]
# ^cache(0)			# =debug оставил кэширование в админке!
# $MAIN:NoCache(1)			# =debug оставил кэширование в админке!
$OBJECTS[^getOBJECTS[]]			# объекты
$OBJECTS_HASH[^OBJECTS.hash[id]]
$OBJECTS_HASH_TREE[^OBJECTS.hash[parent_id][$.distinct[tables]]]
$TYPES[^getTYPES[]]			# типы объектов
$TYPES_HASH[^TYPES.hash[id]]
$BLOCKS[^getBLOCKS[]]			# блоки
$BLOCKS_HASH[^BLOCKS.hash[id]]
$BLOCKS_TO_OBJECT[^getBLOCKS_TO_OBJECT[]]			# связи блоков
$BLOCKS_TO_OBJECT_HASH[^BLOCKS_TO_OBJECT.hash[id]]
$DATA_TYPES[^getDATA_TYPES[]]			# типы данных
$DATA_TYPES_HASH[^DATA_TYPES.hash[id]]
$DATA_PROCESS_TYPES[^getDATA_PROCESS_TYPES[]]			# обработчики
$DATA_PROCESS_TYPES_HASH[^DATA_PROCESS_TYPES.hash[id]]
$USERS[^getUSERS[]]			# пользователи
$USERS_HASH[^USERS.hash[id]]
$GROUPS[^getGROUPS[]]			# взаимосвязи пользователей
$GROUPS_HASH[^GROUPS.hash[id]]
$USERS_TYPES_HASH[			# типы пользователей
	$.0[$.name[user]]
	$.1[$.name[group]]
	$.2[$.name[owner]]
]
$ACL[^getACL[]]			# права системы
$ACL_HASH[^ACL.hash[id]]
$result[]			# подчистим грязь
#end @mLoaderInit[]



#################################################################################################
# общая часть
@mLoaderRun[hParams]
$result[$hParams.body]
#end @mLoaderRun[hParams]



#################################################################################################
#                                    ПОЛУЧЕНИЕ ДАННЫХ                                           #
#################################################################################################
# забирает объекты для страниц администрирующих систему (больше полей)
# =debug не соотвествует схеме, не отделены name ..., нет конструкторов
@getOBJECTS[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_object.object_id][id]
			$.[m_object.sort_order][]
			$.[m_object.parent_id][]
			$.[m_object.thread_id][]
			$.[m_object.site_id][]
			$.[m_object.template_id][]
			$.[m_object.data_process_id][]
			$.[m_object.object_type_id][]
			$.[m_object.link_to_object_type_id][]
			$.[m_object.link_to_object_id][]
			$.[m_object.auser_id][]
			$.[m_object.rights][]
			$.[m_object.cache_time][]
			$.[m_object.is_show_on_sitemap][]
			$.[m_object.is_show_in_menu][]
			$.[m_object.is_published][]
			$.[m_object.dt_update][]
			$.[m_object.path][]
			$.[m_object.full_path][]
			$.[m_object.url][]
			$.[m_object.name][]
			$.[m_object.document_name][]
			$.[m_object.window_name][]
			$.[m_object.description][]
		]]
		$.table[m_object]
		$.where[$lparams.where]
		$.order[sort_order]
		$.cache[objects_full]
	]
]
#end @getOBJECTS[lparams]

#################################################################################################
# забирает объекты для страниц не администрирующих систему (вообщем поля не все)
@getTYPES[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_object_type.object_type_id][id]
			$.[m_object_type.sort_order][]
			$.[m_object_type.is_show_on_sitemap][]
			$.[m_object_type.is_fake][]
			$.[m_object_type.abbr][]
			$.[m_object_type.name][]
			$.[m_object_type.constructor][]
	]]
		$.table[m_object_type]
		$.where[$lparams.where]
		$.order[sort_order]
		$.cache[types]
	]
]
#end @getTYPES[lparams]

#################################################################################################
# метод достает все блоки
@getBLOCKS[lparams]
$result[
	^getSql[
		$.names[^hash::create[
    		$.[m_block.block_id][id]
    		$.[m_block.name][]
    		$.[m_block.attr][]
    		$.[m_block.description][]
    		$.[m_block.data_type_id][]
    		$.[m_block.data_process_id][]
    		$.[m_block.data][]
    		$.[m_block.dt_update][]
    		$.[m_block.is_published][]
    		$.[m_block.is_hide_published][]
    		$.[m_block.is_not_empty][]
    		$.[m_block.is_shared][]
    		$.[m_block.is_parsed_manual][]
	]]
		$.table[m_block]
		$.where[$lparams.where]
		$.cache[blocks_full]
	]
]
#end @getBLOCKS[]

#################################################################################################
# метод достает блоки запрошенного объекта
@getBLOCKS_TO_OBJECT[]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_block_to_object.block_id][id]
			$.[m_block_to_object.sort_order][]
			$.[m_block_to_object.mode][]
			$.[m_block.name][]
	]]
		$.table[m_block_to_object]
		$.leftjoin[m_block]
		$.using[block_id]
		$.where[object_id = '$form:id']
		$.order[sort_order]
		$.cache[blocks_to_object_${form:id}]
	]
]
#end @getBLOCKS_TO_OBJECT[]

#################################################################################################
# забирает из sql все типы данных
@getDATA_TYPES[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_data_type.data_type_id][id]
			$.[m_data_type.sort_order][]
			$.[m_data_type.name][]
	]]
		$.table[m_data_type]
		$.where[$lparams.where]
		$.order[sort_order]
		$.cache[data_types]
	]
]
#end @getDATA_TYPES[lparams]

#################################################################################################
# забирает из sql все типы данных
@getDATA_PROCESS_TYPES[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_data_process_type.data_process_type_id][id]
			$.[m_data_process_type.sort_order][]
			$.[m_data_process_type.name][]
	]]
		$.table[m_data_process_type]
		$.where[$lparams.where]
		$.order[sort_order]
		$.cache[data_process_types]
	]
]
#end @getDATA_PROCESS_TYPES[lparams]

#################################################################################################
# забирает пользователей
@getUSERS[lparams]
$result[
	^getSql[
		$.names[^hash::create[
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
	]]
		$.table[auser]
		$.leftjoin[asession]
		$.using[auser_id]
		$.where[$lparams.where]
		$.order[name]
		$.group[auser.name]
		$.cache[users]
	]
]
#end @getUSERS[lparams]

#################################################################################################
# забирает грeggs
@getGROUPS[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[auser_to_auser.auser_id][id]
			$.[auser_to_auser.parent_id][]
			$.[auser_to_auser.rights][]
	]]
		$.table[auser_to_auser]
		$.where[$lparams.where]
		$.cache[groups]
	]
]
#end @getUSERS[lparams]

#################################################################################################
# забирает права
@getACL[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[acl.acl_id][id]
			$.[acl.object_id][]
			$.[acl.auser_id][]
			$.[acl.rights][]
	]]
		$.table[acl]
		$.where[$lparams.where]
		$.cache[acl]
	]
]
#end @getUSERS[lparams]