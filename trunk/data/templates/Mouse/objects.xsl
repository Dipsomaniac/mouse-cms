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

<!-- admin lists -->
<xsl:template match="alists">
	<form action="/forms/" method="post" name="form_content" enctype="multipart/form-data">
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
			<xsl:apply-templates select="./alist_th" />
		</tr>
		</thead>
		<tbody class="table-builder-spreadsheet">
			<xsl:apply-templates select="./alist_tr" />
		</tbody>
		<tfoot class="table-builder-spreadsheet">
			<tr id="space"><td colspan="100"></td></tr>
			<xsl:apply-templates select="./alist_scroller" />
			<tr id="search">
				<td colspan="100">
					<div>
						<label for="sys-search">Поиск:</label>
    					<input type="text" id="sys-search" name="sys_svalue" value="{./form_find}" class="input-text-long" size="50" />
    					<input type="button" class="input-button" value="Показать" 
						onClick="Go('{./footer_attr}find=' + escape(document.getElementsByName('sys_svalue')[0].value) + '&amp;filter=' + document.getElementsByName('fquery')[0].value, '#container')" />
					</div>
					<div>
    					<label for="sys-filter">Фильтр:</label>
    					<input type="text" name="fquery" value="{./form_filter}" class="input-text-long" size="30" readonly="readonly" />
    					<input type="hidden" name="sys_ffield" value="" />
    					<input type="hidden" name="sys_fvalue" value="" />
    					<img src="/themes/mouse/buttons/clear.gif" alt="x" class="input-image" onClick="clearFilter()" />
    					(чтобы установить фильтр нажмите на значение в таблице)
				</div>
			</td>
		</tr>
		</tfoot>
		</table>
		<input type="hidden" name="form_engine" value="{./form_engine}" />
	</div>
	</form>
</xsl:template>

<xsl:template match="alist_th">
<th	id="{@id}" onDblClick="Go('{../th_attr}order={@id}','#container')"><xsl:value-of select="."/></th>
</xsl:template>

<xsl:template match="alist_tr">
	<tr id="tr_{@id}" onDblClick="doEdit('{../tr_attr}id={@id}','#container')">
		<td>
			<div style="padding: 0px; margin: 0px;">
				<input type="checkbox" name="check_{@id}" class="input-checkbox" onClick="markRow({@id})" />
				<span style="cursor: default;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}">
				</span>
			</div>
					<div class="div-system-info" id="sysinfo_{@id}">
						<xsl:apply-templates select="./alist_code" />
					</div>
				</td>
		<xsl:apply-templates select="./alist_td" />
	</tr>
</xsl:template>

<xsl:template match="alist_code">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="alist_td">
<td onClick="doMark({../@id})">
	<span onClick="setFilter('{@id}', '{@name}')" class="arrow" onMouseover="ShowLocate('sysinfo_{../@id}', event)" onMouseout="Hide('sysinfo_{../@id}')">
		<xsl:value-of select="@value"/>
	</span>
</td>
</xsl:template>

<xsl:template match="alist_scroller">
<tr id="pages">
	<td colspan="100">
		<xsl:copy-of select="./span" />
	</td>
</tr>
<tr id="perpage">
	<td colspan="100">
		<div class="form">
    		<label for="sys-perpage">Объектов на страницу:</label>
    		<input type="text" id="sys-perpage" name="sys_perpage" value="{@limit}" class="input-text-short" size="2" />
   			<input type="button" value="Показать" class="input-button" onClick="Go('{../scroller_attr}number=' + document.getElementsByName('sys_perpage')[0].value , '#container')" />
		</div>
			<div class="total">
				<xsl:text>Общее количество: </xsl:text>
				<xsl:value-of select="@offset" /><xsl:text> </xsl:text>
				<xsl:value-of select="@now" /><xsl:text> - </xsl:text>
				<xsl:value-of select="@count" /> 
			</div>
	</td>
</tr>
</xsl:template>
</xsl:stylesheet>