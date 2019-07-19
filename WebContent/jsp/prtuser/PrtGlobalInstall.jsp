<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print printer search"/>
<meta name="Description" content="Global print installs a printer to user's workstation" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_install") %></title>
<%@ include file="metainfo2.jsp" %>
<%
   PrinterInstallData pid  = (PrinterInstallData) request.getAttribute("GetPrtInstallData");
   PrinterInstallBean pib = pid.pib;
   TableQueryBhvr OSViewFromDB  = (TableQueryBhvr) request.getAttribute("OSViewFromDB");
   TableQueryBhvrResultSet OSViewFromDB_RS = OSViewFromDB.getResults();
   PrinterTools tool = new PrinterTools();
   AppTools appTool = new AppTools();

	String browser = tool.nullStringConverter(request.getParameter("browser"));
	String[] osArray = new String[10];
	int x = 0;
	while (OSViewFromDB_RS.next()) {
		osArray[x] = OSViewFromDB_RS.getString("OS_ABBR");
		x++;
	}
	int LOCID = 0;
	String GEO = "";
	String COUNTRY = "";
	String STATE = "";
	String CITY = "";
	String BUILDING = "";
	String FLOOR = "";
	String ROOM = "";
	String NAME = "";
	String CLSID = "";
	String CLSID64BIT = "";
	String ClientUser = "";
	String ClientPass = "";
	String ClientDumpDir = "";
	String PLUGINURL = "";
	String PLUGINSPAGE = "";
	String ERRORURL = "";
	String SUCCESSURL = "";
	String PLUGINVER = "";
	String WIDGETVER = "";
	String ILS = "";

	String RESTRICT = "";
	String SEPFILE = "";
	
	String FTPSITE = "";
	String FTPPASS = "";
	String FTPUSER = "";
	String FTPHOMEDIR = "";
	String STATUS  = "";
	
	String PRTCOMMENT = "";
	String PRTLOCATION = "";
    String SERVER = "";
	String TNAME = "";
	String TYPE = "";
	String PORT = "";
	String LPNAME = "";
	
	CLSID = pib.getCLSID();
	CLSID64BIT = pib.getCLSID64BIT();
	ClientUser = pib.getClientUserid();
	ClientPass = pib.getClientPassword();
	ClientDumpDir = pib.getClientDumpDir();
	PLUGINURL = pib.getPluginURL();
	PLUGINSPAGE = pib.getPluginsPage();
	ERRORURL = pib.getErrorURL();
	SUCCESSURL = pib.getSuccessURL();
	PLUGINVER = pib.getPluginVer();
	WIDGETVER = pib.getWidgetVer();
	ILS = pib.getILS();
	
	LOCID = pib.getLocid();
	GEO = pib.getGeo();
	COUNTRY = pib.getCountry();
	STATE = pib.getState();
	CITY = pib.getCity();
	BUILDING = pib.getBuilding();
	FLOOR = pib.getFloor();
	ROOM = pib.getRoom();
	
	FTPSITE = pib.getFtpSite();
	FTPPASS = pib.getFtpPass();
	FTPUSER = pib.getFtpUser();
	FTPHOMEDIR = pib.getFtpHomeDir();
	
	NAME = pib.getPrtName();
	TYPE = pib.getPrtModel();
	PRTCOMMENT = pib.getPrtComment();
	RESTRICT = pib.getRestrict();
	SEPFILE = pib.getPrtSepFile();
	//PORT = pib.getPort();
	LPNAME = pib.getLPName();

	PRTLOCATION = "Floor " + FLOOR + " of " + BUILDING + " in " + CITY + ", " + STATE;
	if (TYPE != null && !TYPE.equals("")) {
		for(int j=0; j <= TYPE.length(); j++) {
			if (j+5 <= TYPE.length()) {
				if (TYPE.substring(j,j+5).equalsIgnoreCase("COLOR")) {
					NAME += " Color";
				}
			}
			if (j+6 <= TYPE.length()) {
				if (TYPE.substring(j,j+6).equalsIgnoreCase("COLOUR")) {
					NAME += " Color";
				}
			}
		}	
	}
	TNAME = NAME + "-" + ROOM +"-" + FLOOR + "-" + BUILDING + "-" + CITY;
	if(TNAME.length() > 255)
	NAME = TNAME.substring(0,255);
	else NAME = TNAME;
	
	//Remove any blanks from the name
	NAME = NAME.trim();
	
	//Check the plugin version to see if password encryption is needed
	String sVersion = PLUGINVER;
	sVersion = sVersion.substring(0,1); 
	int VNum = Integer.parseInt(sVersion);
	if (VNum < 3) {
		// Use decrypt method
		FTPPASS = tool.DecryptString(FTPPASS);
		StringBuffer strbuf = new StringBuffer(RESTRICT);
            strbuf.reverse();
            RESTRICT = strbuf.toString();
            RESTRICT = tool.DecryptString(RESTRICT);
            //System.out.println("Here is the out of Reverse Password : " + RESTRICT);
	} // else use regular encrypted passwords.	
%>
<script type="text/javascript" src="<%= statichtmldir %>/js/OSBrowserCheck.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/PrtInstallInstructions.js"></script>
<script language="javascript">

dojo.ready(function() {
	initialize();
	executeOS();
});

</script>
</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp"%>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<ul id="ibm-navigation-trail">
					<li></li>
				</ul>
				<h1>
					<%= messages.getString("printer_install_nav") %>
				</h1>
			</div>
		</div>
		<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<div id="instructions"></div>
			
			<% if (browser.toLowerCase().indexOf("internet explorer") >= 0 && browser.toLowerCase().indexOf("64 bit") > 0) { %>
			<%= CLSID64BIT.replace('!','"') %>
			<% } else { %>
			<%= CLSID.replace('!','"') %>
			<% } %>
			<param name="pluginurl" value="<%= PLUGINURL %>"/>
			<param name="pluginspage" value="<%= PLUGINSPAGE %>"/>
			<param name="errorurl"   value="<%= ERRORURL %>"/>
			<param name="successurl" value="<%= SUCCESSURL %>"/>
			<param name="pluginver" value="<%= PLUGINVER %>"/>
			<param name="widgetver" value="<%= WIDGETVER %>"/>
			<param name="ils" value="<%= ILS %>"/>
			<param name="clientuserid" value="<%= ClientUser %>"/>
			<param name="clientpassword" value="<%= ClientPass %>"/>
			<param name="clientdumpdir" value="<%= ClientDumpDir %>"/>
			<param name="site" value="<%= FTPSITE %>"/>
			<param name="ftppass" value="<%= FTPPASS %>"/>
			<param name="ftpuser" value="<%= FTPUSER %>"/>
			<param name="prtname" value="<%= NAME %>"/>
			<param name="prtcomment" value="<%= PRTCOMMENT %>"/>
			<param name="prtlocation" value="<%= PRTLOCATION %>"/>
			<param name="prtsepfile" value="<%= SEPFILE %>"/>                                 
			<param name="restrict" value="<%= RESTRICT %>"/>
			
			<% for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="port<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.port[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="host<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.host[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="spooler<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.spooler[a]) %>"/>
			<% } %>
			<% for (int a = 0; a < pib.getOSNumber(); a++) { 
				if (osArray[a] != null && !osArray[a].equals("")) {%>
					<param name="lpname<%= osArray[a] %>" value="<%= LPNAME %>"/>
			<% 	}
			   } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { 
					if (pib.driverName[a] == null || pib.driverName[a].equals("")) { %>
						<param name="drivername<%= osArray[a] %>" value="<%= osArray[a] %>DUMMY"/>
					<% } else { %>	
						<param name="drivername<%= osArray[a] %>" value="<%= pib.driverName[a] %>"/>
					<% } 
			   } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="driverpackage<%= osArray[a] %>" value="<%= FTPHOMEDIR %><%= appTool.nullStringConverter(pib.driverPackage[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="version<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.driverVersion[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="datafile<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.dataFile[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="driverpath<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.driverPath[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="configfile<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.configFile[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="helpfile<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.helpFile[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="monitor<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.monitor[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="monfile<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.monitorFile[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="filelist<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.fileList[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="defaulttype<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.defaultType[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="prtprocessor<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.proc[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="prtprocfile<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.procFile[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="prtattributes<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.prtAttributes[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="changeini<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.changeINI[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="optionsfile<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.optionsFile[a]) %>"/>
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="protocol<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.protocolType[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="protocolver<%= osArray[a] %>" value="<%= appTool.nullStringConverter(pib.protocolVersion[a]) %>"/>
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					<param name="protocolpackage<%= osArray[a] %>" value="<%= FTPHOMEDIR %><%= appTool.nullStringConverter(pib.protocolPackage[a]) %>"/>
			<% } %>
			<embed type="application/x-cpsweb" height="180" width="180" 
			pluginurl="<%= PLUGINURL %>"
			pluginspage="<%= PLUGINSPAGE %>"
			errorurl="<%= ERRORURL %>"
			successurl="<%= SUCCESSURL %>"
			pluginver="<%= PLUGINVER %>"
			widgetver="<%= WIDGETVER %>"
			ils="<%= ILS %>"
			clientuserid="<%= ClientUser %>"
			clientpassword="<%= ClientPass %>"
			clientdumpdir="<%= ClientDumpDir %>"
			site="<%= FTPSITE %>"
			ftppass="<%= FTPPASS %>"
			ftpuser="<%= FTPUSER %>"
			prtname="<%= NAME %>"
			prtcomment="<%= PRTCOMMENT %>"
			prtlocation="<%= PRTLOCATION %>"
			prtsepfile="<%= SEPFILE %>"
			restrict="<%= RESTRICT %>"
			<% for (int a = 0; a < pib.getOSNumber(); a++) { %>
					port<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.port[a]) %>"
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					host<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.host[a]) %>"
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					spooler<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.spooler[a]) %>"
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
				lpname<%= osArray[a] %>="<%= LPNAME %>"
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { 
					if (pib.driverName[a] == null || pib.driverName[a].equals("")) { %>
						drivername<%= osArray[a] %>="<%= osArray[a] %>DUMMY"
					<% } else { %>	
						drivername<%= osArray[a] %>="<%= pib.driverName[a] %>"
					<% } 
			   } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					driverpackage<%= osArray[a] %>="<%= FTPHOMEDIR %><%= appTool.nullStringConverter(pib.driverPackage[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					version<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.driverVersion[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					datafile<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.dataFile[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					driverpath<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.driverPath[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					configfile<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.configFile[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					helpfile<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.helpFile[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					monitor<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.monitor[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					monfile<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.monitorFile[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					filelist<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.fileList[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					defaulttype<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.defaultType[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					prtprocessor<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.proc[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					prtprocfile<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.procFile[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					prtattributes<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.prtAttributes[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					changeini<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.changeINI[a]) %>"
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					optionsfile<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.optionsFile[a]) %>"
			<% }
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					protocol<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.protocolType[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					protocolver<%= osArray[a] %>="<%= appTool.nullStringConverter(pib.protocolVersion[a]) %>"
			<% } 
			   for (int a = 0; a < pib.getOSNumber(); a++) { %>
					protocolpackage<%= osArray[a] %>="<%= FTPHOMEDIR %><%= appTool.nullStringConverter(pib.protocolPackage[a]) %>"
			<% } %>
			</embed>
			</object>
			</center>
		</div>
		<!-- FEATURES_BEGIN -->
		<div id="ibm-content-sidebar">
			<div id="ibm-contact-module">
			<!--IBM Contact Module-->
				<%= messages.getString("for_more_info_visit") %>:
				<ul>
					<li><a href="<%= statichtmldir %>/HowtoInstallPrinters.html"><%= messages.getString("how_to_install_printer") %></a></li>
					<li><a href="<%= statichtmldir %>/UserInformation.html"><%= messages.getString("user_info") %></a></li>
				</ul>
			</div>
		</div>
		<!-- FEATURES_END -->
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>