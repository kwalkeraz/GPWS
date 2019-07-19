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
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.ibm.aurora.*;
import com.ibm.aurora.util.*;

/**
  * This behavior takes 3 parameters in the properties file.
  * The first is a list of boolean methods to call via the StateVar
  * Tthe second is the page to redirect to if the boolean equation is false.  This can
  * either be defined as a page # for the same application or a fully qualfied URL.
  * The third is the type of boolean equation AND/OR/NOR.  This is optional and defaults
  * to AND.
  *
  * The point of this behavior is to redirect a user to a specific page if a condition
  * is or is not set.  For example, they didn't go through your starting page where you
  * set a cookie.  If the cookie check is false, this behavior (used on every other page
  * on your site) could auto-redirect them back to the start page.
  *
  * CLASS                        com.ibm.vhds.printer.ViewPageOKBhvr
  * ORDINANCE                    Singleton
  * Method_1                     !UserProfileBean.getIsAdminTypeA
  * Method_2                     !UserProfileBean.getIsSuperUser
  * BooleanType                  [AND | OR | NOR]
  * [only use one or the other of these]
  * On_False_Redirect_To         200
  * On_Failure_Redirect_To_URL_   http://
  * On_Failure_Redirect_To_URL_   #SERVERNAME
  * On_Failure_Redirect_To_URL_   #PATH_TO_SERVLET
  * On_Failure_Redirect_To_URL_  ?to_page_id=200
  *
  * @author IBM VHD Team November 2001
  */

public class ViewPageOKBhvr implements Behavior {
    private final static String BOOLEANMETHOD = "Method_";
    private final static String REDIRECT_TO = "On_Failure_Redirect_To";
    private final static String REDIRECT_TO_URL = "On_Failure_Redirect_To_URL_";
    private final static String BOOLEAN_TYPE = "BooleanType";
    private final static int BOOL_AND = 0;
    private final static int BOOL_OR = 1;
    private final static int BOOL_NOR = 2;

    // The name of this specific instance of this Behavior,
    private String behaviorName = null;
    private StateVar functionToCall[] = null;
    private String redirectPage = null;
    private StateVar redirectPageURL[] = null;
    private int booleanType = BOOL_AND;  // default

    /**
     * Constructor used for 'per call' instances.
     */
    public ViewPageOKBhvr(Behavior b) throws BehaviorException {
       throw new BehaviorException("Don't call ViewPageOKBhvr as PER CALL",0);
    }
    /**
     * The constructor will initialize the specifics of the Behavior.
     * It will be called ONCE from the constructor of the BehaviorInfo.
     *
     * @param resourceBundle a reference to the resource bundle for this specific behavior.
     * @param specificBehavior a string that defines the specific behavior name that can be used
     *  for errors.
     */
    public ViewPageOKBhvr(PropertyResourceBundle prb, String specificBehavior) throws BehaviorException {
        behaviorName = specificBehavior;

        functionToCall = StateVar.loadArrayFromProperty(prb,BOOLEANMETHOD);
         // statevar doesn't currently allow you to check the parameter type
         // but all parameters in this case MUST be functions...
//        if( functionToCall.getType() != StateVar.SV_FUNCTION ) {
//           throw new BehaviorException("Invalid Parameter for ViewPageOKBhvr.  Must be a function type.");
//        }


        try {
           redirectPage = prb.getString(REDIRECT_TO);
        } // if they did not define a page to go to, then they must
          // have defined a new servlet
        catch( MissingResourceException mre ) {
           redirectPageURL = StateVar.loadArrayFromProperty(prb,REDIRECT_TO_URL);
        }

        try {
           String x = prb.getString(BOOLEAN_TYPE);
           if( x != null && x.length() > 0 ) {
              if( x.equals("AND") ) booleanType = BOOL_AND;
              if( x.equals("OR") ) booleanType = BOOL_OR;
              if( x.equals("NOR") ) booleanType = BOOL_NOR;
           }
        }
        catch( MissingResourceException mre ) { /* ok to ignore and default this one */ }
    }

   /*
    * This method will loop through the methods defined in the properites file and check the results.
    * If the final result is false, redirect them to the page defined in the properties.
    *
    * @param req the request object from the invoking servlet or JSP.
    * @param conn the Connection object to be used for SQL calls.
    * @exception BehaviorException if the properties file is set up incorrectly.
    * @exception SQLException if a query does not execute properly.
    */
   public void execute(HttpServletRequest req, HttpServletResponse res, Connection conn) throws BehaviorException, SQLException {

       // this function could be optimized later so for cases like AND, if the first function is
       // false, there is no need to continue and check the other functions
       // Or in the case of OR if the first function is TRUE.


       // loop through the functions and get the result
      boolean bFlag[] = new boolean[functionToCall.length];
      for( int i=0; i<functionToCall.length; i++ ) {
         bFlag[i] = ((Boolean)(functionToCall[i].getData(req))).booleanValue();
         if (Log.getTraceLevel() > 9) {
            Log.println("ViewPageOK: function "+(i+1)+" returned "+bFlag[i]);
         }
      }
       // now run them through the equation
      boolean result = true;
      switch( booleanType ) {
         case BOOL_AND: {
            result = true;
             // all of the function results must be true
            for( int i=0; i<bFlag.length; i++ ) {
               if( bFlag[i] == false ) { result = false; break; }
            }
         }
         break;
         case BOOL_OR: {
             // any of the function results must be true
            result = false;
            for( int i=0; i<bFlag.length; i++ ) {
               if( bFlag[i] == true ) { result = true; break; }
            }
         }
         break;
         case BOOL_NOR: {
            result = true;
             // none of the function results must be true
            for( int i=0; i<bFlag.length; i++ ) {
               if( bFlag[i] ) { result = false; break; }
            }
         }
         break;
      }
       // if the final result is false, then do the redirect
      if( result == false ) {
          // use BehaviorException to redirect to a new page #
         if( redirectPage != null && redirectPage.length() > 0 ) {
            throw new BehaviorException("ViewPageOKBhvr redirecting because test condition failed", 0, redirectPage);
         } else {
            // use RedirectException to redirect to a new URL
            StringBuffer theUrl = new StringBuffer();

            for( int i=0; i<redirectPageURL.length; i++ )
               theUrl.append( (String)(redirectPageURL[i].getData(req)) );
            throw new RedirectException(0,theUrl.toString(),false);
         }
      }
   }

   /**
    * Gets the behaviorName property.
    * @return the name of this bean's resource properties file.
    */
    public String getBehaviorName() {
        return this.behaviorName;
    }

}
