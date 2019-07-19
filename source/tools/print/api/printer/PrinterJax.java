package tools.print.api.printer;

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

import tools.print.api.printer.SQLBuilder;
import tools.print.api.printer.PrinterFactory;
import tools.print.api.printer.Devices;
import tools.print.api.printer.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/printer")
public class PrinterJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Devices printers = null;
	protected String devicenameValue = "";
	protected String osValue = "";
	protected String ipValue = "";
	protected String geoValue = "";
	protected String countryValue = "";
	protected String cityValue = "";
	protected String buildingValue = "";
	protected String floorValue = "";
	protected int deviceidValue = 0;
	protected String status = "";

	public String getPrinterName() {
    	return devicenameValue;
    }

    public void setPrinterName(String value) {
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

    public void setDeviceIDValue(int value) {
    	this.deviceidValue = value;
    }

    public int getDeviceIDValue() {
    	return deviceidValue;
    }

	protected final String getStatus() {
		return status;
	}

	protected final void setStatus(String status) {
		this.status = status;
	}

	public void createList(List<Map<String, Object>> columns) {
		printers = factory.createDevices();
		List<Map<String, Object>> protocolArray;

		try {
			for (Map<String, Object> i : columns)  {
				String geo = pc.returnKeyValue(i,"GEO");
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
				String port = pc.returnKeyValue(i, "PORT");
				String duplex = pc.returnKeyValue(i, "DUPLEX");
				String dipp= pc.returnKeyValue(i, "DIPP");
				String faxNumber = pc.returnKeyValue(i, "FAX_NUMBER");
				String ipDomain = pc.returnKeyValue(i, "IP_DOMAIN");
				String ipSubnet = pc.returnKeyValue(i, "IP_SUBNET");
				String ipGateway = pc.returnKeyValue(i, "IP_GATEWAY");
				String ipHostname = pc.returnKeyValue(i, "IP_HOSTNAME");
				String ipAddress = pc.returnKeyValue(i, "IP_ADDRESS");
				String lanDrop = pc.returnKeyValue(i, "LAN_DROP");
				String model = pc.returnKeyValue(i, "MODEL");
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
				String igsKeyop = pc.returnKeyValue(i, "IGS_KEYOP");
				String IPDS = pc.returnKeyValue(i, "IPDS");
				String serialnumber = pc.returnKeyValue(i, "SERIAL_NUMBER");
				String webVisible = pc.returnKeyValue(i, "WEB_VISIBLE");
				String installable = pc.returnKeyValue(i, "INSTALLABLE");
				String countryAbbr = pc.returnKeyValue(i, "COUNTRY_ABBR");
				String e2eCategory = pc.returnKeyValue(i, "E2E_CATEGORY");
				String CS = pc.returnKeyValue(i, "CS");
				String VM = pc.returnKeyValue(i, "VM");
				String MVS = pc.returnKeyValue(i, "MVS");
				String SAP = pc.returnKeyValue(i, "SAP");
				String WTS = pc.returnKeyValue(i, "WTS");
				String serverSDC = pc.returnKeyValue(i, "SERVER_SDC");
				String installDate = pc.returnKeyValue(i, "INSTALL_DATE");
				String modifiedDate = pc.returnKeyValue(i, "MODIFIED_DATE");
				String deleteDate = pc.returnKeyValue(i, "DELETE_DATE");
				int koCompanyID = pc.returnKeyValueInt(i, "KO_COMPANYID");
				String vendorName = pc.returnKeyValue(i, "VENDOR_NAME");
				String OS = pc.returnKeyValue(i, "OS_ABBR");
				String sPackage = pc.returnKeyValue(i, "PACKAGE");
				String version = pc.returnKeyValue(i, "VERSION");
				String driverName = pc.returnKeyValue(i, "DRIVER_NAME");
				String dataFile = pc.returnKeyValue(i, "DATA_FILE");
				String driverPath = pc.returnKeyValue(i, "DRIVER_PATH");
				String configFile = pc.returnKeyValue(i, "CONFIG_FILE");
				String helpFile = pc.returnKeyValue(i, "HELP_FILE");
				String monitorFile = pc.returnKeyValue(i, "MONITOR_FILE");
				String fileList = pc.returnKeyValue(i, "FILE_LIST");
				String defaultType = pc.returnKeyValue(i, "DEFAULT_TYPE");
				String proc = pc.returnKeyValue(i, "PROC");
				String procFile = pc.returnKeyValue(i, "PROC_FILE");
				String prtAttributes = pc.returnKeyValue(i, "PRT_ATTRIBUTES");
				String changeINI = pc.returnKeyValue(i, "CHANGE_INI");
				String optionsFileName = pc.returnKeyValue(i, "OPTIONS_FILE_NAME");
				String protocolPackage = "";
				String protocolVersion = "";
				protocolArray = prepareConnection2();
				for (Map<String, Object> x : protocolArray) {
					protocolPackage = pc.returnKeyValue(x, "PROTOCOL_PACKAGE");
					protocolVersion = pc.returnKeyValue(x, "PROTOCOL_VERSION");
				}

				//System.out.println("The protocols are --> package: " + protocolPackage + " version: " + protocolVersion);

				printers.getPrinter().add(PrinterFactory.PrinterCreateList(factory, geo, country, state, city, building, floor, devicename, status, room, roomaccess,
						lpname, port, duplex, dipp, faxNumber, ipDomain, ipSubnet, ipGateway, ipHostname, ipAddress, lanDrop, model, driverSetName, clientDefType, serverName,
						comm, commPort, spooler, spoolerPort, supervisor, supervisorPort, ftpSite, confidentialPrint, igsKeyop, IPDS, serialnumber, webVisible, installable,
						countryAbbr, e2eCategory, CS, VM, MVS, SAP, WTS, serverSDC, installDate, modifiedDate, deleteDate, koCompanyID, vendorName, OS, protocolPackage,
						protocolVersion, sPackage, version, driverName, dataFile, driverPath, configFile, helpFile, monitorFile, fileList, defaultType, proc, procFile,
						prtAttributes, changeINI, optionsFileName));
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
		//setOSValue(osValue.equals("") ? osValue = "LX" : osValue);

		if (!getFloorValue().equals("")) {
			sSQL = SQLBuilder.byFloor(getOSValue(), getFloorValue(), getBuildingValue(), getCityValue(), getCountryValue(), getGeoValue(), getStatus());
	    } else if (!getBuildingValue().equals("")) {
	    	sSQL = SQLBuilder.byBuilding(getOSValue(), getBuildingValue(), getCityValue(), getCountryValue(), getGeoValue(), getStatus());
	    } else if (!getCityValue().equals("")) {
	    	sSQL = SQLBuilder.byCity(getOSValue(), getCityValue(), getCountryValue(), getGeoValue(), getStatus());
	    } else if (!getIPValue().equals("")) {
	    	sSQL = SQLBuilder.byIPAddress(getIPValue(), getOSValue().toUpperCase());
	    } else if (getDeviceIDValue() != 0) {
	    	sSQL = SQLBuilder.byID(getDeviceIDValue(), getOSValue().toUpperCase());
	    } else {
			sSQL = SQLBuilder.byDeviceName(getPrinterName(), getOSValue().toUpperCase());
		}

		//System.out.println("SQL: " + sSQL);
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
	public List<Map<String, Object>> prepareConnection2() {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();
		String sSQL = "SELECT A.DEVICE_NAME, B.PRINTER_DEF_TYPEID, C.PROTOCOL_PACKAGE, C.PROTOCOL_VERSION FROM GPWS.DEVICE_VIEW A, GPWS.PRINTER_DEF_TYPE_CONFIG_VIEW B LEFT OUTER " +
				"JOIN GPWS.PROTOCOL_VIEW C ON (C.OS_PROTOCOLID = B.OS_PROTOCOLID) WHERE A.PRINTER_DEF_TYPEID = B.PRINTER_DEF_TYPEID AND B.OS_ABBR = ? ";

		String sSQL2 = "";
		String searchObject = "";
		String osObject = getOSValue();
		if (!getPrinterName().equals("")) {
			sSQL2 = "AND A.DEVICE_NAME = ?";
			searchObject = getPrinterName();
		} else if (!getIPValue().equals("")) {
			sSQL2 = "AND A.IP_ADDRESS = ?";
			searchObject = getIPValue();
		} else if (getDeviceIDValue() != 0) {
			sSQL2 = "AND A.DEVICEID = ? ";
		}

		//System.out.println("The 2nd SQL generated is " + sSQL + sSQL2);
		//To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, osObject);
	      hm.put(2, searchObject);

	    columns = pc.prepareConnection(sSQL+sSQL2, hm);

	    return columns;
	}

	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Devices> getDevicewParam(@Context HttpServletRequest req) throws IOException {
		setPrinterName(tools.nullStringConverter(req.getParameter("devicename")));
		setOSValue(tools.nullStringConverter(req.getParameter("os")));
		setIPValue(tools.nullStringConverter(req.getParameter("ip")));
		setGeoValue(tools.nullStringConverter(req.getParameter("geo")));
		setCountryValue(tools.nullStringConverter(req.getParameter("country")));
		setCityValue(tools.nullStringConverter(req.getParameter("city")));
		setBuildingValue(tools.nullStringConverter(req.getParameter("building")));
		setFloorValue(tools.nullStringConverter(req.getParameter("floor")));
		setStatus(tools.nullStringConverter(req.getParameter("status")));
		if (req.getParameter("deviceid") != null)
			setDeviceIDValue(Integer.parseInt(tools.nullStringConverter(req.getParameter("deviceid"))));

		if (getPrinterName().equals("") && getDeviceIDValue() == 0 && getIPValue().equals("") && (getGeoValue().equals("") && getCountryValue().equals("") && getCityValue().equals(""))) {
			 RespBuilder.createResponse(412);
		} else {
			populateList();
		}

        return createDevices(printers);
    }


	@GET
	@Path("/devicename/{devicename}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyName(@PathParam("devicename") String name, @Context HttpServletRequest req) {
		setPrinterName(name);
		populateList();

		return createDevices(printers);
	}

	@GET
	@Path("/devicename/{devicename}/os/{os}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyOS(@PathParam("devicename") String name, @PathParam("os") String os, @Context HttpServletRequest req) {
		setPrinterName(name);
		setOSValue(os);
		populateList();

		return createDevices(printers);
	}

	@GET
	@Path("/deviceid/{deviceid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyID(@PathParam("deviceid") int deviceid, @Context HttpServletRequest req) {
		setDeviceIDValue(deviceid);
		populateList();

		return createDevices(printers);
	}

	@GET
	@Path("/ip/{ip}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Devices> getDevicebyIP(@PathParam("ip") String name, @Context HttpServletRequest req) {
		setPrinterName(name);
		populateList();

		return createDevices(printers);
	}

	public JAXBElement<Devices> createDevices(Devices value) {
		QName _var_QNAME = new QName(Devices.class.getSimpleName());
		return new JAXBElement<Devices>(_var_QNAME, Devices.class, value);
	}
} //PrinterJax