<%
	TableQueryBhvr DeviceList  = (TableQueryBhvr) request.getAttribute("DeviceList");
	TableQueryBhvrResultSet DeviceList_RS = DeviceList.getResults();
	AppTools tool = new AppTools();  
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website driver set device list"/>
	<meta name="Description" content="Global print website driver set report device list" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("listsearch_search_info_device") %> </title>
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
				<h1><%= messages.getString("listsearch_search_info_device") %></h1>
			</div> 
		</div>
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="<%= messages.getString("driver_set_device_list") %>">
							<caption><em><%= DeviceList_RS.getResultSetSize() %> <%= messages.getString("devices_found") %></em></caption>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("device_name") %></th>
									<th scope="col"><%= messages.getString("device_status") %></th>
									<th scope="col"><%= messages.getString("e2e_category") %></th>
									<th scope="col"><%= messages.getString("device_model") %></th>
								</tr>
							</thead>
							<tbody>
								<%	while (DeviceList_RS.next()) { %>
								<tr>
									<td><%= tool.nullStringConverter(DeviceList_RS.getString("DEVICE_NAME")) %></td>
									<td><%= tool.nullStringConverter(DeviceList_RS.getString("STATUS")) %></td>
									<td><%= tool.nullStringConverter(DeviceList_RS.getString("E2E_CATEGORY")) %></td>
									<td><%= tool.nullStringConverter(DeviceList_RS.getString("MODEL")) %></td>
								</tr>
								<% 	}  //while DeviceList_RS  %>
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