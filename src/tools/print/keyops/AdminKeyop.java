/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.keyops;

import java.io.IOException;
import java.sql.*;
import javax.servlet.http.*;
import tools.print.lib.*;
import tools.print.printer.PrinterUserProfileBean;


/****************************************************************************************
 * AdminKeyop																			*
 * 																						*
 * @author: Joe Comfort																	*
 * Copyright IBM																		*
 * 																						*
 * This class is the admin section that handles keyops. Only administrators have access *
 * to this page, and this is where they can add, remove, or view the keyops in the		*
 * system.																				*
 ****************************************************************************************/
public class AdminKeyop { 
	
	/****************************************************************************************
	* addKeyopDB																			
	* 
	* This method will add the specified keyop to the database
	*****************************************************************************************/
	public int addKeyopDB(HttpServletRequest req) {
		
		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		SendMail mail = new SendMail();
		Connection con = null;
		Statement stmtKeyops = null;
		ResultSet rsKeyops = null;
		ResultSet rsAuthType = null;
		int iReturnCode = 99;
		
		String sFirstName = req.getParameter("firstname");
		String sLastName = req.getParameter("lastname");
		String sPager = req.getParameter("pager");// + "@" + req.getParameter("pageremail");
		String sEmail = req.getParameter("email");
		String sLoginid = req.getParameter("loginid");
		String sTimeZone = req.getParameter("timezone");
		boolean bUserExist = tool.isUser(sLoginid);
		boolean dbResult = true;
		boolean bSentMail = false;
		String sMessage = "";
		int iUserid = 0;
		int iAuthTypeid = 0;
		int iVendorID = 0;
		
		PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(tools.print.printer.PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sUserid = pupb.getUserLoginID(); 
		
		boolean isSuperUser = tool.isValidKeyopSuperUser(pupb.getUserLoginID());
		if (isSuperUser) {
			iVendorID = Integer.parseInt(req.getParameter("vendor"));
		} else {
			iVendorID = pupb.getVendorID();
		}
		 
	  try {
	  	con = appTool.getConnection();
		sMessage = ("You have been added as a Keyop to GPWS. Please use your intranet ID and password to log in. You can access the Keyop admin page from the following URL.\n\nhttp://" + tool.getServerName() + tool.getWebAddress() + "gpwsadmin.html");
		
		stmtKeyops = con.createStatement();
		
		if (bUserExist == false) {
			stmtKeyops.execute("INSERT INTO GPWS.USER (FIRST_NAME, LAST_NAME, PAGER, EMAIL, LOGINID, TIME_ZONE, VENDORID) values ('" + sFirstName + "','" + sLastName + "', '" + sPager + "', '" + sEmail + "', '" + sLoginid + "', '" + sTimeZone + "', " + iVendorID + ")");
	  	} else {
	  		if (sPager != null && !sPager.equals("")) {
	  			stmtKeyops.executeUpdate("UPDATE GPWS.USER SET PAGER = '" + sPager + "', VENDORID = " + iVendorID + " WHERE LOGINID = '" + sLoginid + "'");
	  		}
	  	}
		rsKeyops = stmtKeyops.executeQuery("SELECT USERID FROM GPWS.USER WHERE LOGINID = '" + sLoginid + "'");

		while (rsKeyops.next()) {
			iUserid = rsKeyops.getInt("USERID");
		}

		rsAuthType = stmtKeyops.executeQuery("SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = 'Keyop'");
		while (rsAuthType.next()) {
			iAuthTypeid = rsAuthType.getInt("AUTH_TYPEID");
		}

		//Update the user's authority
		if (iAuthTypeid != 0 && iUserid != 0) {
			stmtKeyops.executeUpdate("INSERT INTO GPWS.USER_AUTH_TYPE (AUTH_TYPEID, USERID) VALUES (" + iAuthTypeid + ", " + iUserid + ")");
		} else {
			dbResult = false;
		}
		
		//Log the action to the user log
		
		appTool.logUserAction(sUserid, "Added " + sFirstName + " " + sLastName + " (" + sLoginid + ") as a keyop.", "Keyop");
		
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.addKeyopDB ERROR1: " + e);
	  		dbResult = false;
	  		try {
	   			appTool.logError("AdminKeyop.addKeyopDB.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.addKeyopDB.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsAuthType != null)
	  				rsAuthType.close();
	  			if (rsKeyops != null)
	  				rsKeyops.close();
	  			if (stmtKeyops != null)
		  			stmtKeyops.close();
		  		if (con != null)
		  			con.close();
			} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.addKeyopDB.2 ERROR: " + e);
	  		}
	  }
	  if (dbResult == true) {
	  	try {	
			bSentMail = (mail.sendMail(sEmail, "New Keyop userid created for you", sMessage));
	
		} catch (Exception e) {
		  		System.out.println("Keyop error in AdminKeyop.addKeyopDB ERROR2: " + e);
		 		bSentMail = false;
		 	try {
		 		appTool.logError("AdminKeyop.addKeyopDB.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.addKeyopDB.3 ERROR: " + ex);
	   		}
		}
	  }
		
		if (dbResult == false) {
			iReturnCode = 2;
		} else if (bSentMail == true) {	
			req.setAttribute("result", "true");
			iReturnCode = 0;
		} else {
			req.setAttribute("result", "false");
			iReturnCode = 1;
		}
	  
		return iReturnCode;
	}
	
	/****************************************************************************************
	* removeKeyopDB																			
	* 
	* This method will remove a specified keyop from the database
	*****************************************************************************************/
	public int removeKeyopDB(String sUserid) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		int iReturnCode = 99;
		
		boolean bOpenTickets = false;
		Statement stmtKeyops = null;
		ResultSet rsKeyops = null;
				
	  try {
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		rsKeyops = stmtKeyops.executeQuery("SELECT * FROM GPWS.KEYOP_REQUEST WHERE KEYOP_USERID = " + sUserid + " AND REQ_STATUS != 'completed'");
		
		while (rsKeyops.next()) {
			bOpenTickets = true;
		}
		
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop method removeKeyopDB ERROR: " + e);
	  		try {
	   			appTool.logError("AdminKeyop.removeKeyopDB.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.removeKeyopDB.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsKeyops != null)
	  				rsKeyops.close();
	  			if (stmtKeyops != null)
	  				stmtKeyops.close();
	  			if (con != null) 
	  				con.close();
	  		} catch (Exception e) {
	  			System.out.println("Keyop Error in AdminKeyop.addKeyopDB.2 ERROR: " + e);
	  		}
	  }
	  
	  ResultSet rsKeyops2 = null;
	  
	  try {
	  	con = appTool.getConnection();
	  	
	  	boolean onlyKeyop = false;
		if (bOpenTickets == false) {
			stmtKeyops = con.createStatement();
			stmtKeyops.executeUpdate("DELETE FROM GPWS.KEYOP_SITE WHERE USERID = " + sUserid);
			stmtKeyops.executeUpdate("DELETE FROM GPWS.KEYOP_BUILDING WHERE USERID = " + sUserid);
			rsKeyops2 = stmtKeyops.executeQuery("SELECT USERID FROM GPWS.USER_VIEW WHERE USERID = " + sUserid + " AND AUTH_NAME != 'Keyop'");
			int x = 0;
			while (rsKeyops2.next()) {
				x++;
			}
			if (x < 1)
				onlyKeyop = true;
			if (onlyKeyop == true) {
				stmtKeyops.executeUpdate("DELETE FROM GPWS.USER WHERE USERID = " + sUserid);
			} else {
				stmtKeyops.executeUpdate("DELETE FROM GPWS.USER_AUTH_TYPE WHERE USERID = " + sUserid + " AND AUTH_TYPEID = (SELECT AUTH_TYPEID FROM GPWS.AUTH_TYPE WHERE AUTH_NAME = 'Keyop')");
			}
	  		iReturnCode = 0;
		} else {
			iReturnCode = 1;
		}
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.removeKeyopDB ERROR2: " + e);
	  		iReturnCode = 2;
	  		try {
	   			appTool.logError("AdminKeyop.removeKeyopDB.3","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.removeKeyopDB.3 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
				if (rsKeyops2 != null)
					rsKeyops2.close();
				if (stmtKeyops != null)
					stmtKeyops.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in AdminKeyop.addKeyopDB.4 ERROR: " + e);
			}
	  }
			  
	  return iReturnCode;
		
	}
	
	/****************************************************************************************
	* editKeyopDB																			
	* 
	* This method will edit the information for a keyop
	*****************************************************************************************/
	public int editKeyopDB(HttpServletRequest req) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtKeyops = null;
		int iReturnCode = 99;
		
		int iUserid = 0;
		String sLoginid = req.getParameter("loginid");
		String sPagerNo = req.getParameter("pagerno");
		String sEmail = req.getParameter("email");
		String sFirstName = req.getParameter("firstname");
		String sLastName = req.getParameter("lastname");
		String sTimeZone = req.getParameter("timezone");
		String sOfficeStatus = req.getParameter("officestatus");
		int iBackupid = 0;
		boolean dbResult = true;
				
	  try {
		  iUserid = Integer.parseInt(req.getParameter("userid"));
		  if (!req.getParameter("backup").equals("None")) {
			  iBackupid = Integer.parseInt(req.getParameter("backup"));
		  }
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		stmtKeyops.executeUpdate("UPDATE GPWS.USER SET LOGINID = '" + sLoginid + "', PAGER = '" + sPagerNo + "', EMAIL = '" + sEmail + "', FIRST_NAME = '" + sFirstName + "', LAST_NAME = '" + sLastName + "', TIME_ZONE = '" + sTimeZone + "', OFFICE_STATUS = '" + sOfficeStatus + "', BACKUPID = " + iBackupid + " WHERE USERID = " + iUserid);
	  } catch (Exception e) {
	  		dbResult = false;
	  		System.out.println("Keyop error in AdminKeyop.editKeyopDB ERROR " + e);
	  		try {
	   			appTool.logError("AdminKeyop.editKeyopDB.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.editKeyopDB.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (stmtKeyops != null)
					stmtKeyops.close();
				if (con != null)
					con.close();
	  		} catch (Exception e){
				System.out.println("Keyop Error in AdminKeyop.editKeyopDB.2 ERROR: " + e);
	  		}
	  }
	  
	    if (dbResult == true) {
		    req.setAttribute("result", "true");
		    iReturnCode = 0;
	    } else {
	    	req.setAttribute("result", "false");
	    	iReturnCode = 1;
	    }
	    
	  	return iReturnCode;
	}
	
	/****************************************************************************************
	* getUserID																			
	* 
	* This method will take the loginid and return the UserID
	*****************************************************************************************/
	public int getUserID(String sLoginID) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtKeyops = null;
		ResultSet rsKeyops = null;
		
		int iUserID = 0;

	  try {
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		rsKeyops = stmtKeyops.executeQuery("SELECT USERID FROM GPWS.USER WHERE LOGINID = '" + sLoginID + "'");
		while (rsKeyops.next()) {
			iUserID = rsKeyops.getInt("USERID");
		}

	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.getUserID ERROR1: " + e);
	  		try {
	   			appTool.logError("AdminKeyop.getUserID.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in getUserID.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsKeyops != null)
	  				rsKeyops.close();
	  			if (stmtKeyops != null)
		  			stmtKeyops.close();
		  		if (con != null)
		  			con.close();
			} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.getUserID.2 ERROR: " + e);
	  		}
	  }
	  
		return iUserID;
	}
	
	/****************************************************************************************
	* addSiteDB																				
	* 
	* This method will add sites to the database for a specified keyop.
	*****************************************************************************************/
	public int addSiteDB(HttpServletRequest req) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtKeyops = null;
		int iReturnCode = 99;
		
		int iUserid = Integer.parseInt(req.getParameter("userid"));
		String sEntireSite = req.getParameter("entiresite");
		if (sEntireSite == null || sEntireSite.equals("")) {
			sEntireSite = "N";
		} else {
			sEntireSite = "Y";
		} 
		String[] aCityID = req.getParameterValues("availsites");
				
	  try {
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		
		if (aCityID != null) {
			for(int i = 0; i < aCityID.length; i++){	
				stmtKeyops.executeUpdate("INSERT INTO GPWS.KEYOP_SITE (USERID, CITYID, ENTIRE_SITE) values (" + iUserid + ", " + Integer.parseInt(aCityID[i]) + ", '" + sEntireSite + "')");
			}
			iReturnCode = 0;
		} else {
			iReturnCode = 2;
		}
		
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.addSiteDB ERROR1: " + e);
	  		iReturnCode = 1;
	  		try {
	   			appTool.logError("AdminKeyop.addSiteDB.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.addSiteDB.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
				if (stmtKeyops != null)
		  			stmtKeyops.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.addSiteDB.2 ERROR: " + e);
	  		}
	  }
	  
		return iReturnCode;
	}
	
	/****************************************************************************************
	* removeSiteDB																			
	* 
	* This method removes a site assigned to a keyop from the database.
	*****************************************************************************************/
	public int removeSiteDB(HttpServletRequest req) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtKeyops = null;
		int iReturnCode = 99;
		
		String sUserid = req.getParameter("userid");
		String sCityID = req.getParameter("cityid");
				
	  try {
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		
		if (sCityID != null && !sCityID.equals("")) {
			stmtKeyops.executeUpdate("DELETE FROM GPWS.KEYOP_SITE WHERE USERID = " + sUserid + " AND CITYID = " + sCityID);
			stmtKeyops.executeUpdate("DELETE FROM GPWS.KEYOP_BUILDING WHERE USERID = " + sUserid + " AND BUILDINGID IN (SELECT BUILDINGID FROM GPWS.BUILDING WHERE CITYID = " + sCityID + ")");
			iReturnCode = 0;
		} else {
			iReturnCode = 1;
		}
		
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.removeSiteDB ERROR1: " + e);
	  		iReturnCode = 1;
	  		try {
	   			appTool.logError("AdminKeyop.removeSiteDB.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.removeSiteDB.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (stmtKeyops != null)
		  			stmtKeyops.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.removeSiteDB.2 ERROR: " + e);
	  		}
	  }
	  
	  return iReturnCode;
		
	}
	
	/****************************************************************************************
	* editSiteBuildings																				
	* 
	* This method will add buildings to the database for a specified keyop.
	*****************************************************************************************/
	public int editSiteBuildings(HttpServletRequest req) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtKeyops = null;
		int iReturnCode = 99;
		
		String sUserid = req.getParameter("userid");
		String sCityid = req.getParameter("cityid");
		String[] aBuildingID = req.getParameterValues("buildings");
		String sEntireSite = req.getParameter("entiresite");
		if (sEntireSite != null && !sEntireSite.equals("") && (sEntireSite.toLowerCase().equals("yes") || sEntireSite.toLowerCase().equals("y"))) {
			sEntireSite = "Y";
		} else {
			sEntireSite = "N";
		}
		boolean dbResult = true;
				
	  try {
		removeAllBuildings(req);
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		
		stmtKeyops.executeUpdate("UPDATE GPWS.KEYOP_SITE SET ENTIRE_SITE = '" + sEntireSite + "' WHERE USERID = " + sUserid + " AND CITYID = " + sCityid);
		
		if (aBuildingID != null && sEntireSite.equals("N")) {
			for(int i = 0; i < aBuildingID.length; i++){
				stmtKeyops.executeUpdate("INSERT INTO GPWS.KEYOP_BUILDING (USERID, BUILDINGID) VALUES (" + sUserid + ", " + aBuildingID[i] + ")");
			}
		}
		iReturnCode = 0;
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.editSiteBuildings ERROR1: " + e);
	  		dbResult = false;
	  		iReturnCode = 1;
	  		try {
	   			appTool.logError("AdminKeyop.editSiteBuildings.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.editSiteBuildings.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
				if (stmtKeyops != null)
					stmtKeyops.close();
				if (con != null)
					con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.editSiteBuildings.2 ERROR: " + e);
	  		}
	  }
	  
	  return iReturnCode;
		
	}
	
	/****************************************************************************************
	* removeAllBuildings																			
	* 
	* This method removes a site assigned to a keyop from the database.
	*****************************************************************************************/
	public int removeAllBuildings(HttpServletRequest req) {
		
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtKeyops = null;
		int iReturnCode = 99;
		
		String sUserid = req.getParameter("userid");
		String sCityID = req.getParameter("cityid");
				
	  try {
	  	con = appTool.getConnection();
		stmtKeyops = con.createStatement();
		
		if (sCityID != null && !sCityID.equals("")) {
			stmtKeyops.executeUpdate("DELETE FROM GPWS.KEYOP_BUILDING WHERE USERID = " + sUserid + " AND BUILDINGID IN (SELECT BUILDINGID FROM GPWS.BUILDING WHERE CITYID = " + sCityID + ")");
			iReturnCode = 0;
		} else {
			iReturnCode = 1;
		}
		
	  } catch (Exception e) {
	  		System.out.println("Keyop error in AdminKeyop.removeAllBuildings ERROR1: " + e);
	  		iReturnCode = 1;
	  		try {
	   			appTool.logError("AdminKeyop.removeAllBuildings.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in AdminKeyop.removeAllBuildings.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (stmtKeyops != null)
		  			stmtKeyops.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.removeAllBuildings.2 ERROR: " + e);
	  		}
	  }
	  
	  return iReturnCode;
		
	}
			
	/****************************************************************************************
	* siteNameLookup																		
	* 
	* This method takes a cityid and returns the sitename
	*****************************************************************************************/
	public static String siteNameLookup( String sCityId )
    	throws IOException {
    	
		String sCityName = "not found";
		AppTools appTool = new AppTools();
		Connection con = null;
		Statement stmtSites = null;
		ResultSet rsSites = null;
		
      try {
      	
        con = appTool.getConnection();
        stmtSites = con.createStatement();
		rsSites = stmtSites.executeQuery("SELECT CITY FROM GPWS.CITY WHERE CITYID = " + sCityId);
        
		while (rsSites.next()) {				
			sCityName = rsSites.getString("CITY");
		}
				
	   } catch(Exception e) {
	   		System.out.print("Keyop error in AdminKeyop.siteNameLookup ERROR " + e);
       } finally {
	   		try {
	   			if (rsSites != null)
	   				rsSites.close();
	   			if (stmtSites != null)
		   			stmtSites.close();
		   		if (con != null)
		   			con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in AdminKeyop.siteNameLookup.1 ERROR: " + e);
	   		}
 		}
       
		return sCityName;
    }
    
	/****************************************************************************************
	* AssignTo
	*****************************************************************************************/
	public int AssignTicket(int iUserid, int iTicketNo, String sUserLoginid) {
		
		AppTools appTool = new AppTools();
		boolean dbResult = true;
		keyopTools tool = new keyopTools();
		SendMail mail = new SendMail();
		int iReturnCode = 0;
		Connection con = null;
		Statement stmtAssign = null;
		boolean bSentMail = false;
		boolean bSentPage = false;
		String sAction = "";
		String sKeyopName = "";
		
		RequestService reqServ = new RequestService();
				
	   try {
	  	
	   	sKeyopName = tool.returnUserInfo(iUserid, "last_first_name");
		con = appTool.getConnection();
		
		stmtAssign = con.createStatement();
		stmtAssign.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET REQ_STATUS = 'in progress', KEYOP_USERID = " + iUserid + ", KEYOP_NAME = '" + sKeyopName + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
			
	   } catch (Exception e) {
			System.out.println("Keyop error in AdminKeyop.AssignTicket ERROR: " + e);
			dbResult = false;
			try {
				appTool.logError("AdminKeyop.AssignTicket.1","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminKeyop.AssignTicket.1 ERROR: " + ex);
			}
	   } finally {
			try {
				if (stmtAssign != null)
					stmtAssign.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in AdminKeyop.AssignTicket.2 ERROR: " + e);
			}
	   }
	   
	   		Statement stmtKeyopTicket = null;
	   		Statement stmtKeyopPager = null;
	   		ResultSet rsKeyopTicket = null;
	   		ResultSet rsKeyopPager = null;
	   		String sUserName = "";
	   		String sEmail = "";
	   		String sExtPhone = "";
	   		String sTieLine = "";
	   		String sPrinterName = "";
	   		String sSite = "";
	   		String sBuilding = "";
	   		String sFloor = "";
	   		String sRoom = "";
	   		String sProblems = "";
	   		String sDescription = "";
	   		String sPager = "";
	   try {
			con = appTool.getConnection();
			
	   		stmtKeyopPager = con.createStatement();
	   		rsKeyopPager = stmtKeyopPager.executeQuery("SELECT PAGER, EMAIL FROM GPWS.USER WHERE USERID = " + iUserid);
			while (rsKeyopPager.next()) {
				sPager = rsKeyopPager.getString("PAGER");
				sEmail = rsKeyopPager.getString("EMAIL");
			}
			stmtKeyopTicket = con.createStatement();
			rsKeyopTicket = stmtKeyopTicket.executeQuery("SELECT REQUESTOR_NAME, REQUESTOR_EMAIL, REQUESTOR_EXT_PHONE, REQUESTOR_TIELINE, DEVICE_NAME, CITY, BUILDING, FLOOR, ROOM, DESCRIPTION FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iTicketNo);
			while (rsKeyopTicket.next()) {
				sUserName = appTool.nullStringConverter(rsKeyopTicket.getString("REQUESTOR_NAME"));
				sExtPhone = appTool.nullStringConverter(rsKeyopTicket.getString("REQUESTOR_EXT_PHONE"));
				sTieLine = appTool.nullStringConverter(rsKeyopTicket.getString("REQUESTOR_TIELINE"));
				sPrinterName = appTool.nullStringConverter(rsKeyopTicket.getString("DEVICE_NAME"));
				sSite = appTool.nullStringConverter(rsKeyopTicket.getString("CITY"));
				sBuilding = appTool.nullStringConverter(rsKeyopTicket.getString("BUILDING"));
				sFloor = appTool.nullStringConverter(rsKeyopTicket.getString("FLOOR"));
				sRoom = appTool.nullStringConverter(rsKeyopTicket.getString("ROOM"));
				sDescription = appTool.nullStringConverter(rsKeyopTicket.getString("DESCRIPTION"));
			}
			sProblems = reqServ.getTicketProblems(con, iTicketNo);
			
			// Create email message
			String sMessage = ("There is a request from an end user for your printer service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " printer " + sPrinterName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " for " + sProblems + ". Problem description: " + sDescription + ". Contact " + sUserName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
			
			// if the description is blank, put the problems in the page instead
			if (sDescription == null || sDescription.equals("")) { 
				sDescription = sProblems; 
			}
			// Create page message
			String sPagerMessage = ("Ticket " + iTicketNo + " transferred: " + sUserName + " at " + sExtPhone + " requested service to " + sPrinterName + " (" + sSite + ", " + sBuilding + ", " + sFloor + ", " + sRoom + ") for: " + sDescription);
			bSentMail = mail.sendMail(sEmail, "Ticket " + iTicketNo + " transferred: Request from end user for printer service on " + sSite + " printer " + sPrinterName, sMessage);
			bSentPage = mail.sendPage(sPager, sPagerMessage);
	   } catch (Exception e) {
		   System.out.println("Keyop error in AdminKeyop.AssignTicket ERROR: " + e);
		   try {
			   appTool.logError("KeyopTicket.AssignTo.1","Keyop", e);
		   } catch (Exception ex) {
			   System.out.println("Keyop Error in AdminKeyop.AssignTicket.3 ERROR: " + ex);
		   }
	   } finally {
			try {
				if (rsKeyopTicket != null)
					rsKeyopTicket.close();
				if (rsKeyopPager != null)
					rsKeyopPager.close();
				if (stmtKeyopTicket != null)
					stmtKeyopTicket.close();
				if (stmtKeyopPager != null)
					stmtKeyopPager.close();
				if (con != null)	
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in AdminKeyop.AssignTicket.4 ERROR: " + e);
			}
	   }
	  
	  try { 
			if (dbResult == false) {
				iReturnCode = 2;
				sAction = ("Attempted to assign ticket number " + iTicketNo + " to " + tool.getName(tool.returnInfo(iUserid, "name")) + " but failed due to a db2 error.");
			} else if (bSentPage == false) {
				iReturnCode = 1;
				sAction = ("Successfully assigned ticket number " + iTicketNo + " to " + tool.getName(tool.returnInfo(iUserid, "name")) + " but failed notifying keyop.");
			} else {
				iReturnCode = 0;
				sAction = ("Successfully assigned ticket number " + iTicketNo + " to " + tool.getName(tool.returnInfo(iUserid, "name")) + ".");
			}
	  
			appTool.logUserAction(sUserLoginid,sAction,"Keyop");
	  
	  } catch (Exception e) {
			System.out.println("Keyop error in AdminKeyop.AssignTicket ERROR2: " + e);
			try {
				appTool.logError("KeyopAssign.AssignTo.2","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in AdminKeyop.AssignTicket.5 ERROR: " + ex);
			}
	  }
	 
	  return iReturnCode;
	}
}