package tools.print.api.country;

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

import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/country")
public class CountryJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Countries countries = null;
	protected String geoValue = "";
	protected String countryidValue = "";
	
	public String getGeoName() {
        return geoValue;
    }

    public void setGeoName(String value) {
        this.geoValue = value;
    }
    public String getCountryIDName() {
        return countryidValue;
    }

    public void setCountryIDName(String value) {
        this.countryidValue = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		countries = factory.createCountries();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "COUNTRYID");
				String country = pc.returnKeyValue(i, "COUNTRY");
				String abbr = pc.returnKeyValue(i, "COUNTRY_ABBR");
				if (geoValue.equals("")) setGeoName(pc.returnKeyValue(i, "GEO"));
				String url = setURL(country);
				countries.getCountry().add(CountryFactory.CountryCreateList(factory, id, country, abbr, url));
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
	    
	    String sSQL = "SELECT * FROM GPWS.COUNTRY WHERE GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = ?) ORDER BY COUNTRY";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    //System.out.println("SQL is " + sSQL);
	    
	    @SuppressWarnings("rawtypes")
	    HashMap hm = new HashMap();
	      hm.put(1, getGeoName());
	    
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
	    
	    String sSQL = "SELECT A.*, B.GEO FROM GPWS.COUNTRY A, GPWS.GEO B WHERE COUNTRYID = ? AND A.GEOID = B.GEOID";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    //System.out.println("SQL is " + sSQL);
	    
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	private String setURL(String country){
		String protocol = "http://";
		String server = pc.setServerName();
		String uri = pc.setURI() +  pc.setServletPath() + "/city";
		String parameters = "?country="+country+"&geo="+getGeoName();
		String url = protocol + server + uri + parameters;
		return url;
	}
	
	
	@GET
	@Path("/{geo}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Countries> getCountry(@PathParam("geo") String name, @Context HttpServletRequest req) {		
		setGeoName(name);
		//System.out.println("name is " + geoValue);
		if (geoValue.equals("") || geoValue == null || name.equals("id")) {
			RespBuilder.createResponse(412);
		} else {
			populateList();
		}
		 return createCountries(countries);
    } //getCountry
	
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Countries> getCountry(@Context HttpServletRequest req) throws IOException {
		setGeoName(tools.nullStringConverter(req.getParameter("geo")));
		setCountryIDName(tools.nullStringConverter(req.getParameter("id")));
		if (geoValue.equals("") && countryidValue.equals("")) {
			 RespBuilder.createResponse(412);
		} else if (!geoValue.equals("")){
			populateList();
		} else {
			populateListbyName(Integer.parseInt(countryidValue));
		}
		return createCountries(countries);
    } //getCountry
	
	@GET
	@Path("/id/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Countries> getCountrybyName(@DefaultValue("") @PathParam("id") String sID, @Context HttpServletRequest req) throws NumberFormatException, IOException {
		setCountryIDName(sID);
		if (countryidValue.equals("")) {
			 RespBuilder.createResponse(412);
		} else {
			populateListbyName(Integer.parseInt(countryidValue));
		}
		
		return createCountries(countries);
	}
	
	public JAXBElement<Countries> createCountries(Countries value) {
		QName _var_QNAME = new QName(Countries.class.getSimpleName());
		return new JAXBElement<Countries>(_var_QNAME, Countries.class, value);
	}

} //CountryJax
