package tools.print.api.commonprocess;

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

import tools.print.api.commonprocess.Requests;
import tools.print.api.commonprocess.CommonProcessFactory;
import tools.print.api.commonprocess.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/commonprocess")
public class RequestJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Requests requests = null;
	protected String requestNumber = "";
	protected String cpapprovalid = "";
	
	public String getRequestNum() {
    	return requestNumber;
    }
    
    public void setRequestNum(String value) {
    	this.requestNumber = value;
    }
    
    public String getCPApprovalID() {
    	return cpapprovalid;
    }
    
    public void setCPApprovalID(String value) {
    	this.cpapprovalid = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		requests = factory.createRequests();
		
		List<Map<String, Object>> functionArray;
		List<Map<String, Object>> routingSteps;
		
		try {
			for (Map<String, Object> i : columns)  {
				int cpapprovalid = pc.returnKeyValueInt(i, "CPAPPROVALID");
				String requestNumber = pc.returnKeyValue(i, "REQ_NUM");
				String status = pc.returnKeyValue(i, "REQ_STATUS");
				String action = pc.returnKeyValue(i, "ACTION");
				String deviceName = pc.returnKeyValue(i, "DEVICE_NAME");
				String geo = pc.returnKeyValue(i, "GEO");
				String country = pc.returnKeyValue(i, "COUNTRY");
				String city = pc.returnKeyValue(i, "CITY");
				String building = pc.returnKeyValue(i, "BUILDING");
				String floor = pc.returnKeyValue(i, "FLOOR");
				String room = pc.returnKeyValue(i, "ROOM"); 
				String requesterName = pc.returnKeyValue(i, "REQ_NAME");
				String emailAddress = pc.returnKeyValue(i, "REQ_EMAIL");
				String phone = pc.returnKeyValue(i, "REQ_PHONE");
				String requestedDate = pc.returnKeyValue(i, "REQ_DATE");
				String justification = pc.returnKeyValue(i, "REQ_JUSTIFICATION");
				String cs = pc.returnKeyValue(i, "CS");
				String mvs = pc.returnKeyValue(i, "MVS"); 
				String vm = pc.returnKeyValue(i, "VM"); 
				String sap = pc.returnKeyValue(i, "SAP"); 
				String wts = pc.returnKeyValue(i, "WTS");
				String fnArray = "";
				functionArray = prepareConnection2(deviceName);
				for (Map<String, Object> x : functionArray) {
					fnArray = fnArray + ", " + pc.returnKeyValue(x, "FUNCTION_NAME");
				}
				fnArray = fnArray.replaceFirst(", ", "");
				
				routingSteps = prepareConnection3(cpapprovalid);
				requests.getRequest().add(CommonProcessFactory.RequestCreateList(factory, cpapprovalid, requestNumber, status, action, deviceName, fnArray, geo, country, 
						city, building, floor, room, requesterName, emailAddress, phone, requestedDate, justification, cs, mvs, vm, sap, wts, routingSteps));
			}
		} catch (Exception e) {
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
		String sSQL = "";
	    String parameter = "";
	    if (!cpapprovalid.equals("")) {
			sSQL = "SELECT * FROM GPWS.CP_APPROVAL_VIEW WHERE CPAPPROVALID = ?";
			parameter = cpapprovalid;
		} else if (!requestNumber.equals("")) {
			sSQL = "SELECT * FROM GPWS.CP_APPROVAL_VIEW WHERE UPPER(REQ_NUM) = ?";
			parameter = requestNumber.toUpperCase();
		} 
	    //System.out.println("SQL is: " + sSQL);
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	    hm.put(1, parameter);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	/**
	 * Prepares the SQL query
	 * @param - None 
	 * @return - List from result set
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> prepareConnection2(String deviceName) {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();	
		String sSQL = "SELECT FUNCTION_NAME FROM GPWS.DEVICE_FUNCTIONS_VIEW WHERE DEVICE_NAME = ? ORDER BY FUNCTION_NAME";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, deviceName);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	/**
	 * Prepares the SQL query
	 * @param - None 
	 * @return - List from result set
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> prepareConnection3(int cpapprovalid) {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();	
		String sSQL = "SELECT * FROM GPWS.CP_ROUTING WHERE CPAPPROVALID = ? ORDER BY STEP";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, cpapprovalid);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Requests> getDevicewParam(@Context HttpServletRequest req) throws IOException {
		setRequestNum(tools.nullStringConverter(req.getParameter("requestnumber")));
		setCPApprovalID(tools.nullStringConverter(req.getParameter("cpapprovalid")));
		if (cpapprovalid.equals("") && requestNumber.equals("")) {
			 RespBuilder.createResponse(412);
		} else {
			populateList();
		}
		
        return createRequests(requests);
    } 
	
	
	@GET
	@Path("/requestnum/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Requests> getDevicebyName(@PathParam("name") String name, @Context HttpServletRequest req) {
		setRequestNum(name); 
		populateList();
		
		return createRequests(requests);
	}
	
	
	@GET
	@Path("/cpapprovalid/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Requests> getDevicebyIP(@PathParam("id") String name, @Context HttpServletRequest req) {
		setCPApprovalID(name);
		populateList();
		
		return createRequests(requests);
	}
	
	public JAXBElement<Requests> createRequests(Requests value) {
		QName _var_QNAME = new QName(Requests.class.getSimpleName());
		return new JAXBElement<Requests>(_var_QNAME, Requests.class, value);
	}
} //RequestJax