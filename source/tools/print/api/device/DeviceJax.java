package tools.print.api.device;

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

import tools.print.api.device.DeviceFactory;
import tools.print.api.device.Devices;
import tools.print.api.device.ObjectFactory;
import tools.print.api.device.SQLBuilder;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/device")
public class DeviceJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	GetTimeStamps gt = new GetTimeStamps();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Devices devices = null;
	protected String devicenameValue = "";
	protected String osValue = "";
	protected String ipValue = "";
	protected String geoValue = "";
	protected String countryValue = "";
	protected String cityValue = "";
	protected String buildingValue = "";
	protected String floorValue = "";
	protected String statusValue = "";
	protected int deviceidValue = 0;
	protected String modifiedToday = "";
	protected String startDate = "";
	protected String endDate = "";
	protected boolean showFunctions = false;
	protected String category = "";
	
	
	private final String getCategory() {
		return category;
	}

	private final void setCategory(String category) {
		this.category = category;
	}

	private final boolean isShowFunctions() {
		return showFunctions;
	}

	private final void setShowFunctions(boolean showFunctions) {
		this.showFunctions = showFunctions;
	}

	public String getDeviceName() {
    	return devicenameValue;
    }
    
    public void setDeviceName(String value) {
    	this.devicenameValue = value;
    }
    
    public String getOSValue() {
    	return osValue;
    }
    
    public void setOSValue(String value) {
    	this.osValue = value;
    }
    
    public String getIPValue() {
    	return ipValue;
    }
    
    public void setIPValue(String value) {
    	this.ipValue = value;
    }
    
    public String getGeoValue() {
    	return geoValue;
    }
    
    public void setGeoValue(String value) {
    	this.geoValue = value;
    }
    
    public String getCountryValue() {
    	return countryValue;
    }
    
    public void setCountryValue(String value) {
    	this.countryValue = value;
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
    
    public String getFloorValue() {
    	return floorValue;
    }
    
    public void setFloorValue(String value) {
    	this.floorValue = value;
    }
    
    public void setStatusValue(String value) {
    	this.statusValue = value;
    }
    
    public String getStatusValue() {
    	return statusValue;
    }
    
    public void setDeviceIDValue(int value) {
    	this.deviceidValue = value;
    }
    
    public int getDeviceIDValue() {
    	return deviceidValue;
    }
    
    public void setStartDateValue(String value) {
    	this.startDate = value;
    }
    
    public String getStartDateValue() {
    	return startDate;
    }
    
    public void setEndDateValue(String value) {
    	this.endDate = value;
    }
    
    public String getEndDateValue() {
    	return endDate;
    }
	
	private final String getModifiedToday() {
		return modifiedToday;
	}

	private final void setModifiedToday(String modifiedToday) {
		this.modifiedToday = modifiedToday;
	}

	public void createList(List<Map<String, Object>> columns) {
		devices = factory.createDevices();
		List<Map<String, Object>> functionArray;
		
		try {
			for (Map<String, Object> i : columns)  {
				int deviceid = pc.returnKeyValueInt(i, "DEVICEID");
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
				String webVisible = pc.returnKeyValue(i, "WEB_VISIBLE");
				String installable = pc.returnKeyValue(i, "INSTALLABLE");
				String port = pc.returnKeyValue(i, "PORT");
				String duplex = pc.returnKeyValue(i, "DUPLEX");
				String dipp = pc.returnKeyValue(i, "DIPP");
				String faxNumber = pc.returnKeyValue(i, "FAX_NUMBER");
				String ipDomain = pc.returnKeyValue(i, "IP_DOMAIN");
				String ipSubnet = pc.returnKeyValue(i, "IP_SUBNET");
				String ipGateway = pc.returnKeyValue(i, "IP_GATEWAY");
				String ipHostname = pc.returnKeyValue(i, "IP_HOSTNAME");
				String ipAddress = pc.returnKeyValue(i, "IP_ADDRESS");
				String lanDrop = pc.returnKeyValue(i, "LAN_DROP");
				String model = pc.returnKeyValue(i, "MODEL");
				String e2ecategory = pc.returnKeyValue(i, "E2E_CATEGORY");
				String driverSetName = pc.returnKeyValue(i, "DRIVER_SET_NAME");
				String clientDefType = pc.returnKeyValue(i, "CLIENT_DEF_TYPE");
				String serverName = pc.returnKeyValue(i, "SERVER_NAME");
				String comm = pc.returnKeyValue(i, "COMM");
				String commPort = pc.returnKeyValue(i, "COMM_PORT");
				String spooler = pc.returnKeyValue(i, "SPOOLER");
				String spoolerPort = pc.returnKeyValue(i, "SPOOLER_PORT");
				String supervisor = pc.returnKeyValue(i, "SUPERVISOR");
				String supervisorPort = pc.returnKeyValue(i, "SUPERVISOR_PORT");
				String ftpSite = pc.returnKeyValue(i, "FTP_SITE");
				String confidentialPrint = pc.returnKeyValue(i, "CONFIDENTIAL_PRINT");
				int koCompanyID = pc.returnKeyValueInt(i, "KO_COMPANYID");
				String vendorName = pc.returnKeyValue(i, "VENDOR_NAME");
				String igsKeyop = pc.returnKeyValue(i, "IGS_KEYOP");
				String IPDS =  pc.returnKeyValue(i, "IPDS");
				String serialnumber = pc.returnKeyValue(i, "SERIAL_NUMBER");
				String OS = pc.returnKeyValue(i, "OS_ABBR");
				String sPackage = pc.returnKeyValue(i, "PACKAGE");
				String version = pc.returnKeyValue(i, "VERSION");
				String driverName = pc.returnKeyValue(i, "DRIVER_NAME");
				String dataFile = pc.returnKeyValue(i, "DATA_FILE");
				String driverPath = pc.returnKeyValue(i, "DRIVER_PATH");
				String configFile = pc.returnKeyValue(i, "CONFIG_FILE");
				String helpFile = pc.returnKeyValue(i, "HELP_FILE"); 
				String monitor = pc.returnKeyValue(i, "MONITOR");
				String monitorFile = pc.returnKeyValue(i, "MONITOR_FILE");
				String fileList = pc.returnKeyValue(i, "FILE_LIST");
				String defaultType = pc.returnKeyValue(i, "DEFAULT_TYPE");
				String proc = pc.returnKeyValue(i, "PROC");
				String procFile = pc.returnKeyValue(i, "PROC_FILE");
				String prtAttributes = pc.returnKeyValue(i, "PRT_ATTRIBUTES");
				String changeINI = pc.returnKeyValue(i, "CHANGE_INI");
				String optionsFileName = pc.returnKeyValue(i, "OPTIONS_FILE_NAME");
				String installDate = pc.returnKeyValue(i, "INSTALL_DATE");
				String modifiedDate = pc.returnKeyValue(i, "MODIFIED_DATE");
				String deleteDate = pc.returnKeyValue(i, "DELETE_DATE");
				String fnArray = "";
				if (isShowFunctions()) {
					functionArray = prepareConnection2(deviceid);
					for (Map<String, Object> x : functionArray) {
						fnArray = fnArray + ", " + pc.returnKeyValue(x, "FUNCTION_NAME");
					}
					fnArray = fnArray.replaceFirst(", ", "");
				}
				
				devices.getDevice().add(DeviceFactory.DeviceCreateList(factory, deviceid, geo, country, state, city, building, floor, devicename,
						status, room, roomaccess, lpname, webVisible, installable, port, duplex, dipp, faxNumber, ipDomain, ipSubnet, 
						ipGateway, ipHostname, ipAddress, lanDrop, model, e2ecategory, driverSetName, clientDefType, serverName, comm, 
						commPort, spooler, spoolerPort, supervisor, supervisorPort, ftpSite, confidentialPrint, 
						koCompanyID, vendorName, igsKeyop, IPDS, serialnumber, OS, sPackage, version, driverName, dataFile,
						driverPath, configFile, helpFile, monitorFile, fileList, defaultType, proc, procFile, prtAttributes,
						changeINI, optionsFileName, installDate, modifiedDate, deleteDate, fnArray));
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
		osValue = osValue.equals("") ? osValue = "LX" : osValue;
		
		if (!getFloorValue().equals("")) {
			sSQL = SQLBuilder.byFloor(getOSValue(), getFloorValue(), getBuildingValue(), getCityValue(), getCountryValue(), getGeoValue(), getStatusValue());
	    } else if (!getBuildingValue().equals("")) {
	    	sSQL = SQLBuilder.byBuilding(getOSValue(), getBuildingValue(), getCityValue(), getCountryValue(), getGeoValue(), getStatusValue());
	    } else if (!getCityValue().equals("")) {
	    	sSQL = SQLBuilder.byCity(getOSValue(), getCityValue(), getCountryValue(), getGeoValue(), getStatusValue());
	    } else if (!getIPValue().equals("")) {
	    	sSQL = SQLBuilder.byIPAddress(getIPValue(), getOSValue().toUpperCase());
	    } else if (getDeviceIDValue() != 0) {
	    	sSQL = SQLBuilder.byID(getDeviceIDValue(), getOSValue().toUpperCase());
	    } else if (!getModifiedToday().equals("")) {
	    	sSQL = SQLBuilder.byModifiedDateToday(getOSValue().toUpperCase(), getModifiedToday());
	    } else if (!getStartDateValue().equals("") && !getEndDateValue().equals("")) {
	    	sSQL = SQLBuilder.byModifiedDateRange(getOSValue().toUpperCase(), getStartDateValue(), getEndDateValue());
	    } else if (!getCategory().equals("")) {
	    	sSQL = SQLBuilder.byCategoryField(getOSValue().toUpperCase(), getCategory());
	    } else {
			sSQL = SQLBuilder.byDeviceName(getDeviceName(), getOSValue().toUpperCase(), getStatusValue());
		}
		
		System.out.println("SQL: " + sSQL);
		//To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = null;
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
	    
	    String sSQL = "SELECT DEVICEID, FUNCTION_NAME FROM GPWS.DEVICE_FUNCTIONS WHERE DEVICEID = ? ORDER BY FUNCTION_NAME";
	    
	    //System.out.println("SQL: " + sSQL);
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Devices> getDevicewParam(@Context HttpServletRequest req) throws IOException {
		setDeviceName(tools.nullStringConverter(req.getParameter("devicename")));
		setOSValue(tools.nullStringConverter(req.getParameter("os")));
		setIPValue(tools.nullStringConverter(req.getParameter("ip")));
		setGeoValue(tools.nullStringConverter(req.getParameter("geo")));
		setCountryValue(tools.nullStringConverter(req.getParameter("country")));
		setCityValue(tools.nullStringConverter(req.getParameter("city")));
		setBuildingValue(tools.nullStringConverter(req.getParameter("building")));
		setFloorValue(tools.nullStringConverter(req.getParameter("floor")));
		setStatusValue(tools.nullStringConverter(req.getParameter("status")));
		setStartDateValue(tools.nullStringConverter(req.getParameter("mod_start_date")));
		setEndDateValue(tools.nullStringConverter(req.getParameter("mod_end_date")));
		setShowFunctions(Boolean.valueOf(tools.nullStringConverter(req.getParameter("showfunctions"))));
		if (req.getParameter("deviceid") != null) 
			setDeviceIDValue(Integer.parseInt(tools.nullStringConverter(req.getParameter("deviceid"))));
		
		if (getDeviceName().equals("") && getDeviceIDValue() == 0 && getIPValue().equals("") & getGeoValue().equals("") && getCountryValue().equals("") && getCityValue().equals("")
				&& getStartDateValue().equals("") && getEndDateValue().equals("") && tools.nullStringConverter(req.getParameter("modified-today")).equals("")) {
			RespBuilder.createResponse(412);
		} else if (!tools.nullStringConverter(req.getParameter("modified-today")).equals("")) {
			setModifiedToday(gt.todaysDate());
			populateList();
		} else {
			populateList();
		}
        return createDevices(devices);
    } 
	
	//{devicnename} - Search by device name
	@GET
	@Path("/devicename/{devicename}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyName(@PathParam("devicename") String name, @Context HttpServletRequest req) {
		setDeviceName(name); 
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//modified-today - search by modified date as of today.  Please note that it grabs the server time for today and it compares it
	// to the modified_date field in the database.
	@GET
	@Path("/modified-today")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyName(@Context HttpServletRequest req) {
		//modifiedToday = gt.todaysDate();
		setModifiedToday(gt.todaysDate());
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//modified-range - Search by a modified date range.  Grabs the date supplied and compares it to the modified_date field in the db
	// ie - modified-range/2009-05-07/2009-05-09.  Date must be in this format YYYY-mm-dd
	@GET
	@Path("/modified-range/{startDate}/{endDate}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyDateRange(@PathParam("startDate") String startdate, @PathParam("endDate") String enddate, @Context HttpServletRequest req) {
		setStartDateValue(startdate);
		setEndDateValue(enddate);
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//{status} is an optional parameter to search for only completed devices
	@GET
	@Path("/e2ecategory/{category}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyCategory(@PathParam("category") String category, @Context HttpServletRequest req) {
		setCategory(category);
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//seach by OS support - ie W7, LX
	@GET
	@Path("/devicename/{devicename}/os/{os}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyOS(@PathParam("devicename") String name, @PathParam("os") String os, @Context HttpServletRequest req) {
		setDeviceName(name); 
		setOSValue(os);
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//{status} is an optional parameter to search for only completed devices
	@GET
	@Path("/devicename/{devicename}/os/{os}/{status}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyOS(@PathParam("devicename") String name, @PathParam("os") String os, @PathParam("status") String status, @Context HttpServletRequest req) {
		setDeviceName(name); 
		setOSValue(os);
		setStatusValue(status);
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//{deviceid} - Search by deviceid
	@GET
	@Path("/deviceid/{deviceid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyID(@PathParam("deviceid") int deviceid, @Context HttpServletRequest req) {
		setDeviceIDValue(deviceid);
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	//{ip} - Search by IP
	@GET
	@Path("/ip/{ip}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyIP(@PathParam("ip") String name, @Context HttpServletRequest req) {
		setDeviceName(name); 
		setShowFunctions(true);
		populateList();
		
		return createDevices(devices);
	}
	
	public JAXBElement<Devices> createDevices(Devices value) {
		QName _var_QNAME = new QName(Devices.class.getSimpleName());
		return new JAXBElement<Devices>(_var_QNAME, Devices.class, value);
	}
} //DeviceJax