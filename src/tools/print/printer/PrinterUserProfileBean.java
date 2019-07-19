/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.sql.Connection;
import java.sql.*;

 /**
   * Keeps track of printer user information such as whether they are a printer admin.
   *
   * @author VHD Team May 2002
   */

public class PrinterUserProfileBean {
   // users userid - employee number
   private int userid = 0;
   // users first name
   private String firstname = null;
   // users last name
   private String lastname = null;
   // users phone number
   private String phone = null;
   // users email address
   private String email = null;
   // users pager number
   private String pager = "";
   // users time zone
   private String timezone = "";
   // users office status
   private String officestatus = "";
   // users backupid
   private int backupid = 0;
   // users vendorid
   private int vendorid = 0;
   // comment string
   private String comment = null;
   // the user id (what they log in with)
   private String loginid = null;
   // access the user has
   private String[] access = null;
   private String[] authTypes = null;
   private boolean validUser = false;
   private boolean validSession = false;
   
   // following variables used in IP Range and IP validation rules
   private boolean correctIPRange = true;
   private String msgIPRange = null;
   private boolean correctIP = true;
   private String msgIP = null;

    /** constructor */
   public PrinterUserProfileBean() {
      // maybe some database calls here to query the user info
   }

   public void setUserID( int i ) { this.userid = i; }
   public int getUserID() { return this.userid; }
   public void setUserFirstName( String s ) { this.firstname = s; }
   public String getUserFirstName() { return this.firstname; }
   public void setUserLastName( String s ) { this.lastname = s; }
   public String getUserLastName() { return this.lastname; }
   public void setPhone( String s ) { this.phone = s; }
   public String getPhone() { return this.phone; }
   public void setEmail( String s ) { this.email = s; }
   public String getEmail() { return this.email; }
   public void setPager( String s ) { this.pager = s; }
   public String getPager() { return this.pager; }
   public void setTimeZone( String s ) { this.timezone = s; }
   public String getTimeZone() { return this.timezone; }
   public void setOfficeStatus( String s ) { this.officestatus = s; }
   public String getOfficeStatus() { return this.officestatus; }
   public void setBackupID( int i ) { this.backupid = i; }
   public int getBackupID() { return this.backupid; }
   public void setVendorID( int i ) { this.vendorid = i; }
   public int getVendorID() { return this.vendorid; }
   public void setComment( String s ) { this.comment = s; }
   public String getComment() { return this.comment; }
   
   public String getUserLoginID() { return this.loginid; }
   public void setUserLoginID( String s ) { this.loginid = s; }
   public Boolean getValidUser() { return new Boolean(this.validUser); }
   public void setValidUser( boolean b ) { this.validUser = b; }
   public Boolean getValidSession() { return new Boolean(this.validSession); }
   public void setValidSession( boolean b ) { this.validSession = b; }
   
   public void setAccess(int i) { this.access = getUserAccess(i); }
   public Boolean getAccess(String accessType) { return new Boolean(isValidAccess(accessType)); }
   
   public void setAuthTypes(int i) { this.authTypes = getUserAuthTypes(i); }
   public String[] getAuthTypes() { return this.authTypes; }

   // following methods used in IP Range validation rules
   public Boolean getCorrectIPRange() { return new Boolean(this.correctIPRange); }
   public void setCorrectIPRange( boolean b ) { this.correctIPRange = b; }

   public void setMsgIPRange( String s ) { this.msgIPRange = s; }
   public String getMsgIPRange() { return this.msgIPRange; }

   public Boolean getCorrectIP() { return new Boolean(this.correctIP); }
   public void setCorrectIP( boolean b ) { this.correctIP = b; }

   public void setMsgIP( String s ) { this.msgIP = s; }
   public String getMsgIP() { return this.msgIP; }
   
   
   // getUserAccess gets all of the auth types for the specified user
   public String[] getUserAccess(int userid) {
   	String[] userAccess = new String[100];
   	Connection con = null;
   	//Statement stmtUser = null;
   	PreparedStatement stmtUser = null;
   	ResultSet rsUser = null;
   	PrinterTools tool = new PrinterTools();
   	int count = 0;
   	
   	try {
   		con = tool.getConnection();
   		stmtUser = con.prepareStatement("SELECT ACTION_TYPE FROM GPWS.AUTH_ACTION WHERE AUTH_ACTIONID IN (SELECT AUTH_ACTIONID FROM GPWS.AUTH_TYPE_ACTION WHERE AUTH_TYPEID IN (SELECT AUTH_TYPEID FROM GPWS.USER_AUTH_TYPE WHERE USERID = ?))");
   		stmtUser.setInt(1,userid);
   		rsUser = stmtUser.executeQuery();
   		
   		while (rsUser.next()) {
   			userAccess[count] = rsUser.getString("ACTION_TYPE");
   			count++;
   		}
   		
   	} catch (Exception e) {
   		System.out.println("Error in PrinterUserProfileBean ERROR: " + e);
   	} finally {
   		try {
   			if (rsUser != null)
   	   			rsUser.close();
   	   		if (stmtUser != null)
   	   			stmtUser.close();
   	   		if (con != null)
   	   			con.close();
   		} catch (Exception e) {
   			System.out.println("Error closing connections in PrinterUserProfileBean ERROR: " + e);
   		}
   	}
   	
   	return userAccess;
   }
   
// userAuthType gets all of the auth types for the specified user
   public String[] getUserAuthTypes(int userid) {
   	Connection con = null;
   	PreparedStatement stmtUser = null;
   	PreparedStatement stmtGroup = null;
   	ResultSet rsUser = null;
   	ResultSet rsGroup = null;
   	PrinterTools tool = new PrinterTools();
   	int count = 0;
   	int counter = 0;
   	// First, get the number of different auth groups available
   	try {
   		con = tool.getConnection();
   		stmtGroup = con.prepareStatement("SELECT DISTINCT AUTH_GROUP FROM GPWS.USER_AUTH_TYPE UAT, GPWS.AUTH_TYPE AT WHERE UAT.AUTH_TYPEID = AT.AUTH_TYPEID AND UAT.USERID = ? ORDER BY AUTH_GROUP");
   		stmtGroup.setInt(1,userid);
   		rsGroup = stmtGroup.executeQuery();
   		
   		while (rsGroup.next()) {
   			counter++;
   		}
   		
   	} catch (Exception e) {
   		System.out.println("Error in PrinterUserProfileBean.getUserAuthTypes ERROR: " + e);
   	} finally {
   		try {
   			if (rsGroup != null)
   	   			rsGroup.close();
   	   		if (stmtGroup != null)
   	   			stmtGroup.close();
   	   		if (con != null)
   	   			con.close();
   		} catch (Exception e) {
   			System.out.println("Error closing connections in PrinterUserProfileBean.getUserAuthTypes ERROR: " + e);
   		}
   	}
   	// End of auth groups
   	
   	//Set the array to those groups, remember, only one authentication per group
   	if (counter == 0) {
   		counter = 10; //set the counter to some global value, 10 is the eyeball #
   	}
   	String[] userAuthType = new String[counter];
   	
   	try {
   		con = tool.getConnection();
   		stmtUser = con.prepareStatement("SELECT UAT.USER_AUTH_TYPEID, UAT.AUTH_TYPEID, UAT.USERID, AT.AUTH_NAME, AT.DESCRIPTION, AT.AUTH_GROUP FROM GPWS.USER_AUTH_TYPE UAT, GPWS.AUTH_TYPE AT WHERE UAT.AUTH_TYPEID = AT.AUTH_TYPEID AND UAT.USERID = ? ORDER BY AUTH_GROUP");
   		stmtUser.setInt(1,userid);
   		rsUser = stmtUser.executeQuery();
   		
   		while (rsUser.next()) {
   			userAuthType[count] = rsUser.getString("AUTH_NAME");
   			count++;
   		}
   		
   	} catch (Exception e) {
   		System.out.println("Error in PrinterUserProfileBean.getUserAuthTypes ERROR: " + e);
   	} finally {
   		try {
   			if (rsUser != null)
   	   			rsUser.close();
   	   		if (stmtUser != null)
   	   			stmtUser.close();
   	   		if (con != null)
   	   			con.close();
   		} catch (Exception e) {
   			System.out.println("Error closing connections in PrinterUserProfileBean.getUserAuthTypes ERROR: " + e);
   		}
   	}
   	
   	return userAuthType;
   }
   
   public boolean isValidAccess(String accessType) {
   	
   	boolean isValid = false;
   	if (access != null) {
   		for (int i = 0; i < this.access.length; i++) {
   			if (accessType.equals(access[i])) {
   				isValid = true;
   				break;
   			}
   		}
   	}
   	
   	return isValid;
   }
}