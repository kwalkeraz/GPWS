<%
   TableQueryBhvr PrtViewCitySearchAll  = (TableQueryBhvr) request.getAttribute("PrtViewCitySearchAll");
   TableQueryBhvrResultSet PrtViewCitySearchAll_RS = PrtViewCitySearchAll.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr DeviceFunctionsView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("DeviceFunctionsView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet DeviceFunctionsView_RS = DeviceFunctionsView.getResults();
   AppTools appTool = new AppTools();
   Cookie cGeo = new Cookie("globalPrintGeo",appTool.nullStringConverter(request.getParameter("geo")));
	Cookie cCountry = new Cookie("globalPrintCountry",appTool.nullStringConverter(request.getParameter("country")));
	Cookie cSite = new Cookie("globalPrintSite",appTool.nullStringConverter(request.getParameter("city")));
	Cookie cBuilding = new Cookie("globalPrintBuilding",appTool.nullStringConverter(request.getParameter("building")));
	Cookie cFloor = new Cookie("globalPrintFloor",appTool.nullStringConverter(request.getParameter("floor")));
	cGeo.setMaxAge(63072000);
	cCountry.setMaxAge(63072000);
	cSite.setMaxAge(63072000);
	cBuilding.setMaxAge(63072000);
	cFloor.setMaxAge(63072000);
	response.addCookie(cGeo);
	response.addCookie(cCountry);
	response.addCookie(cSite);
	response.addCookie(cBuilding);
	response.addCookie(cFloor);
	
	String[] aFunctions = new String[DeviceFunctionsView_RS.getResultSetSize()];
	String[] aFunctions2 = new String[DeviceFunctionsView_RS.getResultSetSize()];
	int x = 0;
	while (DeviceFunctionsView_RS.next()) {
		aFunctions[x] = DeviceFunctionsView_RS.getString("CATEGORY_VALUE1");
		aFunctions2[x] = DeviceFunctionsView_RS.getString("CATEGORY_VALUE2");
		x++;
	} //while
	
	String geo = appTool.nullStringConverter(request.getParameter("geo"));
	String country = appTool.nullStringConverter(request.getParameter("country"));
	String site = appTool.nullStringConverter(request.getParameter("city"));
	String building = appTool.nullStringConverter(request.getParameter("building"));
	String floor = appTool.nullStringConverter(request.getParameter("floor"));
	String referer = appTool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
	String searchvalue = appTool.nullStringConverter(request.getParameter("searchvalue"));
	int deviceID = 0;
	int locIDValue = 0;
	String geoValue = "";
	String countryValue = "";
	String cityValue = "";
	String buildingValue = "";
	String floorValue = "";
	String roomValue = "";
	String nameValue = "";
	String type = "";	
	String color = "";	
	String access = "";
	String faxnumber = "";
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
	boolean bFlag = true;
	int driverid = 0;
	String deviceName = "";
	//String drivermodel = "";
	String devFuncName = "";
	//String osabbr = "";
	String lastDeviceName = "";
	int lastdriverid = 0;
	int osid = 0;
	int iGray = 0;
	int devFuncCounter = 0;
	int count = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device search"/>
	<meta name="Description" content="Global print website device search results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_search_results") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function callView(deviceid) {
	 	var params = "";
	 	<% if (referer.equals("620")) { %>
		params = "&deviceid="+deviceid+"&referer=<%= referer %>&searchvalue=<%= searchvalue %>";
		<% } else { %>
		params = "&deviceid="+deviceid+"&referer=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= site %>&building=<%= building %>&floor=<%= floor %>";
		<% } %>
		document.location.href="<%= printeruser %>?<%=  BehaviorConstants.TOPAGE %>=55" + params;
	 } //callView
	
	 dojo.ready(function() {
     	createPostForm('delForm','delDeviceForm','delDeviceForm','ibm-column-form','<%= printeruser %>');
     });
	
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead4.jsp" %>
	<header class="hero hero--small" style="background-image: url(&quot;https://w3-03.ibm.com/tools/print/images/bee_background.png&quot;);"><h1 class="hero__title">Global Print | Search Results</h1> <!----> 
    <div role="presentation" class="hero__contrast-layer" style="opacity: 0.3;">
    </div></header>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" >
		<div >
			<ul id="ibm-navigation-trail">
				<!-- <li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=60"><%= messages.getString("browse_devices") %></a></li> -->
				<li><a href="<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=60">Locate Printers</a></li>
			</ul>
			<!-- <h1><%= messages.getString("device_search_results") %></h1> -->
		</div>
	</div>
	
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			<p>
				<%= messages.getString("click_device_view_info") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
					<%  int numDev = 0;
						if (PrtViewCitySearchAll_RS.getResultSetSize() > 0) { 
							String sLast = "";
							while (PrtViewCitySearchAll_RS.next()) {
								String sDevice = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("DEVICE_NAME"));
								if (!sDevice.equals(sLast)) {
									numDev++;
								}
								sLast = sDevice;
							}
							PrtViewCitySearchAll_RS.first(); 
						} //if %>
					<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display search results for devices">
						<% if (referer.equals("600")) { %>
							<caption><%= numDev %>&nbsp;<%= messages.getStringArgs("devices_found_bld_site_country", new String[] {building, site, country}) %></caption>
						<% } else if (referer.equals("610")){ %>						
							<caption><%= numDev %>&nbsp;<%= messages.getStringArgs("devices_found_floor_bld_site_country", new String[] {floor, building, site, country}) %></caption>
						<% } else if (referer.equals("620")){ %>						
							<caption><%= numDev %> <%= messages.getString("devices_found") %></caption>
						<% } %>
						<% if (PrtViewCitySearchAll_RS.getResultSetSize() > 0) { %>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("name") %></th>
									<th scope="col"><%= messages.getString("site") %></th>
									<th scope="col"><%= messages.getString("building") %></th>
									<th scope="col"><%= messages.getString("floor") %></th>
									<th scope="col"><%= messages.getString("room") %></th>
									<th scope="col"><%= messages.getString("room_access") %></th>
									<th scope="col"><%= messages.getString("model") %></th>
									<th scope="col">Color</th>
									<th scope="col"><%= messages.getString("fax_number") %></th>
								<% for (int j=0; j < aFunctions.length; j++) { %>
									<th scope="col"><%= aFunctions[j] %></th>
								<% } %>
								</tr>
							</thead>
						<tbody>
							<% 	lastDeviceName = "";
								PrtViewCitySearchAll_RS.first();
								while (PrtViewCitySearchAll_RS.next()) {
									deviceID = PrtViewCitySearchAll_RS.getInt("DEVICEID");
									locIDValue = PrtViewCitySearchAll_RS.getInt("LOCID");
									geoValue = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("GEO"));
									countryValue = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("COUNTRY"));
									cityValue = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("CITY"));
									buildingValue = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("BUILDING_NAME"));
									floorValue = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("FLOOR_NAME").trim());
									roomValue = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("ROOM"));
									access = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("ROOM_ACCESS"));			
									deviceName = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("DEVICE_NAME"));						
									type = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("MODEL"));
									color = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("COLOR"));
									
									if (!color.equals("Y")) {
							    		String color2 = type.toUpperCase();
								 		//String substring = "Color".toUpperCase();
								 		//color = (color2.indexOf(substring) > -1) ? "Y" : "";
								 		if (color2.indexOf("Color".toUpperCase()) > -1) {
								 			color = "Y";
								 		} else if (color2.indexOf("Colour".toUpperCase()) > -1) {
								 			color = "Y";
								 		} else {
								 			color = "";
								 		}
								 	} else {
								 		color = "Y";
								 	}
								 	
									faxnumber = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("FAX_NUMBER"));
									webvis = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("WEB_VISIBLE"));
									webinst = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("INSTALLABLE"));
									devFunc = appTool.nullStringConverter(PrtViewCitySearchAll_RS.getString("FUNCTION_NAME"));
								    if (lastDeviceName.equals("")) { %> 
							<tr>
								<td><a href="javascript:callView('<%= deviceID %>')"><%= deviceName %></a></td>
									<td><%= cityValue %></td>
									<td><%= buildingValue %></td>
									<td><%= floorValue %></td>
									<td><%= roomValue %></td>
									<td><%= access %></td>
									<td><%= type %></td>
									<td><%= color %></td>
									<td><%= faxnumber %></td>
									<% lastDeviceName = deviceName;
										lastdriverid = driverid; %>
							<% 	} 
								if (!deviceName.equals(lastDeviceName) && count != 0) { %>
									<% while(devFuncCounter < aFunctions.length) { %>
										<td>
											<% devFuncCounter++; %>
										</td>
									<% } //while Loop %>
									</tr>
									<% devFuncCounter = 0; %>
									<tr>
										<td><a href="javascript:callView('<%= deviceID %>')"><%= deviceName %></a></td>
										<td><%= cityValue %></td>
										<td><%= buildingValue %></td>
										<td><%= floorValue %></td>
										<td><%= roomValue %></td>
										<td><%= access %></td>
										<td><%= type %></td>
										<td><%= color %></td>
										<td><%= faxnumber %></td>
									<% lastDeviceName = deviceName; 
									lastdriverid = driverid; 
									while(devFuncCounter < aFunctions.length) { %>
										<td align="center">
										<% if (aFunctions[devFuncCounter] != null && aFunctions[devFuncCounter].equals(devFunc)) { %> 
											<%= aFunctions[devFuncCounter] %>
											<% devFuncCounter++; 
										 	break; 
										} else { 
											devFuncCounter++; 
										} %>
										</td>
									<% } //while loop %>
							<% } else {
									while(devFuncCounter < aFunctions.length) { %>
										<td align="center">
										<%	if (aFunctions[devFuncCounter] != null && aFunctions[devFuncCounter].equals(devFunc)) { %> 
											<%= aFunctions[devFuncCounter] %>
											<% devFuncCounter++; 
											break; 
										} else { %>
											<% devFuncCounter++; 
										} %>
										</td>
									<% } //while loop %>
							<% } //if drivername is not equal%>
						<% count++;
						 } //while DriverView
						 	while(devFuncCounter < aFunctions.length) { %>
						 		<td>
									<% devFuncCounter++; %>
								</td>
							<% } //while devFuncCounter %>
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
<%@ include file="bottominfo2.jsp" %>