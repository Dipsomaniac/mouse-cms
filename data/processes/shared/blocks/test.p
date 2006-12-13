^mRun[$lparams]

@mRun[hParams]
^use[curd.p]
# создание курда сайтов
$crdSite[^curd::init[
	$.table[site]
	$.order[sort_order]
	$.names[
		$.[site.site_id][id]
		$.[site.name][]
		$.[site.lang_id][]
		$.[site.domain][]
		$.[site.e404_object_id][]
		$.[site.cache_time][]
		$.[site.sort_order][]
]]]
# создание курда объектов
$crdObject[^curd::init[
	$.table[object]
	$.order[sort_order]
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
]]]

#end @getOBJECTS[lparams]
<block_content>
	$crdSite.hash.1.name
	$crdObject.hash.1.name
	^crdSite.list[
		$.object[$crdObject.hash]
		$.label[Mouse CMS | Сайты]
		$.names[^table::create{name	id	object
ID	id
Название	name
Домен	domain
Время кэша	cache_time
Страница Ошибок	e404_object_id	object
}]
	]
</block_content>