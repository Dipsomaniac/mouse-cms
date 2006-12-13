<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- block_content -->
<xsl:template match="block_content">
	<xsl:apply-templates />
</xsl:template>

<!-- buttons -->
<xsl:template match="buttons">
	<div class="buttons">&nbsp;
		<xsl:apply-templates select="//button" mode="draw"/>
	</div>
</xsl:template>
<xsl:template match="button" mode="draw">
	<xsl:choose>
		<xsl:when test="@href">
			<a href="{@href}" alt="{@alt}" title="{@alt}"><img src="/themes/mouse/icons/{@image}" class="input-image" /></a>
		</xsl:when>
		<xsl:otherwise>
			<img src="/themes/mouse/icons/{@image}" name="{@name}" alt="{@alt}" title="{@alt}" class="input-image" onClick="{@onClick}" />
		</xsl:otherwise>
	</xsl:choose>
	&nbsp;&nbsp;
</xsl:template>
<xsl:template match="button">
</xsl:template>

<!-- jq_object -->
<xsl:template match="jq_object">
	<h2>Mouse</h2>
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="jq_object//branche">
	<div>
		<img src="/themes/mouse/icons/nil{@level}.gif" />
		<xsl:if test="./branche">
			<span class="plusminus" id="plusminus_{@id}" onClick="$('#sections_{@id}').slideToggle('slow');">
				<img src="/themes/mouse/icons/plus.gif" />
			</span>
		</xsl:if>
		<span class="pick" onClick="Go('/mc/admin/?type=objects&amp;action=edit&amp;id={@id}', '#container')"
		onMouseover="this.className='pick-hover'" title="{@description}" onMouseout="this.className='pick'">
			<xsl:value-of select="@name"/>
		</span>
		<img src="/themes/mouse/icons/12_add.gif" 
		alt="Создать потомок" title="Создать потомок" 
		class="input-image" onClick="Go('/mc/admin/?type=objects&amp;action=add&amp;id={@id}', '#container')" />
		<img src="/themes/mouse/icons/12_copy.gif" 
		alt="Создать потомок" title="Копировать" 
		class="input-image" onClick="Go('/mc/admin/?type=objects&amp;action=copy&amp;id={@id}', '#container')" />
		<img src="/themes/mouse/icons/12_blocks.gif" 
		alt="Создать потомок" title="Управление блоками" 
		class="input-image" onClick="Go('/mc/admin/?type=objects&amp;action=blocks&amp;id={@id}', '#container')" />
		<xsl:if test="./branche">
			<div id="sections_{@id}">
				<xsl:apply-templates />
			</div>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template match="lists">
	<form action="/ajax/go.html" method="post" name="form_content" enctype="multipart/form-data">
	<div class="mlabel">
		<xsl:value-of select="@label"/>
	</div>
	<div id="tabs" class="form-builder-tabs">
		<table class="table-builder-spreadsheet">
		<thead class="table-builder-spreadsheet">
		<tr>
   			<td>
   				<div style="padding: 0px; margin: 0px;">
					<input type="checkbox" name="check_main" class="input-checkbox" onClick="checkAll();markAll()" />
					<span style="cursor: default;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}" />
				</div>
			</td>
			<xsl:apply-templates select="./th" />
		</tr>
		</thead>
		<tbody class="table-builder-spreadsheet">
			
		</tbody>
		</table>
	</div>
	</form>
</xsl:template>

<xsl:template match="th">
<th id="{@id}"><xsl:value-of select="."/></th>
</xsl:template>

</xsl:stylesheet>