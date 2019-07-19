package tools.print.api.korequest;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

import tools.print.api.korequest.KORequests;
import tools.print.api.korequest.KORequestFactory;
import tools.print.api.korequest.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.lib.CategoryTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/keyop")
public class KORequestJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static KORequests requests = null;
	protected String korequestid = "";
	protected String reqemail = "", reqname = "", devicetype = "", devicename = "", cityValue = "", buildingValue = "", reqstatus = "";
	protected String keyopname = "", keyopuserid = "", closecodeid = "", dateRangeStart = "", dateRangeEnd = "";
	
	public String getRequestID() {
    	return korequestid;
    }
    
    public void setRequestID(String value) {
    	this.korequestid = value;
    }
    
    public String getReqEmail() {
    	return reqemail;
    }
    
    public void setReqEmail(String value) {
    	this.reqemail = value;
    }
    
    public String getReqName() {
    	return reqname;
    }
    
    public void setReqName(String value) {
    	this.reqname = value;
    }
    
    public String getDeviceType() {
    	return devicetype;
    }
    
    public void setDeviceType(String value) {
    	this.devicetype = value;
    }
    
    public String getDeviceName() {
    	return devicename;
    }
    
    public void setDeviceName(String value) {
    	this.devicename = value;
    }
    
    public String getCityValue() {
    	return cityValue;
    }
    
    public void setCityValue(String value) {
    	this.cityValue = value;
    }
    
    public String getBuildingValue() {
    	return buildingValue;
    }
    
    public void setBuildingValue(String value) {
    	this.buildingValue = value;
    }
    
    public String getReqStatus() {
    	return reqstatus;
    }
    
    public void setReqStatus(String value) {
    	this.reqstatus = value;
    }
    
    public String getKeyopName() {
    	return keyopname;
    }
    
    public void setKeyopName(String value) {
    	this.keyopname = value;
    }
    
    public String getKeyopUserID() {
    	return keyopuserid;
    }
    
    public void setKeyopUserID(String value) {
    	this.keyopuserid = value;
    }
    
    public String getCloseCodeID() {
    	return closecodeid;
    }
    
    public void setCloseCodeID(String value) {
    	this.closecodeid = value;
    }
    
    public String getDateRangeStart() {
    	return dateRangeStart;
    }
    
    public void setDateRangeStart(String value) {
    	this.dateRangeStart = value;
    }
    
    public String getDateRangeEnd() {
    	return dateRangeEnd;
    }
    
    public void setDateRangeEnd(String value) {
    	this.dateRangeEnd = value;
    }
    
	
	public void createList(List<Map<String, Object>> columns) {
		requests = factory.createKORequests();
		List<Map<String, Object>> notesArray;
		
		try {
			for (Map<String, Object> i : columns)  {
				int koRequestID = pc.returnKeyValueInt(i, "KEYOP_REQUESTID");
				String reqEmail = pc.returnKeyValue(i, "REQUESTOR_EMAIL");
				String reqName = pc.returnKeyValue(i, "REQUESTOR_NAME");
				String reqTieline = pc.returnKeyValue(i, "REQUESTOR_TIELINE");
				String reqExtPhone = pc.returnKeyValue(i, "REQUESTOR_EXT_PHONE");
				String timeSubmitted = pc.returnKeyValue(i, "TIME_SUBMITTED");
				int deviceID = pc.returnKeyValueInt(i, "DEVICEID");
				String deviceName = pc.returnKeyValue(i, "DEVICE_NAME");
				String deviceSerial = pc.returnKeyValue(i, "DEVICE_SERIAL");
				String deviceType = pc.returnKeyValue(i, "DEVICE_TYPE");
				String tier = pc.returnKeyValue(i, "TIER");
				String e2eCategory = pc.returnKeyValue(i, "E2E_CATEGORY");
				String city = pc.returnKeyValue(i, "CITY");
				int cityid = pc.returnKeyValueInt(i, "CITYID");
				String building = pc.returnKeyValue(i, "BUILDING");
				int buildingid = pc.returnKeyValueInt(i, "BUILDINGID");
				String floor = pc.returnKeyValue(i, "FLOOR");
				String room = pc.returnKeyValue(i, "ROOM");
				String description = pc.returnKeyValue(i, "DESCRIPTION");
				String ccEmail = pc.returnKeyValue(i, "CC_EMAIL");
				String reqStatus = pc.returnKeyValue(i, "REQ_STATUS");
				String solution = pc.returnKeyValue(i, "SOLUTION");
				int keyopUserID = pc.returnKeyValueInt(i, "KEYOP_USERID");
				String keyopName = pc.returnKeyValue(i, "KEYOP_NAME");
				String timeFinished = pc.returnKeyValue(i, "TIME_FINISHED");
				String closedBy = pc.returnKeyValue(i, "CLOSED_BY");
				String customerContacted = pc.returnKeyValue(i, "CUSTOMER_CONTACTED");
				String keyopTimeStart = pc.returnKeyValue(i, "KEYOP_TIME_START");
				String keyopTimeFinish = pc.returnKeyValue(i, "KEYOP_TIME_FINISH");
				String ceRefNum = pc.returnKeyValue(i, "CE_REFERRAL_NUM");
				String ceRefDate = pc.returnKeyValue(i, "CE_REFERRAL_DATE");
				String hdRefNum = pc.returnKeyValue(i, "HD_REFERRAL_NUM");
				String hdRefDate = pc.returnKeyValue(i, "HD_REFERRAL_DATE");
				String bondReqNum = pc.returnKeyValue(i, "BOND_REQ_NUM");
				int closeCodeID = pc.returnKeyValueInt(i, "CLOSE_CODEID");
				String keyopFName =  pc.returnKeyValue(i, "KEYOP_FNAME");
				String keyopLName = pc.returnKeyValue(i, "KEYOP_LNAME");
				int vendorID = pc.returnKeyValueInt(i, "VENDORID");
				int keyopCompanyID = pc.returnKeyValueInt(i, "KO_COMPANYID");
				String keyopCompanyName = pc.returnKeyValue(i, "KO_COMPANY_NAME");
				
				String nArray = "";
				notesArray = prepareConnection2(koRequestID);
				for (Map<String, Object> x : notesArray) {
					nArray += " ::: " + pc.returnKeyValue(x, "DATE_TIME") + ": " + pc.returnKeyValue(x, "ADDED_BY") + " - " + pc.returnKeyValue(x, "NOTE");
				}
				nArray = nArray.replaceFirst(" ::: ", "");
				
				requests.getKORequest().add(KORequestFactory.KORequestCreateList(factory, koRequestID, reqEmail, reqName, reqTieline, reqExtPhone, timeSubmitted, deviceID, deviceName, deviceSerial, deviceType, tier, 
						e2eCategory, city, cityid, building, buildingid, floor, room, description, ccEmail, reqStatus, solution, keyopUserID, keyopName, timeFinished,
						closedBy, customerContacted, keyopTimeStart, keyopTimeFinish, ceRefNum, ceRefDate, hdRefNum, hdRefDate, bondReqNum, closeCodeID, keyopFName, keyopLName, vendorID, keyopCompanyID, 
						keyopCompanyName, nArray));
			}
		} catch (Exception e) {
			System.out.println("Error in formatXML.");
			e.printStackTrace();
			System.out.println(e);
		} //for loop
	}
	
	/**
	 * Prepares the SQL query
	 * @param - None 
	 * @return - List from result set
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> prepareConnection() {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();
		String numRows = CategoryTools.getCategoryValue1("API-MaxResults", "korequest");
		numRows = (numRows.equals("")) ? numRows = "10": numRows;
	    String sSQL = "SELECT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED,	DEVICEID, DEVICE_NAME, DEVICE_SERIAL, " +
	    		"DEVICE_TYPE, TIER, E2E_CATEGORY, CITY, CITYID, BUILDING, BUILDINGID, FLOOR, ROOM, DESCRIPTION, CC_EMAIL, REQ_STATUS, SOLUTION, KEYOP_USERID, KEYOP_NAME, TIME_FINISHED, " +
	    		"CLOSED_BY, CUSTOMER_CONTACTED, KEYOP_TIME_START, KEYOP_TIME_FINISH, CE_REFERRAL_NUM, CE_REFERRAL_DATE, HD_REFERRAL_NUM, HD_REFERRAL_DATE, BOND_REQ_NUM, CLOSE_CODEID, " +
	    		"KEYOP_FNAME, KEYOP_LNAME, VENDORID, KO_COMPANYID, KO_COMPANY_NAME " + 
	    		"FROM GPWS.KEYOP_REQUEST_VIEW";
	    String sWhere = " WHERE 1=1";
	    if (korequestid != null && !korequestid.equals("")) {
	    	sWhere += " AND KEYOP_REQUESTID = ?";
	    }
	    if (reqemail != null && !reqemail.equals("")) {
	    	sWhere += " AND UPPER(REQUESTOR_EMAIL) LIKE ?";
	    }
	    if (reqname != null && !reqname.equals("")) {
	    	sWhere += " AND UPPER(REQUESTOR_NAME) LIKE ?";
	    }
	    if (devicetype != null && !devicetype.equals("")) {
	    	sWhere += " AND UPPER(DEVICE_TYPE) LIKE ?";
	    }
	    if (devicename != null && !devicename.equals("")) {
	    	sWhere += " AND UPPER(DEVICE_NAME) LIKE ?";
	    }
	    if (cityValue != null && !cityValue.equals("")) {
	    	sWhere += " AND UPPER(CITY) LIKE ?";
	    }
	    if (buildingValue != null && !buildingValue.equals("")) {
	    	sWhere += " AND UPPER(BUILDING) LIKE ?";
	    }
	    if (reqstatus != null && !reqstatus.equals("")) {
	    	sWhere += " AND UPPER(REQ_STATUS) LIKE ?";
	    }
	    if (keyopname != null && !keyopname.equals("")) {
	    	sWhere += " AND UPPER(KEYOP_NAME) LIKE ?";
	    }
	    if (keyopuserid != null && !keyopuserid.equals("")) {
	    	sWhere += " AND KEYOP_USERID = ?";
	    }
	    if (closecodeid != null && !closecodeid.equals("")) {
	    	sWhere += " AND CLOSE_CODEID = ?";
	    }
	    if (dateRangeStart != null && !dateRangeStart.equals("") && dateRangeEnd != null && !dateRangeEnd.equals("")) {
	    	sWhere += " AND ( (TIME_SUBMITTED >= ? AND TIME_SUBMITTED <= ?) OR (TIME_FINISHED >= ? AND TIME_FINISHED <= ?) )";
	    }
	    String sOrderBy = " ORDER BY KEYOP_REQUESTID FETCH FIRST " + numRows + " ROWS ONLY";

	    System.out.println("SQL is " + sSQL + sWhere + sOrderBy);
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    int x = 1;
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      if (korequestid != null && !korequestid.equals("")) {
	    	  hm.put(x, korequestid);
	    	  x++;
	      }
	      if (reqemail != null && !reqemail.equals("")) {
	    	  hm.put(x, "%" + reqemail.toUpperCase() + "%");
	    	  x++;
	      }
	      if (reqname != null && !reqname.equals("")) {
	    	  hm.put(x, "%" + reqname.toUpperCase() + "%");
	    	  x++;
	      }
	      if (devicetype != null && !devicetype.equals("")) {
	    	  hm.put(x, "%" + devicetype.toUpperCase() + "%");
	    	  x++;
	      }
	      if (devicename != null && !devicename.equals("")) {
	    	  hm.put(x, "%" + devicename.toUpperCase() + "%");
	    	  x++;
	      }
	      if (cityValue != null && !cityValue.equals("")) {
	    	  hm.put(x, "%" + cityValue.toUpperCase() + "%");
	    	  x++;
	      }
	      if (buildingValue != null && !buildingValue.equals("")) {
	    	  hm.put(x, "%" + buildingValue.toUpperCase() + "%");
	    	  x++;
	      }
	      if (reqstatus != null && !reqstatus.equals("")) {
	    	  hm.put(x, "%" + reqstatus.toUpperCase() + "%");
	    	  x++;
	      }
	      if (keyopname != null && !keyopname.equals("")) {
	    	  hm.put(x, "%" + keyopname.toUpperCase() + "%");
	    	  x++;
	      }
	      if (keyopuserid != null && !keyopuserid.equals("")) {
	    	  hm.put(x, keyopuserid);
	    	  x++;
	      }
	      if (closecodeid != null && !closecodeid.equals("")) {
	    	  hm.put(x, closecodeid);
	    	  x++;
	      }
	      if (dateRangeStart != null && !dateRangeStart.equals("") && dateRangeEnd != null && !dateRangeEnd.equals("")) {
	    	  hm.put(x, dateRangeStart + "-00.00.00.00");
	    	  x++;
	    	  hm.put(x, dateRangeEnd + "-00.00.00.00");
	    	  x++;
	    	  hm.put(x, dateRangeStart + "-00.00.00.00");
	    	  x++;
	    	  hm.put(x, dateRangeEnd + "-00.00.00.00");
	    	  x++;
	      }	
	    
	    columns = pc.prepareConnection(sSQL + sWhere + sOrderBy, hm);
		
	    return columns;
	}
	
	/**
	 * Prepares the SQL query
	 * @param - None 
	 * @return - List from result set
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> prepareConnection2(int id) {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();	
		String sSQL = "SELECT DATE_TIME, NOTE, ADDED_BY FROM GPWS.KO_REQUEST_NOTES WHERE KEYOP_REQUESTID = ? ORDER BY DATE_TIME";
	    
		 System.out.println("SQL is " + sSQL);
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<KORequests> getRequestwParam(@Context HttpServletRequest req) throws IOException {
		setDeviceName(tools.nullStringConverter(req.getParameter("devicename")));
		setRequestID(tools.nullStringConverter(req.getParameter("korequestid"))); 
		setReqEmail(tools.nullStringConverter(req.getParameter("reqemail")));
		setReqName(tools.nullStringConverter(req.getParameter("reqname")));
		setDeviceType(tools.nullStringConverter(req.getParameter("devicetype")));
		setDeviceName(tools.nullStringConverter(req.getParameter("devicename")));
		setCityValue(tools.nullStringConverter(req.getParameter("city")));
		setBuildingValue(tools.nullStringConverter(req.getParameter("building")));
		setReqStatus(tools.nullStringConverter(req.getParameter("reqstatus")));
		setKeyopName(tools.nullStringConverter(req.getParameter("keyopname")));
		setKeyopUserID(tools.nullStringConverter(req.getParameter("keyopuserid")));
		setCloseCodeID(tools.nullStringConverter(req.getParameter("closecodeid")));
		setDateRangeStart(tools.nullStringConverter(req.getParameter("daterangestart")));
		setDateRangeEnd(tools.nullStringConverter(req.getParameter("daterangeend")));		
		
		if (korequestid.equals("") && devicename.equals("") && reqemail.equals("") && reqname.equals("") && devicetype.equals("") && cityValue.equals("") && buildingValue.equals("") && reqstatus.equals("")
				&& keyopname.equals("") && keyopuserid.equals("") && closecodeid.equals("") && dateRangeStart.equals("") && dateRangeEnd.equals("")) {
			 RespBuilder.createResponse(412);
		} else {
			populateList();
		}
		
        return createRequests(requests);
    } 
	
	
	@GET
	@Path("/korequestid/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getKORequestByID(@PathParam("id") String name, @Context HttpServletRequest req) {
		setRequestID(name); 
		populateList();
		
		return createRequests(requests);
	}
	
	
	@GET
	@Path("/reqemail/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByReqEmail(@PathParam("name") String name, @Context HttpServletRequest req) {
		setReqEmail(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/reqname/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByReqName(@PathParam("name") String name, @Context HttpServletRequest req) {
		setReqName(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/devicetype/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByDeviceType(@PathParam("name") String name, @Context HttpServletRequest req) {
		setDeviceType(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/devicename/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByDeviceName(@PathParam("name") String name, @Context HttpServletRequest req) {
		setDeviceName(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/city/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByCity(@PathParam("name") String name, @Context HttpServletRequest req) {
		setCityValue(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/building/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByBuilding(@PathParam("name") String name, @Context HttpServletRequest req) {
		setBuildingValue(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/reqstatus/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByReqStatus(@PathParam("name") String name, @Context HttpServletRequest req) {
		setReqStatus(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/keyopname/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByKeyopName(@PathParam("name") String name, @Context HttpServletRequest req) {
		setKeyopName(name);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/keyopuserid/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByKeyopUserID(@PathParam("id") String id, @Context HttpServletRequest req) {
		setKeyopUserID(id);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/closecodeid/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByCloseCodeID(@PathParam("id") String id, @Context HttpServletRequest req) {
		setCloseCodeID(id);
		populateList();
		
		return createRequests(requests);
	}
	
	@GET
	@Path("/rangestart/{start}/rangeend/{end}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<KORequests> getByCloseCodeID(@PathParam("start") String start, @PathParam("end") String end, @Context HttpServletRequest req) {
		setDateRangeStart(start);
		setDateRangeEnd(end);
		populateList();
		
		return createRequests(requests);
	}
	
	public JAXBElement<KORequests> createRequests(KORequests value) {
		QName _var_QNAME = new QName(KORequests.class.getSimpleName());
		return new JAXBElement<KORequests>(_var_QNAME, KORequests.class, value);
	}
} //KORequestJax
