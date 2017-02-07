<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:reqif="http://www.omg.org/spec/ReqIF/20110401/reqif.xsd"
    xmlns:rm="http://www.ibm.com/rm"
    xmlns:rm-reqif="http://www.ibm.com/rm/reqif">
  
  <xsl:output omit-xml-declaration="yes" method="html"/>
 
  <xsl:template match="node()|@*" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:key name="sameAsUriFromID"
           match="rm-reqif:DATATYPE-DEFINITION-EXTENSION/rm-reqif:SAME-AS/text()
                  |rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION/rm-reqif:SAME-AS/text()"
                  
           use="../../reqif:ENUM-VALUE-REF/text()
                |../../reqif:DATATYPE-DEFINITION-ENUMERATION-REF/text()
                |../../reqif:DATATYPE-DEFINITION-INTEGER-REF/text()
                |../../reqif:ATTRIBUTE-DEFINITION-XHTML-REF/text()
                "/>

  <xsl:key name="attrDefEnumFromDataTypeID"
           match="reqif:SPEC-ATTRIBUTES/*"
           use="@IDENTIFIER"/>

  <xsl:key name="attrdefFromName"
           match="reqif:SPEC-ATTRIBUTES/*"
           use="@LONG-NAME"/>

  <xsl:template match="reqif:REQ-IF">
    <html>
      <head>
      </head>
      <body>
      <title><xsl:value-of select="base-uri()" /></title>
            <h1>Source: <xsl:value-of select="base-uri()" /></h1>
        <xsl:variable name="specobjects" select="//reqif:SPEC-OBJECT"/>
	<h1>SPEC-OBJECTs: <xsl:value-of select="count($specobjects)"/></h1>

        <xsl:variable name="spec-relations" select="//reqif:SPEC-RELATION"/>
        <h1>SPEC-RELATIONs: <xsl:value-of select="count($spec-relations)"/></h1>

        <xsl:variable name="specifications" select="//reqif:SPECIFICATION"/>
        <table style="border:1px solid black;">
	  <tr><td colspan="3"><h1>SPECIFICATIONs (<xsl:value-of select="count($specifications)"/>)</h1></td></tr>

          <tr>
            <td><b>LONG-NAME</b></td><td><b>ID</b></td><td><b>count</b></td>
          </tr>
          <xsl:for-each select="$specifications">
            <xsl:variable name="long-name" select="@LONG-NAME"/>
            <xsl:variable name="id" select="@IDENTIFIER"/>
            <xsl:variable name="object_count" select="count(.//reqif:OBJECT)"/>
            <tr>
              <td><xsl:value-of select="$long-name"/></td>
              <td><xsl:value-of select="$id"/></td>
              <td><xsl:value-of select="$object_count"/></td>
            </tr>
          </xsl:for-each>
        </table>

	<br/>

	<br/>
        <xsl:variable name="spec-types" select="//reqif:SPEC-TYPES/reqif:SPEC-OBJECT-TYPE"/>
        <table style="border:1px solid black;">
          <tr><td colspan="2"><h1>SPEC-OBJECT-TYPE (<xsl:value-of select="count($spec-types)"/>)</h1></td></tr>
          <tr>
            <td><b>LONG-NAME</b></td><td><b>ID</b></td>
          </tr>
          <xsl:for-each select="$spec-types">
            <xsl:variable name="long-name" select="@LONG-NAME"/>
            <xsl:variable name="id" select="@IDENTIFIER"/>
            <tr>
              <td><xsl:value-of select="$long-name"/></td>
              <td><xsl:value-of select="$id"/></td>
            </tr>
          </xsl:for-each>
        </table>

       <br/>

        <table style="border:1px solid black;">
	  <tr><td colspan="4"><h1>Attribute Definitions with sameAs</h1></td></tr>
          <tr>
            <td><b>sameas</b></td><td><b>count</b></td><td><b>LONG-NAME</b></td><td><b>id</b></td>
          </tr>
          <xsl:for-each select="//rm-reqif:ATTRIBUTE-DEFINITION-EXTENSION/rm-reqif:SAME-AS">
            <xsl:sort select="text()"/>
            <xsl:variable name="dataTypeSameAs" select="text()"/>
            <xsl:variable name="dataTypeID" select="../*[1]/text()"/>
            <xsl:variable name="attrdef" select="key('attrDefEnumFromDataTypeID', $dataTypeID)"/>
            <xsl:variable name="dataTypeName"       select="$attrdef/@LONG-NAME"/>
            <tr>
              <td><xsl:value-of select="$dataTypeSameAs"/></td>
              <td><xsl:value-of select="count($dataTypeName)"/></td>
              <td><xsl:value-of select="$dataTypeName[1]"/></td>
              <td><xsl:value-of select="$dataTypeID"/></td>
            </tr>
          </xsl:for-each>
        </table>

       <br/>

        <table style="border:1px solid black;">
	  <tr><td colspan="3"><h1>Attribute Types with sameAs</h1></td></tr>
          <tr>
            <td><b>sameas</b></td><td><b>LONG-NAME</b></td><td><b>id</b></td>
          </tr>
          <xsl:for-each select="//rm:SPEC-OBJECT-TYPE-EXTENSION/rm:SAME-AS">
            <xsl:variable name="dataTypeSameAs" select="text()"/>
            <xsl:variable name="dataTypeID" select="../*[1]/text()"/>
            <xsl:variable name="attrdef" select="key('attrDefEnumFromDataTypeID', $dataTypeID)"/>
            <xsl:variable name="dataTypeName"       select="$attrdef/@LONG-NAME"/>
            <tr>
              <td><xsl:value-of select="$dataTypeSameAs"/></td>
              <td><xsl:value-of select="$dataTypeName"/></td>
              <td><xsl:value-of select="$dataTypeID"/></td>
            </tr>
          </xsl:for-each>
        </table>

       <br/>


        <table style="border:1px solid black;">
	  <tr><td colspan="4"><h1>Attribute Datatypes</h1></td></tr>
          <tr>
            <td><b>LONG-NAME</b></td><td><b>Values</b></td><td><b>ID</b></td><td><b>sameas</b></td>
          </tr>
          <xsl:for-each select="//reqif:DATATYPE-DEFINITION-ENUMERATION">
            <xsl:sort select="@LONG-NAME"/>
            <xsl:variable name="sameAsURI" select="key('sameAsUriFromID', @IDENTIFIER)"/>
            <tr>
              <td><xsl:value-of select="@LONG-NAME"/></td>
              <td>
                <table style="border:1px solid black;">
                  <tr>
                    <td><b>Name</b></td>                <td><b>Value</b></td>                <td><b>ID</b></td>
                  </tr>
                  <xsl:for-each select="reqif:SPECIFIED-VALUES/reqif:ENUM-VALUE">
                    <xsl:sort select="reqif:PROPERTIES/reqif:EMBEDDED-VALUE/@KEY"/>
                    <xsl:variable name="long_name" select="@LONG-NAME"/>
                    <tr>
                      <td><xsl:value-of select="$long_name"/></td>
                      <td><xsl:value-of select="reqif:PROPERTIES/reqif:EMBEDDED-VALUE/@KEY"/></td>
                      <td><xsl:value-of select="@IDENTIFIER"/></td>
                    </tr>
                  </xsl:for-each>
                </table>
              </td>
              <td><xsl:value-of select="@IDENTIFIER"/></td>
              <td><xsl:value-of select="$sameAsURI"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
  
</xsl:stylesheet>
