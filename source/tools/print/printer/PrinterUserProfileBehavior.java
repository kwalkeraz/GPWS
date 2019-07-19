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
import com.ibm.aurora.util.*;

 /**
   * Used as a common behavior that all printer pages will run.  This allows all printer pages access to
   * the printer user profile bean.  It should be queried from specific page behaviors and JSP files
   * as follows:
   * <p><code>
   * PrinterUserProfileBehavior pupbav = (PrinterUserProfileBehavior) request.getAttribute("PrinterUserProfileBehavior");<br />
   * PrinterUserProfileBean pupb = pupbav.getPrinterUserProfileBean();
   * </code></p>
   *
   * @author VHD Team May 2002
   */
public class PrinterUserProfileBehavior implements Behavior {

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
   public PrinterUserProfileBehavior( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
      setBehaviorName( specificBehavior );
   }

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public PrinterUserProfileBehavior( Behavior b ) throws BehaviorException {
      try {
      }
      catch( ClassCastException cce ) {
      }
   }

    /**
      * Get the PrinterUserProfileBean out of the session object and make it available through
      * a getter in this PrinterUserProfileBehavior object.  This way no one else has to access
      * the session object and access to the PrinterUserProfileBean is handled the same as access
      * to all other data within the application.
      */
   public void execute( HttpServletRequest req, HttpServletResponse res, Connection con )
      throws BehaviorException, SQLException {
      HttpSession sess = req.getSession();
      sess.setMaxInactiveInterval(3600);
      PrinterUserProfileBean pupb = (PrinterUserProfileBean)sess.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN);
      if( pupb != null && Log.getTraceLevel() > 9 ) {
         Log.println("PrinterUserProfileBehavior: PrinterUserProfileBean found and set into request object");
      }
      if( pupb == null ) {
         if( Log.getTraceLevel() > 9 ) {
            Log.println("PrinterUserProfileBehavior: PrinterUserProfileBean created and set into request object");
         }
         pupb = new PrinterUserProfileBean();
         sess.setAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN,pupb);
      }
      req.setAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN, pupb );
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