<%
   TableQueryBhvr AppVersionsFromDB  = (TableQueryBhvr) request.getAttribute("AppVersionsFromDB");
   TableQueryBhvrResultSet AppVersionsFromDB_RS = AppVersionsFromDB.getResults();
   
   TableQueryBhvr WidgetVersionFromDB  = (TableQueryBhvr) request.getAttribute("WidgetVersionFromDB");
   TableQueryBhvrResultSet WidgetVersionFromDB_RS = WidgetVersionFromDB.getResults();
   
   TableQueryBhvr GPWSVersionFromDB  = (TableQueryBhvr) request.getAttribute("GPWSVersionFromDB");
   TableQueryBhvrResultSet GPWSVersionFromDB_RS = GPWSVersionFromDB.getResults();
   
   AppTools appTool = new AppTools();
   AppVersionsFromDB_RS.next();
   String sPluginVer = appTool.nullStringConverter(AppVersionsFromDB_RS.getString("PLUGIN_VERSION"));
   String sObjectVer = appTool.nullStringConverter(AppVersionsFromDB_RS.getString("CLSID"));
   
   if (sObjectVer != null) {
		sObjectVer = sObjectVer.substring( (sObjectVer.indexOf("version=") + 8), (sObjectVer.length() - 2) );
   }
   String sWidgetVer = "";
   String sIPMVer = "";
   String GPWSVer = "";
   while (WidgetVersionFromDB_RS.next()) {
		if (appTool.nullStringConverter(WidgetVersionFromDB_RS.getString("OS_ABBR")).equals("XP")) {
			sIPMVer = appTool.nullStringConverter(WidgetVersionFromDB_RS.getString("PROTOCOL_VERSION"));
		} else {
			sWidgetVer = appTool.nullStringConverter(WidgetVersionFromDB_RS.getString("PROTOCOL_VERSION"));
		}
   }
   
	while (GPWSVersionFromDB_RS.next()) {
		if (GPWSVersionFromDB_RS.getString("CATEGORY_CODE").toUpperCase().equals("VERSION")) {
			GPWSVer = appTool.nullStringConverter(GPWSVersionFromDB_RS.getString("CATEGORY_VALUE1"));
		}
	} //while gpwsversion
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print version information" />
	<meta name="Description" content="Global print website version information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("gpws_version_information") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("gpws_version_information") %></h1>
		</div>
	</div>
	<%@ include file="../prtadmin/nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			<ul>
				<li><%= messages.getString("gpws_app_version") %>: <strong><%= GPWSVer %></strong></li>
				<li><%= messages.getString("ipm_version") %>: <strong><%= sIPMVer %></strong></li>
			</ul>
			<p></p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='Form'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
					<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display search results for devices">
					<caption><em><%= messages.getString("plugin_version_description") %></em></caption>
						<thead>
							<tr>
								<th scope="col"><%= messages.getString("os") %></th>
								<th scope="col"><%= messages.getString("browser") %></th>
								<th scope="col"><%= messages.getString("plugin_type") %></th>
								<th scope="col"><%= messages.getString("version") %></th>
							</tr>
						</thead>
					<tbody>
						<tr>
							<th scope="row" class="ibm-table-row"><%= messages.getString("windows") %></th>
							<td><%= messages.getString("internet_explorer") %></td>
							<td><%= messages.getString("object") %></td>
							<td><%= sObjectVer %></td>
						</tr>
						<tr>
							<th scope="row" class="ibm-table-row"><%= messages.getString("windows") %></th>
							<td><%= messages.getString("firefox") %></td>
							<td><%= messages.getString("plugin") %></td>
							<td><%= sPluginVer %></td>
						</tr>
						<tr>
							<th scope="row" class="ibm-table-row"><%= messages.getString("linux") %></th>
							<td><%= messages.getString("firefox") %></td>
							<td><%= messages.getString("widget") %></td>
							<td><%= sWidgetVer %></td>
						</tr>		
					</tbody>
				</table>
			</div>
		</div>
		<!-- FEATURES_BEGIN -->
		<div id="ibm-content-sidebar">
			<div id="ibm-contact-module">
			<!--IBM Contact Module-->
			</div>
		</div>
		<!-- FEATURES_END -->
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>