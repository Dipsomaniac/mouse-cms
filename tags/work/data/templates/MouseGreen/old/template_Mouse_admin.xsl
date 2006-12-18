<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" />

<!-- *IMPORT -->
<xsl:include href="template_Mouse_forms.xsl"/>
<xsl:include href="template_Mouse_object.xsl"/>
<xsl:include href="header.xsl"/>
<xsl:include href="html.xsl"/>
<!-- #IMPORT -->

<xsl:template match="/">
	<html>
		<!-- HEAD -->
		<head>
		<xsl:apply-templates select="/document/headers" />
		</head>
		<body>
		<!-- BODY -->
		<xsl:apply-templates select="/document/body" />
		<!-- FOOTER_SCRIPT -->
		<xsl:apply-templates select="//js_footer" />
		</body>
	</html>
</xsl:template>

	
<!-- CONTENT* -->
<xsl:template match="/document/body">
<div id="rap">
	<!-- HEADER -->
	<div id="header">
		<xsl:apply-templates select="//menu"/>
		<h1><a href="http://{/document/system/site/.}" title="{/document/headers/main_url/.}"><xsl:value-of select="/document/system/site"/></a></h1>
		<div id="desc"><xsl:value-of select="/document/headers/document_name"/></div>
	</div>
	<!-- MAIN -->
	<div id="main">
			<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
		<!-- FOOTER -->
		<p id="footer">
			<xsl:text>Справка | Техническая поддержка | О программе</xsl:text>
			<br /><xsl:text>Copyright (с) 2006 KLeN</xsl:text><br />
		</p>
  	</div>
</div>
</xsl:template>
<!-- CONTENT# -->
</xsl:stylesheet>