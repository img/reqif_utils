<!--  -*- mode: xml; -*- -->
<!--  Copyright 2017 Persistent Systems -->
<!--  img/edinburgh lab -->
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:h="http://www.w3.org/TR/REC-html40"
    xmlns:xs="http://schema.w3.org/xs/"
    xmlns:rm="http://www.ibm.com/xmlns/rdm/rdf/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:jfs="http://jazz.net/xmlns/foundation/1.0/">
  
  <xsl:output omit-xml-declaration="yes" method="html"/>
 
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
      </head>
      <body>
        Attribute Datatypes
        <table style="border:1px solid black;">
            <tr>
              <td>Name</td>
              <td>valueType</td>
              <td>sameAs</td>
              <td>URI</td>
            </tr>
          <xsl:for-each select="//rm:AttributeType">
            <xsl:sort select="dcterms:title/text()" order="ascending"/>
            <xsl:variable name="uri" select="@rdf:about"/>
            <xsl:variable name="valueType" select="rm:valueType/@rdf:resource"/>
            <xsl:variable name="typename" select="dcterms:title/text()"/>
            <xsl:variable name="sameas" select="owl:sameAs/@rdf:resource"/>
            <tr>
              <td><xsl:value-of select="$typename"/></td>
              <td><xsl:value-of select="$valueType"/></td>
              <td><xsl:value-of select="$sameas"/></td>
              <td><xsl:value-of select="$uri"/></td>
            </tr>
          </xsl:for-each>
        </table>


        Attribute Definitions
        <table style="border:1px solid black;">
            <tr>
              <td>Name</td>
              <td>Range</td>
              <td>sameAs</td>
              <td>URI</td>
            </tr>
          <xsl:for-each select="//rm:AttributeDefinition">
            <xsl:sort select="dcterms:title/text()" order="ascending"/>
            <xsl:variable name="uri" select="@rdf:about"/>
            <xsl:variable name="range" select="rm:range/@rdf:resource"/>
            <xsl:variable name="attrdefname" select="dcterms:title/text()"/>
            <xsl:variable name="sameas" select="owl:sameAs/@rdf:resource"/>
            <tr>
              <td><xsl:value-of select="$attrdefname"/></td>
              <td><xsl:value-of select="$range"/></td>
              <td><xsl:value-of select="$sameas"/></td>
              <td><xsl:value-of select="$uri"/></td>
            </tr>
          </xsl:for-each>
        </table>

        Object Types
        <table style="border:1px solid black;">
          <xsl:for-each select="//rm:ObjectType">
            <xsl:sort select="dcterms:title/text()" order="ascending"/>
            <xsl:variable name="uri" select="@rdf:about"/>
            <xsl:variable name="attrdefname" select="dcterms:title/text()"/>
            <xsl:variable name="sameas" select="owl:sameAs/@rdf:resource"/>
            <tr>
              <td><xsl:value-of select="$attrdefname"/></td>
              <td><xsl:value-of select="$sameas"/></td>
              <td><xsl:value-of select="$uri"/></td>
            </tr>
            <tr>
              <td>Attributes
              <table style="border:1px solid black;">
                <xsl:for-each select="rm:hasAttribute">
                  <xsl:variable name="uri" select="@rdf:resource"/>
                  <tr><td><xsl:value-of select="$uri"/></td></tr>
                </xsl:for-each>
              </table>
              </td>
            </tr>
            <tr>
              <td>System Attributes
              <table style="border:1px solid black;">
                <xsl:for-each select="rm:hasSystemAttribute">
                  <xsl:variable name="uri" select="@rdf:resource"/>
                  <tr><td><xsl:value-of select="$uri"/></td></tr>
                </xsl:for-each>
              </table>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
  
  </xsl:stylesheet>
