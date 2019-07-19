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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import tools.print.lib.AppTools;

/**
 * @author ganunez
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class PrinterDefTypeConfigUpdate {

	public int insertPrinterDefTypeConfig(HttpServletRequest req) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		Statement stmtPrinterDefTypeConfig = null;
		Statement stmtOSView = null;
		ResultSet PrinterDefTypeConfig_RS = null;
		ResultSet OSView_RS = null;
		String printerdeftypeid = req.getParameter("printerdeftypeid");
		int ReturnCode = 0;
		try {
			con = tool.getConnection();
			stmtPrinterDefTypeConfig = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	stmtOSView = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	OSView_RS = stmtOSView.executeQuery("SELECT OSID, OS_NAME, OS_ABBR, COMMENT, SEQUENCE_NUMBER FROM GPWS.OS ORDER BY SEQUENCE_NUMBER ASC");
		  	//System.out.println("SELECT OSID, OS_NAME, OS_ABBR, COMMENT, SEQUENCE_NUMBER FROM GPWS.OS ORDER BY SEQUENCE_NUMBER ASC");
		  	while (OSView_RS.next()) {
		  		String osprotocolid = req.getParameter("printerdeftypeid"+OSView_RS.getString("OS_ABBR"));
		  		if (!osprotocolid.equals("0") && !osprotocolid.equals("-1")) {
		  			stmtPrinterDefTypeConfig.executeUpdate("INSERT INTO GPWS.PRINTER_DEF_TYPE_CONFIG(OS_PROTOCOLID, PRINTER_DEF_TYPEID) VALUES (" + osprotocolid + "," + printerdeftypeid + ")");
			  		System.out.println("INSERT INTO GPWS.PRINTER_DEF_TYPE_CONFIG(OS_PROTOCOLID, PRINTER_DEF_TYPEID) VALUES (" + osprotocolid + "," + printerdeftypeid + ")");
			  		ReturnCode = 0;
		  		} //osdriverid not 0
		  	} //while OSView
		} catch (SQLException e){
			System.out.println("GPWSAdmin error in PrinterDefTypeConfigUpdate.class method insertPrinterDefTypeConfig ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("PrinterDefTypeConfigUpdate.insertPrinterDefTypeConfig.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in PrinterDefTypeConfigUpdate.insertPrinterDefTypeConfig.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			if (OSView_RS != null)
	  				OSView_RS.close();
	  			if (PrinterDefTypeConfig_RS != null)
	  				PrinterDefTypeConfig_RS.close();
	  			if (stmtOSView != null)
	  				stmtOSView.close();
	  			if (stmtPrinterDefTypeConfig != null)
	  				stmtPrinterDefTypeConfig.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in PrinterDefTypeConfigUpdate.insertPrinterDefTypeConfig.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
		
	}  //insert
	
	public int updatePrinterDefTypeConfig(HttpServletRequest req) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		Statement stmtPrinterDefTypeConfig = null;
		Statement stmtPrinterDefTypeConfig2 = null;
		Statement stmtPrinterDefTypeConfig3 = null;
		Statement stmtOSView = null;
		ResultSet PrinterDefTypeConfig_RS = null;
		ResultSet OSView_RS = null;
		String printerdeftypeid = req.getParameter("printerdeftypeid");
		int ReturnCode = 0;
		try {
			con = tool.getConnection();
			stmtPrinterDefTypeConfig = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmtPrinterDefTypeConfig2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			stmtPrinterDefTypeConfig3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	stmtOSView = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	OSView_RS = stmtOSView.executeQuery("SELECT OSID, OS_NAME, OS_ABBR, COMMENT, SEQUENCE_NUMBER FROM GPWS.OS ORDER BY SEQUENCE_NUMBER ASC");
		  	//System.out.println("SELECT OSID, OS_NAME, OS_ABBR, COMMENT, SEQUENCE_NUMBER FROM GPWS.OS ORDER BY SEQUENCE_NUMBER ASC");
		  	while (OSView_RS.next()) {
		  		String osprotocolid = req.getParameter("printerdeftypeid"+OSView_RS.getString("OS_ABBR"));
		  		String printerdeftypeconfigid = req.getParameter("printerdeftypeconfigid"+OSView_RS.getString("OS_ABBR"));
		  		if (printerdeftypeconfigid != null && !printerdeftypeconfigid.equals("")) {
		  			PrinterDefTypeConfig_RS = stmtPrinterDefTypeConfig.executeQuery("SELECT PRINTER_DEF_TYPE_CONFIGID, OS_PROTOCOLID, PRINTER_DEF_TYPEID FROM GPWS.PRINTER_DEF_TYPE_CONFIG WHERE PRINTER_DEF_TYPE_CONFIGID = "+printerdeftypeconfigid+"");
			  		//System.out.println("SELECT PRINTER_DEF_TYPE_CONFIGID, OS_PROTOCOLID, PRINTER_DEF_TYPEID FROM GPWS.PRINTER_DEF_TYPE_CONFIG WHERE PRINTER_DEF_TYPE_CONFIGID = "+printerdeftypeconfigid+"");
			  		while(PrinterDefTypeConfig_RS.next()) {
			  			if (!osprotocolid.equals("0") && PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") == 0) {
			  				stmtPrinterDefTypeConfig2.executeUpdate("INSERT INTO GPWS.PRINTER_DEF_TYPE_CONFIG(OS_PROTOCOLID, PRINTER_DEF_TYPEID) VALUES (" + osprotocolid + "," + printerdeftypeid + ")");
					  		//System.out.println("INSERT INTO GPWS.PRINTER_DEF_TYPE_CONFIG(OS_PROTOCOLID, PRINTER_DEF_TYPEID) VALUES (" + osprotocolid + "," + printerdeftypeid + ")");
			  			}
			  			else if ((osprotocolid.equals("-1") || osprotocolid.equals("0")) && PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") != 0) {
			  				stmtPrinterDefTypeConfig2.executeUpdate("DELETE FROM GPWS.PRINTER_DEF_TYPE_CONFIG WHERE PRINTER_DEF_TYPE_CONFIGID = " + PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") + "");
					  		//System.out.println("DELETE FROM GPWS.PRINTER_DEF_TYPE_CONFIG WHERE PRINTER_DEF_TYPE_CONFIGID = " + PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") + "");
			  			}
			  			else if (!osprotocolid.equals("0") && PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") != 0) {
			  				stmtPrinterDefTypeConfig2.executeUpdate("UPDATE GPWS.PRINTER_DEF_TYPE_CONFIG SET OS_PROTOCOLID = " + osprotocolid + ", PRINTER_DEF_TYPEID = " + printerdeftypeid + " WHERE PRINTER_DEF_TYPE_CONFIGID = " + PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") + "");
					  		//System.out.println("UPDATE GPWS.PRINTER_DEF_TYPE_CONFIGID SET OS_PROTOCOLID = " + osprotocolid + ", PRINTER_DEF_TYPEID = " + printerdeftypeid + " WHERE PRINTER_DEF_TYPE_CONFIGID = " + PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID") + "");
			  			}
			  		} //while DriverSetConfig_RS
		  		} else if (!osprotocolid.equals("0")){ //is not null
		  			stmtPrinterDefTypeConfig3.executeUpdate("INSERT INTO GPWS.PRINTER_DEF_TYPE_CONFIG(OS_PROTOCOLID, PRINTER_DEF_TYPEID) VALUES (" + osprotocolid + "," + printerdeftypeid + ")");
			  		//System.out.println("INSERT INTO GPWS.PRINTER_DEF_TYPE_CONFIG(OS_PROTOCOLID, PRINTER_DEF_TYPEID) VALUES (" + osprotocolid + "," + printerdeftypeid + ")");
		  		}
		  	} //while OSView
		} catch (SQLException e){
			System.out.println("GPWSAdmin error in DriverSetConfigUpdate.class method updateDriverSetConfig ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("PrinterDefTypeConfigUpdate.updatePrinterDefTypeConfig.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in PrinterDefTypeConfigUpdate.updatePrinterDefTypeConfig.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			if (OSView_RS != null)
	  				OSView_RS.close();
	  			if (PrinterDefTypeConfig_RS != null)
	  				PrinterDefTypeConfig_RS.close();
	  			if (stmtOSView != null)
	  				stmtOSView.close();
	  			if (stmtPrinterDefTypeConfig != null)
	  				stmtPrinterDefTypeConfig.close();
	  			if (stmtPrinterDefTypeConfig2 != null)
	  				stmtPrinterDefTypeConfig2.close();
	  			if (stmtPrinterDefTypeConfig3 != null)
	  				stmtPrinterDefTypeConfig3.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.insertDriverSetConfig.2 ERROR: " + e);
	  		}
		} //finally
		
		
		return ReturnCode;
	}  //update
	
} //class
