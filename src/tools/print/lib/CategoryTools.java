/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.lib;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import tools.print.printer.PrinterTools;


/****************************************************************************************
 * CategoryTools																			
 * 																						
 * @author: Joe Comfort																	
 * Copyright IBM																		
 * 																						
 * This class contains methods that will return data from the Category view.							
 ****************************************************************************************/
public class CategoryTools {
	
	/*********************************************************************************************
	 * Get value in Category value 1 for a particular category and category code 
	 * @param category - This is the category_name value
	 * @param categoryCode - This is the category_code value
	 * @return - returns the value of category_value1 from the DB. Should only return 1 result.
	 *********************************************************************************************/
	public static String getCategoryValue1(String category, String categoryCode) {
		
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		AppTools appTool = new AppTools(); 
		String sValue = "";
			
		try {	
			con = appTool.getConnection();
			stmt = con.prepareStatement("SELECT CATEGORY_CODE, CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? AND CATEGORY_CODE = ? ORDER BY CATEGORY_CODE");
			stmt.setString(1, category);
			stmt.setString(2, categoryCode);
			rs = stmt.executeQuery(); 
			rs.next();
			sValue = rs.getString("CATEGORY_VALUE1"); 
				
		} catch(Exception e) {
			System.out.println("Error in CategoryTools.getCategoryValue1 ERROR: " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("Error in CategoryTools.getCategoryValue1 ERROR: " + e);
				}
			}
  		return sValue;
		
	} //getCategoryValue1
	
} // main class