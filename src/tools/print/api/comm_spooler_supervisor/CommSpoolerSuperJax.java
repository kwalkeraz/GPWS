package tools.print.api.comm_spooler_supervisor;

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

import tools.print.api.comm_spooler_supervisor.CommSpoolerSuperFactory;
import tools.print.api.comm_spooler_supervisor.CommSpoolerSupervisors;
import tools.print.api.comm_spooler_supervisor.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/commspoolersuper")
public class CommSpoolerSuperJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static CommSpoolerSupervisors commspoolersupervisors = null;
	protected int serveridValue = 0;
	
    public int getServerID() {
    	return serveridValue;
    }
    
    public void setServerID(int value) {
    	this.serveridValue = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		commspoolersupervisors = factory.createCommSpoolerSupervisors();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "COMM_SPOOL_SUPERID");
				String process = "";
				String serverName = pc.returnKeyValue(i, "SERVER_NAME");
				String comm = pc.returnKeyValue(i, "COMM");
				String spooler = pc.returnKeyValue(i, "SPOOLER");
				String supervisor = pc.returnKeyValue(i, "SUPERVISOR");
				process = comm + ":" + spooler + ":" + supervisor;
				commspoolersupervisors.getCommSpoolerSupervisor().add(CommSpoolerSuperFactory.CityCreateList(factory, id, serverName, process));
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
	    sSQL = "SELECT * FROM GPWS.COMM_SPOOLER_SUPERVISOR_VIEW";
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
	    
	    String sSQL = "SELECT * FROM GPWS.COMM_SPOOLER_SUPERVISOR_VIEW WHERE SERVERID = ?";
	    
	    //System.out.println("SQL is: " +sSQL);
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
    public JAXBElement<CommSpoolerSupervisors> getCommSpoolerSuper(@Context HttpServletRequest req) throws IOException {
		String serverid = "";
        if (req.getParameter("serverid") != null) {
        	serverid = tools.nullStringConverter(req.getParameter("serverid"));
			if (serverid.equals("")) {
				RespBuilder.createResponse(412);
			} else {
				populateListbyName(Integer.parseInt(serverid));
			}
		} else {
			populateList();
		}
		
        return createCommSpoolerSuper(commspoolersupervisors);
    } 
	
	@GET
	@Path("/serverid/{id}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<CommSpoolerSupervisors> getCommSpoolerSuperByID(@PathParam("id") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createCommSpoolerSuper(commspoolersupervisors);
	}
	
	public JAXBElement<CommSpoolerSupervisors> createCommSpoolerSuper(CommSpoolerSupervisors value) {
		QName _var_QNAME = new QName(CommSpoolerSupervisors.class.getSimpleName());
		return new JAXBElement<CommSpoolerSupervisors>(_var_QNAME, CommSpoolerSupervisors.class, value);
	}
}
