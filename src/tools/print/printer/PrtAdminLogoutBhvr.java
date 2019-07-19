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
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.net.*;
import com.ibm.aurora.*;

 /**
   * Process Printer Admin Logout
   *
   * @author VHD Team September 2001
   */
public class PrtAdminLogoutBhvr implements Behavior {

   private String bName;

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
   public PrtAdminLogoutBhvr( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
      setBehaviorName( specificBehavior );
   }

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public PrtAdminLogoutBhvr( Behavior b ) throws BehaviorException {
        try {
            PrtAdminLogoutBhvr bhvr = ((PrtAdminLogoutBhvr) b);
        }
        catch (ClassCastException cce) {
           throw new BehaviorException(getBehaviorName() + ": Invalid cast of a behavior to a PrtAdminLogoutBhvr.",BhvrErrors.INVALID_CAST);
        }
   }

    /**
      *
      */
   public void execute( HttpServletRequest req, HttpServletResponse res, Connection con )
      throws BehaviorException, SQLException {
	  PrinterUserProfileBean pupbean = (PrinterUserProfileBean)req.getAttribute("PrinterUserProfileBean");
	  pupbean.setValidUser(false);
	  pupbean.setValidSession(false);
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
}