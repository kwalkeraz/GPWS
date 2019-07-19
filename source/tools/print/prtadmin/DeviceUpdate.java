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
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import tools.print.lib.DateTime;
import tools.print.lib.AppTools;
import tools.print.printer.PrinterTools;

/**
 * @author ganunez
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DeviceUpdate {
	/**
	 * Takes the server values to be added and adds it to the server table, then
	 * takes each value of the protocol and adds them to the server_protocol table
	 * 
	 * @param req
	 * @param protocolArray
	 * @return sMessage
	 * @throws SQLException
	 * @throws IOException
	 * @throws ServletException
	 */
	
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.lib.DateTime");
	
	
	/*****************************************************
	 * insertDevice
	 *  
	 * @param req
	 * @return int
	 * @throws SQLException
	 * @throws IOException
	 * @throws ServletException
	 * @throws Exception
	 * 
	 * Description: Inserts a new device into the database
	 ******************************************************/
	public int insertDevice(HttpServletRequest req) throws SQLException, IOException, ServletException, Exception {
		
		AppTools tool = new AppTools();
		PrinterTools ptools = new PrinterTools();
		DateTime dateTime = new DateTime();
		Connection con = null;
		//Statement stmtDevice = null;
		ResultSet rsDevice = null;		
		//Get the values
		int locid = 0;
		//Get the location information
		String geo = req.getParameter("geo");
		String country = req.getParameter("country");
		String city = req.getParameter("city");
		String building = req.getParameter("building");
		String floor = req.getParameter("floor");
		String room = req.getParameter("room");
		// device information
		String devicename = req.getParameter("devicename");
		String status = req.getParameter("status");
		String roomaccess =req.getParameter("roomaccess");
		String roomphone =req.getParameter("roomphone");
		String landrop =req.getParameter("landrop");
		String connecttype =req.getParameter("connecttype");
		if (connecttype.equals("None")) connecttype = "";
		String e2ecategory =req.getParameter("end2end");
		String cs =tool.nullStringConverter(req.getParameter("cs"));
		String vm =tool.nullStringConverter(req.getParameter("vm"));
		String mvs =tool.nullStringConverter(req.getParameter("mvs"));
		String sap =tool.nullStringConverter(req.getParameter("sap"));
		String wts =tool.nullStringConverter(req.getParameter("wts"));
		String lpname =req.getParameter("lpname");
		String port =req.getParameter("port");
		String separatorpage =req.getParameter("separatorpage");
		if (separatorpage.equals("None")) separatorpage = "";
		String restrict =req.getParameter("restrict");
		String requestnumber =req.getParameter("requestnumber");
		String igsasset = tool.nullStringConverter(req.getParameter("igsasset"));
		if (igsasset.equals("None")) igsasset = "";
		String igsdevice = tool.nullStringConverter(req.getParameter("igsdevice"));
		if (igsdevice.equals("None")) igsdevice = "";
		String igskeyop = tool.nullStringConverter(req.getParameter("igskeyop"));
		if (igskeyop.equals("None")) igskeyop = "";
		String duplex = tool.nullStringConverter(req.getParameter("duplex"));
		if (duplex.equals("None")) duplex = "";
		String numtrays = tool.nullStringConverter(req.getParameter("numtrays"));
		String bodytray = tool.nullStringConverter(req.getParameter("bodytray"));
		String headertray = tool.nullStringConverter(req.getParameter("headertray"));
		String serialnum =req.getParameter("serialnum");
		String macaddress =req.getParameter("macaddress");
		String comment =req.getParameter("comment");
		String dipp = tool.nullStringConverter(req.getParameter("dipp"));
		if (dipp.equals("None")) dipp = "";
		String koname =req.getParameter("koname");
		String kophone =req.getParameter("kophone");
		String koemail =req.getParameter("koemail");
		String kocompanyid =req.getParameter("kocompany");
		if (kocompanyid.equals("0")) kocompanyid = null;
		String kopager =req.getParameter("kopager");
		String faxnumber = req.getParameter("faxnumber");
		String billdept = req.getParameter("billdept");
		String billdiv = req.getParameter("billdiv");
		String billdetail = req.getParameter("billdetail");
		String billemail = req.getParameter("billemail");
		String billname = req.getParameter("billname");
		String ipdomain = req.getParameter("ipdomain");
		String ipsubnet = req.getParameter("ipsubnet");
		String ipgateway = req.getParameter("ipgateway");
		String iphostname = req.getParameter("iphostname");
		String ipaddress = req.getParameter("ipaddress");
		String poolname = req.getParameter("poolname");
		String ipm = req.getParameter("ipm");
		String psname = req.getParameter("psname");
		String afp = req.getParameter("afp");
		String ps =tool.nullStringConverter(req.getParameter("ps"));
		String pcl =tool.nullStringConverter(req.getParameter("pcl"));
		String ascii =tool.nullStringConverter(req.getParameter("ascii"));
		String ipds =tool.nullStringConverter(req.getParameter("ipds"));
		String ppds =tool.nullStringConverter(req.getParameter("ppds"));
		String webvisible = tool.nullStringConverter(req.getParameter("webvisible"));
		if (webvisible.equals("None")) webvisible = "";
		String installable = tool.nullStringConverter(req.getParameter("installable"));
		if (installable.equals("None")) installable = "";
		String sdc = req.getParameter("sdc");
		if (sdc.equals("None")) sdc = "";
		String createdby =req.getParameter("createdby");
		//String createddate =req.getParameter("createddate");
		Timestamp createddate = dateTime.getSQLTimestamp();
		String creationmethod =req.getParameter("creationmethod");
		String installdate =req.getParameter("installdate");
		String modelid =req.getParameter("devicemodel");
		if (modelid.equals("0")) modelid = null;
		String ftpid =req.getParameter("ftpsite");
		if (ftpid.equals("0"))ftpid = null;
		String printerdeftypeid =req.getParameter("printerdeftype");
		if (printerdeftypeid.equals("0")) printerdeftypeid = null;
		String driversetid =req.getParameter("driverset");
		if (driversetid.equals("0"))driversetid = null;
		String commspoolsuperid =req.getParameter("process");
		if (commspoolsuperid.equals("0"))commspoolsuperid = null;
		String serverid =req.getParameter("server");
		if (serverid.equals("0")) serverid = null;
		restrict = ptools.EncryptString(restrict);
		//
		int sMessage = 0;
		PreparedStatement psLocation = null;
		PreparedStatement psDevice = null;
		PreparedStatement psDeviceid = null;
		PreparedStatement psDeviceFunction = null;
		PreparedStatement psFunction = null;
		ResultSet rs = null;
		ResultSet rsDeviceid = null;
		ResultSet DeviceFunction_RS = null;
		int counter = 0;
		int deviceid = 0;
		
	  try {
	  	con = tool.getConnection();
	  	//stmtDevice = con.createStatement();
	  	
	  	//first, get the location information
	  	psLocation = con.prepareStatement("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE GEO = ? AND COUNTRY = ? AND CITY = ? AND BUILDING_NAME = ? AND FLOOR_NAME = ?");
	  	//System.out.println("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE GEO = '"+geo+"' AND COUNTRY = '"+country+"' AND CITY = '"+city+"' AND BUILDING_NAME = '"+building+"' AND FLOOR_NAME = '"+floor+"'");
	  	psLocation.setString(1, geo);
	  	psLocation.setString(2, country);
	  	psLocation.setString(3, city);
	  	psLocation.setString(4, building);
	  	psLocation.setString(5, floor);
	  	rs = psLocation.executeQuery();
	  	while (rs.next()) {
	  		locid = rs.getInt("LOCID");
	  		//System.out.println("LOCID is " + locid);
	  	}

	  	//System.out.println("INSERT INTO GPWS.DEVICE (DEVICE_NAME, STATUS, ROOM, ROOM_ACCESS, ROOM_PHONE, LAN_DROP, CONNECT_TYPE, E2E_CATEGORY, CS, VM, MVS, SAP, WTS, LPNAME, PORT, SEPARATOR_PAGE, RESTRICT, REQUEST_NUMBER, IGS_ASSET, IGS_DEVICE, IGS_KEYOP, DUPLEX, NUMBER_TRAYS, BODY_TRAY, HEADER_TRAY, SERIAL_NUMBER, MAC_ADDRESS, COMMENT, DIPP, KO_NAME, KO_PHONE, KO_EMAIL, KO_COMPANY, KO_PAGER, FAX_NUMBER, BILL_DEPT, BILL_DIV, BILL_DETAIL, BILL_EMAIL, BILL_NAME, IP_DOMAIN, IP_SUBNET, IP_GATEWAY, IP_HOSTNAME, IP_ADDRESS, POOL_NAME, PS, PCL, ASCII, IPDS, PPDS, WEB_VISIBLE, INSTALLABLE, CREATED_BY, CREATION_DATE, CREATION_METHOD, INSTALL_DATE, LOCID, MODELID, FTPID, PRINTER_DEF_TYPEID, DRIVER_SETID, COMM_SPOOL_SUPERID, SERVERID) VALUES ('"+devicename + "', '" + status + "', '" + room + "', '" + roomaccess + "', '" + roomphone + "', '" + landrop + "', '" + connecttype + "', '" + e2ecategory + "', '" + cs + "', '" + vm + "', '" + mvs + "', '" + sap + "', '" + wts + "', '" + lpname + "', '" + port + "', '" + separatorpage + "', '" + restrict + "', '" + requestnumber + "', '" + igsasset + "', '" + igsdevice + "', '" + igskeyop + "', '" + duplex + "', '" + numtrays + "', '" + bodytray + "', '" + headertray + "', '" + serialnum + "', '" + macaddress + "', '" + comment + "', '" + dipp + "', '" + koname + "', '" + kophone + "', '" + koemail + "', '" + kocompany + "', '" + kopager + "', '" + faxnumber + "', '" + billdept + "', '" + billdiv + "', '" + billdetail + "', '" + billemail + "', '" + billname + "', '" + ipdomain + "', '" + ipsubnet + "', '" + ipgateway + "', '" + iphostname + "', '" + ipaddress + "', '" + poolname + "', '" + ps + "', '" + pcl + "', '" + ascii + "', '" + ipds + "', '" + ppds + "', '" + webvisible + "', '" + installable + "', '" + createdby + "', '" + createddate + "', '" + creationmethod + "', '" + installdate + "', " + locid + ", " + modelid + ", " + ftpid + ", " + printerdeftypeid + ", " + driversetid + ", " + commspoolsuperid + ", " + serverid + ")");
	  	psDevice = con.prepareStatement("INSERT INTO GPWS.DEVICE (DEVICE_NAME, STATUS, ROOM, ROOM_ACCESS, ROOM_PHONE, LAN_DROP, CONNECT_TYPE, E2E_CATEGORY, CS, VM, MVS, SAP, WTS, LPNAME, PORT, SEPARATOR_PAGE, RESTRICT, REQUEST_NUMBER, IGS_ASSET, IGS_DEVICE, IGS_KEYOP, DUPLEX, NUMBER_TRAYS, BODY_TRAY, HEADER_TRAY, SERIAL_NUMBER, MAC_ADDRESS, COMMENT, DIPP, KO_NAME, KO_PHONE, KO_EMAIL, KO_COMPANYID, KO_PAGER, FAX_NUMBER, BILL_DEPT, BILL_DIV, BILL_DETAIL, BILL_EMAIL, BILL_NAME, IP_DOMAIN, IP_SUBNET, IP_GATEWAY, IP_HOSTNAME, IP_ADDRESS, POOL_NAME, PS, PCL, ASCII, IPDS, PPDS, WEB_VISIBLE, INSTALLABLE, CREATED_BY, CREATION_DATE, CREATION_METHOD, INSTALL_DATE, LOCID, MODELID, FTPID, PRINTER_DEF_TYPEID, DRIVER_SETID, COMM_SPOOL_SUPERID, SERVERID, SERVER_SDC, IPM_QUEUE_NAME, PS_DEST_NAME, AFP_DEST_NAME) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	  	psDevice.setString(1,devicename);
	  	psDevice.setString(2,status);
	  	psDevice.setString(3,room);
	  	psDevice.setString(4,roomaccess);
	  	psDevice.setString(5,roomphone);
	  	psDevice.setString(6,landrop);
	  	psDevice.setString(7,connecttype);
	  	psDevice.setString(8,e2ecategory);
	  	psDevice.setString(9,cs);
	  	psDevice.setString(10,vm);
	  	psDevice.setString(11,mvs);
	  	psDevice.setString(12,sap);
	  	psDevice.setString(13,wts);
	  	psDevice.setString(14,lpname);
	  	psDevice.setString(15,port);
	  	psDevice.setString(16,separatorpage);
	  	psDevice.setString(17,restrict);
	  	psDevice.setString(18,requestnumber);
	  	psDevice.setString(19,igsasset);
	  	psDevice.setString(20,igsdevice);
	  	psDevice.setString(21,igskeyop);
	  	psDevice.setString(22,duplex);
	  	psDevice.setString(23,numtrays);
	  	psDevice.setString(24,bodytray);
	  	psDevice.setString(25,headertray);
	  	psDevice.setString(26,serialnum);
	  	psDevice.setString(27,macaddress);
	  	psDevice.setString(28,comment);
	  	psDevice.setString(29,dipp);
	  	psDevice.setString(30,koname);
	  	psDevice.setString(31,kophone);
	  	psDevice.setString(32,koemail);
	  	//psDevice.setString(33,kocompany);
	  	if (kocompanyid != null) psDevice.setInt(33,Integer.parseInt(kocompanyid)); else psDevice.setNull(33,Types.INTEGER);
	  	psDevice.setString(34,kopager);
	  	psDevice.setString(35,faxnumber);
	  	psDevice.setString(36,billdept);
	  	psDevice.setString(37,billdiv);
	  	psDevice.setString(38,billdetail);
	  	psDevice.setString(39,billemail);
	  	psDevice.setString(40,billname);
	  	psDevice.setString(41,ipdomain);
	  	psDevice.setString(42,ipsubnet);
	  	psDevice.setString(43,ipgateway);
	  	psDevice.setString(44,iphostname);
	  	psDevice.setString(45,ipaddress);
	  	psDevice.setString(46,poolname);
	  	psDevice.setString(47,ps);
	  	psDevice.setString(48,pcl);
	  	psDevice.setString(49,ascii);
	  	psDevice.setString(50,ipds);
	  	psDevice.setString(51,ppds);
	  	psDevice.setString(52,webvisible);
	  	psDevice.setString(53,installable);
	  	psDevice.setString(54,createdby);
	  	psDevice.setTimestamp(55,createddate);
	  	psDevice.setString(56,creationmethod);
	  	psDevice.setString(57,installdate);
	  	psDevice.setInt(58,locid);
	  	if (modelid != null) psDevice.setInt(59,Integer.parseInt(modelid)); else psDevice.setNull(59,Types.INTEGER);
	  	if (ftpid != null) psDevice.setInt(60,Integer.parseInt(ftpid)); else psDevice.setNull(60,Types.INTEGER);
	  	if (printerdeftypeid != null) psDevice.setInt(61,Integer.parseInt(printerdeftypeid)); else psDevice.setNull(61,Types.INTEGER);
	  	if (driversetid != null) psDevice.setInt(62,Integer.parseInt(driversetid)); else psDevice.setNull(62,Types.INTEGER);
	  	if (commspoolsuperid != null) psDevice.setInt(63,Integer.parseInt(commspoolsuperid)); else psDevice.setNull(63,Types.INTEGER);
	  	if (serverid != null) psDevice.setInt(64,Integer.parseInt(serverid)); else psDevice.setNull(64,Types.INTEGER);
	  	psDevice.setString(65,sdc);
	  	psDevice.setString(66,ipm);
	  	psDevice.setString(67,psname);
	  	psDevice.setString(68,afp);
	  	psDevice.executeUpdate();
	  	// end of prepared statements
	  	psDeviceid = con.prepareStatement("SELECT DEVICEID FROM GPWS.DEVICE WHERE DEVICE_NAME = ?");
	  	psDeviceid.setString(1, devicename);
	  	rsDeviceid = psDeviceid.executeQuery();
	  	while (rsDeviceid.next()) {
	  		deviceid = rsDeviceid.getInt("DEVICEID");
	  		//System.out.println("Device ID value is " + deviceid);
	  	}
	  	String sDeviceid = Integer.toString(deviceid);
	  	req.setAttribute("deviceid",sDeviceid);
	  	
	  	psDeviceFunction = con.prepareStatement("SELECT * FROM GPWS.CATEGORY_INFO WHERE CATEGORYID = (SELECT CATEGORYID FROM GPWS.CATEGORY WHERE CATEGORY_NAME = ?)");
	  	psDeviceFunction.setString(1, "DeviceFunction");
	  	DeviceFunction_RS = psDeviceFunction.executeQuery();
	  	while (DeviceFunction_RS.next()) {
	  		String functiontype = req.getParameter(DeviceFunction_RS.getString("CATEGORY_VALUE1").toLowerCase()+"type");
	  		//System.out.println("Function type value is " + functiontype);
	  		if (functiontype != null) {
	  			//stmtDevice.executeUpdate("INSERT INTO GPWS.DEVICE_FUNCTIONS (FUNCTION_NAME, DEVICEID) VALUES ('"+ functiontype + "',"+deviceid+")");
	  			psFunction = con.prepareStatement("INSERT INTO GPWS.DEVICE_FUNCTIONS (FUNCTION_NAME, DEVICEID) VALUES (?,?)");
	  			psFunction.setString(1,functiontype);
	  		  	psFunction.setInt(2,deviceid);
	  		  	psFunction.executeUpdate();
	  		}
	  	}
	  	sMessage = 0;
	  } catch (SQLException e) {
		  	String exc = e.toString();
	  		System.out.println("GPWSAdmin error in DeviceUpdate.class method insertDevice ERROR1: " + e);
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("DeviceUpdate.insertDevice.1", "GPWSAdmin", exc);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in DeviceUpdate.insertDevice.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (psDevice != null)
	  				psDevice.close();
	  			if (psDeviceFunction != null)
	  				psDeviceFunction.close();
	  			if (psFunction != null)
	  				psFunction.close();
	  			if (DeviceFunction_RS != null)
	  				DeviceFunction_RS.close();
	  			if (rs != null)
	  				rs.close();
	  			if (psLocation != null)
	  				psLocation.close();
	  			if (rsDevice != null)
	  				rsDevice.close();
	  			//if (stmtDevice != null)
		  			//stmtDevice.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in DeviceUpdate.insertDevice.2 ERROR: " + e);
	  		}
	  }
	  	return sMessage;
	} //method insertUser
	
	
	/*****************************************************************
	 * updateDevice
	 * 
	 * @param req
	 * @return int
	 * @throws SQLException
	 * @throws IOException
	 * @throws ServletException
	 * @throws Exception
	 * 
	 * Description: Updates a device in the database
	 * 
	 ******************************************************************/
	public int updateDevice(HttpServletRequest req) throws SQLException, IOException, ServletException, Exception {
		
		AppTools tool = new AppTools();
		PrinterTools ptools = new PrinterTools();
		DateTime dateTime = new DateTime();
		Connection con = null;
		//Statement stmtDevice = null;
		ResultSet rsDevice = null;		
		//Get the values
		int locid = 0;
		//Get the location information
		String deviceid = req.getParameter("deviceid");
		String geo = req.getParameter("geo");
		String country = req.getParameter("country");
		String city = req.getParameter("city");
		String building = req.getParameter("building");
		String floor = req.getParameter("floor");
		String room = req.getParameter("room");
		// device information
		String devicename = req.getParameter("devicename");
		String status = req.getParameter("status");
		String roomaccess =req.getParameter("roomaccess");
		String roomphone =req.getParameter("roomphone");
		String landrop =req.getParameter("landrop");
		String connecttype =req.getParameter("connecttype");
		if (connecttype.equals("None")) connecttype = "";
		String e2ecategory =req.getParameter("end2end");
		String cs =tool.nullStringConverter(req.getParameter("cs"));
		String vm =tool.nullStringConverter(req.getParameter("vm"));
		String mvs =tool.nullStringConverter(req.getParameter("mvs"));
		String sap =tool.nullStringConverter(req.getParameter("sap"));
		String wts =tool.nullStringConverter(req.getParameter("wts"));
		String lpname =req.getParameter("lpname");
		String port =req.getParameter("port");
		String separatorpage =req.getParameter("separatorpage");
		if (separatorpage.equals("None")) separatorpage = "";
		String restrict =req.getParameter("restrict");
		String requestnumber =req.getParameter("requestnumber");
		String igsasset = tool.nullStringConverter(req.getParameter("igsasset"));
		if (igsasset.equals("None")) igsasset = "";
		String igsdevice = tool.nullStringConverter(req.getParameter("igsdevice"));
		if (igsdevice.equals("None")) igsdevice = "";
		String igskeyop = tool.nullStringConverter(req.getParameter("igskeyop"));
		if (igskeyop.equals("None")) igskeyop = "";
		String duplex = tool.nullStringConverter(req.getParameter("duplex"));
		if (duplex.equals("None")) duplex = "";
		String numtrays = tool.nullStringConverter(req.getParameter("numtrays"));
		String bodytray = tool.nullStringConverter(req.getParameter("bodytray"));
		String headertray = tool.nullStringConverter(req.getParameter("headertray"));
		String serialnum =req.getParameter("serialnum");
		String macaddress =req.getParameter("macaddress");
		String comment =req.getParameter("comment");
		String dipp = tool.nullStringConverter(req.getParameter("dipp"));
		if (dipp.equals("None")) dipp = "";
		String koname =req.getParameter("koname");
		String kophone =req.getParameter("kophone");
		String koemail =req.getParameter("koemail");
		//String kocompany =req.getParameter("kocompany");
		String kocompanyid =req.getParameter("kocompany");
		if (kocompanyid.equals("0")) kocompanyid = null;
		String kopager =req.getParameter("kopager");
		String faxnumber =req.getParameter("faxnumber");
		String billdept =req.getParameter("billdept");
		String billdiv =req.getParameter("billdiv");
		String billdetail =req.getParameter("billdetail");
		String billemail =req.getParameter("billemail");
		String billname =req.getParameter("billname");
		String ipdomain =req.getParameter("ipdomain");
		String ipsubnet =req.getParameter("ipsubnet");
		String ipgateway =req.getParameter("ipgateway");
		String iphostname =req.getParameter("iphostname");
		String ipaddress =req.getParameter("ipaddress");
		String poolname =req.getParameter("poolname");
		String ipm = req.getParameter("ipm");
		String psname = req.getParameter("psname");
		String afp = req.getParameter("afp");
		String ps =tool.nullStringConverter(req.getParameter("ps"));
		String pcl =tool.nullStringConverter(req.getParameter("pcl"));
		String ascii =tool.nullStringConverter(req.getParameter("ascii"));
		String ipds =tool.nullStringConverter(req.getParameter("ipds"));
		String ppds =tool.nullStringConverter(req.getParameter("ppds"));
		String webvisible = tool.nullStringConverter(req.getParameter("webvisible"));
		if (webvisible.equals("None")) webvisible = "";
		String installable = tool.nullStringConverter(req.getParameter("installable"));
		if (installable.equals("None")) installable = "";
		String sdc = req.getParameter("sdc");
		if (sdc.equals("None")) sdc = "";
		String lastmodifiedby =req.getParameter("lastmodifiedby");
		Timestamp lastmodified = dateTime.getSQLTimestamp();
		String creationmethod = req.getParameter("creationmethod");
		String installdate = req.getParameter("installdate");
		String deletedate = req.getParameter("deletedate");
		String modelid = req.getParameter("devicemodel");
		if (modelid.equals("0")) modelid = null;
		String ftpid = req.getParameter("ftpsite");
		if (ftpid.equals("0"))ftpid = null;
		String printerdeftypeid =req.getParameter("printerdeftype");
		if (printerdeftypeid.equals("0")) printerdeftypeid = null;
		String driversetid =req.getParameter("driverset");
		if (driversetid.equals("0"))driversetid = null;
		String commspoolsuperid =req.getParameter("process");
		if (commspoolsuperid.equals("0"))commspoolsuperid = null;
		String serverid =req.getParameter("server");
		if (serverid.equals("0")) serverid = null;
		restrict = ptools.EncryptString(restrict);
		//
		int sMessage = 0;
		PreparedStatement psLocation = null;
		PreparedStatement psDevice = null;
		PreparedStatement psDeviceid = null;
		PreparedStatement psDeviceFunction = null;
		PreparedStatement psDeviceFunctionCategory = null;
		PreparedStatement psFunction = null;
		ResultSet rs = null;
		ResultSet rsDeviceid = null;
		ResultSet DeviceFunction_RS = null;
		ResultSet DeviceFunctionCategory_RS = null;
		int counter = 0;
		
	  try {
	  	con = tool.getConnection();
	  	//stmtDevice = con.createStatement();
	  	
	  	//first, get the location information
	  	psLocation = con.prepareStatement("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE GEO = ? AND COUNTRY = ? AND CITY = ? AND BUILDING_NAME = ? AND FLOOR_NAME = ?");
	  	//System.out.println("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE GEO = '"+geo+"' AND COUNTRY = '"+country+"' AND CITY = '"+city+"' AND BUILDING_NAME = '"+building+"' AND FLOOR_NAME = '"+floor+"'");
	  	psLocation.setString(1, geo);
	  	psLocation.setString(2, country);
	  	psLocation.setString(3, city);
	  	psLocation.setString(4, building);
	  	psLocation.setString(5, floor);
	  	rs = psLocation.executeQuery();
	  	while (rs.next()) {
	  		locid = rs.getInt("LOCID");
	  		//System.out.println("LOCID is " + locid);
	  	}

	  	psDevice = con.prepareStatement("UPDATE GPWS.DEVICE SET DEVICE_NAME = ?, STATUS = ?, ROOM = ?, ROOM_ACCESS = ?, ROOM_PHONE = ?, LAN_DROP = ?, CONNECT_TYPE = ?, E2E_CATEGORY = ?, CS = ?, VM = ?, MVS = ?, SAP = ?, WTS = ?, LPNAME = ?, PORT = ?, SEPARATOR_PAGE = ?, RESTRICT = ?, REQUEST_NUMBER = ?, IGS_ASSET = ?, IGS_DEVICE = ?, IGS_KEYOP = ?, DUPLEX = ?, NUMBER_TRAYS = ?, BODY_TRAY = ?, HEADER_TRAY = ?, SERIAL_NUMBER = ?, MAC_ADDRESS = ?, COMMENT = ?, DIPP = ?, KO_NAME = ?, KO_PHONE = ?, KO_EMAIL = ?, KO_COMPANYID = ?, KO_PAGER = ?, FAX_NUMBER = ?, BILL_DEPT = ?, BILL_DIV = ?, BILL_DETAIL = ?, BILL_EMAIL = ?, BILL_NAME = ?, IP_DOMAIN = ?, IP_SUBNET = ?, IP_GATEWAY = ?, IP_HOSTNAME = ?, IP_ADDRESS = ?, POOL_NAME = ?, PS = ?, PCL = ?, ASCII = ?, IPDS = ?, PPDS = ?, WEB_VISIBLE = ?, INSTALLABLE = ?, MODIFIED_BY = ?, MODIFIED_DATE = ?, INSTALL_DATE = ?, DELETE_DATE = ?, LOCID = ?, MODELID = ?, FTPID = ?, PRINTER_DEF_TYPEID = ?, DRIVER_SETID = ?, COMM_SPOOL_SUPERID = ?, SERVERID = ?, SERVER_SDC = ?, IPM_QUEUE_NAME = ?, PS_DEST_NAME = ?, AFP_DEST_NAME = ? WHERE DEVICEID = ?");
	  	psDevice.setString(1,devicename);
	  	psDevice.setString(2,status);
	  	psDevice.setString(3,room);
	  	psDevice.setString(4,roomaccess);
	  	psDevice.setString(5,roomphone);
	  	psDevice.setString(6,landrop);
	  	psDevice.setString(7,connecttype);
	  	psDevice.setString(8,e2ecategory);
	  	psDevice.setString(9,cs);
	  	psDevice.setString(10,vm);
	  	psDevice.setString(11,mvs);
	  	psDevice.setString(12,sap);
	  	psDevice.setString(13,wts);
	  	psDevice.setString(14,lpname);
	  	psDevice.setString(15,port);
	  	psDevice.setString(16,separatorpage);
	  	psDevice.setString(17,restrict);
	  	psDevice.setString(18,requestnumber);
	  	psDevice.setString(19,igsasset);
	  	psDevice.setString(20,igsdevice);
	  	psDevice.setString(21,igskeyop);
	  	psDevice.setString(22,duplex);
	  	psDevice.setString(23,numtrays);
	  	psDevice.setString(24,bodytray);
	  	psDevice.setString(25,headertray);
	  	psDevice.setString(26,serialnum);
	  	psDevice.setString(27,macaddress);
	  	psDevice.setString(28,comment);
	  	psDevice.setString(29,dipp);
	  	psDevice.setString(30,koname);
	  	psDevice.setString(31,kophone);
	  	psDevice.setString(32,koemail);
	  	if (kocompanyid != null) psDevice.setInt(33,Integer.parseInt(kocompanyid)); else psDevice.setNull(33,Types.INTEGER);
	  	//psDevice.setInt(33,kocompany);
	  	psDevice.setString(34,kopager);
	  	psDevice.setString(35,faxnumber);
	  	psDevice.setString(36,billdept);
	  	psDevice.setString(37,billdiv);
	  	psDevice.setString(38,billdetail);
	  	psDevice.setString(39,billemail);
	  	psDevice.setString(40,billname);
	  	psDevice.setString(41,ipdomain);
	  	psDevice.setString(42,ipsubnet);
	  	psDevice.setString(43,ipgateway);
	  	psDevice.setString(44,iphostname);
	  	psDevice.setString(45,ipaddress);
	  	psDevice.setString(46,poolname);
	  	psDevice.setString(47,ps);
	  	psDevice.setString(48,pcl);
	  	psDevice.setString(49,ascii);
	  	psDevice.setString(50,ipds);
	  	psDevice.setString(51,ppds);
	  	psDevice.setString(52,webvisible);
	  	psDevice.setString(53,installable);
	  	psDevice.setString(54,lastmodifiedby);
	  	psDevice.setTimestamp(55,lastmodified);
	  	psDevice.setString(56,installdate);
	  	psDevice.setString(57,deletedate);
	  	psDevice.setInt(58,locid);
	  	if (modelid != null) psDevice.setInt(59,Integer.parseInt(modelid)); else psDevice.setNull(59,Types.INTEGER);
	  	if (ftpid != null) psDevice.setInt(60,Integer.parseInt(ftpid)); else psDevice.setNull(60,Types.INTEGER);
	  	if (printerdeftypeid != null) psDevice.setInt(61,Integer.parseInt(printerdeftypeid)); else psDevice.setNull(61,Types.INTEGER);
	  	if (driversetid != null) psDevice.setInt(62,Integer.parseInt(driversetid)); else psDevice.setNull(62,Types.INTEGER);
	  	if (commspoolsuperid != null) psDevice.setInt(63,Integer.parseInt(commspoolsuperid)); else psDevice.setNull(63,Types.INTEGER);
	  	if (serverid != null) psDevice.setInt(64,Integer.parseInt(serverid)); else psDevice.setNull(64,Types.INTEGER);
	  	psDevice.setString(65,sdc);
	  	psDevice.setString(66,ipm);
	  	psDevice.setString(67,psname);
	  	psDevice.setString(68,afp);
	  	psDevice.setString(69,deviceid);
	  	psDevice.executeUpdate();
	  	// end of prepared statements
	  	
	  	//Now, let's look at the functions
	  	psDeviceFunctionCategory = con.prepareStatement("SELECT * FROM GPWS.CATEGORY_INFO WHERE CATEGORYID = (SELECT CATEGORYID FROM GPWS.CATEGORY WHERE CATEGORY_NAME = ?) ORDER BY CATEGORY_VALUE1",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	  	psDeviceFunctionCategory.setString(1, "DeviceFunction");
	  	DeviceFunctionCategory_RS = psDeviceFunctionCategory.executeQuery();
	  	psDeviceFunction = con.prepareStatement("SELECT * FROM GPWS.DEVICE_FUNCTIONS WHERE DEVICEID = ? ORDER BY FUNCTION_NAME",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	  	psDeviceFunction.setInt(1, Integer.parseInt(deviceid));
	  	DeviceFunction_RS = psDeviceFunction.executeQuery();
	  	//first, get all the possible functions
	  	while (DeviceFunctionCategory_RS.next()) {
	  		DeviceFunctionCategory_RS.getString("CATEGORY_VALUE1");
	  		counter++;
	  	}
	  	String[] userArray = new String[counter];
	  	String[] devfuncArrayinDB = new String[counter];
	  	int counter2 = 0;
	  	int counter3 = 0;
	  	DeviceFunctionCategory_RS.beforeFirst();
	  	while (DeviceFunctionCategory_RS.next()) {
	  		userArray[counter2] = req.getParameter(DeviceFunctionCategory_RS.getString("CATEGORY_VALUE1").toLowerCase()+"type");
	  		counter2++;
	  	}
	  	while (DeviceFunction_RS.next()) {
  			devfuncArrayinDB[counter3] = DeviceFunction_RS.getString("FUNCTION_NAME");
  			counter3++;
  		} //while loop
	  	
	  	for (int x = 0; x < userArray.length; x++) {
	  		boolean functionExists = false;
	  		for (int z = 0; z < devfuncArrayinDB.length; z++) {
	  			if (userArray[x] != null && devfuncArrayinDB[z] != null && userArray[x].equals(devfuncArrayinDB[z])) {
	  				functionExists = true;
	  			}
	  		}  // first for loop
	  		if (userArray[x]!= null && !functionExists) {
	  			psFunction = con.prepareStatement("INSERT INTO GPWS.DEVICE_FUNCTIONS (FUNCTION_NAME, DEVICEID) VALUES (?,?)");
	  			psFunction.setString(1,userArray[x]);
	  		  	psFunction.setInt(2,Integer.parseInt(deviceid));
	  		  	psFunction.executeUpdate();
	  		}
	  	} // 2nd for loop
	  	
	  	for (int a = 0; a < devfuncArrayinDB.length; a++) {	
	  		boolean functionExists = false;	
	  		for (int b = 0; b < userArray.length; b++) {		
	  			if (userArray[b] != null && devfuncArrayinDB[a] != null && userArray[b].equals(devfuncArrayinDB[a])) {			
	  				functionExists = true;		
	  			}	
	  		}  //first for loop	
	  		if (devfuncArrayinDB[a] != null && !functionExists) {		
	  			psFunction = con.prepareStatement("DELETE FROM GPWS.DEVICE_FUNCTIONS WHERE DEVICEID = ? AND FUNCTION_NAME = ?");
	  			psFunction.setInt(1,Integer.parseInt(deviceid));
	  			psFunction.setString(2,devfuncArrayinDB[a]);
	  		  	psFunction.executeUpdate();
	  		}
	  	} //2nd for loop
	  	
	  	sMessage = 0;
	  } catch (SQLException e) {
		  	String exc = e.toString();
	  		System.out.println("GPWSAdmin error in DeviceUpdate.class method updateDevice ERROR1: " + e);
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("DeviceUpdate.updateDevice.1", "GPWSAdmin", exc);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in DeviceUpdate.updateDevice.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (psDevice != null)
	  				psDevice.close();
	  			if (psDeviceFunction != null)
	  				psDeviceFunction.close();
	  			if (psFunction != null)
	  				psFunction.close();
	  			if (DeviceFunction_RS != null)
	  				DeviceFunction_RS.close();
	  			if (rs != null)
	  				rs.close();
	  			if (psLocation != null)
	  				psLocation.close();
	  			if (rsDevice != null)
	  				rsDevice.close();
	  			//if (stmtDevice != null)
		  			//stmtDevice.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in DeviceUpdate.updateDevice.2 ERROR: " + e);
	  		}
	  }
	  	return sMessage;
		
	} //method updateDevice
	
	
	/*************************************************************************************
	 * updateDeviceLang
	 * 
	 * @param String aLangs - This is an array of languages that the user wants to add
	 * @param int iDeviceID - This is the deviceid for the device these languages are for
	 * 
	 * Description: This method will update the device_lang table with language codes
	 * and priorities based on user input. It will compare the values that currently exist
	 * in the database and only update/delete/insert those that are necessary. 
	 **************************************************************************************/
	public static int updateDeviceLang(String[] aLangs, int iDeviceID) throws SQLException, IOException, ServletException, Exception {
		
		int iRC = 0;
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ArrayList<String> alDevLangs = new ArrayList<String>();
		try {
		  	con = tool.getConnection();
		  	ps = con.prepareStatement("SELECT LANG_CODE, LANG_PRIORITY FROM GPWS.DEVICE_LANG WHERE DEVICEID = ? ORDER BY LANG_PRIORITY");
		  	ps.setInt(1,iDeviceID);
		  	rs = ps.executeQuery();
		  	// This loop will handle deleting old languages from the database and updating existing languages with new priority
		  	while (rs.next()) {
		  		String sLangCode = rs.getString("LANG_CODE");
		  		int iLangPriority = rs.getInt("LANG_PRIORITY");
		  		alDevLangs.add(sLangCode);
		  		boolean exists = false;
		  		
		  		for (int x = 0; x < aLangs.length; x++) {
		  			System.out.println("LangCode/aLangs = " + sLangCode + " : " + aLangs[x]);
		  			if (aLangs[x].equalsIgnoreCase(sLangCode)) { // Language exists in database and user selection
		  				exists = true;
		  				if ((x+1) != iLangPriority) { // Language priority is different, update the database
		  					ps = con.prepareStatement("UPDATE GPWS.DEVICE_LANG SET LANG_PRIORITY = ? WHERE LANG_CODE = ? AND DEVICEID = ?");
		  					ps.setInt(1, x+1);
		  					ps.setString(2, sLangCode);
		  					ps.setInt(3, iDeviceID);
		  					ps.execute();
		  				} // no else necessary because it means user didn't make a change to this language
		  			} // Languages don't match, keep going
		  		}
		  		if (exists == false) { // Language exists in database, but not in user selection so we need to delete it
		  			ps = con.prepareStatement("DELETE FROM GPWS.DEVICE_LANG WHERE LANG_CODE = ? AND DEVICEID = ?");
		  			ps.setString(1,sLangCode);
		  			ps.setInt(2, iDeviceID);
		  			ps.execute();
		  		}
		  	}
		  	
		  	// Now we need to loop through user selection array in order to add any languages that don't already exist in database
		  	for (int x = 0; x < aLangs.length; x++) {
		  		boolean exists = false;
		  		for (int z = 0; z < alDevLangs.size(); z++) {
		  			if (aLangs[x].equalsIgnoreCase(alDevLangs.get(z))) {
		  				exists = true;
		  			}
		  		}
		  		if (exists == false) {
		  			ps = con.prepareStatement("INSERT INTO GPWS.DEVICE_LANG (LANG_CODE, LANG_PRIORITY, DEVICEID) values (?,?,?)");
		  			ps.setString(1,aLangs[x]);
		  			ps.setInt(2, x+1);
					ps.setInt(3, iDeviceID);
					ps.execute();
		  		}
		  	}
		  	
		} catch (Exception e) {
			System.out.println("Error in DeviceUpdate.updateDeviceLang: " + e);
			iRC = 1;
		} finally {
			rs.close();
			ps.close();
			con.close();
		}
		
		return iRC;
	}
	
}  //class DeviceUpdate
