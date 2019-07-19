/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.keyops;

import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.*;
import tools.print.lib.*;

/****************************************************************************************
 * RequestService																		*
 * 																						*
 * @author Joe Comfort																	*
 * Copyright IBM																		*
 * 																						*
 * This class handles the form to open a new request. It will insert the ticket info    *
 * into the database. This servlet gets called by RequestService.jsp					*
 ****************************************************************************************/
public class RequestService {
	
	private boolean isValidDevice = false;
	private boolean isSupportedDevice = false;
	private String sDeviceName = "";
	private String sDeviceName2 = "";
	private int iDeviceID = 0; 
	private String sSite = "";
	private String sBuilding = "";
	private int iBuildingID = 0;
	private String sFloor = "";
	private String sRoom = "";
	private int iCityID = 0;
	private String sE2ECategory = "";
	private String sTier = "";
	private String sDeviceSerial = "";
	private String sDeviceType = "";
	
	public boolean getIsValidDevice() {
		return isValidDevice;
	}
	public boolean getIsSupportedDevice() {
		return isSupportedDevice;
	}
	public String getDeviceName() {
		return sDeviceName;
	}
	public String getDeviceName2() {
		return sDeviceName2;
	}
	public String getSite() {
		return sSite;
	}
	public String getBuilding() {
		return sBuilding;
	}
	public int getBuildingID() {
		return iBuildingID;
	}
	public String getFloor() {
		return sFloor;
	}
	public String getRoom() {
		return sRoom;
	}
	public int getCityID() {
		return iCityID;
	}
	public String getE2ECategory() {
		return sE2ECategory;
	}
	public String getTier() {
		return sTier;
	}
	public String getDeviceSerial() {
		return sDeviceSerial;
	}
	public String getDeviceType() {
		return sDeviceType;
	}

	
	/****************************************************************************************
	* SubmitForm																			*
	*****************************************************************************************/
	public int[] SubmitForm(HttpServletRequest req) throws Exception {
			
		keyopTools tool = new keyopTools();
		DateTime dateTime = new DateTime();
		AppTools appTool = new AppTools();
		SendMail mail = new SendMail();
		Connection con = null;
		Statement stmtRequest = null;
		Statement stmtKeyopPager = null;
		ResultSet rsRequest = null;
		ResultSet rsKeyopPager = null;
		int iTicketNo = 0;
		int iReturnCode = -1;
		
		Timestamp tsTimeSubmitted = dateTime.getSQLTimestamp();
		  
		String sEmail = req.getParameter("email");
	  	String sRequestorName = req.getParameter("nameid");
		String sExtPhone = req.getParameter("phoneid");
		String sTieLine = req.getParameter("tieid");
		String sDescription = req.getParameter("description");
		String sCCEmail = req.getParameter("ccemail");
		UserInfo user = null;
		if (sRequestorName == null || sRequestorName.equals("") || sExtPhone == null || sExtPhone.equals("") || sTieLine == null || sTieLine.equals("")) {
			user = new UserInfo(sEmail);
		}
		if (sRequestorName == null || sRequestorName.equals("")) {
			sRequestorName = user.employeeName();
		}
		if (sExtPhone == null || sExtPhone.equals("")) {
			sExtPhone = user.empXphone();
		}
		if (sTieLine == null || sTieLine.equals("")) {
			sTieLine = user.empTie();
		}
		boolean dbResult = true;
		boolean bMailSent = true;
		boolean bMailSent2 = true;
	  	
		String[] sProblem = new String[tool.getNumProbChoices() + 1];
		sProblem = req.getParameterValues("Problem");
		String sProblemsAll = "";
		for (int y = 0; y < sProblem.length; y++) {
			if ( y == 0 ) {
				sProblemsAll = sProblem[y];
			} else {
				sProblemsAll = (sProblemsAll + ", " + sProblem[y]);
			}
		}
		
		// Query database and get emails and pagers
		List<String> lEmails = Collections.synchronizedList(new ArrayList<String>());
		List<String> lPagers = Collections.synchronizedList(new ArrayList<String>());
		Object[] aEmails = null;
		Object[] aPagers = null;
  		try {	
	  		con = tool.getConnection();
	  		
	  		int iDevVendorID = tool.getDeviceVendorID(con, sDeviceName);
	  		
	  		stmtKeyopPager = con.createStatement();
	  		rsKeyopPager = stmtKeyopPager.executeQuery("SELECT USER.PAGER, USER.EMAIL, USER.OFFICE_STATUS, USER.BACKUPID FROM GPWS.USER USER WHERE USER.VENDORID = " + iDevVendorID + " AND (USER.USERID IN (SELECT USERID FROM GPWS.KEYOP_SITE WHERE CITYID = " + iCityID + " AND ENTIRE_SITE = 'Y') OR USER.USERID IN (SELECT USERID FROM GPWS.KEYOP_BUILDING WHERE BUILDINGID = " + iBuildingID + "))");
			
			String sTemp1 = "";
			String sTemp2 = "";
			while (rsKeyopPager.next()) {
				sTemp1 = rsKeyopPager.getString("EMAIL");
				sTemp2 = rsKeyopPager.getString("PAGER");
				String sTemp3 = "";
				String sTemp4 = "";
				if (rsKeyopPager.getString("OFFICE_STATUS").equals("N")) {
					sTemp3 = tool.returnKeyopInfo(rsKeyopPager.getInt("BACKUPID"), "pager");
					sTemp4 = tool.returnKeyopInfo(rsKeyopPager.getInt("BACKUPID"), "email");
					if (sTemp1 != null && !sTemp1.equals("") && !sTemp1.equals("null")) {
						lEmails.add(sTemp1);
					}
					if (sTemp4 != null && !sTemp4.equals("") && !sTemp4.equals("null")) {
						lEmails.add(sTemp4);
					}
					if (sTemp3 != null && !sTemp3.equals("") && !sTemp3.equals("null")) {
						lPagers.add(sTemp3);
					}
				} else {
					if (sTemp1 != null && !sTemp1.equals("") && !sTemp1.equals("null")) {
						lEmails.add(sTemp1);
					}
					if (sTemp2 != null && !sTemp2.equals("") && !sTemp2.equals("null")) {
						lPagers.add(sTemp2);
					}
				}
			}
			aEmails = lEmails.toArray();
			aPagers = lPagers.toArray();
			
  		} catch (Exception e) {
			System.out.println("Keyop error in RequestService.SubmitForm.1a ERROR: " + e);
			try {
				appTool.logError("RequestService.submitForm.1b","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in RequestService.submitForm.1c ERROR: " + ex);
			}
  		} finally {
			try {
				if (stmtKeyopPager != null) { stmtKeyopPager.close(); }
				if (con != null ) { con.close(); }
			} catch (Exception e){
				System.out.println("Keyop Error in RequestService.submitForm.1d ERROR: " + e);
			}
  		}
		
		//Check to see if duplicate ticket
		int iDuplicate = checkDuplicate(sDeviceName, sProblem);
		
		if (iDuplicate == 0) {

			// Insert ticket into database.
		  try {
		  	con = tool.getConnection();
			stmtRequest = con.createStatement(); 
			if (sCCEmail != null && !sCCEmail.equals("") && !sCCEmail.equals("null")) {
				stmtRequest.executeUpdate("INSERT INTO GPWS.KEYOP_REQUEST (KEYOP_REQUESTID, REQUESTOR_NAME, REQUESTOR_EMAIL, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, DEVICE_NAME, DEVICEID, DEVICE_TYPE, DEVICE_SERIAL, TIER, E2E_CATEGORY, CITY, CITYID, BUILDING, BUILDINGID, FLOOR, ROOM, REQ_STATUS, DESCRIPTION, CC_EMAIL) VALUES (COALESCE((SELECT MAX(KEYOP_REQUESTID)+1 FROM GPWS.KEYOP_REQUEST),1),'" + sRequestorName + "','" + sEmail + "','" + sTieLine + "','" + sExtPhone + "','" + tsTimeSubmitted + "','" + sDeviceName + "'," + iDeviceID + ",'" + sDeviceType + "','" + sDeviceSerial + "','" + sTier + "','" + sE2ECategory + "','" + sSite + "'," + iCityID + ",'" + sBuilding + "'," + iBuildingID + ",'" + sFloor + "','" + sRoom + "','new','" + tool.fixDBInputText(sDescription) + "','" + sCCEmail + "')");
			} else {
				stmtRequest.executeUpdate("INSERT INTO GPWS.KEYOP_REQUEST (KEYOP_REQUESTID, REQUESTOR_NAME, REQUESTOR_EMAIL, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, DEVICE_NAME, DEVICEID, DEVICE_TYPE, DEVICE_SERIAL, TIER, E2E_CATEGORY, CITY, CITYID, BUILDING, BUILDINGID, FLOOR, ROOM, REQ_STATUS, DESCRIPTION) VALUES (COALESCE((SELECT MAX(KEYOP_REQUESTID)+1 FROM GPWS.KEYOP_REQUEST),1),'" + sRequestorName + "','" + sEmail + "','" + sTieLine + "','" + sExtPhone + "','" + tsTimeSubmitted + "','" + sDeviceName + "'," + iDeviceID + ",'" + sDeviceType + "','" + sDeviceSerial + "','" + sTier + "','" + sE2ECategory + "','" + sSite + "'," + iCityID + ",'" + sBuilding + "'," + iBuildingID + ",'" + sFloor + "','" + sRoom + "','new','" + tool.fixDBInputText(sDescription) + "')");
			}
			rsRequest = stmtRequest.executeQuery("SELECT MAX(KEYOP_REQUESTID) FROM GPWS.KEYOP_REQUEST");
			while (rsRequest.next()) {
				iTicketNo = rsRequest.getInt("1");
			}
			for (int x = 0; x < sProblem.length; x++) {
				stmtRequest.executeUpdate("INSERT INTO GPWS.KO_REQUEST_PROBLEMS (KEYOP_REQUESTID, PROBLEM_NAME) VALUES (" + iTicketNo + ",'" + sProblem[x] + "')");
			}
		  } catch (Exception e) {
		  		System.out.println("Keyop error in RequestService.SubmitForm.2a ERROR: " + e);
		  		dbResult = false;
		  		try {
		  			appTool.logError("RequestService.submitForm.2b","Keyop", e);
		   		} catch (Exception ex) {
		   			System.out.println("Keyop Error in RequestService.SubmitForm.2c ERROR: " + ex);
		   		}
		  } finally {
		  		try {
		  			if (rsRequest != null)
		  				rsRequest.close();
		  			if (stmtRequest != null)
		  				stmtRequest.close();
		  			if (con != null)
		  				con.close();
		  		} catch (Exception e){
			  		System.out.println("Keyop Error in RequestService.SubmitForm.2d ERROR: " + e);
		  		}
		  }
		  
		  String sMessageKeyop = "";
		  String sMessageKeyopEmail = "";
		  
		  	// Create message for page and email to be sent to keyop.
				if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C')) {
					sMessageKeyopEmail = ("There is a request from an end user for your copier service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " copier " + sDeviceName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " that has problem with " + sProblemsAll + ". Problem description - " + sDescription + ". Contact " + sRequestorName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
				} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
					sMessageKeyopEmail = ("There is a request from an end user for your fax service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " fax " + sDeviceName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " that has problem with " + sProblemsAll + ". Problem description - " + sDescription + ". Contact " + sRequestorName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
				} else {
					sMessageKeyopEmail = ("There is a request from an end user for your printer service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " printer " + sDeviceName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " that has problem with " + sProblemsAll + ". Problem description - " + sDescription + ". Contact " + sRequestorName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
				}
				sMessageKeyop = (sRequestorName + " at " + sExtPhone + " requested service to " + sDeviceName + " (" + sSite + ", " + sBuilding + ", " + sFloor + ", " + sRoom + ") for " + sProblemsAll + ". (" + sDescription + ")");
				if (sMessageKeyop != null && !sMessageKeyop.equals("") && sMessageKeyop.length() > 160) {
					sMessageKeyop = sMessageKeyop.substring(0,160);
				}
				
		  // Send page to keyops
			boolean pageResult = false;
			try {
				if (dbResult == true) {
					pageResult = mail.sendPage(aPagers, sMessageKeyop);
				}
			} catch (Exception e) {
				System.out.println("Keyop error in RequestService.SubmitForm.3a ERROR: " + e);
				try {
					appTool.logError("RequestService.submitForm.3b","Keyop", e);
				} catch (Exception ex) {
					System.out.println("Keyop Error in RequestService.submitForm.3c ERROR: " + ex);
				}
	  		}
			// Send email to keyops
	  	   try { 
	  			if (dbResult == true) {
					if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C') ) {
						mail.sendMail(aEmails, "Request from end user for copier service on " + sSite + " printer " + sDeviceName, sMessageKeyopEmail);
					} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
						mail.sendMail(aEmails, "Request from end user for fax service on " + sSite + " printer " + sDeviceName, sMessageKeyopEmail);
					} else {
						mail.sendMail(aEmails, "Request from end user for printer service on " + sSite + " printer " + sDeviceName, sMessageKeyopEmail);
					}
	  			}
		  } catch (Exception e) {
		  		System.out.println("Keyop error in RequestService.SubmitForm.4a ERROR: " + e);
		  		try {
		   			appTool.logError("RequestService.submitForm.4b","Keyop", e);
		   		} catch (Exception ex) {
		   			System.out.println("Keyop Error in RequestService.submitForm.4c ERROR: " + ex);
		   		}
		  } 
		  
		  // Send email to user.
		  String sMessageUser = ""; 
		  try {
		  	if (dbResult == true) {
				if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C') ) {
					sMessageUser = ("Your Key Operator service request number " + iTicketNo + " has been received for copier " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Problem Description - " + sDescription + ". During business hours, a Key Operator will contact you within one hour. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
				} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
					sMessageUser = ("Your Key Operator service request number " + iTicketNo + " has been received for fax " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Problem Description - " + sDescription + ". During business hours, a Key Operator will contact you within one hour. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
				} else {
					sMessageUser = ("Your Key Operator service request number " + iTicketNo + " has been received for printer " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Problem Description - " + sDescription + ". During business hours, a Key Operator will contact you within one hour. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
				}
				bMailSent = mail.sendMail(sEmail, "Keyop ticket " + iTicketNo + " for " + sDeviceName + " received - " + sProblemsAll, sMessageUser);
		  	}
		  } catch (Exception e) {
		  		System.out.println("Keyop error in RequestService.SubmitForm.5a ERROR: " + e);
		  		bMailSent = false;
		  		try {
		   			appTool.logError("RequestService.submitForm.5b","Keyop", e);
		   		} catch (Exception ex) {
		   			System.out.println("Keyop Error in RequestService.submitForm.5c ERROR: " + ex);
		   		}
		  }
		  // Send email to CC list.
		  try {
		  	if (dbResult == true) {
				if (sCCEmail != null && sCCEmail != "" && !sCCEmail.equals("") && !sCCEmail.equals("null")) {
					if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C')) {
						sMessageUser = ("Your Key Operator service request number " + iTicketNo + " has been received for copier " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Problem Description - " + sDescription + ". During business hours, a Key Operator will contact you within one hour. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
					} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
						sMessageUser = ("Your Key Operator service request number " + iTicketNo + " has been received for fax " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Problem Description - " + sDescription + ". During business hours, a Key Operator will contact you within one hour. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
					} else {
						sMessageUser = ("Your Key Operator service request number " + iTicketNo + " has been received for printer " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Problem Description - " + sDescription + ". During business hours, a Key Operator will contact you within one hour. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
					}
					bMailSent2 = mail.sendMail(sCCEmail, "Keyop ticket " + iTicketNo + " for " + sDeviceName + " received - " + sProblemsAll, sMessageUser);
				}
		  	}
		  } catch (Exception e) {
		  		System.out.println("Keyop error in RequestService.SubmitForm.6a ERROR: " + e);
		  		bMailSent2 = false;
		  		try {
		   			appTool.logError("RequestService.submitForm.6b","Keyop", e);
		   		} catch (Exception ex) {
		   			System.out.println("Keyop Error in RequestService.SubmitForm.6c ERROR: " + ex);
		   		}
		  }
		  
		  try {	
		  	if (dbResult == false) {
		  		iReturnCode = 2;
		  	} else if (bMailSent == false) {
		  		iReturnCode = 1;
		  	} else {
		  		iReturnCode = 0;
		  	}
			
		  } catch(Exception e) {
		  		System.out.println("Keyop error in RequestService.SubmitForm.7a ERROR: " + e);
		  		try {
		   			appTool.logError("RequestService.submitForm.7b","Keyop", e);
		   		} catch (Exception ex) {
		   			System.out.println("Keyop Error in RequestService.SubmitForm.7c ERROR: " + ex);
		   		}
	      }
		  
		} else { // if duplicate ticket exists
						
			try {
				
			  	con = tool.getConnection();
				stmtRequest = con.createStatement();
				rsRequest = null;
				
				//Update ticket with description
				Timestamp tTimestamp = dateTime.getSQLTimestamp();
				stmtRequest.executeUpdate("INSERT INTO GPWS.KO_REQUEST_NOTES (NOTE, ADDED_BY, KEYOP_REQUESTID, DATE_TIME) VALUES ('**UPDATE: " + sDescription + "','" + sEmail + "'," + iDuplicate + ",'" + tTimestamp + "')");
				
				String req_email = "";
				String cc_email = "";
				rsRequest = stmtRequest.executeQuery("SELECT REQUESTOR_EMAIL, CC_EMAIL FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iDuplicate);
				while (rsRequest.next()) {
					req_email = tool.nullStringConverter(req_email = rsRequest.getString("REQUESTOR_EMAIL"));
					cc_email = tool.nullStringConverter(cc_email = rsRequest.getString("CC_EMAIL"));
				}
				
				// Make sure requestor isn't orginal requestor or on the cc email list.
				if (!sEmail.equals(req_email) && (cc_email == null || cc_email.equals("")) ) {
					stmtRequest.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET CC_EMAIL = '" + sEmail + "' WHERE KEYOP_REQUESTID = " + iDuplicate);
				} else if (!sEmail.equals(req_email) && (cc_email != null && cc_email.indexOf(sEmail) < 0)) {
					stmtRequest.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET CC_EMAIL = '" + cc_email + ";" + sEmail + "' WHERE KEYOP_REQUESTID = " + iDuplicate);
				}	
				
			  } catch (Exception e) {
			  		System.out.println("Keyop error in RequestService.SubmitForm.8a ERROR: " + e);
			  		dbResult = false;
			  		try {
			  			appTool.logError("RequestService.submitForm.8b","Keyop", e);
			   		} catch (Exception ex) {
			   			System.out.println("Keyop Error in RequestService.SubmitForm.8c ERROR: " + ex);
			   		}
			  } finally {
			  		try {
			  			if (rsRequest != null)
			  				rsRequest.close();
			  			if (stmtRequest != null)
			  				stmtRequest.close();
			  			if (con != null)
			  				con.close();
			  		} catch (Exception e){
				  		System.out.println("Keyop Error in RequestService.SubmitForm.8d ERROR: " + e);
			  		}
			  }
			  
			  // Send email to user
			  String sMessageUser = ""; 
			  try {
					if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C') ) {
						sMessageUser = ("We are already aware of the problem with copier " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Ticket " + iDuplicate + " was already open regarding this issue, but you have been added to the notification list to receive ticket status updates. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iDuplicate);
					} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
						sMessageUser = ("We are already aware of the problem with fax " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Ticket " + iDuplicate + " was already open regarding this issue, but you have been added to the notification list to receive ticket status updates. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iDuplicate);
					} else {
						sMessageUser = ("We are already aware of the problem with printer " + sDeviceName + " located in " + sSite + ", Building " + sBuilding + ", Floor " + sFloor + ", Room " + sRoom + ". Ticket " + iDuplicate + " was already open regarding this issue, but you have been added to the notification list to receive ticket status updates. To check the status of your request please visit\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iDuplicate);
					}
					bMailSent = mail.sendMail(sEmail, "Keyop ticket " + iDuplicate + " for " + sDeviceName + " received - " + sProblemsAll, sMessageUser);
			  } catch (Exception e) {
			  		System.out.println("Keyop error in RequestService.SubmitForm.9a ERROR: " + e);
			  		bMailSent = false;
			  		try {
			   			appTool.logError("RequestService.submitForm.9b","Keyop", e);
			   		} catch (Exception ex) {
			   			System.out.println("Keyop Error in RequestService.submitForm.9c ERROR: " + ex);
			   		}
			  }
			  
			  if (dbResult == true) {
			  	iReturnCode = 9;
			  } else {
			  	iReturnCode = 3;
			  }
			  iTicketNo = iDuplicate;
			  
			  String sMessageKeyopEmail = "";
			  String sMessageKeyop = "";
			  //Create message for page and email to be sent to keyop.
				if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C')) {
					sMessageKeyopEmail = ("There is a duplicate request from an end user for your copier service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " copier " + sDeviceName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " that has problem with " + sProblemsAll + ". Problem description - " + sDescription + ". Contact " + sRequestorName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
				} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
					sMessageKeyopEmail = ("There is a duplicate request from an end user for your fax service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " fax " + sDeviceName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " that has problem with " + sProblemsAll + ". Problem description - " + sDescription + ". Contact " + sRequestorName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
				} else {
					sMessageKeyopEmail = ("There is a duplicate request from an end user for your printer service. Please respond within one hour. Thanks. Ticket number " + iTicketNo + " is about " + sSite + " printer " + sDeviceName + " at building " + sBuilding + " floor " + sFloor + " room " + sRoom + " that has problem with " + sProblemsAll + ". Problem description - " + sDescription + ". Contact " + sRequestorName + " at " + sExtPhone + " or " + sTieLine + " for more information.");
				}
				sMessageKeyop = (sRequestorName + " at " + sExtPhone + " requested service to " + sDeviceName + " (" + sSite + ", " + sBuilding + ", " + sFloor + ", " + sRoom + ") for " + sProblemsAll + ". (" + sDescription + ")");
				if (sMessageKeyop != null && !sMessageKeyop.equals("") && sMessageKeyop.length() > 160) {
					sMessageKeyop = sMessageKeyop.substring(0,160);
				}
				
		  // Send page to keyops
			boolean pageResult = false;
			try {
				if (dbResult == true) {
					pageResult = mail.sendPage(aPagers, sMessageKeyop);
				}
			} catch (Exception e) {
				System.out.println("Keyop error in RequestService.SubmitForm.10a ERROR: " + e);
				try {
					appTool.logError("RequestService.submitForm.10b","Keyop", e);
				} catch (Exception ex) {
					System.out.println("Keyop Error in RequestService.submitForm.10c ERROR: " + ex);
				}
	  		}
			// Send email to keyops
	  	   try { 
	  			if (dbResult == true) {
					if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'c' || sDeviceName.charAt(5) == 'C') ) {
						mail.sendMail(aEmails, "Duplicate request from end user for copier service on " + sSite + " printer " + sDeviceName, sMessageKeyopEmail);
					} else if (sDeviceName != null && !sDeviceName.equals("") && (sDeviceName.charAt(5) == 'f' || sDeviceName.charAt(5) == 'F')) {
						mail.sendMail(aEmails, "Duplicate request from end user for fax service on " + sSite + " printer " + sDeviceName, sMessageKeyopEmail);
					} else {
						mail.sendMail(aEmails, "Duplicate request from end user for printer service on " + sSite + " printer " + sDeviceName, sMessageKeyopEmail);
					}
	  			}
		  } catch (Exception e) {
		  		System.out.println("Keyop error in RequestService.SubmitForm.11a ERROR: " + e);
		  		try {
		   			appTool.logError("RequestService.submitForm.11b","Keyop", e);
		   		} catch (Exception ex) {
		   			System.out.println("Keyop Error in RequestService.submitForm.11c ERROR: " + ex);
		   		}
		  } 
		}
		  
	  int[] iTemp = {iReturnCode, iTicketNo};
	  return iTemp;
	}
	
	/****************************************************************************************
	* checkDuplicate
	*****************************************************************************************/
	public int checkDuplicate(String sDeviceName, String[] sProblems) throws Exception {
				
		keyopTools tool = new keyopTools();
		Connection con = null;
		Statement stmtRequest = null;
		ResultSet rsCheckPrinter = null;
		
		int iDup = 0;
		
      try {  
      	con = tool.getConnection();
      	
      	stmtRequest = con.createStatement();
		rsCheckPrinter = stmtRequest.executeQuery("SELECT A.KEYOP_REQUESTID, B.PROBLEM_NAME FROM GPWS.KEYOP_REQUEST A, GPWS.KO_REQUEST_PROBLEMS B WHERE A.KEYOP_REQUESTID = B.KEYOP_REQUESTID AND REQ_STATUS != 'completed' AND LOWER(A.DEVICE_NAME) = '" + sDeviceName.toLowerCase() + "'");
		
		while (rsCheckPrinter.next()) {
			String sProblem = rsCheckPrinter.getString("PROBLEM_NAME");
			for (int x = 0; x < sProblems.length; x++) {
				if ( sProblem != null && (sProblem.equals(sProblems[x]))) { 
					iDup = rsCheckPrinter.getInt("KEYOP_REQUESTID");
				}
			}
		}	
      
      } catch(Exception e) {
      		System.out.println("Keyop error in RequestService.checkDuplicate ERROR: " + e);
      		try {
	   			tool.logError("RequestService.checkDuplicate", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in RequestService.checkDuplicate ERROR: " + ex);
	   		}
      }	finally {
	  		try {
	  			if (rsCheckPrinter != null)
	  				rsCheckPrinter.close();
	  			if (stmtRequest != null)
	  				stmtRequest.close();
	  			if (con != null)
	  				con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in RequestService.checkDuplicate.2 ERROR: " + e);
	  		}
	  }	// end finally
      
      return iDup;
		
	} // end method checkDuplicate
		
	/****************************************************************************************
	* DeviceLookup
	*****************************************************************************************/
	public void DeviceLookup(String sPrinterName) throws Exception {
				
		keyopTools tool = new keyopTools();
		Connection con = null;
		Statement stmtRequest = null;
		ResultSet rsRequest = null;
		ResultSet rsCheckPrinter = null;
		
      try {  
      	con = tool.getConnection();
      	
      	if (sPrinterName == null) {
      		sPrinterName = "";
      	}
      	
      	stmtRequest = con.createStatement();
		rsCheckPrinter = stmtRequest.executeQuery("SELECT DEVICE.IGS_KEYOP, DEVICE.STATUS, DEVICE.LOCID, DEVICE.COUNTRY FROM GPWS.DEVICE_VIEW DEVICE WHERE LOWER(DEVICE.DEVICE_NAME) = '" + sPrinterName.toLowerCase() + "'");
		
		String sStatus = "";
		while (rsCheckPrinter.next()) {
			isValidDevice = true;
			String sIGSKeyop = rsCheckPrinter.getString("IGS_KEYOP");
			sStatus = rsCheckPrinter.getString("STATUS");
			if ( (sIGSKeyop != null) && (sIGSKeyop.toUpperCase().equals("YES") || sIGSKeyop.toUpperCase().equals("Y") && (sStatus != null && sStatus.toUpperCase().equals("COMPLETED")) && isSupportedLocation(rsCheckPrinter.getString("COUNTRY")) == true) ){
				isSupportedDevice = true;
			}
		}
		
		if (isValidDevice != false || isSupportedDevice != false) {
			rsRequest = stmtRequest.executeQuery("SELECT DEVICEID, DEVICE_NAME, MODEL, SERIAL_NUMBER, E2E_CATEGORY, ROOM, FLOOR_NAME, BUILDING_NAME, BUILDINGID, BUILDING_TIER, CITY, CITYID FROM GPWS.DEVICE_VIEW DEVICE_VIEW WHERE LOWER(DEVICE_NAME) = '" + sPrinterName.toLowerCase() + "'");
	        
			while (rsRequest.next()) {
				iDeviceID = rsRequest.getInt("DEVICEID");
				sSite = rsRequest.getString("CITY");
				iCityID = rsRequest.getInt("CITYID");
				sBuilding = rsRequest.getString("BUILDING_NAME");
				iBuildingID = rsRequest.getInt("BUILDINGID");
				sFloor = rsRequest.getString("FLOOR_NAME");
				sRoom = rsRequest.getString("ROOM");
				sTier = rsRequest.getString("BUILDING_TIER");
				sDeviceType = rsRequest.getString("MODEL");
				sDeviceSerial = rsRequest.getString("SERIAL_NUMBER");
				sE2ECategory = rsRequest.getString("E2E_CATEGORY");
			}
		}
        
		if (isValidDevice != true || sStatus.equals("DELETED")) {
			sDeviceName2 = sPrinterName;
			sDeviceName = "not found";
		} else if (isSupportedDevice != true) {
			sDeviceName2 = sPrinterName;
			sDeviceName = "not supported";
		} else {
			sDeviceName = sPrinterName;
		}	
      
      } catch(Exception e) {
      		System.out.println("Keyop error in RequestService.PrinterLookup ERROR: " + e);
      		try {
	   			tool.logError("RequestService.PrinterLookup", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in RequestService.PrinterLookup ERROR: " + ex);
	   		}
      }	finally {
	  		try {
	  			if (rsRequest != null)
	  				rsRequest.close();
	  			if (rsCheckPrinter != null)
	  				rsCheckPrinter.close();
	  			if (stmtRequest != null)
	  				stmtRequest.close();
	  			if (con != null)
	  				con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in RequestService.PrinterLookup.2 ERROR: " + e);
	  		}
	  }	// end finally
		
	} // end method PrinterLookup
	
	/****************************************************************************************
	* isSupportedLocation
	*****************************************************************************************/
	public boolean isSupportedLocation(String sCountry) throws Exception {
				
		keyopTools tool = new keyopTools();
		Connection con = null;
		Statement stmtLoc = null;
		ResultSet rsLoc = null;
		boolean isSuppLoc = false;
		
      try {
    	  if (sCountry == null) {
    		  sCountry = "";
    	  }
    	  
    	  con = tool.getConnection();
    	  stmtLoc = con.createStatement();
    	  
    	  rsLoc = stmtLoc.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'KeyopSupportedCountries' AND UPPER(CATEGORY_VALUE1) LIKE '" + sCountry.toUpperCase() + "'");
    	  rsLoc.next();
    	  if (rsLoc.getInt("COUNT") > 0) {
    		  isSuppLoc = true;
    	  }
      
      } catch(Exception e) {
      		System.out.println("Keyop error in RequestService.isUSLocation ERROR: " + e);
      		try {
	   			tool.logError("RequestService.isUSLocation", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in RequestService.isUSLocation ERROR: " + ex);
	   		}
      }	finally {
	  		try {
	  			if (rsLoc != null)
	  				rsLoc.close();
	  			if (stmtLoc != null)
	  				stmtLoc.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in RequestService.isUSLocation.2 ERROR: " + e);
	  		}
	  }	// end finally
	
      return isSuppLoc;
      
	} // end method isSupportedLocation
	
	/****************************************************************************************
	* getTicketProblems
	*****************************************************************************************/
	public String getTicketProblems(Connection con, int iTicketNum) throws Exception {
		
		String sProblems = "";
		
		Statement stmt = null;
		ResultSet rs = null;
		keyopTools tool = new keyopTools();
		
      try {
      	
        stmt = con.createStatement();
		rs = stmt.executeQuery("SELECT PROBLEM_NAME FROM GPWS.KO_REQUEST_PROBLEMS WHERE KEYOP_REQUESTID = " + iTicketNum);
        
		int count = 0;
		while (rs.next()) {
			if (count == 0) {
				sProblems += rs.getString("PROBLEM_NAME");
			} else {
				sProblems += ", " + rs.getString("PROBLEM_NAME");
			}
		}
				
	   } catch(Exception e) {
	   		System.out.print("Keyop error in RequestService.getTicketProblems ERROR " + e);
	   		tool.logError("RequestService.getTicketProblems", e);
       } finally {
	   		try {
	   			if (rs != null)
	   				rs.close();
	   			if (stmt != null)
		   			stmt.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in RequestService.getTicketProblems.1 ERROR: " + e);
	   		}
 		}
		return sProblems;
	}
	
} // end class RequestService