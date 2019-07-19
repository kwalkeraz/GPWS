package tools.print.api.city;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

import tools.print.api.city.Cities;
import tools.print.api.city.CityFactory;
import tools.print.api.city.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;


@XmlRegistry
@Path("/city")
public class CityJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Cities cities = null;
	protected String geoValue = "";
	protected String countryValue = "";
	protected String stateValue = "";
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
		cities = factory.createCities();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "CITYID");
				String city = pc.returnKeyValue(i, "CITY");
				String status = pc.returnKeyValue(i, "CITY_STATUS");
				if (geoValue.equals("")) setGeoName(pc.returnKeyValue(i, "GEO"));
				if (countryValue.equals("")) setCountryName(pc.returnKeyValue(i, "COUNTRY"));
				if (stateValue.equals("")) setStateName(pc.returnKeyValue(i, "STATE"));
				String url = setURL(city);
				cities.getCity().add(CityFactory.CityCreateList(factory, id, city, status, url));
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
	    if (!dev_statusValue.equals("") && !deviceAvailValue.equals("") && !stateValue.equals("") && !loc_statusValue.equals("")) {
	    	sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE UPPER(A.CITY_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + stateValue.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID " + sFunctionSQL + ") ORDER BY CITY";
	    } else if (!dev_statusValue.equals("") && !deviceAvailValue.equals("") && !loc_statusValue.equals("")) {
	    	sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE UPPER(A.CITY_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID " + sFunctionSQL + ") ORDER BY CITY";
	    } else if (!dev_statusValue.equals("") && !deviceAvailValue.equals("") && !stateValue.equals("")) {
	    	sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + stateValue.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID " + sFunctionSQL + ") ORDER BY CITY";
	    } else if (!dev_statusValue.equals("") && !deviceAvailValue.equals("")) {
	    	sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID " + sFunctionSQL + ") ORDER BY CITY";
	    //
	    } else if (!loc_statusValue.equals("") && !deviceAvailValue.equals("")) {
	    	sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID " + sFunctionSQL + ") AND UPPER(A.CITY_STATUS) = '" + loc_statusValue.toUpperCase() + "' ORDER BY CITY";
	    } else if (!dev_statusValue.equals("")) {
	    	sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID AND UPPER(B.STATUS) = '"+ getStatusValue().toUpperCase() +"') ORDER BY CITY";
	    } else if (!stateValue.equals("") && !deviceAvailValue.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + stateValue.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_VIEW B WHERE A.CITYID = B.CITYID) ORDER BY CITY";
		} else if (!deviceAvailValue.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_VIEW B WHERE A.CITYID = B.CITYID) ORDER BY CITY";
		} else if (!stateValue.equals("") && !loc_statusValue.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + stateValue.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND UPPER(CITY_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' ORDER BY CITY";
		} else if (!stateValue.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + stateValue.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) ORDER BY CITY";
		} else if (!loc_statusValue.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY WHERE  STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) AND UPPER(CITY_STATUS) = '"+ getLocStatusValue().toUpperCase() +"' ORDER BY CITY";
		} else {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + countryValue.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + geoValue.toUpperCase() + "'))) ORDER BY CITY";
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
	    
	    //String sSQL = "SELECT A.*, B.STATE FROM GPWS.CITY A, GPWS.STATE B WHERE CITYID = ? AND A.STATEID = B.STATEID";
		String sSQL = "SELECT A.*, B.STATE, C.COUNTRY, D.GEO FROM GPWS.CITY A, GPWS.STATE B, GPWS.COUNTRY C, GPWS.GEO D WHERE CITYID = ?" +
				" AND A.STATEID = B.STATEID AND B.COUNTRYID = C.COUNTRYID AND C.GEOID = D.GEOID";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	private String setURL(String city){
		String protocol = "http://";
		String server = pc.setServerName();
		String uri = pc.setURI() +  pc.setServletPath() + "/building";
		String parameters = "?city="+city+"&country="+getCountryName()+"&geo="+getGeoName();
		String url = protocol + server + uri + parameters;
		return url;
	}
	
	
	@GET
	@Path("/{geo}/{country}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCountry(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @Context HttpServletRequest req) {
		setCountryName(countryValue);
		setGeoName(geoValue); 
		populateList();
		
        return createCities(cities);
    } //getCountry
	
	@GET
	@Path("/{geo}/{country}/{state}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCity(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("state") String stateValue,
    		@Context HttpServletRequest req) {
		setStateName(stateValue);
		setCountryName(countryValue);
		setGeoName(geoValue); 
		populateList();
		
        return createCities(cities);
    } //getCountry
	
	@GET
	@Path("/{geo}/{country}/{devicestatus}/{deviceavailable}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCity(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, 
    		@PathParam("devicestatus") String statusValue, @PathParam("deviceavailable") String deviceAvail, @Context HttpServletRequest req) {
		setCountryName(countryValue);
		setGeoName(geoValue);
		setStatusValue(statusValue);
		setDeviceAvailValue(deviceAvail);
		populateList();
		
        return createCities(cities);
    } //getCountry
	
	@GET
	@Path("/{geo}/{country}/{loc_status}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCityByStatus(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, 
    		@PathParam("loc_status") String locstatusValue, @Context HttpServletRequest req) {
		setCountryName(countryValue);
		setGeoName(geoValue);
		setLocStatusValue(locstatusValue);
		populateList();
		
        return createCities(cities);
    } //getCountry
	
	@GET
	@Path("/{geo}/{country}/{state}/{loc_status}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCityByStatus(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("state") String stateValue,
    		@PathParam("loc_status") String locstatusValue, @Context HttpServletRequest req) {
		setStateName(stateValue);
		setCountryName(countryValue);
		setGeoName(geoValue);
		setLocStatusValue(locstatusValue);
		populateList();
		
        return createCities(cities);
    } //getCountry
	
	@GET
	@Path("/{geo}/{country}/{state}/{devicestatus}/{deviceavailable}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCity(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @PathParam("state") String stateValue,
    		@PathParam("devicestatus") String statusValue, @PathParam("deviceavailable") String deviceAvail, @Context HttpServletRequest req) {
		setStateName(stateValue);
		setCountryName(countryValue);
		setGeoName(geoValue);
		setStatusValue(statusValue);
		setDeviceAvailValue(deviceAvail);
		populateList();
		
        return createCities(cities);
    } //getCountry
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Cities> getCity(@Context HttpServletRequest req) throws IOException {
		String countryID = tools.nullStringConverter(req.getParameter("id"));
		setGeoName(tools.nullStringConverter(req.getParameter("geo"))); 
		setCountryName(tools.nullStringConverter(req.getParameter("country")));
		setStateName(tools.nullStringConverter(req.getParameter("state")));
		//deviceAvailValue = tools.nullStringConverter(req.getParameter("deviceavailable"));
		//statusValue = tools.nullStringConverter(req.getParameter("status"));
		setStatusValue(tools.nullStringConverter(req.getParameter("dev_status")));
		setLocStatusValue(tools.nullStringConverter(req.getParameter("loc_status")));
		setDeviceAvailValue(tools.nullStringConverter(req.getParameter("deviceavailable")));
		if ((geoValue.equals("") || countryValue.equals("")) && req.getParameter("id") == null) {
			 RespBuilder.createResponse(412);
		} else if (!countryID.equals("")){
			populateListbyName(Integer.parseInt(countryID));
		} else {
			populateList();
		}
		
        return createCities(cities);
    } //getGeo
	
	@GET
	@Path("/id/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Cities> getCityByName(@DefaultValue("") @PathParam("id") String sID, @Context HttpServletRequest req) {
		if (sID.equals("")) {
			 RespBuilder.createResponse(412);
		} else {
			populateListbyName(Integer.parseInt(sID));
		}	
		return createCities(cities);
	}
	
	public JAXBElement<Cities> createCities(Cities value) {
		QName _var_QNAME = new QName(Cities.class.getSimpleName());
		return new JAXBElement<Cities>(_var_QNAME, Cities.class, value);
	}

} //CityJax
