<%
	AppTools tool = new AppTools();
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print download report"/>
	<meta name="Description" content="Global print website download report information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("tableselect_reports_admin") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	<script type="text/javascript" djConfig="parseOnLoad: true"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function callNext(TabSel) {
		if (TabSel == "printerlog") {
			<% if ( pupb.getAccess(UserAuthConstants.DEVICE_ADD).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=530_csv&logaction=Downloaded the printerlog";
			<% } else { %>
				alert('<%= messages.getString("printerlogcsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "deviceInstallReport") {
			<% if ( pupb.getAccess(UserAuthConstants.DEVICE_ADD).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=2802&logaction=Ran the Device Installation Report";
			<% } else { %>
				alert('<%= messages.getString("device_install_report_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "deviceTroubleshooter") {
			<% if ( pupb.getAccess(UserAuthConstants.DEVICE_ADD).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=620&logaction=Executed the device troubleshooter";
			<% } else { %>
				alert('<%= messages.getString("device_troubleshooter_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "adminlog") {
			<% if ( pupb.getAccess(UserAuthConstants.USER_ADMIN).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=532_csv&logaction=Downloaded the user log";
			<% } else { %>
				alert('<%= messages.getString("userlogcsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "errorlog") {
			<% if ( pupb.getAccess(UserAuthConstants.USER_ADMIN).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=570_csv&logaction=Downloaded the error log";
			<% } else { %>
				alert('<%= messages.getString("errorlogcsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "dbstorage") {
			<% if ( pupb.getAccess(UserAuthConstants.USER_ADMIN).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=590&logaction=Downloaded the database storage report";
			<% } else { %>
				alert('<%= messages.getString("dbstorage_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "transaction") {
			<% if ( pupb.getAccess(UserAuthConstants.USER_ADMIN).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=592&logaction=Downloaded the gpws transaction report";
			<% } else { %>
				alert('<%= messages.getString("transaction_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "printers") {
			<% if ( pupb.getAccess(UserAuthConstants.DEVICE_ADD).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=534_csv&logaction=Downloaded the list of devices";
			<% } else { %>
				alert('<%= messages.getString("devicescsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "drivers") {
			<% if ( pupb.getAccess(UserAuthConstants.DRIVER_ADD).booleanValue() ) { %>	
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=536_csv&logaction=Downloaded the driver list";
			<% } else { %>
				alert('<%= messages.getString("driverscsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
		if (TabSel == "driverSet") {
			<% if ( pupb.getAccess(UserAuthConstants.DRIVER_ADD).booleanValue() ) { %>	
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=580&modelid=0&logaction=Downloaded the driver set report";
			<% } else { %>
				alert('<%= messages.getString("driversetcsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=580&modelid=0";
		}
		if (TabSel == "driverSetOS") {
			<% if ( pupb.getAccess(UserAuthConstants.DRIVER_ADD).booleanValue() ) { %>	
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=582&logaction=Downloaded the os driver set report";
			<% } else { %>
				alert('<%= messages.getString("driversetcsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=582";
		}
		if (TabSel == "protocols") {
			<% if ( pupb.getAccess(UserAuthConstants.PROTOCOL_ADD).booleanValue() || pupb.getAccess(UserAuthConstants.DRIVER_ADD).booleanValue() ) { %>
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=550_csv&logaction=Downloaded the protocol list";
			<% } else { %>
				alert('<%= messages.getString("protocolscsv_denied") %>');
				document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=520";
				return false;
			<% } %>
		}
	} //callNext
	 
	 dojo.addOnLoad(function() {
     });
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
			</ul>
			<h1><%= messages.getString("tableselect_reports_admin") %></h1>
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
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='form'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<p><%= messages.getString("reports_general") %></p>
				<p class="ibm-item-note"><%= messages.getString("reports_note") %>:&nbsp;<%= messages.getString("reports_info") %></p>
				<div class="ibm-columns">
						<div class="ibm-col-6-2">
							<em>
								<h2 class="ibm-rule"><%= messages.getString("reports_device") %></h2>
							</em>
							<div class="ibm-alternate-rule"><hr /></div>
							<ul>
								<li><a class="ibm-download-link" href="javascript:callNext('printerlog')"><%= messages.getString("printerlogcsv") %></a></li>
								<li><a class="ibm-download-link" href="javascript:callNext('printers')"><%= messages.getString("devicescsv") %></a></li>
								<li><a href="javascript:callNext('deviceInstallReport')"><%= messages.getString("device_install_report") %></a></li>
								<li><a href="javascript:callNext('deviceTroubleshooter')"><%= messages.getString("device_troubleshooter") %></a></li>
							<br />
							</ul>
							<em>
								<h2 class="ibm-rule"><%= messages.getString("reports_driver") %></h2>
							</em>
							<div class="ibm-alternate-rule"><hr /></div>
							<ul>
								<li><a class="ibm-download-link" href="javascript:callNext('drivers')"><%= messages.getString("driverscsv") %></a></li>
								<li><a href="javascript:callNext('driverSet')"><%= messages.getString("driversetcsv") %></a></li>
								<li><a href="javascript:callNext('driverSetOS')"><%= messages.getString("driversetoscsv") %></a></li>
							</ul>
							<br />
						</div>
						<div class="ibm-col-6-1"></div>
						<div class="ibm-col-6-2">
							<em>
								<h2 class="ibm-rule"><%= messages.getString("reports_protocol") %></h2>
							</em>
							<div class="ibm-alternate-rule"><hr /></div>
							<ul>
								<li><a class="ibm-download-link" href="javascript:callNext('protocols')"><%= messages.getString("protocolscsv") %></a></li>
							</ul>
							<br />
							<em>
								<h2 class="ibm-rule"><%= messages.getString("reports_admin") %></h2>
							</em>
							<div class="ibm-alternate-rule"><hr /></div>
							<ul>
								<li><a class="ibm-download-link" href="javascript:callNext('adminlog')"><%= messages.getString("userlogcsv") %></a></li>
								<li><a class="ibm-download-link" href="javascript:callNext('errorlog')"><%= messages.getString("errorlogcsv") %></a></li>
								<li><a href="javascript:callNext('dbstorage')"><%= messages.getString("database_storage_report") %></a></li>
								<li><a href="javascript:callNext('transaction')"><%= messages.getString("gpws_transaction_report") %></a></li>
							</ul>
						</div> <!--  END ibm-col-6-2 -->
				</div><!--  END ibm-columns -->
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>