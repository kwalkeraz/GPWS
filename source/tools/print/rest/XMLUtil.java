/**
 * Licensed Material - Property of IBM Corporation.
 * (C) Copyright IBM Corp. 2007 - All Rights Reserved.
 */
package tools.print.rest;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;

import org.apache.xerces.parsers.DOMParser;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

/**
 * XML-related utilities.
 */
public class XMLUtil {

public static void saveXMLDocument(String filename, Document doc) throws java.io.IOException{
	StringWriter sw = new StringWriter();
	OutputFormat format = new OutputFormat(doc);
	format.setIndenting(true);
	XMLSerializer serial = new XMLSerializer(sw,format);
	serial.serialize(doc);

	File newFile = new File(filename);
	FileOutputStream output = new FileOutputStream(newFile);
	OutputStreamWriter writer = new OutputStreamWriter(output);
	writer.write(sw.toString(), 0, sw.toString().length());
	writer.close();
	output.close();
}

/**
 * Parse the XML on the given InputSource, placing it in a Document, which is returned
 * @param iSrc The InputSource containing XML to be parsed
 * @return Document containing parsed XML
 **/
public static Document parseToDocument(InputSource iSrc) throws org.xml.sax.SAXException, java.io.IOException{
	DOMParser dp = new DOMParser();
	dp.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
	dp.parse(iSrc);
	
	Document doc = dp.getDocument();
	return doc;
}

public static String getXMLAsString(Document xml) throws Exception
	{
		OutputFormat format = new OutputFormat(xml);
		format.setIndenting(true);
	   	StringWriter stringOut = new StringWriter();
	   	XMLSerializer serial = new XMLSerializer( stringOut, format );
		try	
		{
	    	serial.asDOMSerializer();
 	    	serial.serialize( xml.getDocumentElement() );
		}
		catch (Exception e)
		{
			String errmsg = "Error outputing DOM to XML.  Extend error message was:/n";
			//More appropriate exception?
			throw new Exception(errmsg + e);
		}
		return stringOut.toString();
	}

}

