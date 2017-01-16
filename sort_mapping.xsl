<xsl:stylesheet
    version="2.0"
    exclude-result-prefixes="#all"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/xmlns/rdm/rdf/"
    xmlns:migration="http://www.ibm.com/rm/migration"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">

  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>

 <xsl:template match="node()|@*">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
 </xsl:template>

  <xsl:variable name="debug_mode" select="false()"/>

  <xsl:template match="/rdf:RDF/rm:idMapping">
    <xsl:copy>
      <xsl:apply-templates select="./rm:mapping">
	<xsl:sort select="./dcterms:identifier/text()"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
