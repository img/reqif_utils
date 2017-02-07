<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="@*|*|processing-instruction()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="reqif:SPEC-OBJECTS">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="reqif:SPEC-OBJECT">
        <xsl:sort select="@IDENTIFIER" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="reqif:SPECIFICATIONS">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="reqif:SPECIFICATION">
        <xsl:sort select="@IDENTIFIER" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="reqif:SPEC-OBJECT/reqif:VALUES | reqif:SPECIFICATION/reqif:VALUES">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*">
        <xsl:sort select="reqif:DEFINITION/*/text()" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="reqif:ATTRIBUTE-VALUE-ENUMERATION/reqif:VALUES">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="reqif:ENUM-VALUE-REF">
        <xsl:sort select="text()" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="rm:ARTIFACT-EXTENSIONS">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*">
        <xsl:sort select="reqif:SPEC-OBJECT-REF/text()" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="rm:WRAPPED-RESOURCES">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*">
        <xsl:sort select="@IDENTIFIER" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="rm:TAG-ASSOCIATIONS">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="rm:TAG-ASSOCIATION">
        <xsl:sort select="rm:TAG-REF/text()" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="rm:TAG-ASSOCIATION">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*">
        <xsl:sort select="text()" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>


<!-- DOORS Next Generation does not use the ID of SPEC-HIERARCHY, so use a information-discarding
     normalization.  SPEC-HIERARCHY is already in normal form since the tree is an ordered tree -->
    <xsl:template match="reqif:SPEC-HIERARCHY/@IDENTIFIER">
        <xsl:attribute name="IDENTIFIER">
            <xsl:value-of select="'unused'"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="rm:TAG-ASSOCIATION/@IDENTIFIER">
        <xsl:attribute name="IDENTIFIER">
            <xsl:value-of select="'unused'"/>
        </xsl:attribute>
    </xsl:template>


</xsl:stylesheet>
