<%
   com.ibm.aurora.bhvr.TableQueryBhvr DeviceSearch  = (TableQueryBhvr) request.getAttribute("DeviceSearch");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet DeviceSearch_RS = DeviceSearch.getResults();
%>
<%@ include file="metainfo.jsp" %>
<% boolean windowOnLoad = false; %>
<meta name="keywords" content="Global Print, keyop, request service device lookup results"/>
<meta name="Description" content="This page shows the results of a printer search." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("device_search_results") %></title>
<%@ include file="metainfo2.jsp" %>
<!--* Main Content Begin *-->
<script language="Javascript">
	
	function callSelect(city,building,floor,room,name) {
		window.opener.document.theForm.devicename.value = name;
		window.opener.document.theForm.site.value = city;
		window.opener.document.theForm.building.value = building;
		window.opener.document.theForm.floor.value = floor;
		window.opener.document.theForm.room.value = room;
		window.close();
	}
</script>
</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-popup">
		<%@ include file="mastheadPopup.jsp" %>
		<!-- MASTHEAD_END -->
		
		<!-- LEADSPACE_BEGIN -->
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<h1><%= messages.getString("device_search_results") %></h1>
			</div> <!--  Leadspace-body -->
		</div> <!--  Leadspace-head -->
		<!-- LEADSPACE_END -->
		
		<!-- All the main body stuff goes here -->
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<p class="ibm-intro ibm-alternate-three"><em><%= messages.getString("device_search_results") %></em></p><br />

						<table width="100%"><tr><td align="left"><a href="javascript: history.go(-1)">&lt; <%= messages.getString("back") %></a></td><td align="right"><a href="javascript:window.close()"><%= messages.getString("close_window") %></a></td></tr></table>
						<div class="hrule-dots">&nbsp;</div>
						<br />
						<% if (DeviceSearch_RS.getResultSetSize() > 0) { %>
							
						<h2><%= DeviceSearch_RS.getResultSetSize() %> <%= messages.getString("devices_found") %></h2>
						
						<table class="ibm-data-table" border="0" cellpadding="0" cellspacing="0" summary="This table displays printer search results.">
							<caption>This table displays printer search results</caption>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("building") %></th>
									<th scope="col"><%= messages.getString("floor") %></th>
									<th scope="col"><%= messages.getString("room") %></th>
									<th scope="col"><%= messages.getString("room_access") %></th>
									<th scope="col"><%= messages.getString("device_name") %></th>
									<th scope="col"><%= messages.getString("device_type") %></th>
									<th scope="col"><%= messages.getString("select_device") %></th>
								</tr>
							</thead>
							<tbody>
						        
						<%
							AppTools appTool = new AppTools();
							int locIDValue = 0;
							String geoValue = "";
							String countryValue = "";
							String cityValue = "";
							String buildingValue = "";
							String floorValue = "";
							String roomValue = "";
							String nameValue = "";
							String alias = "";
							String type = "";		
							String access = "";
							boolean bFlag = true;
							String igsKeyop = "";
							int iGray = 0;
							while(DeviceSearch_RS.next()) {
								locIDValue = DeviceSearch_RS.getInt("LOCID");
								geoValue = appTool.nullStringConverter(DeviceSearch_RS.getString("GEO"));
								countryValue = appTool.nullStringConverter(DeviceSearch_RS.getString("COUNTRY"));
								cityValue = appTool.nullStringConverter(DeviceSearch_RS.getString("CITY"));
								buildingValue = appTool.nullStringConverter(DeviceSearch_RS.getString("BUILDING_NAME"));
								floorValue = appTool.nullStringConverter(DeviceSearch_RS.getString("FLOOR_NAME").trim());
								roomValue = appTool.nullStringConverter(DeviceSearch_RS.getString("ROOM"));
								access = appTool.nullStringConverter(DeviceSearch_RS.getString("ROOM_ACCESS"));			
								nameValue = appTool.nullStringConverter(DeviceSearch_RS.getString("DEVICE_NAME"));
								type = appTool.nullStringConverter(DeviceSearch_RS.getString("MODEL"));		
								igsKeyop = appTool.nullStringConverter(DeviceSearch_RS.getString("IGS_KEYOP"));
						 %>
							<tr>						
								<td><%= buildingValue %></td>
								<td><%= floorValue %></td>
								<td><%= roomValue %></td>
								<td><%= access %></td>
								<td><%= nameValue %></td>
								<td><%= type %></td>
								<td>
								<% if (igsKeyop.equals("Y") || igsKeyop.equals("y")) { %>
								<a href="javascript:callSelect('<%= cityValue %>','<%= buildingValue %>','<%= floorValue %>','<%= roomValue %>','<%= nameValue %>')">Select <%= nameValue %></a>
								<% } else { %>
								<%= messages.getString("keyop_services_not_avail") %>
								<% } %>
								</td>
							</tr>
							
							<% bFlag = !bFlag;
								}
							%>
							</tbody>
						</table>
						<% } else { %>
						
							<p><%= messages.getString("no_devices_found") %></p>
						
						<% } %>
					
					<br />
					<div class="hrule-dots">&nbsp;</div>
					<table width="100%"><tr><td align="left"><a href="javascript: history.go(-1)">&lt; <%= messages.getString("back") %></a></td><td align="right"><a href="javascript:window.close()"><%= messages.getString("close_window") %></a></td></tr></table>
				</div><!-- CONTENT_MAIN END -->
			</div><!-- CONTENT_BODY END -->
		</div><!-- END ibm-content -->
	</div>
	</div>
</body>
</html>