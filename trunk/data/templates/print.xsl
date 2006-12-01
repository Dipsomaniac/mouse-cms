<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

<!-- *IMPORT -->
<xsl:include href="forms.xsl"/>
<xsl:include href="html.xsl"/>
<xsl:include href="object.xsl"/>
<!-- #IMPORT -->

<xsl:template match="/">
<html>
    <xsl:apply-templates select="/document/headers" />
    <body>
	<xsl:apply-templates select="//print" />
	</body>
</html>
</xsl:template>

<!-- HEAD* -->
<xsl:template match="/document/headers">
	<!-- CSS -->
	<link rel="stylesheet" href="/style/print.css" />
	<!-- META -->
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
	<!-- TITLE -->
	<title><xsl:value-of select="/document/headers/window_name"/></title>
</xsl:template>
<!-- HEAD# -->

<xsl:template match="//print">
	<xsl:apply-templates />
</xsl:template>

<!-- CONTENT* -->
<xsl:template match="/document/body">
<div id="container">

	<!-- CONTENT -->
	<div id="content">
			
		<!-- MAIN -->
		<div id="main">
			<h2>
				<xsl:value-of select="/document/headers/document_name"/>
			</h2> 
			<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
		</div>
				
				
	</div>
</div>
</xsl:template>
<!-- CONTENT# -->

<!-- BLOCK -->
		<xsl:template match="block">
		<fieldset><legend><xsl:value-of select="@name" /></legend>
			<p>
				<xsl:apply-templates />
			</p>
		</fieldset>
		</xsl:template>
		<!-- BLOCK:END -->
		
		<xsl:template match="bname">
		<xsl:value-of select="."/>
		</xsl:template>
		
</xsl:stylesheet>