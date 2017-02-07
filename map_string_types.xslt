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
// (c) Copyright IBM Corporation 2012. All Rights Reserved.
//
// U.S. Government Users Restricted Rights: Use, duplication or disclosure restricted
// by GSA ADP Schedule Contract with IBM Corp.

Transforms DOORS reqif packages so that Text and String are replaced
with NG's idea of string.

Doing so avoids having Text and String 2 (etc.) datatypes in NG.
-->

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <xsl:output omit-xml-declaration="no" method="xml"/>
 
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match='reqif:SOURCE-TOOL-ID/text()'>
    <xsl:value-of select='.'/>
    <xsl:text> (String types mapped)</xsl:text>
  </xsl:template>

  <xsl:template name="map_string_types"
                match="//rm-reqif:SAME-AS/text()[. = 'http://jazz.net/ns/rm/doors/type#text'
                                                 or
                                                 . = 'http://jazz.net/ns/rm/doors/type#string']">
    <xsl:text>http://www.w3.org/2001/XMLSchema#string</xsl:text>
  </xsl:template>

</xsl:stylesheet>
