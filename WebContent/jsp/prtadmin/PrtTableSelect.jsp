<%      
	// Check authorization levels
	PrinterUserProfileBean pupb2 = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	boolean hasAccess = false;
	boolean hasGPAccess = false;
	String[] sAuthTypes = pupb2.getAuthTypes();
	String CPAccess = "None";
	String KOAccess = "None";
	String GPWSAccess = "None";
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("CP")) {
			hasAccess = true;
			CPAccess = sAuthTypes[i];
		} else if (sAuthTypes[i].startsWith("Keyop")) {
			hasAccess = true;
			KOAccess = sAuthTypes[i];
		} else {
			hasAccess = true;
			GPWSAccess = sAuthTypes[i];
		}
	} //for
%>
<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print administration"/>
<meta name="Description" content="Global print website select an action item page" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("GPWS_administration") %> </title>
<%@ include file="metainfo2.jsp" %>

<script type="text/javascript" src="<%= statichtmldir %>/js/displayFields.js"></script>

<script language="Javascript">

dojo.ready(function() {
	var gpwsAccess = "<%= GPWSAccess %>";
	var KOAccess = "<%= KOAccess %>";
	var CPAccess = "<%= CPAccess %>";
	if (gpwsAccess == "" || gpwsAccess == "None") {
		if (KOAccess != null && KOAccess != "" && KOAccess != "None") {
			self.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250_KO";
		} else if (CPAccess != null && CPAccess != "" && CPAccess != "None") {
			self.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250_CP";
		} 
	}
 });

function callNext(TabSel) {

	if (TabSel == "DeviceAdd") {
			<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_ADD).booleanValue() ) {%>
				//loadWaitMsg('3');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=280";
			<% } else { %>
				alert('<%= messages.getString("tableselect_prtadd_denied") %>');
				return false;
			<% } %>
		}
	if (TabSel == "DeviceMod") {
			<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_MOD).booleanValue() ) {%>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=281";
			<% } else { %>
				alert('<%= messages.getString("tableselect_prtmod_denied") %>');
				return false;
			<% } %>
	}
	if (TabSel == "ServerAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.SERVER_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5000";
		<% } else { %>
			alert('<%= messages.getString("tableselect_server_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "ServerMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.SERVER_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5010";
		<% } else { %>
			alert('<%= messages.getString("tableselect_server_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "ErrorLog") {
		<% if ( pupb2.getAccess(UserAuthConstants.ERROR_LOG).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=570&ft=0&mpp=50";
		<% } else { %>
			alert('<%= messages.getString("tableselect_errorlog_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "UserLog") {
		<% if ( pupb2.getAccess(UserAuthConstants.USER_LOG).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=571&ft=0&mpp=50";
		<% } else { %>
			alert('<%= messages.getString("tableselect_userlog_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "UpdatesAdminister") {
		<% if ( pupb2.getAccess(UserAuthConstants.MASS_DB_UPDATE).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=530";
		<% } else { %>
			alert('<%= messages.getString("tableselect_updates_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "FTPSiteAdminister") {
		<% if ( pupb2.getAccess(UserAuthConstants.FTP_SERVER).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=340";
		<% } else { %>
			alert('<%= messages.getString("tableselect_ftpsite_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "TypeAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_TYPE_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=800";
		<% } else { %>
			alert('<%= messages.getString("tableselect_reports_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "TypeMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_TYPE_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=850";
		<% } else { %>
			alert('<%= messages.getString("tableselect_reports_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "DriverAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.DRIVER_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=322";
		<% } else { %>
			alert('<%= messages.getString("tableselect_driveradd_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "DriverMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.DRIVER_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=321";
		<% } else { %>
			alert('<%= messages.getString("tableselect_drivermod_denied") %>');
			return false;
		<% } %>
	}
		if (TabSel == "DriverSetAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.DRIVER_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=350";
		<% } else { %>
			alert('<%= messages.getString("tableselect_drivermod_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "DriverSetMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.DRIVER_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=352";
		<% } else { %>
			alert('<%= messages.getString("tableselect_drivermod_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "LocMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.LOCATION_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=261_Select";
		<% } else { %>
			alert('<%= messages.getString("tableselect_locmod_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "LocMassAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.LOCATION_MASS).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=2600";
		<% } else { %>
			alert('<%= messages.getString("tableselect_locadd_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "ProtocolAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.PROTOCOL_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=310";
		<% } else { %>
			alert('<%= messages.getString("tableselect_protocoladd_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "ProtocolMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.PROTOCOL_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=311";
		<% } else { %>
			alert('<%= messages.getString("tableselect_protocolmod_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "CategoryAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.CATEGORY_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7002";
		<% } else { %>
			alert('<%= messages.getString("tableselect_category_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "CategoryMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.CATEGORY_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7010";
		<% } else { %>
			alert('<%= messages.getString("tableselect_category_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "VendorAdmin") {
		<% if ( pupb2.getAccess(UserAuthConstants.CATEGORY_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=452";
		<% } else { %>
			alert('<%= messages.getString("tableselect_vendor_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "EnblAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7220";
		<% } else { %>
			alert('<%= messages.getString("tableselect_enbl_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "EnblMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7200";
		<% } else { %>
			alert('<%= messages.getString("tableselect_enbl_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "OSAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.OS_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=240";
		<% } else { %>
			alert('<%= messages.getString("tableselect_drivermod_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "OSMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.OS_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=242";
		<% } else { %>
			alert('<%= messages.getString("tableselect_drivermod_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "Sql") {
		<% if ( pupb2.getAccess(UserAuthConstants.SQL_COMMANDS).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=700";
		<% } else { %>
			alert('<%= messages.getString("tableselect_sql_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "AppSettings") {
		<% if ( pupb2.getAccess(UserAuthConstants.APP_SETTINGS).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=510";
		<% } else { %>
			alert('<%= messages.getString("tableselect_misc_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "AuthTypeAdmin") {
		<% if ( pupb2.getAccess(UserAuthConstants.AUTH_TYPE_ADMIN).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=3302&authgroup=All";
		<% } else { %>
			alert('<%= messages.getString("tableselect_printer_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "UserAdmin") {
		<% if ( pupb2.getAccess(UserAuthConstants.USER_ADMIN).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332";
		<% } else { %>
			alert('<%= messages.getString("tableselect_printer_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "ReportsAdminister") {
		<% if ( pupb2.getAccess(UserAuthConstants.DOWNLOAD_REPORTS).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
		<% } else { %>
			alert('<%= messages.getString("tableselect_reports_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "PrinterDefTypeAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.PRINTER_DEF_TYPE_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=390";
		<% } else { %>
			alert('<%= messages.getString("tableselect_server_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "PrinterDefTypeMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.PRINTER_DEF_TYPE_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=392";
		<% } else { %>
			alert('<%= messages.getString("tableselect_server_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "EnblTypeAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.PRINTER_DEF_TYPE_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7250";
		<% } else { %>
			alert('<%= messages.getString("tableselect_server_administer_denied") %>');
			return false;
		<% } %>
	}
}
</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("GPWS_administration") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="nav.jsp" %>			
<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main" role="main">
					<p><%= messages.getString("tableselect_info") %>&nbsp;&nbsp;<%= messages.getString("tableselect_admin_contact") %></p>
					<div class="ibm-columns">
						<!-- <div class="ibm-col-1-1"> -->
							<% if (hasAccess) { %>
							<%@ include file="NewsFeed.jsp" %>
				
							<!-- FIRST COLUMN OF ADMIN LINKS -->
						    <div class="ibm-col-6-2">
						    	
								<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_MOD).booleanValue() ) { %>
									<!-- Device administration -->
									<h2><%= messages.getString("tableselect_admin_device") %></h2>
									<ul>
										<li><a href="javascript: callNext('DeviceAdd');"><%= messages.getString("device_add_page") %></a></li>
										<li><a href="javascript: callNext('DeviceMod')";><%= messages.getString("tableselect_device_mod") %></a></li>
									</ul>
								<% } %>		
								<% if ( pupb2.getAccess(UserAuthConstants.MASS_DB_UPDATE).booleanValue() ) { %>
									<!-- Mass DB Update -->
									<h2><%= messages.getString("tableselect_admin_updates") %></h2>
									<ul>
										<li><a href="javascript: callNext('UpdatesAdminister');"><%= messages.getString("tableselect_updates_admin") %></a></li>
									</ul>
								<% } %>
								<% if ( pupb2.getAccess(UserAuthConstants.DRIVER_MOD).booleanValue() ) { %>
									<!-- Driver administration -->
									<h2><%= messages.getString("tableselect_admin_driver") %></h2>
									<ul>
										<li><a href="javascript: callNext('DriverAdd');"><%= messages.getString("tableselect_driver_add") %></a></li>
										<li><a href="javascript: callNext('DriverMod');"><%= messages.getString("tableselect_driver_mod") %></a></li>
										<li><a href="javascript: callNext('DriverSetAdd');"><%= messages.getString("driver_set_add") %></a></li>
										<li><a href="javascript: callNext('DriverSetMod');"><%= messages.getString("driver_set_administer") %></a></li>
									</ul>
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.LOCATION_MOD).booleanValue() ) { %>
									<!-- Location administration -->
									<h2 class="bar-gray-light"><%= messages.getString("tableselect_admin_loc") %></h2>
									<ul>
										<li><a href="javascript: callNext('LocMod');"><%= messages.getString("tableselect_loc_mod") %></a></li>
										<li><a href="javascript: callNext('LocMassAdd');"><%= messages.getString("tableselect_loc_mass_add") %></a></li>
									</ul>
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.CATEGORY_MOD).booleanValue() ) { %>
									<!-- Category administration -->
									<h2><%= messages.getString("tableselect_admin_category") %></h2>
									<ul>
										<li><a href="javascript: callNext('CategoryAdd');"><%= messages.getString("tableselect_category_mod") %></a></li>
									</ul>
								<% } %>
								<% if ( pupb2.getAccess(UserAuthConstants.APP_SETTINGS).booleanValue() || pupb2.getAccess(UserAuthConstants.SQL_COMMANDS).booleanValue() ) { %>
									<!-- Application configuration -->
									<h2><%= messages.getString("gpws_configuration") %></h2>
									<ul>
										<li><a href="javascript: callNext('AppSettings');"><%= messages.getString("app_settings") %></a></li>
										<li><a href="javascript: callNext('Sql');"><%= messages.getString("tableselect_sql_admin") %></a></li>
									</ul>
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.USER_ADMIN).booleanValue() || pupb2.getAccess(UserAuthConstants.AUTH_TYPE_ADMIN).booleanValue() ) { %>
									<!-- User administration -->
									<h2><%= messages.getString("user_administration") %></h2>
									<ul>
										<li><a href="javascript: callNext('UserAdmin');"><%= messages.getString("tableselect_printer_admin") %></a></li>
										<li><a href="javascript: callNext('AuthTypeAdmin');"><%= messages.getString("tableselect_admin_auth_type") %></a></li>
									</ul>
								<%	} %>
								
								
							</div> <!-- END ibm-col-6-2 -->
							<!-- SECOND COLUMN OF ADMIN LINKS -->
							<div class="ibm-col-6-3">
								<% if ( pupb2.getAccess(UserAuthConstants.SERVER_MOD).booleanValue() ) { %>
									<!-- Print server administration -->
									<h2><%= messages.getString("tableselect_admin_server") %></h2>
									<ul>
										<li><a href="javascript: callNext('ServerAdd');"><%= messages.getString("tableselect_server_add") %></a></li>
										<li><a href="javascript: callNext('ServerMod');"><%= messages.getString("tableselect_server_mod") %></a></li>
									</ul>	
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_MOD).booleanValue() ) { %>
									<!-- Enablement administration -->
									<h2><%= messages.getString("tableselect_admin_enbl") %></h2>
									<ul>
										<li><a href="javascript: callNext('EnblTypeAdd');"><%= messages.getString("enbl_type_admin") %></a></li>
									</ul>
								<% } %>
								<% if ( pupb2.getAccess(UserAuthConstants.DEVICE_TYPE_MOD).booleanValue() ) { %>
									<!-- Device model administration -->
 									<h2><%= messages.getString("tableselect_admin_type") %></h2>
									<ul>
										<li><a href="javascript: callNext('TypeAdd');"><%= messages.getString("add_strategic_device_type") %></a></li>
										<li><a href="javascript: callNext('TypeMod');"><%= messages.getString("administer_device_type") %></a></li>
									</ul>
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.FTP_SERVER).booleanValue() ) { %>
									<!-- Download repository administration -->
  									<h2><%= messages.getString("tableselect_admin_ftp_sites") %></h2>
									<ul>
 										<li><a href="javascript: callNext('FTPSiteAdminister');"><%= messages.getString("tableselect_ftp_admin") %></a></li>
									</ul>
								<% } %>
								<% if ( pupb2.getAccess(UserAuthConstants.PROTOCOL_MOD).booleanValue() ) { %>
									<!-- Protocol administration -->
									<h2><%= messages.getString("tableselect_admin_protocol") %></h2>
									<ul>
										<li><a href="javascript: callNext('ProtocolAdd');"><%= messages.getString("tableselect_protocol_add") %></a></li>
										<li><a href="javascript: callNext('ProtocolMod');"><%= messages.getString("tableselect_protocol_mod") %></a></li>
										<li><a href="javascript: callNext('PrinterDefTypeAdd');"><%= messages.getString("printer_def_type_add") %></a></li>
										<li><a href="javascript: callNext('PrinterDefTypeMod');"><%= messages.getString("printer_def_type_admin") %></a></li>
									</ul>
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.OS_ADD).booleanValue() || pupb2.getAccess(UserAuthConstants.OS_MOD).booleanValue() ) { %>
									<!-- Operating Systems -->
									<h2><%= messages.getString("operating_systems") %></h2>
									<ul>
										<li><a href="javascript: callNext('OSAdd');"><%= messages.getString("os_add") %></a></li>
										<li><a href="javascript: callNext('OSMod');"><%= messages.getString("os_administer") %></a></li>
									</ul>
								<%	} %>
								<% if ( pupb2.getAccess(UserAuthConstants.VENDOR_MOD).booleanValue()) { %>
									<!-- Vendors -->
									<h2><%= messages.getString("vendor_administer") %></h2>
									<ul>
										<li><a href="javascript: callNext('VendorAdmin');"><%= messages.getString("vendor_administer") %></a></li>
									</ul>
								<%	} %>
								
							</div> <!--  END ibm-col-6-2 -->
							<div class="ibm-col-6-1">
								<div class="ibm-container">
									<h2 class="ibm-alternative"><%= messages.getString("access_levels") %></h2>
									<div class="ibm-container-body">
								    	<p><b><%= messages.getString("gpws") %>:</b>&nbsp;<%= messages.getString(GPWSAccess.replace(' ','_')) %></p>
								    	<p><b><%= messages.getString("keyop_cap") %>:</b>&nbsp;<%= messages.getString(KOAccess.replace(' ','_')) %></p>
								    	<p><b><%= messages.getString("common_process") %>:</b>&nbsp;<%= messages.getString(CPAccess.replace(' ','_')) %></p>
								    
								    	<p><a href="<%= statichtmldir %>/AccessRequest.html"><%= messages.getString("access_request_page") %></a></p>
							    	</div>
								</div>
							    <% if (pupb2.getAccess(UserAuthConstants.DOWNLOAD_REPORTS).booleanValue()) { %>
							    <div class="ibm-container">
							    	<h3><%= messages.getString("reports") %></h3>
							    	<div class="ibm-container-body">
							    		<p><a href="javascript: callNext('ReportsAdminister');"><%= messages.getString("tableselect_reports_admin") %></a></p>
							    	</div>
							    </div>
							    <% } %>
							    <div class="ibm-container">
							    	<h3><%= messages.getString("support") %></h3>
							    	<div class="ibm-container-body">
							    		<p><a href="<%= statichtmldir %>/GPWSHelp.html"><%= messages.getString("tableselect_GPWS_help_doc") %></a></p>
							    	</div>
							    </div>
							    
								<% if (pupb2.getAccess(UserAuthConstants.ERROR_LOG).booleanValue() || pupb2.getAccess(UserAuthConstants.USER_LOG).booleanValue()) {%>
									<div class="ibm-container">
								    	<h3><%= messages.getString("logs") %></h3>
								    	<div class="ibm-container-body">
									<% if (pupb2.getAccess(UserAuthConstants.ERROR_LOG).booleanValue()) { %>
								    <p><a href="javascript: callNext('ErrorLog');" onclick="javascript: callNext('ErrorLog');" ><%= messages.getString("error_log") %></a></p>
								    <% } 
									   if (pupb2.getAccess(UserAuthConstants.USER_LOG).booleanValue()) { %>
								    <p><a href="javascript: callNext('UserLog');" onclick="javascript: callNext('UserLog');" ><%= messages.getString("user_log") %></a></p>
								    <% } %>
								    	</div>
								    </div>
								   <% } %>  
							</div>

							<% } else { //user does not have access %>
								<p><%= messages.getString("invalid_login") %>.  <%= messages.getString("believe_need_access") %> </p>
							<% } %>
						<!-- </div> --> <!-- END ibm-col-1-1 -->

					</div><!--  END ibm-columns ibm-graphics-tabs -->
				    <!-- ibm-content-main -->
				    <!-- FEATURES_END -->
				
				    <!-- CONTENT_BODY_END -->
				</div><!--  END ibm-content-main -->
			</div><!--  END ibm-content-body -->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>