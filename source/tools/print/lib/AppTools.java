/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.lib;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import tools.print.printer.PrinterTools;


/****************************************************************************************
 * AppTools																			*
 * 																						*
 * @author: Joe Comfort																	*
 * Copyright IBM																		*
 * 																						*
 * This class contains many useful methods that are used often throughout all of the	*
 * other servlets.  It's a means of writing code once and creating an instance of this	*
 * class whenever use of one of these common methods is needed.							*
 ****************************************************************************************/
public class AppTools {
	
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.lib.AppTools");
	   
   /**********************************************************************************************
    * getConnection																				  *
    * 																							  *
    * This method creates a connection to the specified database and returns that connection.     *
    ***********************************************************************************************/
   public Connection getConnection()
   		throws ServletException, IOException {
   			
   		Connection con = null;
		// Reads database values in property file
		String sDSJNDIname = myResources.getString("DSJNDIname");
   		
	 try {
		InitialContext ic = new InitialContext();
     	javax.sql.DataSource ds = (javax.sql.DataSource)ic.lookup(sDSJNDIname);
    	con = ds.getConnection();
    	con.setAutoCommit (true);
	 } catch (Exception e) {
	 	System.out.println("Error in AppTools method: getConnection ERROR: " + e);
     }
		return con;
   }
   
   /**********************************************************************************************
    * getConnection																				  *
    * 																							  *
    * This method creates a connection to the specified database and returns that connection.     *
    ***********************************************************************************************/
   public Connection getConnection(String sDBname)
   		throws ServletException, IOException {
   			
   		Connection con = null;
		
		// Reads database values in property file
		String sDSJNDIname = myResources.getString("DSJNDIname");
   		
	 try {
		InitialContext ic = new InitialContext();
     	javax.sql.DataSource ds = (javax.sql.DataSource)ic.lookup(sDSJNDIname);
    	con = ds.getConnection();
		con.setAutoCommit (true);
	 } catch (Exception e) {
	 	System.out.println("Error in AppTools method: getConnection ERROR: " + e);
     }
		return con;
   }
   
	
	/****************************************************************************************
	* getLocID - gets the locid of the location																*
	*****************************************************************************************/
	public int getLocID(HttpServletRequest req) throws IOException, SQLException {

		HttpSession session = req.getSession(false);
		int locid = 0;
		String geo = req.getParameter("geo");
		String country = req.getParameter("country");
		String city = req.getParameter("city");;
		String building = req.getParameter("building");
		String floor = req.getParameter("floor");
		String room = req.getParameter("room");
					
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		int iReturnCode = -1;
			
		try {	
			con = getConnection();
			stmt = con.createStatement();
			rs = stmt.executeQuery("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE FLOOR = '" + floor + "' AND BUILDING = '" + building + "' AND CITY = '" + city + "' AND COUNTRY = '" + country + "' AND GEO = '" + geo + "'");
			
			while (rs.next()) {
				locid = Integer.parseInt(rs.getString("locid"));
			}  //while available
				
		} catch(Exception e) {
			System.out.println("Error in AppTools.getLocID ERROR: " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("Error in AppTools.getLocID ERROR: " + e);
				}
			}
  		return locid;
	
	} // end InsertPrinterPassword
	
	/********************************************************************************************
	* nullStringConverter
	* 
	* This will convert any null value to an empty string. Strings with a value are not affected
	********************************************************************************************/
	public String nullStringConverter( String s )
		throws IOException {
		
			String sNewString = "";
			if(s != null) {
				sNewString = s;
			}
	
		return sNewString;
	}
	
	/********************************************************************************************
	* xmlTextUpdater
	* 
	* This will update any strings with an ampersand (&) to the ascii format for xml files.
	********************************************************************************************/
	public String xmlTextUpdater( String s )
		throws IOException {
		
			String sNewString = "";
			if(s != null) {
				sNewString = s.replaceAll("&","&amp;");
			}
	
		return sNewString;
	}
	
	/********************************************************************************************
    * logError
    * 
    * This will log an error to the ERROR_LOG table in the database
    ********************************************************************************************/
	public void logError( String sClassMethod, String sModule, Exception eError )
    	throws IOException, Exception {
    		
    		Connection con = null;
    		PreparedStatement psLogError = null;
    		String serverName = "";
    		serverName = getLocalHost();
    		String sError = "";
    		sError = serverName + ": " + eError.toString();
    		
    	try {
    		con = getConnection();
    		
    		psLogError = con.prepareStatement("INSERT INTO GPWS.ERROR_LOG (CLASS_METHOD, MODULE_NAME, ERROR) VALUES (?,?,?)");
			psLogError.setString(1,sClassMethod);
			psLogError.setString(2,sModule);
			psLogError.setString(3,sError);
			psLogError.executeUpdate();
			
    	} catch (Exception e) {
    		System.out.print("Error in AppTools method logError ERROR: " + e);    		
    	} finally {
			try {
				if (psLogError != null)
					psLogError.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Error in AppTools.logError.2 ERROR: " + e);
			}
  		}
    }
	
	/********************************************************************************************
    * logError
    * 
    * This will log an error to the ERROR_LOG table in the database.  Takes (String, String, String)
    ********************************************************************************************/
	public void logError( String sClassMethod, String sModule, String eError )
    	throws IOException, Exception {
    		
    		Connection con = null;
    		PreparedStatement psLogError = null;
    		String serverName = "";
    		serverName = getLocalHost();
    		eError = serverName + ": " + eError;
    		
    	try {
    		con = getConnection();
    		
    		psLogError = con.prepareStatement("INSERT INTO GPWS.ERROR_LOG (CLASS_METHOD, MODULE_NAME, ERROR) VALUES (?,?,?)");
			psLogError.setString(1,sClassMethod);
			psLogError.setString(2,sModule);
			psLogError.setString(3,eError);
			psLogError.executeUpdate();
    		
    	} catch (Exception e) {
    		System.out.print("Error in AppTools method logError ERROR: " + e);    		
    	} finally {
			try {
				if (psLogError != null)
					psLogError.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Error in AppTools.logError.2 ERROR: " + e);
			}
  		}
    }
    
	/********************************************************************************************
	* logUserAction
	* 
	* This will log user actions to the USER_LOG table in the database
	********************************************************************************************/
	public void logUserAction( String sLoginid, String sAction, String sUserType )
		throws IOException {
    		
			Connection con = null;
			Statement stmtLogAction = null;
		try {
			con = getConnection();
    		
			stmtLogAction = con.createStatement(); 
			stmtLogAction.executeUpdate("INSERT INTO GPWS.USER_LOG (LOGINID, ACTION, USER_TYPE) values ('" + sLoginid + "', '" + sAction + "', '" + sUserType + "')"); 
					
		} catch (Exception e) {
			System.out.print("Error in AppTools method logUserAction ERROR: " + e);    		
		} finally {
			try {
				if (stmtLogAction != null)
					stmtLogAction.close();
				if (con != null)	
					con.close();
			} catch (Exception e){
				System.out.println("Error in AppTools.logUserAction.2 ERROR: " + e);
			}
		}
	}
	
	/********************************************************************************************
	* getEncryptPW
	* 
	* This will log get the encrypt password from the database
	********************************************************************************************/
	public String getEncryptPW()
			throws IOException {
	    		
				PrinterTools tool = new PrinterTools();
				String sPW = "";
				sPW = tool.getEncryptPass();
		/**		Connection con = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
			try {
				con = getConnection();
	    		
				pstmt = con.prepareStatement("SELECT ENCRYPT_PASSWORD FROM GPWS.APP_SETTINGS"); 
				rs = pstmt.executeQuery(); 
				
				while (rs.next()) {
					sPW = nullStringConverter(rs.getString("ENCRYPT_PASSWORD"));
				}
				
				sPW = tool.DecryptString(sPW);
						
			} catch (Exception e) {
				System.out.print("Error in AppTools.getEncryptPW ERROR: " + e);    		
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
					if (con != null)	
						con.close();
				} catch (Exception e){
					System.out.println("Error in AppTools.getEncryptPW.2 ERROR: " + e);
				}
			} **/
			return sPW;
		}
	
	/**********************************************************************************************
	* validateUserInput
	* 
	* This method checks for invalid characters in the input string
	**********************************************************************************************/
	public boolean validateUserInput(String sInput) throws IOException  {
 
		boolean bIsValid = true;
		char[] invalidChars = {'\'','<','>','"'};
		int count = 0;
	
		if (sInput != null && !sInput.equals("")) {
			while (count < sInput.length()) {
				for (int x=0; x < invalidChars.length; x++) {
					if (sInput.charAt(count) == invalidChars[x]) {
						bIsValid = false;
					}
				}
				count++;
			}
		}
		return bIsValid;
   }
	
	/**********************************************************************************************
	* isValidIPAddress
	* 
	* This method checks to see if String is a valid ip address
	**********************************************************************************************/
	public boolean isValidIPAddress(String sInput) throws IOException  {
 
		boolean bIsValid = false;
		int quad1 = -1;
		int quad2 = -1;
		int quad3 = -1;
		int quad4 = -1;
		String newString = "";
		try {
			if (sInput != null && !sInput.equals("") && sInput.length() > 6) {
				quad1 = Integer.parseInt(sInput.substring(0,sInput.indexOf('.')));
				newString = sInput.substring(sInput.indexOf('.') + 1,sInput.length());
				
				quad2 = Integer.parseInt(newString.substring(0,newString.indexOf('.')));
				newString = newString.substring(newString.indexOf('.') + 1,newString.length());
				
				quad3 = Integer.parseInt(newString.substring(0,newString.indexOf('.')));
				newString = newString.substring(newString.indexOf('.') + 1,newString.length());
				
				quad4 = Integer.parseInt(newString);
				
				if ( (quad1 >= 0 && quad1 <= 255) && (quad2 >= 0 && quad2 <= 255) && (quad3 >= 0 && quad3 <= 255) && (quad4 >= 0 && quad4 <= 255)) {
					bIsValid = true;
				}
				
			} else {
				bIsValid = false;
			}
		} catch (Exception e) {
			bIsValid = false;
		}
		return bIsValid;
   }
	
	/******************************************************************
	 * Get the hostname of the local machine for troubleshooting purposes
	 * 
	 ******************************************************************/
	private String getLocalHost() throws Exception {
		String host = "";
		try { 
			InetAddress addr = InetAddress.getLocalHost(); 
			// Get IP Address 
			byte[] ipAddr = addr.getAddress(); 
			// Get hostname 
			host = addr.getHostName(); 
		} catch (Exception e) { 
			System.out.println("Error in AppTools.getLocalHost.2 ERROR: " + e);
		} 
		return host;
	}
	
	/******************************************************************
	 * Convert an HTML string to text only.  Good for removing extra
	 * html characters that otherwise cause problems
	 * @param html - as a string
	 * @return - clean string
	 ******************************************************************/
	public String html2text(String html) {
		html = html.replaceAll("\\<.*?\\>", "");
		html = html.replaceAll("\\n", " ");
		html = html.replaceAll("'", "&#39;");
		html = html.replaceAll("\"", "&quot;");
        //System.out.println(html);
	    return html;
	} //html2text
} // main class