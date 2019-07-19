package tools.print.api.state;

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

import tools.print.api.state.States;
import tools.print.api.state.StateFactory;
import tools.print.api.state.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.rest.PrepareConnection;
import tools.print.lib.AppTools;

@XmlRegistry
@Path("/state")
public class StateJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static States states = null;
	protected String geoValue = "";
	protected String countryValue = "";
	
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
	
	public void createList(List<Map<String, Object>> columns) {
		states = factory.createStates();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "STATEID");
				String state = pc.returnKeyValue(i, "STATE");
				if (geoValue.equals("")) setGeoName(pc.returnKeyValue(i, "GEO"));
				if (countryValue.equals("")) setCountryName(pc.returnKeyValue(i, "COUNTRY"));
				String url = setURL(state);
				states.getState().add(StateFactory.StateCreateList(factory, id, state, url));
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
	    
		String sSQL = "SELECT STATE, STATEID FROM GPWS.STATE WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE COUNTRY = ? AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = ?))) ORDER BY STATE";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, countryValue);
	      hm.put(2, geoValue);
	    
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
	    
	    String sSQL = "SELECT A.*, B.COUNTRY, C.GEO FROM GPWS.STATE A, GPWS.COUNTRY B, GPWS.GEO C WHERE STATEID = ? AND A.COUNTRYID = B.COUNTRYID AND C.GEOID = B.GEOID";
	    
	    //To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    // if no parameters are needed, set the hashmap as null
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, id);
	    
	    columns = pc.prepareConnection(sSQL, hm);
		
	    return columns;
	}
	
	private String setURL(String state){
		String protocol = "http://";
		String server = pc.setServerName();
		String uri = pc.setURI() +  pc.setServletPath() + "/city";
		String parameters = "?state="+state+"&country="+getCountryName()+"&geo="+getGeoName();
		String url = protocol + server + uri + parameters;
		return url;
	}
	
	
	@GET
	@Path("/{geo}/{country}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<States> getState(@PathParam("geo") String geoValue, @PathParam("country") String countryValue, @Context HttpServletRequest req) {
		setGeoName(geoValue);
		setCountryName(countryValue); 
		populateList();
		
        return createStates(states);
    } //getCountry
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<States> getState(@Context HttpServletRequest req) throws IOException {
		String stateID = tools.nullStringConverter(req.getParameter("id"));
		setGeoName(tools.nullStringConverter(req.getParameter("geo"))); 
		setCountryName(tools.nullStringConverter(req.getParameter("country"))); 
		if ((geoValue.equals("") || countryValue.equals("")) && req.getParameter("id") == null) {
			 RespBuilder.createResponse(412);
		} else if (!stateID.equals("")){
			populateListbyName(Integer.parseInt(stateID));
		} else {
			populateList();
		}
        return createStates(states);
    } //getState
	
	@GET
	@Path("/id/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<States> getStatebyName(@PathParam("id") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createStates(states);
	}
	
	public JAXBElement<States> createStates(States value) {
		QName _var_QNAME = new QName(States.class.getSimpleName());
		return new JAXBElement<States>(_var_QNAME, States.class, value);
	}

} //StateJax
