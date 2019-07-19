<%    
    PrinterTools tool = new PrinterTools();
	String sDeviceName = request.getParameter("device");

    //dts will set all variables so all we have to do is pull variables in from dts 
    DeviceTroubleShooter dts = new DeviceTroubleShooter(sDeviceName, request);
    boolean install = dts.getInstallResult();
    String rc = dts.getRC();
   
	// if windowOnLoad is true then this will include javascript window_onload() function
   boolean windowOnLoad = false;
%>
<%@ include file="metainfo.jsp" %>
<meta name="Description" content="Global print website select an action item page" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_troubleshooter_results") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript">

	function packageDetails(drvPackage) {
		if (drvPackage != null && drvPackage.equals != "" && drvPackage.indexOf("/") >= 0) {
			dojo.byId("filepath").innerHTML = "<b>File path</b>: " + drvPackage.substring(0,drvPackage.lastIndexOf("/"));
			dojo.byId("filename").innerHTML = "<b>File name</b>: " + drvPackage.substring(drvPackage.lastIndexOf("/") + 1,drvPackage.length);
		}
		ibmweb.overlay.show('packageDetailsOverlay', this);
	}
</script>
</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp"%>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=620"><%= messages.getString("device_troubleshooter") %></a></li>
			</ul>
			<h1>
				<%= messages.getString("device_troubleshooter_results") %>
			</h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<!-- LEADSPACE_BEGIN -->
			<p>
				<%= messages.getString("device_ts_results_desc") %> 
				<br />
				<h3><%= messages.getString("overall_device_results") %></h3>
				<% if (install == true) { %>
				<p><a class="ibm-confirm-link"></a>&nbsp;<%= messages.getString("no_device_config_issues_found") %></p>
				<% } else { %>
				<p class="ibm-error"><a class="ibm-error-link"></a>&nbsp;<%= messages.getString("errors_found_not_install") %><br /><br /><%= messages.getString("reason") %>: <%= rc %></p>
				<% } %>
				<br />
				<h3><%= messages.getString("device_results") %></h3>
				<p><b><%= messages.getString("device_name") %>:</b> <%= sDeviceName %><br /><br />
				<% if (tool.nullStringConverter(dts.getStatus()).toUpperCase().equals("COMPLETED")) { %><a class="ibm-confirm-link"></a><% } else { %><a class="ibm-error-link"></a><% } %>&nbsp;<b><%= messages.getString("status") %>:</b> <%= dts.getStatus() %><br />
				<% if (!tool.nullStringConverter(dts.getModel()).equals("")) { %><a class="ibm-confirm-link"></a><% } else { %><a class="ibm-error-link"></a><% } %>&nbsp;<b><%= messages.getString("model") %>:</b> <%= dts.getModel() %><br />
				<% if (tool.nullStringConverter(dts.getWebVisible()).toUpperCase().equals("Y")) { %><a class="ibm-confirm-link"></a><% } else { %><a class="ibm-error-link"></a><% } %>&nbsp;<b><%= messages.getString("web_visible") %>:</b> <%= dts.getWebVisible() %><br />
				<% if (tool.nullStringConverter(dts.getInstallable()).toUpperCase().equals("Y")) { %><a class="ibm-confirm-link"></a><% } else { %><a class="ibm-error-link"></a><% } %>&nbsp;<b><%= messages.getString("installable_req") %>:</b> <%= dts.getInstallable() %><br />
				<br />
				<% if (tool.nullStringConverter(dts.getPrtDefType()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("printer_def_type") %>:</b> <%= dts.getPrtDefType() %><br />
				<% String sHostPortConfig = tool.nullStringConverter(dts.getHostPortConfig());
				if (sHostPortConfig.equals("Server/Port")) { 
				   if (tool.nullStringConverter(dts.getServer()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("server") %>:</b> <%= dts.getServer() %><br />
				<% if (tool.nullStringConverter(dts.getPort()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("port") %>:</b> <%= dts.getPort() %><br />
				<% } else if (sHostPortConfig.equals("Hostname/Port")) { 
				   if (tool.nullStringConverter(dts.getPort()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("port") %>:</b> <%= dts.getPort() %><br />
				<% if (tool.nullStringConverter(dts.getIP()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("ip_address") %>:</b> <%= dts.getIP() %><br />
				<% if (tool.nullStringConverter(dts.getHostname()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("ip_hostname") %>:</b> <%= dts.getHostname() %><br />
				<% } else if (sHostPortConfig.equals("Server/Server Process")) {
				   if (tool.nullStringConverter(dts.getServer()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("server") %>:</b> <%= dts.getServer() %><br />
				<% if (tool.nullStringConverter(dts.getSDC()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("sdc") %>:</b> <%= dts.getSDC() %><br />
				<% if (tool.nullStringConverter(dts.getProcess()).equals("")) { %><a class="ibm-error-link"></a><% } else { %><a class="ibm-confirm-link"></a><% } %>&nbsp;<b><%= messages.getString("server_process") %>:</b> <%= dts.getProcess() %><br />
				<% } %>
				<% if (dts.getValidDS()) { %><a class="ibm-confirm-link"></a><% } else { %><a class="ibm-error-link"></a><% } %>&nbsp;<b><%= messages.getString("driver_set_name") %>:</b> <%= dts.getDriverSet() %><br />
				</p>
				<br />
				<h3><%= messages.getString("os_driver_set_results") %></h3>
				<!-- DRIVER SET DATA TABLE -->
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Driver set data table">
					<caption><em><%= messages.getString("os_driver_set_table_desc") %>: <%= dts.getDriverSet() %></em></caption>
					<thead>
						<tr>
							<th></th>
							<th scope="col"><%= messages.getString("os_name") %></th>
							<th scope="col"><%= messages.getString("driver_name") %></th>
							<th scope="col"><%= messages.getString("options_file") %></th>
							<th scope="col"><%= messages.getString("driver_package") %></th>
						</tr>
					</thead>
					<tbody>
					<% String[] sOSName = dts.getOSName();
					//String[] sDriverName = dts.getDriverName();
					String[] sDriverModel = dts.getDriverModel();
					String[] sOptionsFile = dts.getOptionsFile();
					String[] sPackage = dts.getPackage();
					String[] aOS = dts.getOS();
					for (int x=0; x < dts.getOSName().length; x++) {
						if (sOSName[x] != null) { %>
					<tr><td><% if (sDriverModel[x] != null) { 
									if (sOSName[x].equals("Linux") && sDriverModel[x] != null && !sDriverModel[x].equals("") && sOptionsFile[x].toLowerCase().indexOf("ppd") < 0) { %>
										<a class="ibm-error-link"></a><%
									} else { %>
										<a class="ibm-confirm-link"></a><%
									}
								} else { %>
									<a class="ibm-error-link"></a> <%
								} %>
								</td><td><%= sOSName[x] %></td><td><%= sDriverModel[x] %></td><td><%= sOptionsFile[x] %></td><td><%= sPackage[x] %>&nbsp;<a href="javascript:packageDetails('<%= sPackage[x] %>')">(<%= messages.getString("details") %>)</a></td></tr><%
						//}
						 	for (int y=0; y < aOS.length; y++) {
								if(sOSName[x].equals(aOS[y])) {
									aOS[y] = "";
									break;
								}
							}
						}
					} 
						for (int z=0; z < aOS.length; z++) {
							if (aOS[z] != null && !aOS[z].equals("")) { %>
							<tr><td><a class="ibm-error-link"></a></td><td><%= aOS[z] %></td><td></td><td></td></tr>
					<% 	} 	}
					%>
					</tbody>
				</table> <!-- END DRIVER SET TABLE -->
				<br />
				<h3><%= messages.getString("recent_install_errors") %></h3>
				<!-- RECENT ERRORS DATA TABLE -->
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Recent errors data table">
					<caption><em><%= messages.getString("recent_install_errors_desc") %>: <%= sDeviceName %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("error_code") %></th>
							<th scope="col"><%= messages.getString("number_of_occurrences") %></th>
							<th scope="col"><%= messages.getString("suggested_fix") %></th>
						</tr>
					</thead>
					<tbody>
				<% int[] aInstallError = dts.getInstallErrors();
				   int[] aInstallErrorCount = dts.getInstallErrorsCount();
					for (int x=0; x <= dts.getInstallErrorLength(); x++) {
						if (aInstallError[x] != 0) { 
							if (aInstallError[x] == 2) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin2.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 3) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin3.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 5) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin5.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 6) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin6.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 8) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin8.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 126) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin126.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 1722) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin1722.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else if (aInstallError[x] == 1796) { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPlugin1796.html"><%= messages.getString("suggested_fix") %></a></td></tr>
						<%  } else { %>
								<tr><td><%= aInstallError[x] %></td><td><%= aInstallErrorCount[x] %></td><td><a href="<%= statichtmldir %>/ErrorWebPluginOther.html"><%= messages.getString("suggested_fix") %></a></td></tr>
					<%	 	}
						}
					}
				%>
				</tbody>
				</table> <!-- END DRIVER SET TABLE -->
				<p><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=2800&name=<%= sDeviceName %>&SearchName=<%= sDeviceName %>%"><%= messages.getString("view_full_install_stats") %></a></p>
				
				<!-- PACKAGE DETAILS OVERAL STARTS HERE -->
				<div class="ibm-common-overlay" id="packageDetailsOverlay">
					<div class="ibm-head">
						<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
					</div>
					<div class="ibm-body">
						<div class="ibm-main">
							<div class="ibm-title ibm-subtitle">
								<h1><%= messages.getString("driver_package") %></h1>
							</div>
							<p class="ibm-overlay-intro"><%= messages.getString("driver_package_details") %><br /><br />
							<div><b><%= messages.getString("ftp_site") %></b>: <%= tool.nullStringConverter(dts.getFTPSite()) %></div>
							<div id="filepath"></div>
							<div id="filename"></div><br />
							</p>
						</div>
					</div>
				
					<div class="ibm-footer"></div>
				</div>
				<!-- PACKAGE DETAILS OVERLAY ENDS HERE -->
			</div><!-- CONTENT_MAIN END-->
		</div><!-- CONTENT_BODY END-->
	</div><!-- END ibm-content -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>