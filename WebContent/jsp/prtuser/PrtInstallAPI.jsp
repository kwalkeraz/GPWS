<?xml version="1.0"?><%@ page contentType="application/xml; charset=utf-8" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %><%
	Connection con = null;
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	PreparedStatement stmtFields = null;
	ResultSet rsFields = null;
	
	String[] aFields = new String[250];
	String[] aXMLTag = new String[250];
	
	AppTools appTool = new AppTools();
	PrinterTools tool = new PrinterTools();
	ResourceBundle myResources = ResourceBundle.getBundle("tools.print.lib.AppTools");
	String sServer = myResources.getString("serverName");
	
	String sSQL = "";
	String sQuery = appTool.nullStringConverter(request.getParameter("query"));
	String sGeo = (appTool.nullStringConverter(request.getParameter("geo"))).replaceAll("%20"," ");
	String sCountry = (appTool.nullStringConverter(request.getParameter("country"))).replaceAll("%20"," ");
	String sState = appTool.nullStringConverter(request.getParameter("state"));
	String sCity = (appTool.nullStringConverter(request.getParameter("city"))).replaceAll("%20"," ");
	String sBuilding = (tool.stripLeadingZeros(appTool.nullStringConverter(request.getParameter("building"))).replaceAll("%20"," "));
	String sFloor = (tool.stripLeadingZeros(appTool.nullStringConverter(request.getParameter("floor"))).replaceAll("%20"," "));
	String sName = (appTool.nullStringConverter(request.getParameter("device"))).replaceAll("%20"," ");
	String sOS = (appTool.nullStringConverter(request.getParameter("os"))).replaceAll("%20"," ");
	String sFTP = (appTool.nullStringConverter(request.getParameter("ftp"))).replaceAll("%20"," ");
	String sIP = (appTool.nullStringConverter(request.getParameter("ip"))).replaceAll("%20"," ");
	boolean bFTP = false;
	boolean validSQL = true;
	boolean validQuery = true;
	String sFunctionSQL = "";
	String orFunctionSQL = "";
	String available = appTool.nullStringConverter(request.getParameter("deviceavailable")).toLowerCase(); //check for the type of device available (print, copy, fax, scan)
	String sStatus = appTool.nullStringConverter(request.getParameter("status")).toLowerCase();  //check to see if only requesting devices with completed status 
	String delims = "[,]";
	String[] tokens = available.split(delims);
	for (int i = 0; i < tokens.length; i++) {
	    //System.out.println(tokens[i]);
	    if (!tokens[i].equals("all")) {
			sFunctionSQL = "AND (FUNCTION_NAME = '" + tokens[i] + "'";
	    	if (tokens.length > 1) {
	    		orFunctionSQL += " OR FUNCTION_NAME = '" + tokens[i] + "'";
	    	}
	    	sFunctionSQL = sFunctionSQL + orFunctionSQL + ")";
	    } //if else
	} //for loop
	if (sStatus != "") {
		sFunctionSQL = sFunctionSQL + " AND UPPER(B.STATUS) = 'COMPLETED'";
	}
	
	String sFTPHomeDir = "";
	
try {

	if (sOS == null || sOS.equals("")) {
		sOS = "LX";
	}
	if (sFTP != null && !sFTP.equals("") && sFTP.toUpperCase().equals("TRUE")) {
		bFTP = true;
	} else {
		bFTP = false;
	}
	
	con = appTool.getConnection();
	
	if (sQuery.equals("geography")) { %>
<Geographies><%
		if (!available.equals("")) {
			sSQL = "SELECT GEO, GEO_ABBR, GEOID, EMAIL_ADDRESS, CCEMAIL_ADDRESS FROM GPWS.GEO A WHERE EXISTS (SELECT GEO FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.GEO = B.GEO " + sFunctionSQL + ") ORDER BY GEO";
		} else if (sGeo != null && !sGeo.equals("")) {
			sSQL = "SELECT GEO, GEO_ABBR, GEOID, EMAIL_ADDRESS, CCEMAIL_ADDRESS FROM GPWS.GEO WHERE GEOID = " + Integer.parseInt(sGeo);
		} else {
			sSQL = "SELECT GEO, GEO_ABBR, GEOID, EMAIL_ADDRESS, CCEMAIL_ADDRESS FROM GPWS.GEO ORDER BY GEO";
		}
	} else if (sQuery.equals("country")) { %>
<Countries><%
		if (sGeo != null && !sGeo.equals("") && !available.equals("")) {
			sSQL = "SELECT COUNTRY, COUNTRY_ABBR, COUNTRYID FROM GPWS.COUNTRY A WHERE GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND EXISTS (SELECT COUNTRY FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.COUNTRY = B.COUNTRY " + sFunctionSQL + ") ORDER BY COUNTRY";
		} else if (sGeo != null && !sGeo.equals("")) {
			sSQL = "SELECT COUNTRY, COUNTRY_ABBR, COUNTRYID FROM GPWS.COUNTRY WHERE GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "') ORDER BY COUNTRY";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("state")) { %>
<States><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && !available.equals("")) {
			sSQL = "SELECT STATE, STATEID FROM GPWS.STATE A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))) AND EXISTS (SELECT STATE FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.STATE = B.STATE " + sFunctionSQL + ") ORDER BY STATE";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("")) {
			sSQL = "SELECT STATE, STATEID FROM GPWS.STATE WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))) ORDER BY STATE";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("city")) { %>
<Cities><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sState != null && !sState.equals("") && !available.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + sState.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.CITYID = B.CITYID " + sFunctionSQL + ") ORDER BY CITY";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sState != null && !sState.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE UPPER(STATE) = '" + sState.toUpperCase() + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))) ORDER BY CITY";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && !available.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY A WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))) AND EXISTS (SELECT CITYID FROM GPWS.DEVICE_VIEW B WHERE A.CITYID = B.CITYID) ORDER BY CITY";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("")) {
			sSQL = "SELECT CITY, CITY_STATUS, CITYID FROM GPWS.CITY WHERE STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))) ORDER BY CITY";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("building")) { %>
<Buildings><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && !available.equals("")) {
			sSQL = "SELECT BUILDINGID, BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING A WHERE CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "')))) AND EXISTS (SELECT BUILDINGID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.BUILDINGID = B.BUILDINGID " + sFunctionSQL + ") ORDER BY BUILDING_NAME"; 
		} else if(sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("")) {
			sSQL = "SELECT BUILDING_NAME, TIER, SDC, SITE_CODE, WORK_LOC_CODE, BUILDING_STATUS, BUILDINGID FROM GPWS.BUILDING WHERE CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "')))) ORDER BY BUILDING_NAME";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("floor")) { %>
<Floors><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("") && !available.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION A WHERE BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))))) AND EXISTS (SELECT LOCID FROM GPWS.DEVICE_FUNCTIONS_VIEW B WHERE A.LOCID = B.LOCID " + sFunctionSQL + ") ORDER BY FLOOR_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("")) {
			sSQL = "SELECT FLOOR_NAME, FLOOR_STATUS, LOCID FROM GPWS.LOCATION WHERE BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "') AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND STATEID IN (SELECT STATEID FROM GPWS.STATE WHERE COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE UPPER(GEO) = '" + sGeo.toUpperCase() + "'))))) ORDER BY FLOOR_NAME";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("device")) {
		stmtFields = null;
	  	rsFields = null;
		stmtFields = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? ORDER BY CAST(CATEGORY_CODE AS INTEGER)");
		stmtFields.setString(1,"API-Device");
		rsFields = stmtFields.executeQuery(); 
		int count = 0;
		sSQL = "SELECT ";
		while (rsFields.next()) {
			if (count == 0) {
				sSQL += "A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			} else {
				sSQL += ", A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			}
		}  %>
<Devices><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("") && sFloor != null && !sFloor.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(FLOOR_NAME) = '" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '00" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '0" + sFloor.toUpperCase() + "' ) AND ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' ORDER BY DEVICE_NAME";
		} else if (sName != null && !sName.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE UPPER(DEVICE_NAME) LIKE '%" + sName.toUpperCase() + "%' ORDER BY DEVICE_NAME";
		} else if (sIP != null && !sIP.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE IP_ADDRESS LIKE '%" + sIP + "%' ORDER BY IP_ADDRESS";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("printer")) {
		stmtFields = null;
	  	rsFields = null;
		stmtFields = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? ORDER BY CAST(CATEGORY_CODE AS INTEGER)");
		stmtFields.setString(1,"API-Printer");
		rsFields = stmtFields.executeQuery(); 
		int count = 0;
		sSQL = "SELECT ";
		while (rsFields.next()) {
			if (count == 0) {
				sSQL += "A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			} else {
				sSQL += ", A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			}
		}  %>
<Devices><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("") && sFloor != null && !sFloor.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(FLOOR_NAME) = '" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '00" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '0" + sFloor.toUpperCase() + "' ) AND ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'print') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'print') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'print') ORDER BY DEVICE_NAME";
		} else if (sName != null && !sName.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE UPPER(DEVICE_NAME) LIKE '%" + sName.toUpperCase() + "%' ORDER BY DEVICE_NAME";
		} else if (sIP != null && !sIP.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE IP_ADDRESS LIKE '%" + sIP + "%' ORDER BY IP_ADDRESS";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("copier")) {
		stmtFields = null;
	  	rsFields = null;
		stmtFields = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? ORDER BY CAST(CATEGORY_CODE AS INTEGER)");
		stmtFields.setString(1,"API-Copier");
		rsFields = stmtFields.executeQuery(); 
		int count = 0;
		sSQL = "SELECT ";
		while (rsFields.next()) {
			if (count == 0) {
				sSQL += "A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			} else {
				sSQL += ", A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			}
		} %>
<Devices><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("") && sFloor != null && !sFloor.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(FLOOR_NAME) = '" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '00" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '0" + sFloor.toUpperCase() + "' ) AND ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'copy') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'copy') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'copy') ORDER BY DEVICE_NAME";
		} else if (sName != null && !sName.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE UPPER(DEVICE_NAME) LIKE '%" + sName.toUpperCase() + "%' ORDER BY DEVICE_NAME";
		} else if (sIP != null && !sIP.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE IP_ADDRESS LIKE '%" + sIP + "%' ORDER BY IP_ADDRESS";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("fax")) {
		stmtFields = null;
	  	rsFields = null;
		stmtFields = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? ORDER BY CAST(CATEGORY_CODE AS INTEGER)");
		stmtFields.setString(1,"API-Fax");
		rsFields = stmtFields.executeQuery(); 
		int count = 0;
		sSQL = "SELECT ";
		while (rsFields.next()) {
			if (count == 0) {
				sSQL += "A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			} else {
				sSQL += ", A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			}
		}  %>
<Devices><%
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("") && sFloor != null && !sFloor.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(FLOOR_NAME) = '" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '00" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '0" + sFloor.toUpperCase() + "' ) AND ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'fax') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'fax') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'fax') ORDER BY DEVICE_NAME";
		} else if (sName != null && !sName.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE UPPER(DEVICE_NAME) LIKE '%" + sName.toUpperCase() + "%' ORDER BY DEVICE_NAME";
		} else if (sIP != null && !sIP.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE IP_ADDRESS LIKE '%" + sIP + "%' ORDER BY IP_ADDRESS";
		} else {
			validSQL = false;
		}
	} else if (sQuery.equals("scanner")) {
		stmtFields = null;
	  	rsFields = null;
		stmtFields = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? ORDER BY CAST(CATEGORY_CODE AS INTEGER)");
		stmtFields.setString(1,"API-Scanner");
		rsFields = stmtFields.executeQuery(); 
		int count = 0;
		sSQL = "SELECT ";
		while (rsFields.next()) {
			if (count == 0) {
				sSQL += "A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			} else {
				sSQL += ", A." + tool.nullStringConverter(rsFields.getString("CATEGORY_VALUE1"));
				aFields[count] = rsFields.getString("CATEGORY_VALUE1");
				aXMLTag[count] = rsFields.getString("CATEGORY_VALUE2");
				count++;
			}
		}  %>
<Devices><%	
		if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("") && sFloor != null && !sFloor.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(FLOOR_NAME) = '" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '00" + sFloor.toUpperCase() + "' OR UPPER(FLOOR_NAME) = '0" + sFloor.toUpperCase() + "' ) AND ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'scan') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("") && sBuilding != null && !sBuilding.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE ( UPPER(BUILDING_NAME) = '" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '00" + sBuilding.toUpperCase() + "' OR UPPER(BUILDING_NAME) = '0" + sBuilding.toUpperCase() + "' ) AND UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'scan') ORDER BY DEVICE_NAME";
		} else if (sGeo != null && !sGeo.equals("") && sCountry != null && !sCountry.equals("") && sCity != null && !sCity.equals("")) {
			sSQL += ", B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE LOCID IN (SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE UPPER(CITY) = '" + sCity.toUpperCase() + "' AND UPPER(COUNTRY) = '" + sCountry.toUpperCase() + "' AND UPPER(GEO) = '" + sGeo.toUpperCase() + "') AND UPPER(STATUS) = 'COMPLETED' AND DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS WHERE FUNCTION_NAME = 'scan') ORDER BY DEVICE_NAME";
		} else if (sName != null && !sName.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE UPPER(DEVICE_NAME) LIKE '%" + sName.toUpperCase() + "%' ORDER BY DEVICE_NAME";
		} else if (sIP != null && !sIP.equals("")) {
			sSQL += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY FROM GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE IP_ADDRESS LIKE '%" + sIP + "%' ORDER BY IP_ADDRESS";
		} else {
			validSQL = false;
		}
	} else { %>
<Error>Invalid parameters passed.</Error><%
		validQuery = false;
	}
	
	if (validSQL == true) {
		stmt = con.prepareStatement(sSQL);
		rs = stmt.executeQuery();
		
		String geo = "";
		String country = "";
		String state = "";
		String city = "";
		String building = "";
		String floor = "";
		int geoid = 0;
		int countryid = 0;
		int stateid = 0;
		int cityid = 0;
		int buildingid = 0;
		int locid = 0;
		
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
		response.setHeader("Pragma","no-cache"); //HTTP 1.0 
		response.setHeader("Content-disposition","attachment; filename=API.xml");
		
		while( rs.next() ) {
			if (sQuery.equals("geography")) {
				geo = appTool.xmlTextUpdater(rs.getString("GEO"));
				geoid = rs.getInt("GEOID"); %>
	<Geography id="<%= geoid %>">
		<Name><%= geo %></Name>
		<Abbr><%= appTool.xmlTextUpdater(rs.getString("GEO_ABBR")) %></Abbr>
		<URL>http://<%= sServer %>/tools/print/servlet/printeruser.wss?to_page_id&#61;10000&amp;query&#61;country&amp;geo&#61;<%= geo %></URL>
		<Email><%= appTool.xmlTextUpdater(rs.getString("EMAIL_ADDRESS")) %></Email>
		<CCEmail><%= appTool.xmlTextUpdater(rs.getString("CCEMAIL_ADDRESS")) %></CCEmail>
	</Geography><%
			} else if (sQuery.equals("country")) {
				country = appTool.xmlTextUpdater(rs.getString("COUNTRY")); 
				countryid = rs.getInt("COUNTRYID"); %>
	<Country id="<%= countryid %>">
		<Name><%= country %></Name>
		<Abbr><%= appTool.xmlTextUpdater(rs.getString("COUNTRY_ABBR")) %></Abbr>
		<URL>http://<%= sServer %>/tools/print/servlet/printeruser.wss?to_page_id&#61;10000&amp;query&#61;city&amp;geo&#61;<%= sGeo %>&amp;country=<%= country %></URL>
	</Country><%
			} else if (sQuery.equals("state")) {
				state = appTool.xmlTextUpdater(rs.getString("STATE")); 
				stateid = rs.getInt("STATEID"); %>
	<State id="<%= stateid %>">
		<Name><%= state %></Name>
		<URL>http://<%= sServer %>/tools/print/servlet/printeruser.wss?to_page_id&#61;10000&amp;query&#61;city&amp;geo&#61;<%= sGeo %>&amp;country=<%= country %>&amp;state=<%= state %></URL>
	</State><%
			} else if (sQuery.equals("city")) {
				city = appTool.xmlTextUpdater(rs.getString("CITY")); 
				cityid = rs.getInt("CITYID"); %>
	<City id="<%= cityid %>">
		<Name><%= city %></Name>
		<Status><%= appTool.xmlTextUpdater(rs.getString("CITY_STATUS")) %></Status>
		<URL>http://<%= sServer %>/tools/print/servlet/printeruser.wss?to_page_id&#61;10000&amp;query&#61;building&amp;geo&#61;<%= sGeo %>&amp;country=<%= sCountry %>&amp;city&#61;<%= city %></URL>
	</City><%
			} else if (sQuery.equals("building")) {
				building = appTool.xmlTextUpdater(rs.getString("BUILDING_NAME")); 
				buildingid = rs.getInt("BUILDINGID"); %>
	<Building id="<%= buildingid %>">
		<Name><%= building %></Name>
		<Tier><%= appTool.xmlTextUpdater(rs.getString("TIER")) %></Tier>
		<SDC><%= appTool.xmlTextUpdater(rs.getString("SDC")) %></SDC>
		<SiteCode><%= appTool.xmlTextUpdater(rs.getString("SITE_CODE")) %></SiteCode>
		<WorkLocCode><%= appTool.xmlTextUpdater(rs.getString("WORK_LOC_CODE")) %></WorkLocCode>
		<Status><%= appTool.xmlTextUpdater(rs.getString("BUILDING_STATUS")) %></Status>
		<URL>http://<%= sServer %>/tools/print/servlet/printeruser.wss?to_page_id&#61;10000&amp;query&#61;floor&amp;geo&#61;<%= sGeo %>&amp;country=<%= sCountry %>&amp;city&#61;<%= sCity %>&amp;building&#61;<%= building %></URL>
	</Building><%
			} else if (sQuery.equals("floor")) {
				floor = appTool.xmlTextUpdater(rs.getString("FLOOR_NAME")); 
				locid = rs.getInt("LOCID"); %>
	<Floor id="<%= locid %>">
		<Name><%= floor %></Name>
		<Status><%= appTool.xmlTextUpdater(rs.getString("FLOOR_STATUS")) %></Status>
		<URL>http://<%= sServer %>/tools/print/servlet/printeruser.wss?to_page_id&#61;10000&amp;query&#61;printer&amp;geo&#61;<%= sGeo %>&amp;country=<%= sCountry %>&amp;city&#61;<%= sCity %>&amp;building&#61;<%= sBuilding %>&amp;floor&#61;<%= floor %></URL>
	</Floor><%
			} else if (sQuery.equals("device") || sQuery.equals("printer")) {
				stmt2 = null;
		  		rs2 = null;
				stmt2 = con.prepareStatement("SELECT A.OS_ABBR, A.DRIVER_NAME, A.CHANGE_INI, A.MONITOR_FILE, A.CONFIG_FILE, A.VERSION, A.PROC, A.PROC_FILE, A.DRIVER_PATH, A.PRT_ATTRIBUTES, A.HELP_FILE, A.FILE_LIST, A.DATA_FILE, A.MONITOR, A.DEFAULT_TYPE, A.PACKAGE, A.CHANGE_INI, B.OPTIONS_FILE_NAME FROM GPWS.DRIVER_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON (A.OS_DRIVERID = B.OS_DRIVERID) WHERE B.DRIVER_SETID = ? AND UPPER(A.OS_ABBR) = '" + sOS + "' ORDER BY A.OSID");
				stmt2.setInt(1,rs.getInt("DRIVER_SETID"));
				rs2 = stmt2.executeQuery();
				if (sQuery.equals("printer")) { %>
	<Printer><%
			 } else { %>
	<Device><%
			 } 
			int fieldNum = 0;
			while (aFields[fieldNum] != null) { %>
		<<%= aXMLTag[fieldNum] %>><%= appTool.xmlTextUpdater(rs.getString(aFields[fieldNum])) %></<%= aXMLTag[fieldNum] %>><%
				fieldNum++; }
				sFTPHomeDir = appTool.xmlTextUpdater(rs.getString("HOME_DIRECTORY"));
				if (bFTP) { %>
		<FTPUser><%= appTool.xmlTextUpdater(rs.getString("FTP_USER")) %></FTPUser>
		<FTPPass><%= appTool.xmlTextUpdater(tool.DecryptString(appTool.nullStringConverter(rs.getString("FTP_PASS")))) %></FTPPass><%
				} %>
		<OS><%= sOS %></OS><%
			while (rs2.next()) { %>
		<Package><%= sFTPHomeDir %><%= appTool.nullStringConverter(rs2.getString("PACKAGE")) %></Package>
		<Version><%= appTool.nullStringConverter(rs2.getString("VERSION")) %></Version>
		<DriverName><%= appTool.nullStringConverter(rs2.getString("DRIVER_NAME")) %></DriverName>
		<DataFile><%= appTool.nullStringConverter(rs2.getString("DATA_FILE")) %></DataFile>
		<DriverPath><%= appTool.nullStringConverter(rs2.getString("DRIVER_PATH")) %></DriverPath>
		<ConfigFile><%= appTool.nullStringConverter(rs2.getString("CONFIG_FILE")) %></ConfigFile>
		<HelpFile><%= appTool.nullStringConverter(rs2.getString("HELP_FILE")) %></HelpFile>
		<Monitor><%= appTool.nullStringConverter(rs2.getString("MONITOR")) %></Monitor>
		<MonitorFile><%= appTool.nullStringConverter(rs2.getString("MONITOR_FILE")) %></MonitorFile>
		<FileList><%= appTool.nullStringConverter(rs2.getString("FILE_LIST")) %></FileList>
		<DefaultType><%= appTool.nullStringConverter(rs2.getString("DEFAULT_TYPE")) %></DefaultType>
		<Proc><%= appTool.nullStringConverter(rs2.getString("PROC")) %></Proc>
		<ProcFile><%= appTool.nullStringConverter(rs2.getString("PROC_FILE")) %></ProcFile>
		<PrtAttributes><%= appTool.nullStringConverter(rs2.getString("PRT_ATTRIBUTES")) %></PrtAttributes>
		<ChangeINI><%= appTool.nullStringConverter(rs2.getString("CHANGE_INI")) %></ChangeINI>
		<OptionsFileName><%= appTool.nullStringConverter(rs2.getString("OPTIONS_FILE_NAME")) %></OptionsFileName><%
	 		}
			if (sQuery.equals("printer")) { %>
	</Printer><%  } else { %> 
	</Device><%	 }
	 		} else if (sQuery.equals("copier")) { %>
	<Copier><%
			int fieldNum = 0;
			while (aFields[fieldNum] != null) { %>
		<<%= aXMLTag[fieldNum] %>><%= appTool.xmlTextUpdater(rs.getString(aFields[fieldNum])) %></<%= aXMLTag[fieldNum] %>><%
				fieldNum++;
			} %>
	</Copier><%
	 		} else if (sQuery.equals("fax")) { %>
	<Fax><%
			int fieldNum = 0;
			while (aFields[fieldNum] != null) { %>
		<<%= aXMLTag[fieldNum] %>><%= appTool.xmlTextUpdater(rs.getString(aFields[fieldNum])) %></<%= aXMLTag[fieldNum] %>><%
				fieldNum++;
			} %>
	</Fax><%
	 		} else if (sQuery.equals("scanner")) { %>
	<Scanner><%
			int fieldNum = 0;
			while (aFields[fieldNum] != null) { %>
		<<%= aXMLTag[fieldNum] %>><%= appTool.xmlTextUpdater(rs.getString(aFields[fieldNum])) %></<%= aXMLTag[fieldNum] %>><%
				fieldNum++;
			} %>
	</Scanner><%
			}
		} // close rs while loop
	} else { %>
<Error>Invalid filter passed.</Error><%
	}
} catch (Exception e) {
	System.out.println("Error: " + e); %>
	<Error>Error: <%= e %></Error><%
} finally {
	if (rs != null)
		rs.close();
	if (rs2 != null)
		rs2.close();
	if (stmt != null)
		stmt.close();
	if (stmt2 != null)
		stmt2.close();
	if (con != null)
		con.close();
}
if (sQuery.equals("geography")) { %>
</Geographies><%
	} else if (sQuery.equals("country")) { %>
</Countries><%
	} else if (sQuery.equals("state")) { %>
</States><%
	} else if (sQuery.equals("city")) { %>
</Cities><%
	} else if (sQuery.equals("building")) { %>
</Buildings><%
	} else if (sQuery.equals("floor")) { %>
</Floors><%
	} else if (sQuery.equals("device") || sQuery.equals("printer") || sQuery.equals("copier") || sQuery.equals("fax") || sQuery.equals("scanner")) { %>
</Devices><%
	} %>