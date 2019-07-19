package tools.print.api.model;

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

import tools.print.api.model.ModelFactory;
import tools.print.api.model.Models;
import tools.print.api.model.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/model")
public class ModelJax extends Populate {
	//Global Variables
	PrepareConnection pc = new PrepareConnection();
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Models models = null;
	protected String modelValue = "";
    protected int modelidValue = 0;
	
	public String getModel() {
    	return modelValue;
    }
    
    public void setModel(String value) {
    	this.modelValue = value;
    }
    
    public int getModelID() {
    	return modelidValue;
    }
    
    public void setModelID(int value) {
    	this.modelidValue = value;
    }
	
	public void createList(List<Map<String, Object>> columns) {
		models = factory.createModels();
		try {
			for (Map<String, Object> i : columns)  {
				int id = pc.returnKeyValueInt(i, "MODELID");
				String model = pc.returnKeyValue(i, "MODEL");
				String strategic = pc.returnKeyValue(i, "STRATEGIC");
				String confidentialprint = pc.returnKeyValue(i, "CONFIDENTIAL_PRINT");
				String color = pc.returnKeyValue(i, "COLOR");
				int numLangDisplay = pc.returnKeyValueInt(i, "NUM_LANG_DISPLAY");
				models.getModel().add(ModelFactory.ModelCreateList(factory, id, model, confidentialprint, strategic, color, numLangDisplay));
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
			sSQL = "SELECT MODELID, MODEL, STRATEGIC, CONFIDENTIAL_PRINT, COLOR, NUM_LANG_DISPLAY FROM GPWS.MODEL WHERE MODEL = " + "'" + modelValue + "'" + " ORDER BY MODEL";
		} else { 
			sSQL = "SELECT MODELID, MODEL, STRATEGIC, CONFIDENTIAL_PRINT, COLOR, NUM_LANG_DISPLAY FROM GPWS.MODEL ORDER BY MODEL";
		} //Model queries
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
	    
	    String sSQL = "SELECT MODELID, MODEL, STRATEGIC, CONFIDENTIAL_PRINT, COLOR, NUM_LANG_DISPLAY FROM GPWS.MODEL WHERE MODELID = ? ORDER BY MODEL"; 
	    
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
    public JAXBElement<Models> getModelwParam(@Context HttpServletRequest req) throws IOException {
		if (!tools.nullStringConverter(req.getParameter("modelid")).equals("")) {
			populateListbyName(Integer.parseInt(tools.nullStringConverter(req.getParameter("modelid"))));
		} else {
			setModel(tools.nullStringConverter(req.getParameter("modelname")));
			populateList();
		}
		
        return createModels(models);
    } 
	
	
	@GET
	@Path("/modelname/{modelname}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Models> getModelByName(@PathParam("modelname") String name, @Context HttpServletRequest req) {
		setModel(name); 
		populateList();
		
		return createModels(models);
	}
	
	@GET
	@Path("/modelid/{modelid}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Models> getModelByID(@PathParam("modelid") String sID, @Context HttpServletRequest req) {
		populateListbyName(Integer.parseInt(sID));
		
		return createModels(models);
	}
	
	public JAXBElement<Models> createModels(Models value) {
		QName _var_QNAME = new QName(Models.class.getSimpleName());
		return new JAXBElement<Models>(_var_QNAME, Models.class, value);
	}
} //ModelJax
