package tools.print.api.administrator;

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
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

import tools.print.api.administrator.Administrators;
import tools.print.api.administrator.AdministratorFactory;
import tools.print.api.administrator.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/administrator")
public class AdministratorJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Administrators admins = null;
	protected String loginidValue = "";
    protected String useridValue = "";
    protected String typeValue = "";
    boolean bSession = false;
	
	public String getLoginValue() {
    	return loginidValue;
    }
    
    public void setLoginValue(String value) {
    	this.loginidValue = value;
    }
    
    public String getUserIDValue() {
    	return useridValue;
    }
    
    public void setUserIDValue(String value) {
    	this.useridValue = value;
    }
    
    public void setTypeValue(String value) {
    	this.typeValue = value;
    }
    
    public String getTypeValue() {
    	return typeValue;
    }
    
	
	public void createList(List<Map<String, Object>> columns) {
		admins = factory.createAdministrators();
		List<Map<String, Object>> groupArray;
		
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "USERID");
				int authtypeid = id;
				String firstname = pc.returnKeyValue(i, "FIRST_NAME");
				String lastname = pc.returnKeyValue(i, "LAST_NAME");
				String emailaddress = pc.returnKeyValue(i, "EMAIL");
				String loginid = pc.returnKeyValue(i, "LOGINID");
				String pager = pc.returnKeyValue(i, "PAGER");
				String fullname = lastname + ", " + firstname;
				String agArray = "";
				groupArray = prepareConnection2(id);
				for (Map<String, Object> x : groupArray) {
					agArray = agArray + ", " + pc.returnKeyValue(x, "AUTH_GROUP");
				}
				agArray = agArray.replaceFirst(", ", "");
				admins.getAdministrator().add(AdministratorFactory.AdministratorCreateList(factory, id, firstname, lastname, 
						fullname, emailaddress, loginid, pager, typeValue, authtypeid, agArray));
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
		if (!useridValue.equals("")) {
			sSQL = "SELECT * FROM GPWS.USER WHERE USERID = " + useridValue; 
		} else if (!loginidValue.equals("")) {
			sSQL = "SELECT * FROM GPWS.USER WHERE LOGINID = '" + loginidValue + "'";
		} else if (!typeValue.equals("")) {
			if (typeValue.toUpperCase().equals("GPWS")) {
				sSQL = "SELECT * FROM GPWS.USER_VIEW WHERE AUTH_GROUP = 'GPWS' ORDER BY LAST_NAME";
			} else if (typeValue.toUpperCase().equals("KEYOP")) {
				sSQL = "SELECT * FROM GPWS.USER_VIEW WHERE AUTH_GROUP = 'Keyop' ORDER BY LAST_NAME";
			} else if (typeValue.toUpperCase().equals("COMMONPROCESS")) {
				sSQL = "SELECT * FROM GPWS.USER_VIEW WHERE AUTH_GROUP = 'CommonProcess' ORDER BY LAST_NAME";
			} else {
				sSQL = "SELECT * FROM GPWS.USER ORDER BY LAST_NAME";
			}
		} else {
			sSQL = "SELECT * FROM GPWS.USER ORDER BY LAST_NAME";
		} //is sUserID
		
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
	public List<Map<String, Object>> prepareConnection2(int userid) {
		List<Map<String, Object>> columns = new ArrayList<Map<String, Object>>();	
		String sSQL = "SELECT AUTH_NAME, AUTH_GROUP, DESCRIPTION FROM GPWS.USER_VIEW WHERE USERID = ?"; 
		
		//To initialize the parameters, pass them as a hashmap
	    // (<hashmap index - integer>, <value to search for>)
	    @SuppressWarnings("rawtypes")
		HashMap hm = new HashMap();
	      hm.put(1, userid);
	    
	    columns = pc.prepareConnection(sSQL, hm);
	    
	    return columns;
	}
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Administrators> getDevicewParam(@DefaultValue("") @PathParam("userid") String name, @Context HttpServletRequest req) throws WebApplicationException, IOException {
		bSession = Boolean.valueOf(req.isRequestedSessionIdValid());
		if (bSession) {
			setLoginValue(tools.nullStringConverter(req.getParameter("loginid")));
			setUserIDValue(tools.nullStringConverter(req.getParameter("userid")));
			setTypeValue(tools.nullStringConverter(req.getParameter("type")));
			if (!loginidValue.equals("") || !useridValue.equals("") || !typeValue.equals("")) {
				populateList();
			} else {
				RespBuilder.createResponse(412);
			}
		} else {
			RespBuilder.createResponse(401);
		}
		
        return createAdmins(admins);
    } 
	
	
	@GET
	@Path("/login/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Administrators> getAdminByLogin(@PathParam("name") String name, @Context HttpServletRequest req) {
		bSession = Boolean.valueOf(req.isRequestedSessionIdValid());
		if (bSession) {
			setLoginValue(name);
			if (!loginidValue.equals("")) {
				populateList();
			} else {
				RespBuilder.createResponse(412);
			}
		} else {
			RespBuilder.createResponse(401);
		}
		
		return createAdmins(admins);
	}
	
	
	@GET
	@Path("/userid/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Administrators> getAdminByUserID(@PathParam("name") String name, @Context HttpServletRequest req) {
		
		bSession = Boolean.valueOf(req.isRequestedSessionIdValid());
		if (bSession) {
			setUserIDValue(name);
			if (!useridValue.equals("")) {
				populateList();
			} else {
				RespBuilder.createResponse(412);
			}
		} else {
			RespBuilder.createResponse(401);
		}
		
		return createAdmins(admins);
	}
	
	@GET
	@Path("/type/{name}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Administrators> getAdminByType(@PathParam("name") String name, @Context HttpServletRequest req) {
		bSession = Boolean.valueOf(req.isRequestedSessionIdValid());
		if (bSession) {
			setTypeValue(name);
			if (!typeValue.equals("")) {
				populateList();
			} else {
				RespBuilder.createResponse(412);
			}
		} else {
			RespBuilder.createResponse(401);
		}
		return createAdmins(admins);
		
	}
	
	public JAXBElement<Administrators> createAdmins(Administrators value) {
		QName _var_QNAME = new QName(Administrators.class.getSimpleName());
		return new JAXBElement<Administrators>(_var_QNAME, Administrators.class, value);
	}
} //AdministratorJax