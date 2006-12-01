<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

<!-- BLOCK* -->
<xsl:template match="/document/body/block">
	<xsl:choose>
		<xsl:when test=" @style=0 ">
			<xsl:apply-templates select="block_content" />
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

<!-- BLOCK_CONTENT* -->
<xsl:template match="block_content">
	<xsl:apply-templates />
</xsl:template>
<!-- BLOCK_CONTENT# -->

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

<!-- JQ_OBJECT* -->
<xsl:template match="jq_object">
	<ul id="dhtmlgoodies_tree2" class="dhtmlgoodies_tree">
		<xsl:apply-templates />
	</ul>
</xsl:template>
<xsl:template match="jq_block">
	<xsl:apply-templates />
</xsl:template>
<xsl:template match="jq_block/a">
	<a href="#" id="d_{@id}" rel="{@id}" class="mode{@mode}">[<xsl:value-of select="@mode"/>] <xsl:value-of select="."/></a>
</xsl:template>
<xsl:template match="//jq_object//branche">
		<li id="node{@id}">
<a href="#" onclick="$('#BlockList').load('{//jq_object/@edit}?now={@id}')" title="{@description}">
	[<xsl:value-of select="@id" />] <xsl:value-of select="@name" />
</a>
<a href="#" onclick="$('#BlockList').load('{//jq_object/@add}?now={@id}')" title="Создать объект потомок">N</a>
<xsl:if test="not (./branche)">
	<a href="#" onclick="$('#BlockList').load('{//jq_object/@del}?now={@id}')" title="Удалить объект">|D</a>
</xsl:if>
<a href="#AjaxLayer" onclick="$('#BlockList').load('{//jq_object/@bcl}?now={@id}')">|B</a>
			<xsl:if test="(branche)"><ul><xsl:apply-templates /></ul></xsl:if>
		</li>
</xsl:template>
<!-- JQ_OBJECT#* -->

<!-- POINT* -->
<xsl:template match="point">
<xsl:if test="@select=@id"><option value="{@id}" class="{@class}" mode="{@mode}" selected="selected"><xsl:value-of select="." /></option></xsl:if>
<xsl:if test="not (@select=@id)"><option value="{@id}"  class="{@class}"  mode="{@mode}"><xsl:value-of select="." /></option></xsl:if>
</xsl:template>
<!-- POINT# -->

<!-- все браться контекстного узла -->
<!-- дальше бред -->
<xsl:template match="ai">
  <li>
    <b><xsl:value-of select="@id" /></b>: 
	  <xsl:value-of select="." />
  </li>
</xsl:template>
</xsl:stylesheet>