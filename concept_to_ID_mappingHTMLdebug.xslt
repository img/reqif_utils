<!--
using this xslt requires that the dng html report be tweaked to make it xhtml.  
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
    xmlns:rm="http://www.ibm.com/xmlns/rdm/rdf/"
    xmlns:migration="http://www.ibm.com/rm/migration"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <!-- version 2.0 required to support use of key() in non-default document().
       This can be avoided if necessary.
       img dec 2016
  -->

  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>
 

  <!-- avoid warning from saxon by including rdf:RDF here explicitly -->
  <xsl:template match="xhtml:html|node()|@*" name="remove">
      <xsl:apply-templates select="node()|@*"/>
  </xsl:template>

  <xsl:variable name="debug_mode" select="false()"/>

  <xsl:variable name="src_mapping" select="document('export_report.html')"/>

  <xsl:key name="idFromConcept"
           match="//xhtml:tr/xhtml:td/text()"
           use='../../following-sibling::node()/xhtml:tr/xhtml:td/xhtml:a/@href' />

  <xsl:key name="conceptFromId"
           match="//xhtml:tr/xhtml:td/xhtml:a/@href"
           use='../../../preceding-sibling::*[1]/xhtml:td[2]/text()'/>

  <xsl:template match="//xhtml:tr/xhtml:td/xhtml:a/@href">
      <xsl:variable name="id" select="../../../preceding-sibling::*[1]/xhtml:td[2]/text()"/>
      <xsl:message select="$id"/>
  </xsl:template>    
</xsl:stylesheet>
