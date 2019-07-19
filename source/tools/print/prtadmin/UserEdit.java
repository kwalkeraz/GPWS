/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.prtadmin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import tools.print.lib.AppTools;
import tools.print.printer.PrinterTools;
;

public class UserEdit {
	
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.printer.PrinterTools");
	
	/********************************************************************************************
	* insertUser
	*
	* This method takes 1 argument, an HttpServletRequest, and inserts a user into the database
	********************************************************************************************/
	public int insertUser(HttpServletRequest req) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		PrinterTools ptool = new PrinterTools();
		Connection con = null;
		PreparedStatement psUser = null;
		PreparedStatement psUserID = null;
		ResultSet rsUser = null;
		ResultSet rsUserID = null;
		//Get the original values
		String firstname = req.getParameter("firstname");
		String lastname = req.getParameter("lastname");
		String loginid = req.getParameter("loginid");
		String email = req.getParameter("email");
		String pager = req.getParameter("pager");
		int vendorid = Integer.parseInt(req.getParameter("vendor"));
		String userpasswd = req.getParameter("userpasswd");
		userpasswd = tool.nullStringConverter(userpasswd);
		String timezone = req.getParameter("timezone");
		if (timezone.equals("0")) {
			timezone = null;
		}
		String officestatus = req.getParameter("officestatus");
		if (officestatus == null) {
			officestatus = "";
		}
		String backup = req.getParameter("backupid");
		if (backup.equals("-1")) {
			backup = null;
		}
		int sMessage = 0;
		boolean dbResult = true;
		
	  try {
	  	con = tool.getConnection();
	  	//String sEncryptPW = myResources.getString("encryptPass");
	  	String sEncryptPW = ptool.getEncryptPass();
	  	String encrpwd = "SET ENCRYPTION PASSWORD = '" + sEncryptPW + "'";
	  	psUser = con.prepareStatement(encrpwd);
	  	psUser.execute();
		String sqlInsertQuery = "INSERT INTO GPWS.USER (FIRST_NAME, LAST_NAME, LOGINID, EMAIL, PAGER, PASSWORD, TIME_ZONE, OFFICE_STATUS, BACKUPID, VENDORID) VALUES (?, ?, ?, ?, ?, ENCRYPT('"+userpasswd+"'), ?, ?, ?, ?)";
	  	psUser = con.prepareStatement(sqlInsertQuery);
		psUser.setString(1,firstname);
		psUser.setString(2,lastname);
		psUser.setString(3,loginid);
		psUser.setString(4,email);
		psUser.setString(5,pager);
		//psUser.setString(6,userpasswd);
		if (timezone != null) psUser.setString(6,timezone); else psUser.setNull(6,Types.VARCHAR);
		psUser.setString(7,officestatus);
		if (backup != null) psUser.setInt(8,Integer.parseInt(backup)); else psUser.setNull(8,Types.INTEGER);
		//psUser.setInt(9,vendorid);
		if (vendorid > 0 ) psUser.setInt(9,vendorid); else psUser.setNull(9,Types.INTEGER);
		psUser.executeUpdate();
	  	sMessage = 0;
		
		if (sMessage == 0) {
			String sqlQuery = "SELECT USERID FROM GPWS.USER WHERE LOGINID = ?";
			int userid = 0;
			psUserID = con.prepareStatement(sqlQuery);
		  	psUserID.setString(1, loginid);
		  	rsUserID = psUserID.executeQuery();
			while (rsUserID.next()) {
				userid = rsUserID.getInt("USERID");
				String sUserID = Integer.toString(userid);
				req.setAttribute("userid",sUserID);
			} //while rsProtocols
		}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.class method insertUser ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UserEdit.insertUser.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.insertUser.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsUser != null)
	  				rsUser.close();
	  			if (psUser != null)
		  			psUser.close();
	  			if (rsUserID != null)
	  				rsUserID.close();
	  			if (psUserID != null)
		  			psUserID.close();
	  			if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.insertUser.2 ERROR: " + e);
	  		}
	  }
		return sMessage;
	} //method insertUser
	
	/********************************************************************************************
	* editUser
	*
	* This method takes 1 argument, an HttpServletRequest, and edits a user into the database
	********************************************************************************************/
	public int editUser(HttpServletRequest req) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		PrinterTools ptool = new PrinterTools();
		Connection con = null;
		PreparedStatement psUser = null;
		PreparedStatement psUserOrig = null;
		ResultSet rsUser = null;
		//Get the original values
		int origUserID = 0;
		String origfirstname = "";
		String origlastname = "";
		String origloginid = "";
		String origemail = "";
		String origuserpasswd = "";
		String origpager = "";
		String origtimezone = "";
		String origofficestatus = "";
		//String sEncryptPW = myResources.getString("encryptPass");
		String sEncryptPW = ptool.getEncryptPass();
		String encrpwd = "SET ENCRYPTION PASSWORD = '" + sEncryptPW + "'";
		int origbackupid = 0;
		int origvendorid = 0;
		int UserID = 0;
		String userid = req.getParameter("userid");
		if (userid != null) {
			UserID = Integer.parseInt(userid);
		}
		String firstname = req.getParameter("firstname");
		String lastname = req.getParameter("lastname");
		String loginid = req.getParameter("loginid");
		String email = req.getParameter("email");
		String userpasswd = req.getParameter("userpasswd");
		String pager = req.getParameter("pager");
		String timezone = req.getParameter("timezone");
		if (timezone.equals("0")) {
			timezone = "";
		}
		userpasswd = tool.nullStringConverter(userpasswd);
		String officestatus = req.getParameter("officestatus");
		String backup = req.getParameter("backupid");
		int vendorid = Integer.parseInt(req.getParameter("vendor"));
		int sMessage = 0;
		boolean dbResult = true;
	  try {
	  	con = tool.getConnection();
	  	psUser = con.prepareStatement(encrpwd);
	  	psUser.execute();
	  	String sqlQuery = "SELECT USERID, FIRST_NAME, LAST_NAME, LOGINID, EMAIL, DECRYPT_CHAR(PASSWORD) AS PASSWORD, PAGER, TIME_ZONE, OFFICE_STATUS, BACKUPID, VENDORID FROM GPWS.USER WHERE USERID = ?";
		psUserOrig = con.prepareStatement(sqlQuery);
	  	psUserOrig.setInt(1,UserID);
	  	rsUser = psUserOrig.executeQuery();
	  	while (rsUser.next()) {
			origUserID = rsUser.getInt("USERID");
			origfirstname = rsUser.getString("FIRST_NAME");
			origlastname = rsUser.getString("LAST_NAME");
			origloginid = rsUser.getString("LOGINID");
			origemail = rsUser.getString("EMAIL");
			origpager = rsUser.getString("PAGER");
			if (origpager == null) {
				origpager = "";
			}
			origtimezone = rsUser.getString("TIME_ZONE");
			if (origtimezone == null) {
				origtimezone = "";
			}
			origofficestatus = rsUser.getString("OFFICE_STATUS");
			if (origofficestatus == null) {
				origofficestatus = "";
			}
			origbackupid = rsUser.getInt("BACKUPID");
			origvendorid = rsUser.getInt("VENDORID");
			origuserpasswd = rsUser.getString("PASSWORD");
			origuserpasswd = tool.nullStringConverter(origuserpasswd);
		} //while rsUser
	  	if (!firstname.equals(origfirstname) || !lastname.equals(origlastname) || !loginid.equals(origloginid) || !email.equals(origemail) || !origuserpasswd.equals(userpasswd) || !pager.equals(origpager) || !timezone.equals(origtimezone) || !officestatus.equals(origofficestatus) || Integer.parseInt(backup) != origbackupid || vendorid != origvendorid) {
			if (backup.equals("-1") || backup.equals("0")) {
				backup = null;
			}
			if (timezone.equals("0")) {
				timezone = null;
			}
			String updateQuery = "UPDATE GPWS.USER SET FIRST_NAME = ?, LAST_NAME = ?, LOGINID = ?, EMAIL = ?, PASSWORD = ENCRYPT('"+userpasswd+"'), PAGER = ?, TIME_ZONE = ?, OFFICE_STATUS = ?, BACKUPID = ?, VENDORID = ? WHERE USERID = ?";
			psUser = con.prepareStatement(updateQuery);
			psUser.setString(1,firstname);
			psUser.setString(2,lastname);
			psUser.setString(3,loginid);
			psUser.setString(4,email);
			//psUser.setString(5,userpasswd);
			psUser.setString(5,pager);
			if (timezone != null) psUser.setString(6,timezone); else psUser.setNull(6,Types.VARCHAR);
			psUser.setString(7,officestatus);
			if (backup != null) psUser.setInt(8,Integer.parseInt(backup)); else psUser.setNull(8,Types.INTEGER);
			//psUser.setInt(9,vendorid);
			if (vendorid > 0 ) psUser.setInt(9,vendorid); else psUser.setNull(9,Types.INTEGER);
			psUser.setInt(10,UserID);
			psUser.executeUpdate();
			sMessage = 0;
		} else {
			sMessage = 2;
		}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.class method editUser ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UserEdit.editUser.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.editUser.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (psUserOrig != null)
		  			psUserOrig.close();
		  		if (con != null)
		  			con.close();
	  			if (rsUser != null)
	  				rsUser.close();
	  			if (psUser != null)
		  			psUser.close();
	  			if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.editUser.2 ERROR: " + e);
	  		}
	  }
		return sMessage;
	} //method editUser
	
	/********************************************************************************************
	* updatePassword
	*
	* This method takes 2 arguments, an HttpServletRequest and String, and edits a user's
	* password
	********************************************************************************************/
	public int updatePassword (HttpServletRequest req, String loginid) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psUser = null;
		ResultSet rsUser = null;
		//Get the original values
		//String sEncryptPW = myResources.getString("encryptPass");
		String sEncryptPW = tool.getEncryptPW();
		String encrpwd = "SET ENCRYPTION PASSWORD = '" + sEncryptPW + "'";
		String userpasswd = req.getParameter("passwd1");
		int sMessage = 0;
		int userid = 0;
		String currentpass = req.getParameter("currentpass");  //currentpassword
		String origpass = ""; //original password in DB
		boolean dbResult = true;
	  try {
	  	con = tool.getConnection();
	  	psUser = con.prepareStatement(encrpwd);
	  	psUser.execute();
	  	String sqlQuery = "SELECT USERID, FIRST_NAME, LAST_NAME, LOGINID, EMAIL, DECRYPT_CHAR(PASSWORD) AS PASSWORD, PAGER, TIME_ZONE, OFFICE_STATUS, BACKUPID FROM GPWS.USER WHERE LOGINID = ?";
		psUser = con.prepareStatement(sqlQuery);
	  	psUser.setString(1,loginid);
	  	rsUser = psUser.executeQuery();
	  	while (rsUser.next()) {
			userid = rsUser.getInt("USERID");
			origpass = rsUser.getString("PASSWORD");
		} //while rsUser
	  	if (userid != 0) {
	  		if (currentpass.equals(origpass)) {
				String updateQuery = "UPDATE GPWS.USER SET PASSWORD = ENCRYPT('"+userpasswd+"') WHERE USERID = ?";
				psUser = con.prepareStatement(updateQuery);
				psUser.setInt(1,userid);
				psUser.executeUpdate();
				sMessage = 0;
	  		} else {
				sMessage = 2;
				String ERROR = "U001";
				String ERRORMESSAGE = "Your current password is invalid";
				req.setAttribute("ERROR",ERROR);
				req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
			}
		} else {
			sMessage = 3;
			String ERROR = "U001";
			String ERRORMESSAGE = "The login ID specified: " +"(" + loginid + ")" + " was not found.";
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
		}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.class method updatePassword ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UserEdit.editUser.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.updatePassword.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsUser != null)
	  				rsUser.close();
	  			if (psUser != null)
		  			psUser.close();
	  			if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.updatePassword.2 ERROR: " + e);
	  		}
	  }
	 return sMessage;
	} //end method updatePassword

	/********************************************************************************************
	* editAuth
	*
	* This method takes 4 arguments, an HttpServletRequest and 3 ints, and edits a user's
	* authorizations.
	********************************************************************************************/
	public int editAuth(HttpServletRequest req, int UserAuthTypeID, int AuthTypeID, int UserID) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psUser = null;
		PreparedStatement psUserAuth = null;
		ResultSet rsUser = null;
		//Get the original values
		int origAuthTypeID = 0;
		int origUserID = 0;
		int origUserAuthTypeID = 0;
		int sMessage = 0;
		boolean dbResult = true;
		
	  try {
	  	con = tool.getConnection();
	  	String sqlQuery = "SELECT USER_AUTH_TYPEID, AUTH_TYPEID, USERID FROM GPWS.USER_AUTH_TYPE WHERE USER_AUTH_TYPEID = ?";
		psUser = con.prepareStatement(sqlQuery);
		psUser.setInt(1,UserAuthTypeID);
		rsUser = psUser.executeQuery();
	  	while (rsUser.next()) {
			origAuthTypeID = rsUser.getInt("AUTH_TYPEID");
			origUserID = rsUser.getInt("USERID");
			origUserAuthTypeID = rsUser.getInt("USER_AUTH_TYPEID");
		} //while rsProtocols
		if (AuthTypeID != origAuthTypeID && AuthTypeID != 0) {
			//execute SQL to update each protocol
			String insertQuery = "UPDATE GPWS.USER_AUTH_TYPE SET AUTH_TYPEID = ? WHERE USER_AUTH_TYPEID = ?";
			psUserAuth = con.prepareStatement(insertQuery);
			psUserAuth.setInt(1,AuthTypeID);
			psUserAuth.setInt(2,UserAuthTypeID);
			psUserAuth.executeUpdate();
			sMessage = 0;
		} else {
			sMessage = 2;
		}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.class method editAuth ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UserEdit.editAuth.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.editAuth.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsUser != null)
	  				rsUser.close();
	  			if (psUser != null)
		  			psUser.close();
	  			if (psUserAuth != null)
		  			psUserAuth.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.editAuth.2 ERROR: " + e);
	  		}
	  }
		return sMessage;
	} //method editAuth
	
	/********************************************************************************************
	* deleteAuth
	*
	* This method takes 4 arguments, an HttpServletRequest and 3 ints, and deletes a user's
	* authorizations.
	********************************************************************************************/
	public int deleteAuth(HttpServletRequest req, int UserAuthTypeID, int AuthTypeID, int UserID) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psUser = null;
		ResultSet rsUser = null;
		int sMessage = 0;
		boolean dbResult = true;
		
	  try {
	  	con = tool.getConnection();
		String sqlQuery = "DELETE FROM GPWS.USER_AUTH_TYPE WHERE USER_AUTH_TYPEID = ? AND USERID = ?";
	  	psUser = con.prepareStatement(sqlQuery);
	  	psUser.setInt(1,UserAuthTypeID);
	  	psUser.setInt(2,UserID);
		psUser.executeUpdate();
		sMessage = 0;
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.class method deleteAuth ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("GPWSAdmin.UserEdit.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.deleteAuth.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsUser != null)
	  				rsUser.close();
	  			if (psUser != null)
		  			psUser.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.deleteAuth.2 ERROR: " + e);
	  		}
	  }
		return sMessage;
	} //method deleteAuth
	
	/********************************************************************************************
	* insertAuth
	*
	* This method takes 3 arguments, an HttpServletRequest and 2 ints, and inserts a user's
	* authorizations.
	********************************************************************************************/
	public int insertAuth(HttpServletRequest req, int AuthTypeID, int UserID) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		Connection con = null;
		Statement stmtUser = null;
		ResultSet rsUser = null;
		int sMessage = 0;
		boolean dbResult = true;
		
	  try {
	  	con = tool.getConnection();
		stmtUser = con.createStatement();
		stmtUser.executeUpdate("INSERT INTO GPWS.USER_AUTH_TYPE (AUTH_TYPEID, USERID) VALUES (" + AuthTypeID + "," + UserID + ")");
		sMessage = 0;
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.class method insertAuth ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UserEdit.insertAuth.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.insertAuth.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsUser != null)
	  				rsUser.close();
	  			if (stmtUser != null)
		  			stmtUser.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.insertAuth.2 ERROR: " + e);
	  		}
	  }
		return sMessage;
	} //method insertAuth
	
	/********************************************************************************************
	* getAuthType
	*
	* This method takes 1 arguments, an int, and returns the auth type name.
	********************************************************************************************/
	public String getAuthType(int AuthTypeID) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sAuthType = "";
		
	  try {
	  	con = tool.getConnection();
	  	stmt = con.createStatement();
	  	rs = stmt.executeQuery("SELECT AUTH_NAME FROM GPWS.AUTH_TYPE WHERE AUTH_TYPEID = " + AuthTypeID);

	  	while (rs.next()) {
	  		sAuthType = rs.getString("AUTH_NAME");
	  	}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.getAuthType ERROR1: " + e);
	  		try {
	   			tool.logError("UserEdit.getAuthType.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.getAuthType.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rs != null)
	  				rs.close();
	  			if (stmt != null)
		  			stmt.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.getAuthType.2 ERROR: " + e);
	  		}
	  }
		return sAuthType;
	} //method insertAuth
	
	/********************************************************************************************
	* getEmailURLs
	*
	* This method takes 0 arguments and will return an array of the prod GPWS URL, test GPWS
	* URL and the help documentation URL. It is used for sending emails to new GPWS users.
	********************************************************************************************/
	public String[] getEmailURLs() throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String[] sURLs = {"", "", ""};
		
	  try {
	  	con = tool.getConnection();
	  	stmt = con.createStatement();
	  	rs = stmt.executeQuery("SELECT CATEGORY_CODE, CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'GPWS-URLs'");

	  	while (rs.next()) {
	  		if (rs.getString("CATEGORY_CODE").equals("GPWS-Admin")) {
	  			sURLs[0] = rs.getString("CATEGORY_VALUE1") + ": " + rs.getString("CATEGORY_VALUE2");
	  		} else if (rs.getString("CATEGORY_CODE").equals("GPWS-Help")) {
	  			sURLs[1] = rs.getString("CATEGORY_VALUE1") + ": " + rs.getString("CATEGORY_VALUE2");
	  		} else if (rs.getString("CATEGORY_CODE").equals("GPWS-Dev-Admin")) {
	  			sURLs[2] = rs.getString("CATEGORY_VALUE1") + ": " + rs.getString("CATEGORY_VALUE2");
	  		}
	  	}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in UserEdit.getEmailURLs ERROR1: " + e);
	  		try {
	   			tool.logError("UserEdit.getEmailURLs.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in UserEdit.getEmailURLs.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rs != null)
	  				rs.close();
	  			if (stmt != null)
		  			stmt.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in UserEdit.getEmailURLs.2 ERROR: " + e);
	  		}
	  }
		return sURLs;
	} //method insertAuth
	
} //class UserEdit