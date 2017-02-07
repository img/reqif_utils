<!--  -*- mode: xml; -*- -->
<!--  Copyright 2017 Persistent Systems -->
<!--  img/edinburgh lab -->
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <!-- Remove all instance data (and annotations) from reqif package. -->

  <xsl:output omit-xml-declaration="yes" method="xml"/>
  
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template
      match="reqif:SPEC-OBJECTS
             | reqif:SPECIFICATIONS
             | rm:FOLDERS
             | rm:FOLDER-HIERARCHY
             | rm:ARTIFACT-EXTENSIONS">
    <!-- all gone -->
  </xsl:template>
</xsl:stylesheet>
