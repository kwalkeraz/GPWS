package tools.print.api.floor;

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

import tools.print.api.floor.FloorFactory;
import tools.print.api.floor.Floors;
import tools.print.api.floor.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/floor")
public class FloorJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Floors floors = null;
	protected String geoValue = "";
	protected String countryValue = "";
	protected String stateValue = "";
	protected String cityValue = "";
	protected String buildingValue = "";
	protected String deviceAvailValue = "";
    //protected String statusValue = "";
    protected String dev_statusValue = "";
    protected String loc_statusValue = "";
    protected String floorValue = "";
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
    
    public void setBuildingName(String value) {
    	this.buildingValue = value;
    }
    
    public String getBuildingName() {
    	return buildingValue;
    }
    
    public void setFloorName(String value) {
    	this.floorValue = value;
    }
    
    public String getFloorName() {
    	return floorValue;
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
		floors = factory.createFloors();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "LOCID");
				String floor = pc.returnKeyValue(i, "FLOOR_NAME");
				String status = pc.returnKeyValue(i, "FLOOR_STATUS");
				if (geoValue.equals("")) setGeoName(pc.returnKeyValue(i, "GEO"));
				if (countryValue.equals("")) setCountryName(pc.returnKeyValue(i, "COUNTRY"));
				if (cityValue.equals("")) setCityName(pc.returnKeyValue(i, "CITY"));
				if (buildingValue.equals("")) setBuildingName(pc.returnKeyValue(i, "BUILDING_NAME"));
				String url = setURL(floor);
				floors.getFloor().add(FloorFactory.FloorCreateList(factory, id, floor, status, url));
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
		
		String sFunctionSQL = "";
		String orFunctionSQL = "";
		String delims = "[,]";
		String[] tokens = deviceAvailValue.toUpperCase().split(delims);
		for (int i = 0; i < tokens.length; i++) {
		    //System.out.println(tokens[i]);
		    if (!tokens[i].equals("all") && !deviceAvailValue.equals("")) {
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
		if (!floorValue.equals("") && !deviceAvailValue.equals("") && !dev_statusValue.equals("") && !loc_statusValue.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE UPPER(A.FLOOR_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND A.FLOOR_NAME = '" + floorValue.toUpperCase() + "' AND BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE ( UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) AND EXISTS (SELECT LOCID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.LOCID = B.LOCID " + sFunctionSQL + ") ORDER BY FLOOR_NAME";
		} else if (!floorValue.equals("") && !deviceAvailValue.equals("") && !dev_statusValue.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE A.FLOOR_NAME = '" + floorValue.toUpperCase() + "' AND BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE ( UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) AND EXISTS (SELECT LOCID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.LOCID = B.LOCID " + sFunctionSQL + ") ORDER BY FLOOR_NAME";
		} else if  (!deviceAvailValue.equals("") && !dev_statusValue.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE (UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) AND EXISTS (SELECT LOCID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.LOCID = B.LOCID " + sFunctionSQL + ") ORDER BY FLOOR_NAME";
		//
		} else if  (!deviceAvailValue.equals("") && !loc_statusValue.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE UPPER(A.FLOOR_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE (UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) AND EXISTS (SELECT LOCID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.LOCID = B.LOCID " + sFunctionSQL + ") ORDER BY FLOOR_NAME";
		
		} else if (!loc_statusValue.equals("")) {
	    	sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE UPPER(A.FLOOR_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE (UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) ORDER BY FLOOR_NAME";
		} else if (!deviceAvailValue.equals("")) {
	    	sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE (UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) AND EXISTS (SELECT LOCID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.LOCID = B.LOCID " + sFunctionSQL + ") ORDER BY FLOOR_NAME";
		} else if (!floorValue.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE A.FLOOR_NAME = '" + floorValue.toUpperCase() + "' AND BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE ( UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) ORDER BY FLOOR_NAME";
		} else {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION WHERE BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE (UPPER(BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + cityValue.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))))) ORDER BY FLOOR_NAME";
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
	    
	    //String sSQL = "SELECT A.*, B.STATUS AS FLOOR_STATUS FROM GPWS.LOCATION_VIEW A, GPWS.LOCATION B WHERE A.LOCID = B.LOCID AND A.LOCID= ?";
		String sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION WHERE LOCID = ?";
	    
		//System.out.println("SQL is: " + sSQL);
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	private String setURL(String floor){
		String protocol = "http://";
		String server = pc.setServerName();
		String uri = pc.setURI() +  pc.setServletPath() + "/printer";
		//String parameters = "?floor="+floor+"&building="+getBuildingName()+"&city="+getCityName()+"&country="+getCountryName()+"&geo="+getGeoName();
		String parameters = "?floor="+floor+"&building="+getBuildingName()+"&city="+getCityName()+"&country="+getCountryName()+"&geo="+getGeoName()+"&deviceavailable=print"+"&dev_status=completed";
		String url = protocol + server + uri + parameters;
		return url;
	}
	
	
	@GET
	@Path("/{geo}/{country}/{city}/{building}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Floors> getFloor(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("city") String cityValue, 
    		@PathParam("building") String buildingValue, @Context HttpServletRequest req) {
		setBuildingName(buildingValue);
		setCityName(cityValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		populateList();
		
		return createFloors(floors);
    } //getFloor
	
	@GET
	@Path("/{geo}/{country}/{city}/{building}/{loc_status}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Floors> getFloor(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("city") String cityValue, 
    		@PathParam("building") String buildingValue, @PathParam("loc_status") String statusValue, @Context HttpServletRequest req) {
		setBuildingName(buildingValue);
		setCityName(cityValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		setStatusValue(statusValue);
		populateList();
		
		return createFloors(floors);
    } //getFloor
	
	@GET
	@Path("/{geo}/{country}/{city}/{building}/{dev_status}/{deviceavailable}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Floors> getFloor(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("city") String cityValue, 
    		@PathParam("building") String buildingValue, @PathParam("dev_status") String statusValue, @PathParam("deviceavailable") String deviceAvail, 
    		@Context HttpServletRequest req) {
		setBuildingName(buildingValue);
		setCityName(cityValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		setStatusValue(statusValue);
		setDeviceAvailValue(deviceAvail);
		populateList();
		
		return createFloors(floors);
    } //getFloor
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Floors> getFloor(@Context HttpServletRequest req) throws IOException {
		String locID = tools.nullStringConverter(req.getParameter("id"));
		setGeoName(tools.nullStringConverter(req.getParameter("geo"))); 
		setCountryName(tools.nullStringConverter(req.getParameter("country")));
		setCityName(tools.nullStringConverter(req.getParameter("city")));
		setBuildingName(tools.nullStringConverter(req.getParameter("building")));
		setFloorName(tools.nullStringConverter(req.getParameter("floor")));
		//deviceAvailValue = tools.nullStringConverter(req.getParameter("deviceavailable"));
		//statusValue = tools.nullStringConverter(req.getParameter("status"));
		setStatusValue(tools.nullStringConverter(req.getParameter("dev_status")));
		setLocStatusValue(tools.nullStringConverter(req.getParameter("loc_status")));
		setDeviceAvailValue(tools.nullStringConverter(req.getParameter("deviceavailable")));
		if (((geoValue.equals("") || countryValue.equals("")) || cityValue.equals("") || buildingValue.equals("")) && req.getParameter("id") == null) {
			 RespBuilder.createResponse(412);
		} else if (!locID.equals("")){
			populateListbyName(Integer.parseInt(locID));
		} else {
			populateList();
		}
		
        return createFloors(floors);
    } //getFloor
	
	@GET
	@Path("/id/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Floors> getFloorByName(@PathParam("id") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createFloors(floors);
	}
	
	public JAXBElement<Floors> createFloors(Floors value) {
		QName _var_QNAME = new QName(Floors.class.getSimpleName());
		return new JAXBElement<Floors>(_var_QNAME, Floors.class, value);
	}

} //FloorJax
