^mArticlesEdit[]

#################################################################################################
# Редактирование и управление статьями
@mArticlesEdit[][tArticles;hArticles;sLabel;iR]
$tArticles[^getArticles[]]
$hArticles[^tArticles.hash[id]]
^if(def $form:action){
	^if($form:action eq 'edit'){$iR($iR + 1) $sLabel[Редатирование ]}
	^if($form:action eq 'copy'){$iR($iR + 2) $sLabel[Копирование ]}
	^if($form:action eq 'add'){ $iR($iR + 4) $sLabel[Добавление ]}
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Статьи | $sLabel" >
	<tabs>
		<tab id="section-1" name="Основное">
			<field type="text"     name="title"          label="Название"          description=" Название статьи "           class="medium">
				$hArticles.[$form:id].title
			</field>
			<field type="checkbox" name="is_published"  label="Опубликовать">$hArticles.[$form:id].is_published</field>
			<field type="textarea" name="lead"   label="Анонс"     description="Краткое содержание">$hArticles.[$form:id].lead</field>
			^if($iR & 6){
			<field type="hidden" name="action">insert</field>
			}
			^if($iR & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">article_id</field>
				<field type="hidden" name="article_id">$form:id</field>
			}
			<field type="hidden" name="cache">articles</field>
			<field type="hidden" name="dt">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="dt_published">^MAIN:dtNow.sql-string[]</field>
			<field type="hidden" name="tables">
				^$.main[m_b_article]
			</field>
		</tab>
		<tab id="section-2" name="Содержание">
			^use[/fckeditor/fckeditor.p]
			$oFCKeditorData[^fckeditor::Init[body]]
			$oFCKeditorData.Height[500]
			$oFCKeditorData.ToolbarSet[Basic]
			$oFCKeditorData.Value[$hArticles.[$form:id].body]
			^oFCKeditorData.Create[]
		</tab>
	</tabs>
	</form>
}{
^drawList[
		$.names[^table::create{name	id	object
ID	id
Название	title
Опубликована	is_published
Дата публикации	dt_published
Категория	name
}]
		$.data[$tArticles]
		$.added[
			<field type="hidden" name="where">article_id</field>
			<field type="hidden" name="cache">articles</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_b_article]
			</field>
		]
		$.where[article_id]
		$.label[Mouse CMS | Статьи ]
		$.description{
			Анонс: $_tData.lead <br/>
			^if($_tData.is_not_empty){Содержит данные <br/>}
			Создана: $_tData.dt_published <br/>
		}
	]
}

#################################################################################################
# забирает пользователей
@getArticles[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_b_article.article_id][id]
			$.[m_b_article.title][]
			$.[m_b_article.lead][]
			$.[m_b_article.is_not_empty][]
			$.[m_b_article.is_published][]
			$.[m_b_article.body][]
			$.[m_b_article.dt][]
			$.[m_b_article.dt_published][]
			$.[m_b_article_type.name][]
			$.[m_b_article_type.irf][]
	]]
		$.table[m_b_article]
		$.leftjoin[m_b_article_type]
		$.using[article_type_id]
		$.where[$lparams.where]
		$.order[article_id]
		$.cache[articles]
	]
]
#end @getUSERS[lparams]