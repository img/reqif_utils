<!--  -*- mode: xml; -*- -->
<!--  Copyright 2017 Persistent Systems -->
<!--  img/edinburgh lab -->
<!-- dunps dng mapping files -->
<xsl:stylesheet
    version="2.0"
    exclude-result-prefixes="#all"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rm="http://www.ibm.com/xmlns/rdm/rdf/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rmReqIF="http://www.ibm.com/xmlns/rdm/reqif/"
    xmlns:jfs="http://jazz.net/xmlns/foundation/1.0/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  
  <!-- version 2.0 required to support use of key() in non-default document().
       This can be avoided if necessary.
       img dec 2016
  -->

  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="no"/>
 

  <!-- avoid warning from saxon by including rdf:RDF here explicitly -->
  <xsl:template match="rdf:RDF|node()|@*" name="identity">
      <xsl:apply-templates select="node()|@*"/>
  </xsl:template>

  <xsl:variable name="debug_mode" select="false()"/>

  <xsl:template match="/rdf:RDF/rm:idMapping/rm:mapping/rm:resource/@rdf:resource">
    <xsl:variable name="resource" select="."/>
    <xsl:variable name="reqifid" select="../../dcterms:identifier/text()"/>
    <xsl:text>&#xa;</xsl:text>
    <entry>
      <xsl:attribute name="reqifid">
	<xsl:choose>
	  <xsl:when test="1 = count($reqifid)">
	    <xsl:copy-of select="$reqifid"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="'______________________'"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="uri">
        <xsl:copy-of select="$resource"/>
      </xsl:attribute>

    </entry>

  </xsl:template>
</xsl:stylesheet>
