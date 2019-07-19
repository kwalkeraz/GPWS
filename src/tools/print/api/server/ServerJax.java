package tools.print.api.server;

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

import tools.print.api.server.ServerFactory;
import tools.print.api.server.Servers;
import tools.print.api.server.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/server")
public class ServerJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Servers servers = null;
	protected String serveridValue = "";
    protected String sdcValue = "";
    protected String servernameValue = "";
    protected String customerValue = "";
	
	public String getServerName() {
    	return servernameValue;
    }
    
    public void setServerName(String value) {
    	this.servernameValue = value;
    }
    
    public String getServerID() {
    	return serveridValue;
    }
    
    public void setServerID(String value) {
    	this.serveridValue = value;
    }
    
    public String getSDC() {
    	return sdcValue;
    }

	public void setSDC(String value) {
    	this.sdcValue = value;
    }
	
	private final String getCustomerValue() {
		return customerValue;
	}

	private final void setCustomerValue(String customerValue) {
		this.customerValue = customerValue;
	}
	
	public void createList(List<Map<String, Object>> columns) {
		servers = factory.createServers();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "SERVERID");
				String server = pc.returnKeyValue(i, "SERVER_NAME");
				String sdc = pc.returnKeyValue(i, "SDC");
				String customer = pc.returnKeyValue(i, "CUSTOMER");
				String contactEmail = pc.returnKeyValue(i, "CONTACT_EMAIL");
				String vpsxServer = pc.returnKeyValue(i, "VPSX_SERVER_NAME");
				servers.getServer().add(ServerFactory.ServerCreateList(factory, id, server, sdc, customer, contactEmail, vpsxServer));
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
	    if (!getSDC().equals("")) {
			//sSQL = "SELECT * FROM GPWS.SERVER WHERE UPPER(SDC) = '" + sdcValue.toUpperCase() + "' ORDER BY SERVER_NAME"; 
	    	sSQL = "SELECT A.SERVERID, A.SERVER_NAME, A.SDC, A.CUSTOMER, A.CONTACT_EMAIL, B.VPSX_SERVER_NAME FROM GPWS.SERVER A FULL OUTER JOIN GPWS.VPSX_EQUITRAC_VIEW B" +
	    			" ON A.SERVERID = B.EQUITRAC_SERVERID WHERE UPPER(SDC) = '" + getSDC().toUpperCase() + "' ORDER BY A.SERVER_NAME";
		} else if (!getServerName().equals("")) {
			//sSQL = "SELECT * FROM GPWS.SERVER WHERE UPPER(SERVER_NAME) = '" + servernameValue.toUpperCase() + "' ORDER BY SERVER_NAME";
			sSQL = "SELECT A.SERVERID, A.SERVER_NAME, A.SDC, A.CUSTOMER, A.CONTACT_EMAIL, B.VPSX_SERVER_NAME FROM GPWS.SERVER A FULL OUTER JOIN GPWS.VPSX_EQUITRAC_VIEW B" +
	    			" ON A.SERVERID = B.EQUITRAC_SERVERID WHERE UPPER(SERVER_NAME) = '" + getServerName().toUpperCase() + "' ORDER BY A.SERVER_NAME";
		} else if (!getCustomerValue().equals("")) {
			sSQL = "SELECT A.SERVERID, A.SERVER_NAME, A.SDC, A.CUSTOMER, A.CONTACT_EMAIL, B.VPSX_SERVER_NAME FROM GPWS.SERVER A FULL OUTER JOIN GPWS.VPSX_EQUITRAC_VIEW B" +
	    			" ON A.SERVERID = B.EQUITRAC_SERVERID WHERE UPPER(CUSTOMER) = '" + getCustomerValue().toUpperCase() + "' ORDER BY A.SERVER_NAME";
		} else { 
			//sSQL = "SELECT * FROM GPWS.SERVER ORDER BY SERVER_NAME";
			sSQL = "SELECT A.SERVERID, A.SERVER_NAME, A.SDC, A.CUSTOMER, A.CONTACT_EMAIL, B.VPSX_SERVER_NAME FROM GPWS.SERVER A FULL OUTER JOIN GPWS.VPSX_EQUITRAC_VIEW B" +
	    			" ON A.SERVERID = B.EQUITRAC_SERVERID ORDER BY A.SERVER_NAME";
		}
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
	    
	    //String sSQL = "SELECT * FROM GPWS.SERVER WHERE SERVERID = ? ORDER BY SERVER_NAME"; 
		String sSQL = "SELECT A.SERVERID, A.SERVER_NAME, A.SDC, A.CUSTOMER, A.CONTACT_EMAIL, B.VPSX_SERVER_NAME FROM GPWS.SERVER A FULL OUTER JOIN GPWS.VPSX_EQUITRAC_VIEW B" +
    			" ON A.SERVERID = B.EQUITRAC_SERVERID WHERE SERVERID = ? ORDER BY A.SERVER_NAME";
	    
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
    public JAXBElement<Servers> getModelwParam(@Context HttpServletRequest req) throws IOException {
		if (!tools.nullStringConverter(req.getParameter("serverid")).equals("")) {
			populateListbyName(Integer.parseInt(tools.nullStringConverter(req.getParameter("serverid"))));
		} else { 
			setSDC(tools.nullStringConverter(req.getParameter("sdc")));
			setServerName(tools.nullStringConverter(req.getParameter("servername")));
			setCustomerValue(tools.nullStringConverter(req.getParameter("customer")));
			populateList();
		}
		
        return createServers(servers);
    } 
	
	
	@GET
	@Path("/servername/{servername}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Servers> getServerByName(@PathParam("servername") String name, @Context HttpServletRequest req) {
		setServerName(name); 
		populateList();
		
		return createServers(servers);
	}
	
	@GET
	@Path("/sdc/{sdcname}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Servers> getServerBySDC(@PathParam("sdcname") String name, @Context HttpServletRequest req) {
		setSDC(name); 
		populateList();
		
		return createServers(servers);
	}
	
	@GET
	@Path("/customer/{customer}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Servers> getServerByCustomer(@PathParam("customer") String customer, @Context HttpServletRequest req) {
		setCustomerValue(customer); 
		populateList();
		
		return createServers(servers);
	}
	
	@GET
	@Path("/serverid/{serverid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Servers> getModelByID(@PathParam("serverid") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createServers(servers);
	}
	
	public JAXBElement<Servers> createServers(Servers value) {
		QName _var_QNAME = new QName(Servers.class.getSimpleName());
		return new JAXBElement<Servers>(_var_QNAME, Servers.class, value);
	}
} //ServerJax
