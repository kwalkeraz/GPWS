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

/****************************************************************************************
 * KeyopTicket																			
 * 																						
 * Author: Joe Comfort				
 * Copyright IBM										
 * 																						
 * This class allows a keyop to assign a ticket to his or herself, add a note to a		
 * ticket, close a ticket, update materials, change to hold status, or change from hold
 * status.
 ****************************************************************************************/
public class KeyopTicket {
	
	/****************************************************************************************
	* ChangeTimeZone																			*
	*****************************************************************************************/
	public boolean ChangeTimeZone(HttpServletRequest req) throws Exception {
		
		PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		AppTools appTool = new AppTools();
		boolean dbResult = true;
		Connection con = null;
		Statement stmtKeyop = null;
		
		int iUserid = pupb.getUserID();
		String sLoginid = pupb.getUserLoginID();
		String sTimeZone = req.getParameter("timezone");
		String sOfficeStatus = req.getParameter("officestatus");
		int iBackup = Integer.parseInt(req.getParameter("backup"));
		String sAction = "";
		
	   try {
	   	
		con = appTool.getConnection();
		
		stmtKeyop = con.createStatement();
		if (iBackup == 0) {
			stmtKeyop.executeUpdate("UPDATE GPWS.USER SET TIME_ZONE = '" + sTimeZone + "', OFFICE_STATUS = '" + sOfficeStatus + "', BACKUPID = null WHERE USERID = " + iUserid);
		} else {
			stmtKeyop.executeUpdate("UPDATE GPWS.USER SET TIME_ZONE = '" + sTimeZone + "', OFFICE_STATUS = '" + sOfficeStatus + "', BACKUPID = " + iBackup + " WHERE USERID = " + iUserid);
		}
		
		pupb.setTimeZone(sTimeZone);
		
	   } catch (Exception e) {
	  		System.out.println("Keyop error in KeyopTicket.ChangeTimeZone ERROR1: " + e);
	  		dbResult = false;
	  		try {
	   			appTool.logError("KeyopTicket.ChangeTimeZone","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeTimeZone ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtKeyop != null)
	   				stmtKeyop.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.ChangeTimeZone.2 ERROR: " + e);
	   		}
 	   }
 	   
 	   try {
 	   		if (dbResult == true) {
				sAction = ("Successfully changed time zone to " + sTimeZone + ".");
 	   		} else {
				sAction = ("Attempted to change time zone to " + sTimeZone + " but failed due to a db2 error.");
 	   		} 
 	   		appTool.logUserAction(sLoginid, sAction, "Keyop");
 	   } catch (Exception e) {
			System.out.println("Keyop Error in KeyopTicket.ChangeTimeZone.3 ERROR: " + e);
 	   }
		
		return dbResult;
	}	
	
	
	/****************************************************************************************
	* AssignTo
	*****************************************************************************************/
	public int AssignTo(int iUserid, String sUserLoginid, int iTicketNo, HttpServletRequest req) throws Exception {
		
		boolean dbResult = true;
		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		int iReturnCode = 0;
		Connection con = null;
		Statement stmtAssign = null;
		String sAction = "";
		String sKeyopName = "";
				
	   try {
	   	
	   	sKeyopName = tool.returnUserInfo(iUserid, "last_first_name");
	   	
		con = appTool.getConnection();
		stmtAssign = con.createStatement();
		stmtAssign.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET REQ_STATUS = 'in progress', KEYOP_USERID = " + iUserid + ", KEYOP_NAME = '" + sKeyopName + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
		
		AddNote(iTicketNo + "", "Took ownership of ticket.", sUserLoginid, stmtAssign);
				
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket method AssignTo ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			tool.logError("KeyopTicket.AssignTo.1", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.AssignTo.1 ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtAssign != null)
	   				stmtAssign.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.AssignTo.2 ERROR: " + e);
	   		}
 	   }
	   
	  try { 
	   		if (dbResult == false) {
	   			iReturnCode = 1;
				sAction = ("Attempted to take ownership of ticket number " + iTicketNo + " but failed due to a db2 error.");
	   		} else {
	   			iReturnCode = 0;
				sAction = ("Successfully took ownership of ticket number " + iTicketNo + ".");
	   		}
	   
	   		appTool.logUserAction(sUserLoginid, sAction, "Keyop");
	   
	  } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.AssignTo ERROR2: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.AssignTo.2", "Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.AssignTo.2 ERROR: " + ex);
	   		}
	  }
	  
	  return iReturnCode;
	}
	
	/****************************************************************************************
	* AddNote
	*****************************************************************************************/
	public int AddNote(int iTicketNo, String sSolution, String sUserLoginid, HttpServletRequest req) throws Exception {	
		
	   	keyopTools tool = new keyopTools();
	   	AppTools appTool = new AppTools();
	   	SendMail mail = new SendMail();
	   	DateTime dateTime = new DateTime();
	   	Connection con = null;
	   	Statement stmtAddNote = null;
	   	ResultSet rsAddNote = null;
	   	
	    String sRequestedBy = null;
	   	String sNoteToAdd = "";
	   	boolean dbResult = true;
		boolean emailResult = true;
		boolean emailResult2 = true;
		String sCCEmail = null;
		int iReturnCode = 0;
		String sAction = "";
	   	
	   try {
		Timestamp tTimestamp = dateTime.getSQLTimestamp();
	   	con = appTool.getConnection();
		stmtAddNote = con.createStatement();
		rsAddNote = stmtAddNote.executeQuery("SELECT REQUESTOR_EMAIL, CC_EMAIL FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iTicketNo);
		
		while (rsAddNote.next()) {
			sRequestedBy = appTool.nullStringConverter(rsAddNote.getString("REQUESTOR_EMAIL"));
			sCCEmail = appTool.nullStringConverter(rsAddNote.getString("CC_EMAIL"));
		}

		sNoteToAdd = sSolution;
		stmtAddNote.executeUpdate("INSERT INTO GPWS.KO_REQUEST_NOTES (KEYOP_REQUESTID, NOTE, DATE_TIME, ADDED_BY) VALUES (" + iTicketNo + ", '" + tool.fixDBInputText(sNoteToAdd)  + "', '" + tTimestamp + "', '" + sUserLoginid + "')");
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.AddNote ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.AddNote.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.AddNote ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (rsAddNote != null)
	   				rsAddNote.close();
	   			if (stmtAddNote != null)
	   				stmtAddNote.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.AddNote.2 ERROR: " + e);
	   		}
 	   }
	
	   try {
		if (dbResult == true) {
			String sMessage = ("Ticket number " + iTicketNo + " has been updated by the keyop. The following note has been added.\n\nNote: " + sSolution + "\n\nYou can view more details regarding this ticket at the following address.\n\nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
			emailResult = mail.sendMail(sRequestedBy, "Keyop ticket " + iTicketNo + " has been updated", sMessage);
			if (sCCEmail != null && !sCCEmail.equals("") && !sCCEmail.equals("null")) {
				emailResult2 = mail.sendMail(sCCEmail, "Keyop ticket " + iTicketNo + " has been updated", sMessage);
			}
			
		} 

		if (dbResult == false) {
			iReturnCode = 3;
			sAction = ("Attempted to add note to ticket number " + iTicketNo + " but failed due to a db2 error.");
		} else if (emailResult == false) {
			iReturnCode = 2;
			sAction = ("Successfully added note to ticket number " + iTicketNo + " but failed to email customer.");
		} else {
			iReturnCode = 0;
			sAction = ("Successfully added note to ticket number " + iTicketNo + ".");
		}
		
		appTool.logUserAction(sUserLoginid, sAction, "Keyop");
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.AddNote ERROR2: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.AddNote.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.AddNote.2 ERROR: " + ex);
	   		}
	   }
	   
	   return iReturnCode;
	}
	
	/****************************************************************************************
	* AddNote2
	*****************************************************************************************/
	public int AddNote(String sTicketNo, String sNote, String sUserLoginid, Statement stmt) throws Exception {	
	
		int iRC = 0;
		
		try {
			keyopTools tool = new keyopTools();
			DateTime dateTime = new DateTime();
			Timestamp tTimestamp = dateTime.getSQLTimestamp();
			stmt.executeUpdate("INSERT INTO GPWS.KO_REQUEST_NOTES (KEYOP_REQUESTID, NOTE, DATE_TIME, ADDED_BY) VALUES (" + sTicketNo + ", '" + tool.fixDBInputText(sNote)  + "', '" + tTimestamp + "', '" + sUserLoginid + "')");
		} catch (Exception e) {
			iRC = 1;
			System.out.println("Keyop error in KeyopTicket.AddNote2 ERROR2: " + e);
		}
		
		return iRC;
	}
	
	/****************************************************************************************
	* CloseTicket																			*
	*****************************************************************************************/
	public int CloseTicket(String sUserLoginid, HttpServletRequest req) throws Exception{

		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		SendMail mail = new SendMail();
		DateTime dateTime = new DateTime();
		int iReturnCode = 0;
		int iTicketNo = 0;
		if (req.getParameter("ticketno") != null) {
			iTicketNo = Integer.parseInt(req.getParameter("ticketno"));
		}
	   	String sSolution = tool.fixDBInputText(req.getParameter("solution"));
	   			
		int iCloseCode = 0;
		if (req.getParameter("closecodeid") != null) {
			iCloseCode = Integer.parseInt(req.getParameter("closecodeid"));
		}
		String sCCEmail = "";
		String sRequestedBy = "";
		String sStatus = "";
		boolean dbResult = true;
		boolean emailResult = true;
		boolean emailResult2 = true;
		boolean alreadyClosed = false;
		Connection con = null;
		Statement stmtRequestedBy = null;
		Statement stmtClose = null;
		ResultSet rsRequestedBy = null;
		String sAction = "";

	  try {
	  	
	  	con = appTool.getConnection();
		stmtRequestedBy = con.createStatement();
		rsRequestedBy = stmtRequestedBy.executeQuery("SELECT REQUESTOR_EMAIL, KEYOP_USERID, CC_EMAIL, REQ_STATUS FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iTicketNo);
		
		while (rsRequestedBy.next()) {
			sRequestedBy = appTool.nullStringConverter(rsRequestedBy.getString("REQUESTOR_EMAIL"));
			sCCEmail = appTool.nullStringConverter(rsRequestedBy.getString("CC_EMAIL"));
			sStatus = appTool.nullStringConverter(rsRequestedBy.getString("REQ_STATUS"));
		}
		if (!sStatus.equals("completed")) {
			Timestamp tTimeClosed = dateTime.getSQLTimestamp();
			
			stmtClose = con.createStatement();
			stmtClose.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET REQ_STATUS = 'completed', TIME_FINISHED = '" + tTimeClosed + "', CLOSED_BY = '" + sUserLoginid + "', SOLUTION = '" + sSolution + "', CLOSE_CODEID = " + iCloseCode + " WHERE KEYOP_REQUESTID = " + iTicketNo);
			
			String sNoteToAdd = "Closed Ticket.";
			stmtClose.executeUpdate("INSERT INTO GPWS.KO_REQUEST_NOTES (KEYOP_REQUESTID, NOTE, DATE_TIME, ADDED_BY) VALUES (" + iTicketNo + ", '" + tool.fixDBInputText(sNoteToAdd)  + "', '" + tTimeClosed + "', '" + sUserLoginid + "')");
		} else {
			alreadyClosed = true;
		}

	  } catch (Exception e) {
	  		System.out.println("Keyop error in KeyopTicket.CloseTicket ERROR: " + e);
	  		dbResult = false;
	  		try {
	  			appTool.logError("KeyopTicket.CloseTicket.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.CloseTicket.2 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsRequestedBy != null)
	  				rsRequestedBy.close();
	  			if (stmtRequestedBy != null)
	  				stmtRequestedBy.close();
	  			if (stmtClose != null)
	  				stmtClose.close();
	  			if (con != null)
	  				con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in KeyopTicket.CloseTicket.3 ERROR: " + e);
	  		}
	  }
	
	  try {
	  	if (dbResult == true && !sStatus.equals("completed")) {
			String sMessage = ("Ticket number " + iTicketNo + " has been closed by the keyop\nResolution: " + sSolution + "\n\nYou can view the ticket information here: \nhttp://" + tool.getServerName() + tool.getKeyopServletPathCR() + "?next_page_id=2015&ticketno=" + iTicketNo);
			emailResult = mail.sendMail(sRequestedBy, "Keyop ticket " + iTicketNo + " has been closed", sMessage );
			if (sCCEmail != null && !sCCEmail.equals("") && !sCCEmail.equals("null")) {
				emailResult2 = mail.sendMail(sCCEmail, "Keyop ticket " + iTicketNo + " has been closed", sMessage );
			}
			sAction = ("Successfully closed ticket number " + iTicketNo + ".");
			
	  	} else {
			sAction = ("Attempted to close ticket number " + iTicketNo + " but failed due to a db2 error.");
			
	  	}
	  	
	  	appTool.logUserAction(sUserLoginid, sAction, "Keyop");

	  } catch (Exception e) {
	  		System.out.println("Keyop error in KeyopTicket.CloseTicket ERROR2: " + e);
	  		//emailResult = false;
	  		try {
	  			appTool.logError("KeyopTicket.CloseTicket.4","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.CloseTicket.4 ERROR: " + ex);
	   		}
	  }
	  
	  	if (alreadyClosed == true) {
	  		iReturnCode = 4;
	  	} else if (dbResult == false) {
			iReturnCode = 3;
		} else if (emailResult == false) {
			iReturnCode = 2;
		} else {
			iReturnCode = 0;
		}
	   
	   return iReturnCode;
	}
	
	/****************************************************************************************
	* UpdateTimes																			*
	*****************************************************************************************/
	public int UpdateTimes(HttpServletRequest req) throws Exception{
		
		PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sTimeZone = pupb.getTimeZone();
		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		DateTime dateTime = new DateTime();
		int iReturnCode = 0;
		String iTicketNo = req.getParameter("ticketno");
		String sCEReferralNum = appTool.nullStringConverter(req.getParameter("cerefnum"));
		String sHDReferralNum = appTool.nullStringConverter(req.getParameter("hdrefnum"));
		String sAction = "";
		String sUserLoginid = pupb.getUserLoginID();
				
		String sCustDate = req.getParameter("cusContDate");
		String sCustHour = req.getParameter("cusContHour");
		String sCustMinute  = req.getParameter("cusContMin");
		String sCustContacted = sCustDate + "-" + sCustHour + "." + sCustMinute + ".00.00";
				
		String sWorkStartDate = req.getParameter("workStartDate");
		String sWorkStartHour = req.getParameter("workStartHour");
		String sWorkStartMinute  = req.getParameter("workStartMin");
		String sKeyopTimeStart = (sWorkStartDate + "-" + sWorkStartHour + "." + sWorkStartMinute + ".00.00");
		
		String sWorkCompDate = req.getParameter("workCompDate");
		String sWorkCompHour = req.getParameter("workCompHour");
		String sWorkCompMinute  = req.getParameter("workCompMin");
		String sKeyopTimeFinish = (sWorkCompDate + "-" + sWorkCompHour + "." + sWorkCompMinute + ".00.00");
		
		String sCERefNumDate = req.getParameter("ceRefNumDate");
		String sCERefNumHour = req.getParameter("ceRefNumHour");
		String sCERefNumMinute  = req.getParameter("ceRefNumMin");
		String sCERefNumTS = (sCERefNumDate + "-" + sCERefNumHour + "." + sCERefNumMinute + ".00.00");
		
		String sHDRefNumDate = req.getParameter("hdRefNumDate");
		String sHDRefNumHour = req.getParameter("hdRefNumHour");
		String sHDRefNumMinute  = req.getParameter("hdRefNumMin");
		String sHDRefNumTS = (sHDRefNumDate + "-" + sHDRefNumHour + "." + sHDRefNumMinute + ".00.00");
				
		try {
			sCustContacted = dateTime.convertTimeZonetoUTC(sCustContacted, sTimeZone);
			sKeyopTimeStart = dateTime.convertTimeZonetoUTC(sKeyopTimeStart, sTimeZone);
			sKeyopTimeFinish = dateTime.convertTimeZonetoUTC(sKeyopTimeFinish, sTimeZone);
			sCERefNumTS = dateTime.convertTimeZonetoUTC(sCERefNumTS, sTimeZone);
			sHDRefNumTS = dateTime.convertTimeZonetoUTC(sHDRefNumTS, sTimeZone);
		} catch (Exception e) {
			System.out.println("Keyop error in KeyopTicket.UpdateTimes.1 ERROR: " + e);
			try {
				appTool.logError("KeyopTicket.UpdateTimes.1","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in KeyopTicket.UpdateTimes.1 ERROR: " + ex);
			}
		}

		String sCCEmail = null;
		
		String sRequestedBy = "";
		boolean dbResult = true;
		Connection con = null;
		Statement stmtRequestedBy = null;
		Statement stmtClose = null;
		ResultSet rsRequestedBy = null;

	  try {
		  
		con = appTool.getConnection();

		stmtRequestedBy = con.createStatement();
		rsRequestedBy = stmtRequestedBy.executeQuery("SELECT REQUESTOR_EMAIL, KEYOP_USERID, CC_EMAIL FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iTicketNo);
	
		while (rsRequestedBy.next()) {
			sRequestedBy = appTool.nullStringConverter(rsRequestedBy.getString("REQUESTOR_EMAIL"));
			sCCEmail = appTool.nullStringConverter(rsRequestedBy.getString("CC_EMAIL"));
		}
		  
		stmtClose = con.createStatement();
		int iCustCont = 99;
		int iKeyopTimeStart = 99;
		String sNote = "";
		if (dateTime.isValidTimeStamp(sCustContacted)) {
			iCustCont = stmtClose.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET CUSTOMER_CONTACTED = '" + sCustContacted + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
			sNote += "Customer Contacted, ";
		}
		  
		if (dateTime.isValidTimeStamp(sKeyopTimeStart)) {
			iKeyopTimeStart = stmtClose.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET KEYOP_TIME_START = '" + sKeyopTimeStart + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
			sNote += "Work Started, ";
		}
		  
		if (dateTime.isValidTimeStamp(sKeyopTimeFinish)) {
			stmtClose.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET KEYOP_TIME_FINISH = '" + sKeyopTimeFinish + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
			sNote += "Work Completed, ";
		}

		if (dateTime.isValidTimeStamp(sCERefNumTS)) {
			stmtClose.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET CE_REFERRAL_DATE = '" + sCERefNumTS + "', CE_REFERRAL_NUM = '" + sCEReferralNum + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
			sNote += "CE Referral Number and Date, ";
		}

		if (dateTime.isValidTimeStamp(sHDRefNumTS)) {
			stmtClose.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET HD_REFERRAL_DATE = '" + sHDRefNumTS + "', HD_REFERRAL_NUM = '" + sHDReferralNum + "' WHERE KEYOP_REQUESTID = " + iTicketNo);
			sNote += "Helpdesk Referral Number and Date, ";
		}

		AddNote(iTicketNo + "", "The following times were updated: " + sNote, sUserLoginid, stmtClose);
		  
	  } catch (Exception e) {
			System.out.println("Keyop error in KeyopTicket.UpdateTimes ERROR: " + e);
			dbResult = false;
			try {
				appTool.logError("KeyopTicket.UpdateTimes.2","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in KeyopTicket.UpdateTimes.2 ERROR: " + ex);
			}
	  } finally {
			try {
				if (rsRequestedBy != null)
					rsRequestedBy.close();
				if (stmtRequestedBy != null)
					stmtRequestedBy.close();
				if (stmtClose != null)
					stmtClose.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in KeyopTicket.UpdateTimes.3 ERROR: " + e);
			}
	  }

	  try {
		if (dbResult == true) {
			sAction = ("Successfully updated times and referrals on ticket number " + iTicketNo + ".");
		} else {
			sAction = ("Attempted to update times and referrals on ticket number " + iTicketNo + " but failed due to a db2 error.");
		}
		
		appTool.logUserAction(sUserLoginid, sAction, "Keyop");
		
	  } catch (Exception e) {
			System.out.println("Keyop error in KeyopTicket.UpdateTimes ERROR2: " + e);
			try {
				appTool.logError("KeyopTicket.UpdateTimes.4","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in KeyopTicket.UpdateTimes.4 ERROR: " + ex);
			}
	  }
	  
		if (dbResult == false) {
			iReturnCode = 3;
		} else {
			iReturnCode = 0;
		}
   
	   return iReturnCode;
	
	}
	
	/****************************************************************************************
	* UpdateMaterials																		*
	*****************************************************************************************/
	public int UpdateMaterials(String sUserLoginid, HttpServletRequest req) throws Exception {	
		
	   	AppTools appTool = new AppTools();
	   	String sTicketNo = req.getParameter("ticketno");

	   	String[] aSuppliesReplaced = req.getParameterValues("suppliesReplaced");
		String[] aSuppliesReplacedCurrent = req.getParameterValues("suppliesReplacedCurrent");
		String[] aPartsReplaced = req.getParameterValues("partsReplaced");
		String[] aPartsAdded = req.getParameterValues("partsAdded");
		String[] aPartsReplacedCurrent = req.getParameterValues("partsReplacedCurrent");
		String[] aPartsAddedCurrent = req.getParameterValues("partsAddedCurrent");
		String sPartsReplacedOther = req.getParameter("partsReplacedOther");
		String sBondReqNum = req.getParameter("bondreqnum");
		String sAction = "";
		String sNoteToAdd = "";
		String sNote = "";

	   	boolean dbResult = true;
		int iReturnCode = 0;
		Connection con = null;
		Statement stmtUpdate = null;

	   try {
	   	con = appTool.getConnection();
		stmtUpdate = con.createStatement();
		
		if (aSuppliesReplacedCurrent != null) {
    		for(int i = 0; i < aSuppliesReplacedCurrent.length; i++){
     	 		stmtUpdate.executeUpdate("DELETE FROM GPWS.KO_REQUEST_SUPPLIES WHERE KO_REQUEST_SUPPLYID = " + Integer.parseInt(aSuppliesReplacedCurrent[i]));
    		}
		}
					
		if (aSuppliesReplaced != null) {
			for(int i = 0; i < aSuppliesReplaced.length; i++){
  	    		stmtUpdate.executeUpdate("INSERT INTO GPWS.KO_REQUEST_SUPPLIES (KEYOP_REQUESTID, SUPPLY_NAME) VALUES (" + sTicketNo + ", '" + aSuppliesReplaced[i] + "')");
  	    		sNote += aSuppliesReplaced[i] + ", ";
  		  	}
		}
		
		if (aPartsReplacedCurrent != null) {
    		for(int i = 0; i < aPartsReplacedCurrent.length; i++){
     	 		stmtUpdate.executeUpdate("DELETE FROM GPWS.KO_REQUEST_PARTS WHERE KO_REQUEST_PARTSID = " + Integer.parseInt(aPartsReplacedCurrent[i]));
    		}
	   	}

		if (aPartsReplaced != null) {
			for(int i = 0; i < aPartsReplaced.length; i++){
	      		stmtUpdate.executeUpdate("INSERT INTO GPWS.KO_REQUEST_PARTS (KEYOP_REQUESTID, PART_NAME, SERVICE_ACTION_TYPE) VALUES (" + sTicketNo + ", '" + aPartsReplaced[i] + "', 'replaced')");
	      		sNote += aPartsReplaced[i] + ", ";
	    	}
		}
		
		if (aPartsAddedCurrent != null) {
	    	for(int i = 0; i < aPartsAddedCurrent.length; i++){
	      		stmtUpdate.executeUpdate("DELETE FROM GPWS.KO_REQUEST_PARTS WHERE KO_REQUEST_PARTSID = " + Integer.parseInt(aPartsAddedCurrent[i]));
	    	}
		}

		if (aPartsAdded != null) {
	    	for(int i = 0; i < aPartsAdded.length; i++){
	      		stmtUpdate.executeUpdate("INSERT INTO GPWS.KO_REQUEST_PARTS (KEYOP_REQUESTID, PART_NAME, SERVICE_ACTION_TYPE) VALUES (" + sTicketNo + ", '" + aPartsAdded[i] + "', 'added')");
	      		sNote += aPartsAdded[i] + ", ";
	    	}
		}

		if (sBondReqNum == null) {
			sBondReqNum = "";
		} 
		stmtUpdate.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET BOND_REQ_NUM = '" + sBondReqNum + "' WHERE KEYOP_REQUESTID = " + sTicketNo);
		
		if (sNote == "") {
			sNoteToAdd = "Updated parts and supplies.";
		} else {
			sNoteToAdd = "Replaced the following parts and supplies: " + sNote;
		}
		
		AddNote(sTicketNo, sNoteToAdd, sUserLoginid, stmtUpdate);
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.UpdateMaterials ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.UpdateMaterials.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.UpdateMaterials.1 ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtUpdate != null)
	   				stmtUpdate.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.UpdateMaterials.2 ERROR: " + e);
	   		}
 	   }

	   try { 

		if (dbResult == false) {
			iReturnCode = 2;
			sAction = ("Attempted to update materials on ticket number " + sTicketNo + " but failed due to a db2 error.");
		} else {
			iReturnCode = 0;
			sAction = ("Successfully updated materials on ticket number " + sTicketNo);
		}
		
		appTool.logUserAction(sUserLoginid, sAction, "Keyop");
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.UpdateMaterials ERROR2: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.UpdateMaterials.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.UpdateMaterials.2 ERROR: " + ex);
	   		}
	   }
	   return iReturnCode;
	}
	
	/****************************************************************************************
	* AddPO
	*****************************************************************************************/
	public int AddPO(String sUserLoginid, HttpServletRequest req) throws Exception {	
		
	   	AppTools appTool = new AppTools();
	   	DateTime dateTime = new DateTime();
	   	Connection con = null;
	   	Statement stmtAddPO = null;
	   	
	   	PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sTimeZone = pupb.getTimeZone();

	   	boolean dbResult = true;
		boolean emailResult = true;
		boolean emailResult2 = true;
		String sCCEmail = null;
		int iReturnCode = 0;
		String sAction = "";
		String sPONumber = appTool.nullStringConverter(req.getParameter("ponumber"));
		String sPODate = appTool.nullStringConverter(req.getParameter("podate"));
		String sTicketNo = appTool.nullStringConverter(req.getParameter("ticketno"));
		
		sPODate = dateTime.convertTimeZonetoUTC(sPODate, sTimeZone);
	   	
	   try {
	   	con = appTool.getConnection();
	   	stmtAddPO = con.createStatement();
	   	stmtAddPO.executeUpdate("INSERT INTO GPWS.KO_REQUEST_PURCHASE_ORDER (PURCHASE_ORDER_NUMBER, PURCHASE_ORDER_DATE, KEYOP_REQUESTID) VALUES ('" + sPONumber + "','" + sPODate + "'," + sTicketNo + ")");
	   	
		AddNote(sTicketNo, "Added purchase order to ticket.", sUserLoginid, stmtAddPO);
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.AddPO ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.AddPO.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.AddPO ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtAddPO != null)
	   				stmtAddPO.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.AddPO.2 ERROR: " + e);
	   		}
 	   }
	
	   try {

		if (dbResult == false) {
			iReturnCode = 1;
			sAction = ("Attempted to add purchase order to ticket number " + sTicketNo + " but failed due to a db2 error.");
		} else {
			iReturnCode = 0;
			sAction = ("Successfully added purchase order to ticket number " + sTicketNo + ".");
		}
		
		appTool.logUserAction(sUserLoginid, sAction, "Keyop");
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.AddPO ERROR2: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.AddPO.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.AddPO.2 ERROR: " + ex);
	   		}
	   }
	   
	   return iReturnCode;
	}
	
	/****************************************************************************************
	* EditPO
	*****************************************************************************************/
	public int EditPO(String sUserLoginid, HttpServletRequest req) throws Exception {	
		
	   	AppTools appTool = new AppTools();
	   	DateTime dateTime = new DateTime();
	   	Connection con = null;
	   	Statement stmtAddPO = null;
	   	
	   	PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
		String sTimeZone = pupb.getTimeZone();

	   	boolean dbResult = true;
		String sCCEmail = null;
		int iReturnCode = 0;
		String sAction = "";
		String sPONumber = appTool.nullStringConverter(req.getParameter("ponumberMOD"));
		String sPODate = appTool.nullStringConverter(req.getParameter("podate"));
		String sTicketNo = appTool.nullStringConverter(req.getParameter("ticketno"));
		String sPOID = req.getParameter("poid");
		
		sPODate = dateTime.convertTimeZonetoUTC(sPODate, sTimeZone);
	   	
	   try {
	   	con = appTool.getConnection();
	   	stmtAddPO = con.createStatement();
	   	stmtAddPO.executeUpdate("UPDATE GPWS.KO_REQUEST_PURCHASE_ORDER SET (PURCHASE_ORDER_NUMBER, PURCHASE_ORDER_DATE, KEYOP_REQUESTID) = ('" + sPONumber + "','" + sPODate + "'," + sTicketNo + ") WHERE KO_REQUEST_PURCHASE_ORDERID = " + sPOID);
	   	
	   	AddNote(sTicketNo, "Edited purchase order.", sUserLoginid, stmtAddPO);
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.EditPO ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.EditPO.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.EditPO ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtAddPO != null)
	   				stmtAddPO.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.EditPO.2 ERROR: " + e);
	   		}
 	   }
	
	   try {

		if (dbResult == false) {
			iReturnCode = 1;
			sAction = ("Attempted to edit purchase order to ticket number " + sTicketNo + " but failed due to a db2 error.");
		} else {
			iReturnCode = 0;
			sAction = ("Successfully edited purchase order on ticket number " + sTicketNo + ".");
		}
		
		appTool.logUserAction(sUserLoginid, sAction, "Keyop");
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.EditPO ERROR2: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.EditPO.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.EditPO.2 ERROR: " + ex);
	   		}
	   }
	   
	   return iReturnCode;
	}
	
	/****************************************************************************************
	* ChangeToHoldStatus
	*****************************************************************************************/
	public int ChangeToHoldStatus(int iUserid, String sUserLoginid, HttpServletRequest req) throws Exception {
		
		boolean dbResult = true;
		int iTicketNo = 0;
		if (req.getParameter("ticketno") != null && !req.getParameter("ticketno").equals("")) {
			iTicketNo = Integer.parseInt(req.getParameter("ticketno"));
		}
		String sNote = req.getParameter("holdtextvalue");
		String sNoteToAdd = "";
		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		DateTime dateTime = new DateTime();
		Timestamp tTimestamp = dateTime.getSQLTimestamp();
		Connection con = null;
		Statement stmtAddNote = null;
		Statement stmtAssign = null;
		Statement stmtAssign2 = null;
		int iReturnCode = 0;
		String sAction = "";
		
	   try {
		con = appTool.getConnection();
		stmtAssign2 = con.createStatement();
		stmtAssign2.executeUpdate("INSERT INTO GPWS.KO_REQUEST_HOLDTIMES (KEYOP_REQUESTID, STATUS, TIME_ON_HOLD) VALUES (" + iTicketNo + ", 'hold', '" + tTimestamp + "')");
		
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.ChangeToHoldStatus ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.ChangeToHoldStatus.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.1 ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtAssign2 != null)
	   				stmtAssign2.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.2 ERROR: " + e);
	   		}
 	   }
	   try {
			if (dbResult == true) {
				sNoteToAdd = ("Put ticket on hold for " + sNote);
				con = appTool.getConnection();
				stmtAddNote = con.createStatement();
				stmtAddNote.executeUpdate("INSERT INTO GPWS.KO_REQUEST_NOTES (KEYOP_REQUESTID, NOTE, DATE_TIME, ADDED_BY) VALUES (" + iTicketNo + ", '" + tool.fixDBInputText(sNoteToAdd)  + "', '" + tTimestamp + "', '" + sUserLoginid + "')");
			}
		} catch (Exception e) {
			System.out.println("Keyop error in KeyopTicket.ChangeToHoldStatus ERROR: " + e);
			try {
			  tool.logError("KeyopTicket.ChangeToHoldStatus.1", e);
			} catch (Exception ex) {
			  System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.1 ERROR: " + ex);
			}
		} finally {
			try {
				if (stmtAddNote != null)
					stmtAddNote.close();
				if (con != null)
					con.close();
			} catch (Exception e){
		  		System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.2 ERROR: " + e);
			}
		}
	   try {
	   	if (dbResult == true) {
	   		con = appTool.getConnection();
			stmtAssign = con.createStatement();
			stmtAssign.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET REQ_STATUS = 'HOLD' WHERE KEYOP_REQUESTID = " + iTicketNo);
	   	}
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.ChangeToHoldStatus ERROR: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.ChangeToHoldStatus.3","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.3 ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtAssign != null)
	   				stmtAssign.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.4 ERROR: " + e);
	   		}
 	   }
	   
	   
	  try { 
	   if (dbResult == false) {
	   		iReturnCode = 1;
			sAction = ("Attempted to change ticket number " + iTicketNo + " to hold status, but failed due to a db2 error.");
	   } else {
	   		iReturnCode = 0;
			sAction = ("Successfully changed ticket number " + iTicketNo + " to hold status.");
	   }
	   
	   appTool.logUserAction(sUserLoginid, sAction, "Keyop");
	   		
	  } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.ChangeToHoldStatus ERROR5: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.ChangeToHoldStatus.5","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeToHoldStatus.5 ERROR: " + ex);
	   		}
	  }
	  return iReturnCode;
	}
	
	/****************************************************************************************
	* ChangeFromHoldStatus																	
	*****************************************************************************************/
	public int ChangeFromHoldStatus(int iUserid, String sUserLoginid, HttpServletRequest req) throws Exception {
		
		boolean dbResult = true;
		int iTicketNo = Integer.parseInt(req.getParameter("ticketno"));
		keyopTools tool = new keyopTools();
		AppTools appTool = new AppTools();
		DateTime dateTime = new DateTime();
		Timestamp tTimestamp = dateTime.getSQLTimestamp();
		Connection con = null;
		Statement stmtHold3 = null;
		Statement stmtHold2 = null;
		Statement stmtAddNote = null;
		int iReturnCode = 0;
		String sAction = "";

	  try {
		con = appTool.getConnection();
		stmtHold3 = con.createStatement();
		stmtHold3.executeUpdate("UPDATE GPWS.KO_REQUEST_HOLDTIMES SET TIME_OFF_HOLD = '" + tTimestamp + "' WHERE TIME_OFF_HOLD IS NULL AND KEYOP_REQUESTID = " + iTicketNo);

	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.ChangeFromHoldStatus ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.ChangeFromHoldStatus.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.1 ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtHold3 != null)
	   				stmtHold3.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.2 ERROR: " + e);
	   		}
 	   }
	   
	   try {
	   	if (dbResult == true) {
	   		con = appTool.getConnection();
			stmtHold2 = con.createStatement();
			stmtHold2.executeUpdate("UPDATE GPWS.KEYOP_REQUEST SET REQ_STATUS = 'in progress' WHERE KEYOP_REQUESTID = " + iTicketNo);
		}
	   } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.ChangeFromHoldStatus ERROR: " + e);
	   		dbResult = false;
	   		try {
	   			appTool.logError("KeyopTicket.ChangeFromHoldStatus.2","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.2 ERROR: " + ex);
	   		}
	   } finally {
	   		try {
	   			if (stmtHold2 != null)
	   				stmtHold2.close();
	   			if (con != null)
	   				con.close();
	   		} catch (Exception e){
		   		System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.2 ERROR: " + e);
	   		}
 	   }
 	   String sNoteToAdd = "";
	   try {
		if (dbResult == true) {
			sNoteToAdd = ("Ticket taken off hold.");
			con = tool.getConnection();
			stmtAddNote = con.createStatement();
			stmtAddNote.executeUpdate("INSERT INTO GPWS.KO_REQUEST_NOTES (KEYOP_REQUESTID, NOTE, DATE_TIME, ADDED_BY) VALUES (" + iTicketNo + ", '" + tool.fixDBInputText(sNoteToAdd)  + "', '" + tTimestamp + "', '" + sUserLoginid + "')");
		
		 }
		} catch (Exception e) {
			System.out.println("Keyop error in KeyopTicket.ChangeFromHoldStatus ERROR: " + e);
			try {
				appTool.logError("KeyopTicket.ChangeToHoldStatus.1","Keyop", e);
			} catch (Exception ex) {
			   System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.1 ERROR: " + ex);
			}
		} finally {
		   try {
		   		if (stmtAddNote != null)
		   			stmtAddNote.close();
		   		if (con != null)
		   			con.close();
		   } catch (Exception e){
			   System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.2 ERROR: " + e);
		   }
		}
	   
	  try { 
	   if (dbResult == false) {
	   		req.setAttribute("result", "false");
	   		iReturnCode = 1;
			sAction = ("Attempted to change ticket number " + iTicketNo + " back to in progress status, but failed due to a db2 error.");
	   } else {
	   		req.setAttribute("result", "true");
	   		iReturnCode = 0;
			sAction = ("Successfully changed ticket number " + iTicketNo + " back to in progress status.");
	   }
	   
	   appTool.logUserAction(sUserLoginid, sAction, "Keyop");
	   
	  } catch (Exception e) {
	   		System.out.println("Keyop error in KeyopTicket.ChangeFromHoldStatus ERROR2: " + e);
	   		try {
	   			appTool.logError("KeyopTicket.ChangeFromHoldStatus.3","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in KeyopTicket.ChangeFromHoldStatus.3 ERROR: " + ex);
	   		}
	  }
	  
	  return iReturnCode;
	}
}