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

public class ExecuteSql implements Behavior {

   private String bName = null;
   protected String searchName = null;
   protected int arrCount = 0;
   AppTools tool = new AppTools();

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
   public ExecuteSql( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
      setBehaviorName( specificBehavior );
   }

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public ExecuteSql( Behavior b ) throws BehaviorException {
		try {
			ExecuteSql qps = (ExecuteSql) b;
			this.bName = qps.bName;
		}
		catch( ClassCastException cce ) {
			throw new BehaviorException("Invalid cast to an ExecuteSql object",BhvrErrors.INVALID_CAST,cce);
		}
   }

    /**
      * Get search value
	  * Perform search
	  * Add the result arraylist to request object
      */
   public void execute( HttpServletRequest req, HttpServletResponse res, Connection con )
      throws BehaviorException, SQLException {
      
	  String searchName = req.getParameter("SqlCommand");
	  if( searchName == null || searchName.equals("") || searchName.equals("null") ) searchName = "";

	  System.out.println("ExecuteSql: searchName = "+searchName);
	  performSql(searchName, con, req);
	  System.out.println("ExecuteSql: sql completed.");
   }

	protected final String strStrip( String str ) {
		if( str == null || str.equals("") || str.equals("null") ) return "";
		else return str;
	}
  
   protected final void performSql( String searchName, Connection con, HttpServletRequest req )
      throws BehaviorException, SQLException {
		PreparedStatement stmt = null;
		int rs = 0; //initialize
		try {
			//PreparedStatement stmt;
			String sql = searchName;
			stmt = con.prepareStatement(sql);
			rs = stmt.executeUpdate();
			//System.out.println("ExecuteSql: Inside SQL Method ==> Prepared Statement Executed : " + sql +" " +String.valueOf(rs));
			System.out.println("ExecuteSql: Result is " + rs);
			String result = Integer.toString(rs);
			req.setAttribute("RESULT",result);
		} catch (SQLException sqle){
			System.out.println("Error in ExecuteSQL.performSql: " + sqle);
			String ERROR = Integer.toString(sqle.getErrorCode());
			String ERRORMESSAGE = sqle.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
			try {
	   			tool.logError("ExecuteSQL.performSql.1", "GPWSAdmin", sqle);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in ExecuteSQL.performSql.1 ERROR: " + ex);
	   		}
	    } finally {
	  		try {
	  			if (stmt != null)
		  			stmt.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in ExecuteSQL.performSql.2 ERROR: " + e);
	  		}
	    }
	}
   
   public final String getSearchName() {
      if( searchName != null )
         return this.searchName;
      else return "";
   }
   private final void setBehaviorName( String s ) { this.bName = s; }
   public final String getBehaviorName() { return bName; }

}