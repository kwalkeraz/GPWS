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
import tools.print.lib.*;

 /**
   * This behavior will take in search name and gets all printers matching the search fields.
   *
   * @author IBM VHD Team October 2001
   */
public class ValidateInputBhvr implements Behavior {

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
   public ValidateInputBhvr( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
      setBehaviorName( specificBehavior );
   }

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public ValidateInputBhvr( Behavior b ) throws BehaviorException {
		try {
			ValidateInputBhvr vib = (ValidateInputBhvr) b;
			this.bName = vib.bName;
		}
		catch( ClassCastException cce ) {
			throw new BehaviorException("Invalid cast to a ValidateInputBhvr object",BhvrErrors.INVALID_CAST,cce);
		}
   }

    /**
      * 
      */
   public void execute( HttpServletRequest req, HttpServletResponse res, Connection con ) throws BehaviorException, SQLException {
   	
		Enumeration paramEnum = req.getParameterNames();
		String paramName = "";
		String paramValue = "";
		int count = 1;
		AppTools appTool = new AppTools();
		while (paramEnum.hasMoreElements()) {
			paramName = (String)paramEnum.nextElement();
			paramValue = req.getParameter(paramName);

			boolean bValidInput = true;
			try {
				bValidInput = appTool.validateUserInput(paramValue);				
			} catch (Exception e) {
				System.out.println("Error validating input in ValidateInputBhvr ERROR: " + e);	
			}
			if (bValidInput == false) {
				throw new BehaviorException("Invalid user input in field",1,"9000");
			}
			count++;
		}

   }

   private final void setBehaviorName( String s ) { this.bName = s; }
   public final String getBehaviorName() { return bName; }

    /**
      * public getter for the location information to use in JSP's
      */
   public PrinterDataBean getPrinterData() { return this.pd; }

}