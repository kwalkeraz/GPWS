<%
   TableQueryBhvr DeviceView  = (TableQueryBhvr) request.getAttribute("Device");
   TableQueryBhvrResultSet DeviceView_RS = DeviceView.getResults();
   boolean isExternal = PrinterConstants.isExternal;
   AppTools tool = new AppTools();
   String referer = request.getParameter("referer");
   referer = tool.nullStringConverter(referer);
	String ServerName = tool.nullStringConverter(request.getParameter("servername"));
	String device = "";
	String lpname = "";
	String status = "";
	String serverdeftype = "";
	String spooler = "";
	int serverid = 0;
	int deviceid = 0;
	int locid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view devices by server"/>
	<meta name="Description" content="Global print website view devices by server information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("server_list_devices_by_server") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	
	<script type="text/javascript">
	function lookDevice(deviceid, devicename) {
		devicename = devicename.toUpperCase() + "%";
		var referer = "282";
		var params = "&deviceid="+deviceid+"&referer=" + referer + "&SearchName=" + devicename ;
		var link = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=283" + params;
		var args = 'height=500,width=900,toolbar=yes,location=yes,menubar=yes,scrollbars=yes,resizable=yes,status=yes';	
		window.open(link,'_blank',args);
	} //loolDevice
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5010"><%= messages.getString("server_select_location") %></a></li>
				<% if (referer.equals("5021")) {%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5021&sdc=<%= request.getParameter("sdc") %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } else if (referer.equals("5022")){%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5022&servername=<%= ServerName.toUpperCase() %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } else {%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5022&servername=<%= ServerName.toUpperCase() %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("server_list_devices_by_server") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<h2><%= messages.getString("server_name") %>: <%= ServerName %></h2>
			<br />
			<div id='response'></div>
			<div id='serverForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='serveridloc'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available print servers and the corresponding protocols they support">
					<caption><em><%= messages.getStringArgs("device_found", new String[] {Integer.toString(DeviceView_RS.getResultSetSize())}) %></em></caption>
					<% if (DeviceView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_name") %></th>
							<th scope="col"><%= messages.getString("status") %></th>
							<th scope="col"><%= messages.getString("device_lpname") %></th>
							<th scope="col"><%= messages.getString("server_definition") %></th>
							<th scope="col"><%= messages.getString("spooler") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						while(DeviceView_RS.next()) {
							ServerName = DeviceView_RS.getString("SERVER_NAME");
							device = tool.nullStringConverter(DeviceView_RS.getString("DEVICE_NAME"));
							status = tool.nullStringConverter(DeviceView_RS.getString("STATUS"));
							lpname = tool.nullStringConverter(DeviceView_RS.getString("LPNAME"));
							serverdeftype = tool.nullStringConverter(DeviceView_RS.getString("SERVER_DEF_TYPE"));
							spooler = tool.nullStringConverter(DeviceView_RS.getString("SPOOLER"));
							serverid = DeviceView_RS.getInt("SERVERID");
							deviceid = DeviceView_RS.getInt("DEVICEID");
					 %>
						<tr id='tr<%= serverid %>'>
							<th class="ibm-table-row" scope="row">
								<a class="ibm-signin-link" href="javascript:lookDevice('<%= deviceid %>','<%=device %>');"><%=device %></a>
							</th>
							<td>
								<%= status %>
							</td>
							<td>
								<%= lpname %>
							</td>
							<td>
								<%= serverdeftype %>
							</td>
							<td>
								<%= spooler %>
							</td>
						</tr>
					<% } //while loop %>
					</tbody>
					<% } //if there are records %>
				</table>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>