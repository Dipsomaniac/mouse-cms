<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "../dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Output -->
<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	method="html"
/>

<!-- Include -->
<xsl:include href="../all.xsl"/>
<xsl:include href="forms.xsl"/>
<xsl:include href="objects.xsl"/>

<!-- Gooo -->
<xsl:template match="/node()">
	<xsl:apply-templates select="/document/body/block[(@mode=1)]"/>
</xsl:template>

<!-- Block -->
<xsl:template match="/document/body/block">
	<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>