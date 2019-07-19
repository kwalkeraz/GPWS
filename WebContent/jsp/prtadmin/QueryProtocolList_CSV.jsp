PROTOCOL_NAME, PROTOCOL_TYPE, OS_NAME, HOST_PORT_CONFIG, PROTOCOL_VERSION, PROTOCOL_PACKAGE<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,tools.print.lib.*,java.util.*,java.io.*,java.net.*" %>
<%
	// the list of protocollist
	TableQueryBhvr drvList = (TableQueryBhvr) request.getAttribute("protocollist");
	TableQueryBhvrResultSet drvList_RS = drvList.getResults();
	drvList_RS = drvList.getResults();
	AppTools appTool = new AppTools();
	String protocolname = "";
	String protocoltype = "";
	String osname = "";
	String hostportconfig = "";
	String protocolversion = "";
	String protocolpackage = "";
	response.setHeader("Content-disposition","attachment; filename=ProtocolListReport.csv");
	while( drvList_RS.next() ) {
		protocolname = appTool.nullStringConverter(drvList_RS.getString("PROTOCOL_NAME"));
		protocoltype = appTool.nullStringConverter(drvList_RS.getString("PROTOCOL_TYPE"));
		osname = appTool.nullStringConverter(drvList_RS.getString("OS_NAME"));
		hostportconfig = appTool.nullStringConverter(drvList_RS.getString("HOST_PORT_CONFIG"));
		protocolversion = appTool.nullStringConverter(drvList_RS.getString("PROTOCOL_VERSION"));
		protocolpackage = appTool.nullStringConverter(drvList_RS.getString("PROTOCOL_PACKAGE"));
%><%= protocolname %>,"<%= protocoltype %>",<%= osname %>,"<%= hostportconfig %>",<%= protocolversion %>,"<%= protocolpackage %>",
<% } %>
