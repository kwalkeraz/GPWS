<%
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSet");
	TableQueryBhvrResultSet DriverSet_RS = DriverSet.getResults();
	tools.print.prtadmin.DriverSetConfigUpdate driverset = new tools.print.prtadmin.DriverSetConfigUpdate();
	int iDriverSetID = 0;
	String driversetid = "";
	String referer = request.getParameter("referer");
	String modelid = request.getParameter("modelid");
	int driversetconfigid = 0;
	String logaction = request.getParameter("logaction");
	PrinterTools tool = new PrinterTools();
	Connection con = null;
	PreparedStatement psDriverSetConfig = null;
	ResultSet DriverSetConfig_RS = null;
	PreparedStatement psOptionsFile = null;
	ResultSet OptionsFileView_RS = null;
	int resultSize = 0;
	String[] osabbrArray = new String[OSView_RS.getResultSetSize()];
	String driversetname = "";
	int[] driversetidArray = new int[DriverSet_RS.getResultSetSize()];
	String[] driversetArray = new String[DriverSet_RS.getResultSetSize()];
	String model = "";
	int y = 0;
	int x = 0;
	
	if (DriverSet_RS.getResultSetSize() > 0) {
		while (DriverSet_RS.next()) {
			model = DriverSet_RS.getString("MODEL");
			driversetname = DriverSet_RS.getString("DRIVER_SET_NAME");
			driversetidArray[y] = DriverSet_RS.getInt("DRIVER_SETID");
			driversetArray[y] = DriverSet_RS.getString("DRIVER_SET_NAME");
			y++;
		}  //while
	} //if
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website driver set help"/>
	<meta name="Description" content="Global print website driver set help page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_configuration") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript">
		ibmweb.config.set({
			greeting: { enabled: false }
		});
	</script>

</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="mastheadPopup.jsp" %>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<h1><%= messages.getString("driver_set_configuration") %></h1>
			</div> 
		</div>
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<p>
							<%= messages.getString("device_model") %>: <%= model %>
						</p>
					    <table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display a list of all available driver sets along with its corresponding drivers for each operating system and options files">
							<caption><em><%= messages.getString("driver_set_config_info") %></em></caption>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("driver_set_name") %></th>
									<%	OSView_RS.first();
										while (OSView_RS.next()) { %>
									<th scope="col"><%= tool.nullStringConverter(OSView_RS.getString("OS_NAME")) %></th>
									<%  } //while OSView %>
								</tr>
							</thead>
							<tbody>
							<%	try {
									con = tool.getConnection();
									OSView_RS.first();
									String sqlQuery = "SELECT OS_DRIVERID, DRIVER_MODEL, DRIVERID, DRIVER_SET_NAME, OPTIONS_FILEID, OPTIONS_FILE_NAME, FUNCTIONS FROM GPWS.DRIVER_SET_CONFIG_VIEW WHERE OSID = ? AND DRIVER_SETID = ?";
									psDriverSetConfig = con.prepareStatement(sqlQuery,ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
									  	
									for (int i=0; i < driversetidArray.length; i++) { %>
								<tr>
									<td>
										<%= driversetArray[i] %>
									</td>
									<%	OSView_RS.first();
										while (OSView_RS.next()) {
											//int counter = 0;
											//int osdriverid = 0;
											//int driverid = 0;
											int osid = 0;
											String drivermodel = "";
											String optionsfile = "";
											osid = OSView_RS.getInt("OSID");
											psDriverSetConfig.setInt(1, osid);
										  	psDriverSetConfig.setInt(2, driversetidArray[i]);
										  	DriverSetConfig_RS = psDriverSetConfig.executeQuery(); %>
									<td>
										<% 	while( DriverSetConfig_RS.next() ) {
												//osdriverid = DriverSetConfig_RS.getInt("OS_DRIVERID");
												drivermodel = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_MODEL"));
												//driverid = DriverSetConfig_RS.getInt("DRIVERID");
												optionsfile = tool.nullStringConverter(DriverSetConfig_RS.getString("OPTIONS_FILE_NAME"));
												//String dsname = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_SET_NAME"));
												//counter++; %>
												<%= drivermodel %>
												<% if (!optionsfile.equals("")) { %>
													<i>(<%= optionsfile %>)</i>
												<% } //if Optionsfile %>
										<%  } //while DriverSetConfig_RS %>
									</td> 
									<% 	}  //while OSView  %>
								</tr>
								<%	} // for loop %>
							<%  } catch (Exception e) {
									System.out.println("Error in DriverSetHelp.jsp ERROR: " + e);
								} finally {
									DriverSetConfig_RS.close();
									psDriverSetConfig.close();
									con.close();
								} %>
							</tbody>
						</table> 
						<div align="right"><span><a class="ibm-cancel-link" href="javascript:window.close();parent.opener.window.focus();"><%= messages.getString("close") %></a></span></div>
					</div>
				</div>
			</div>
			<!-- CONTENT_END -->
		</div>
	</div>
</body>