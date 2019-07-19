/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.io.IOException;
import java.util.*;
import java.sql.*;

/****************************************************************************************
 * PrinterLog
 * 	
 * @author: Joe Comfort
 * Copyright IBM
 *
 ****************************************************************************************/
public class PrinterLog {
	
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.printer.PrinterTools");
	private int numBrowser = 0;
	private String[] browser;
	private String[] os;
	private String[][] data;
	private int[] browserSuccess;
	private int[] browserFail;
	private int[] osSuccess;
	private int[] osFail;
	
	PrinterTools tool = new PrinterTools();
	
	/*******************
	 * constructor
	 *******************/
	public PrinterLog() throws Exception {
		
		Connection con = null;
		
		try {
			con = tool.getConnection();
			setBrowser(con);
			setOS(con);
		} catch (Exception e) {
			System.out.println("Error setting browser and os.");
		} finally {
			if (con != null)
				con.close();
		}
		
	}
	
	public String[] getBrowser() { return browser; }
	
	public String[] getOS() { return os; }
	
	public String[][] getData() { return data; };
	
	public int[] getBrowserSuccess() { return browserSuccess; }
	
	public int[] getBrowserFail() { return browserFail; }
	
	public int[] getOSSuccess() { return osSuccess; }
	
	public int[] getOSFail() { return osFail; }
	   
	/**********************************************************************************************
    * setBrowser
    * 
    * This method creates a connection to the specified database and returns that connection.
    ***********************************************************************************************/
   public void setBrowser(Connection con) throws Exception {
   			
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		
	 try {
	 	
		stmt = con.prepareStatement("SELECT DISTINCT BROWSER_NAME FROM GPWS.PRINTER_LOG ORDER BY BROWSER_NAME", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	    rs = stmt.executeQuery();
	    
	    int x = 0;
	    String sBTemp = "";
		String sPrevB = "";
		// Determine the size of the array
	    while (rs.next()) {
	    	sBTemp = parseBrowserName(rs.getString("BROWSER_NAME"), 0);
			if (!sBTemp.equals(sPrevB)) {
				x++;
			}
			sPrevB = sBTemp;
	    }
	    rs.beforeFirst();
	    browser = new String[x];
	    browserSuccess = new int[x];
		browserFail = new int[x];
		for (int j = 0; j < x; j++) {
	    	browserSuccess[j] = 0;
	    	browserFail[j] = 0;
	    }
		x = 0;
		sBTemp = "";
		sPrevB = "";
	    while (rs.next()) {	    	
	    	sBTemp = parseBrowserName(rs.getString("BROWSER_NAME"), 0);
			if (!sBTemp.equals(sPrevB)) {
				browser[x] = sBTemp;
				x++;
			}
			sPrevB = sBTemp;
	    }
	    
	 } catch (Exception e) {
	 	System.out.println("PrinterLog.setBrowser ERROR: " + e);
     } finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
     }
   }
   
   /******************************************************************************************
	* parseBrowserName
	*
	*******************************************************************************************/
	private static String parseBrowserName(String browserData, int fromIndex) {
		
		String sBrowser = "";
		
		try {
			int iSpace = browserData.indexOf(' ', fromIndex);
			if (iSpace > 0) {
				if (browserData.substring(iSpace + 1, iSpace + 2).matches("[0-9]")) {
					sBrowser = browserData.substring(0,iSpace);
				} else {
					sBrowser = parseBrowserName(browserData, iSpace + 1);
				}
			} else {
				sBrowser = browserData;
			}
		} catch (Exception e) {
			System.out.println("\nError in PrinterLog.parseBrowserName ERROR: " + e);
		}
				
		return sBrowser;
	}
   
   /**********************************************************************************************
    * setOS	
    * 	
    * This method creates a connection to the specified database and returns that connection.
    ***********************************************************************************************/
   public void setOS(Connection con) throws Exception {
   			
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		
	 try {
		stmt = con.prepareStatement("SELECT DISTINCT OS_NAME FROM GPWS.PRINTER_LOG ORDER BY OS_NAME", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	    rs = stmt.executeQuery();
	    
	    int x = 0;
	    while (rs.next()) {
	    	x++;
	    }
	    rs.beforeFirst();
	    
	    os = new String[x];
	    osSuccess = new int[x];
		osFail = new int[x];
		
		for (int j = 0; j < x; j++) {
	    	osSuccess[j] = 0;
	    	osFail[j] = 0;
	    }
		
		x = 0;
	    while (rs.next()) {
	    	os[x] = nullConverter(rs.getString("OS_NAME"));
	    	x++;
	    }
	    
	 } catch (Exception e) {
	 	System.out.println("PrinterLog.setOS ERROR: " + e);
     } finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
     }
   }
	
   /**********************************************************************************************
    * getInstallData
    * 	
    * This method creates a connection to the specified database and returns that connection.
    ***********************************************************************************************/
   public void getInstallData(String[] values) throws Exception {
   			
   		Connection con = null;
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		
	 try {
		
		con = tool.getConnection();
		if (values[0].equals("device")) {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE DEVICE_NAME = ? ORDER BY DATE_TIME DESC");
			stmt.setString(1,values[1]);
		} else if (values[0].equals("geo")) {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE GEO = ? ORDER BY DATE_TIME DESC");
			stmt.setString(1,values[2]);
		} else if (values[0].equals("country")) {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE GEO = ? AND COUNTRY = ? ORDER BY DATE_TIME DESC");
			stmt.setString(1,values[2]);
			stmt.setString(2,values[3]);
		} else if (values[0].equals("site")) {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE GEO = ? AND COUNTRY = ? AND CITY = ? ORDER BY DATE_TIME DESC");
			stmt.setString(1,values[2]);
			stmt.setString(2,values[3]);
			stmt.setString(3,values[4]);
		} else if (values[0].equals("building")) {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE GEO = ? AND COUNTRY = ? AND CITY = ? AND BUILDING = ? ORDER BY DATE_TIME DESC");
			stmt.setString(1,values[2]);
			stmt.setString(2,values[3]);
			stmt.setString(3,values[4]);
			stmt.setString(4,values[5]);
		} else if (values[0].equals("floor")) {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE GEO = ? AND COUNTRY = ? AND CITY = ? AND BUILDING = ? AND FLOOR = ? ORDER BY DATE_TIME DESC");
			stmt.setString(1,values[2]);
			stmt.setString(2,values[3]);
			stmt.setString(3,values[4]);
			stmt.setString(4,values[5]);
			stmt.setString(5,values[6]);
		} else {
			stmt = con.prepareStatement("SELECT DEVICE_NAME, GEO, COUNTRY, STATE, CITY, BUILDING, FLOOR, DATE_TIME, OS_NAME, BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG ORDER BY DATE_TIME DESC");
		}
		
	    rs = stmt.executeQuery();
	    data = new String[12][1000];
	    int a = 0;
	    while (rs.next()) {
	    	if (a < 1000) {
		    	data[0][a] = nullConverter(rs.getString("DEVICE_NAME"));
		    	data[1][a] = nullConverter(rs.getString("GEO"));
		    	data[2][a] = nullConverter(rs.getString("COUNTRY"));
		    	data[3][a] = nullConverter(rs.getString("STATE"));
		    	data[4][a] = nullConverter(rs.getString("CITY"));
		    	data[5][a] = nullConverter(rs.getString("BUILDING"));
		    	data[6][a] = nullConverter(rs.getString("FLOOR"));
		    	data[7][a] = nullConverter(rs.getString("DATE_TIME"));
		    	data[8][a] = nullConverter(rs.getString("OS_NAME"));
		    	data[9][a] = nullConverter(rs.getString("BROWSER_NAME"));
		    	data[10][a] = nullConverter(rs.getString("INSTALL_RC"));
	    	}
	    	a++;
	    	if (a <= 1000) {
	    		data[11][0] = a + "";
	    	}
	    	String sBrowser = nullConverter(rs.getString("BROWSER_NAME")).toUpperCase();
	    	for (int x = 0; x < browser.length; x++) {
	    		if (sBrowser.indexOf(browser[x].toUpperCase()) >= 0) {
	    			if (rs.getInt("INSTALL_RC") == 0) {
	    				browserSuccess[x]++;
	    				break;
	    			} else {
	    				browserFail[x]++;
	    			}
		    	} 
	    	}
	    	
	    	String sOS = nullConverter(rs.getString("OS_NAME")).toUpperCase();
	    	for (int y = 0; y < os.length; y++) {
	    		if (os[y].toUpperCase().replace(':',' ').indexOf((sOS)) >= 0) {
	    			if (rs.getInt("INSTALL_RC") == 0) {
	    				osSuccess[y]++;
	    				break;
	    			} else {
	    				osFail[y]++;
	    			}
		    	} 
	    	}
	    }	    
	
	 } catch (Exception e) {
	 	System.out.println("PrinterLog.getInstallData ERROR: " + e);
     }  finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
		if (con != null)
			con.close();
     }
	 
   }
   
   /**********************************************************************************************
    * getBrowserDevice
    * 
    * 
    ***********************************************************************************************/
//   public void getBrowserDevice(String device) throws Exception {
//   			
//   		Connection con = null;
//   		PreparedStatement stmt = null;
//   		ResultSet rs = null;
//   		
//	 try {
//
//		con = tool.getConnection();
//		stmt = con.prepareStatement("SELECT BROWSER_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE DEVICE_NAME = ? ORDER BY DATE_TIME");
//		stmt.setString(1,device);
//		
//	    rs = stmt.executeQuery();
//	    
//	    while (rs.next()) {
//	    	String sBrowser = nullConverter(rs.getString("BROWSER_NAME")).toUpperCase();
//	    	for (int x = 0; x < browser.length; x++) {
//	    		if (sBrowser.indexOf(browser[x].toUpperCase()) >= 0) {
//	    			if (rs.getInt("INSTALL_RC") == 0) {
//	    				browserSuccess[x]++;
//	    				break;
//	    			} else {
//	    				browserFail[x]++;
//	    			}
//		    	} 
//	    	}
//	    }
//	
//	 } catch (Exception e) {
//	 	System.out.println("PrinterLog.getBrowserDevice ERROR: " + e);
//     }  finally {
//     	if (rs != null)
//     		rs.close();
//     	if (stmt != null)
//     		stmt.close();
//		if (con != null)
//			con.close();
//     }
//	 
//   }  
   
   /**********************************************************************************************
    * getOSDevice
    * 
    * This method creates a connection to the specified database and returns that connection.
    ***********************************************************************************************/
//   public void getOSDevice(String device) throws Exception {
//   	
//   		Connection con = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//		
//		 try {
//		
//			con = tool.getConnection();
//			stmt = con.prepareStatement("SELECT OS_NAME, INSTALL_RC FROM GPWS.PRINTER_LOG WHERE DEVICE_NAME = ? ORDER BY DATE_TIME");
//			stmt.setString(1,device);
//		    rs = stmt.executeQuery();
//		    
//		    while (rs.next()) {
//		    	String sOS = nullConverter(rs.getString("OS_NAME")).toUpperCase();
//		    	for (int x = 0; x < os.length; x++) {
//		    		if (os[x].toUpperCase().replace(':',' ').indexOf((sOS)) >= 0) {
//		    			if (rs.getInt("INSTALL_RC") == 0) {
//		    				osSuccess[x]++;
//		    				break;
//		    			} else {
//		    				osFail[x]++;
//		    			}
//			    	} 
//		    	}
//		    }
//		
//		 } catch (Exception e) {
//		 	System.out.println("PrinterLog.getOSDevice ERROR: " + e);
//		 } finally {
//	     	if (rs != null)
//	     		rs.close();
//	     	if (stmt != null)
//	     		stmt.close();
//			if (con != null)
//				con.close();
//	     }
//		 
//   }
   
   /**********************************************************************************************
    * getGeoInstalls
    * 
    * This method creates a connection to the specified database and returns that connection.
    ***********************************************************************************************/
//   public int[] getGeoInstalls() throws Exception {
//   			
//   		Connection con = null;
//   		PreparedStatement stmt = null;
//   		ResultSet rs = null;
//   		String[] geos = null;
//	 	int[] geosCount = null;
//   		
//	 try {
//
//		con = tool.getConnection();
//		stmt = con.prepareStatement("SELECT GEO FROM GPWS.PRINTER_LOG ORDER BY GEO");
//	    rs = stmt.executeQuery();
//	    
//	    int iNumGeos = getNumGeos();
//	    geos = getGeos();
//	    geosCount = new int[iNumGeos];
//	    
//	    while (rs.next()) {
//	    	String geo = nullConverter(rs.getString("GEO"));
//	    	for (int j = 0; j < iNumGeos; j++) {
//	    		if (geo.equals(geos[j])) {
//	    			geosCount[j]++;
//	    		}
//	    	}
//	    }
//	
//	 } catch (Exception e) {
//	 	System.out.println("PrinterLog.getGeoInstalls ERROR: " + e);
//     }  finally {
//     	if (rs != null)
//     		rs.close();
//     	if (stmt != null)
//     		stmt.close();
//		if (con != null)
//			con.close();
//     }
//		return geosCount;
//   }
   
   /**********************************************************************************************
    * getNumGeos
    * 
    * This method gets the number of geos in the system and returns that value.
    ***********************************************************************************************/
//   public int getNumGeos() throws Exception {
//   			
//   		Connection con = null;
//   		PreparedStatement stmt = null;
//   		ResultSet rs = null;
//   		int numGeos = 0;
//   		
//	 try {
//
//		con = tool.getConnection();
//		stmt = con.prepareStatement("SELECT count(*) as count from gpws.geo");
//	    rs = stmt.executeQuery();
//	    
//	    while (rs.next()) {
//	    	numGeos = rs.getInt("count");
//	    }
//	
//	 } catch (Exception e) {
//	 	System.out.println("PrinterLog.getNumGeos ERROR: " + e);
//     } finally {
//     	if (rs != null)
//     		rs.close();
//     	if (stmt != null)
//     		stmt.close();
//		if (con != null)
//			con.close();
//     }
//		return numGeos;
//   }
   
   /**********************************************************************************************
    * getGeos																				  
    * 																							  
    * This method gets the number of geos in the system and returns that value.
    ***********************************************************************************************/
//   public String[] getGeos() throws Exception {
//   			
//   		Connection con = null;
//   		PreparedStatement stmt = null;
//   		ResultSet rs = null;
//   		String[] geos = new String[getNumGeos()];
//   		
//	 try {
//
//		con = tool.getConnection();
//		stmt = con.prepareStatement("SELECT geo from gpws.geo order by geo");
//	    rs = stmt.executeQuery();
//	    int x = 0;
//	    while (rs.next()) {
//	    	geos[x] = nullConverter(rs.getString("geo"));
//	    	x++;
//	    }
//	
//	 } catch (Exception e) {
//	 	System.out.println("PrinterLog.getGeos ERROR: " + e);
//     } finally {
//     	if (rs != null)
//     		rs.close();
//     	if (stmt != null)
//     		stmt.close();
//		if (con != null)
//			con.close();
//     }
//		return geos;
//   }
   
   /**********************************************************************************************
    * getGeos																				  
    * 																							  
    * This method gets the number of geos in the system and returns that value.
    ***********************************************************************************************/
//   public String[] getGeoAbbrevs() throws Exception {
//   			
//   		Connection con = null;
//   		PreparedStatement stmt = null;
//   		ResultSet rs = null;
//   		String[] geos = new String[getNumGeos()];
//   		
//	 try {
//
//		con = tool.getConnection();
//		stmt = con.prepareStatement("SELECT geo_abbr from gpws.geo order by geo");
//	    rs = stmt.executeQuery();
//	    int x = 0;
//	    while (rs.next()) {
//	    	geos[x] = nullConverter(rs.getString("geo_abbr"));
//	    	x++;
//	    }
//	
//	 } catch (Exception e) {
//	 	System.out.println("PrinterLog.getGeoAbbrevs ERROR: " + e);
//     } finally {
//     	if (rs != null)
//     		rs.close();
//     	if (stmt != null)
//     		stmt.close();
//		if (con != null)
//			con.close();
//     }
//		return geos;
//   }
   
   /********************************************************************************************
	* nullConverter
	* 
	* This will convert any null value to an empty string. Strings with a value are not affected
	********************************************************************************************/
	public String nullConverter( String s )
		throws IOException {
		
			String sNewString = "";
			if(s != null) {
				sNewString = s;
			}
	
		return sNewString;
	}
   
} // main class