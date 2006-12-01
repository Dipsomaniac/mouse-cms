<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



<!-- block_content -->
<xsl:template match="block_content">
	<xsl:apply-templates />
</xsl:template>

<!-- jq_object -->
<xsl:template match="jq_object">
	<ul id="dhtmlgoodies_tree2" class="dhtmlgoodies_tree">
		<xsl:apply-templates />
	</ul>
</xsl:template>
<xsl:template match="jq_block">
	<xsl:apply-templates />
</xsl:template>
<xsl:template match="jq_block/li">
	<li id="d_{@id}" rel="{@id}" class="mode{@mode}">
		[<xsl:value-of select="@mode"/>] <xsl:value-of select="."/>
	</li>
</xsl:template>
<xsl:template match="//jq_object//branche">
		<li id="node{@id}" class="objecttree">
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

</xsl:stylesheet>