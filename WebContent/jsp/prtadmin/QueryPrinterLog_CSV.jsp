DEVICE,EMAIL,GEO,COUNTRY,STATE,CITY,BUILDING,FLOOR,DEVICE_IP,USER_IP,OS_NAME,BROWSER_NAME,DATE_TIME<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,java.util.*,java.io.*,java.net.*" %>
<%	// the list of prtlog
	TableQueryBhvr prtLog = (TableQueryBhvr) request.getAttribute("prtlog");
	TableQueryBhvrResultSet prtLog_RS = prtLog.getResults();
	prtLog_RS = prtLog.getResults();
	PrinterTools tool = new PrinterTools();
	String device = "";
	String email = "";
	int locid = 0;
	String geo = "";
	String country = "";
	String state = "";
	String city = "";
	String building = "";
	String floor = "";
	String printerip = "";
	String userip = "";
	String os = "";
	String browser = "";
	response.setHeader("Content-disposition","attachment; filename=PrinterInstallLogReport.csv");
    java.sql.Timestamp datetime;	
	while( prtLog_RS.next() ) {
		device = tool.nullStringConverter(prtLog_RS.getString("DEVICE_NAME"));
		email = tool.nullStringConverter(prtLog_RS.getString("EMAIL"));
		geo = tool.nullStringConverter(prtLog_RS.getString("GEO"));
		country = tool.nullStringConverter(prtLog_RS.getString("COUNTRY"));
		state = tool.nullStringConverter(prtLog_RS.getString("STATE"));
		city = tool.nullStringConverter(prtLog_RS.getString("CITY"));
		building = tool.nullStringConverter(prtLog_RS.getString("BUILDING"));
		floor = tool.nullStringConverter(prtLog_RS.getString("FLOOR"));
		printerip = tool.nullStringConverter(prtLog_RS.getString("PRINTER_IP"));
		userip = tool.nullStringConverter(prtLog_RS.getString("USER_IP"));
		os = tool.nullStringConverter(prtLog_RS.getString("OS_NAME"));
		browser = tool.nullStringConverter(prtLog_RS.getString("BROWSER_NAME"));
		datetime = prtLog_RS.getTimeStamp("DATE_TIME");%><%= device %>,<%= email %>,<%= geo %>,<%= country %>,<%= state %>,<%= city %>,<%= building %>,<%= floor %>,<%= printerip %>,<%= userip %>,<%= os %>,<%= browser %>,"<%= datetime %>"
<% } %>