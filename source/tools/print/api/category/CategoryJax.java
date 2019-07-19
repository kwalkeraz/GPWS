package tools.print.api.category;

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

import tools.print.api.category.Categories;
import tools.print.api.category.CategoryFactory;
import tools.print.api.category.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.Populate;
import tools.print.lib.AppTools;
import tools.print.rest.PrepareConnection;

@XmlRegistry
@Path("/category")
public class CategoryJax extends Populate {
	//Global Variables
		PrepareConnection pc = new PrepareConnection();
		AppTools tools = new AppTools();
		final static ObjectFactory factory = new ObjectFactory();
		static Categories categories = null;
		protected String name = "";
		protected int categoryid = 0;
		
		public String getCategoryName() {
			return name;
	    }

	    public void setCategoryName(String value) {
	        this.name = value;
	    }
		
	    public int getCategoryID() {
	    	return categoryid;
	    }
	    
	    public void setCategoryID(int value) {
	    	this.categoryid = value;
	    }
	    
		public void createList(List<Map<String, Object>> columns) {
			categories = factory.createCategories();
			try {
				for (Map<String, Object> i : columns)  {
					if (name.equals("")) setCategoryName(pc.returnKeyValue(i, "CATEGORY_NAME"));
					if (categoryid == 0) setCategoryID(pc.returnKeyValueInt(i, "CATEGORYID"));
					String description = pc.returnKeyValue(i, "DESCRIPTION");
					String code = pc.returnKeyValue(i, "CATEGORY_CODE");
					String value1 = pc.returnKeyValue(i, "CATEGORY_VALUE1");
					String value2 = pc.returnKeyValue(i, "CATEGORY_VALUE2");
					int infoId = pc.returnKeyValueInt(i, "CATEGORY_INFOID");
					categories.getCategory().add(CategoryFactory.CategoryCreateList(factory, categoryid, name, description, code, value1, value2, infoId));
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
		    
			String sSQL = "";
			if (name.equals("")) {
				sSQL = "SELECT A.*, B.* FROM GPWS.CATEGORY A, GPWS.CATEGORY_INFO B WHERE A.CATEGORYID = B.CATEGORYID ORDER BY B.CATEGORY_CODE";
			} else { 
				sSQL = "SELECT A.*, B.* FROM GPWS.CATEGORY A, GPWS.CATEGORY_INFO B WHERE A.CATEGORYID = B.CATEGORYID AND A.CATEGORY_NAME = '" + name + "' ORDER BY B.CATEGORY_CODE";
			}
		    
			//System.out.println("SQL is: " + sSQL);
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
		    
		    String sSQL = "SELECT A.*, B.* FROM GPWS.CATEGORY A, GPWS.CATEGORY_INFO B WHERE A.CATEGORYID = B.CATEGORYID AND A.CATEGORYID = ? ORDER BY B.CATEGORY_CODE";
		    
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
	    public JAXBElement<Categories> getCategorywParam(@Context HttpServletRequest req) throws IOException {
			if (!tools.nullStringConverter(req.getParameter("categoryid")).equals("")) {
				populateListbyName(Integer.parseInt(tools.nullStringConverter(req.getParameter("categoryid"))));
			} else {
				setCategoryName(tools.nullStringConverter(req.getParameter("category_name")));
				populateList();
			}
			
			return createCategories(categories);
	    } 
		
		
		@GET
		@Path("/name/{name}")
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
		public JAXBElement<Categories> getCategoryByName(@PathParam("name") String name, @Context HttpServletRequest req) {
			setCategoryName(name); 
			populateList();
			
			return createCategories(categories);
		}
		
		@GET
		@Path("/id/{id}")
		@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
		public JAXBElement<Categories> getCategoryByID(@PathParam("id") String sID, @Context HttpServletRequest req) {
			populateListbyName(Integer.parseInt(sID));
			
			return createCategories(categories);
		}
		
		public JAXBElement<Categories> createCategories(Categories value) {
			QName _var_QNAME = new QName(Categories.class.getSimpleName());
			return new JAXBElement<Categories>(_var_QNAME, Categories.class, value);
		}

} //CategoryJax
