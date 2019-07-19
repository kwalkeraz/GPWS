package tools.print.api.modeldriver;

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

import tools.print.api.modeldriver.ModelDriverFactory;
import tools.print.api.modeldriver.ModelDrivers;
import tools.print.api.modeldriver.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/modeldriver")
public class ModelDriverJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static ModelDrivers modeldrivers = null;
	protected String modelValue = "";
	protected String modelidValue = "";
	protected String drivernameValue = "";
	protected String drivermodelValue = "";
	protected String driveridValue = "";
	
	public String getModel() {
    	return modelValue;
    }
    
    public void setModel(String value) {
    	this.modelValue = value;
    }
    
    public String getModelID() {
    	return modelidValue;
    }
    
    public void setModelID(String value) {
    	this.modelidValue = value;
    }
    
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
    
    public String getDriverID() {
    	return driveridValue;
    }
    
    public void setDriverID(String value) {
    	this.driveridValue = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		modeldrivers = factory.createModelDrivers();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "MODEL_DRIVERID");
				int modelid = pc.returnKeyValueInt(i, "MODELID");
				String model = pc.returnKeyValue(i, "MODEL");
				String drivername = pc.returnKeyValue(i, "DRIVER_NAME");
				int driverid = pc.returnKeyValueInt(i, "DRIVERID");
				String drivermodel = pc.returnKeyValue(i, "DRIVER_MODEL");
				modeldrivers.getModelDriver().add(ModelDriverFactory.ModelDriverCreateList(factory, id, model, modelid, drivermodel, drivername, driverid));
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
	    if (!modelValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE MODEL = " + "'" + modelValue + "'" + " ORDER BY MODEL";
		} else if (!modelidValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE MODELID = " + modelidValue + " ORDER BY MODEL";
		} else if (!drivernameValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE DRIVER_NAME = " + "'" + drivernameValue + "'" + " ORDER BY MODEL";
		} else if (!drivermodelValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE DRIVER_MODEL = " + "'" + drivermodelValue + "'" + " ORDER BY MODEL";
		} else if (!driveridValue.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE DRIVERID = " + driveridValue + " ORDER BY MODEL";
		} else {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW ORDER BY MODEL";
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
	    
	    String sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE MODEL_DRIVERID = ? ORDER BY MODEL";
	    
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
    public JAXBElement<ModelDrivers> getModelwParam(@Context HttpServletRequest req) throws IOException {
		if (!tools.nullStringConverter(req.getParameter("modelid")).equals("")) {
			setModelID(tools.nullStringConverter(req.getParameter("modelid")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("driverid")).equals("")) {
			setDriverID(tools.nullStringConverter(req.getParameter("driverid")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("modelname")).equals("")) {
			setModel(tools.nullStringConverter(req.getParameter("modelname")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("drivername")).equals("")) {
			setDriverName(tools.nullStringConverter(req.getParameter("drivername")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("drivermodel")).equals("")) {
			setDriverModel(tools.nullStringConverter(req.getParameter("drivermodel")));
			populateList();
		} else {
			populateList();
		}
		
        return createModelDrivers(modeldrivers);
    } 
	
	
	@GET
	@Path("/modelname/{modelname}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDrivers> getModelByName(@PathParam("modelname") String name, @Context HttpServletRequest req) {
		setModel(name); 
		populateList();
		
		return createModelDrivers(modeldrivers);
	}
	
	@GET
	@Path("/modelid/{modelid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDrivers> getModelByID(@PathParam("modelid") String sID, @Context HttpServletRequest req) {
		setModelID(sID); 
		populateList();
		
		return createModelDrivers(modeldrivers);
	}
	
	@GET
	@Path("/driverid/{driverid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDrivers> getDriverByID(@PathParam("driverid") String sID, @Context HttpServletRequest req) {
		setDriverID(sID); 
		populateList();
		
		return createModelDrivers(modeldrivers);
	}
	
	@GET
	@Path("/drivername/{drivername}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDrivers> getDriverByName(@PathParam("drivername") String name, @Context HttpServletRequest req) {
		setDriverName(name); 
		populateList();
		
		return createModelDrivers(modeldrivers);
	}
	
	@GET
	@Path("/drivermodel/{drivermodel}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDrivers> getDriverByModel(@PathParam("model") String model, @Context HttpServletRequest req) {
		setDriverModel(model); 
		populateList();
		
		return createModelDrivers(modeldrivers);
	}
	
	public JAXBElement<ModelDrivers> createModelDrivers(ModelDrivers value) {
		QName _var_QNAME = new QName(ModelDrivers.class.getSimpleName());
		return new JAXBElement<ModelDrivers>(_var_QNAME, ModelDrivers.class, value);
	}
} //ModelDriverJax
