<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

<!-- FIELD* -->
<xsl:template match="//field[(@type='text') or (@type='submit') or @type='password']">
	<p class="m_modal"><input type="{@type}" name="{@name}" id="{@id}" value="{@value}" size="{@size}" tabindex="{@tabindex}" required="{@required}" mask="{@mask}"/>
	<br /><label for="{@name}"><small> <xsl:value-of select="@description"/></small></label></p>
</xsl:template>
<!-- =debug ну не знаю я XSLT!!! -->
<xsl:template match="//field[(@type='checkbox') and (@checked='1')]">
	<input type="{@type}" name="{@name}"  id="{@id}" value="{@value}" checked="{@checked}"/>
	<label for="{@name}"><small> <xsl:value-of select="@description"/></small></label><br/>
</xsl:template>
<xsl:template match="//field[(@type='checkbox') and not (@checked='1')]">
	<input type="{@type}" name="{@name}"  id="{@id}" value="{@value}" />
	<label for="{@name}"><small> <xsl:value-of select="@description"/></small></label><br/>
</xsl:template>
<xsl:template match="//field[(@type='hidden')]">
<input type="{@type}" name="{@name}" value="{@value}" />
</xsl:template>
<!-- FIELD# -->

<!-- TEXTAREA* -->
<xsl:template match="textarea">
	<p><textarea name="{@name}" id="{@name}" cols="{@cols}" rows="{@rows}" tabindex="{@tabindex}">
	<xsl:value-of select="." /></textarea>
	<br /><label for="{@name}"><small> <xsl:value-of select="@description"/></small></label></p>
</xsl:template>
<!-- TEXTAREA# -->

<!-- SELECT* -->
<xsl:template match="select">
	<p><select name="{@name}" size="{@size}" id="{@id}">
			<xsl:apply-templates />
  		</select>
	<br /><label for="{@name}"><small><xsl:value-of select="@description"/></small></label></p>
</xsl:template>
<!-- SELECT# -->

<!-- OPTION* -->
<xsl:template match="option">
<xsl:if test="@select=@value"><option value="{@value}" selected="selected"><xsl:value-of select="." /></option></xsl:if>
<xsl:if test="not (@select=@value)"><option value="{@value}"><xsl:value-of select="." /></option></xsl:if>
</xsl:template>
<!-- OPTION# -->

<!-- MOUSE FORMS* -->
<xsl:template match="form">
	<h3 id="respond"><xsl:value-of select="@description"/></h3>
	<form action="{@action}" method="{@method}" id="{@id}" name="{@name}">
			<xsl:apply-templates />
	</form>
</xsl:template>
<xsl:template match="auth-logon">
	<div style="text-align:center">
	<form action="{@action}" method="{@method}" id="searchform">
			<xsl:apply-templates />
	</form></div>
</xsl:template>
<xsl:template match="auth-profile">
	<div style="text-align:center">
	<form action="{@action}" method="{@method}" id="searchform">
			<xsl:apply-templates />
	</form></div>
</xsl:template>
<xsl:template match="auth-logout">
	<div style="text-align:center">
	<form action="{@action}" method="{@method}" id="searchform">
			<xsl:apply-templates />
	</form></div>	
</xsl:template>
<!-- MOUSE FORMS# -->

</xsl:stylesheet>