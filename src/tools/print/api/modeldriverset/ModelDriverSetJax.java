package tools.print.api.modeldriverset;

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

import tools.print.api.modeldriverset.ModelDriverSetFactory;
import tools.print.api.modeldriverset.ModelDriverSets;
import tools.print.api.modeldriverset.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/modeldriverset")
public class ModelDriverSetJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static ModelDriverSets modeldriverset = null;
	protected String modelValue = "";
	protected String modelidValue = "";
	protected String modeldriversetidValue = "";
	protected String driversetnameValue = "";
	protected String driversetidValue = "";
	
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
    
    public String getDriverSetName() {
		return driversetnameValue;
    }

    public void setDriverSetName(String value) {
        this.driversetnameValue = value;
    }
    
    public String getDriverSetID() {
    	return driversetidValue;
    }
    
    public void setDriverSetID(String value) {
    	this.driversetidValue = value;
    }
    
    public String getModelDriverSetID() {
    	return modeldriversetidValue;
    }
    
    public void setModelDriverSetID(String value) {
    	this.modeldriversetidValue = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		modeldriverset = factory.createModelDriverSets();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "MODEL_DRIVER_SETID");
				int modelid = pc.returnKeyValueInt(i, "MODELID");
				String model = pc.returnKeyValue(i, "MODEL");
				String driversetname = pc.returnKeyValue(i, "DRIVER_SET_NAME");
				int driversetid = pc.returnKeyValueInt(i, "DRIVER_SETID");
				modeldriverset.getModelDriverSet().add(ModelDriverSetFactory.ModelDriverCreateList(factory, id, model, modelid, driversetname, driversetid));
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
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE MODEL = '" + modelValue + "' ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!modelidValue.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE MODELID = " + modelidValue + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!driversetidValue.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE DRIVER_SETID = " + driversetidValue + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!modeldriversetidValue.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE MODEL_DRIVER_SETID = " + modeldriversetidValue + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!driversetnameValue.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE DRIVER_SET_NAME = '" + driversetnameValue + "' ORDER BY MODEL, DRIVER_SET_NAME";
		} else {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW ORDER BY MODEL, DRIVER_SET_NAME";
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
	    
	    String sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE DRIVER_SET_NAME = ? ORDER BY MODEL, DRIVER_SET_NAME";
	    
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
    public JAXBElement<ModelDriverSets> getModelwParam(@Context HttpServletRequest req) throws IOException {
		if (!tools.nullStringConverter(req.getParameter("modelid")).equals("")) {
			setModelID(tools.nullStringConverter(req.getParameter("modelid")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("driversetid")).equals("")) {
			setDriverSetID(tools.nullStringConverter(req.getParameter("driversetid")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("modelname")).equals("")) {
			setModel(tools.nullStringConverter(req.getParameter("modelname")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("driversetname")).equals("")) {
			setDriverSetName(tools.nullStringConverter(req.getParameter("driversetname")));
			populateList();
		} else if (!tools.nullStringConverter(req.getParameter("modeldriversetid")).equals("")) {
			setModelDriverSetID(tools.nullStringConverter(req.getParameter("modeldriversetid")));
			populateList();
		} else {
			populateList();
		}
		
        return createModelDriverSets(modeldriverset);
    } 
	
	
	@GET
	@Path("/modelname/{modelname}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDriverSets> getModelByName(@PathParam("modelname") String name, @Context HttpServletRequest req) {
		setModel(name); 
		populateList();
		
		return createModelDriverSets(modeldriverset);
	}
	
	@GET
	@Path("/modelid/{modelid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDriverSets> getModelByID(@PathParam("modelid") String sID, @Context HttpServletRequest req) {
		setModelID(sID); 
		populateList();
		
		return createModelDriverSets(modeldriverset);
	}
	
	@GET
	@Path("/driversetid/{driversetid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDriverSets> getDriverByID(@PathParam("driversetid") String sID, @Context HttpServletRequest req) {
		setDriverSetID(sID); 
		populateList();
		
		return createModelDriverSets(modeldriverset);
	}
	
	@GET
	@Path("/driversetname/{driversetname}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDriverSets> getDriverSetName(@PathParam("driversetname") String name, @Context HttpServletRequest req) {
		setDriverSetName(name); 
		populateList();
		
		return createModelDriverSets(modeldriverset);
	}
	
	@GET
	@Path("/modeldriversetid/{modeldriversetid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<ModelDriverSets> getModelDriverSetByID(@PathParam("modeldriversetid") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createModelDriverSets(modeldriverset);
	}
	
	public JAXBElement<ModelDriverSets> createModelDriverSets(ModelDriverSets value) {
		QName _var_QNAME = new QName(ModelDriverSets.class.getSimpleName());
		return new JAXBElement<ModelDriverSets>(_var_QNAME, ModelDriverSets.class, value);
	}
} //ModelDriverSetJax
