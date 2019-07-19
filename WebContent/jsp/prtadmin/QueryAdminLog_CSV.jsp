LOGINID, ACTION, USER_TYPE, DATE_TIME<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,java.util.*,java.io.*,java.net.*" %>
<%
	// the list of adminlog
	TableQueryBhvr adminLog = (TableQueryBhvr) request.getAttribute("adminlog");
	TableQueryBhvrResultSet adminLog_RS = adminLog.getResults();
	adminLog_RS = adminLog.getResults();
	String loginid = "";
	String action = "";
	String usertype = "";
	response.setHeader("Content-disposition","attachment; filename=UserLogReport.csv");
    java.sql.Timestamp datetime;
	while( adminLog_RS.next() ) {
		loginid = adminLog_RS.getString("LOGINID");
		action = adminLog_RS.getString("ACTION");
		usertype = adminLog_RS.getString("USER_TYPE");
		datetime = adminLog_RS.getTimeStamp("DATE_TIME");
%><%= loginid %>,"<%= action %>",<%= usertype %>,"<%= datetime %>"
<% } %>
