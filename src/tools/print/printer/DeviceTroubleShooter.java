/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.sql.*;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import tools.print.lib.GetTransTag;

/****************************************************************************************
 * DeviceTroubleShooter																			*
 * 																						*
 * @author: Joseph Comfort																	*
 * Copyright IBM																		*
 * 																						*
 ****************************************************************************************/
public class DeviceTroubleShooter {
	
	private int iDeviceID;
	private int iDriverSetID;
	private int iPrtDefTypeID;
	private String sStatus;
	private String sModel;
	private String sWebVisible;
	private String sInstallable;
	private String sFTPSite;
	
	private String sDriverSet;
	private boolean bValidDS = false;
	private String[] aOSName = new String[7];
	private String[] aDriverName = new String[7];
	private String[] aDriverModel = new String[7];
	private String[] aOptionsFile = new String[7];
	private String[] aPackage = new String[7];
	private boolean[] aValidDS = new boolean[7];
	private String sPrtDefType;
	private String sPort;
	private String sIP;
	private String sHostname;
	private String sSDC;
	private String sProcess;
	private String sServer;
	private String sHostPortConfig;
	private int[] aInstallError = new int[1000];
	private int[] aInstallErrorCount = new int[1000];
	private int iInstallErrorLength = 0;
	
	private boolean bInstallResult = true;
	private String sRC = "";
		
	PrinterTools tool = new PrinterTools();
	GetTransTag messages = null;
	
	/*******************
	 * constructor
	 *******************/
	public DeviceTroubleShooter(String sDevice, HttpServletRequest req) throws Exception {
		
		Connection con = null;
		
		try {
			Locale currentLocale = req.getLocale();
			messages = new GetTransTag();
			messages.setLocale(currentLocale);
			
			con = tool.getConnection();
			setDevice(con, sDevice);
			setDriver(con);
			setInstallErrors(con, sDevice);
			
		} catch (Exception e) {
			System.out.println("Error setting browser and os.");
		} finally {
			if (con != null)
				con.close();
		}
		
	}
		
	public int getDeviceID() { return iDeviceID; }
	public int getDriverSetID() { return iDriverSetID; }
	public int getPrtDefTypeID() { return iPrtDefTypeID; }
	public String getStatus() { return sStatus; }
	public String getModel() { return sModel; }
	public String getWebVisible() { return sWebVisible; }
	public String getInstallable() { return sInstallable; }
	public String getFTPSite() { return sFTPSite; }
	
	public String getDriverSet() { return sDriverSet; }
	public boolean getValidDS() { return bValidDS; }
	public String[] getOSName() { return aOSName; }
	public String[] getDriverName() { return aDriverName; }
	public String[] getDriverModel() { return aDriverModel; }
	public String[] getOptionsFile() { return aOptionsFile; }
	public String[] getPackage() { return aPackage; }
	public boolean[] getValidDSValues() { return aValidDS; }
	
	public String getPrtDefType() { return sPrtDefType; }
	public String getPort() { return sPort; }
	public String getIP() { return sIP; }
	public String getHostname() { return sHostname; }
	public String getSDC() { return sSDC; }
	public String getProcess() { return sProcess; }
	public String getServer() { return sServer; }
	public String getHostPortConfig() { return sHostPortConfig; }
	public int[] getInstallErrors() { return aInstallError; }
	public int[] getInstallErrorsCount() { return aInstallErrorCount; }
	public int getInstallErrorLength() { return iInstallErrorLength; }
	
	public boolean getInstallResult() { return bInstallResult; }
	public String getRC() { return sRC; }
   
	/**********************************************************************************************
    * setDevice																				  *
    * 																							  *
    * This method creates a connection to the specified database and returns that connection.     *
    ***********************************************************************************************/
   public void setDevice(Connection con, String sDevice) throws Exception {
   			
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		
	 try {
	 	
		stmt = con.prepareStatement("SELECT A.DEVICEID, A.STATUS, A.MODEL, A.WEB_VISIBLE, A.INSTALLABLE, A.DRIVER_SETID, A.FTP_SITE, A.PRINTER_DEF_TYPEID, A.CLIENT_DEF_TYPE, A.PORT, A.IP_ADDRESS, A.IP_HOSTNAME, A.IP_DOMAIN, A.SERVER_SDC, A.SERVER_NAME, B.HOST_PORT_CONFIG FROM GPWS.DEVICE_VIEW A, GPWS.PRINTER_DEF_TYPE_CONFIG_VIEW B WHERE A.PRINTER_DEF_TYPEID = B.PRINTER_DEF_TYPEID AND A.DEVICE_NAME = ?", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		stmt.setString(1, sDevice);
	    rs = stmt.executeQuery();
	    
	    while (rs.next()) {
	    	iDeviceID = rs.getInt("DEVICEID");
	    	sStatus = tool.nullStringConverter(rs.getString("STATUS"));
	    	sModel = tool.nullStringConverter(rs.getString("MODEL"));
	    	sWebVisible = tool.nullStringConverter(rs.getString("WEB_VISIBLE"));
	    	sInstallable = tool.nullStringConverter(rs.getString("INSTALLABLE"));
	    	iDriverSetID = rs.getInt("DRIVER_SETID");
	    	sFTPSite = rs.getString("FTP_SITE");
	    	iPrtDefTypeID = rs.getInt("PRINTER_DEF_TYPEID");
	    	sPrtDefType = tool.nullStringConverter(rs.getString("CLIENT_DEF_TYPE"));
	    	sServer = tool.nullStringConverter(rs.getString("SERVER_NAME"));
	    	sPort = tool.nullStringConverter(rs.getString("PORT"));
	    	sIP = tool.nullStringConverter(rs.getString("IP_ADDRESS"));
	    	sHostname = tool.nullStringConverter(rs.getString("IP_HOSTNAME")) + "." + tool.nullStringConverter(rs.getString("IP_DOMAIN"));
	    	sSDC = tool.nullStringConverter(rs.getString("SERVER_SDC"));
	    	sProcess = tool.nullStringConverter(rs.getString("SERVER_NAME"));
	    	sHostPortConfig = tool.nullStringConverter(rs.getString("HOST_PORT_CONFIG"));
    	}
    	
	    if (iDeviceID <= 0 ) { sRC = "Device not found. "; bInstallResult = false; }
	    if (sStatus == null || !sStatus.equalsIgnoreCase("COMPLETED")) { sRC += messages.getString("status_not_completed") + " "; bInstallResult = false; }
	    if (sModel == null || sModel.equalsIgnoreCase("")) { sRC += messages.getString("model_not_set") + " "; bInstallResult = false; }
	    if (sWebVisible == null || !sWebVisible.equalsIgnoreCase("Y")) { sRC += messages.getString("printer_not_visible") + " "; bInstallResult = false; }
	    if (sInstallable == null || !sInstallable.equalsIgnoreCase("Y")) { sRC += messages.getString("printer_not_installable") + " "; bInstallResult = false; }
	    if (iDriverSetID <= 0) { sRC += messages.getString("driver_set_not_assigned") + " "; bInstallResult = false; }
	    if (iPrtDefTypeID <= 0) { sRC += messages.getString("prtdeftype_not_assigned") + " "; bInstallResult = false; }
	    if (sPrtDefType.equalsIgnoreCase("DIPP") && (sPort == null || sPort.equals(""))) { sRC += messages.getString("port_missing") + " "; bInstallResult = false; }
	    if (sPrtDefType.equalsIgnoreCase("DIPP") && ((sIP == null || sIP.equals("")) && (sHostname == null || sHostname.equals("")))) { sRC += messages.getString("ip_missing") + " "; bInstallResult = false; }
	    if (sPrtDefType.equalsIgnoreCase("IPM") && (sServer == null || sServer.equals(""))) { sRC += messages.getString("server_missing") + " "; bInstallResult = false; }
	    if (sPrtDefType.equalsIgnoreCase("IPM") && (sProcess == null || sProcess.equals(""))) { sRC += messages.getString("server_process_missing") + " "; bInstallResult = false; }
	    
	 } catch (Exception e) {
	 	System.out.println("DeviceTroubleShooter.setDevice ERROR: " + e);
     } finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
     }
   }
   
   /**********************************************************************************************
    * setDriver
    * 
    * 
    ***********************************************************************************************/
   public void setDriver(Connection con) throws Exception {
   			
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		
	 try {

		stmt = con.prepareStatement("SELECT DSCV.DRIVER_SET_NAME, DSCV.OS_NAME, DSCV.DRIVER_NAME, DSCV.DRIVER_MODEL, DSCV.OPTIONS_FILE_NAME, OSD.PACKAGE FROM GPWS.DRIVER_SET_CONFIG_VIEW DSCV, GPWS.OS_DRIVER OSD WHERE DRIVER_SETID = ? AND DSCV.DRIVERID = OSD.DRIVERID AND DSCV.OSID = OSD.OSID", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		stmt.setInt(1, iDriverSetID);
	    rs = stmt.executeQuery();
	    int x = 0;
	    bValidDS = false;
	    while (rs.next()) {
	    	sDriverSet = tool.nullStringConverter(rs.getString("DRIVER_SET_NAME"));
	    	aOSName[x] = tool.nullStringConverter(rs.getString("OS_NAME"));
	    	aDriverName[x] = tool.nullStringConverter(rs.getString("DRIVER_NAME"));
	    	aDriverModel[x] = tool.nullStringConverter(rs.getString("DRIVER_MODEL"));
	    	aOptionsFile[x] = tool.nullStringConverter(rs.getString("OPTIONS_FILE_NAME"));
	    	aPackage[x] = tool.nullStringConverter(rs.getString("PACKAGE"));
	    	aValidDS[x] = true;
	    	if (aDriverName[x] == null || aDriverName[x].equals("") || aDriverModel[x] == null || aDriverModel[x].equals("") || aPackage[x].equals("")) {
	    		bValidDS = false;
	    	} else {
	    		bValidDS = true;
	    	}
	    	x++;
	    }
	    
	    
	 } catch (Exception e) {
	 	System.out.println("DeviceTroubleShooter.setDriver ERROR: " + e);
     } finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
     }
   }
   
   /**********************************************************************************************
    * getOS
    * 
    * 
    ***********************************************************************************************/
   public String[] getOS() throws Exception {
   			
	    Connection con = null;
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		String[] aOS = new String[10];
   		
	 try {
		con = tool.getConnection();
		stmt = con.prepareStatement("SELECT OS_NAME FROM GPWS.OS ORDER BY OS_NAME");
	    rs = stmt.executeQuery();
	    int x = 0;
	    while (rs.next()) {
	    	aOS[x] = tool.nullStringConverter(rs.getString("OS_NAME"));
	    	x++;
	    }
	    
	 } catch (Exception e) {
	 	System.out.println("DeviceTroubleShooter.getOS ERROR: " + e);
     } finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
     	if (con != null)
     		con.close();
     }
     	return aOS;
   }
   
   /**********************************************************************************************
    * setInstallErrors
    * 
    * 
    ***********************************************************************************************/
   public void setInstallErrors(Connection con, String sDevice) throws Exception {
   			
   		PreparedStatement stmt = null;
   		ResultSet rs = null;
   		
	 try {

		stmt = con.prepareStatement("SELECT INSTALL_RC, COUNT(*) AS COUNT FROM GPWS.PRINTER_LOG WHERE DEVICE_NAME = ? GROUP BY INSTALL_RC", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		stmt.setString(1, sDevice);
	    rs = stmt.executeQuery();
	    int x = 0;
	    while (rs.next()) {
	    	aInstallError[x] = rs.getInt("INSTALL_RC");
	    	aInstallErrorCount[x] = rs.getInt("COUNT");
	    	x++;
	    }
	    iInstallErrorLength = x;
	 } catch (Exception e) {
	 	System.out.println("DeviceTroubleShooter.setInstallErrors ERROR: " + e);
     } finally {
     	if (rs != null)
     		rs.close();
     	if (stmt != null)
     		stmt.close();
     }
   }
      
} // main class