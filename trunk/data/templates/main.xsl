<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Output -->
<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
/>

<!-- Include -->
<xsl:include href="all.xsl"/>

<!-- Header -->
<xsl:template name="header">
	<head>
		<!--   -->
		<title><xsl:value-of select="header/window_name" /></title>
		<!--  meta -->
		<xsl:if test="string(header/keywords)">
			<meta name="keywords" lang="{@lang}" content="{header/keywords}"/>
		</xsl:if>
		<!-- =debug   -->
		<meta http-equiv="Content-Type" content="text/html; charset=WINDOWS-1251" />
		<!-- RSS Feed =debug -->
		<xsl:call-template name="RSS"/>
		<!--  =debug -->
		<!-- <link rel="Shortcut Icon" href="/favicon.ico"/> -->
		<!--       -->
		<xsl:apply-templates select="//css" />
		<xsl:apply-templates select="//css_head" />
		<!--  java     -->
		<xsl:apply-templates select="//js" />
		<xsl:apply-templates select="//js_head" />
</head>
</xsl:template>

<!-- RSS feed -->
<xsl:template name="RSS">
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0 feed" href="/news/rss/"/>
</xsl:template>

<!-- java-css scripts [js|js_head|css|css_head]-->
<xsl:template match="//js">
<script type="text/javascript" src="{@source}" />
</xsl:template>
<xsl:template match="//js_head|//js_footer">
<script type="text/javascript">
	<xsl:value-of select="."/>
</script>
</xsl:template>
<xsl:template match="//css">
<link rel="stylesheet" href="{@source}"/>
</xsl:template>
<xsl:template match="//css_head">
<style type="text/css" media="all">
	<xsl:value-of select="." />
</style>
</xsl:template>

</xsl:stylesheet>