package tools.print.api.category;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Scanner;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.ibm.json.java.JSONArray;
import com.ibm.json.java.JSONObject;

import tools.print.rest.*;

/*
 * Searches the category API for a given category name.  For example, looking for the Feedback category, it will search the URL
 * http://hostname/tools/print/servlet/api.wss/category/name/Feedback
 * and will return the results in either XML or JSON format, depending on which method is called
 * @param - category name
 * 
 * Don't forget to first set the constructor like ParseCategory category = new ParseCategory({variable_name})
 */
public class ParseCategory {
	//final static String sUrl = "http://localhost:9082/tools/print/servlet/api.wss/category/name/Feedback";
	static String sUrl = "";
	
	protected static String getsUrl() {
		return sUrl;
	}

	@SuppressWarnings("static-access")
	protected final void setsUrl(String sUrl) {
		PrepareConnection pc = new PrepareConnection();
		String host = "http://" + pc.setServerName() + pc.setURI() + pc.setServletPath() + "/" + "category" + "/" + "name" + "/" + sUrl;
		//System.out.println("The full url is " + host);
		this.sUrl = host;
	}

	// Look for the category name in the API, constructor name
	public ParseCategory(String category_name) {
		setsUrl(category_name);
	}
	
	Document dom = null;
	
	//Setters and Getters
	protected String name = "";
	protected String code = "";
	protected String value1 = "";
	protected String value2 = "";
	protected String description = "";
	
	public String getName() {
		return name;
	}

	private void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	private void setCode(String code) {
		this.code = code;
	}

	public String getValue1() {
		return value1;
	}

	private void setValue1(String value1) {
		this.value1 = value1;
	}

	public String getValue2() {
		return value2;
	}

	private void setValue2(String value2) {
		this.value2 = value2;
	}

	public String getDescription() {
		return description;
	}

	private void setDescription(String description) {
		this.description = description;
	}

	// JSON format
	
	private static URL setURL(String s) {
		URL url = null;
		try {
			url = new URL(s);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return url;
	}
	
	private static URLConnection setConnection() {
		URLConnection connection = null;
		URL url = setURL(getsUrl());
		try {
			connection = url.openConnection();
		} catch (IOException e) {
			System.out.println("Either the URL provided is incorrect or the web server is not available");
			e.printStackTrace();
		}
		return connection;
	}
	
	public String parseJson(String value) {
		//System.out.println("Calling Json...");
		String sValue = "";
		try {  
			URLConnection yc = setConnection();
			yc.addRequestProperty("Accept", "application/json");
			
			//Scanner scan = new Scanner(url.openStream());
			Scanner scan = new Scanner(yc.getInputStream());
			String str = new String();
			while (scan.hasNext())
				str += scan.nextLine();
			scan.close();
			
	        //If you need to get only the array, list starts with [ then use the following line:
			//JSONArray feedbackArray = JSONArray.parse(str.toString());
			
			//Otherwise if it starts with { and the array is in the middle, then you use the following 3 lines:
			Object oValue = JSONObject.parse(str.toString()).get("value");
			Object feedback = JSONObject.parse(oValue.toString()).get("Category");
            JSONArray feedbackArray = JSONArray.parse(feedback.toString());
			 
			for (Object fdObject : feedbackArray) {
				if (value.equals(JSONObject.parse(fdObject.toString()).get("Category_Value1").toString())) {
					setName(JSONObject.parse(fdObject.toString()).get("Category_Name").toString());
					setCode(JSONObject.parse(fdObject.toString()).get("Category_Code").toString());
					setValue1(JSONObject.parse(fdObject.toString()).get("Category_Value1").toString());
					setValue2(JSONObject.parse(fdObject.toString()).get("Category_Value2").toString());
					setDescription(JSONObject.parse(fdObject.toString()).get("Description").toString());
					sValue = getValue2();
					
					//System.out.println("Name : "+ getName());
					//System.out.println("URL  : "+ sUrl);
					//System.out.println("Code : " + getCode());
					//System.out.println("Value_1 : " + getValue1());
					//System.out.println("Value_2 : " + getValue2());
					//System.out.println("Description : " + getDescription());
					//System.out.println("-------------------------------");
				}
	        }
		} catch(Exception ex) {
			ex.printStackTrace();
		}
		
		return sValue;
	}
	
	// All XML related
	
	private void parseXMLURL() {
		//get the factory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		URL u = null;
		// Use URLConnection if you need to manipulate the HTTP header information or add parameters
	    //URLConnection uc = null;
	    InputStream in = null;
		
		try {
			//Form url
			//u = new URL(sUrl);
			u = setURL(getsUrl());
			
			//Read input stream from URL
			in = u.openStream();
			
			//Using factory get an instance of document builder
			DocumentBuilder db = dbf.newDocumentBuilder();
			
			//parse using builder to get DOM representation of the XML file
			dom = db.parse(in);
			in.close();
			
		} catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		} catch(SAXException se) {
			se.printStackTrace();
		} catch(IOException ioe) {
			System.out.println("Unable to read XML format, error is: " + ioe.getLocalizedMessage());
			ioe.printStackTrace();
		}
	}

	public String parseXML(String value) {
		//System.out.println("Calling XML...");
		//get the XML file
		String sValue = "";
		parseXMLURL();
		//get the root elememt
		Element docEle = dom.getDocumentElement();
		
		//get a nodelist of <employee> elements
		NodeList nl = docEle.getElementsByTagName("Category");
		if(nl != null && nl.getLength() > 0) {
			for(int i = 0 ; i < nl.getLength();i++) {
				
				//get the employee element
				try {
					Element el = (Element)nl.item(i);
					getSubTag(el, value);
				} catch (Exception ex) {
					System.out.println(ex.getLocalizedMessage());
				}
					
			}
		}
		sValue = getValue2();
		return sValue;
	}


	/**
	 * I take an employee element and read the values in, create
	 * an Employee object and return it
	 * @param empEl
	 * @return
	 */
	private void getSubTag(Element ele, String value) {
		if (value.equals(getTextValue(ele,"Category_Value1"))) {
			setName(getTextValue(ele,"Category_Name"));
			setCode(getTextValue(ele,"Category_Code"));
			setValue1(getTextValue(ele,"Category_Value1"));
			setValue2(getTextValue(ele,"Category_Value2"));
			setDescription(getTextValue(ele,"Description"));
		
			//System.out.println("Name : "+ getName());
			//System.out.println("URL  : "+ sUrl);
			//System.out.println("Code : " + getCode());
			//System.out.println("Value_1 : " + getValue1());
			//System.out.println("Value_2 : " + getValue2());
			//System.out.println("Description : " + getDescription());
			//System.out.println("-------------------------------");
		}
	}


	/**
	 * I take a xml element and the tag name, look for the tag and get
	 * the text content 
	 * i.e for <employee><name>John</name></employee> xml snippet if
	 * the Element points to employee node and tagName is name I will return John  
	 * @param ele
	 * @param tagName
	 * @return
	 */
	private String getTextValue(Element ele, String tagName) {
		String textVal = "";
		textVal = ele.getElementsByTagName(tagName).item(0).getTextContent();
		//System.out.println("Element in getTextValue for tagName " + tagName + " is " + ele.getElementsByTagName(tagName).item(0).getTextContent());

		return textVal;
	}

	
	/**
	 * Calls getTextValue and returns a int value
	 * @param ele
	 * @param tagName
	 * @return
	 */
	private int getIntValue(Element ele, String tagName) {
		//in production application you would catch the exception
		return Integer.parseInt(getTextValue(ele,tagName));
	}

}
