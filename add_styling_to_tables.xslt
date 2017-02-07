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
    xmlns:reqif-xhtml="http://www.w3.org/1999/xhtml"
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
<!-- 
<jazz_rm:primaryText rdf:parseType="Literal"><div xmlns="http://www.w3.org/1999/xhtml">
<table border="1" cellpadding="1" cellspacing="1" dir="ltr" id="_1399103098357" style="width:100%">	<tbody>		<tr>			<td colspan="1" id="_1399103098358" rowspan="1"><span> </span></td>			<td colspan="1" id="_1399103098359" rowspan="1"><span> </span></td>		</tr>		<tr>			<td colspan="1" id="_1399103098360" rowspan="1"><span> </span></td>			<td colspan="1" id="_1399103098361" rowspan="1"><span> </span></td>		</tr>		<tr>			<td colspan="1" id="_1399103098362" rowspan="1"><span> </span></td>			<td colspan="1" id="_1399103098363" rowspan="1"><span> </span></td>		</tr>	</tbody></table>
<p dir="ltr" id="_1399103098356">Pin #</p>

-->

  <!-- Transform the tool-id so that we know this is not DOORS output -->
  <xsl:template match="reqif:SOURCE-TOOL-ID/text()">
    <xsl:value-of select="."/>
    <xsl:text> (Added table styling)</xsl:text>
  </xsl:template>

  <xsl:template match="//reqif-xhtml:table">
    <xsl:copy>
      <xsl:attribute name="border">1</xsl:attribute>
      <xsl:attribute name="cellpadding">1</xsl:attribute>
      <xsl:attribute name="cellspacing">1</xsl:attribute>
      <xsl:attribute name="style">width:100%</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
