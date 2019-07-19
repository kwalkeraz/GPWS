package tools.print.api.geo;

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

import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/geo")
public class GeoJax extends Populate{
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Geographies geographies = null;
	
	public void createList(List<Map<String, Object>> columns) {
		geographies = factory.createGeographies();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "GEOID");
				String geo = pc.returnKeyValue(i, "GEO");
				String abbr = pc.returnKeyValue(i, "GEO_ABBR");
				String email = pc.returnKeyValue(i, "EMAIL_ADDRESS");
				String ccemail = pc.returnKeyValue(i, "CCEMAIL_ADDRESS");
				String url = setURL(geo);
				geographies.getGeography().add(GeoFactory.GeoCreateList(factory, id, geo, abbr, email, ccemail, url));
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
	    
	    String sSQL = "SELECT * FROM GPWS.GEO";
	    
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
	    
	    String sSQL = "SELECT * FROM GPWS.GEO WHERE GEOID = ?";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	private String setURL(String geo){
		String protocol = "http://";
		String server = pc.setServerName();
		String uri = pc.setURI() +  pc.setServletPath() + "/country";
		String parameters = "?geo="+geo;
		String url = protocol + server + uri + parameters;
		return url;
	}
	
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Geographies> getGeo(@Context HttpServletRequest req) throws IOException {
        String geoID = "";
        if (req.getParameter("id") != null) {
        	geoID = tools.nullStringConverter(req.getParameter("id"));
			if (geoID.equals("")) {
				RespBuilder.createResponse(412);
			} else {
				populateListbyName(Integer.parseInt(geoID));
			}
		} else {
			populateList();
		}
        return createGeographies(geographies);
    } //getGeo
	
	@GET
	@Path("/id/{id}")
	//@Produces({MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON, MediaType.TEXT_XML, "text/json"})
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Geographies> getGeobyName(@PathParam("id") String sName, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sName));
		
		return createGeographies(geographies);
	}
	
	public JAXBElement<Geographies> createGeographies(Geographies value) {
		QName _var_QNAME = new QName(Geographies.class.getSimpleName());
		//return new JAXBElement<Geographies>(_var_QNAME, Geographies.class, null, value);
		return new JAXBElement<Geographies>(_var_QNAME, Geographies.class, value);
	}

}
