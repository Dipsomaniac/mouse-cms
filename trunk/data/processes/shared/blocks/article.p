^mArticleRun[$lparams]



#################################################################################################
# Вывод данных
@mArticleRun[hParams][tArticles]
$tArticles[^getArticles[
	$.path[$SYSTEM.path]
	$.id[$form:id]
	^if(^form:year.int(0)){$.where[dt >= '^form:year.int(0)-^form:month.int(0)-00' AND dt <= '^form:year.int(0)-^form:month.int(0)-31']}{$.limit(20)}
	]
]
<block_content>
$hParams.body
<ul>
^untaint[as-is]{
	^tArticles.menu{
		<article>
			<date>^dtf:format[%d %B %Y;$article.dt]</date>
			<name><a href="?id=$tArticles.id">$tArticles.title</a></name>
			<author>$tArticles.name</author>
			^if(^form:id.int(0)){<body>$tArticles.body</body>}{<anonce>$tArticles.lead</anonce>}
		</article>
	}
}
</ul>
</block_content>
#end @mArticleRun[hParams][tArticles]



#################################################################################################
# загрузка данных
@getArticles[params]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_b_article.article_id][id]
         $.[m_b_article.title][]
			$.[m_b_article.lead][]
			$.[m_b_article.dt][]
			$.[m_b_article.name][]
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
#end @getArticles[params]
