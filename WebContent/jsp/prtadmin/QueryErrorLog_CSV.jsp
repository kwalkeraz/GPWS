CLASS_METHOD, MODULE_NAME, ERROR, DATE_TIME<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,java.util.*,java.io.*,java.net.*" %>
<%
	// the list of adminlog
	TableQueryBhvr errorLog = (TableQueryBhvr) request.getAttribute("ErrorLogView");
	TableQueryBhvrResultSet errorLog_RS = errorLog.getResults();
	PrinterTools tool = new PrinterTools();
	errorLog_RS = errorLog.getResults();
	String classmethod = "";
	String modulename = "";
	String error = "";
	response.setHeader("Content-disposition","attachment; filename=ErrorLogReport.csv");
    java.sql.Timestamp datetime;
	while( errorLog_RS.next() ) {
		classmethod = tool.nullStringConverter(errorLog_RS.getString("CLASS_METHOD"));
		modulename = tool.nullStringConverter(errorLog_RS.getString("MODULE_NAME"));
		error = tool.nullStringConverter(errorLog_RS.getString("ERROR"));
		error = error.replace(',',' ').replace('\n',' ').replace('"','\'').replace('\r',' ');
		//error = error.replace('\n',' ');
		//error = error.replace('"','\'');
		//error = error.replace('\r',' ');
		datetime = errorLog_RS.getTimeStamp("DATE_TIME");
%><%= classmethod %>,"<%= modulename %>",<%= error %>,"<%= datetime %>"
<% } %>
