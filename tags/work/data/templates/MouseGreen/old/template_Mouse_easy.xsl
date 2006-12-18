<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

<!-- *IMPORT -->
<xsl:include href="template_Mouse_forms.xsl"/>
<xsl:include href="template_Mouse_object.xsl"/>
<xsl:include href="html.xsl"/>
<xsl:include href="header.xsl"/>
<!-- #IMPORT -->

<xsl:template match="/">
	<!-- CONTENT -->
	<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
</xsl:template>

</xsl:stylesheet>