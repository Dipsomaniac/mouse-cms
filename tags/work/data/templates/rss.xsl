<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "dtd/entities.dtd">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Output -->
<xsl:output	version="1.0" encoding="UTF-8" method="xml"/>

<!-- Gooo -->
<xsl:template match="/node()">
<rss version="2.0">
	<xsl:apply-templates select="/document/body/block/channel"/>
</rss>
</xsl:template>

<xsl:template match="channel">
<channel>
	<title><xsl:value-of select="@title"/></title>
	<link><xsl:value-of select="@link"/></link>
	<description><xsl:value-of select="@description"/></description>
	<generator><xsl:value-of select="@generator"/></generator>
	<webMaster><xsl:value-of select="@webmaster"/></webMaster>
	<lastBuildDate><xsl:value-of select="@date"/></lastBuildDate>
	<docs>http://blogs.law.harvard.edu/tech/rss</docs>
	<xsl:apply-templates select="/document/body/block/block_content//article"/>
	<xsl:apply-templates select="/document/body/block/block_content//forum_last"/>
</channel>
</xsl:template>

<xsl:template match="article|forum_last">
<item>
	<title><xsl:value-of select="@name"/></title>
	<description><xsl:value-of select="."/></description>
	<author><xsl:value-of select="@author"/></author>
	<pubDate><xsl:value-of select="@date"/></pubDate>
	<link><xsl:value-of select="//channel/@link"/>?id=<xsl:value-of select="@id"/></link>
	<guid isPermaLink="true"><xsl:value-of select="//channel/@link"/>?id=<xsl:value-of select="@id"/></guid>
</item>
</xsl:template>

</xsl:stylesheet>