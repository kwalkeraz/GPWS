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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
//import java.sql.Statement;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import tools.print.lib.AppTools;

/**
 * @author ganunez
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DriverSetConfigUpdate {

	public int insertDriverSetConfig(HttpServletRequest req) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psDriverSetConfig = null;
		PreparedStatement psOSView = null;
		ResultSet DriverSetConfig_RS = null;
		ResultSet OSView_RS = null;
		String driversetid = req.getParameter("driver_setid");
		int ReturnCode = 0;
		String osQuery = "";
		String insertQuery = "";
		try {
			con = tool.getConnection();
		  	osQuery = "SELECT OSID, OS_NAME, OS_ABBR, COMMENT, SEQUENCE_NUMBER FROM GPWS.OS ORDER BY SEQUENCE_NUMBER ASC";
			psOSView = con.prepareStatement(osQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			OSView_RS = psOSView.executeQuery();
			while (OSView_RS.next()) {
				String osdriverid = tool.nullStringConverter(req.getParameter("driver"+OSView_RS.getString("OS_ABBR")));
		  		String optionsfileid = tool.nullStringConverter(req.getParameter("optionsfile"+OSView_RS.getString("OS_ABBR")));
		  		if (optionsfileid == null || optionsfileid.equals("0") || !optionsfileid.equals("")) {
		  			optionsfileid = null;
		  		}
		  		if (!osdriverid.equals("0") && !osdriverid.equals("-1") && !osdriverid.equals("")) {
		  			insertQuery = "INSERT INTO GPWS.DRIVER_SET_CONFIG(OS_DRIVERID, DRIVER_SETID, OPTIONS_FILEID) VALUES (?, ?, ?)";
			  		psDriverSetConfig = con.prepareStatement(insertQuery);
			  		psDriverSetConfig.setInt(1,Integer.parseInt(osdriverid));
			  		psDriverSetConfig.setInt(2,Integer.parseInt(driversetid));
			  		if (optionsfileid != null) psDriverSetConfig.setInt(3,Integer.parseInt(optionsfileid)); else psDriverSetConfig.setNull(3,Types.INTEGER);
			  		psDriverSetConfig.executeUpdate();
			  		ReturnCode = 0;
		  		} //osdriverid not 0
		  	} //while OSView
		} catch (SQLException e){
			System.out.println("GPWSAdmin error in DriverSetConfigUpdate.class method insertDriverSetConfig ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("DriverSetConfigUpdate.DriverSetConfig.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.DriverSetConfig.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			if (OSView_RS != null)
	  				OSView_RS.close();
	  			if (DriverSetConfig_RS != null)
	  				DriverSetConfig_RS.close();
	  			if (psOSView != null)
	  				psOSView.close();
	  			if (psDriverSetConfig != null)
	  				psDriverSetConfig.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.insertDriverSetConfig.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
		
	}  //insert
	
	public int updateDriverSetConfig(HttpServletRequest req) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psDriverSetConfig = null;
		PreparedStatement psDriverSetConfig2 = null;
		PreparedStatement psDriverSetConfig3 = null;
		PreparedStatement psOSView = null;
		ResultSet DriverSetConfig_RS = null;
		ResultSet OSView_RS = null;
		String driversetid = tool.nullStringConverter(req.getParameter("driver_setid"));
		int ReturnCode = 0;
		String osQuery = "";
		String driverQuery = "";
		String insertQuery = "";
		try {
			con = tool.getConnection();
		  	osQuery = "SELECT OSID, OS_NAME, OS_ABBR, COMMENT, SEQUENCE_NUMBER FROM GPWS.OS ORDER BY SEQUENCE_NUMBER ASC";
			psOSView = con.prepareStatement(osQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	OSView_RS = psOSView.executeQuery();
			while (OSView_RS.next()) {
				String osdriverid = tool.nullStringConverter(req.getParameter("driver"+OSView_RS.getString("OS_ABBR")));
		  		String driversetconfigid = tool.nullStringConverter(req.getParameter("driversetconfigid"+OSView_RS.getString("OS_ABBR")));
		  		String optionsfileid = tool.nullStringConverter(req.getParameter("optionsfile"+OSView_RS.getString("OS_ABBR")));
		  		if (optionsfileid == null || optionsfileid.equals("0") || optionsfileid.equals("")) {
		  			optionsfileid = null;
		  		}
		  		if (!driversetconfigid.equals("")) {
		  			driverQuery = "SELECT DRIVER_SET_CONFIGID, OS_DRIVERID, DRIVER_SETID FROM GPWS.DRIVER_SET_CONFIG WHERE DRIVER_SET_CONFIGID = ?";
		  			psDriverSetConfig = con.prepareStatement(driverQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  			psDriverSetConfig.setInt(1, Integer.parseInt(driversetconfigid));
		  			DriverSetConfig_RS = psDriverSetConfig.executeQuery();
		  			while(DriverSetConfig_RS.next()) {
		  				if (!osdriverid.equals("0") && !osdriverid.equals("") && DriverSetConfig_RS.getInt("DRIVER_SET_CONFIGID") == 0) {
			  				insertQuery = "INSERT INTO GPWS.DRIVER_SET_CONFIG(OS_DRIVERID, DRIVER_SETID, OPTIONS_FILEID) VALUES (?, ?, ?)";
			  				psDriverSetConfig2 = con.prepareStatement(insertQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			  				psDriverSetConfig2.setInt(1, Integer.parseInt(osdriverid));
			  				psDriverSetConfig2.setInt(2, Integer.parseInt(driversetid));
			  				if (optionsfileid != null) psDriverSetConfig.setInt(3,Integer.parseInt(optionsfileid)); else psDriverSetConfig.setNull(3,Types.INTEGER);
			  				psDriverSetConfig2.executeUpdate();
			  			}
			  			else if ((osdriverid.equals("-1") || osdriverid.equals("0")) && DriverSetConfig_RS.getInt("DRIVER_SET_CONFIGID") != 0) {
			  				insertQuery = "DELETE FROM GPWS.DRIVER_SET_CONFIG WHERE DRIVER_SET_CONFIGID = ?";
			  				psDriverSetConfig2 = con.prepareStatement(insertQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			  				psDriverSetConfig2.setInt(1, DriverSetConfig_RS.getInt("DRIVER_SET_CONFIGID"));
			  				psDriverSetConfig2.executeUpdate();
			  			}
			  			else if (!osdriverid.equals("0") && !osdriverid.equals("") && DriverSetConfig_RS.getInt("DRIVER_SET_CONFIGID") != 0) {
			  				insertQuery = "UPDATE GPWS.DRIVER_SET_CONFIG SET OS_DRIVERID = ?, DRIVER_SETID = ?, OPTIONS_FILEID = ? WHERE DRIVER_SET_CONFIGID = ?";
			  				psDriverSetConfig2 = con.prepareStatement(insertQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			  				psDriverSetConfig2.setInt(1, Integer.parseInt(osdriverid));
			  				psDriverSetConfig2.setInt(2, Integer.parseInt(driversetid));
			  				if (optionsfileid != null) psDriverSetConfig2.setInt(3,Integer.parseInt(optionsfileid)); else psDriverSetConfig2.setNull(3,Types.INTEGER);
			  				psDriverSetConfig2.setInt(4, DriverSetConfig_RS.getInt("DRIVER_SET_CONFIGID"));
			  				psDriverSetConfig2.executeUpdate();
			  			}
			  		} //while DriverSetConfig_RS
		  		} else if (!osdriverid.equals("0") && !osdriverid.equals("")){ //is not null
		  			insertQuery = "INSERT INTO GPWS.DRIVER_SET_CONFIG(OS_DRIVERID, DRIVER_SETID, OPTIONS_FILEID) VALUES (?, ?, ?)";
	  				psDriverSetConfig3 = con.prepareStatement(insertQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	  				psDriverSetConfig3.setInt(1, Integer.parseInt(osdriverid));
	  				psDriverSetConfig3.setInt(2, Integer.parseInt(driversetid));
	  				if (optionsfileid != null) psDriverSetConfig3.setInt(3,Integer.parseInt(optionsfileid)); else psDriverSetConfig3.setNull(3,Types.INTEGER);
	  				psDriverSetConfig3.executeUpdate();
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
	   			tool.logError("DriverSetConfigUpdate.updateDriverSetConfig.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.updateDriverSetConfig.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			if (OSView_RS != null)
	  				OSView_RS.close();
	  			if (DriverSetConfig_RS != null)
	  				DriverSetConfig_RS.close();
	  			if (psOSView != null)
	  				psOSView.close();
	  			if (psDriverSetConfig != null)
	  				psDriverSetConfig.close();
	  			if (psDriverSetConfig2 != null)
	  				psDriverSetConfig2.close();
	  			if (psDriverSetConfig3 != null)
	  				psDriverSetConfig3.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.insertDriverSetConfig.2 ERROR: " + e);
	  		}
		} //finally
		
		
		return ReturnCode;
	}  //update
	
	/***********************************************************************************
	 * checkDriverSetConfigError
	 * 
	 * @param int - OSID, int - DriverSetID
	 * @return int[] - iReturnCode (0,1,2,3,4), iModelID (only on RC 1,2)
	 * RC 0: Everything is configured correctly for the DriverSetConfig to work.
	 * RC 1: OS Driver needs to be added for that specified OS on that driver.
	 * RC 2: Model and Driver need to be linked.
	 * RC 3: DriverSet and Model need to be linked.
	 * RC 4: An Exception occurred.
	 * 
	 **********************************************************************************/
	public int[] checkDriverSetConfigError(int osID, int driverSetID) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		
		PreparedStatement psDriverSetConfig = null;
		
		ResultSet DriverSetModel_RS = null;
		ResultSet ModelDriver_RS = null;
		ResultSet DriverOSDrivers_RS = null;
		
		boolean bDriverSetModel = false;
		boolean bModelDriver = false;
		boolean bDriverOSDrivers = false;
		
		int iReturnCode = 0;
		String sQuery = "";
		String insertQuery = "";
		int[] iReturnArray = new int[2];
		int iModelID = 0;
		try {
			con = tool.getConnection();
		  	sQuery = "SELECT MODELID FROM GPWS.MODEL_DRIVER_SET WHERE DRIVER_SETID = ?";
		  	psDriverSetConfig = con.prepareStatement(sQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	psDriverSetConfig.setInt(1,driverSetID);
			
			DriverSetModel_RS = psDriverSetConfig.executeQuery();
			while (DriverSetModel_RS.next()) {
				bDriverSetModel = true;
				iModelID = DriverSetModel_RS.getInt("MODELID");
			}
		  	
			if (bDriverSetModel == true) {
				sQuery = "SELECT DRIVERID FROM GPWS.MODEL_DRIVER WHERE MODELID IN (SELECT MODELID FROM GPWS.MODEL_DRIVER_SET WHERE DRIVER_SETID = ?)";
			  	psDriverSetConfig = con.prepareStatement(sQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			  	psDriverSetConfig.setInt(1,driverSetID);
			  	
			  	ModelDriver_RS = psDriverSetConfig.executeQuery();
				while (ModelDriver_RS.next()) {
					bModelDriver = true;
				}
				
				if (bModelDriver == true) {
					sQuery = "SELECT OS_DRIVER.OS_DRIVERID, DRIVER.DRIVER_MODEL FROM GPWS.OS_DRIVER OS_DRIVER, GPWS.DRIVER DRIVER WHERE OS_DRIVER.DRIVERID = DRIVER.DRIVERID AND OS_DRIVER.OSID = ? AND OS_DRIVER.DRIVERID IN (SELECT DRIVERID FROM GPWS.MODEL_DRIVER WHERE MODELID IN (SELECT MODELID FROM GPWS.MODEL_DRIVER_SET WHERE DRIVER_SETID = ?))";
				  	psDriverSetConfig = con.prepareStatement(sQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				  	psDriverSetConfig.setInt(1,osID);
				  	psDriverSetConfig.setInt(2,driverSetID);
				  	
				  	DriverOSDrivers_RS = psDriverSetConfig.executeQuery();
					while (DriverOSDrivers_RS.next()) {
						bDriverOSDrivers = true;
					}
				}
			}
			
			if (bDriverSetModel == false) {
				iReturnArray[0] = 3;
			} else if (bModelDriver == false) {
				iReturnArray[0] = 2;
				iReturnArray[1] = iModelID;
			} else if (bDriverOSDrivers == false) {
				iReturnArray[0] = 1;
				iReturnArray[1] = iModelID;
			} else {
				iReturnArray[0] = 0;
			}
			
		} catch (SQLException e){
			System.out.println("GPWSAdmin error in DriverSetConfigUpdate.class method insertDriverSetConfig ERROR1: " + e);
	  		//iReturnCode = 4;
	  		iReturnArray[0] = 4;
	  		try {
	   			tool.logError("DriverSetConfigUpdate.checkDriverSetConfigError.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.checkDriverSetConfigError.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			if (DriverSetModel_RS != null)
	  				DriverSetModel_RS.close();
	  			if (ModelDriver_RS != null)
	  				ModelDriver_RS.close();
	  			if (DriverOSDrivers_RS != null)
	  				DriverOSDrivers_RS.close();
	  			if (psDriverSetConfig != null)
	  				psDriverSetConfig.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in DriverSetConfigUpdate.checkDriverSetConfigError.2 ERROR: " + e);
	  		}
		} //finally
		
		//return iReturnCode;
		return iReturnArray;
		
	} 
	
} //class