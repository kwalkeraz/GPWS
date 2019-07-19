package tools.print.api.feedback;

import java.io.ByteArrayInputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

import com.ibm.json.java.JSONObject;

import tools.print.api.category.ParseCategory;
import tools.print.jaxrs.Populate;

import tools.print.lib.*;

@Path("/feedback")
public class FeedbackJax extends Populate {
	AppTools tool = new AppTools();
	static String encodeType = "utf-8";
	ParseCategory cat = new ParseCategory("Feedback");
	
	//Setters and Getters
	protected String usernameValue = "";
	protected String emailValue = "";
	protected String subjectValue = "";
	protected String aboutpageValue = "";
	protected String geoValue = "";
	protected String geoemailValue = "";
    protected String commentsValue = "";
    boolean result = true;
	
    /**
	 * @return the usernameValue
	 */
	private String getUsernameValue() {
		return usernameValue;
	}

	/**
	 * @param usernameValue the usernameValue to set
	 */
	private void setUsernameValue(String value) {
		this.usernameValue = decodeValue(value);
	}
	
	/**
	 * @return the emailValue
	 */
	private String getEmailValue() {
		return emailValue;
	}

	/**
	 * @param emailValue the emailValue to set
	 */
	private void setEmailValue(String value) {
		this.emailValue = decodeValue(value);
	}

	/**
	 * @return the subjectValue
	 */
	private String getSubjectValue() {
		return subjectValue;
	}

	/**
	 * @param subjectValue the subjectValue to set
	 */
	private void setSubjectValue(String value) {
		value = "GPWS feedback results: " + value;
		this.subjectValue = decodeValue(value);
	}

	/**
	 * @return the aboutpageValue
	 */
	private String getAboutpageValue() {
		return aboutpageValue;
	}

	/**
	 * @param aboutpageValue the aboutpageValue to set
	 */
	private void setAboutpageValue(String value) {
		this.aboutpageValue = decodeValue(value);
	}

	/**
	 * @return the geoValue
	 */
	private String getGeoValue() {
		return geoValue;
	}

	/**
	 * @param geoValue the geoValue to set
	 */
	private void setGeoValue(String value) {
		this.geoValue = decodeValue(value);
	}

	/**
	 * @return the geoemailValue
	 */
	private String getGeoemailValue() {
		return geoemailValue;
	}

	/**
	 * @param geoemailValue the geoemailValue to set
	 */
	private void setGeoemailValue(String value) {
		this.geoemailValue = decodeValue(value);
	}

	/**
	 * @return the commentsValue
	 */
	private String getCommentsValue() {
		return commentsValue;
	}

	/**
	 * @param commentsValue the commentsValue to set
	 */
	private void setCommentsValue(String value) {
		this.commentsValue = decodeValue(value);
	}
	
	@SuppressWarnings("static-access")
	private static String decodeValue(String value){
		try {
			value = new URLDecoder().decode((String)value.trim(),encodeType);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return value;
	}
	
	/*
	 * This method takes the form submitted from a web page.  Please note that the form fields have to be named exactly as the FormParam.
	 */
	@POST
    @Path("/form")
    public Response submitwForm(@FormParam("userName") String username, 
                                 @FormParam("email") String email, @FormParam("subject") String subject, @FormParam("aboutpage") String aboutpage, 
                                 @FormParam("geo") String geo, @FormParam("comments") String comments, @FormParam("geoemail") String geoemail, 
                                 @Context HttpServletRequest req) {
		
    	try {
        	setUsernameValue(username);
        	setEmailValue(email);
        	setSubjectValue(subject);
        	setAboutpageValue(aboutpage);
        	setGeoValue(geo);
        	setCommentsValue(comments);
        	setGeoemailValue(geoemail);
        	
        	sendMail();
        	return Response.ok()
            		.entity("Form submitted successfully")
            		.build();

        } catch (Exception e) {
        	return Response.status(Response.Status.PRECONDITION_FAILED)
            		.entity("Message(form) is " + e.getLocalizedMessage())
            		.build();
        }      
    }
	
	/**
	 * This method takes a JSON format string, to be used with a REST client, please note the format below
	 * JSON file must be in this format:
	 * {
		  "username": "{Name of the sender}",
		  "email": "{sender email address}",
		  "subject": "GPWS feedback",
		  "aboutpage": "http://localhost/tools/print/",
		  "geo": "Any",
		  "comments": "This is a test feedback"
		}
	 */
	@POST
    @Path("/json")
    public Response submitwJSON(String body, @Context HttpServletRequest req) {
		
    	try {
    		String username = JSONObject.parse(body.toString()).get("username").toString();
			String email = JSONObject.parse(body.toString()).get("email").toString();
			String subject = JSONObject.parse(body.toString()).get("subject").toString();
			String aboutpage = JSONObject.parse(body.toString()).get("aboutpage").toString();
			String geo = JSONObject.parse(body.toString()).get("geo").toString();
			//String geoemail = JSONObject.parse(body.toString()).get("geoemail").toString();
			String comments = JSONObject.parse(body.toString()).get("comments").toString();
			
			setUsernameValue(username);
        	setEmailValue(email);
        	setSubjectValue(subject);
        	setAboutpageValue(aboutpage);
        	setGeoValue(geo);
        	setCommentsValue(comments);
        	setGeoemailValue(cat.parseJson(geo));
        	
        	//geoemail = cat.parseJson(geo);
        	sendMail();
    		return Response.ok()
            		.entity("Form submitted successfully")
            		.build();
    	} catch (Exception e) {
    		return Response.status(Response.Status.PRECONDITION_FAILED)
            		.entity("Message(json) is " + e.getLocalizedMessage())
            		.build();
    	}
    } //json
	
	/**
	 * This method takes a XML format string, to be used with a REST client, please note the format below
	 * XML file must be in this format:
	 * <Feedback>
	 * 	<username></username>
	 *  <email></email>
	 *  <subject>GPWS Feedback</subject>
	 *  <aboutpage>http://localhost/tools/print/</aboutpage>
	 *  <geo></geo>
	 *  <geoemail></geoemail>
	 *  <comments>This is a test feedback</comments>
	 * </Feedback>
	 */
	@POST
    @Path("/xml")
    public Response submitwXML(String body, @Context HttpServletRequest req) {
		
    	try {
    		DocumentBuilder newDocumentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    		Document parse = newDocumentBuilder.parse(new ByteArrayInputStream(body.getBytes()));
    		
    		String username = parse.getElementsByTagName("username").item(0).getFirstChild().getNodeValue();
			String email = parse.getElementsByTagName("email").item(0).getFirstChild().getNodeValue();
			String subject = parse.getElementsByTagName("subject").item(0).getFirstChild().getNodeValue();
			String aboutpage = parse.getElementsByTagName("aboutpage").item(0).getFirstChild().getNodeValue();
			String geo = parse.getElementsByTagName("geo").item(0).getFirstChild().getNodeValue();
			//String geoemail = parse.getElementsByTagName("geoemail").item(0).getFirstChild().getNodeValue();
			String comments = parse.getElementsByTagName("comments").item(0).getFirstChild().getNodeValue();
			
			setUsernameValue(username);
        	setEmailValue(email);
        	setSubjectValue(subject);
        	setAboutpageValue(aboutpage);
        	setGeoValue(geo);
        	setCommentsValue(comments);
        	setGeoemailValue(cat.parseXML(geo));
    		
        	//geoemail = cat.parseXML(geo);
        	sendMail();
    		return Response.ok()
            		.entity("Form submitted successfully")
            		.build();
    	} catch (Exception e) {
    		return Response.status(Response.Status.PRECONDITION_FAILED)
            		.entity("Message(xml) is " + e.getLocalizedMessage())
            		.build();
    	}
    	
    } //xml
	
	/*
	 * This method sends the email for the feedback
	 */
	private boolean sendMail() {
		SendMail mailTool = new SendMail();
		String body = "Name of sender: " + getUsernameValue() +
 	   				   "\nEmail Address: " + getEmailValue() +
 	   				   //"\nSubject: " + getSubjectValue() +
 	   				   "\nGeo: " + getGeoValue() +
 	   				   "\nURL: " + getAboutpageValue() +
 	   				   "\n" +
 	   				   "\nComments: " + getCommentsValue();
		boolean result = true;
		try {
			// Need to remove the category code from the email, otherwise the email will not be correct
			String email = getGeoemailValue().substring(0,getGeoemailValue().length()-1);
			result = mailTool.sendMail(email, getSubjectValue(), body);
			//result = mailTool.sendMail("asdf@us.ibm.com", getSubjectValue(), body);
			//System.out.println("This is where it would have emailed \n" + body + " to email " + email);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = false;
		}
 	   
		return result;
	}

}
