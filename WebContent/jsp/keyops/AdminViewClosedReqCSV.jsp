<%@ page contentType="application/x-msexcel" %><%@page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" 
%><% 
	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	String sCityID = appTool.nullStringConverter(request.getParameter("cityid"));
	
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	int iVendorID = pupb.getVendorID();
	
	String[] sAuthTypes = pupb.getAuthTypes();
	boolean isKOSU = false;
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("Keyop Superuser")) {
			isKOSU = true;
		}
	}

%>KEYOP_REQUESTID,<% if (isKOSU) { %>VENDOR_NAME<% } %>,REQUESTOR_EMAIL,REQUESTOR_NAME,REQUESTOR_TIELINE,REQUESTOR_EXT_PHONE,TIME_SUBMITTED,DEVICE_NAME,DEVICE_TYPE,DEVICE_SERIAL,TIER,E2E_CATEGORY,CITY,BUILDING,FLOOR,ROOM,DESCRIPTION,SOLUTION,KEYOP_NAME,CLOSED_BY,TIME_FINISHED,CUSTOMER_CONTACTED,KEYOP_TIME_START,KEYOP_TIME_FINISH
<%
    DateTime dateTime = new DateTime();
	response.setHeader("Content-disposition","attachment; filename=ClosedKeyopTickets.csv");
	String sOrderBy = "keyop_requestid";
	Connection con = null;
	Statement stmtNewReq = null;
	ResultSet rsNewReq = null;
	
	String sTimeZone = "America/New York";
	String sMinRangeDate = appTool.nullStringConverter(request.getParameter("minDate"));
	int iMinRangeDateYear = 0;
	int iMinRangeDateMonth = 0;
	int iMinRangeDateDay = 0;
	String sMinRangeDateYear = "";
	String sMinRangeDateMonth = "";
	String sMinRangeDateDay = "";
	String sMinRangeDateSQL = "";
	   
	String sMaxRangeDate = appTool.nullStringConverter(request.getParameter("maxDate"));
	int iMaxRangeDateYear = 0;
	int iMaxRangeDateMonth = 0;
	int iMaxRangeDateDay = 0;
	String sMaxRangeDateYear = "";
	String sMaxRangeDateMonth = "";
	String sMaxRangeDateDay = "";
	String sMaxRangeDateSQL = "";
	  
	if (sMinRangeDate != null && !sMinRangeDate.equals("null") && !sMinRangeDate.equals("")) {
		sMinRangeDate += ".00.00.00.00";
		sMinRangeDate = dateTime.convertTimeZoneFromUTC(sMinRangeDate, sTimeZone);
		iMinRangeDateYear = dateTime.getStringTimeStampValues(sMinRangeDate, "year");
		iMinRangeDateMonth = dateTime.getStringTimeStampValues(sMinRangeDate, "month");
		iMinRangeDateDay = dateTime.getStringTimeStampValues(sMinRangeDate, "day");
			
		sMinRangeDateYear = iMinRangeDateYear + "";
		sMinRangeDateMonth = dateTime.addLeadingZero(iMinRangeDateMonth + "");
		sMinRangeDateDay = dateTime.addLeadingZero(iMinRangeDateDay + "");
					
		sMinRangeDate = dateTime.formatTime(sMinRangeDate);
		sMinRangeDateSQL = sMinRangeDateYear + "-" + sMinRangeDateMonth + "-" + sMinRangeDateDay + "-00.00.00.00";
	}
	 
	if (sMaxRangeDate != null && !sMaxRangeDate.equals("null") && !sMaxRangeDate.equals("")) {
		sMaxRangeDate += ".00.00.00.00";
		sMaxRangeDate = dateTime.convertTimeZoneFromUTC(sMaxRangeDate, sTimeZone);
		iMaxRangeDateYear = dateTime.getStringTimeStampValues(sMaxRangeDate, "year");
		iMaxRangeDateMonth = dateTime.getStringTimeStampValues(sMaxRangeDate, "month");
		iMaxRangeDateDay = dateTime.getStringTimeStampValues(sMaxRangeDate, "day");
			
		sMaxRangeDateYear = iMaxRangeDateYear + "";
		sMaxRangeDateMonth = dateTime.addLeadingZero(iMaxRangeDateMonth + "");
		sMaxRangeDateDay = dateTime.addLeadingZero(iMaxRangeDateDay + "");
					
		sMaxRangeDate = dateTime.formatTime(sMaxRangeDate);
		sMaxRangeDateSQL = sMaxRangeDateYear + "-" + sMaxRangeDateMonth + "-" + sMaxRangeDateDay + "-23.59.59.99";
	}
	
	if(request.getParameter("orderby") != null) {
		sOrderBy = request.getParameter("orderby");
	}
	if(sOrderBy.equals("city")) {
		sOrderBy = "city, building, room, floor";
	}
	try {
		con = tool.getConnection();
		stmtNewReq = con.createStatement();
		if (isKOSU == true) {
			rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, DEVICE_NAME, DEVICE_TYPE, DEVICE_SERIAL, TIER, E2E_CATEGORY, CITY, BUILDING, FLOOR, ROOM, DESCRIPTION, SOLUTION, KEYOP_NAME, CLOSED_BY, TIME_FINISHED, CUSTOMER_CONTACTED, KEYOP_TIME_START, KEYOP_TIME_FINISH, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE LOWER(REQ_STATUS) = 'completed' AND CITYID = " + sCityID + " AND TIME_FINISHED >= '" + sMinRangeDateSQL + "' AND TIME_FINISHED <= '" + sMaxRangeDateSQL + "' ORDER BY " + sOrderBy);
		} else {
			rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, DEVICE_NAME, DEVICE_TYPE, DEVICE_SERIAL, TIER, E2E_CATEGORY, CITY, BUILDING, FLOOR, ROOM, DESCRIPTION, SOLUTION, KEYOP_NAME, CLOSED_BY, TIME_FINISHED, CUSTOMER_CONTACTED, KEYOP_TIME_START, KEYOP_TIME_FINISH FROM GPWS.KEYOP_REQUEST_VIEW WHERE LOWER(REQ_STATUS) = 'completed' AND KO_COMPANYID = " + iVendorID + " AND CITYID = " + sCityID + " AND TIME_FINISHED >= '" + sMinRangeDateSQL + "' AND TIME_FINISHED <= '" + sMaxRangeDateSQL + "' ORDER BY " + sOrderBy);
		}
		
		while (rsNewReq.next()) { 
			%><%= rsNewReq.getInt("KEYOP_REQUESTID") %>,<% if (isKOSU == true) { %><%= rsNewReq.getString("KO_COMPANY_NAME") %><% } %>,<%= rsNewReq.getString("REQUESTOR_EMAIL") %>,<%= tool.nullStringConverter(rsNewReq.getString("REQUESTOR_NAME")).replace(',',' ') %>,<%= rsNewReq.getString("REQUESTOR_TIELINE") %>,<%= rsNewReq.getString("REQUESTOR_EXT_PHONE") %>,<%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("TIME_SUBMITTED")) %>,<%= rsNewReq.getString("DEVICE_NAME") %>,<%= rsNewReq.getString("DEVICE_TYPE") %>,<%= rsNewReq.getString("DEVICE_SERIAL") %>,<%= rsNewReq.getString("TIER") %>,<%= rsNewReq.getString("E2E_CATEGORY") %>,<%= rsNewReq.getString("CITY") %>,<%= rsNewReq.getString("BUILDING") %>,<%= rsNewReq.getString("FLOOR") %>,<%= rsNewReq.getString("ROOM") %>,<%= rsNewReq.getString("DESCRIPTION") %>,<%= rsNewReq.getString("SOLUTION") %>,<%= tool.nullStringConverter(rsNewReq.getString("KEYOP_NAME")).replace(',',' ') %>,<%= rsNewReq.getString("CLOSED_BY") %>,<%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("TIME_FINISHED")) %>,<%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("CUSTOMER_CONTACTED")) %> ,<%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("KEYOP_TIME_START")) %>,<%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("KEYOP_TIME_FINISH")) %>
<% }  //while rsNewReq 
	} catch (Exception e) {
			System.out.println("Keyop error in AdminViewClosedReq_CSV.jsp ERROR: " + e);
		} finally {
			if (rsNewReq != null)
				rsNewReq.close();
			if (stmtNewReq != null)
				stmtNewReq.close();
			if (con != null)
				con.close();
		}
%>