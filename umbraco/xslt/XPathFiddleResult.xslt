<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	xmlns:ucom="urn:ucomponents.xml"
	xmlns:make="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="umb ucom make"
>
	
	<xsl:import href="xmlverbatim.xslt" />

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="currentPage" />
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::Website" />
	
	<xsl:variable name="defaultDocProxy">
		<doc>data.xml</doc>
	</xsl:variable>
	<xsl:variable name="defaultDoc" select="make:node-set($defaultDocProxy)" />
	
	<xsl:variable name="xpath" select="normalize-space(umb:RequestQueryString('xpath'))" />
	<xsl:variable name="doc" select="normalize-space(umb:RequestQueryString('xdoc'))" />
	<xsl:variable name="filterMatched" select="boolean(umb:RequestQueryString('filter') = 1)" />
	
	<xsl:variable name="data" select="document(concat($doc, $defaultDoc/doc[not($doc)]))" />
	<xsl:variable name="matched-nodes" select="ucom:FilterNodes($data, $xpath)" />
	
	<xsl:template match="/">
		
		<form action="{umb:NiceUrl($currentPage/@id)}" id="expression" class="HUD" method="get">
			<fieldset id="xpath-expression">
				<legend>XPath</legend>
				<label for="xpath">Expression</label>
				<input id="xpath" name="xpath" type="text" placeholder="Type an expression, e.g.: people/person[2]" tabindex="1">
					<xsl:if test="$xpath">
						<xsl:attribute name="value"><xsl:value-of select="$xpath" /></xsl:attribute>
					</xsl:if>
				</input>
			</fieldset>

			<fieldset id="xml-document">
				<legend>XML</legend>
				<label for="xdoc">URL</label>
				<input class="top" id="xdoc" name="xdoc" type="text" placeholder="URL for the XML document, e.g.: data.xml" tabindex="3">
					<xsl:if test="$doc">
						<xsl:attribute name="value"><xsl:value-of select="$doc" /></xsl:attribute>
					</xsl:if>
				</input>
			</fieldset>

			<fieldset id="settings">
				<legend>Settings</legend>
				<div class="radiobutton"><input type="radio" name="view" id="view-filter" /><label>Filter</label></div>
				<div class="radiobutton"><input type="radio" name="view" id="view-hilite" /><label>Highlight</label></div>
			</fieldset>
			
			<button type="submit">Go</button>
		</form>

		<a href="#" id="toggle" tabindex="2">Open</a>

		<xsl:if test="$data">
						
			<div id="results">
				<xsl:if test="$filterMatched"><xsl:attribute name="class">filtered</xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="$filterMatched">
						<div class="xmlverb-default">
							<xsl:apply-templates select="$matched-nodes" mode="xmlverb" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$data" mode="xmlverb">
							<xsl:with-param name="indent-elements" select="true()" />
						</xsl:apply-templates>				
					</xsl:otherwise>
				</xsl:choose>
				
				<dl id="stats">
					<dt># of matches: </dt>
					<dd><xsl:value-of select="count($matched-nodes)" /></dd>
				</dl>
			</div>
			
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>