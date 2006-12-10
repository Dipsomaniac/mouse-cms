^mEditorInit[]
^mEditorRun[$lparams]



#################################################################################################
# Загрузка данных
@mEditorInit[]
$tArticles[^getArticles[]]
$hArticles[^tArticles.hash[id]]
$tCategory[^getCategory[]]
$hCategory[^tCategory.hash[id]]
#end @mArticlesInit[]



#################################################################################################
# Администрирование
@mEditorRun[hParams]
^switch[$hParams.param]{
	^case[article]{^mArticleEdit[]}
	^case[category]{^mCategoryEdit[]}
}
#end @mEditorRun[hParams]



#################################################################################################
# Редактирование и управление статьями
@mArticleEdit[][hAction]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Статьи | $hAction.label" >
	<tabs>
		<tab id="section-1" name="Основное">
			<field type="text"     name="title"          label="Название"          description=" Название статьи "           class="medium">
				$hArticles.[$form:id].title
			</field>
			<field type="select" name="article_type_id" label="Категория"     description="Категория статьи"        class="medium">
				<system:method name="list">name[tCategory]added[select="$hArticles.[$form:id].article_type_id"]tag[option]</system:method>
			</field>
			<field type="checkbox" name="is_published"  label="Опубликовать">$hArticles.[$form:id].is_published</field>
			<field type="textarea" name="lead"   label="Анонс"     description="Краткое содержание">$hArticles.[$form:id].lead</field>
			^if($hAction.i & 6){
			<field type="hidden" name="action">insert</field>
			}
			^if($hAction.i & 1){
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
			$oFCKeditorData[^fckeditor::init[body]]
			$oFCKeditorData.sHeight[500]
#			$oFCKeditorData.sToolbarSet[Basic]
			$oFCKeditorData.sValue[$hArticles.[$form:id].body]
			^oFCKeditorData.create[]
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
Категория	article_type_id	hCategory
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
#end @mArticleEdit[][sLabel;iR]



#################################################################################################
# Редактирование и управление категориями
@mCategoryEdit[][hAction;hRights]
^if(def $form:action){
	$hAction[^mGetAction[$form:action]]
	<form method="post" action="" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Категории | $hAction.label" >
	<tabs>
		<tab id="section-1" name="Основное">
			<field type="text"     name="name"          label="Название"          description=" Название категории "           class="medium">
				$hCategory.[$form:id].name
			</field>
			<field type="text"     name="path"          label="Путь"          description=" Виртуальный путь "           class="medium">
				$hCategory.[$form:id].path
			</field>
			$hRights[^getHashRights($hCategory.[$form:id].rights)]
			<field type="checkbox" name="rights_read" label="Просмотр" description="Права по умолчанию">$hRights.read</field>
			<field type="checkbox" name="rights_edit" label="Правка" description="Права по умолчанию">$hRights.edit</field>
			<field type="checkbox" name="rights_delete" label="Удаление" description="Права по умолчанию">$hRights.delete</field>
			<field type="checkbox" name="rights_comment" label="Комментарии" description="Права по умолчанию">$hRights.comment</field>
			<field type="checkbox" name="rights_supervisory" label="Может все" description="Права по умолчанию">$hRights.supervisory</field>
			^if($hAction.i & 6){
			<field type="hidden" name="action">insert</field>
			}
			^if($hAction.i & 1){
				<field type="hidden" name="action">update</field>
				<field type="hidden" name="where">article_type_id</field>
				<field type="hidden" name="article_type_id">$form:id</field>
			}
			<field type="hidden" name="cache">category</field>
			<field type="hidden" name="tables">
				^$.main[m_b_article_type]
			</field>
		</tab>
	</tabs>
	</form>
}{
^drawList[
		$.names[^table::create{name	id	object
ID	id
Название	name
Путь	path
Права	rights
}]
		$.data[$tCategory]
		$.added[
			<field type="hidden" name="where">article_type_id</field>
			<field type="hidden" name="cache">category</field>
			<field type="hidden" name="action">delete</field>
			<field type="hidden" name="tables">
				^$.main[m_b_article_type]
			</field>
		]
		$.where[article_type_id]
		$.label[Mouse CMS | Категории ]
	]
}
#end @mCategoryEdit[][hAction;hRights]



#################################################################################################
# загрузка статей
@getArticles[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_b_article.article_id][id]
			$.[m_b_article.article_type_id][]
			$.[m_b_article.title][]
			$.[m_b_article.lead][]
			$.[m_b_article.is_not_empty][]
			$.[m_b_article.is_published][]
			$.[m_b_article.body][]
			$.[m_b_article.dt][]
			$.[m_b_article.dt_published][]
	]]
		$.table[m_b_article]
		$.where[$lparams.where]
		$.order[article_id]
		$.cache[articles]
	]
]
#end @getArticles[lparams]



#################################################################################################
# загрузка категорий статей
@getCategory[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_b_article_type.article_type_id][id]
			$.[m_b_article_type.path][]
			$.[m_b_article_type.name][]
			$.[m_b_article_type.rights][]
	]]
		$.table[m_b_article_type]
		$.where[$lparams.where]
		$.order[article_type_id]
		$.cache[a_category]
	]
]
#end @getUSERS[lparams]