<!--  -*- mode: xml; -*- -->
<!--  Copyright 2017 Persistent Systems -->
<!--  img/edinburgh lab -->
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rif="http://automotive-his.de/200807/rif"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:doors="http://www.ibm.com/rdm/doors/RIF/xmlns/1.0"
    xmlns:rif-xhtml="http://automotive-his.de/200706/rif-xhtml"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <xsl:output omit-xml-declaration="no" method="xml"/>
  <!-- redact RIF1.2a package --> 

 <xsl:template match="//rif:OTHER-CONTENT|//*[not(self::rif:DATATYPE-DEFINITION-INTEGER
                                              or self::rif:DATATYPE-DEFINITION-DOCUMENT
                                              or self::rif:DATATYPE-DEFINITION-DATE
                                              or self::rif:ATTRIBUTE-DEFINITION-SIMPLE
                                              )]
                                              /rif:LONG-NAME[text() != 'Created Thru'
                                                             and text() != 'Last Modified On'
                                                             and text() != 'String'
                                                             and text() != 'Object Heading'
                                                             and text() != 'Object Short Text'
                                                             and text() != 'Absoulte Number'
                                                             and text() != 'Object Text']
                                   |//rif-xhtml:div|//rif:THE-VALUE|//rif:DESC|//doors:VIEW-NAME|//doors:VIEW-DATA">
   <xsl:variable name="elementname" select="concat('REDACTED-',generate-id(.))"/>
   <xsl:copy>
        <xsl:value-of select="$elementname">
        </xsl:value-of>
   </xsl:copy>
 </xsl:template>

  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
