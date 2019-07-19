<%

	TableQueryBhvr PrtInfoSearch  = (TableQueryBhvr) request.getAttribute("PrtAllFieldsView");
	TableQueryBhvrResultSet PrtInfoSearch_RS = PrtInfoSearch.getResults();
	TableQueryBhvr PrtNotesView  = (TableQueryBhvr) request.getAttribute("PrtNotes");
	TableQueryBhvrResultSet PrtNotesView_RS = PrtNotesView.getResults();

	TableQueryBhvr EnblHdrView  = (TableQueryBhvr) request.getAttribute("EnblHeader");
	TableQueryBhvrResultSet EnblHdrView_RS = EnblHdrView.getResults();
	TableQueryBhvr EnblInfo  = (TableQueryBhvr) request.getAttribute("EnblInfo");
	TableQueryBhvrResultSet EnblInfo_RS = EnblInfo.getResults();
	
	TableQueryBhvr DeviceFunctionView  = (TableQueryBhvr) request.getAttribute("DeviceFunctionView");
	TableQueryBhvrResultSet DeviceFunctionView_RS = DeviceFunctionView.getResults();
	
	AppTools appTool = new AppTools();
	int iDeviceID = 0;
	String Geo = "";
	String Country = "";
	String State = "";
	String Site = "";
	String Building = "";
	String Floor = "";
	String Room = "";
	String Name = "";
	String Type = "";
	String CS = "";
	String VM = "";
	String MVS = "";
	String SAP = "";
	String WTS = "";
	String LPName = "";
	String Port = "";
	String SepFile = "";
	String Restrict = "";
	String Status = "";
	String REQNUM = "";
	String PRTTYPE = "";
	String IGSASSET = "";
	String IGSPRT = "";
	String IGSKEYOP = "";
	String DUPLEX = "";
	String NOTRAYS = "";
	String BODYTRAY = "";
	String HEADERTRAY = "";
	String PSERNO = "";
	String MACADD = "";
	String ITCOMMENT = "";
	String DIPP = "";
	String ENDTOEND = "";
	String ROOMACCESS = "";
	String ROOMPHONE = "";
	String LANDROP = "";
	String CONNECTTYPE = "";
	String KONAME = "";
	String KOPHONE = "";
	String KOADD = "";
	String KOPAGE = "";
	String KOCO = "";
	String FAXNUMBER  = "";
	String SEPARATORPAGE = "";
	String sBillDept = "";
	String sBillDiv = "";
	String sBillDetail = "";
	String EMAILBILL = "";
	String NAMEBILL = "";
	String IPDOMAIN = "";
	String IPSUBNET = "";
	String IPGATEWAY = "";
	String PS = "";
	String PCL = "";
	String ASCII = "";
	String IPDS = "";
	String PPDS = "";
	String WEBVISIBLE = "";
	String INSTALLABLE = "";
	String IPHOSTNAME = "";
	String IPADDR = "";
	String POOLNAME = "";
	String PrinterDefType = "";
	String DriverSetName = "";
	String Comm = "";
	String CommPort = "";
	String Spooler = "";
	String SpoolerPort = "";
	String Super = "";
	String SuperPort = "";
	String IPMQueueName = "";
	String PSDestName = "";
	String AFPDestName = "";
	String Server = "";
	String ServerSDC = "";
    
    while (PrtInfoSearch_RS.next()) {
	// the user profile stuff
		iDeviceID = PrtInfoSearch_RS.getInt("DEVICEID");
		Geo = appTool.nullStringConverter(PrtInfoSearch_RS.getString("GEO"));
		Country = appTool.nullStringConverter(PrtInfoSearch_RS.getString("COUNTRY"));
		State = appTool.nullStringConverter(PrtInfoSearch_RS.getString("STATE"));
		Site = appTool.nullStringConverter(PrtInfoSearch_RS.getString("CITY"));
		Building = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BUILDING_NAME"));
		Floor = appTool.nullStringConverter(PrtInfoSearch_RS.getString("FLOOR_NAME"));
		Room = appTool.nullStringConverter(PrtInfoSearch_RS.getString("ROOM"));
		Name = appTool.nullStringConverter(PrtInfoSearch_RS.getString("DEVICE_NAME"));
		Type = appTool.nullStringConverter(PrtInfoSearch_RS.getString("MODEL"));
		CS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("CS"));
		VM = appTool.nullStringConverter(PrtInfoSearch_RS.getString("VM"));
		MVS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("MVS"));
		SAP = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SAP"));
		WTS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("WTS"));
		LPName = appTool.nullStringConverter(PrtInfoSearch_RS.getString("LPNAME"));
		Port = appTool.nullStringConverter(PrtInfoSearch_RS.getString("PORT"));
		SepFile = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SEPARATOR_PAGE"));
		Restrict = appTool.nullStringConverter(PrtInfoSearch_RS.getString("RESTRICT"));
		Status = appTool.nullStringConverter(PrtInfoSearch_RS.getString("STATUS"));
		REQNUM = appTool.nullStringConverter(PrtInfoSearch_RS.getString("REQUEST_NUMBER"));
		IGSASSET = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IGS_ASSET"));
		IGSPRT = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IGS_DEVICE"));
		IGSKEYOP = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IGS_KEYOP"));
		DUPLEX = appTool.nullStringConverter(PrtInfoSearch_RS.getString("DUPLEX"));
		NOTRAYS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("NUMBER_TRAYS"));
		BODYTRAY = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BODY_TRAY"));
		HEADERTRAY = appTool.nullStringConverter(PrtInfoSearch_RS.getString("HEADER_TRAY"));
		PSERNO = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SERIAL_NUMBER"));
		MACADD = appTool.nullStringConverter(PrtInfoSearch_RS.getString("MAC_ADDRESS"));
		ITCOMMENT = appTool.nullStringConverter(PrtInfoSearch_RS.getString("COMMENT"));
		DIPP = appTool.nullStringConverter(PrtInfoSearch_RS.getString("DIPP"));
		ENDTOEND = appTool.nullStringConverter(PrtInfoSearch_RS.getString("E2E_CATEGORY"));
		ROOMACCESS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("ROOM_ACCESS"));
		ROOMPHONE = appTool.nullStringConverter(PrtInfoSearch_RS.getString("ROOM_PHONE"));
		LANDROP = appTool.nullStringConverter(PrtInfoSearch_RS.getString("LAN_DROP"));
		CONNECTTYPE = appTool.nullStringConverter(PrtInfoSearch_RS.getString("CONNECT_TYPE"));
		KONAME = appTool.nullStringConverter(PrtInfoSearch_RS.getString("KO_NAME"));
		KOPHONE = appTool.nullStringConverter(PrtInfoSearch_RS.getString("KO_PHONE"));
		KOADD = appTool.nullStringConverter(PrtInfoSearch_RS.getString("KO_EMAIL"));
		KOPAGE = appTool.nullStringConverter(PrtInfoSearch_RS.getString("KO_PAGER"));
		KOCO = appTool.nullStringConverter(PrtInfoSearch_RS.getString("KO_COMPANY"));
		FAXNUMBER  = appTool.nullStringConverter(PrtInfoSearch_RS.getString("FAX_NUMBER"));
		sBillDept = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BILL_DEPT"));
		sBillDiv = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BILL_DIV"));
		sBillDetail = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BILL_DETAIL"));
		EMAILBILL = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BILL_EMAIL"));
		NAMEBILL = appTool.nullStringConverter(PrtInfoSearch_RS.getString("BILL_NAME"));
		IPDOMAIN = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IP_DOMAIN"));
		IPSUBNET = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IP_SUBNET"));
		IPGATEWAY = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IP_GATEWAY"));
		IPHOSTNAME = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IP_HOSTNAME"));
		IPADDR = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IP_ADDRESS"));
		POOLNAME = appTool.nullStringConverter(PrtInfoSearch_RS.getString("POOL_NAME"));
		IPMQueueName = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IPM_QUEUE_NAME"));
		PSDestName = appTool.nullStringConverter(PrtInfoSearch_RS.getString("PS_DEST_NAME"));
		AFPDestName = appTool.nullStringConverter(PrtInfoSearch_RS.getString("AFP_DEST_NAME"));
		PS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("PS"));
		PCL = appTool.nullStringConverter(PrtInfoSearch_RS.getString("PCL"));
		ASCII = appTool.nullStringConverter(PrtInfoSearch_RS.getString("ASCII"));
		IPDS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("IPDS"));
		PPDS = appTool.nullStringConverter(PrtInfoSearch_RS.getString("PPDS"));
		WEBVISIBLE = appTool.nullStringConverter(PrtInfoSearch_RS.getString("WEB_VISIBLE"));
		INSTALLABLE = appTool.nullStringConverter(PrtInfoSearch_RS.getString("INSTALLABLE"));
		PrinterDefType = appTool.nullStringConverter(PrtInfoSearch_RS.getString("CLIENT_DEF_TYPE"));
		DriverSetName = appTool.nullStringConverter(PrtInfoSearch_RS.getString("DRIVER_SET_NAME"));
		Comm = appTool.nullStringConverter(PrtInfoSearch_RS.getString("COMM"));
		CommPort = appTool.nullStringConverter(PrtInfoSearch_RS.getString("COMM_PORT"));
		Spooler = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SPOOLER"));
		SpoolerPort = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SPOOLER_PORT"));
		Super = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SUPERVISOR"));
		SuperPort = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SUPERVISOR_PORT"));
		Server = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SERVER_NAME"));
		ServerSDC = appTool.nullStringConverter(PrtInfoSearch_RS.getString("SERVER_SDC"));		
	} //while loop
	
	String referer = "";
	String searchValue = "";
	String searchName = "";
	String geo = "";
	String country = "";
	String site = "";
	String building = "";
	String floor = "";
	referer = appTool.nullStringConverter(request.getParameter("referer"));
	searchValue = appTool.nullStringConverter(request.getParameter("searchvalue"));
	searchName = appTool.nullStringConverter(request.getParameter("SearchName"));
	geo = appTool.nullStringConverter(request.getParameter("geo"));
	country = appTool.nullStringConverter(request.getParameter("country"));
	site = appTool.nullStringConverter(request.getParameter("city"));
	building = appTool.nullStringConverter(request.getParameter("building"));
	floor = appTool.nullStringConverter(request.getParameter("floor"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print Web Site view device info"/>
	<meta name="Description" content="Global print website view device information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_info") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.ready(function() {
	 	createpTag();
	 	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
	 });
	 
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead4.jsp" %>
		<header class="hero hero--small" style="background-image: url(&quot;https://w3-03.ibm.com/tools/print/images/bee_background.png&quot;);">
		<h1 class="hero__title">Global Print | <%= Name %> </h1> <!---->
		<div role="presentation" class="hero__contrast-layer" style="opacity: 0.3;">
    	</div></header>
	
		<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div >
					<ul id="ibm-navigation-trail">
						<li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=60"><%= messages.getString("browse_devices") %></a></li>
						<% if (referer.equals("620")) { %>
						<li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=<%= referer %>&searchvalue=<%= searchValue.toUpperCase() %>&SearchName=<%= searchName %>"><%= messages.getString("device_search_results")%></a></li>
						<% } else if (referer.equals("610")) { %>
						<li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= site %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("device_search_results")%></a></li>
						<% } else if (referer.equals("600")) { %>
						<li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= site %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("device_search_results") %></a></li>
						<% } else { %>
						<li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=620&searchvalue=<%= Name.toUpperCase() %>&SearchName=<%= Name.toUpperCase() %>"><%= messages.getString("device_search_results") %></a></li>
						<% } %>
					</ul>
		
				</div>
			</div>
			
		<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
		<!-- CONTENT_BODY -->
		<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<% if (PrtInfoSearch_RS.getResultSetSize() > 0) { %>
			<div id='Device'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<%= messages.getString("device_info") %> | <%= Name %>
					</em>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_location_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for="site">
						<%= messages.getString("geo") %>: 
					</label>
					<span>
						<%= Geo %>
					</span>
				</div>
				<div class="pClass">
					<label for="site">
						<%= messages.getString("country") %>: 
					</label>
					<span>
						<%= Country %>
					</span>
				</div>
				<div class="pClass">
					<label for="site">
						<%= messages.getString("state") %>: 
					</label>
					<span>
						<%= State %>
					</span>
				</div>
				<div class="pClass">
					<label for="site">
						<%= messages.getString("site") %>: 
					</label>
					<span>
						<%= Site %>
					</span>
				</div>
				<div class="pClass">	
					<label id="buildinglabel" for="building">
						<%= messages.getString("building") %>:
					</label>
					<span>
						<%= Building %>
					</span>
				</div>
				<div class="pClass">
					<label for="floor">
						<%= messages.getString("floor") %>:
					</label>
					<span>
						<%= Floor %>
					</span>
				</div>
				<div class="pClass">
					<label for='room'><%= messages.getString("room") %>:</label>
					<span><%= Room %></span>
				</div>
				<div class="pClass">
					<label for='roomaccess'><%= messages.getString("room_access") %>:</label>
					<span><%= ROOMACCESS %></span>
				</div>
				<div class="pClass">
					<label for='roomphone'><%= messages.getString("room_phone") %>:</label>
					<span><%= ROOMPHONE %></span>
				</div>
				<div class="pClass">
					<label for='landrop'><%= messages.getString("lan_drop") %>:</label>
					<span><%= LANDROP %></span>
				</div>
				<div class="pClass">
					<label for='connectype'><%= messages.getString("connect_type") %>:</label>
					<span><%= CONNECTTYPE %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("hardware_configuration") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='duplex'><%= messages.getString("duplex") %>:</label>
					<span><%= DUPLEX %></span>
				</div>
				<div class="pClass">
					<label for='numtrays'><%= messages.getString("num_trays") %>:</label>
					<span><%= NOTRAYS %></span>
				</div>
				<div class="pClass">
					<label for='bodytray'><%= messages.getString("device_body_tray") %>:</label>
					<span><%= BODYTRAY %></span>
				</div>
				<div class="pClass">
					<label for='headertray'><%= messages.getString("device_header_tray") %>:</label>
					<span><%= HEADERTRAY %></span>
				</div>
				<div class="pClass">
					<label for='ps'><%= messages.getString("ps") %>:</label>
					<span><%= PS %></span>
				</div>
				<div class="pClass">
					<label for='pcl'><%= messages.getString("pcl") %>:</label>
					<span><%= PCL %></span>
				</div>
				<div class="pClass">
					<label for='ascii'><%= messages.getString("ascii") %>:</label>
					<span><%= ASCII %></span>
				</div>
				<div class="pClass">
					<label for='ipds'><%= messages.getString("ipds") %>:</label>
					<span><%= IPDS %></span>
				</div>
				<div class="pClass">
					<label for='ppds'><%= messages.getString("ppds") %>:</label>
					<span><%= PPDS %></span>
				</div>
				<div class="pClass">
					<label for='macaddress'><%= messages.getString("mac_address") %>:</label>
					<span><%= MACADD %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("info_ip") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='ipaddress'><%= messages.getString("ip_address") %>:</label>
					<span><%= IPADDR %></span>
				</div>
				<div class="pClass">
					<label for='iphostname'><%= messages.getString("ip_hostname") %>:</label>
					<span><%= IPHOSTNAME %></span>
				</div>
				<div class="pClass">
					<label for='ipdomain'><%= messages.getString("ip_domain") %>:</label>
					<span><%= IPDOMAIN %></span>
				</div>
				<div class="pClass">
					<label for='ipgateway'><%= messages.getString("ip_gateway") %>:</label>
					<span><%= IPGATEWAY %></span>
				</div>
				<div class="pClass">
					<label for='ipsubnet'><%= messages.getString("ip_subnet") %>:</label>
					<span><%= IPSUBNET %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("info_keyop") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='koname'><%= messages.getString("ko_name") %>:</label>
					<span><%= KONAME %></span>
				</div>
				<div class="pClass">
					<label for='kophone'><%= messages.getString("ko_phone") %>:</label>
					<span><%= KOPHONE %></span>
				</div>
				<div class="pClass">
					<label for='koemail'><%= messages.getString("ko_email") %>:</label>
					<span><%= KOADD %></span>
				</div>
				<div class="pClass">
					<label for='kopager'><%= messages.getString("ko_pager") %>:</label>
					<span><%= KOPAGE %></span>
				</div>
				<div class="pClass">
					<label for='koco'><%= messages.getString("ko_company") %>:</label>
					<span><%= KOCO %></span>
				</div>
				<div class="pClass">
					<label for='igsko'><%= messages.getString("igs_keyop") %>:</label>
					<span><%= IGSKEYOP %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("info_bill") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='billdiv'><%= messages.getString("bill_division") %>:</label>
					<span><%= sBillDiv %></span>
				</div>
				<div class="pClass">
					<label for='billdept'><%= messages.getString("bill_dept") %>:</label>
					<span><%= sBillDept %></span>
				</div>
				<div class="pClass">
					<label for='billdetail'><%= messages.getString("bill_detail") %>:</label>
					<span><%= sBillDetail %></span>
				</div>
				<div class="pClass">
					<label for='billemail'><%= messages.getString("bill_email") %>:</label>
					<span><%= EMAILBILL %></span>
				</div>
				<div class="pClass">
					<label for='billname'><%= messages.getString("bill_name") %>:</label>
					<span><%= NAMEBILL %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for="device"><%= messages.getString("device_name") %>:</label>
					<span><%= Name %></span>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:</label>
					<span><strong><%= Status %></strong></span>
				</div>
				<div class="pClass">
					<label for='functions'><%= messages.getString("device_functions") %>:</label>
					<span>
						<% while (DeviceFunctionView_RS.next()) { %>
							<%= DeviceFunctionView_RS.getString("FUNCTION_NAME") %>,&nbsp;
						<% } %>
					</span>
				</div>
				<div class="pClass">
					<label for='model'><%= messages.getString("model") %>:</label>
					<span><%= Type %></span>
				</div>
				<div class="pClass">
					<label for='faxnumber'><%= messages.getString("fax_number") %>:</label>
					<span><%= FAXNUMBER %></span>
				</div>
				<div class="pClass">
					<label for='serialnum'><%= messages.getString("serial_number") %>:</label>
					<span><%= PSERNO %></span>
				</div>
				<div class="pClass">
					<label for='comment'><%= messages.getString("comment") %>:</label>
					<span><%= ITCOMMENT %></span>
				</div>
				<div class="pClass">
					<label for='endtoend'><%= messages.getString("end_to_end") %>:</label>
					<span><%= ENDTOEND %></span>
				</div>
				<div class="pClass">
					<label for='cs'><%= messages.getString("cs") %>:</label>
					<span><%= CS %></span>
				</div>
				<div class="pClass">
					<label for='vm'><%= messages.getString("vm") %>:</label>
					<span><%= VM %></span>
				</div>
				<div class="pClass">
					<label for='mvs'><%= messages.getString("mvs") %>:</label>
					<span><%= MVS %></span>
				</div>
				<div class="pClass">
					<label for='sap'><%= messages.getString("sap") %>:</label>
					<span><%= SAP %></span>
				</div>
				<div class="pClass">
					<label for='wts'><%= messages.getString("wts") %>:</label>
					<span><%= WTS %></span>
				</div>
				<div class="pClass">
					<label for='igsasset'><%= messages.getString("igs_asset") %>:</label>
					<span><%= IGSASSET %></span>
				</div>
				<div class="pClass">
					<label for='igsprinter'><%= messages.getString("igs_printer") %>:</label>
					<span><%= IGSPRT %></span>
				</div>
				<div class="pClass">
					<label for='webvisible'><%= messages.getString("web_visible") %>:</label>
					<span><%= WEBVISIBLE %></span>
				</div>
				<div class="pClass">
					<label for='installablereq'><%= messages.getString("installable_req") %>:</label>
					<span><%= INSTALLABLE %></span>
				</div>				
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("server_def") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='printerdeftype'><%= messages.getString("printer_def_type") %>:</label>
					<span><%= PrinterDefType %></span>
				</div>	
				<div class="pClass">
					<label for='driversetname'><%= messages.getString("driver_set_name") %>:</label>
					<span><%= DriverSetName %></span>
				</div>	
				<div class="pClass">
					<label for='sdc'><%= messages.getString("sdc") %>:</label>
					<span><%= ServerSDC %></span>
				</div>	
				<div class="pClass">
					<label for='servername'><%= messages.getString("server_name") %>:</label>
					<span><%= Server %></span>
				</div>	
				<div class="pClass">
					<label for='port'><%= messages.getString("port") %>:</label>
					<span><%= Port %></span>
				</div>	
				<div class="pClass">
					<label for='communicator'><%= messages.getString("communicator") %>:</label>
					<span><%= Comm %></span>
				</div>	
				<div class="pClass">
					<label for='commport'><%= messages.getString("port") %>:</label>
					<span><%= CommPort %></span>
				</div>	
				<div class="pClass">
					<label for='spooler'><%= messages.getString("spooler") %>:</label>
					<span><%= Spooler %></span>
				</div>	
				<div class="pClass">
					<label for='spoolerport'><%= messages.getString("port") %>:</label>
					<span><%= SpoolerPort %></span>
				</div>	
				<div class="pClass">
					<label for='supervisor'><%= messages.getString("supervisor") %>:</label>
					<span><%= Super %></span>
				</div>	
				<div class="pClass">
					<label for='superport'><%= messages.getString("port") %>:</label>
					<span><%= SuperPort %></span>
				</div>	
				<div class="pClass">
					<label for='devicelogprtname'><%= messages.getString("device_log_prt_name") %>:</label>
					<span><%= LPName %></span>
				</div>	
				<div class="pClass">
					<label for='poolname'><%= messages.getString("pool_name") %>:</label>
					<span><%= POOLNAME %></span>
				</div>	
				<div class="pClass">
					<label for='ipmqueuename'><%= messages.getString("device_ipm_queue_name") %>:</label>
					<span><%= IPMQueueName %></span>
				</div>	
				<div class="pClass">
					<label for='psdestname'><%= messages.getString("device_ps_dest_name") %>:</label>
					<span><%= PSDestName %></span>
				</div>	
				<div class="pClass">
					<label for='installablereq'><%= messages.getString("device_afp_dest_name") %>:</label>
					<span><%= AFPDestName %></span>
				</div>	
				<div class="pClass">
					<label for='sepfile'><%= messages.getString("separator_page") %>:</label>
					<span><%= SepFile %></span>
				</div>	
				<div class="pClass">
					<label for='dipp'><%= messages.getString("dipp") %>:</label>
					<span><%= DIPP %></span>
				</div>	
				
				<% if (EnblHdrView_RS.getResultSetSize() > 0) { %>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_enablements") %></h2>
					</em>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="This table displays all enablement field information for each enablement type for this printer.">
					<caption><em></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("enbl_type") %></th>
							<th scope="col"><%= messages.getString("enbl_status") %></th>
							<th scope="col"><%= messages.getString("comments") %></th>
						</tr>
					</thead>
					<tbody>
					<%
					int fieldcount = 0;
					String thisEnblType;
					
					String enbltype = "";
					String status = "";
					String comments = "";
					int enbltypeid = 0;
					int lastenbltypeid = 0;
					int enblheaderid = 0;
					int enbldetailid = 0;
					String[] enblfieldArray = new String[EnblInfo_RS.getResultSetSize()];
					String[] enblfieldvalueArray = new String[EnblInfo_RS.getResultSetSize()];
					int[] enblheaderidArray = new int[EnblInfo_RS.getResultSetSize()];
					int[] enblfieldidArray = new int[EnblInfo_RS.getResultSetSize()];
					int[] enbldetailidArray = new int[EnblInfo_RS.getResultSetSize()];
					int x = 0;
					int counter = 0;
					
					while (EnblInfo_RS.next()) { 
						enblheaderidArray[x] = EnblInfo_RS.getInt("ENBL_HEADERID");
						enbldetailidArray[x] = EnblInfo_RS.getInt("ENBL_DETAILID");
						enblfieldidArray[x] = EnblInfo_RS.getInt("ENBL_FIELDID");
						enblfieldArray[x] = EnblInfo_RS.getString("ENBL_FIELD_NAME");
						enblfieldvalueArray[x] = EnblInfo_RS.getString("ENBL_FIELD_VALUE");
						x++;
					}
				
					String lastenbltype = "";
					String laststatus = "";
					int lastheaderid = 0;
					EnblHdrView_RS.first();
					while (EnblHdrView_RS.next()) {
							enbltype = EnblHdrView_RS.getString("ENBL_TYPE");
							status = EnblHdrView_RS.getString("ENBL_STATUS");
							comments = EnblHdrView_RS.getString("ENBL_COMMENTS");
							enbltypeid = EnblHdrView_RS.getInt("ENBL_TYPEID");
							enblheaderid = EnblHdrView_RS.getInt("ENBL_HEADERID");
				%>
						
							<% if (lastheaderid != enblheaderid) { %>
						<tr>
							<td><%= enbltype %></td>
							<td><%= status %></td> 
							<td><%= comments %></td> 
						</tr>
						<tr>
							<th></th>
							<th scope="col"><%= messages.getString("enbl_field") %></th>
							<th scope="col"><%= messages.getString("enbl_field_value") %></th>
						</tr>
						<tr>
							<% } else { %>
							<td colspan="5"></td>
							<% } //enbltype = lastenbltype %>
							<%  if (EnblInfo_RS.getResultSetSize() > 0) {
									boolean headervalue = false;
									while (counter < enbldetailidArray.length) { 
										if (enblheaderid == enblheaderidArray[counter]) { %>
						</tr>
							<tr>
								<td></td>
										<td><%= enblfieldArray[counter] %></a></td>
										<td><%= enblfieldvalueArray[counter] %></td>
									<% 	}  //if not equal 
										counter++;
									 } //while EnblInfo
									 if (!headervalue) { %>
							</tr>
									<%}
									counter = 0;
								} else { %>
							</tr>
							<%  } //if > 0 %>
						</tr>
				<%		lastheaderid = enblheaderid;
					}  //main while loop %>
					</tbody>
				</table>
				<% } //if Enablements %>
			</div>
			
			<% if (PrtNotesView_RS.getResultSetSize() > 0) { %>
			<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="This tables lists the notes for this device.">
					<caption><em></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_note_code") %></th>
							<th scope="col"><%= messages.getString("device_note_value") %></th>
						</tr>
					</thead>
					<tbody>
			<%
					String notecodeValue = "";	
					String notevalueValue = "";	
					String notevalueDisplay = "";
					String notecodeLookupValue = "";
					int iGray = 0;
					while(PrtNotesView_RS.next()) {
						notecodeValue = appTool.nullStringConverter(PrtNotesView_RS.getString("NOTE_CODE"));
						notevalueValue = appTool.nullStringConverter(PrtNotesView_RS.getString("NOTE_VALUE"));
						notecodeLookupValue = appTool.nullStringConverter(PrtNotesView_RS.getString("CATEGORY_VALUE1")); %>
						<tr>
							<td><%= notecodeValue %></td>
							<td><%= notevalueValue %></td>
						</tr> 
				<%  } //while PrtNotesView %>
					</tbody>
				</table>
			   <% } //if PrtNotes %>
			<% } else { %>
			<div class="pClass">
				<%= messages.getString("no_printers_info") %>
			</div>
			<% } //PrtInfoSearch%>
		</div>
		<div class="ibm-alternate-rule"><hr /></div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo2.jsp" %>