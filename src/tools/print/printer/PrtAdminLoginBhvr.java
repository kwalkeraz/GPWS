/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.util.*;

import javax.servlet.http.*;
import java.sql.*;
import com.ibm.aurora.*;
import tools.print.lib.*;
import swat.*;

 /**
   * Process a printer admin user login
   *
   * @author VHD Team 2001
   */
public class PrtAdminLoginBhvr implements Behavior {

	private String bName;
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.printer.PrinterTools");

    /**
      * The constructor will initialize the specifics of the Behavior.
      * It will be called ONCE from the constructor of the BehaviorInfo, in order to configure the
      * databaseTable instance variable.  After that, the other constructor will be called to simply
      * get a pointer to this data.
      *
      * @param resourceBundle a reference to the resource bundle for this specific behavior.
      * The bundle should contain a database table name and information about matching the columns
      * to the html fields.
      * @param specificBehavior a string that defines the specific behavior name that can be used
      *  for errors
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
	public PrtAdminLoginBhvr( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
		setBehaviorName( specificBehavior );
	}

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
	public PrtAdminLoginBhvr( Behavior b ) throws BehaviorException {
		try {
		} catch( ClassCastException cce ) {
		}
	}

    /**
      *
      */
	public void execute( HttpServletRequest req, HttpServletResponse res, Connection con ) throws BehaviorException, SQLException {

		String name = req.getParameter(PrinterConstants.LOGIN_NAME);
		String sUserid = req.getParameter("UserId");
		String sPassword = req.getParameter("Password");
		String authMethod = "";
		int iRC = -1;
		AppTools appTool = new AppTools();
	  
		try {
			authMethod = getAuthMethod(con);
			if (authMethod != null && authMethod.equals("ldap")) {
				iRC = bpAuthenticate(sUserid, sPassword);
			} else {
				System.out.println("Executing dbAuth");
				iRC = dbAuthenticate(con, sUserid, sPassword);
			}	
		} catch (Exception e) {
			System.out.print("Error in PrtAdminLoginBehavior.execute ERROR " + e);
			try {
				appTool.logError("PrtAdminLoginBhvr.execute","GPWS", e);
			} catch (Exception ex) {
				System.out.println("Error in PrtAdminLoginBhvr.execute ERROR: " + ex);
			}
		}
		if (iRC != 0 && iRC == -1) {
			throw new BehaviorException("Unknown system error",1,"9001");
		} else if (iRC != 0 && iRC == 3) {
			throw new BehaviorException("LDAP error",1,"9002");
		} else if (iRC != 0 && iRC ==99) {
			throw new BehaviorException("Invalid user input.",1,"9000");
		} else if (iRC != 0) {
			req.setAttribute("Invalid", "Invalid Login");
			throw new BehaviorException("Invalid Login",1,"253");
		}
	  
		// db2 query here to see if they are in the db
	    //
	    // if not a valid user, throw this BehaviorException which will
	    // redirect them to a failure page (Next_page_id=3)
	    //
	    // remember, if you throw the exception, processing stops immediately
	    // if you don't, then the validsiteuser will be true and processing
	    // will continue to next_page_id=2 which is in the properties file
	    //
		// throw new BehaviorException("Not a valid website user", 0, 3);  or maybe...
		// throw new BehaviorException("Not a valid website user", 0, PrinterConstants.AUTHENTICATE_FAILURE);
	    //
		boolean bFlag = false;
		try {
			PrinterUserProfileBean pupbean = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
			// First Name, Last Name should be shared between Triage and Printer Admin after fully implementation
			// Right now it gets from prtadmin table
		  
			pupbean.setUserFirstName((String)req.getAttribute("userfirstname"));
			pupbean.setUserLastName((String)req.getAttribute("userlastname"));
			Integer i = (Integer)req.getAttribute("userid");
			pupbean.setUserID(i.intValue());
			pupbean.setUserLoginID((String)req.getAttribute("userloginid"));
			pupbean.setAccess(i.intValue());
			pupbean.setAuthTypes(i.intValue());
			pupbean.setEmail((String)req.getAttribute("email"));
			pupbean.setTimeZone((String)req.getAttribute("timezone"));
			pupbean.setPager((String)req.getAttribute("pager"));
			pupbean.setOfficeStatus((String)req.getAttribute("officestatus"));
			Integer iBID = (Integer)req.getAttribute("backupid");
			pupbean.setBackupID(iBID.intValue());
			int vendorid = (req.getAttribute("vendorid") == null && req.getAttribute("vendorid") != "") ? 0 : ((Integer)req.getAttribute("vendorid")).intValue();
			pupbean.setVendorID(vendorid);
		  
			pupbean.setValidUser(true);
			pupbean.setValidSession(true);
		}
		catch( Exception e ) {
			throw new BehaviorException("Unknown error trying to set User Profile Bean",PrinterBhvrErrors.CANT_SET_USER_PROFILE_BEAN,e);
		}

	}

    /**
      * Returns the name of this behavior to be used in error messages.
      * @return the name of this behavior
      */
	public String getBehaviorName() { return this.bName; }
    
	/**
      * Returns the name of this behavior to be used in error messages.
      * @param s the name of this specific instance of this behavior
      */
	public void setBehaviorName( String s ) { this.bName = s; }
   
	/********************************************************************************************
    * getAuthMethod
    *
    * Authenticates a user using IIP.
    *********************************************************************************************/	
    public String getAuthMethod(Connection con) throws Exception {
    	
    	String authMethod = "";
    	AppTools appTool = new AppTools();
    	PreparedStatement stmtAuth = null;
    	ResultSet rsAuth = null;
    	    	
    	try {	    	
    		stmtAuth = con.prepareStatement("SELECT AUTH_METHOD FROM GPWS.APP_SETTINGS");
    		rsAuth = stmtAuth.executeQuery();
    		
    		while (rsAuth.next()) {
    			authMethod = appTool.nullStringConverter(rsAuth.getString("AUTH_METHOD"));
    		}
    	
    	} catch (Exception e) {
    		System.out.print("Prtadmin error in PrtAdminLoginBhvr method getAuthMethod ERROR " + e);
    	} finally {
    		if (rsAuth != null)
    			rsAuth.close();
    		if (stmtAuth != null)
    			stmtAuth.close();
    	}
    	
    	return authMethod;
    	
    }
   
   /********************************************************************************************
    * bpAuthenticate
    *
    * Authenticates a user using IIP.
    *********************************************************************************************/	
    public int bpAuthenticate(String sUserid, String sPassword) {
    	
    	ReturnCode rc = null;
    	String sServerName = myResources.getString("ldapServer");
    	boolean error = true;
    	try {	    	
    		rc = cwa.authenticate(sServerName, sUserid, sPassword);
    		
    	} catch (Exception e) {
    		error = false;
    		System.out.print("Prtadmin error in PrtAdminLoginBhvr.bpAuthenticate ERROR " + e);
    	}
    	if (error == false) {
    		return -1;
    	} else {
    		return(rc.getCode());
    	}    	
    }
    
    /********************************************************************************************
     * dbAuthenticate
     *
     * Authenticates a user via the database.
     *********************************************************************************************/	
     public int dbAuthenticate(Connection con, String sUserid, String sPassword) throws Exception {
     	
     	PreparedStatement stmtUser = null;
     	ResultSet rsUser = null;
     	AppTools appTool = new AppTools();
     	int iRC = -1;
     	//String sEncryptPW = myResources.getString("encryptPass");
     	String sEncryptPW = appTool.getEncryptPW();
     	boolean bValidInput = true;
     	
     	try {
     		  if (appTool.validateUserInput(sUserid) == false || appTool.validateUserInput(sPassword) == false) {
     		  		bValidInput = false;
     		  }
     	} catch (Exception e) {
     			bValidInput = false;
     			System.out.println("Error in PrtAdminLoginBhvr.dbAuthenticate ERROR: " + e);
     	}

 		if (bValidInput == false) {
 			return 99;
 		}
     	
     	try {
     		stmtUser = con.prepareStatement("SET ENCRYPTION PASSWORD = ?");
     		stmtUser.setString(1,sEncryptPW);
     		stmtUser.execute();
     		stmtUser = con.prepareStatement("SELECT USERID FROM GPWS.USER WHERE LOGINID = ? AND DECRYPT_CHAR(PASSWORD) = ?");
			stmtUser.setString(1,sUserid);
			stmtUser.setString(2,sPassword);
     		rsUser = stmtUser.executeQuery();
     		
     		while (rsUser.next()) {
     			iRC = 0;
     		}
     		if (iRC == -1) {
     			iRC = 1;
     		}
     		
     	} catch (Exception e) {
     		System.out.print("Prtadmin error in PrtAdminLoginBhvr.dbAuthenticate ERROR: " + e);
     	} finally {
     		try {
	     		if (rsUser != null)
	     			rsUser.close();
	     		if (stmtUser != null)
	     			stmtUser.close();
     		} catch (Exception e) {
     			System.out.println("Error closing connection in PrtAdminLoginBhvr ERROR: " + e);
     		}
     	}
     	return iRC;
     }
}