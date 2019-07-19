package tools.print.api.copier;

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

import tools.print.api.copier.Devices;
import tools.print.api.copier.ObjectFactory;
import tools.print.api.copier.CopierFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/copier")
public class CopierJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Devices copiers = null;
	protected String devicenameValue = "";
	protected int deviceidValue = 0;
	
	public String getDeviceName() {
    	return devicenameValue;
    }
    
    public void setDeviceName(String value) {
    	this.devicenameValue = value;
    }
    
    public void setDeviceIDValue(int value) {
    	this.deviceidValue = value;
    }
    
    public int getDeviceIDValue() {
    	return deviceidValue;
    }
    	
	public void createList(List<Map<String, Object>> columns) {
		copiers = factory.createDevices();
		
		try {
			for (Map<String, Object> i : columns)  {
				String geo = pc.returnKeyValue(i, "GEO");
				String country = pc.returnKeyValue(i, "COUNTRY"); 
				String state = pc.returnKeyValue(i, "STATE");
				String city = pc.returnKeyValue(i, "CITY"); 
				String building = pc.returnKeyValue(i, "BUILDING_NAME");
				String floor = pc.returnKeyValue(i, "FLOOR_NAME"); 
				String devicename = pc.returnKeyValue(i, "DEVICE_NAME"); 
				String status = pc.returnKeyValue(i, "STATUS");
				String room = pc.returnKeyValue(i, "ROOM"); 
				String roomaccess = pc.returnKeyValue(i, "ROOM_ACCESS"); 
				String lpname = pc.returnKeyValue(i, "LPNAME");
				String model = pc.returnKeyValue(i, "MODEL"); 
				String serialnumber = pc.returnKeyValue(i, "SERIAL_NUMBER");
				copiers.getCopier().add(CopierFactory.CopierCreateList(factory, geo, country, state, city, building, floor, devicename, status, room, roomaccess, lpname, 
						model, serialnumber));
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
		String function = "copy";
		String sSQL = "";
		
		if (deviceidValue != 0) {
			sSQL = "SELECT * FROM GPWS.DEVICE_FUNCTIONS_VIEW WHERE DEVICEID = ? AND UPPER(FUNCTION_NAME) = ?";
		} else {
			sSQL = "SELECT * FROM GPWS.DEVICE_FUNCTIONS_VIEW WHERE DEVICE_NAME = ? AND UPPER(FUNCTION_NAME) = ?";
		}
	    //System.out.println("SQL is: " + sSQL);
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, deviceidValue !=0 ? deviceidValue : devicenameValue);
	      hm.put(2, function.toUpperCase());	
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
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
	    
	    return columns;
	}
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Devices> getDevicewParam(@Context HttpServletRequest req) throws IOException {
		setDeviceName(tools.nullStringConverter(req.getParameter("devicename")));
		if (req.getParameter("deviceid") != null) 
			setDeviceIDValue(Integer.parseInt(tools.nullStringConverter(req.getParameter("deviceid"))));
		
		if (devicenameValue.equals("") && deviceidValue == 0) {
			 RespBuilder.createResponse(412);
		} else {
			populateList();
		}
		
        return createDevices(copiers);
    } 
	
	
	@GET
	@Path("/devicename/{devicename}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyName(@PathParam("devicename") String name, @Context HttpServletRequest req) {
		setDeviceName(name); 
		populateList();
		
		return createDevices(copiers);
	}
	
	@GET
	@Path("/deviceid/{deviceid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyID(@PathParam("deviceid") int deviceid, @Context HttpServletRequest req) {
		setDeviceIDValue(deviceid);
		populateList();
		
		return createDevices(copiers);
	}
	
	
	@GET
	@Path("/ip/{ip}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyIP(@PathParam("ip") String name, @Context HttpServletRequest req) {
		setDeviceName(name); 
		populateList();
		
		return createDevices(copiers);
	}
	
	public JAXBElement<Devices> createDevices(Devices value) {
		QName _var_QNAME = new QName(Devices.class.getSimpleName());
		return new JAXBElement<Devices>(_var_QNAME, Devices.class, value);
	}
} //CopierJax
