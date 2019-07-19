<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,tools.print.lib.*,java.util.*,java.io.*,java.net.*,java.sql.*" %>
<% 
	TableQueryBhvr QueryType  = (TableQueryBhvr) request.getAttribute("QueryType");
	TableQueryBhvrResultSet QueryType_RS = QueryType.getResults();
   
	TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSet");
	TableQueryBhvrResultSet DriverSet_RS = DriverSet.getResults();
   
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	
	AppTools tool = new AppTools();
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
	String driversetname = "";
	int[] driversetidArray = new int[DriverSet_RS.getResultSetSize()];
	String[] driversetArray = new String[DriverSet_RS.getResultSetSize()];
	String model = "";
	int y = 0;
	String[] csvReport = new String[DriverSet_RS.getResultSetSize()];
	response.setHeader("Content-disposition","attachment; filename=DriverSetReport.csv");
	
	if (DriverSet_RS.getResultSetSize() > 0) {
		while (DriverSet_RS.next()) {
			model = DriverSet_RS.getString("MODEL");
			driversetname = DriverSet_RS.getString("DRIVER_SET_NAME");
			driversetidArray[y] = DriverSet_RS.getInt("DRIVER_SETID");
			driversetArray[y] = DriverSet_RS.getString("DRIVER_SET_NAME");
			y++;
		}  //while
	} //if
	try {
		con = tool.getConnection();
   		int csvCount = 0;
		csvReport[csvCount] = "Driver Set Name,";
	
		while (OSView_RS.next()) { 
			csvReport[csvCount] += OSView_RS.getString("OS_NAME") + " Driver," +  OSView_RS.getString("OS_NAME") + " Options File," + OSView_RS.getString("OS_NAME") + " Package,";
	  	} //while OSView
	  	csvReport[csvCount] += "# of printers";
  
	    csvCount++;
		OSView_RS.first();
	
		String sqlQuery = "";
		sqlQuery = "SELECT DSCV.OS_DRIVERID, DSCV.DRIVER_MODEL, DSCV.DRIVERID, DSCV.DRIVER_SET_NAME, DSCV.OPTIONS_FILEID, DSCV.OPTIONS_FILE_NAME, DSCV.FUNCTIONS, OSD.PACKAGE FROM GPWS.DRIVER_SET_CONFIG_VIEW DSCV LEFT OUTER JOIN GPWS.OS_DRIVER OSD ON (DSCV.OS_DRIVERID = OSD.OS_DRIVERID) WHERE DSCV.OSID = ? AND DSCV.DRIVER_SETID = ?";
		psDriverSetConfig = con.prepareStatement(sqlQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	
		for (int i=0; i < driversetidArray.length; i++) { 
			csvReport[csvCount] = driversetArray[i] + ",";
		
		String dsname = "";
		OSView_RS.first();
		while (OSView_RS.next()) {
			int counter = 0;
			int osdriverid = 0;
			int driverid = 0;
			String drivermodel = "";
			String optionsfile = "";
			String packageName = "";
			boolean setExist = false;
			//sqlQuery = "SELECT OS_DRIVER.OS_DRIVERID, DRIVER.DRIVER_MODEL, DRIVER.DRIVERID FROM GPWS.OS_DRIVER OS_DRIVER, GPWS.DRIVER DRIVER WHERE OS_DRIVER.DRIVERID = DRIVER.DRIVERID AND OS_DRIVER.OSID = ? AND OS_DRIVER.DRIVERID IN (SELECT DRIVERID FROM GPWS.MODEL_DRIVER WHERE MODELID IN (SELECT MODELID FROM GPWS.MODEL_DRIVER_SET WHERE DRIVER_SETID = ?))";
			psDriverSetConfig.setInt(1, OSView_RS.getInt("OSID"));
		  	//psDriverSetConfig.setInt(2, Integer.parseInt(driversetid));
		  	psDriverSetConfig.setInt(2, driversetidArray[i]);
		  	DriverSetConfig_RS = psDriverSetConfig.executeQuery();

		//	DriverSetConfig_RS.first();
			while( DriverSetConfig_RS.next() ) {
				setExist = true;
				osdriverid = DriverSetConfig_RS.getInt("OS_DRIVERID");
				drivermodel = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_MODEL"));
				driverid = DriverSetConfig_RS.getInt("DRIVERID");
				optionsfile = tool.nullStringConverter(DriverSetConfig_RS.getString("OPTIONS_FILE_NAME"));
				dsname = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_SET_NAME"));
				packageName = tool.nullStringConverter(DriverSetConfig_RS.getString("PACKAGE"));
				counter++;
				
				csvReport[csvCount] += drivermodel + ",";
				if (optionsfile != null && !optionsfile.equals("")) {
					csvReport[csvCount] += optionsfile + ","; 

				} else {
					csvReport[csvCount] += ",";
				}
				csvReport[csvCount] += packageName + ",";

			} //while DriverSetConfig_RS
			if (setExist == false) {
				csvReport[csvCount] += ",,,";
			}
		}  //while OSView  

		stmt = null;
		rs = null;
		int printerCount = 0;
		try {
			//stmt = con.createStatement();
			String sqlQueryDSC = "SELECT COUNT(*) AS COUNT FROM GPWS.DEVICE_VIEW WHERE DRIVER_SET_NAME = ?";
			psDriverSetCount = con.prepareStatement(sqlQueryDSC,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			psDriverSetCount.setString(1, dsname);
			DriverSetCount_RS = psDriverSetCount.executeQuery();
			//rs = stmt.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.DEVICE_VIEW WHERE DRIVER_SET_NAME = '" + dsname + "'");
		
			while (DriverSetCount_RS.next()) {							
				printerCount = DriverSetCount_RS.getInt("COUNT");
			}
		} catch (Exception e) {
  			System.out.println("GPWS error in DriverSetReport.jsp.1 ERROR: " + e);
  		} finally {
  			try {
  				if (DriverSetCount_RS != null)
  					DriverSetCount_RS.close();
  				if (psDriverSetCount != null)
  					psDriverSetCount.close();
  			} catch (Exception e){
	  			System.out.println("GPWS Error in DriverSetReport.jsp.2 ERROR: " + e);
  			}
  		}
		csvReport[csvCount] += printerCount;
		csvCount++;
	} // for loop

	} catch (Exception e) {
			System.out.println("Error in DriverSetHelp.jsp ERROR: " + e);
	} finally {
		if (DriverSetConfig_RS != null)
			DriverSetConfig_RS.close();
		if (psDriverSetConfig != null)
			psDriverSetConfig.close();
		if (con != null)
			con.close();
	}
	
for (int j=0; j < driversetidArray.length; j++) { %>
<%= csvReport[j]%><%	} %>