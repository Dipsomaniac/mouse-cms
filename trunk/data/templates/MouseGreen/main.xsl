<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Output -->
<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	method="html"
/>

<!-- Include -->
<xsl:include href="../main.xsl"/>

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
	<body>
		<xsl:apply-templates select="/document/body" />
	</body>
</xsl:template>

<!-- CONTENT* -->
<xsl:template match="document/body">
<div id="rap">
	<!-- header -->
	<div id="header">
		<xsl:apply-templates select="//menu"/>
		<h1><a href="http://{/document/system/site/.}" title="{/document/header/main_url/.}"><xsl:value-of select="/document/system/site"/></a></h1>
		<div id="desc"><xsl:value-of select="/document/header/document_name"/></div>
	</div>
	<!-- MAIN -->
	<div id="main">
		<div id="content">
			<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
		</div>
				
		<!-- SIDEBAR -->
		<div id="sidebar">
		    	<xsl:apply-templates select="/document/body/block[(@mode=2)]"/>
		</div>
					
		<!-- FOOTER -->
		<p id="footer">
			<xsl:text>Справка | Техническая поддержка | О программе</xsl:text>
			<br /><xsl:text>Copyright (с) 2006 KLeN</xsl:text><br />
		</p>
  	</div>
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
			<div class="post">
				<div class="post-info">
					<h2 class="post-title"><xsl:value-of select="@name" /></h2>
				</div>
				<div class="post-content">
				<xsl:apply-templates select="block_content"/>
				</div>
				<div class="post-info"></div>
				<div class="post-footer"> </div>
			</div>
		</xsl:when>
		<xsl:when test=" @mode = 2 ">
			<h2><xsl:value-of select="@name" /></h2>
			<ul><xsl:apply-templates select="block_content"/></ul>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- BLOCK# -->

<!-- MENU* -->
<xsl:template match="//menu">
	<ul id="topnav">
		<xsl:apply-templates select="//menu/branche"/>
	</ul>
</xsl:template>
<xsl:template match="//menu/branche"> 
	<xsl:if test="@is_show_on_menu = 1">
		<li>
			<a href="{@path}" title="{@document_name}">
				<xsl:value-of select="@name"/>
					<xsl:if test = "not(position()=last())" >
                    	<xsl:text >| </xsl:text>
                    </xsl:if>
			</a>
		</li>
	</xsl:if>
</xsl:template>
<!-- MENU# -->

<!-- MAP* -->
<xsl:template match="//map">
<ul>
	<xsl:apply-templates />
</ul>
</xsl:template>
<xsl:template match="//map//branche"> 
<xsl:if test="@is_show_on_site_map = 1">
		<li>
			<a href="{@path}" title="{@document_name}"><xsl:value-of select="@name"/></a> - <xsl:value-of select="@description"/>
			<ul><xsl:apply-templates /></ul>
		</li>
</xsl:if>
</xsl:template>
<!-- MAP# -->

<!-- все браться контекстного узла -->
<!-- дальше бред -->
<xsl:template match="ai">
  <li>
    <b><xsl:value-of select="@id" /></b>: 
	  <xsl:value-of select="." />
  </li>
</xsl:template>

</xsl:stylesheet>