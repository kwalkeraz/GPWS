package tools.print.api.protocol;

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

import tools.print.api.protocol.ProtocolFactory;
import tools.print.api.protocol.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/protocol")
public class ProtocolJax extends Populate {
	//Global Variables
		PrepareConnection pc = new PrepareConnection();
		AppTools tools = new AppTools();
		final static ObjectFactory factory = new ObjectFactory();
		static Protocols protocols = null;
		protected int osprotocolid = 0;
	    protected String protocolnameValue = "";
	    protected String osnameValue = "";
	    protected String osabbrValue = "";
		
		public int getOSProtocolID() {
			return osprotocolid;
	    }

	    public void setOSProtocolID(int value) {
	        this.osprotocolid = value;
	    }
	    
	    public String getProtocolName() {
	    	return protocolnameValue;
	    }
	    
	    public void setProtocolName(String value) {
	    	this.protocolnameValue = value;
	    }
	    
	    public String getOSName() {
	    	return osnameValue;
	    }
	    
	    public void setOSName(String value) {
	    	this.osnameValue = value;
	    }
	    
	    public String getOSABBR() {
	        return osabbrValue;
	    }

	    public void setOSABBR(String value) {
	        this.osabbrValue = value;
	    }
		
		public void createList(List<Map<String, Object>> columns) {
			protocols = factory.createProtocols();
			try {
				for (Map<String, Object> i : columns)  {
					int osprotocolid = pc.returnKeyValueInt(i, "OS_PROTOCOLID");
					String name = pc.returnKeyValue(i, "PROTOCOL_NAME"); 
					String type = pc.returnKeyValue(i, "PROTOCOL_TYPE"); 
					String hostPortConfig = pc.returnKeyValue(i, "HOST_PORT_CONFIG");
					String protocolVersion = pc.returnKeyValue(i, "PROTOCOL_VERSION");
					String protocolPackage = pc.returnKeyValue(i, "PROTOCOL_PACKAGE");
					int protocolid = pc.returnKeyValueInt(i, "PROTOCOLID");
					int osid = pc.returnKeyValueInt(i, "OSID");
					String osname = pc.returnKeyValue(i, "OS_NAME");
					String osabbr = pc.returnKeyValue(i, "OS_ABBR");
					int sequenceNumber = pc.returnKeyValueInt(i, "SEQUENCE_NUMBER");
					protocols.getProtocol().add(ProtocolFactory.ProtocolCreateList(factory, name, type, hostPortConfig, protocolVersion, protocolPackage, protocolid, osid, osname, osabbr, sequenceNumber, osprotocolid));
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
		    if (!protocolnameValue.equals("") && (!osnameValue.equals(""))) {
				sSQL = "SELECT * FROM GPWS.PROTOCOL_VIEW WHERE PROTOCOL_NAME = " + "'" + protocolnameValue + "'" + " AND OS_NAME = " + "'" + osnameValue + "'" + " ORDER BY PROTOCOL_NAME";
		    } else if (!protocolnameValue.equals("") && (!osabbrValue.equals(""))) {
				sSQL = "SELECT * FROM GPWS.PROTOCOL_VIEW WHERE PROTOCOL_NAME = " + "'" + protocolnameValue + "'" + " AND OS_ABBR = " + "'" + osabbrValue + "'" + " ORDER BY PROTOCOL_NAME";
		    } else if (!protocolnameValue.equals("")) {
				sSQL = "SELECT * FROM GPWS.PROTOCOL_VIEW WHERE PROTOCOL_NAME = " + "'" + protocolnameValue + "'" + " ORDER BY PROTOCOL_NAME";
			} else {
				sSQL = "SELECT * FROM GPWS.PROTOCOL_VIEW";
			}
		    System.out.println("SQL is: " + sSQL);
		    
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
		    
		    String sSQL = "SELECT * FROM GPWS.PROTOCOL_VIEW WHERE OS_PROTOCOLID = ? ORDER BY PROTOCOL_NAME";
		    
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
		
		@GET
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	    public JAXBElement<Protocols> getProtocolwParam(@Context HttpServletRequest req) throws IOException {
			if (!tools.nullStringConverter(req.getParameter("osprotocolid")).equals("")) {
				populateListbyName(Integer.parseInt(tools.nullStringConverter(req.getParameter("osprotocolid"))));
			} else {
				setProtocolName(tools.nullStringConverter(req.getParameter("protocolname")));
				setOSName(tools.nullStringConverter(req.getParameter("osname")));
				setOSABBR(tools.nullStringConverter(req.getParameter("osabbr")));
				populateList();
			}
	        return createProtocols(protocols);
	    } //getDriver
		
		
		@GET
		@Path("/protocolname/{protocolname}")
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
		public JAXBElement<Protocols> getProtocol(@PathParam("protocolname") String name, @Context HttpServletRequest req) {
			setProtocolName(name);
			populateList();
			
			return createProtocols(protocols);
		}
		
		@GET
		@Path("/protocolname/{protocolname}/osname/{osname}")
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
		public JAXBElement<Protocols> getProtocol(@PathParam("protocolname") String name, @PathParam("osname") String osname,  @Context HttpServletRequest req) {
			setProtocolName(name);
			setOSName(osname);
			populateList();
			
			return createProtocols(protocols);
		}
		
		@GET
		@Path("/protocolname/{protocolname}/osabbr/{osabbr}")
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
		public JAXBElement<Protocols> getProtocolOSAbbr(@PathParam("protocolname") String name, @PathParam("osabbr") String osabbr,  @Context HttpServletRequest req) {
			setProtocolName(name);
			setOSABBR(osabbr);
			populateList();
			
			return createProtocols(protocols);
		}
		
		@GET
		@Path("/osprotocolid/{osprotocolid}")
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
		public JAXBElement<Protocols> getDriverByModel(@PathParam("osprotocolid") String osprotocolid, @Context HttpServletRequest req) 
				throws NumberFormatException, IOException {
			setOSProtocolID(Integer.parseInt(tools.nullStringConverter(osprotocolid))); 
			populateListbyName(Integer.parseInt(osprotocolid));
			
			return createProtocols(protocols);
		}
		
		public JAXBElement<Protocols> createProtocols(Protocols value) {
			QName _var_QNAME = new QName(Protocols.class.getSimpleName());
			return new JAXBElement<Protocols>(_var_QNAME, Protocols.class, value);
		}

}
