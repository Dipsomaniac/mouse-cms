<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- form -->
<xsl:template match="form">
	<form action="{@action}" method="{@method}" id="{@id}" name="{@name}" enctype="{@enctype}">
	<div class="mlabel">
		<xsl:value-of select="./@label"/>
	</div>
	<div id="tabs" class="form-builder-tabs">
		<xsl:apply-templates />
	</div>
	</form>
</xsl:template>

<!-- tabs -->
<xsl:template match="tabs">
		<ul class="form-builder-tab">
			<xsl:apply-templates select="./tab" mode="anchor"/>
		</ul>
			<xsl:apply-templates select="./tab" mode="out"/>
</xsl:template>
<xsl:template match="tab" mode="anchor">
	<li><a href="#{@id}"><xsl:value-of select="@name"/></a></li>
</xsl:template>
<xsl:template match="tab" mode="out">
	<div id="{@id}" class="form-builder-tab">
		<xsl:apply-templates />
	</div>
</xsl:template>

<!-- field -->
<xsl:template match="field">
	<xsl:if test="@type='hidden'">
		<input type="{@type}"  name="{@name}" value="{.}" />
	</xsl:if>
	<xsl:if test="@type='submit'">
		<input type="submit" class="input-button" name="{@name}" value="{@value}" />
	</xsl:if>
	<xsl:if test="not(@type='hidden') and not(@type='submit')">
		<div class="divider">
			<label for="" class="title" id="title_{@name}"><xsl:value-of select="@label"/></label>
			<small class="help"><xsl:value-of select="@description"/></small>
			<div class="container">
				<xsl:choose>
					<xsl:when test="@type='none'">
						<span id="{@name}"><xsl:apply-templates /></span>
					</xsl:when>
					<xsl:when test="@type='text'">
						<input type="text" name="{@name}" value="{.}"  class="input-text-{@class}" />
					</xsl:when>
					<xsl:when test="@type='checkbox'">
						<xsl:if test=". &gt; '0'">
							<input type="checkbox" name="{@name}" value="0" checked="{.}" />
						</xsl:if>
						<xsl:if test="not(. &gt; '0')">
							<input type="checkbox" name="{@name}" value="0" />
						</xsl:if>
					</xsl:when>
					<xsl:when test="@type='textarea'">
							<br/><br/>
							<div>
								<img src="/themes/mouse/buttons/minimize.gif" name="img_{@name}" alt="..." title="..." class="input-image" style="float: right;" onClick="$('#div_{@name}').slideToggle('slow');" />
								<br/>
							</div>
							<div id="div_{@name}">
								<textarea name="{@name}" id="textarea_{@name}" class="input-textarea-large"><xsl:value-of select="."/></textarea>
								<xsl:if test="@ws"><a href="javascript://toggle/this" onClick="popXTextArea('{@name}');return false;">Править в визуальном редакторе</a></xsl:if>
							</div>
					</xsl:when>
					<xsl:when test="@type='select'">
						<select name="{@name}" class="input-text-{@class}" size="1">
							<xsl:apply-templates />
						</select>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="field_option">
	<option value="{@id}">
		<xsl:if test="@id=@select">
			<xsl:attribute name="selected">selected</xsl:attribute> 
		</xsl:if>
		<xsl:value-of select="@value"/>
	</option>
</xsl:template>



<!-- input -->
<xsl:template match="input">
		<input>
			<xsl:copy-of select="@*"/>
		</input>
</xsl:template>

<!-- option -->
<xsl:template match="option">
	<xsl:if test="@select=@value"><option value="{@value}" mode="{@mode}" selected="selected"><xsl:value-of select="." /></option></xsl:if>
	<xsl:if test="not (@select=@value)"><option value="{@value}" mode="{@mode}"><xsl:value-of select="." /></option></xsl:if>
</xsl:template>

<!-- others -->
<xsl:template match="auth-logon">
	<div style="text-align:center">
	<form action="{@action}" method="{@method}" id="searchform">
		<div align="center">
			<xsl:apply-templates />
		</div>
	</form></div>
</xsl:template>
<xsl:template match="auth-logon/field">
	<input type="{@type}" value="{@value}" name="{@name}" /><br/>
</xsl:template>
<xsl:template match="auth-profile">
	<div style="text-align:center">
	<form action="{@action}" method="{@method}" id="searchform">
			<xsl:apply-templates />
	</form></div>
</xsl:template>
<xsl:template match="auth-logout">
	<form action="{@action}" method="{@method}">
			<xsl:apply-templates />
	</form>
</xsl:template>
<xsl:template match="login-name">
</xsl:template>

</xsl:stylesheet>