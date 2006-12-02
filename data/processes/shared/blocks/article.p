$article[^getArticles[
	$.path[$SYSTEM.path]
	^if(^form:year.int(0)){
		$.where[dt >= '^form:year.int(0)-^form:month.int(0)-00' AND dt <= '^form:year.int(0)-^form:month.int(0)-31']
	}{
		$.limit(20)
	}
]]
<block_content>
^if($article){^printArticles[$article]}
</block_content>
# если права позволяют добавляем в панель управления страницы возможность добавлять новость
^if($RIGHTS & $SYSTEM.write){
	<addcontrol>
		<img src="/themes/mouse/icons/add.gif" name="add" alt="Добавить" title="Добавить" class="input-image"/>
	</addcontrol>
}

@printArticles[article]
<ul>
^untaint[as-is]{
	^article.menu{
		<article>
			<date>^dtf:format[%d %B %Y;$article.dt]</date>
			<name>^printTitle[$article]</name>
			<author>$MAIN:objAuth.user.name</author>
			<anonce>$article.lead</anonce>
		</article>
	}
}
</ul>

@printTitle[article]
^if(def $article.title && ^article.title.match[\^[[^^\^]]+\^]]){
	$result[^article.title.match[\^[([^^\^]]+)\^]][g]{<a href="?id=$article.id">$match.1</a>}]
}{
	$result[<a href="?id=$article.id">$article.title</a>]
}

@getArticles[params]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_b_article.article_id][id]
         $.[m_b_article.title][]
			$.[m_b_article.lead][]
			$.[m_b_article.dt][]
			^if(^params.id.int(0)){$.[m_b_article.body][]}
		]]
		$.table[m_b_article]
		$.leftjoin[m_b_article_type]
		$.using[article_type_id]
		$.where[
			m_b_article.is_published = 1 AND
			m_b_article.dt_published <= ^MAIN:objSQL.now[] AND
			m_b_article_type.path = '$params.path'
			^if(^params.id.int(0)){ AND m_b_article.article_id = ^params.id.int(0) }
			^if(def $params.where){ AND $params.where }
		]
		$.order[dt DESC]
		$.cache[articles${params.id}^math:md5[$params.path].cache]
		^if(def $params.limit){$.limit($params.limit)}
		^if(def $params.offset){$.offset($params.offset)}
	]
]
#end @getArticles[]
