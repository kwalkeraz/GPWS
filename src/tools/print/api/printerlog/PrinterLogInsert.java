package tools.print.api.printerlog;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

import com.ibm.json.java.JSONObject;

import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

//@XmlRegistry
@Path("/printerlog")
public class PrinterLogInsert extends Populate {
	//DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, PRINTER_IP, USER_IP, EMAIL, OS_NAME, BROWSER_NAME, INSTALL_RC
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	
	protected String devicename = "";
	protected String geo = "";
	protected String country = "";
	protected String state = "";
	protected String city = "";
	protected String building = "";
	protected String floor = "";
	protected String printer_ip = "";
	protected String user_ip = "";
	protected String email = "";
	protected String osname = "";
	protected String browsername = "";
	protected int installrc = 0;
	public String getDevicename() {
		return devicename;
	}
	public void setDevicename(String devicename) {
		this.devicename = devicename;
	}
	private String getGeo() {
		return geo;
	}
	public void setGeo(String geo) {
		this.geo = geo;
	}
	private String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	private String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	private String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	private String getBuilding() {
		return building;
	}
	public void setBuilding(String building) {
		this.building = building;
	}
	private String getFloor() {
		return floor;
	}
	public void setFloor(String floor) {
		this.floor = floor;
	}
	private String getPrinter_ip() {
		return printer_ip;
	}
	public void setPrinter_ip(String printer_ip) {
		this.printer_ip = printer_ip;
	}
	private String getUser_ip() {
		return user_ip;
	}
	public void setUser_ip(String user_ip) {
		this.user_ip = user_ip;
	}
	private String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	private String getOsname() {
		return osname;
	}
	public void setOsname(String osname) {
		this.osname = osname;
	}
	private String getBrowsername() {
		return browsername;
	}
	public void setBrowsername(String browsername) {
		this.browsername = browsername;
	}
	private int getInstallrc() {
		return installrc;
	}
	public void setInstallrc(int installrc) {
		this.installrc = installrc;
	}
	
	/*
	 * This method takes the form submitted from a web page.  Please note that the form fields have to be named exactly as the FormParam.
	 */
	@POST
    @Path("/form")
    public Response submitwForm(@FormParam("devicename") String devicename, @FormParam("geo") String geo, @FormParam("country") String country,
    		@FormParam("state") String state, @FormParam("city") String city, @FormParam("building") String building,
    		@FormParam("floor") String floor, @FormParam("winwshost") String host, @FormParam("userip") String ip, @FormParam("email") String email, 
    		@FormParam("os") String os, @FormParam("browser") String browser, @FormParam("rc") String rc, @Context HttpServletRequest req) {
		
		setDevicename(devicename);
		setGeo(geo);
		setCountry(country);
		setState(state);
		setCity(city);
		setBuilding(building);
		setFloor(floor);
		setPrinter_ip(host);
		setUser_ip(ip);
		setEmail("IBM");
		setOsname(os);
		setBrowsername(browser);
		setInstallrc(Integer.parseInt(rc));
		
		String sSQL = "INSERT INTO GPWS.PRINTER_LOG (DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, PRINTER_IP, USER_IP, EMAIL, OS_NAME, BROWSER_NAME, INSTALL_RC) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
        	insertLog(sSQL);
        	return Response.ok()
            		.entity("Form submitted successfully")
            		.build();

        } catch (Exception e) {
        	return Response.status(Response.Status.PRECONDITION_FAILED)
            		.entity("Message(form) is " + e.getLocalizedMessage())
            		.build();
        }      
	}
	
	@PUT
	@Path("/devicename/{name}/geo/{geo}/country/{country}/state/{state}/city/{city}/building/{building}/floor/{floor}/winwshost/{winwshost}/userip/{userip}/email/{email}/os/{os}/browser/{browser}/rc/{rc}")
	@Produces(MediaType.TEXT_PLAIN)
	public Response submitURI(@PathParam("name") String devicename, @PathParam("geo") String geo, @PathParam("country") String country,
    		@PathParam("state") String state, @PathParam("city") String city, @PathParam("building") String building,
    		@PathParam("floor") String floor, @PathParam("winwshost") String host, @PathParam("userip") String ip, @PathParam("email") String email, 
    		@PathParam("os") String os, @PathParam("browser") String browser, @PathParam("rc") String rc, @Context HttpServletRequest req) {
		
		setDevicename(devicename);
		setGeo(geo);
		setCountry(country);
		setState(state);
		setCity(city);
		setBuilding(building);
		setFloor(floor);
		setPrinter_ip(host);
		setUser_ip(ip);
		//setEmail(email);
		setEmail("IBM");
		setOsname(os);
		setBrowsername(browser);
		setInstallrc(Integer.parseInt(rc));
		
		String sSQL = "INSERT INTO GPWS.PRINTER_LOG (DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, PRINTER_IP, USER_IP, EMAIL, OS_NAME, BROWSER_NAME, INSTALL_RC) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
        	insertLog(sSQL);
        	return Response.ok()
            		.entity("Form submitted successfully")
            		.build();

        } catch (Exception e) {
        	return Response.status(Response.Status.PRECONDITION_FAILED)
            		.entity("Message(path) is " + e.getLocalizedMessage())
            		.build();
        }      
	}
	
	@POST
	@Produces(MediaType.TEXT_PLAIN)
	public Response submitReq(@Context HttpServletRequest req) {
		//name,geo,country,state,city,building,floor,winwshost,userip,os,browser,rc
		
		setDevicename(req.getParameter("devicename"));
		setGeo(req.getParameter("geo"));
		setCountry(req.getParameter("country"));
		setState(req.getParameter("state"));
		setCity(req.getParameter("city"));
		setBuilding(req.getParameter("building"));
		setFloor(req.getParameter("floor"));
		setPrinter_ip(req.getParameter("winwshost"));
		setUser_ip(req.getParameter("userip"));
		//setEmail(req.getParameter("email"));
		setEmail("IBM"); 
		setOsname(req.getParameter("os"));
		setBrowsername(req.getParameter("browser"));
		setInstallrc(Integer.parseInt(req.getParameter("rc")));
		
		String sSQL = "INSERT INTO GPWS.PRINTER_LOG (DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, PRINTER_IP, USER_IP, EMAIL, OS_NAME, BROWSER_NAME, INSTALL_RC) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
        	insertLog(sSQL);
        	return Response.ok()
            		.entity("Form submitted successfully")
            		.build();

        } catch (Exception e) {
        	return Response.status(Response.Status.PRECONDITION_FAILED)
            		.entity("Message(form) is " + e.getLocalizedMessage())
            		.build();
        }      
	} //request
	
	/**
	 * This method takes a JSON format string, to be used with a REST client, please note the format below
	 * JSON file must be in this format:
	 * {
			 "devicename": "",
			 "geo": "",
			 "country": "",
			 "state": "",
			 "city": "",
			 "building": "",
			 "floor": "",
			 "winwshost": "",
			 "userip": "",
			 "email": "",
			 "os": "",
			 "browser": "",
			 "rc": ""
		}
	 */
	@POST
    @Path("/json")
    public Response submitwJSON(String body, @Context HttpServletRequest req) {
		
    	try {
    		String name = JSONObject.parse(body.toString()).get("devicename").toString();
			String geo = JSONObject.parse(body.toString()).get("geo").toString();
			String country = JSONObject.parse(body.toString()).get("country").toString();
			String state = JSONObject.parse(body.toString()).get("state").toString();
			String city = JSONObject.parse(body.toString()).get("city").toString();
			String building = JSONObject.parse(body.toString()).get("building").toString();
			String floor = JSONObject.parse(body.toString()).get("floor").toString();
			String printerip = JSONObject.parse(body.toString()).get("winwshost").toString();
			String userip = JSONObject.parse(body.toString()).get("userip").toString();
			String email = JSONObject.parse(body.toString()).get("email").toString();
			String osname = JSONObject.parse(body.toString()).get("os").toString();
			String browser = JSONObject.parse(body.toString()).get("browser").toString();
			String rc = JSONObject.parse(body.toString()).get("rc").toString();
			
			setDevicename(name);
			setGeo(geo);
			setCountry(country);
			setState(state);
			setCity(city);
			setBuilding(building);
			setFloor(floor);
			setPrinter_ip(printerip);
			setUser_ip(userip);
			//setEmail(req.getParameter("email"));
			setEmail(email); 
			setOsname(osname);
			setBrowsername(browser);
			setInstallrc(Integer.parseInt(rc));
        	
			String sSQL = "INSERT INTO GPWS.PRINTER_LOG (DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, PRINTER_IP, USER_IP, EMAIL, OS_NAME, BROWSER_NAME, INSTALL_RC) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
			insertLog(sSQL);
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
	 *  <PrinterLog>
	 *	 	<devicename></devicename>
	 *		<geo></geo>
	 *		<country></country>
	 *		<state></state>
	 *		<city></city>
	 *		<building></building>
	 *		<floor></floor>
	 *		<winwshost></winwshost>
	 *		<userip></userip>
	 *		<email></email>
	 *	 	<os></os>
	 *	 	<browser></browser>
	 *	 	<rc></rc>
	 *	</PrinterLog>
	 */
	@POST
    @Path("/xml")
    public Response submitwXML(String body, @Context HttpServletRequest req) {
		
    	try {
    		DocumentBuilder newDocumentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    		Document parse = newDocumentBuilder.parse(new ByteArrayInputStream(body.getBytes()));
    		
    		String name = parse.getElementsByTagName("devicename").item(0).getFirstChild().getNodeValue();
			String geo = parse.getElementsByTagName("geo").item(0).getFirstChild().getNodeValue();
			String country = parse.getElementsByTagName("country").item(0).getFirstChild().getNodeValue();
			String state = parse.getElementsByTagName("state").item(0).getFirstChild().getNodeValue();
			String city = parse.getElementsByTagName("city").item(0).getFirstChild().getNodeValue();
			String building = parse.getElementsByTagName("building").item(0).getFirstChild().getNodeValue();
			String floor = parse.getElementsByTagName("floor").item(0).getFirstChild().getNodeValue();
			String printerip = parse.getElementsByTagName("winwshost").item(0).getFirstChild().getNodeValue();
			String userip = parse.getElementsByTagName("userip").item(0).getFirstChild().getNodeValue();
			String email = parse.getElementsByTagName("email").item(0).getFirstChild().getNodeValue();
			String osname = parse.getElementsByTagName("os").item(0).getFirstChild().getNodeValue();
			String browser = parse.getElementsByTagName("browser").item(0).getFirstChild().getNodeValue();
			String rc = parse.getElementsByTagName("rc").item(0).getFirstChild().getNodeValue();
			
			setDevicename(name);
			setGeo(geo);
			setCountry(country);
			setState(state);
			setCity(city);
			setBuilding(building);
			setFloor(floor);
			setPrinter_ip(printerip);
			setUser_ip(userip);
			//setEmail(req.getParameter("email"));
			setEmail(email); 
			setOsname(osname);
			setBrowsername(browser);
			setInstallrc(Integer.parseInt(rc));
        	
			String sSQL = "INSERT INTO GPWS.PRINTER_LOG (DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, PRINTER_IP, USER_IP, EMAIL, OS_NAME, BROWSER_NAME, INSTALL_RC) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
			insertLog(sSQL);
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
	 * This method inserts the information into the database, based on a built SQL string
	 */
	private void insertLog(String sSQL) {
		Connection con = null;
		PreparedStatement stmtLog = null;
		ResultSet rsLog = null;
		//int sMessage = 0;
		
		try {
		  	con = tools.getConnection();
		  	stmtLog = con.prepareStatement(sSQL);
		  	stmtLog.setString(1,getDevicename());
		  	stmtLog.setString(2,getGeo());
			stmtLog.setString(3,getCountry());
			stmtLog.setString(4,getState());
			stmtLog.setString(5,getCity());
			stmtLog.setString(6,getBuilding());
			stmtLog.setString(7,getFloor());
			stmtLog.setString(8,getPrinter_ip());
			stmtLog.setString(9,getUser_ip());
			stmtLog.setString(10,getEmail());
			stmtLog.setString(11,getOsname());
			stmtLog.setString(12,getBrowsername());
			stmtLog.setInt(13,getInstallrc());
			stmtLog.executeUpdate();
			//sMessage = 0;
			
		} catch (SQLException e) {
		  		System.out.println("GPWSAdmin error in UserEdit.class method insertAuth ERROR1: " + e);
		  		//sMessage = 1;
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
		  		try {
		  			if (rsLog != null)
		  				rsLog.close();
		  			if (stmtLog != null)
		  				stmtLog.close();
			  		if (con != null)
			  			con.close();
		  		} catch (Exception e){
			  		System.out.println("GPWSAdmin Error in UserEdit.insertAuth.2 ERROR: " + e);
		  		}
		 }
	}
	

} //class
