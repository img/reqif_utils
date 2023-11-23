<!--  -*- mode: xml; -*- -->
<!--  img/edinburgh lab -->
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif-common="http://www.prostep.org/reqif"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif"
    xsi:schemaLocation="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd reqif.xsd"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:xhtml="http://www.w3.org/1999/xhtml">
  
  <xsl:output omit-xml-declaration="no" method="xml"/>
  <!-- redact reqif1.2 package -->

  <xsl:key name="obfuscation" match="@LONG-NAME" use="."/>
  <xsl:key name="value-obfuscation" match="@THE-VALUE" use="."/>
  <xsl:key name="other-content-obfuscation" match="//reqif:EMBEDDED-VALUE/@OTHER-CONTENT" use="."/>

  <xsl:template match="//reqif:REQ-IF-HEADER/reqif:TITLE">
    <xsl:variable name="title" select="text()"/>
   <xsl:copy>
        <xsl:value-of select="concat($title, ' (redacted)')">
        </xsl:value-of>
   </xsl:copy>
</xsl:template>


<xsl:template match="@LONG-NAME">
        <xsl:attribute name="LONG-NAME">
            <xsl:value-of select="concat('redacted-', generate-id(key('obfuscation',.)[1]))"/>
        </xsl:attribute>
</xsl:template>

<xsl:template match="//reqif:EMBEDDED-VALUE/@OTHER-CONTENT[not(
		        . = 'Document'
		     or . = 'Glossary'
		     or . = 'Collection'
		     or . = 'Term'
		     or . = 'Text'
		     or . = 'Part'
		     or . = 'Sketch'
		     or . = 'ScreenFlow'
		     or . = 'Storyboard'
		     or . = 'BusinessProcessDiagram'
		     or . = 'SimpleFlowDiagram'
		     or . = 'UseCaseDiagram'
		     or . = 'WrapperResource'
		     or . = 'Module'
		     or . = 'Composite'
		     or . = 'Diagram'
		     )]">
        <xsl:attribute name="OTHER-CONTENT">
            <xsl:value-of select="concat('redacted-', generate-id(key('other-content-obfuscation',.)[1]))"/>
        </xsl:attribute>
</xsl:template>

<xsl:template match="*[not(self::reqif:ATTRIBUTE-VALUE-DATE)]/@THE-VALUE">
        <xsl:attribute name="THE-VALUE">
            <xsl:value-of select="concat('redacted-', generate-id(key('value-obfuscation',.)[1]))"/>
        </xsl:attribute>
</xsl:template>

<!--<xsl:template match="*/@THE-VALUE">
        <xsl:attribute name="THE-VALUE">
            <xsl:value-of select="concat('redacted-', generate-id(key('value-obfuscation',.)[1]))"/>
        </xsl:attribute>
</xsl:template> -->

<xsl:template match="xhtml:div//text()">
  <xsl:variable name="red" select="concat('redacted-text-', generate-id(.))"/>
  <xsl:value-of select="$red"></xsl:value-of>
</xsl:template>

<xsl:template match="rm:ATTRIBUTE-VALUE-XHTML//text()">
  <xsl:variable name="red" select="concat('redacted-text-', generate-id(.))"/>
  <xsl:value-of select="$red"></xsl:value-of>
</xsl:template>

<!--
<xsl:template match="//reqif:ENUM-VALUE/@reqif:LONG-NAME">
   <xsl:variable name="elementname" select="concat('REDACTED-',generate-id(.))"/>
   <xsl:copy>
        <xsl:value-of select="$elementname">
        </xsl:value-of>
   </xsl:copy>
 </xsl:template>
-->
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
<!-- <xsl:template match="//rif:OTHER-CONTENT|//*[not(self::rif:DATATYPE-DEFINITION-INTEGER
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
-->



</xsl:stylesheet>
