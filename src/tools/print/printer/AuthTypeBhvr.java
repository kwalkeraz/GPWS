/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import com.ibm.aurora.*;
import com.ibm.aurora.bhvr.*;
import java.io.*;
import java.net.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import tools.print.lib.AppTools;

 /**
   * This behavior will take in search name and gets all printers matching the search fields.
   *
   * @author IBM VHD Team October 2001
   */
public class AuthTypeBhvr implements Behavior {

	/** the printer information */
   protected PrinterDataBean pd;

   private String bName = null;
   protected String searchName = null;
   protected ArrayList arrList = new ArrayList(1000);
   protected int arrCount = 0;

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
   public AuthTypeBhvr( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
      setBehaviorName( specificBehavior );
   }

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public AuthTypeBhvr( Behavior b ) throws BehaviorException {
		try {
			AuthTypeBhvr fpb = (AuthTypeBhvr) b;
			this.bName = fpb.bName;
		}
		catch( ClassCastException cce ) {
			throw new BehaviorException("Invalid cast to a FindPrinterBhvr object",BhvrErrors.INVALID_CAST,cce);
		}
   }

    /**
      * Assign the remote host string
	  * Determine ip range
	  * Finding location with ip range
      */
   public void execute( HttpServletRequest req, HttpServletResponse res, Connection con )
      throws BehaviorException, SQLException {
   		
   	  String submitValue = req.getParameter("submitvalue");
   	  String[] authActions;
   	  PrinterUserProfileBean pupb = (PrinterUserProfileBean) req.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
   	  int authTypeid = Integer.parseInt(req.getParameter("authtypeid"));
   	  String logaction = req.getParameter("logaction");
   	  if (submitValue != null && !submitValue.equals("") && submitValue.equals("Add")) {
   	  	authActions = req.getParameterValues("availauthactions");
   	  	addActions(authTypeid, authActions, con, pupb, logaction);
   	  } else {
   	  	authActions = req.getParameterValues("authactions");
   	  	removeActions(authTypeid, authActions, con, pupb, logaction);
   	  }	  
   }
 
   protected final void addActions( int authTypeid, String[] authActions, Connection con, PrinterUserProfileBean pupb, String logaction)
      throws BehaviorException, SQLException {
   		
   	  Statement stmtActions = null;
   	  AppTools appTool = new AppTools();
   	
   	  try {
   	  	stmtActions = con.createStatement();
   	  	for (int i = 0; i < authActions.length; i++) {
   	  		stmtActions.executeUpdate("INSERT INTO GPWS.AUTH_TYPE_ACTION (AUTH_ACTIONID, AUTH_TYPEID) VALUES (" + authActions[i] + "," + authTypeid + ")");     
   	  	}
   	  	appTool.logUserAction(pupb.getUserLoginID(),logaction,"GPWSAdmin");
	  
      } catch (Exception e) {
      		try {
      			appTool.logError("AuthTypeBhvr.addActions", "GPWS", e);
      			System.out.println("Error in AuthTypeBhvr.addActions ERROR: " + e);
      		} catch (Exception ex) {
      			System.out.println("Error logging error in AuthTypeBhvr.addActions ERROR: " + ex);
      		}
      } finally {
      	if (stmtActions != null)
      		stmtActions.close();
      }
   }
   
   protected final void removeActions( int authTypeid, String[] authActions, Connection con, PrinterUserProfileBean pupb, String logaction)
   throws BehaviorException, SQLException {
	  Statement stmtActions = null;
	  AppTools appTool = new AppTools();
	  
	  try {
	  	stmtActions = con.createStatement();
	  	for (int j = 0; j < authActions.length; j++) {
	  		stmtActions.executeUpdate("DELETE FROM GPWS.AUTH_TYPE_ACTION WHERE AUTH_ACTIONID = " + authActions[j] + " AND AUTH_TYPEID = " + authTypeid);     
	  	}
	  	appTool.logUserAction(pupb.getUserLoginID(),logaction,"GPWSAdmin");
	  } catch (Exception e) {
   		try {
			appTool.logError("AuthTypeBhvr.addActions", "GPWS", e);
			System.out.println("Error in AuthTypeBhvr.removeActions ERROR: " + e);
		} catch (Exception ex) {
			System.out.println("Error logging error in AuthTypeBhvr.removeActions ERROR: " + ex);
		}
	  } finally {
	  	if (stmtActions != null)
	  		stmtActions.close();
	  }
}
   

   private final void setBehaviorName( String s ) { this.bName = s; }
   public final String getBehaviorName() { return bName; }

}