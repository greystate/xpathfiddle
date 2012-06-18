<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	xmlns:ucom="urn:ucomponents.xml"
	exclude-result-prefixes="umb ucom"
>
	
	<xsl:import href="xmlverbatim.xslt" />

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="currentPage" />
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::Website" />
	
	<xsl:variable name="xpath" select="umb:RequestQueryString('xpath')" />
	
	<xsl:variable name="data" select="document('lost-people.xml')" />
	<xsl:variable name="matched-nodes" select="ucom:FilterNodes($data, $xpath)" />
   
	<xsl:template match="/">
		<xsl:apply-templates select="$data" mode="xmlverb">
			<xsl:with-param name="indent-elements" select="true()" />
		</xsl:apply-templates>
	</xsl:template>
	

</xsl:stylesheet>