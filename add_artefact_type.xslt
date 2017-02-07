<!-- -*- mode: xml; -*-
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
  
  <!-- version 2.0 required to support use of key() in non-default document().
       This can be avoided if necessary.
       img dec 2013

       dependencies: customer_types_reqif2.xml containing the reqif package definining the
       rm:SPEC-OBJECT-TYPE-EXTENSION elements which map sameAsURI to ReqIF ID.  (This document
       does not need to be a full reqif package; only those elements are needed.)

      literal http://customer.com/.. URIs are kludge.  Should be lifted out as template parameters
  -->

  <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml"/>
 
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
  <!-- <xsl:variable name="artefactTypeURI" select="'http://ibm.com/ns/rm#ArtefactType'"/> -->
  <xsl:param name="artefactTypeURI" select="'http://ibm.com/attributes/rm#ArtefactType'"/>

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
  

  <!-- Transform the tool-id so that we know this is not DOORS output -->
  <xsl:template match="reqif:SOURCE-TOOL-ID/text()">
    <xsl:value-of select="."/>
    <xsl:text> (Artefact Types Mapped</xsl:text>
    <xsl:text> using </xsl:text><xsl:value-of select="$artefactTypeURI"/><xsl:text>)</xsl:text>
  </xsl:template>


  <xsl:function name="migration:mapType">
    <xsl:param name="type_node"/>
    <xsl:variable name="rv">
      <xsl:for-each select="$type_node/../../reqif:VALUES/reqif:ATTRIBUTE-VALUE-ENUMERATION/reqif:DEFINITION/reqif:ATTRIBUTE-DEFINITION-ENUMERATION-REF/text()">
        <xsl:variable name="attrDefID" select="."/>
        <xsl:if test="$debug_mode">
          <xsl:variable name="debug1"
                        select="concat('attrDefID: ', $attrDefID)"/>
          <xsl:comment select="$debug1"/>
        </xsl:if>

        <!-- lookup to see if this attrdef represents artefact type -->
        <xsl:variable name="attrDefRepresentsArtefactType" select="key('attrDefExtensionFromReqIFID', $attrDefID)"/>
        <xsl:if test="$debug_mode">
          <xsl:comment select="concat('attrDefRepresentsArtefactType: ', $attrDefRepresentsArtefactType)"/>
        </xsl:if>

        <xsl:if test="$attrDefRepresentsArtefactType">
          <xsl:if test="$debug_mode">
            <xsl:comment select="concat('Found attrDefID: ', $attrDefID)"/>
          </xsl:if>

          <!-- use the value of this enumeration as the
               spec-object-type.  Notice that it would be bad for there
               to be multiple such values -->
          <xsl:variable name="enumValue"
                        select="$attrDefID/../../../reqif:VALUES/reqif:ENUM-VALUE-REF/text()"/>
          <xsl:if test="$debug_mode">
            <xsl:comment select="concat('Found enumValue: ', $enumValue)"/>
          </xsl:if>

          <xsl:if test="1 != count($enumValue)">
            <xsl:variable name="err" select="'Error: ArtefactType mapping cannot be multi-valued or null'"/>
            <xsl:message select="$err"/>
            <xsl:comment select="$err"/>
          </xsl:if>
          <xsl:if test="1 = count($enumValue)">
            <xsl:if test="$debug_mode">
              <xsl:comment>Found single enumValue</xsl:comment>
              <xsl:comment select="'Found enumValue:'"/>
              <xsl:comment select="$enumValue"/>
            </xsl:if>
            
            <xsl:variable name="sameAsUri" select="key('sameAsUriFromEnumRef', $enumValue)"/>
            <xsl:variable name="artefactTypeRef" select="key('artefactTypeRefFromSameAsUri', $sameAsUri, $type_target)"/>
            <xsl:if test="$debug_mode">
              <xsl:comment>
                <xsl:comment>sameAsUri: </xsl:comment>
                <xsl:value-of select="$sameAsUri"/>
              </xsl:comment>
            </xsl:if>

            <xsl:if test="$artefactTypeRef">
              <migration:MAPPED-TYPE>
                <xsl:if test="$debug_mode">
                  <xsl:comment>
                    <xsl:value-of select="$sameAsUri"/>
                    <xsl:value-of select="'enumValue is: '"/>
                    <xsl:value-of select="$enumValue"/>
                  </xsl:comment>
                </xsl:if>
                <xsl:value-of select="$artefactTypeRef"/>
              </migration:MAPPED-TYPE>
            </xsl:if>
            <xsl:if test="not($artefactTypeRef)">
              <xsl:variable name="err"
                            select="concat('Error: unable to find artefact type in type_target which maps ', $sameAsUri)"/>
              <xsl:message select="$err"/>
              <xsl:comment select="$err"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="$rv"/>
  </xsl:function>


  <!-- SPECIFICATION-TYPE-REF written by DOORS is unique to the source
       module.  When the module has an assigned artefact type, refer
       to the DNG artefact type ID.  Otherwise, leave unchanged.
       
       Comments inserted in the output tree are FYI only.
  -->
  <xsl:template match="reqif:SPECIFICATION/reqif:TYPE/reqif:SPECIFICATION-TYPE-REF">
    <xsl:variable name="spec_type" select="."/>
    <xsl:variable name="mappedID" select="migration:mapType($spec_type)"/>    
    <xsl:choose>
      <xsl:when test="$mappedID/migration:MAPPED-TYPE">
        <SPECIFICATION-TYPE-REF>
          <xsl:copy-of select="$mappedID/migration:MAPPED-TYPE/node()"/>
        </SPECIFICATION-TYPE-REF>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="msg" select="'Warning: No SPEC-OBJECT-TYPE mapping for SPECIFICATION-OBJECT.  Missing enum value?  (Check DOORS default value/deleted objects/table objects).)'"/>
        <xsl:message select="$msg"/>
        <xsl:comment select="$msg"/>
        <xsl:text>
        </xsl:text>
        <xsl:copy-of select="$spec_type"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <!-- Ditto for SPEC-OBJECT -->
  <xsl:template match="reqif:SPEC-OBJECT/reqif:TYPE/reqif:SPEC-OBJECT-TYPE-REF">
    <xsl:variable name="spec_type" select="."/>
    <xsl:variable name="mappedID" select="migration:mapType($spec_type)"/>    
    <xsl:choose>
      <xsl:when test="$mappedID/migration:MAPPED-TYPE">
        <SPEC-OBJECT-TYPE-REF>
          <xsl:copy-of select="$mappedID/migration:MAPPED-TYPE/node()"/>
        </SPEC-OBJECT-TYPE-REF>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="msg" select="'Warning: No SPEC-OBJECT-TYPE mapping for SPEC-OBJECT.  Missing enum value?  (Check DOORS is not using default value/deleted object.)'"/>
        <xsl:message select="$msg"/>
        <xsl:comment select="$msg"/>
        <xsl:text>
        </xsl:text>
        <xsl:copy-of select="$spec_type"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Remove ATTRIBUTE-VALUE-ENUMERATIONs which represent artefact
       type assignments.  (This has been transformed into the assigned
       artefact type.)
  -->
  <xsl:template match="reqif:ATTRIBUTE-VALUE-ENUMERATION">
    <xsl:variable name="enumValue"
                  select="reqif:VALUES/reqif:ENUM-VALUE-REF/text()"/>
    <xsl:variable name="sameAsUri" select="key('sameAsUriFromEnumRef', $enumValue)"/>
    <xsl:variable name="artefactTypeRef" select="key('artefactTypeRefFromSameAsUri', $sameAsUri, $type_target)"/>
    <xsl:if test="$artefactTypeRef">
      <xsl:comment>
        <xsl:value-of select="$sameAsUri"/>
      </xsl:comment>
    </xsl:if>
    <xsl:if test="not($artefactTypeRef)">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove ATTRIBUTE-DEFINITION-ENUMERATIONs which represent
       artefact type assignments.
  -->
  <xsl:template match="reqif:ATTRIBUTE-DEFINITION-ENUMERATION">
   <xsl:variable name="reqifid" select="@IDENTIFIER"/>
   <xsl:variable name="attrdefextension" select="key('attrDefExtensionFromReqIFID', $reqifid)"/>
   <xsl:if test="$attrdefextension">
     <xsl:comment>
       <xsl:value-of select="$reqifid"/>
     </xsl:comment>
   </xsl:if>
   <xsl:if test="not($attrdefextension)">
     <xsl:copy-of select="."/>
   </xsl:if>
  </xsl:template>
  

  <!-- Remove rm-reqif:ATTRIBUTE-DEFINITION-EXTENSIONs which represent
       artefact type
  -->
  <xsl:template match="rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION[rm-reqif:SAME-AS/text() = $artefactTypeURI]">
  </xsl:template>

  <!-- Remove all datatypes representing artefact type -->
  <xsl:template match="reqif:DATATYPE-DEFINITION-ENUMERATION">
    <xsl:variable name="dataTypeID" select="@IDENTIFIER"/>
    <xsl:variable name="attrdefenum" select="key('attrDefEnumFromDataTypeID', $dataTypeID)"/>
    <xsl:if test="$attrdefenum">
      <xsl:variable name="attrdefextensionID" select="$attrdefenum/@IDENTIFIER"/>
      <xsl:variable name="attrdefextension" select="key('attrDefExtensionFromReqIFID', $attrdefextensionID)"/>
      <xsl:if test="not($attrdefextension)">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="not($attrdefenum)">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove all SPECIFICATION-TYPE objects representing artefact type -->
  <xsl:template match="reqif:XXXSPECIFICATION-TYPE | reqif:XXXSPEC-OBJECT-TYPE">
    <xsl:variable name="dataTypeID"
                  select="reqif:SPEC-ATTRIBUTES/reqif:ATTRIBUTE-DEFINITION-ENUMERATION/reqif:TYPE/reqif:DATATYPE-DEFINITION-ENUMERATION-REF/text()"/>
    <xsl:variable name="attrdefenum" select="key('attrDefEnumFromDataTypeID', $dataTypeID)"/>
    <xsl:if test="$attrdefenum">
      <xsl:variable name="attrdefextensionID" select="$attrdefenum/@IDENTIFIER"/>
      <xsl:variable name="attrdefextension" select="key('attrDefExtensionFromReqIFID', $attrdefextensionID)"/>
      <xsl:if test="not($attrdefextension)">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="not($attrdefenum)">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  

  <xsl:key name="attributeDefinitionRefFromSameAsUri"
           match="rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION/reqif:ATTRIBUTE-DEFINITION-XHTML-REF/text()"
           use="../../rm-reqif:SAME-AS/text()"/>

   <!-- Transform all references to Object Heading into corresponding ReqIF.Text in DNG for the attribute definition
        which is associated with the SPEC-TYPE being assigned to headings.
     -->  

  <xsl:template name="map_heading_and_primary_text"
                match="reqif:ATTRIBUTE-VALUE-XHTML/reqif:DEFINITION/reqif:ATTRIBUTE-DEFINITION-XHTML-REF/text()">
    <xsl:variable
        name="attrDefRefForPrimaryText"
        select="key('attributeDefinitionRefFromSameAsUri', 'http://jazz.net/ns/rm#primaryText', $type_target)" />
    <xsl:variable
        name="attrDefRefForHeading"
        select="key('attributeDefinitionRefFromSameAsUri', 'http://www.ibm.com/rm/reqif#heading', $type_target)" />
      <xsl:if test="matches(., '.*_OBJECTHEADING')">
          <xsl:if test="not($attrDefRefForHeading)">
            <xsl:message>Error: can't find heading</xsl:message>
            <xsl:copy-of select="'error'"/>
          </xsl:if>
        <xsl:value-of select="$attrDefRefForHeading"/>
      </xsl:if>
      <xsl:if test="not(matches(., '.*_OBJECTHEADING'))">
        <xsl:if test="matches(., '.*_OBJECTTEXT')">
          <xsl:if test="not($attrDefRefForPrimaryText)">
            <xsl:message>Error: can't find primary text</xsl:message>
            <xsl:copy-of select="'error'"/>
          </xsl:if>
          <xsl:value-of select="$attrDefRefForPrimaryText"/>
        </xsl:if>
        <xsl:if test="not(matches(., '.*_OBJECTTEXT'))">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:if>
  </xsl:template>

  <!-- Extend the SPEC-TYPES with those from the type_target -->
  <xsl:template match="//reqif:SPEC-TYPES">
    <reqif:SPEC-TYPES>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:comment>Types from the target type system</xsl:comment>
      <!-- don't apply-templates to the type_target; the type_target
           should already be clean (as if the map_string_types had
           already been applied.  when this is not the case, doing
           map_string_types on type_target will only break the
           following ReqIF import since NG does not tolerated changes
           to URIs on items already identified by ReqIF ID
      -->
      <xsl:copy-of select="$type_target//reqif:SPEC-TYPES/reqif:SPEC-OBJECT-TYPE"/>
      <xsl:copy-of select="$type_target//reqif:SPEC-TYPES/reqif:SPECIFICATION-TYPE"/>
    </reqif:SPEC-TYPES>
  </xsl:template>

  <xsl:template match="//reqif:DATATYPES">
    <reqif:DATATYPES>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:comment>Datatypes from the target type system</xsl:comment>
      <!-- don't apply-templates to the type_target; the type_target
           should already be clean (as if the map_string_types had
           already been applied.  when this is not the case, doing
           map_string_types on type_target will only break the
           following ReqIF import since NG does not tolerated changes
           to URIs on items already identified by ReqIF ID
      -->
      <xsl:copy-of select="$type_target//reqif:DATATYPES/*"/>
    </reqif:DATATYPES>
  </xsl:template>

  <xsl:template match="//rm-reqif:TYPE-EXTENSIONS">
    <rm-reqif:TYPE-EXTENSIONS>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:comment>Type extensions from target type system</xsl:comment>
      <!-- don't apply-templates to the type_target; the type_target
           should already be clean (as if the map_string_types had
           already been applied.  when this is not the case, doing
           map_string_types on type_target will only break the
           following ReqIF import since NG does not tolerated changes
           to URIs on items already identified by ReqIF ID
      -->
      <xsl:copy-of select="$type_target//rm-reqif:TYPE-EXTENSIONS/*"/>
    </rm-reqif:TYPE-EXTENSIONS>
  </xsl:template>

  <!-- map doors text&string to ng string -->
  <xsl:template name="map_string_types"
                match="//rm-reqif:SAME-AS/text()[. = 'http://jazz.net/ns/rm/doors/type#text'
                                                 or
                                                 . = 'http://jazz.net/ns/rm/doors/type#string']">
    <xsl:text>http://www.w3.org/2001/XMLSchema#string</xsl:text>
  </xsl:template>
</xsl:stylesheet>
