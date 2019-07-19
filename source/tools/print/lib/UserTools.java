/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.lib;

import java.sql.*;


/****************************************************************************************
 * UserTools
 * 
 * @author: Joe Comfort
 * Copyright IBM
 * 
 * This class contains many useful methods that are used often throughout all of the
 * other servlets.  It's a means of writing code once and creating an instance of this
 * class whenever use of one of these common methods is needed. All these methods
 * pertain to GPWS users and anything related to the USER table.
 ****************************************************************************************/
public class UserTools {
		   
   /**********************************************************************************************
    * getUserInfo
    * 
    * This method takes a userid and string and returns user info based on the string value.
    ***********************************************************************************************/
   public String getUserInfo(int userID, String sFlag) throws Exception {
   		
	    AppTools tool = new AppTools();
	    
	    Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sReturnValue = "";
		
		String sFirstName = "";
		String sLastName = "";
		String sLoginID = "";
		String sEmail = "";
		String sPager = "";
		String sTimeZone = "";
		String sOfficeStatus = "";
			
		try {	
			con = tool.getConnection();
			stmt = con.prepareStatement("SELECT * FROM GPWS.USER WHERE USERID = ?");
			stmt.setInt(1,userID);
			rs = stmt.executeQuery();
						
			while (rs.next()) {
				sFirstName = rs.getString("FIRST_NAME");
				sLastName = rs.getString("LAST_NAME");
				sLoginID = rs.getString("LOGINID");
				sEmail = rs.getString("EMAIL");
				sPager = rs.getString("PAGER");
				sTimeZone = rs.getString("TIME_ZONE");
				sOfficeStatus = rs.getString("OFFICE_STATUS");
			}  //while available
			
			if (!sFlag.equals("")) {
				if (sFlag.toUpperCase().equals("NAME")) {
					sReturnValue = sFirstName + " " + sLastName; 
				} else if (sFlag.toUpperCase().equals("FIRST_NAME")) {
					sReturnValue = sFirstName;
				} else if (sFlag.toUpperCase().equals("LAST_NAME")) {
					sReturnValue = sLastName;
				} else if (sFlag.toUpperCase().equals("LOGINID")) {
					sReturnValue = sLoginID;
				} else if (sFlag.toUpperCase().equals("EMAIL")) {
					sReturnValue = sEmail;
				} else if (sFlag.toUpperCase().equals("PAGER")) {
					sReturnValue = sPager;
				} else if (sFlag.toUpperCase().equals("TIME_ZONE")) {
					sReturnValue = sTimeZone;
				} else if (sFlag.toUpperCase().equals("OFFICE_STATUS")) {
					sReturnValue = sOfficeStatus;
				}
			}
				
		} catch(Exception e) {
			System.out.println("Error in UserTools.getUserInfo ERROR: " + e);
			tool.logError("UserTools.getUserInfo","GPWS",e);
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (con != null)
				con.close();
		}
 		return sReturnValue;
   }
   
   /**********************************************************************************************
    * getUserInfo
    * 
    * This method takes a userid and string and returns user info based on the string value.
    ***********************************************************************************************/
   public String getUserInfo(String sLoginID, String sFlag) throws Exception {
   		
	    AppTools tool = new AppTools();
	    
	    Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sReturnValue = "";
		
		String sFirstName = "";
		String sLastName = "";
		String sEmail = "";
		String sPager = "";
		String sTimeZone = "";
		String sOfficeStatus = "";
			
		try {	
			con = tool.getConnection();
			stmt = con.prepareStatement("SELECT * FROM GPWS.USER WHERE LOGINID = ?");
			stmt.setString(1,sLoginID);
			rs = stmt.executeQuery();
						
			while (rs.next()) {
				sFirstName = rs.getString("FIRST_NAME");
				sLastName = rs.getString("LAST_NAME");
				sLoginID = rs.getString("LOGINID");
				sEmail = rs.getString("EMAIL");
				sPager = rs.getString("PAGER");
				sTimeZone = rs.getString("TIME_ZONE");
				sOfficeStatus = rs.getString("OFFICE_STATUS");
			}  //while available
			
			if (!sFlag.equals("")) {
				if (sFlag.toUpperCase().equals("NAME")) {
					sReturnValue = sFirstName + " " + sLastName; 
				} else if (sFlag.toUpperCase().equals("FIRST_NAME")) {
					sReturnValue = sFirstName;
				} else if (sFlag.toUpperCase().equals("LAST_NAME")) {
					sReturnValue = sLastName;
				} else if (sFlag.toUpperCase().equals("LOGINID")) {
					sReturnValue = sLoginID;
				} else if (sFlag.toUpperCase().equals("EMAIL")) {
					sReturnValue = sEmail;
				} else if (sFlag.toUpperCase().equals("PAGER")) {
					sReturnValue = sPager;
				} else if (sFlag.toUpperCase().equals("TIME_ZONE")) {
					sReturnValue = sTimeZone;
				} else if (sFlag.toUpperCase().equals("OFFICE_STATUS")) {
					sReturnValue = sOfficeStatus;
				}
			}
				
		} catch(Exception e) {
			System.out.println("Error in UserTools.getUserInfo ERROR: " + e);
			tool.logError("UserTools.getUserInfo","GPWS",e);
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (con != null)
				con.close();
		}
 		return sReturnValue;
   }
   
   /**********************************************************************************************
    * getUserID
    * 
    * This method takes a user's email address and returns the userid.
    ***********************************************************************************************/
   public int getUserID(String sEmail) throws Exception {
   		
	    AppTools tool = new AppTools();
	    
	    Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		int iUserID = 0;
			
		try {	
			con = tool.getConnection();
			stmt = con.prepareStatement("SELECT USERID FROM GPWS.USER WHERE LOGINID = ?");
			stmt.setString(1,sEmail);
			rs = stmt.executeQuery();
						
			while (rs.next()) {
				iUserID = rs.getInt("USERID");
			}  //while available
							
		} catch(Exception e) {
			System.out.println("Error in UserTools.getUserID ERROR: " + e);
			tool.logError("UserTools.getUserID","GPWS",e);
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (con != null)
				con.close();
		}
 		return iUserID;
   }
   
} // class