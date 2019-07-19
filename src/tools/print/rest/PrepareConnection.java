package tools.print.rest;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;

import tools.print.lib.AppTools;

public class PrepareConnection {
	OutputStream outStream;
	
	/**
	 * Takes an SQL string and parameters as hashmap, runs an SQL query and returns the resultset into a List format
	 * @param sSQL - SQL to query
	 * @param hm - Parameters to initialize the SQL
	 * @return - SQL results in List format
	 * @throws IOException 
	 * @throws ServletException 
	 */
	public List<Map<String, Object>> prepareConnection(String sSQL, HashMap hm) {
		Connection con = null;
		PreparedStatement psQuery = null;
		ResultSet rsQuery = null;
		AppTools tool = new AppTools();
		ResultSetMetaData metaData = null;
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
	    try {
			con = tool.getConnection();
			//System.out.println("Query: " + sSQL);
			psQuery = con.prepareStatement(sSQL);
		    if (hm != null) {
		    	Set set = hm.entrySet();
			    Iterator i = set.iterator();
			    int counter = 1;
			    while(i.hasNext()) {
			    	Map.Entry me = (Map.Entry)i.next();
			        //System.out.print(me.getKey() + ": ");
			        //System.out.println(me.getValue());
			        if (me.getValue() instanceof String) {
			        	psQuery.setString(counter, me.getValue().toString());
			        }
			        if (me.getValue() instanceof Integer) {
			        	psQuery.setInt(counter, (Integer) me.getValue());
			        }
			        if (me.getValue() instanceof Timestamp) {
			        	psQuery.setTimestamp(counter, (Timestamp) me.getValue());
			        }
			        counter++;
			    } //while
		    } //if not null
			
			rsQuery = psQuery.executeQuery();
			metaData = rsQuery.getMetaData();
			Integer columnCount = metaData.getColumnCount();
		    Map<String, Object> row = null;

		    while (rsQuery.next()) {
		        row = new HashMap<String, Object>();
		        for (int x = 1; x <= columnCount; x++) {
		        	//row.put(metaData.getColumnName(x), rsQuery.getObject(x));
		        	//Need to user getColumnLabel instead of getColumnName because it may use an alias
		        	row.put(metaData.getColumnLabel(x), rsQuery.getObject(x));
		        	
		        }
		        resultList.add(row);
		    }
			
			
	    } catch (Exception e) {
			System.out.println("Error in getting data ERROR1: " + e);
		} finally {
			try {
				psQuery.close();
				rsQuery.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println(e);
			}
		}
	    return resultList;
	}
	/**
	 * Takes the value of a map and returns a key value
	 * @param columns - Map format
	 * @param key - Key to search for
	 * @return - The value of the key
	 */
	public String returnKeyValue(Map<String, Object> columns, String key){
		String keyValue = "";
		if (columns.get(key) != null) {
			keyValue = columns.get(key.toUpperCase()).toString();
		} 
	    return keyValue;
	}
	
	/**
	 * Takes the value of a map and returns a key value in Integer format
	 * @param columns - Map format
	 * @param key - Key to search for
	 * @return - The value of the key
	 */
	public Integer returnKeyValueInt(Map<String, Object> columns, String key){
		int keyValue = 0;
		try {
			if (columns.get(key) != null) {
				keyValue = Integer.parseInt(columns.get(key.toUpperCase()).toString());
			} 
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		
		return keyValue;
	}
	
	/**
	 * Takes the value of a map and returns a key value in TimeStamp format
	 * @param columns - Map format
	 * @param key - Key to search for
	 * @return - The value of the key
	 */
	public Timestamp returnKeyValueTS(Map<String, Object> columns, String key){
		Timestamp keyValue = null;
		try {
			if (columns.get(key) != null) {
				keyValue = Timestamp.valueOf(columns.get(key.toUpperCase()).toString());
			} 
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
		
		return keyValue;
	}
	
	java.util.ResourceBundle myResources = java.util.ResourceBundle.getBundle("tools.print.lib.AppTools");
	/**
	 * Set the name of the server, could be an alias
	 * @return server name value
	 */
	public String setServerName(){
		return myResources.getString("serverName");
	}
	
	/**
	 * Set the URI path of the app
	 * @return URI value
	 */
	public String setURI() {
		return "/tools/print";
	}
	
	/**
	 * Set the servlet path of the app
	 * @return servlet path value
	 */
	public String setServletPath() {
		return "/servlet/api.wss";
	}

}
