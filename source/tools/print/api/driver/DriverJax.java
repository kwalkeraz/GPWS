package tools.print.api.driver;

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

import tools.print.api.driver.Drivers;
import tools.print.api.driver.DriverFactory;
import tools.print.api.driver.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/driver")
public class DriverJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Drivers drivers = null;
	protected String drivernameValue = "";
    protected String drivermodelValue = "";
    protected int driveridValue = 0;
	
	public String getDriverName() {
		return drivernameValue;
    }

    public void setDriverName(String value) {
        this.drivernameValue = value;
    }
    
    public String getDriverModel() {
    	return drivermodelValue;
    }
    
    public void setDriverModel(String value) {
    	this.drivermodelValue = value;
    }
    
    public int getDriverID() {
    	return driveridValue;
    }
    
    public void setDriverID(int value) {
    	this.driveridValue = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		drivers = factory.createDrivers();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "DRIVERID");
				String drivername = pc.returnKeyValue(i, "DRIVER_NAME"); 
				String drivermodel = pc.returnKeyValue(i, "DRIVER_MODEL"); 
				drivers.getDriver().add(DriverFactory.DriverCreateList(factory, id, drivername, drivermodel));
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
	    if (!drivernameValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER WHERE DRIVER_NAME = " + "'" + drivernameValue + "'" + " ORDER BY DRIVER_NAME";
		} else if (!drivermodelValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER WHERE DRIVER_MODEL = " + "'" + drivermodelValue + "'" + " ORDER BY DRIVER_MODEL";
		} else {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER ORDER BY DRIVER_MODEL";
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
	    
	    String sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER WHERE DRIVERID = ? ORDER BY DRIVER_MODEL";
	    
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
    public JAXBElement<Drivers> getDriverwParam(@Context HttpServletRequest req) throws IOException {
		if (!tools.nullStringConverter(req.getParameter("driverid")).equals("")) {
			populateListbyName(Integer.parseInt(tools.nullStringConverter(req.getParameter("driverid"))));
		} else {
			setDriverName(tools.nullStringConverter(req.getParameter("drivername")));
			setDriverModel(tools.nullStringConverter(req.getParameter("drivermodel"))); 
			populateList();
		}
        return createDrivers(drivers);
    } //getDriver
	
	
	@GET
	@Path("/drivername/{drivername}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Drivers> getDriverByName(@PathParam("drivername") String name, @Context HttpServletRequest req) {
		setDriverName(name); 
		populateList();
		
		return createDrivers(drivers);
	}
	
	@GET
	@Path("/drivermodel/{drivermodel}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Drivers> getDriverByModel(@PathParam("drivermodel") String model, @Context HttpServletRequest req) {
		setDriverModel(model); 
		populateList();
		
		return createDrivers(drivers);
	}
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
    public JAXBElement<Drivers> getDriver(@Context HttpServletRequest req) throws IOException {
		setDriverModel(tools.nullStringConverter(req.getParameter("drivername"))); 
		populateList();
		
        return createDrivers(drivers);
    } //getDriver
	
	@GET
	@Path("/driverid/{driverid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Drivers> getDriverByID(@PathParam("driverid") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createDrivers(drivers);
	}
	
	public JAXBElement<Drivers> createDrivers(Drivers value) {
		QName _var_QNAME = new QName(Drivers.class.getSimpleName());
		return new JAXBElement<Drivers>(_var_QNAME, Drivers.class, value);
	}
}
