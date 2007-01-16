<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">



<xsl:template match="block_content">
	<xsl:apply-templates />
</xsl:template>


<!-- Голосование -->
<xsl:template match="poll[@mode=0]">
	<h3><span><xsl:value-of select="@title"/></span></h3>
	<form method="post" name="poll" action="{@action}">
	<ul><xsl:apply-templates select="answer" /></ul>
	<input type="submit" name="submit" value="Ответить" class="input-button"/>
	</form>
	<h3>Начало: <xsl:value-of select="@dt"/><br/>
	Окончание: <xsl:value-of select="@dt_finish"/></h3>
</xsl:template>
<xsl:template match="poll[@mode=1]">
	<h3><span><xsl:value-of select="@title"/></span></h3>
	<xsl:apply-templates select="result" />
	<h3>Начало: <xsl:value-of select="@dt"/><br/>
	Окончание: <xsl:value-of select="@dt_finish"/></h3>
</xsl:template>
<xsl:template match="answer">
	<li><input type="radio" name="answer" value="{@id}" id="{@id}" /><label><xsl:value-of select="."/></label></li>
</xsl:template>
<xsl:template match="result">
	<xsl:variable name="id" select="@id"/>
	<li><span><xsl:value-of select="@div"/>% (<xsl:value-of select="@value"/>)</span> - <xsl:value-of select="../answer[@id=$id]"/></li>
</xsl:template>


<xsl:template match="buttons">
	<div class="buttons">&nbsp;
		<xsl:apply-templates select="//button" mode="draw"/>
	</div>
</xsl:template>
<xsl:template match="button" mode="draw">
	<xsl:choose>
		<xsl:when test="@href">
			<a href="{@href}" alt="{@alt}" title="{@alt}" class="modules"><img src="/themes/mouse/icons/{@image}" class="input-image" /></a>
		</xsl:when>
		<xsl:otherwise>
			<img src="/themes/mouse/icons/{@image}" name="{@name}" alt="{@alt}" title="{@alt}" class="input-image" onClick="{@onClick}" />
		</xsl:otherwise>
	</xsl:choose>
	&nbsp;&nbsp;
</xsl:template>
<xsl:template match="button">
</xsl:template>



<xsl:template match="jq_object">
	<h2>Mouse</h2>
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="jq_object//branche">
	<div>
		<img src="/themes/mouse/icons/nil{@level}.gif" />
		<xsl:if test="./branche">
			<span class="plusminus" id="plusminus_{@id}">
				<img src="/themes/mouse/icons/minus.gif" mode="minus.gif" onClick="plusminus(this,'#sections_{@id}','minus.gif','plus.gif')"/>
			</span>
		</xsl:if>
		<span class="pick" onClick="Go('{//jq_object/@url}?type=object&amp;action=edit&amp;id={@id}', '#container')"
		onMouseover="this.className='pick-hover'" title="{@description}" onMouseout="this.className='pick'">
			<xsl:value-of select="@name"/>
		</span>
		<img src="/themes/mouse/icons/12_add.gif" 
		alt="Создать потомок" title="Создать потомок" 
		class="input-image" onClick="Go('{//jq_object/@url}?type=object&amp;action=add&amp;id={@id}', '#container')" />
		<img src="/themes/mouse/icons/12_copy.gif" 
		alt="Создать потомок" title="Копировать" 
		class="input-image" onClick="Go('{//jq_object/@url}?type=object&amp;action=copy&amp;id={@id}', '#container')" />
		<img src="/themes/mouse/icons/12_blocks.gif" 
		alt="Создать потомок" title="Управление блоками" 
		class="input-image" onClick="Go('{//jq_object/@url}?type=object&amp;action=block_to_object&amp;id={@id}', '#container')" />
		<xsl:if test="./branche">
			<div id="sections_{@id}">
				<xsl:apply-templates />
			</div>
		</xsl:if>
	</div>
</xsl:template>



<xsl:template match="atable">
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
			<xsl:apply-templates select="arow_th" /> 
		</tr>
		</thead>
		<tbody class="table-builder-spreadsheet">
			<xsl:apply-templates select="arow_tr" />
		</tbody>
		<tfoot class="table-builder-spreadsheet">
			<tr id="space"><td colspan="100"></td></tr>
			<xsl:apply-templates select="ascroller" />
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
		<xsl:apply-templates select="input" />
	</div>
	</form>
</xsl:template>



<xsl:template match="arow_th">
<th	id="{@id}" onDblClick="Go('{../th_attr}order={@id}','#container')"><xsl:value-of select="."/></th>
</xsl:template>



<xsl:template match="arow_tr">
	<tr id="tr_{@id}" onDblClick="doEdit('{../tr_attr}id={@id}','#container')">
		<td>
			<div style="padding: 0px; margin: 0px;">
				<input type="checkbox" name="check_{@id}" class="input-checkbox" onClick="markRow({@id})" />
				<span style="cursor: default;" onClick="if (this.parentNode.childNodes[0].tagName=='INPUT') {e=this.parentNode.childNodes[0]} else {e=this.parentNode.childNodes[1]} if (e.checked) {e.checked=false} else {e.checked=true}">
				</span>
			</div>
					<div class="div-system-info" id="sysinfo_{@id}">
						<xsl:value-of select="." />
					</div>
				</td>
		<xsl:apply-templates select="./arow_td" />
	</tr>
</xsl:template>



<xsl:template match="arow_td">
<td onClick="doMark({../@id})">
	<span onClick="setFilter('{@id}', '{@value}')" class="arrow" onMouseover="ShowLocate('sysinfo_{../@id}', event)" onMouseout="Hide('sysinfo_{../@id}')">
		<xsl:if test="@name"><xsl:value-of select="@name"/></xsl:if>
		<xsl:if test="not(@name)"><xsl:value-of select="@value"/></xsl:if>
	</span>
</td>
</xsl:template>



<xsl:template match="ascroller">
<tr id="pages">
	<td colspan="100">
		<xsl:apply-templates select="ascroller_left" />
		<xsl:apply-templates select="ascroller_page" />
		<xsl:apply-templates select="ascroller_right" />
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
				<xsl:text>Показаны: </xsl:text>
				<xsl:value-of select="@offset" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="@now" />
				<xsl:text>, Всего: </xsl:text>
				<xsl:value-of select="@count" />
			</div>
	</td>
</tr>
</xsl:template>



<xsl:template match="ascroller_page[@select]|article_scroller_page[@select]|forum_scroller_page[@select]">
	<xsl:text> [</xsl:text>
	<xsl:value-of select="@count"/>
	<xsl:text>] </xsl:text>
</xsl:template>



<xsl:template match="article_scroller_page|forum_scroller_page">
	<a href="{../@uri}page={@count}">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@count"/>
		<xsl:text> </xsl:text>
	</a>
</xsl:template>



<xsl:template match="ascroller_page">
	<a href="#" onClick="Go('{../@uri}page={@count}','#container')">
		<xsl:text> </xsl:text>
		<xsl:value-of select="@count"/>
		<xsl:text> </xsl:text>
	</a>
</xsl:template>



<xsl:template match="ascroller_left">
	<a href="#" onClick="Go('{@uri}','#container')">
		<xsl:text> prev </xsl:text>
	</a>
</xsl:template>



<xsl:template match="forum_scroller_left|article_scroller_left">
	<a href="{@uri}">
		<xsl:text> prev </xsl:text>
	</a>
</xsl:template>



<xsl:template match="forum_scroller_right|article_scroller_right">
	<a href="{@uri}">
		<xsl:text> prev </xsl:text>
	</a>
</xsl:template>



<xsl:template match="ascroller_right">
	<a href="#" onClick="Go('{@uri}','#container')">
		<xsl:text> next </xsl:text>
	</a>
</xsl:template>



<xsl:template match="article">
	<div class="post">
		<xsl:if test="@image"><img src="{/../block_path}{@image}"/></xsl:if>		
		<div class="post-info">
			<h3><span>
				<xsl:choose>
					<xsl:when test="@in">
						<xsl:value-of select="@name"/>
					</xsl:when>
					<xsl:otherwise>
						<a href="?id={@id}">
							<xsl:value-of select="@name"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</span></h3>
			<span>Автор: <xsl:value-of select="@author"/></span>, 
			<span>Дата:  <xsl:value-of select="@date"/></span>
		</div>
		<div class="post-content">
			<xsl:copy-of select="./node()" />
		</div>
	</div>
</xsl:template>



<xsl:template match="article_scroller|forum_scroller">
	<br/><br/><hr/> Страницы: 
	<xsl:apply-templates />
</xsl:template>



<xsl:template match="forum">
<xsl:apply-templates select="buttons" /><hr/>
	<div id="forum_repeat" class="form-builder-tab">
	<form action="" method="post" name="form_forum_repeat" enctype="multipart/form-data">
		<div class="divider">
			<label for="" class="title" id="title_name">Заголовок</label>
			<small class="help">Заголовок сообщения</small>
			<div class="container">
				<input type="text" name="title" value="{param/@title}" class="input-text-long" />
			</div>
		</div>
		<div class="divider">
			<label for="" class="title" id="title_name">Содержание</label>
			<small class="help">Текст сообщения</small>
			<div class="container">
				<textarea name="body" id="message_body" class="input-textarea-large"><xsl:value-of select="param"/></textarea>
<!--				<a href="javascript://toggle/this" onClick="popXTextArea('body');return false;">Править в визуальном редакторе</a> -->
			</div>
		</div>
		<input type="hidden" name="dt_published" value="{@dt}" />
		<input type="hidden" name="parent_id" value="{@parent_id}" />
		<xsl:if test="@id"><input type="hidden" name="id" value="{@id}" /></xsl:if>
		<input type="hidden" name="thread_id" value="{./thread_id}" />
		<xsl:apply-templates select="input" />
		<input type="submit" class="input-button" name="submit" value="Отправить" />
		<br/><br/><hr/>
		</form>
	</div>
	<div id="forum_search" class="form-builder-tab">
		<form action="" method="post" name="form_forum_search" enctype="multipart/form-data">
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
		<xsl:if test="not(param)">$('#forum_repeat').hide()</xsl:if>
		$('#forum_search').hide()
	</script>
	<xsl:apply-templates select="article"/>
	<ul>
		<div class="forum-info">
			<xsl:apply-templates select="forum_message"/>
		</div>
	</ul>
	<xsl:apply-templates select="forum_scroller"/>
</xsl:template>



<xsl:template match="forum_message">
<xsl:if test="../button"><br/></xsl:if>
<li>
	<xsl:if test="forum_message"><img src="/themes/mouse/icons/minimize.gif" name="img_{@id}" alt="..." title="..." class="input-image" style="float: left;margin-right: 5px;" onClick="plusminus(this,'#m{@id}','minimize.gif','maximize.gif')" /></xsl:if>
	<xsl:choose>
		<xsl:when test="@in">
			<h3>
				 <xsl:value-of select="@title"/><xsl:if test="(@is_empty = 1)"> (-)</xsl:if>
			</h3>
		</xsl:when>
		<xsl:otherwise>
			<a href="?id={@id}">
				 <xsl:value-of select="@title"/><xsl:if test="(@is_empty = 1)"> (-)</xsl:if>
			</a>,
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="@author"/>, [<xsl:value-of select="@dt"/>]
	<xsl:if test="./forum_message">
		<ul id="m{@id}">
			<xsl:apply-templates />
		</ul>
	</xsl:if>
</li>
</xsl:template>



<xsl:template match="forum_last">
<li>
<a href="{@uri}?id={@id}">
<xsl:value-of select="@name"/>
<xsl:if test="(@is_empty = 1)"> (-)</xsl:if>
</a>,<xsl:value-of select="@author"/></li>
</xsl:template>



</xsl:stylesheet>