<?xml version="1.0"?><%@ page contentType="application/xml" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %><%

	Connection con = null;
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	AppTools appTool = new AppTools();
	ResourceBundle myResources = ResourceBundle.getBundle("tools.print.lib.AppTools");
	String sServer = myResources.getString("serverName");
	
	String sSQL = "";
	String sQuery = appTool.nullStringConverter(request.getParameter("query"));
	String sModel = (appTool.nullStringConverter(request.getParameter("model_name"))).replaceAll("%20"," ");
	String sModelID = appTool.nullStringConverter(request.getParameter("modelid"));
	String sDriverName = (appTool.nullStringConverter(request.getParameter("driver_name"))).replaceAll("%20"," ");
	String sDriverModel = (appTool.nullStringConverter(request.getParameter("driver_model"))).replaceAll("%20"," ");
	String sDriverID = appTool.nullStringConverter(request.getParameter("driverid"));
	String sModelDriverID = appTool.nullStringConverter(request.getParameter("model_driverid"));
	String sDriverSetID = appTool.nullStringConverter(request.getParameter("driver_setid"));
	String sDriverSetName = (appTool.nullStringConverter(request.getParameter("driver_set_name"))).replaceAll("%20"," ");
	String sModelDriverSetID = appTool.nullStringConverter(request.getParameter("model_driver_setid"));
	boolean validSQL = true;
	
try {
	con = appTool.getConnection();
	
	if (sQuery.equals("model")) { %>
<Models><%
		if (!sModel.equals("")) {
			sSQL = "SELECT MODELID, MODEL, STRATEGIC, CONFIDENTIAL_PRINT FROM GPWS.MODEL WHERE MODEL = " + "'" + sModel + "'" + " ORDER BY MODEL";
		} else if (!sModelID.equals("")) {
			sSQL = "SELECT MODELID, MODEL, STRATEGIC, CONFIDENTIAL_PRINT FROM GPWS.MODEL WHERE MODELID = " + sModelID + " ORDER BY MODEL"; 
		} else { 
			sSQL = "SELECT MODELID, MODEL, STRATEGIC, CONFIDENTIAL_PRINT FROM GPWS.MODEL ORDER BY MODEL";
		} //Model queries
	} else if (sQuery.equals("model_driver")) { %>
<Model-Drivers><%
		if (!sModel.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE MODEL = " + "'" + sModel + "'" + " ORDER BY MODEL";
		} else if (!sModelID.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE MODELID = " + sModelID + " ORDER BY MODEL";
		} else if (!sDriverName.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE DRIVER_NAME = " + "'" + sDriverName + "'" + " ORDER BY MODEL";
		} else if (!sDriverModel.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE DRIVER_MODEL = " + "'" + sDriverModel + "'" + " ORDER BY MODEL";
		} else if (!sDriverID.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE DRIVERID = " + sDriverID + " ORDER BY MODEL";
		} else if (!sModelDriverID.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW WHERE MODEL_DRIVERID = " + sModelDriverID + " ORDER BY MODEL";
		} else {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL, MODELID, MODEL, MODEL_DRIVERID FROM GPWS.MODEL_DRIVER_VIEW ORDER BY MODEL";
		}
	} else if (sQuery.equals("model_driverset")) { %>
<Model-DriverSets><%
		if (!sModel.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE MODEL = " + "'" + sModel + "'" + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!sModelID.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE MODELID = " + sModelID + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!sDriverSetID.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE DRIVER_SETID = " + sDriverSetID + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!sModelDriverSetID.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE MODEL_DRIVER_SETID = " + sModelDriverSetID + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else if (!sDriverSetName.equals("")) {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW WHERE DRIVER_SET_NAME = " + "'" + sDriverSetName + "'" + " ORDER BY MODEL, DRIVER_SET_NAME";
		} else {
			sSQL = "SELECT MODELID, MODEL, DRIVER_SETID, DRIVER_SET_NAME, MODEL_DRIVER_SETID FROM GPWS.MODEL_DRIVER_SET_VIEW ORDER BY MODEL, DRIVER_SET_NAME";
		}
	} else if (sQuery.equals("driver")) { %>
<Drivers><%
		if (!sDriverName.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER WHERE DRIVER_NAME = " + "'" + sDriverName + "'" + " ORDER BY DRIVER_NAME";
		} else if (!sDriverModel.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER WHERE DRIVER_MODEL = " + "'" + sDriverModel + "'" + " ORDER BY DRIVER_MODEL";
		} else if (!sDriverID.equals("")) {
			sSQL = "SELECT DRIVERID, DRIVER_NAME, DRIVER_MODEL FROM GPWS.DRIVER WHERE DRIVERID = " + sDriverID + " ORDER BY DRIVER_MODEL";
		} 
	} else { %>
<Error>Invalid parameters passed.</Error><%
		validSQL = false;
	}
	
	if (validSQL == true) {
	
		stmt = con.prepareStatement(sSQL);
		rs = stmt.executeQuery();
		int modelid = 0;
		String model = "";
		String strategic = "";
		String confprint = "";
		String drivername = "";
		int driverid = 0;
		String drivermodel = "";
		int modeldriverid = 0;
		int modeldriversetid = 0;
		String driversetname = "";
		int driversetid = 0;
		
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
		response.setHeader("Pragma","no-cache"); //HTTP 1.0 
		response.setHeader("Content-disposition","attachment; filename=ModelDriverAPI.xml");
		
		while( rs.next() ) {
			if (sQuery.equals("model")) {
				model = appTool.xmlTextUpdater(rs.getString("MODEL")); 
				modelid = rs.getInt("MODELID"); 
				strategic = appTool.xmlTextUpdater(rs.getString("STRATEGIC"));
				confprint = appTool.xmlTextUpdater(rs.getString("CONFIDENTIAL_PRINT"));
			%>	
	<Model id="<%= modelid %>">
		<Name><%= model %></Name>
		<Strategic><%= strategic %></Strategic>
		<ConfidentialPrint><%= confprint %></ConfidentialPrint>
	</Model>
	<%		} else if (sQuery.equals("model_driver")) { 
				model = appTool.xmlTextUpdater(rs.getString("MODEL")); 
				modelid = rs.getInt("MODELID"); 
				drivername = appTool.xmlTextUpdater(rs.getString("DRIVER_NAME")); 
				driverid = rs.getInt("DRIVERID"); 
				drivermodel = appTool.xmlTextUpdater(rs.getString("DRIVER_MODEL"));
				modeldriverid = rs.getInt("MODEL_DRIVERID"); 
	%>
	<Model-Driver id="<%= modeldriverid %>">
		<Model id="<%= modelid %>"><%= model %></Model>
		<DriverName id="<%= driverid %>"><%= drivername %></DriverName>
		<DriverModel><%= drivermodel %></DriverModel>
	</Model-Driver>
	<%		} else if (sQuery.equals("model_driverset")) { 
				model = appTool.xmlTextUpdater(rs.getString("MODEL")); 
				modelid = rs.getInt("MODELID"); 
				driversetname = appTool.xmlTextUpdater(rs.getString("DRIVER_SET_NAME")); 
				driversetid = rs.getInt("DRIVER_SETID"); 
				modeldriversetid = rs.getInt("MODEL_DRIVER_SETID"); 
	%>
	<Model-DriverSet id="<%= modeldriversetid %>">
		<Model id="<%= modelid %>"><%= model %></Model>
		<DriverSetName id="<%= driversetid %>"><%= driversetname %></DriverSetName>
	</Model-DriverSet>
	<%		} else if (sQuery.equals("driver")) { 
				drivername = appTool.xmlTextUpdater(rs.getString("DRIVER_NAME")); 
				drivermodel = appTool.xmlTextUpdater(rs.getString("DRIVER_MODEL")); 
				driverid = rs.getInt("DRIVERID"); 
	%>
	<Driver id="<%= driverid %>">
		<Name><%= drivername %></Name>
		<Model><%= drivermodel %></Model>
	</Driver>
	<%		} else { %>
	<Error>Invalid filter passed.</Error> <%
			} //else if sQuery
		} //rs while loop
	} //if is validSQL
} catch (Exception e) {
	System.out.println("Error: " + e);
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
} //try and catch
if (sQuery.equals("model")) { %>
</Models>	
<% } else if (sQuery.equals("model_driver")) { %>
</Model-Drivers>
<% } else if (sQuery.equals("model_driverset")) { %>
</Model-DriverSets>
<% } else if (sQuery.equals("driver")) { %>
</Drivers>
<% } %>
		
		
		
		