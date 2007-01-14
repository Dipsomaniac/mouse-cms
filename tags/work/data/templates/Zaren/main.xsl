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
	<div id="container">
		<div id="intro">
			<div id="pageHeader">
				<h1><span><xsl:value-of select="/document/header/name"/></span></h1>
				<h2><span><xsl:value-of select="/document/header/document_name"/></span></h2>
			</div>
			
			<div id="quickSummary">
			<p class="p1"><span><xsl:copy-of select="//block[@id=8]/block_content/quote"/></span></p>
			<p class="p2"><span><xsl:copy-of select="//block[@id=8]/block_content/author"/></span></p>
				
			</div>
		</div>
	
		<div id="supportingText">
			<xsl:apply-templates select="/document/body/block[@mode=1]"/>
			<div id="footer">
				<a href="http://klen.zoxt.net" title="Powered by Mouse">Powered by Mouse</a>
			</div>
		</div>
		
		<div id="linkList">
			<div id="linkList2">
				<xsl:apply-templates select="/document/body/block[@mode=2]"/>
			</div>
		</div>
	</div>
	
</xsl:template>
<!-- CONTENT# -->


<!-- BLOCK* -->
<xsl:template match="/document/body/block">
	<xsl:choose>
		<xsl:when test=" @style = 0 and not (@id = 8)">
			<xsl:apply-templates select="block_content"/>
		</xsl:when>
		<xsl:when test=" @mode = 1 and not (@id = 8) ">
			<div id="{@name}">
				<h3><span><xsl:value-of select="block_name" /></span></h3>
				<xsl:apply-templates select="block_content"/>
			</div>
		</xsl:when>
		<xsl:when test=" @mode = 2 ">
			<div id="{@name}">
			<h3 class="{@name}"><span><xsl:value-of select="block_name" /></span></h3>
			<ul><xsl:apply-templates select="block_content"/></ul>
			</div>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<!-- BLOCK# -->

<xsl:template match="sidemenu">
		<xsl:apply-templates select="/document/navigation/branche[@is_show_in_menu=1]" mode="sidemenu" />
</xsl:template>
<xsl:template match="/document/navigation/branche[@is_show_in_menu=1]|/document/navigation//branche/branche[@is_show_in_menu=1]" mode="sidemenu" >
	<xsl:if test="not (@in=1)">
		<li><a href="{@full_path}" title="{@description}"><xsl:value-of select="@name"/></a>
		<xsl:value-of select="@document_name"/></li>
	</xsl:if>
	<xsl:if test="(@in=1)"><li class="select"><xsl:value-of select="@name"/></li></xsl:if>
	<xsl:if test="branche[@is_show_in_menu=1]"><ul><xsl:apply-templates select="branche" mode="sidemenu" /></ul></xsl:if>
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



</xsl:stylesheet>