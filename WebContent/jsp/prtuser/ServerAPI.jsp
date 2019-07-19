<?xml version="1.0"?><%@ page contentType="application/xml" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %><%

	Connection con = null;
	//Driverset Info
	PreparedStatement serverStmt = null;
	ResultSet serverRs = null;
		
	AppTools appTool = new AppTools();
	ResourceBundle myResources = ResourceBundle.getBundle("tools.print.lib.AppTools");
	String sServer = myResources.getString("serverName");
	
	String sSQL = "";
	String sQuery = appTool.nullStringConverter(request.getParameter("query"));
	String sServerID = appTool.nullStringConverter(request.getParameter("serverid"));
	String sSDC = appTool.nullStringConverter(request.getParameter("sdc"));
	boolean validSQL = true;
	
try {
	con = appTool.getConnection();

	if (sQuery.equals("server")) { %>
<Servers><%
			if (!sServerID.equals("")) {
				sSQL = "SELECT * FROM GPWS.SERVER WHERE SERVERID = " + sServerID + " ORDER BY SERVER_NAME"; 
			} else if (!sSDC.equals("")) {
				sSQL = "SELECT * FROM GPWS.SERVER WHERE SDC = '" + sSDC + "' ORDER BY SERVER_NAME"; 
			} else { 
				sSQL = "SELECT * FROM GPWS.SERVER ORDER BY SERVER_NAME";
			} //DriverSet queries
	} else if (sQuery.equals("process")) { %>
<Comm_Spooler_Supervisors><%
			if (!sServerID.equals("")) {
				sSQL = "SELECT * FROM GPWS.COMM_SPOOLER_SUPERVISOR_VIEW WHERE SERVERID = " + sServerID; 
			} else {
				sSQL = "SELECT * FROM GPWS.COMM_SPOOLER_SUPERVISOR_VIEW";
			}
	} else { %>
<Error>Invalid parameters passed.</Error><%
		validSQL = false;
	} 
	
	if (validSQL == true) {
	
		serverStmt = con.prepareStatement(sSQL);
		serverRs = serverStmt.executeQuery();
		String servername = "";
		int serverid = 0;
		String sdc = "";
		int commspoolersuperid = 0;
		String comm = "";
		String spooler = "";
		String supervisor = "";
		String process = "";
		
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
		response.setHeader("Pragma","no-cache"); //HTTP 1.0 
		response.setHeader("Content-disposition","attachment; filename=ServerAPI.xml");
		
		while(serverRs.next()) {
		if (sQuery.equals("server")) {
			servername = appTool.xmlTextUpdater(serverRs.getString("SERVER_NAME"));
			sdc = appTool.xmlTextUpdater(serverRs.getString("SDC"));
			serverid = serverRs.getInt("SERVERID"); 
			%>	
	<Server id="<%= serverid %>">
		<Name><%= servername %></Name>
		<SDC><%= sdc %></SDC>
	</Server>
		<% } else if (sQuery.equals("process")) {
			servername = appTool.xmlTextUpdater(serverRs.getString("SERVER_NAME"));
			serverid = serverRs.getInt("SERVERID"); 
			comm = appTool.xmlTextUpdater(serverRs.getString("COMM"));
			spooler = appTool.xmlTextUpdater(serverRs.getString("SPOOLER"));
			supervisor = appTool.xmlTextUpdater(serverRs.getString("SUPERVISOR"));
			commspoolersuperid = serverRs.getInt("COMM_SPOOL_SUPERID"); 
			process = comm + ":" + spooler + ":" + supervisor;
			%>
	<Comm_Spooler_Supervisor id="<%= commspoolersuperid %>">
		<Name><%= servername %></Name>
		<Process><%= process %></Process>
	</Comm_Spooler_Supervisor>
<%		   } //else if sQuery
		} //serverRS while loop
	} //if is validSQL
} catch (Exception e) {
	System.out.println("Error: " + e);
} finally {
	if (serverRs != null)
		serverRs.close();
	if (serverStmt != null)
		serverStmt.close();
	if (con != null)
		con.close();
} //try and catch
if (sQuery.equals("server")) { %>
</Servers><%	
} else if (sQuery.equals("process")) { %>
</Comm_Spooler_Supervisors> <%
} %>