<%
   TableQueryBhvr PrtListFloorSearch  = (TableQueryBhvr) request.getAttribute("PrtListView");
   TableQueryBhvrResultSet PrtListFloorSearch_RS = PrtListFloorSearch.getResults();
   
   TableQueryBhvr DeviceFunctionsView = (TableQueryBhvr) request.getAttribute("DeviceFunctionsView");
   TableQueryBhvrResultSet DeviceFunctionsView_RS = DeviceFunctionsView.getResults();
   
   int iGray = 0;
   AppTools appTool = new AppTools();
   Cookie cGeo = new Cookie("globalPrintGeo",appTool.nullStringConverter(request.getParameter("geo")));
	Cookie cCountry = new Cookie("globalPrintCountry",appTool.nullStringConverter(request.getParameter("country")));
	Cookie cSite = new Cookie("globalPrintSite",appTool.nullStringConverter(request.getParameter("city")));
	Cookie cBuilding = new Cookie("globalPrintBuilding",appTool.nullStringConverter(request.getParameter("building")));
	Cookie cFloor = new Cookie("globalPrintFloor",appTool.nullStringConverter(request.getParameter("floor")));
	Cookie cSearchName = new Cookie("globalPrintSearchName",appTool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME)));
	cGeo.setMaxAge(31449600);
	cCountry.setMaxAge(31449600);
	cSite.setMaxAge(31449600);
	cBuilding.setMaxAge(31449600);
	cFloor.setMaxAge(31449600);
	response.addCookie(cGeo);
	response.addCookie(cCountry);
	response.addCookie(cSite);
	response.addCookie(cBuilding);
	response.addCookie(cFloor);
	
	if (appTool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME)) != "") {
		cSearchName.setMaxAge(31449600);
		response.addCookie(cSearchName);
	} //searchbyName
    //end of cookies
    String geo = appTool.nullStringConverter(request.getParameter("geo"));
    String country = appTool.nullStringConverter(request.getParameter("country"));
    String city = appTool.nullStringConverter(request.getParameter("city"));
    String building = appTool.nullStringConverter(request.getParameter("building"));
    String floor = appTool.nullStringConverter(request.getParameter("floor"));
    String searchName = appTool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
    String topageid = appTool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
    String[] aFunctions = new String[DeviceFunctionsView_RS.getResultSetSize()];
	String[] aFunctions2 = new String[DeviceFunctionsView_RS.getResultSetSize()];
	int x = 0;
	while (DeviceFunctionsView_RS.next()) {
		aFunctions[x] = DeviceFunctionsView_RS.getString("CATEGORY_VALUE1");
		aFunctions2[x] = DeviceFunctionsView_RS.getString("CATEGORY_VALUE2");
		x++;
	} //DeviceFunctions
	int deviceid = 0;
	int driverid = 0;
	String deviceName = "";
	String devFuncName = "";
	int locIDValue = 0;
	String geoValue = "";
	String countryValue = "";
	String cityValue = "";
	String buildingValue = "";
	String floorValue = "";
	String roomValue = "";
	String nameValue = "";
	String status = "";
	String type = "";		
	String access = "";
	String cs = "";
	String vm = "";
	String mvs = "";
	String sap = "";
	String wts = "";
	String ims = "";
	String model = "";
	String faxno = "";
	String webvis = "";
	String webinst = "";
	String prtDefType = "";
	String devFunc = "";
	int devFuncCounter = 0;
	int numDevices = 0;
	int lastdriverid = 0;
	int numdevFound = 0; //number of devices found
	String lastDeviceName = "";  //last dev found
	while (PrtListFloorSearch_RS.next()) {
		if (!PrtListFloorSearch_RS.getString("DEVICE_NAME").equals(lastDeviceName)) {
			numdevFound++;
			lastDeviceName = PrtListFloorSearch_RS.getString("DEVICE_NAME");
		}
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device search"/>
	<meta name="Description" content="Global print website device search results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("modify_device_search_results") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	
	function callEdit(deviceid) {
		var referer = "";
		<% if (!searchName.equals("")) {%>
			referer = "&referer=<%= topageid %>&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName %>";
		<% } else if (topageid.equals("1023")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>";
		<% } else if (topageid.equals("1022")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building%>";
		<% } else if (request.getParameter(BehaviorConstants.TOPAGE).equals("1021")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>";
		<% } %>
		var params = "&deviceid="+deviceid+referer;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=1030" + params;
	 } //callEdit
	
	function callDelete(deviceid) {
		var referer = "";
		<% if (!searchName.equals("")) {%>
			referer = "&referer=<%= topageid %>&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName %>";
		<% } else if (topageid.equals("1023")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>";
		<% } else if (topageid.equals("1022")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building%>";
		<% } else if (request.getParameter(BehaviorConstants.TOPAGE).equals("1021")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>";
		<% } %>
		var params = "&deviceid="+deviceid+referer;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=1031" + params;
	} //callDelete
	
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','deviceid','');
        createHiddenInput('logactionid','date','');
        createPostForm('delForm','delDeviceForm','delDeviceForm','ibm-column-form','<%= prtgateway %>');
     });
	
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= statichtmldir %>/ServiceRequests.html"><%= messages.getString("service_requests") %></a></li>
				<li><a href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("macdel_requests") %></a></li>
				<li><a href="<%= commonprocess %>?to_page_id=1020"><%= messages.getString("device_modify_request") %></a></li>
			</ul>
			<h1><%= messages.getString("modify_device_search_results") %></h1>
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
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
					<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display search results for devices">
						<caption><em><%= numdevFound %> <%= messages.getString("devices_found") %></em></caption>
						<% if (PrtListFloorSearch_RS.getResultSetSize() > 0) { %>
							<thead>
								<tr>
									<th scope="col" class="ibm-sort"><%= messages.getString("device_name") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("building") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("floor") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("room") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("room_access") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("device_model") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("modify") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("delete") %></th>
								<% for (int j=0; j < aFunctions.length; j++) { %>
									<th scope="col" class="ibm-sort"><%= aFunctions[j] %></th>
								<% } %>
								</tr>
							</thead>
						<tbody>
							<% 	lastDeviceName = "";
								PrtListFloorSearch_RS.first();
								while(PrtListFloorSearch_RS.next()) {
									deviceid = PrtListFloorSearch_RS.getInt("DEVICEID");
									locIDValue = PrtListFloorSearch_RS.getInt("LOCID");
									geoValue = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("GEO"));
									countryValue = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("COUNTRY"));
									cityValue = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("CITY"));
									buildingValue = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("BUILDING_NAME"));
									floorValue = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("FLOOR_NAME"));
									roomValue = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("ROOM"));
									access = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("ROOM_ACCESS"));
									deviceName = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("DEVICE_NAME"));
									type = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("MODEL"));
									devFunc = appTool.nullStringConverter(PrtListFloorSearch_RS.getString("FUNCTION_NAME"));
									
									if (lastDeviceName.equals("")) { %> 
								<tr>
									<td>
										<%= deviceName %>
									</td>
									<td><%= buildingValue %></td>
									<td><%= floorValue %></td>
									<td><%= roomValue %></td>
									<td><%= access %></td>
									<td><%= type %></td>
									<td>
										<a class="ibm-signin-link" href="javascript:callEdit('<%= deviceid %>');"><%= messages.getString("modify") %></a>
									</td>
									<td>
										<a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= deviceid %>')" ><%= messages.getString("delete") %></a>
									</td>
									<% lastDeviceName = deviceName;
										lastdriverid = driverid;
									   //oscounter = 0; %>
								<% } //if last Device
								if (!deviceName.equals(lastDeviceName) && numDevices != 0) { %>
								<% while(devFuncCounter < aFunctions.length) { %>
									<td>
										<% devFuncCounter++; %>
									</td>
								<% } //while counter %>
								</tr>
							<%  devFuncCounter = 0; %>
							<tr>
								<td>
									<%= deviceName %>
								</td>
								<td><%= buildingValue %></td>
								<td><%= floorValue %></td>
								<td><%= roomValue %></td>
								<td><%= access %></td>
								<td><%= type %></td>
								<td>
									<a class="ibm-signin-link" href="javascript:callEdit('<%= deviceid %>');"><%= messages.getString("modify") %></a>
								</td>
								<td>
									<a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= deviceid %>')" ><%= messages.getString("delete") %></a>
								</td>
								<%  lastDeviceName = deviceName; 
							   		lastdriverid = driverid; %>
								<% while(devFuncCounter < aFunctions.length) { %>
								<td>
									<%  if (aFunctions[devFuncCounter] != null && aFunctions[devFuncCounter].equals(devFunc)) { %> 
									<a class='ibm-confirm-link' href="javascript:void(0)"></a>
								<% devFuncCounter++; 
										 break; 
										} else { 
											devFuncCounter++; 
										}  %>
								</td>
								<% } //while loop %>
							<% } else {
									while(devFuncCounter < aFunctions.length) { %>
										<td>
									<%	if (aFunctions[devFuncCounter] != null && aFunctions[devFuncCounter].equals(devFunc)) { %> 
											<a class='ibm-confirm-link' href="javascript:void(0)"></a>
										<% devFuncCounter++; 
										break; 
										} else { 
											devFuncCounter++; 
										} %>
										</td>
								<% } //while devFuncCounter loop %>
							<% } //if drivername is not equal%>
							<% numDevices++;
							 } //while DriverView
							 	while(devFuncCounter < aFunctions.length) { %>
									<td align="center">
										<% devFuncCounter++; %>
									</td>
									<% } //while os counter %>
								</tr>				
						</tbody>
						<% } //if DeviceSearchList %>
					</table>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>