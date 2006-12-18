<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Output -->
<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
/>

<!-- Include -->
<xsl:include href="../main.xsl"/>
<xsl:include href="forms.xsl"/>
<xsl:include href="objects.xsl"/>

<!-- Gooo -->
<xsl:template match="/node()">
	<html lang="{@lang}">
		<!-- header -->
		<xsl:call-template name="header"/>
		<!-- body -->
		<xsl:call-template name="body"/>
	</html>
</xsl:template>

<!-- Body -->
<xsl:template name="body">
	<body id="{/document/header/object-id}">
		<xsl:apply-templates select="/document/body" />
		<xsl:apply-templates select="//js_footer" />
	</body>
</xsl:template>

<!-- CONTENT* -->
<xsl:template match="document/body">
	<!-- header -->
	<div id="header">
		<a href="http://{/document/system/site/.}" title="{/document/header/main_url/.}">
			<h1><xsl:value-of select="/document/header/document_name"/></h1>
		</a>
		<xsl:apply-templates select="//menu"/>
        <form method="get" action="/search/" id="quick-search">
		    <input type="text" name="phrase" class="text" id="search" value="Поиск" title="Поиск" />
            <input type="image" src="/images/search.gif" name="search" id="search" alt="Найти" />
        </form>
	</div>
	<!-- content -->
	<div id="content">
		<div id="container">
			<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
		</div>
	</div>
				
	<!-- sidebar -->
	<div id="sidebar">
	   	<xsl:apply-templates select="/document/body/block[(@mode=2)]"/>
	   	<xsl:apply-templates select="//badges"/>
	</div>
					
	<!-- FOOTER -->
	<div id="footer">
		<div id="copyright"><p id="mouse"></p>© 2006 KLeN</div>
		<p id="stat">Справка | Техническая поддержка | О программе</p>
	</div>
</xsl:template>
<!-- CONTENT# -->


<!-- BLOCK* -->
<xsl:template match="/document/body/block">
	<xsl:choose>
		<xsl:when test=" @style=0 ">
			<xsl:apply-templates select="block_content"/>
		</xsl:when>
		<xsl:when test=" @mode = 1 ">
			<h2><xsl:value-of select="./name" /></h2>
			<div id="block">
				<xsl:apply-templates select="block_content"/>
			</div>
		</xsl:when>
		<xsl:when test=" @mode = 2 ">
			<h2><xsl:value-of select="./name" /></h2>
			<xsl:apply-templates select="block_content"/>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- BLOCK# -->

<!-- topmenu -->
<xsl:template match="menu">
	<ul id="topnav">
		<xsl:apply-templates select="/document/navigation/branche[@is_show_in_menu=1]" mode="topmenu" />
	</ul>
</xsl:template>
<xsl:template match="/document/navigation/branche[@is_show_in_menu=1]" mode="topmenu"> 
		<li>
			<xsl:if test="not(@in=1) or (@hit=0)">
				<a href="{@full_path}" title="{@document_name}"><xsl:value-of select="@name"/>
				<xsl:call-template name="topmenu" /></a>
			</xsl:if>
			<xsl:if test="(@in=1) and not(@hit=0)">
				<b><xsl:value-of select="@name"/></b>
				<xsl:call-template name="topmenu" />
       		</xsl:if>
		</li>
</xsl:template>
<xsl:template name="topmenu"> 
	<xsl:if test = "not(position()=last())" >
       	<xsl:text >| </xsl:text>
    </xsl:if>
</xsl:template>

<!-- sidemenu -->
<xsl:template match="sidemenu">
	<ul>
		<xsl:apply-templates select="/document/navigation/branche[@is_show_in_menu=1]" mode="sidemenu" />
	</ul>
</xsl:template>
<xsl:template match="/document/navigation/branche[@is_show_in_menu=1]|/document/navigation//branche/branche[@is_show_in_menu=1]" mode="sidemenu" >
			<li>
				<xsl:if test="not (@in=1)"><a href="{@full_path}" title="{@description}"><xsl:value-of select="@name"/></a></xsl:if>
				<xsl:if test="(@in=1)"><b><xsl:value-of select="@name"/></b></xsl:if>
				<xsl:if test="(./branche[@is_show_in_menu=1])"><ul><xsl:apply-templates select="//branche/branche" mode="sidemenu" /></ul></xsl:if>
			</li>
</xsl:template>

<!-- sitemap -->
<xsl:template match="map">
<ul>
	<xsl:apply-templates select="/document/navigation/branche" mode="sitemap" />
</ul>
</xsl:template>
<xsl:template match="/document/navigation/branche|/document/navigation//branche/branche" mode="sitemap">
<xsl:if test="@is_show_on_sitemap = 1">
		<li>
			<a href="{@full_path}" title="{@document_name}"><xsl:value-of select="@name"/></a> | <small><xsl:value-of select="@description"/></small>
			<xsl:if test="(./branche[@is_show_on_sitemap=1])"><ul><xsl:apply-templates select="//branche/branche" mode="sitemap" /></ul></xsl:if>
		</li>
</xsl:if>
</xsl:template>

<!-- control -->
<xsl:template match="control">
	<div class="control">
		<xsl:apply-templates select="//addcontrol" />
		&nbsp;
		<xsl:apply-templates />
	</div>
	<div id="loadingAjax"><li><img src="/images/loading.gif"/> загрузка </li></div>
	<div id="Ajax"></div>
</xsl:template>


<!-- article -->
<xsl:template match="article">
	<div class="post">
		<p class="post-date"><xsl:value-of select="./date"/></p>
		<div class="post-info">
			<h2 class="post-title"><xsl:copy-of select="./name/a"/></h2>
			Автор: <xsl:value-of select="./author"/><br/>
			Комментарии:
		</div>
		<div class="post-content"><xsl:apply-templates /></div>
	</div>
</xsl:template>
<xsl:template match="date|name|author">
</xsl:template>



<!-- forum -->
<xsl:template match="forum">
<xsl:apply-templates select="buttons" /><hr/>
	<div id="forum_repeat" class="form-builder-tab">
	<form action="" method="post" name="form_forum_repeat" enctype="multipart/form-data">
		<div class="divider">
			<label for="" class="title" id="title_name">Заголовок</label>
			<small class="help">Заголовок сообщения</small>
			<div class="container">
				<input type="text" name="title" value="" class="input-text-long" />
			</div>
		</div>
		<div class="divider">
			<label for="" class="title" id="title_name">Содержание</label>
			<small class="help">Текст сообщения</small>
			<div class="container">
				<textarea name="body" id="message_body" class="input-textarea-large"/>
			</div>
		</div>
		<input type="hidden" name="dt_published" value="{@dt}" />
		<input type="hidden" name="parent_id" value="{@parent_id}" />
		<input type="hidden" name="thread_id" value="{./thread_id}" />
		<xsl:apply-templates select="input" />
		<input type="submit" class="input-button" name="submit" value="Отправить" />
		<br/><br/><hr/>
		</form>
	</div>
	<div id="forum_search" class="form-builder-tab">
		<form action="" method="post" name="form_forum_repeat" enctype="multipart/form-data">
			<div class="divider">
				<label for="" class="title" id="title_name">Строка поиска</label>
				<small class="help">Ключевые слова</small>
				<div class="container">
					<input type="text" name="search" value="" class="input-text-long" />
				</div>
			</div>
			<div class="divider">
				<label for="" class="title" id="title_name">Автор</label>
				<small class="help">Фильтр по автору</small>
				<div class="container">
					<input type="text" name="author" value="" class="input-text-medium" />
				</div>
			</div>
		<br/>
		<input type="hidden" name="action" value="search" />
		<input type="submit" class="input-button" name="submit" value="Найти" />
		</form>
	</div>
	<script type="text/javascript">
		$('#forum_repeat').hide()
		$('#forum_search').hide()
	</script>
	<xsl:apply-templates select="article"/>
	<ul>
		<div class="forum-info">
			<xsl:apply-templates select="forum_message"/>
		</div>
	</ul>
</xsl:template>
<xsl:template match="forum_message">
	<li>
			<xsl:choose>
				<xsl:when test="@in">
			<h3><xsl:value-of select="@title"/><xsl:if test="(@is_empty = 1)"> ( - )</xsl:if></h3>
				</xsl:when>
				<xsl:otherwise>
			<a href="?id={@id}"><xsl:value-of select="@title"/><xsl:if test="(@is_empty=1)"> ( - )</xsl:if></a>,
			<xsl:value-of select="@author"/>, [<xsl:value-of select="@dt"/>]
			<xsl:if test="./forum_message"><a href="#" onclick="$('#m{@id}').slideToggle('slow');">#</a></xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:if test="./forum_message">
			<ul id="m{@id}">
				<xsl:apply-templates />
			</ul>
		</xsl:if>
	</li>
</xsl:template>
</xsl:stylesheet>