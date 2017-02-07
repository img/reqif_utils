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
// Author: img
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
  
  <!-- version 2.0 required to support use of key() in non-default document().
       This can be avoided if necessary.
       img dec 2013

       dependencies: customer_types_reqif2.xml containing the reqif package definining the
       rm:SPEC-OBJECT-TYPE-EXTENSION elements which map sameAsURI to ReqIF ID.  (This document
       does not need to be a full reqif package; only those elements are needed.)

      literal http://customer.com/.. URIs are kludge.  Should be lifted out as template parameters
  -->

  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>
 
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:variable name="debug_mode" select="false()"/>

  <!-- URI which identifies in DOORS9 data which attribute definition
       represents artefact type.  This must be a single-valued
       enumeration in the DOORS9 data.
  -->
  <!-- <xsl:variable name="artefactTypeURI" select="'http://customer.com/ns/attribute#objectType'"/> -->
  <!-- <xsl:variable name="artefactTypeURI" select="'http://persistent.com/ns/rm#ArtefactType'"/> -->
  <xsl:param name="artefactTypeURI" select="'http://persistent.com/attributes/rm#ArtefactType'"/>

  <!-- reqif package from DOORS NG that contains the target artefact types -->
  <xsl:variable name="type_target" select="document('customer_types10-7.reqif')"/>

  <xsl:key name="datatypeDefEnumFromID"
           match='reqif:DATATYPE-DEFINITION-ENUMERATION'
           use="@IDENTIFIER"/>
  
  <!-- DOORS 9.5.2 uses DATATYPE-DEFINITION-ENUMERATION-REF but 9.5.2.1 changed this to ENUM-VALUE-REF.
       This key is able to deal with both.
  -->
  <xsl:key name="sameAsUriFromEnumRef"
           match='rm-reqif:DATATYPE-DEFINITION-EXTENSION/rm-reqif:SAME-AS/text()'
           use="../../reqif:ENUM-VALUE-REF/text()|../../reqif:DATATYPE-DEFINITION-ENUMERATION-REF/text()"/>

  <xsl:key name="artefactTypeRefFromSameAsUri"
           match="rm:SPEC-OBJECT-TYPE-EXTENSION/rm:SPEC-TYPE-REF/text()"
           use="../../rm:SAME-AS/text()"/>
  
  <!-- those attrdef extensions which represent artefact type -->
  <xsl:key name="attrDefExtensionFromReqIFID"
           match="rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION[rm-reqif:SAME-AS/text() = $artefactTypeURI]"
           use="reqif:ATTRIBUTE-DEFINITION-ENUMERATION-REF/text()"/>
  
  <xsl:key name="attrDefEnumFromDataTypeID"
           match="reqif:ATTRIBUTE-DEFINITION-ENUMERATION"
           use="reqif:TYPE/reqif:DATATYPE-DEFINITION-ENUMERATION-REF/text()"/>
  

  <!-- All the attribute definitions (of any type), keyed by LONG-NAME -->
  <xsl:key name="attrdefFromName"
           match="reqif:SPEC-ATTRIBUTES/*"
           use="@LONG-NAME"/>

  <xsl:key name="sameAsFromID"
           match="rm-reqif:TYPE-EXTENSIONS/*/rm-reqif:SAME-AS/text()"
           use="../../*[1]/text()"/>


  <!-- Transform the tool-id so that we know this is not DOORS output -->
  <xsl:template match="reqif:SOURCE-TOOL-ID/text()">
    <xsl:value-of select="."/>
    <xsl:text> (SAME-AS added to all uniquely-named attribute definitions)</xsl:text>
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
          <rm-reqif:DATATYPE-DEFINITION-EXTENSION>
            <xsl:comment select="$attrdefname"/>
            <xsl:element name="{$elementname}">
              <xsl:value-of select="$attrdefid"/>
            </xsl:element>
            <rm-reqif:SAME-AS>
              <xsl:value-of select="concat('http://example.com/attr/', encode-for-uri($attrdefname))"/>
            </rm-reqif:SAME-AS>
          </rm-reqif:DATATYPE-DEFINITION-EXTENSION>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
    
  </xsl:template>
</xsl:stylesheet>
