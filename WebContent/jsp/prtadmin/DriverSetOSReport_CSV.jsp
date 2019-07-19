<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,tools.print.lib.*,java.util.*,java.io.*,java.net.*,java.sql.*" %><%
	response.setHeader("Content-disposition","attachment; filename=DriverSetOSReport.csv");
	TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSetNoDeviceList");
	TableQueryBhvrResultSet DriverSet_RS = DriverSet.getResults();   
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults(); 
	AppTools tool = new AppTools();   
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String model_id = tool.nullStringConverter(request.getParameter("modelid"));
	String model = "";
	int modelid = 0;
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	PreparedStatement psDriverSetConfig = null;
	ResultSet DriverSetConfig_RS = null;
	PreparedStatement psOptionsFile = null;
	ResultSet OptionsFileView_RS = null;
	PreparedStatement psDriverSetCount = null;
	ResultSet DriverSetCount_RS = null;
	int resultSize = 0;
	String sDataHeaders = "";
	String[] aDataArray = new String[DriverSet_RS.getResultSetSize()];
	int[] driversetidArray = new int[DriverSet_RS.getResultSetSize()];
	String[] driversetArray = new String[DriverSet_RS.getResultSetSize()];
	int[] driversetDevCountArray = new int[DriverSet_RS.getResultSetSize()];
	int[] osarray = new int[OSView_RS.getResultSetSize()];
	int osc = 0;
	for (int x=0; x < OSView_RS.getResultSetSize(); x++) {
		if (request.getParameter("OS_" + x) != null && Integer.parseInt(request.getParameter("OS_" + x)) > 0) {
			osarray[osc] = Integer.parseInt(request.getParameter("OS_" + x));
			osc++;
		}
	}
	
	int y = 0;
	if (DriverSet_RS.getResultSetSize() > 0) {
		while (DriverSet_RS.next()) {
			driversetidArray[y] = DriverSet_RS.getInt("DRIVER_SETID");
			driversetArray[y] = DriverSet_RS.getString("DRIVER_SET_NAME");
			driversetDevCountArray[y] = DriverSet_RS.getInt("COUNT");
			y++;
		}  //while
	} //if

	try {
		con = tool.getConnection(); 
		sDataHeaders = "Driver Set Name,";
		OSView_RS.first();
		while (OSView_RS.next()) {	 
			sDataHeaders += OSView_RS.getString("OS_NAME") + " Driver,";
			sDataHeaders += OSView_RS.getString("OS_NAME") + " Options File,";
			sDataHeaders += OSView_RS.getString("OS_NAME") + " Package Name,";
		} //while OSView 
		sDataHeaders += "Number of Devices"; 					
		OSView_RS.first();
		String sqlQuery = "";
		sqlQuery = "SELECT DSCV.OS_DRIVERID, DSCV.DRIVER_MODEL, DSCV.DRIVERID, DSCV.DRIVER_SET_NAME, DSCV.OPTIONS_FILEID, DSCV.OPTIONS_FILE_NAME, DSCV.FUNCTIONS, OSD.PACKAGE FROM GPWS.DRIVER_SET_CONFIG_VIEW DSCV LEFT OUTER JOIN GPWS.OS_DRIVER OSD ON (DSCV.OS_DRIVERID = OSD.OS_DRIVERID) WHERE DSCV.OSID = ? AND DSCV.DRIVER_SETID = ?";
		psDriverSetConfig = con.prepareStatement(sqlQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	
		for (int i=0; i < driversetidArray.length; i++) {
			
			aDataArray[i] = driversetArray[i] + ",";
			
			String dsname = "";
			OSView_RS.first();
			while (OSView_RS.next()) {
				int counter = 0;
				int osdriverid = 0;
				int driverid = 0;
				String drivermodel = "";
				String optionsfile = "";
				String packageName = "";
				psDriverSetConfig.setInt(1, OSView_RS.getInt("OSID"));
			  	psDriverSetConfig.setInt(2, driversetidArray[i]);
			  	DriverSetConfig_RS = psDriverSetConfig.executeQuery();
						  	
				if (DriverSetConfig_RS.next() == false) { 
					aDataArray[i] += ",,,";
				}
				DriverSetConfig_RS.beforeFirst();
				while( DriverSetConfig_RS.next() ) {
					osdriverid = DriverSetConfig_RS.getInt("OS_DRIVERID");
					drivermodel = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_MODEL"));
					driverid = DriverSetConfig_RS.getInt("DRIVERID");
					optionsfile = tool.nullStringConverter(DriverSetConfig_RS.getString("OPTIONS_FILE_NAME"));
					dsname = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_SET_NAME"));
					packageName = tool.nullStringConverter(DriverSetConfig_RS.getString("PACKAGE"));
					counter++;
					aDataArray[i] += drivermodel + ","; 	
					if (optionsfile != null && !optionsfile.equals("")) { 
						aDataArray[i] += optionsfile + ",";
					} else { 
						aDataArray[i] += ",";
					} 
					aDataArray[i] += packageName + ","; 
				} //while DriverSetConfig_RS 
			}  //while OSView
			aDataArray[i] += driversetDevCountArray[i];
		} // for loop 
  } catch (Exception e) { 
		System.out.println("Error in DriverSetAuditReport.jsp ERROR: " + e);
	} finally {
		if (DriverSetConfig_RS != null)
			DriverSetConfig_RS.close();
		if (psDriverSetConfig != null)
			psDriverSetConfig.close();
		if (con != null)
			con.close();
	}
%><%= sDataHeaders %><%
for (int j=0; j < aDataArray.length; j++) { %>
<%= aDataArray[j]%><%	} %>