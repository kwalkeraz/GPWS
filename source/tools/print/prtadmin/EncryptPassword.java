/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.prtadmin;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.PropertyResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tools.print.printer.PrinterTools;

import com.ibm.aurora.Behavior;
import com.ibm.aurora.BehaviorException;

/**
 * @author Gerardo Nunez
 * @Created on Mar 24, 2005
 * 
 * Purpose:
 * 	Encrypts passwords stored in database
 */
public class EncryptPassword implements Behavior {
	private String bName;
	
	public EncryptPassword( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
		  setBehaviorName( specificBehavior );
	   }
	   
	public EncryptPassword( Behavior b ) throws BehaviorException {
		try {
	  }
	  catch( ClassCastException cce ) {
	  }
	}
	
	public void execute( HttpServletRequest req, HttpServletResponse res, Connection con )
	  throws BehaviorException, SQLException {
			PrinterTools tool = new PrinterTools();
			con = null;
			Statement stmtAdminPass = null;
		
			  try {	
	  	
				con = tool.getConnection();
	
					stmtAdminPass = con.createStatement();
					stmtAdminPass.execute("set encryption password = '" + tool.getEncryptPass() + "'");
					
	
			  } catch(Exception e) {
					System.out.println("Error in EncryptPassword.encryptPassword ERROR: " + e);
			  } finally {
				  try {
						//stmtAdminPass.close();
						//con.close();
				  } catch (Exception e) {
						System.out.println("Error in EncryptPassword.encryptPassword.2 ERROR: " + e);
				  }
			  }
		
			} // end encryptPassword
			
	public String getBehaviorName() { return this.bName; }
		/**
		  * Returns the name of this behavior to be used in error messages.
		  * @param s the name of this specific instance of this behavior
		  */
	   public void setBehaviorName( String s ) { this.bName = s; }

}  //end of class EncryptPassword
