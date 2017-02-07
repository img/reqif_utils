<xsl:stylesheet
    version="2.0"
    xmlns:reqif-xhtml="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <xsl:output omit-xml-declaration="yes" method="xml"/>
 
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="reqif:SOURCE-TOOL-ID/text()">
    <xsl:value-of select="."/>
    <xsl:text> (OLE renamed)</xsl:text>
  </xsl:template>

  <xsl:template match="reqif-xhtml:object/@data">
    <xsl:attribute name="data">
      <xsl:value-of select="replace(., '.ole$', '.rtf')"/>
    </xsl:attribute>
  </xsl:template>
  
</xsl:stylesheet>
