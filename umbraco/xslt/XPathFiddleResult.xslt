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
	<xsl:variable name="doc" select="umb:RequestQueryString('xdoc')" />
	
	<xsl:variable name="data" select="document($doc)" />
	<xsl:variable name="matched-nodes" select="ucom:FilterNodes($data, $xpath)" />
   
	<xsl:template match="/">
		
		<form action="{umb:NiceUrl($currentPage/@id)}" id="expression" class="HUD">
			<fieldset id="xpath-expression">
				<legend>XPath</legend>
				<label for="xpath">Expression</label>
				<input id="xpath" name="xpath" type="text" placeholder="Type an expression, e.g.: people/person[2]">
					<xsl:if test="normalize-space($xpath)">
						<xsl:attribute name="value"><xsl:value-of select="$xpath" /></xsl:attribute>
					</xsl:if>
				</input>
			</fieldset>

			<fieldset id="settings">
				<legend>Settings</legend>
				<div class="radiobutton"><input type="radio" name="view" id="view-filter" /><label>Filter</label></div>
				<div class="radiobutton"><input type="radio" name="view" id="view-hilite" /><label>Highlight</label></div>

				<xsl:if test="normalize-space($doc)">
					<input type="hidden" name="xdoc" value="{$doc}" />
				</xsl:if>
			</fieldset>

			<!-- <button type="submit">Evaluate</button> -->
		</form>

		<div id="results">
			<xsl:apply-templates select="$data" mode="xmlverb">
				<xsl:with-param name="indent-elements" select="true()" />
			</xsl:apply-templates>

			<dl id="stats">
				<dt># of matches: </dt>
				<dd><xsl:value-of select="count($matched-nodes)" /></dd>
			</dl>
		</div>
		
	</xsl:template>
	

</xsl:stylesheet>