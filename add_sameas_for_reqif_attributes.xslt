<!--
//
// Licensed Materials - Property of IBM -  You may copy, modify, and distribute 
// these samples, or their modifications, in any form, internally or as part of your 
// application or related documentation.
//
// These samples have not been tested under all conditions and are provided to you
// by IBM without obligation of support of any kind.
//
// IBM PROVIDES THESE SAMPLES  "AS IS", SUBJECT TO ANY STATUTORY WARRANTIES
// THAT CANNOT BE EXCLUDED. IBM MAKES NO WARRANTIES OR CONDITIONS, EITHER 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
// OR CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
// NON-INFRINGEMENT REGARDING THESE SAMPLES OR TECHNICAL SUPPORT, IF ANY.
//
// (c) Copyright IBM Corporation 2014. All Rights Reserved.
//
// U.S. Government Users Restricted Rights: Use, duplication or disclosure restricted
// by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet
    version="2.0"
    exclude-result-prefixes="#all"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:migration="http://www.ibm.com/rm/migration"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>
  <xsl:param name="namespacePrefix" select="'http://ibm.com/rm/attributes/reqif/'"/>
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:variable name="debug_mode" select="false()"/>

  <!-- All the attribute definitions (of any type), keyed by LONG-NAME -->
  <xsl:key name="attrdefFromName"
           match="reqif:SPEC-ATTRIBUTES/*[matches(@LONG-NAME, 'ReqIF\..*')]"
           use="@LONG-NAME"/>

  <xsl:key name="sameAsFromID"
           match="rm-reqif:TYPE-EXTENSIONS/*/rm-reqif:SAME-AS/text()"
           use="../../*[1]/text()"/>


  <!-- Transform the tool-id so that we know this is not DOORS output -->
  <xsl:template match="reqif:SOURCE-TOOL-ID/text()">
    <xsl:value-of select="."/>
    <xsl:text> (Added same-as for _all_ ReqIF attributes)</xsl:text>
  </xsl:template>

  <xsl:template match="//rm-reqif:TYPE-EXTENSIONS/*[position()=last()]">
    <xsl:copy-of select="."/>

    <xsl:for-each select="//reqif:SPEC-ATTRIBUTES/*[generate-id() = generate-id(key('attrdefFromName',@LONG-NAME)[1])]">
      <xsl:variable name="attrdef" select="key('attrdefFromName',@LONG-NAME)"/>

      <xsl:for-each select="$attrdef">
        <xsl:variable name="attrdefid" select="@IDENTIFIER"/>
        <xsl:variable name="attrdefsameas" select="key('sameAsFromID', $attrdefid)"/>
        <xsl:if test="0 = count($attrdefsameas)">
          <xsl:variable name="attrdefname" select="$attrdef[1]/@LONG-NAME"/>
          <xsl:variable name="elementname" select="concat(local-name(),'-REF')"/>
          <rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION>
            <xsl:comment select="$attrdefname"/>
            <xsl:element name="{$elementname}">
              <xsl:value-of select="$attrdefid"/>
            </xsl:element>
            <rm-reqif:SAME-AS>
              <xsl:value-of select="concat($namespacePrefix, encode-for-uri($attrdefname))"/>
            </rm-reqif:SAME-AS>
          </rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
    
  </xsl:template>
</xsl:stylesheet>
