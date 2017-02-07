<!--  -*- mode: xml; -*- -->
<!--  Copyright 2017 Persistent Systems -->
<!--  img/edinburgh lab -->
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xpath-default-namespace="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <xsl:output omit-xml-declaration="yes" method="xml"/>
 
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:key name="artefactTypeRefFromSameAsUri"
           match="rm:SPEC-OBJECT-TYPE-EXTENSION/rm:SPEC-TYPE-REF/text()"
           use="../../rm:SAME-AS/text()"/>

  <xsl:key name="typeSameAsFromTypeRef"
           match="rm:SPEC-OBJECT-TYPE-EXTENSION/rm:SAME-AS/text()"
           use="../../rm:SPEC-TYPE-REF/text()"/>


  <xsl:variable name="uriOfHeadingType" select="'http://tesla.com/ns#Heading'"/>
  <xsl:variable name="allHeadingSpecObjects" select="key('artefactTypeRefFromSameAsUri', $uriOfHeadingType)"/>

  <!-- SPEC-OBJECT by IDENTIFIER -->
  <xsl:key name="specObjectFromRef" match="reqif:SPEC-OBJECT" use="@IDENTIFIER"/>

  <xsl:key name="attrDefEnumFromDataTypeID"
           match="reqif:ATTRIBUTE-DEFINITION-ENUMERATION"
           use="reqif:TYPE/reqif:DATATYPE-DEFINITION-ENUMERATION-REF/text()"/>
  

  <!-- Transform the tool-id so that we know this is not pure DOORS NG output -->
  <xsl:template match="reqif:SOURCE-TOOL-ID/text()">
    <xsl:value-of select="."/>
    <xsl:text> (Heading Style Applied to Heading Artefact Types)</xsl:text>
  </xsl:template>


  <xsl:template match="rm:SPEC-OBJECT-EXTENSION">
    <xsl:variable name="specObjectRef" select="reqif:SPEC-OBJECT-REF/text()"/>
    <xsl:variable name="specObject" select="key('specObjectFromRef', $specObjectRef)"/>
    <xsl:variable name="specObjectTypeRef" select="$specObject/reqif:TYPE/reqif:SPEC-OBJECT-TYPE-REF/text()"/>
    <xsl:variable name="artefactTypeSameAs" select="key('typeSameAsFromTypeRef', $specObjectTypeRef)"/>
    <xsl:copy>
      <xsl:copy-of select="@*|*"/>
      <xsl:if test="$artefactTypeSameAs = $uriOfHeadingType">
        <rm:HEADING>true</rm:HEADING>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
