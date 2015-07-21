<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" doctype-public="-//Apple//DTD PLIST 1.0//EN" doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd" />

	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="string[preceding-sibling::key[1] = 'font']" priority="1">
		<xsl:choose>
			<xsl:when test="contains(., 'bold')">
				<xsl:element name="string">
					<xsl:text>Meiryo UI Bold</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="string">
					<xsl:text>Meiryo UI</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
	</xsl:template>

	<!-- preserve empty tag -->
	<xsl:template match="*[not(child::node() or child::text())]">
		<xsl:element name="{local-name()}">
			<xsl:copy-of select="@*" />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
