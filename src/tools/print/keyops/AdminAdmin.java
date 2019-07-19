/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.keyops;

import java.sql.*;
import javax.servlet.http.*;
import tools.print.printer.*;
import tools.print.lib.*;
import java.util.*;

/****************************************************************************************
 * AdminAdmin																			*
 * 																						*
 * @author: Joe Comfort																	*
 * Copyright IBM																		*
 * 																						*
 * This class is the admin section that handles the administration of keyop admins. 	*
 * Only administrators have access to this page. Here they can add, remove, or view the	*
 * admins in the system																	*
 ****************************************************************************************/
public class AdminAdmin { 
	
	/****************************************************************************************
	* addAdminDB																			
	* @param req
	* @return Returns an int, returnCode													
	* This method grabs the information from the AdminAddAdminCheck.jsp and adds the person	
	* to the database in the admin table													
	*****************************************************************************************/
	public int addAdminDB(HttpServletRequest req) {
		
		PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sAdminUserid = pupb.getEmail();
		
		keyopTools tool = new keyopTools();
		SendMail mail = new SendMail();
		AppTools appTool = new AppTools();
		UserTools userTool = new UserTools();
		
		Locale currentLocale = req.getLocale();
		GetTransTag messages = new GetTransTag();
		messages.setLocale(currentLocale);
		
		Connection con = null;
		Statement stmtAdmin = null;
		Statement stmtUser = null;
		ResultSet rsUser = null;
		ResultSet rsAuthType = null;
		int iReturnCode = 99;
		// Get the user's information from the previous page and store to variables. 
		String sLoginid = req.getParameter("loginid");
		String sEmail = req.getParameter("email");
		String sFirstName = req.getParameter("firstname");
		String sLastName = req.getParameter("lastname");
		String sName = sFirstName + " " + sLastName;
		String sAdminType = "Keyop Admin";
		boolean bUserExist = false;
		String sAction = "";
		
		boolean dbResult = true;
		boolean bSentMail = false;
		int sqlError = 0;
		String sMessage = "";
		int iUserid = 0;
		int iAuthTypeid = 0;
	  try {
		con = tool.getConnection();
		// Create the message that will be sent in the email.
		sMessage = messages.getString("admin_add_email") + "\n\nhttp://" + tool.getServerName() + tool.getWebAddress();
	  
		// Create a database statement
		stmtAdmin = con.createStatement();
		iUserid = userTool.getUserID(sLoginid);
		// Execute the SQL statement to insert the user into the admin table
		if (iUserid <= 0) {
			stmtAdmin.executeUpdate("INSERT INTO GPWS.USER (FIRST_NAME, LAST_NAME, EMAIL, LOGINID) values ('" + sFirstName + "', '" + sLastName + "', '" + sEmail + "', '" + sLoginid + "')");
		} else {
			bUserExist = true;
		}
		
		if (iUserid == 0) {
			iUserid = userTool.getUserID(sLoginid);
		}
		
		rsAuthType = stmtAdmin.executeQuery("SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = '" + sAdminType + "'");
		
		while (rsAuthType.next()) {
			iAuthTypeid = rsAuthType.getInt("AUTH_TYPEID");
		}
		
		if (iAuthTypeid != 0 && iUserid != 0) {
			if (bUserExist == true) {
				stmtAdmin.executeUpdate("UPDATE GPWS.USER_AUTH_TYPE SET AUTH_TYPEID = " + iAuthTypeid + " WHERE USERID = " + iUserid + " AND (AUTH_TYPEID = (SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = 'Keyop') OR AUTH_TYPEID = (SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = 'Keyop Admin') OR AUTH_TYPEID = (SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = 'Keyop Superuser'))");
			} else {
				stmtAdmin.executeUpdate("INSERT INTO GPWS.USER_AUTH_TYPE (AUTH_TYPEID, USERID) VALUES (" + iAuthTypeid + ", " + iUserid + ")");
			}
		} else {
			dbResult = false;
		}
		
	  } catch (Exception e) {
			// Catch an Exceptions that might be thrown and print them to stdout.
			System.out.println("Keyop Error in AdminAdmin.addAdminDB.1 ERROR: " + e);
			// Set the database result to false
			dbResult = false;
			int sqlCode = e.toString().indexOf("SQL");
			int sqlCode2 = e.toString().indexOf("SQLCODE");
			if (sqlCode2 != -1 && e.toString().substring(sqlCode + 3,sqlCode + 7).equals("0803") || (e.toString().substring(sqlCode2 + 7,sqlCode2 + 14)).indexOf("803") != -1) {
				sqlError = 803;
			}
			try {
				appTool.logError("AdminAdmin.addAdminDB","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminAdmin.addAdminDB.2 ERROR: " + ex);
			}
	  } finally {
			try {
				if (rsUser != null)
					rsUser.close();
				if (rsAuthType != null)
					rsAuthType.close();
				if (stmtUser != null)
					stmtUser.close();
				if (stmtAdmin != null)
					stmtAdmin.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in AdminAdmin.addAdminDB.3 ERROR: " + e);
			}
	  }
	  try {
		// If SQL statement is successfull, send an email to the new admin
		if (dbResult == true) {
			bSentMail = (mail.sendMail(sEmail, messages.getString("admin_add_email_subject"), sMessage));
		}
		// Based on the results of the SQL statement and send mail function, set the results to an attribute
		// failure: SQL statement failed
		// false: SQL statement success, send mail failed
		// true: SQL statement success, send mail success
		// sAction does NOT need to be translated because it is written to the log file which should always be in English.
		if (dbResult == false) {
			if (sqlError == 803) {
				iReturnCode = 803;
			} else {
				iReturnCode = 2;
			}
			sAction = ("Attempted to add admin " + sName + " (" + sLoginid + ") but failed due to db2 error.");
		} else if (bSentMail == false) {	
			iReturnCode = 1;
			sAction = ("Added admin " + sName + " (" + sLoginid + ") but failed sending email.");
		} else {
			iReturnCode = 0;
			sAction = ("Added admin " + sName + " (" + sLoginid + ") successfully.");
		}
		
		appTool.logUserAction(sAdminUserid, sAction, "Keyop Superuser");
				
	  } catch (Exception e) {
			// Catch any Exceptions and print them to stdout
			System.out.println("Keyop Error in AdminAdmin.addAdminDB.4 ERROR: " + e);
			try {
				appTool.logError("AdminAdmin.addAdminDB","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminAdmin.addAdminDB.5 ERROR: " + ex);
			}
	  }
	  
		return iReturnCode;
		
	}
	
	/****************************************************************************************
	* removeAdminDB																			*
	* @param req
	* @param sAdmin
	* @return int
	* This method will remove the specified admin from the database							*
	*****************************************************************************************/
	public int removeAdminDB(HttpServletRequest req) {
		
		PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sAdminUserid = pupb.getEmail();
		
		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		boolean bResult = true;
		Connection con = null;
		Statement stmtAdmins = null;
		ResultSet rsAdmins = null;
		
		int iUserid = Integer.parseInt(req.getParameter("userid"));
		String sAuthName = req.getParameter("authname");
		int iReturnCode = 99;
		String sAction = "";
		boolean onlyKeyop = false;
				
	  try {
		con = appTool.getConnection();
		// Create an SQL statement and issue the delete command
		stmtAdmins = con.createStatement();
		rsAdmins = stmtAdmins.executeQuery("SELECT USERID FROM GPWS.USER_VIEW WHERE USERID = " + iUserid + " AND (AUTH_NAME != 'Keyop Admin' OR AUTH_NAME != '" + sAuthName + "')");
		int x = 0;
		while (rsAdmins.next()) {
			x++;
		}
		if (x < 1)
			onlyKeyop = true;
		if (onlyKeyop == true) {
			stmtAdmins.executeUpdate("DELETE FROM GPWS.USER WHERE USERID = " + iUserid);
		} else {
			stmtAdmins.executeUpdate("DELETE FROM GPWS.USER_AUTH_TYPE WHERE USERID = " + iUserid + " AND AUTH_TYPEID = (SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = '" + sAuthName + "')");
		}
		
	  } catch (Exception e) {
			// Catch any exceptions or errors from the SQL statement and print to stderr
			System.out.println("Keyop error in AdminAdmin.removeAdminDB ERROR: " + e);
			// Set the result of the SQL statement to false.
			bResult = false;
			try {
				appTool.logError("AdminAdmin.removeAdminDB.1","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminAdmin.removeAdminDB.1 ERROR: " + ex);
			}
	  }  finally {
	  	try {
		  	  if (rsAdmins != null)
		  	  	rsAdmins.close();
		  	  if (stmtAdmins != null)
		  	  	stmtAdmins.close();
		  	  if (con != null)
		  	  	con.close();
		  } catch (Exception e){
			  System.out.println("Keyop Error in AdminAdmin.removeAdminDB.2 ERROR: " + e);
		  }
	  }
	  
	  try {
		// Based on the results of the SQL statement, set the results to an attribute
		// sAction does not need to be translated because it is written to the log which should always be in English.
		if (bResult == false) {
			sAction = ("Attempted to delete admin " + tool.getName(tool.returnInfo( iUserid, "name")) + " (" + iUserid + ") but failed due to a datbase error.");
			iReturnCode = 1;
		} else {
			sAction = ("Deleted admin " + tool.getName(tool.returnInfo( iUserid, "name")) + " (" + iUserid + ") successfully.");
			iReturnCode = 0;
		}
	  	
		appTool.logUserAction(sAdminUserid, sAction, "Keyop Superuser");
		
	  } catch (Exception e) {
			// Catch any Exceptions and print them to stdout
			System.out.println("Keyop error in AdminAdmin.removeAdminDB ERROR3: " + e);
			try {
				appTool.logError("AdminAdmin.removeAdminDB.3","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminAdmin.removeAdminDB.3 ERROR: " + ex);
			}
	  }
		return iReturnCode;
	}
	
	/****************************************************************************************
	* editAdminDB																			
	* @param req
	* @return int
	* This method will edit the information for a keyop
	*****************************************************************************************/
	public int editAdminDB(HttpServletRequest req) {
		
		PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sAdminUserid = pupb.getEmail();
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtAdmin = null;
		int iReturnCode = 99;
		String sAction = "";
		
		int iUserid = Integer.parseInt(req.getParameter("userid"));
		String sLoginid = req.getParameter("loginid");
		String sEmail = req.getParameter("email");
		String sFirstName = req.getParameter("firstname");
		String sLastName = req.getParameter("lastname");
		String sName = sFirstName + " " + sLastName;
		String sPagerNo = req.getParameter("pagerno");
		String sTimeZone = req.getParameter("timezone");
		String sOfficeStatus = req.getParameter("officestatus");
		int iBackupid = 0;
		boolean dbResult = true;
				
	  try {
		  if (!req.getParameter("backup").equals("None")) {
			  iBackupid = Integer.parseInt(req.getParameter("backup"));
		  }
		con = appTool.getConnection();
		stmtAdmin = con.createStatement();
		stmtAdmin.executeUpdate("UPDATE GPWS.USER SET LOGINID = '" + sLoginid + "', EMAIL = '" + sEmail + "', FIRST_NAME = '" + sFirstName + "', LAST_NAME = '" + sLastName + "', PAGER = '" + sPagerNo + "', TIME_ZONE = '" + sTimeZone + "', OFFICE_STATUS = '" + sOfficeStatus + "', BACKUPID = " + iBackupid + " WHERE USERID = " + iUserid);
		
	  } catch (Exception e) {
			dbResult = false;
			System.out.println("Keyop error in AdminAdmin.editAdminDB ERROR " + e);
			try {
				appTool.logError("AdminAdmin.editAdminDB.1","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminKeyop.editAdminDB.1 ERROR: " + ex);
			}
	  }  finally {
			try {
				if (stmtAdmin != null)
					stmtAdmin.close();
				if (con != null);
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in AdminAdmin.editAdminDB.2 ERROR: " + e);
			}
	  }
	  	// sAction does not need to be translated because it is written to the log which should always be in English.
		if (dbResult == true) {
			sAction = ("Edited admin " + sName + " (" + sLoginid + ") successfully.");
			iReturnCode = 0;
		} else {
			sAction = ("Attempted to edit admin " + sName + " (" + sLoginid + ") but failed due to a datbase error.");
			iReturnCode = 1;
		}
		try {
			appTool.logUserAction(sAdminUserid, sAction, "Keyop Superuser");
		} catch (Exception ex) {
			System.out.println("Keyop Error in AdminKeyop.editAdminDB.2 ERROR: " + ex);
		}
						
		return iReturnCode;
	}
}