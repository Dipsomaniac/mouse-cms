^mArticleRun[$lparams]



#################################################################################################
# Вывод данных =debug воспользоваться методом курда list
@mArticleRun[hParams][crdArticle]
$crdArticle[
	^mLoader[
		$.name[article]
		$.t(1)
		$.s(5)
		$.where[
			article.is_published = 1 AND
			article.dt_published <= ^MAIN:objSQL.now[] AND
			article_type.path = '^if(def $hParams.param.path){$hParams.param.path}{$SYSTEM.path}'
			^if(^form:id.int(0)){ AND article.article_id = ^form:id.int(0) }
			^if(^form:year.int(0)){ AND dt >= '^form:year.int(0)-^form:month.int(0)-00' AND dt <= '^form:year.int(0)-^form:month.int(0)-31'}
		]
		^if(!^form:year.int(0)){$.limit(20)}
	]
]
<channel title="Mouse CMS - News" description="Mouse CMS - Новости" link="http://$SYSTEM.siteUrl/" rsslink="http://$SYSTEM.siteUrl/rss/" generator="Mouse CMS" webmaster="horneds@gmail.com" date="$SYSTEM.date"/>
<block_content>
$hParams.body
^untaint[as-is]{
	^crdArticle.list[
		$.attr[$.id[id]$.date[dt]$.name[title]$.author[author]]
		^if(^form:id.int(0)){$.value[body]}{$.value[lead]}
		$.tag[article]
	]
}
^if(!^form:id.int(0)){^crdArticle.scroller[$.uri[$SYSTEM.path]$.tag[article_scroller]]}
</block_content>
#end @mArticleRun[hParams][tArticles]



#################################################################################################
# загрузка данных
@mLoader[hParams]
$result[
	^curd::init[
		$.name[$hParams.name]
		$.t[$hParams.t]
		$.s[$hParams.s]
		$.where[$hParams.where]
		$.names[
			$.[article.article_id][id]
         $.[article.title][]
			$.[article.lead][]
			$.[DATE_FORMAT(article.dt, '%e.%c.%y')][dt]
			$.[article.author][]
			^if(^form:id.int(0)){$.[article.body][]}
		]
		$.leftjoin[article_type]
		$.using[article_type_id]
		$.order[id DESC]
	]
]
#end @mLoader[hParams]
