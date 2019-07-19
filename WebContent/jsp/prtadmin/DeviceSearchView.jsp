<%
   TableQueryBhvr DeviceSearchList  = (TableQueryBhvr) request.getAttribute("DeviceSearchList");
   TableQueryBhvrResultSet DeviceSearchList_RS = DeviceSearchList.getResults();
   TableQueryBhvr DeviceFunctionsView = (TableQueryBhvr) request.getAttribute("DeviceFunctions");
   TableQueryBhvrResultSet DeviceFunctionsView_RS = DeviceFunctionsView.getResults();
   TableQueryBhvr DeviceStatus = (TableQueryBhvr) request.getAttribute("DeviceStatus");
   TableQueryBhvrResultSet DeviceStatus_RS = DeviceStatus.getResults();
   
   String referPage =  request.getParameter(BehaviorConstants.TOPAGE);
    boolean windowOnLoad = false;
    
	Calendar cView = Calendar.getInstance();
	DateTime dateTime = new DateTime();

	//Get the date parts of the current date from the Calendar object
	int month = cView.get(Calendar.MONTH);
	int day = cView.get(Calendar.DATE);
	int year = cView.get(Calendar.YEAR);
	
	Timestamp lastmodified = dateTime.getSQLTimestamp();
    
    //cookies
    AppTools appT = new AppTools();
    String logaction = appT.nullStringConverter(request.getParameter("logaction"));
    Cookie cGeo = new Cookie("globalPrintGeo",appT.nullStringConverter(request.getParameter("geo")));
	Cookie cCountry = new Cookie("globalPrintCountry",appT.nullStringConverter(request.getParameter("country")));
	Cookie cSite = new Cookie("globalPrintSite",appT.nullStringConverter(request.getParameter("city")));
	Cookie cBuilding = new Cookie("globalPrintBuilding",appT.nullStringConverter(request.getParameter("building")));
	Cookie cFloor = new Cookie("globalPrintFloor",appT.nullStringConverter(request.getParameter("floor")));
	Cookie cSearchName = new Cookie("globalPrintSearchName",appT.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME)));
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
	if (appT.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME)) != "") {
		cSearchName.setMaxAge(31449600);
		response.addCookie(cSearchName);
	} //searchbyName
    //end of cookies
    String geo = appT.nullStringConverter(request.getParameter("geo"));
    String country = appT.nullStringConverter(request.getParameter("country"));
    String city = appT.nullStringConverter(request.getParameter("city"));
    String building = appT.nullStringConverter(request.getParameter("building"));
    String floor = appT.nullStringConverter(request.getParameter("floor"));
    String searchName = appT.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
    String topageid = appT.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
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
	while (DeviceSearchList_RS.next()) {
		if (!DeviceSearchList_RS.getString("DEVICE_NAME").equals(lastDeviceName)) {
			numdevFound++;
			lastDeviceName = DeviceSearchList_RS.getString("DEVICE_NAME");
		}
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device search"/>
	<meta name="Description" content="Global print website device search results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_administer") %> </title>
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
			referer = "&referer=<%= topageid %>&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName%>";
		<% } else if (topageid.equals("432")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>";
		<% } else if (topageid.equals("431")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building%>";
		<% } else if (request.getParameter(BehaviorConstants.TOPAGE).equals("430")) {%>
			referer = "&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>";
		
		<% } %>
		var params = "&deviceid="+deviceid+referer;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=283"+params;
	 } //callEdit
	 
	function setFormValues(msg,deviceid,method){
		var day = "<%= day %>";
		var month = "<%= month + 1 %>";
		var year = "<%= year %>";
		var date = day + "/" + month + "/" + year;
		var modified_date = "<%= lastmodified %>";
		(method == "delete") ? topageid = "282_Delete" : topageid = "432_Remove";
		setValue("<%= BehaviorConstants.TOPAGE %>", topageid);
		setValue("deviceid", deviceid);
		setValue("date", date);
		setValue("modified_date", modified_date);
		setValue("logaction", msg);
	} //setFormValues
	
	function DisplayMsg(msg) {
		this.msg = msg;
		this.getMsg = function() {
			return msg;
		};
	} //displayMsg
	
	function DeviceName(name) {
		this.name = name;
		this.getName = function() {
			return name;
		};
	} //DeviceName
	
	var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
	//var deviceName = new DeviceName(name);
	var msg = new DisplayMsg(msg);
	var submitted = true;
	var xhrArgs = {
        	form:  "delDeviceForm",
            handleAs: "text",
            sync: false,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Device may be currently in use</p>";
        			submitted = false;
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg.getMsg() +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
                submitted = false;
            },
        };
	
	function callDelete(devicename, deviceid) {
		var deviceName = new DeviceName(devicename);
		msg = new DisplayMsg("Device " + deviceName.getName() + " has been marked deleted");
		setFormValues(msg.getMsg(),deviceid,"delete");
		var confirmDelete = confirm('<%= messages.getString("device_sure_delete") %> ' + deviceName.getName() + "?");
		if (confirmDelete) {
			var def = dojo.xhrPost(xhrArgs);
			def.then(function(res){
				if (submitted) AddParameter("logaction", msg.getMsg());
			},function(err){
				// Display error message
				alert("An error occurred: " + err);
			});
		} //if yesno
	} //callDelete
	
	function callDestroy(devicename, deviceid) {
		var deviceName = new DeviceName(devicename);
		msg = new DisplayMsg("Device " + deviceName.getName() + " has been permanently deleted");
		setFormValues(msg.getMsg(),deviceid);
		var confirmDelete = confirm('<%= messages.getString("device_sure_remove") %> ' + deviceName.getName() + "?");
		if (confirmDelete) {
			var def = dojo.xhrPost(xhrArgs);
			def.then(function(res){
				if (submitted) AddParameter("logaction", msg.getMsg());
			},function(err){
				// Display error message
				alert("An error occurred: " + err);
			});
		} //if yesno
	} //callDelete
	
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','deviceid','');
        createHiddenInput('logactionid','date','');
        createHiddenInput('logactionid','modified_date','');
        createPostForm('delForm','delDeviceForm','delDeviceForm','ibm-column-form','<%= prtgateway %>');
        <% if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=281"><%= messages.getString("device_search") %></a></li>
			</ul>
			<h1><%= messages.getString("device_administer") %></h1>
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
			<ul>
				<li><%= messages.getString("device_edit_info") %></li>
				<li><%= messages.getString("device_delete_info") %></li>
				<li><%= messages.getString("device_delete_remove") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=280"><%= messages.getString("device_add_page") %></a></li>
				<li>
				<% if (!searchName.equals("")) {%>
					<a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=282_CSV&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName%>&logaction=Downloaded the list of devices"><%= messages.getString("export_link") %></a>
				<% } else if (topageid.equals("432")) {%>
					<a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=432_CSV&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&logaction=Downloaded the list of devices"><%= messages.getString("export_link") %></a>
				<% } else if (topageid.equals("431")) {%>
					<a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=431_CSV&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building%>&logaction=Downloaded the list of devices"><%= messages.getString("export_link") %></a>
				<% } else if (topageid.equals("430")) {%>
					<a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=430_CSV&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>&logaction=Downloaded the list of devices"><%= messages.getString("export_link") %></a>
				<% } %>
				</li>
			</ul>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
					<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display search results for devices">
						<caption><em><%= numdevFound %> <%= messages.getString("devices_found") %></em></caption>
						<% if (DeviceSearchList_RS.getResultSetSize() > 0) { %>
							<thead>
								<tr>
									<th scope="col" class="ibm-sort"><%= messages.getString("device_name") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("delete") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("building") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("floor") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("room") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("room_access") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("device_status") %></th>
									<th scope="col" class="ibm-sort"><%= messages.getString("device_model") %></th>
								<% for (int j=0; j < aFunctions.length; j++) { %>
									<th scope="col" class="ibm-sort"><%= aFunctions[j] %></th>
								<% } %>
								</tr>
							</thead>
						<tbody>
							<% 	lastDeviceName = "";
								DeviceSearchList_RS.first();
								while (DeviceSearchList_RS.next()) {
									deviceid = DeviceSearchList_RS.getInt("DEVICEID");
									locIDValue = DeviceSearchList_RS.getInt("LOCID");
									geoValue = appT.nullStringConverter(DeviceSearchList_RS.getString("GEO"));
									countryValue = appT.nullStringConverter(DeviceSearchList_RS.getString("COUNTRY"));
									cityValue = appT.nullStringConverter(DeviceSearchList_RS.getString("CITY"));
									buildingValue = appT.nullStringConverter(DeviceSearchList_RS.getString("BUILDING_NAME"));
									floorValue = appT.nullStringConverter(DeviceSearchList_RS.getString("FLOOR_NAME").trim());
									roomValue = appT.nullStringConverter(DeviceSearchList_RS.getString("ROOM"));
									access = appT.nullStringConverter(DeviceSearchList_RS.getString("ROOM_ACCESS"));			
									deviceName = appT.nullStringConverter(DeviceSearchList_RS.getString("DEVICE_NAME"));						
									type = appT.nullStringConverter(DeviceSearchList_RS.getString("MODEL"));
									devFunc = appT.nullStringConverter(DeviceSearchList_RS.getString("FUNCTION_NAME"));
									webvis = appT.nullStringConverter(DeviceSearchList_RS.getString("WEB_VISIBLE"));
									webinst = appT.nullStringConverter(DeviceSearchList_RS.getString("INSTALLABLE"));
									status = appT.nullStringConverter(DeviceSearchList_RS.getString("STATUS"));
									DeviceStatus_RS.first();
									if (DeviceStatus_RS.getResultSetSize() > 0 ) {
										while(DeviceStatus_RS.next()) {
											if (status.equals(DeviceStatus_RS.getString("CATEGORY_CODE"))) {
												status = DeviceStatus_RS.getString("CATEGORY_VALUE1");
											} //if equal
										} //while
									} //if >0
									if (lastDeviceName.equals("")) { %> 
								<tr>
									<td>
										<a class="ibm-signin-link" href="javascript:callEdit('<%= deviceid %>');"><%= deviceName %></a>
									</td>
									<td>
										<% if (status.toUpperCase().equals("DELETED")) { %>
											<a id='delserver' class="ibm-delete-link" href="javascript:callDestroy('<%= deviceName %>','<%= deviceid %>')" ><%= messages.getString("remove") %></a>
										<% } else { %>
											<a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= deviceName %>','<%= deviceid %>')" ><%= messages.getString("delete") %></a>
										<% } %>
									</td>
									<td><%= buildingValue %></td>
									<td><%= floorValue %></td>
									<td><%= roomValue %></td>
									<td><%= access %></td>
									<td><%= status %></td>
									<td><%= type %></td>
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
									<a class="ibm-signin-link" href="javascript:callEdit('<%= deviceid %>');"><%= deviceName %></a>
								</td>
								<td>
									<% if (status.toUpperCase().equals("DELETED")) { %>
										<a id='delserver' class="ibm-delete-link" href="javascript:callDestroy('<%= deviceName %>','<%= deviceid %>')" ><%= messages.getString("remove") %></a>
									<% } else { %>
										<a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= deviceName %>','<%= deviceid %>')" ><%= messages.getString("delete") %></a>
									<% } %>
								</td>
								<td><%= buildingValue %></td>
								<td><%= floorValue %></td>
								<td><%= roomValue %></td>
								<td><%= access %></td>
								<td><%= status %></td>
								<td><%= type %></td>
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