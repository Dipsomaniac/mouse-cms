^mArticleRun[$lparams]



#################################################################################################
# Вывод данных =debug воспользоваться методом курда list
@mArticleRun[hParams][crdArticles]
$crdArticle[
	^mLoader[
		$.name[article]
		$.t(1)
		$.where[
			article.is_published = 1 AND
			article.dt_published <= ^MAIN:objSQL.now[] AND
			article_type.path = '$SYSTEM.path'
			^if(^form:id.int(0)){ AND article.article_id = ^form:id.int(0) }
			^if(^form:year.int(0)){ AND dt >= '^form:year.int(0)-^form:month.int(0)-00' AND dt <= '^form:year.int(0)-^form:month.int(0)-31'}
		]
		^if(!^form:year.int(0)){$.limit(20)}
	]
]
<block_content>
$hParams.body
<ul>
^untaint[as-is]{
	^crdArticle.table.menu{
		<article>
			<date>^dtf:format[%d %B %Y;$crdArticle.table.dt]</date>
			<name><a href="?id=$crdArticle.table.id">$crdArticle.table.title</a></name>
			<author>$crdArticle.table.author</author>
			^if(^form:id.int(0)){<body>$crdArticle.table.body</body>}{<anonce>$crdArticle.table.lead</anonce>}
		</article>
	}
}
</ul>
</block_content>
#end @mArticleRun[hParams][tArticles]



#################################################################################################
# загрузка данных
@mLoader[hParams]
$result[
	^curd::init[
		$.name[$hParams.name]
		$.where[$hParams.where]
		$.names[
			$.[article.article_id][id]
         $.[article.title][]
			$.[article.lead][]
			$.[article.dt][]
			$.[article.author][]
			^if(^form:id.int(0)){$.[article.body][]}
		]
		$.leftjoin[article_type]
		$.using[article_type_id]
		$.order[dt DESC]
	]
]
#end @mLoader[hParams]
