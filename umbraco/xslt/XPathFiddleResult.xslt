<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	xmlns:ucom="urn:ucomponents.xml"
	xmlns:xpf="urn:xpath.fiddle"
	xmlns:make="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="umb ucom make xpf"
>
	
	<xsl:import href="xmlverbatim.xslt" />

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="currentPage" />
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::Website" />
	
	<xsl:variable name="debug" select="false()" />
	
	<xsl:variable name="quot" select="'&quot;'" />
	<xsl:variable name="apos">'</xsl:variable>
	<xsl:variable name="errorFlag" select="' &lt;-- '" />
	<xsl:variable name="resultFlag" select="' =&gt; '" />

	<!-- Grab QueryString params -->
	<xsl:variable name="doc" select="normalize-space(umb:RequestQueryString('xdoc'))" />
	<xsl:variable name="xpath" select="normalize-space(umb:RequestQueryString('xpath'))" />
	<xsl:variable name="filterMatched" select="boolean(umb:RequestQueryString('filter') = 1)" />

	<xsl:variable name="docsProxy">
		<doc><xsl:value-of select="translate($doc, concat($quot, $apos), '')" /></doc>
		<doc>data.xml</doc>
	</xsl:variable>
	<xsl:variable name="docs" select="make:node-set($docsProxy)/doc" />
	
	<xsl:variable name="data" select="document(concat($docs[normalize-space()][not(starts-with(., '../'))][1], ''))" />
	<xsl:variable name="xpathSend">
		<xsl:choose>
			<xsl:when test="contains($xpath, $errorFlag)">
				<xsl:value-of select="substring-before($xpath, $errorFlag)" />
			</xsl:when>
			<xsl:when test="contains($xpath, $resultFlag)">
				<xsl:value-of select="substring-before($xpath, $resultFlag)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$xpath" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="matched-nodes" select="xpf:FilterNodes($data, $xpathSend)" />
	
	<xsl:variable name="xpath-error" select="$matched-nodes[descendant-or-self::Exception][normalize-space($xpathSend)]" />
	<xsl:variable name="xpath-value" select="$matched-nodes/descendant-or-self::result[@expression]" />
	
	<xsl:template match="/">
		
		<xsl:call-template name="HelpSheet" />
		
		<div class="application">
		
			<form action="{umb:NiceUrl($currentPage/@id)}" id="expression" class="HUD" method="get">
				<xsl:if test="$xpath-error"><xsl:attribute name="class">HUD error</xsl:attribute></xsl:if>
				<fieldset id="xpath-expression">
					<legend>XPath</legend>
					<label for="xpath">Expression</label>
					<input id="xpath" name="xpath" type="text" placeholder="Type an expression, e.g.: person[2]/name" tabindex="1">
						<xsl:if test="$xpathSend">
							<xsl:attribute name="value">
								<xsl:value-of select="$xpathSend" />
								<xsl:if test="$xpath-error">
									<xsl:value-of select="concat($errorFlag, $xpath-error//Message)" />
								</xsl:if>
								<xsl:if test="$xpath-value">
									<xsl:apply-templates select="$xpath-value" />
								</xsl:if>
							</xsl:attribute>
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

			<a href="?showdoc" class="toggle doc-toggle" tabindex="2">Open</a>

			<xsl:if test="$data">
						
				<div id="results">
					<xsl:if test="not($matched-nodes)"><xsl:attribute name="class">nomatch</xsl:attribute></xsl:if>
					<xsl:if test="$filterMatched"><xsl:attribute name="class">filtered</xsl:attribute></xsl:if>
					<xsl:choose>
						<xsl:when test="$filterMatched or $xpath-value">
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
						<dd><xsl:value-of select="count($matched-nodes) - number(not(normalize-space($xpathSend)))" /></dd>
						<dt>value? :</dt>
						<dd><xsl:value-of select="$xpath-value" /></dd>
					</dl>
				</div>
			
			</xsl:if>
		
		</div>
		<xsl:call-template name="debug" />
	</xsl:template>
	
	<xsl:template name="HelpSheet">
		<section id="help">
			<header>
				<h1>Help Sheet</h1>
				<a href="?showhelp=yes" class="toggle help-toggle">Help</a>
			</header>
			<h2>Shortcuts</h2>
			<dl class="general">
				<dt><code>?</code></dt>
				<dd>Open this sheet</dd>
				<dt><code>x</code></dt>
				<dd>Focus the XPath field</dd>
			</dl>
			<h2>Auto pairs</h2>
			<p>
				Typing <code>(</code>, <code>[</code> or <code>'</code> will automatically insert
				the matching character after it.
			</p>
		</section>
	</xsl:template>
	
	<xsl:template match="result[@expression]">
		<xsl:value-of select="concat($resultFlag, .)" />
	</xsl:template>
	
	<xsl:template match="result[. = 'True'] | result[. = 'False']">
		<xsl:value-of select="concat($resultFlag, translate(., 'TF', 'tf'), '()')" />
	</xsl:template>
	
	<xsl:template name="debug">
		<xsl:if test="$debug">
			<textarea rows="8" cols="40">
				<xsl:comment>$matched-nodes</xsl:comment>
				<xsl:copy-of select="$matched-nodes" />
			</textarea>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>