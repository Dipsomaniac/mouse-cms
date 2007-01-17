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
	<!-- content -->
	<div id="content">
			<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
	</div>
</xsl:template>
<!-- CONTENT# -->


<!-- BLOCK* -->
<xsl:template match="/document/body/block">
	<div id="{@name}">
		<h3><span><xsl:value-of select="block_name" /></span></h3>
		<xsl:apply-templates />
	</div>
</xsl:template>
<!-- BLOCK# -->

<!-- topmenu -->
<xsl:template match="menu">
	<ul id="topnav">
		<xsl:apply-templates select="/document/navigation/branche" mode="topmenu" />
	</ul>
</xsl:template>
<xsl:template match="/document/navigation/branche" mode="topmenu"> 
	<xsl:if test="@is_show_on_menu = 1">
		<li>
			<xsl:if test="not(@in=1)">
				<a href="{@path}" title="{@document_name}"><xsl:value-of select="@name"/>
				<xsl:call-template name="topmenu" /></a>
			</xsl:if>
			<xsl:if test="(@in=1)">
				<b><xsl:value-of select="@name"/></b>
				<xsl:call-template name="topmenu" />
       		</xsl:if>
		</li>
	</xsl:if>
</xsl:template>
<xsl:template name="topmenu"> 
	<xsl:if test = "not(position()=last())" >
       	<xsl:text >| </xsl:text>
    </xsl:if>
</xsl:template>

<!-- sidemenu -->
<xsl:template match="sidemenu">
	<ul>
		<xsl:apply-templates select="/document/navigation/branche" mode="sidemenu" />
	</ul>
</xsl:template>
<xsl:template match="/document/navigation/branche|/document/navigation//branche/branche" mode="sidemenu" >
	<xsl:if test="@is_show_on_menu = 1">
			<li>
				<xsl:if test="not (@in=1)"><a href="{@path}" title="{@description}"><xsl:value-of select="@name"/></a></xsl:if>
				<xsl:if test="(@in=1)"><b><xsl:value-of select="@name"/></b></xsl:if>
				<xsl:if test="(./branche[@is_show_on_menu=1])"><ul><xsl:apply-templates select="//branche/branche" mode="sidemenu" /></ul></xsl:if>
			</li>
	</xsl:if>
</xsl:template>

<!-- sitemap -->
<xsl:template match="map">
<ul>
	<xsl:apply-templates select="/document/navigation/branche" mode="sitemap" />
</ul>
</xsl:template>
<xsl:template match="/document/navigation/branche|/document/navigation//branche/branche" mode="sitemap">
<xsl:if test="@is_show_on_site_map = 1">
		<li>
			<a href="{@path}" title="{@document_name}"><xsl:value-of select="@name"/></a> | <small><xsl:value-of select="@description"/></small>
			<xsl:if test="(./branche[@is_show_on_site_map=1])"><ul><xsl:apply-templates select="//branche/branche" mode="sitemap" /></ul></xsl:if>
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

<xsl:template match="tabs">
	<xsl:apply-templates />
</xsl:template>
<xsl:template match="tab">
		<xsl:apply-templates />
</xsl:template>
</xsl:stylesheet>