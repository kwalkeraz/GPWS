DRIVER_NAME, DRIVER_MODEL, OS_NAME, VERSION, PACKAGE, DATA_FILE, DRIVER_PATH, CONFIG_FILE, HELP_FILE, MONITOR, MONITOR_FILE, PROC, PROC_FILE, PRT_ATTRIBUTES, FILE_LIST, DEFAULT_TYPE, CHANGE_INI<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,tools.print.lib.*,java.util.*,java.io.*,java.net.*" %>
<%
	// the list of drvlist
	TableQueryBhvr drvList = (TableQueryBhvr) request.getAttribute("drvlist");
	TableQueryBhvrResultSet drvList_RS = drvList.getResults();
	drvList_RS = drvList.getResults();
	AppTools appTool = new AppTools();
	String drivername = "";
	String drivermodel = "";
	String osname = "";
	String version = "";
	String sPackage = "";
	String datafile = "";
	String driverpath = "";
	String configfile = "";
	String helpfile = "";
	String monitor = "";
	String monitorfile = "";
	String process = "";
	String processfile = "";
	String attributes = "";
	String filelist = "";
	String defaulttype = "";
	String changeini = "";
	response.setHeader("Content-disposition","attachment; filename=DriversReport.csv");
	while( drvList_RS.next() ) { 
		drivername = drvList_RS.getString("DRIVER_NAME");
		drivermodel = drvList_RS.getString("DRIVER_MODEL");
		osname = appTool.nullStringConverter(drvList_RS.getString("OS_NAME"));
		version = appTool.nullStringConverter(drvList_RS.getString("VERSION"));
		sPackage = appTool.nullStringConverter(drvList_RS.getString("PACKAGE"));
		datafile = appTool.nullStringConverter(drvList_RS.getString("DATA_FILE"));
		driverpath = appTool.nullStringConverter(drvList_RS.getString("DRIVER_PATH"));
		configfile = appTool.nullStringConverter(drvList_RS.getString("CONFIG_FILE"));
		helpfile = appTool.nullStringConverter(drvList_RS.getString("HELP_FILE"));
		monitor = appTool.nullStringConverter(drvList_RS.getString("MONITOR"));
		monitorfile = appTool.nullStringConverter(drvList_RS.getString("MONITOR_FILE"));
		process = appTool.nullStringConverter(drvList_RS.getString("PROC"));
		processfile = appTool.nullStringConverter(drvList_RS.getString("PROC_FILE"));
		attributes = appTool.nullStringConverter(drvList_RS.getString("PRT_ATTRIBUTES"));
		filelist = appTool.nullStringConverter(drvList_RS.getString("FILE_LIST"));
		defaulttype = appTool.nullStringConverter(drvList_RS.getString("DEFAULT_TYPE"));
		changeini = appTool.nullStringConverter(drvList_RS.getString("CHANGE_INI"));
	%><%= drivername %>,<%= drivermodel %>,"<%= osname %>","<%= version %>","<%= sPackage %>","<%= datafile %>","<%= driverpath %>","<%= configfile %>","<%= helpfile %>","<%= monitor %>","<%= monitorfile %>","<%= process %>","<%= processfile %>","<%= attributes %>","<%= filelist %>","<%= defaulttype %>","<%= changeini %>"
<% } %>

