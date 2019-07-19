package tools.print.api.building;

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

import tools.print.api.building.Buildings;
import tools.print.api.building.BuildingFactory;
import tools.print.api.building.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/building")
public class BuildingJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Buildings buildings = null;
	protected String geoValue = "";
	protected String countryValue = "";
	protected String stateValue = "";
	protected String cityValue = "";
	protected String deviceAvailValue = "";
    protected String dev_statusValue = "";
    protected String loc_statusValue = "";
    boolean isValid = true;
	
	public String getGeoName() {
		return geoValue;
    }

    public void setGeoName(String value) {
        this.geoValue = value;
    }
	
    public String getCountryName() {
		return countryValue;
    }

    public void setCountryName(String value) {
        this.countryValue = value;
    }
    
    public void setStateName(String value) {
    	this.stateValue = value;
    }
    
    public String getStateName() {
    	return stateValue;
    }
    
    public void setCityName(String value) {
    	this.cityValue = value;
    }
    
    public String getCityName() {
    	return cityValue;
    }
    
    public void setStatusValue(String value) {
    	this.dev_statusValue = value;
    }
    
    public String getStatusValue() {
    	return dev_statusValue;
    }
    
    public void setLocStatusValue(String value) {
    	this.loc_statusValue = value;
    }
    
    public String getLocStatusValue() {
    	return loc_statusValue;
    }
    
    public void setDeviceAvailValue(String value) {
    	this.deviceAvailValue = value;
    }
    
    public String getDeviceAvailValue() {
    	return deviceAvailValue;
    }
    
	public void createList(List<Map<String, Object>> columns) {
		buildings = factory.createBuildings();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "BUILDINGID");
				String building = pc.returnKeyValue(i, "BUILDING_NAME");
				String tier = pc.returnKeyValue(i, "TIER");
				String sdc = pc.returnKeyValue(i, "SDC");
				String sitecode = pc.returnKeyValue(i, "SITE_CODE");
				String workloccode = pc.returnKeyValue(i, "WORK_LOC_CODE");
				String status = pc.returnKeyValue(i, "BUILDING_STATUS");
				if (geoValue.equals("")) setGeoName(pc.returnKeyValue(i, "GEO"));
				if (countryValue.equals("")) setCountryName(pc.returnKeyValue(i, "COUNTRY"));
				if (cityValue.equals("")) setCityName(pc.returnKeyValue(i, "CITY"));
				String url = setURL(building);
				buildings.getBuilding().add(BuildingFactory.BuildingCreateList(factory, id, building, tier, sdc, sitecode, workloccode, status, url));
			} //for loop
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
		String sFunctionSQL = "";
		String orFunctionSQL = "";
		String delims = "[,]";
		String[] tokens = deviceAvailValue.toUpperCase().split(delims);
		for (int i = 0; i < tokens.length; i++) {
		    //System.out.println(tokens[i]);
		    if (!tokens[i].equals("all")) {
				sFunctionSQL = "AND (UPPER(FUNCTION_NAME) = '" + tokens[i] + "'";
		    	if (tokens.length > 1) {
		    		orFunctionSQL += " OR UPPER(FUNCTION_NAME) = '" + tokens[i] + "'";
		    	}
		    	sFunctionSQL = sFunctionSQL + orFunctionSQL + ")";
		    } //if else
		} //for loop
		
		if (!dev_statusValue.equals("")) {
			sFunctionSQL = sFunctionSQL + " AND UPPER(B.STATUS) = '"+ getStatusValue().toUpperCase() +"'";
		}
	    String sSQL = "";
	    if (!deviceAvailValue.equals("") && !dev_statusValue.equals("") && !loc_statusValue.equals("")) {
	    	sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING A WHERE UPPER(A.BUILDING_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "')))) AND EXISTS (SELECT BUILDINGID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.BUILDINGID = B.BUILDINGID " + sFunctionSQL + ") ORDER BY BUILDING_NAME";  
	    } else if (!deviceAvailValue.equals("") && !dev_statusValue.equals("")) {
	    	sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING A WHERE CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "')))) AND EXISTS (SELECT BUILDINGID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.BUILDINGID = B.BUILDINGID " + sFunctionSQL + ") ORDER BY BUILDING_NAME";  
	    //
	    } else if (!deviceAvailValue.equals("") && !loc_statusValue.equals("")) {
	    	sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING A WHERE UPPER(A.BUILDING_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "')))) AND EXISTS (SELECT BUILDINGID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.BUILDINGID = B.BUILDINGID " + sFunctionSQL + ") ORDER BY BUILDING_NAME";  
	    
	    } else if (!loc_statusValue.equals("")) {
	    	sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING A WHERE UPPER(A.BUILDING_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "')))) ORDER BY BUILDING_NAME";
	    } else if (!deviceAvailValue.equals("")) {
	    	sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING A WHERE CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "')))) AND EXISTS (SELECT BUILDINGID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.BUILDINGID = B.BUILDINGID " + sFunctionSQL + ") ORDER BY BUILDING_NAME";
	    } else {
			sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING WHERE CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "')))) ORDER BY BUILDING_NAME";
		} 
	    //System.out.println("SQL is: " + sSQL);
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
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
	    
	    //String sSQL = "SELECT A.*, B.BUILDING_NAME FROM GPWS.BUILDING_VIEW A, GPWS.BUILDING B WHERE BUILDINGID = ? AND A.BUILDING_NAME = B.BUILDING_NAME";
		String sSQL = "SELECT A.*, B.BUILDINGID FROM GPWS.BUILDING_VIEW A, GPWS.BUILDING B WHERE A.BUILDING_NAME = B.BUILDING_NAME AND B.BUILDINGID = ?";
	    
		//System.out.println("SQL is : " + sSQL);
		
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	private String setURL(String building){
		String protocol = "http://";
		String server = pc.setServerName();
		String uri = pc.setURI() +  pc.setServletPath() + "/floor";
		String parameters = "?building="+building+"&city="+getCityName()+"&country="+getCountryName()+"&geo="+getGeoName();
		String url = protocol + server + uri + parameters;
		return url;
	}
	
	
	@GET
	@Path("/{geo}/{country}/{city}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Buildings> getBuilding(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("city") String cityValue, 
    		@Context HttpServletRequest req) {
		setCityName(cityValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		populateList();
		
		return createBuildings(buildings);
    } //getBuilding
	
	@GET
	@Path("/{geo}/{country}/{city}/{loc_status}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Buildings> getBuilding(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("city") String cityValue, 
    		@PathParam("loc_status") String locstatusValue, @Context HttpServletRequest req) {
		setCityName(cityValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		setLocStatusValue(locstatusValue);
		populateList();
		
		return createBuildings(buildings);
    } //getBuilding
	
	@GET
	@Path("/{geo}/{country}/{city}/{dev_status}/{deviceavailable}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Buildings> getBuilding(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("city") String cityValue, 
    		@PathParam("dev_status") String statusValue, @PathParam("deviceavailable") String deviceAvail, @Context HttpServletRequest req) {
		setCityName(cityValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		setStatusValue(statusValue);
		setDeviceAvailValue(deviceAvail);
		populateList();
		
		return createBuildings(buildings);
    } //getFloor
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Buildings> getBuilding(@Context HttpServletRequest req) throws IOException {
		String buildingID = tools.nullStringConverter(req.getParameter("id"));
		setGeoName(tools.nullStringConverter(req.getParameter("geo"))); 
		setCountryName(tools.nullStringConverter(req.getParameter("country")));
		setCityName(tools.nullStringConverter(req.getParameter("city")));
		//deviceAvailValue = tools.nullStringConverter(req.getParameter("deviceavailable"));
		//statusValue = tools.nullStringConverter(req.getParameter("status"));
		setStatusValue(tools.nullStringConverter(req.getParameter("dev_status")));
		setLocStatusValue(tools.nullStringConverter(req.getParameter("loc_status")));
		setDeviceAvailValue(tools.nullStringConverter(req.getParameter("deviceavailable")));
		if (((geoValue.equals("") || countryValue.equals("")) || cityValue.equals("")) && req.getParameter("id") == null) {
			 RespBuilder.createResponse(412);
		} else if (!buildingID.equals("")){
			populateListbyName(Integer.parseInt(buildingID));
		} else {
			populateList();
		}
		
        return createBuildings(buildings);
    } //getFloor
	
	@GET
	@Path("/id/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Buildings> getBuildingByName(@PathParam("id") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createBuildings(buildings);
	}
	
	public JAXBElement<Buildings> createBuildings(Buildings value) {
		QName _var_QNAME = new QName(Buildings.class.getSimpleName());
		return new JAXBElement<Buildings>(_var_QNAME, Buildings.class, value);
	}

} //BuildingJax
