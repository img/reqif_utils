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
    xmlns:rm="http://www.ibm.com/xmlns/rdm/rdf/"
    xmlns:migration="http://www.ibm.com/rm/migration"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <!-- version 2.0 required to support use of key() in non-default document().
       This can be avoided if necessary.
       img dec 2016
  -->

  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>
 

  <!-- avoid warning from saxon by including rdf:RDF here explicitly -->
  <xsl:template match="rdf:RDF|node()|@*" name="identity">
      <xsl:apply-templates select="node()|@*"/>
  </xsl:template>

  <xsl:variable name="debug_mode" select="false()"/>

  <xsl:variable name="src_mapping" select="document('export_mapping.rdf')"/>

  <xsl:key name="idFromConcept"
           match='rdf:RDF/rm:idMapping/rm:mapping/dcterms:identifier/text()'
           use="../../rm:resource/@rdf:resource"/>

  <xsl:key name="conceptFromId"
           match="rdf:RDF/rm:idMapping/rm:mapping/rm:resource/@rdf:resource"
           use='../../dcterms:identifier/text()'/>

  <xsl:template match="/rdf:RDF/rm:idMapping/rm:mapping/rm:resource/@rdf:resource">
    <xsl:variable name="target_concept" select="."/>
    <xsl:variable name="id" select="key('idFromConcept', $target_concept)"/>
    <xsl:variable name="source_concept" select="key('conceptFromId', $id, $src_mapping)"/>

    <xsl:if test="1 != count($source_concept)">
      <xsl:comment select="'No unique src for the following entry - ommited'"/>
      <xsl:message select="concat('No unique src for ', $target_concept)"/>
    </xsl:if>
    <entry>
      <xsl:attribute name="identifier">
        <xsl:copy-of select="$id"/>
      </xsl:attribute>
      <xsl:if test="1 = count($source_concept)">
        <xsl:attribute name="src">
          <xsl:copy-of select="$source_concept"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="trg">
        <xsl:copy-of select="$target_concept"/>
      </xsl:attribute>
    </entry>
  </xsl:template>
</xsl:stylesheet>
