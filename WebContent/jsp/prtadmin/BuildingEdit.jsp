<%
	TableQueryBhvr BuildingTableView  = (TableQueryBhvr) request.getAttribute("BuildingTableView");
	TableQueryBhvrResultSet BuildingTableView_RS = BuildingTableView.getResults();
	TableQueryBhvr LocationStatus  = (TableQueryBhvr) request.getAttribute("LocationStatus");
    TableQueryBhvrResultSet LocationStatus_RS = LocationStatus.getResults();
	TableQueryBhvr SDCView  = (TableQueryBhvr) request.getAttribute("SDC");
    TableQueryBhvrResultSet SDCView_RS = SDCView.getResults();
    AppTools tool = new AppTools();
	String building	= tool.nullStringConverter(request.getParameter("building"));
	String city	= tool.nullStringConverter(request.getParameter("city"));
	String state = tool.nullStringConverter(request.getParameter("state"));
	String country = tool.nullStringConverter(request.getParameter("country"));
	String geo = tool.nullStringConverter(request.getParameter("geo"));
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	int BuildingID = 0;
	int cityid = 0;
	String status = "";
	String Tier = "";
	String SDC = "";
	String Sitecode = "";
	String Workloccode = "";
	BuildingTableView_RS.next();
		cityid = BuildingTableView_RS.getInt("CITYID");
		BuildingID	= BuildingTableView_RS.getInt("BUILDINGID");
		status = tool.nullStringConverter(BuildingTableView_RS.getString("BUILDING_STATUS"));
		Tier = tool.nullStringConverter(BuildingTableView_RS.getString("TIER"));
		SDC = tool.nullStringConverter(BuildingTableView_RS.getString("SDC"));
		Sitecode = tool.nullStringConverter(BuildingTableView_RS.getString("SITE_CODE"));
		Workloccode = tool.nullStringConverter(BuildingTableView_RS.getString("WORK_LOC_CODE"));
	
	if (Tier.equals("") || Tier.equals("null") ) {
		Tier = "0";
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit building"/>
	<meta name="Description" content="Global print website edit building information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("building_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 var found = false;
	 
	 function reqName(wName){
	 	//console.log('wName is ' + wName);
	 	found = false;
	 	var tagName = 'Name';
	 	var geo = "<%= geo %>";
	 	var country = "<%= country %>";
	 	var state = "<%= state %>";
	 	var city = "<%= city %>";
	 	var currentID = '<%=BuildingID%>';
	 	var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=building&geo=" + geo + "&country=" + country + "&state=" + state + "&city=" + city;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		 		var dt = response.getElementsByTagName(dataTag);
		   		for (var i = 0; i < tn.length; i++) {
		   			var optionName = tn[i].firstChild.data;
		   			var tagID = dt[i].getAttribute("id");
		   			//console.log('tagID is ' + tagID);
		   			if (optionName == wName && currentID != tagID) {
		   				found = true;
		   				break;
		   			}
		   		} //for loop
		   	}, //load function
		   	preventCache: true,
		   	sync: true,
		   	error : function(response, args) {
		   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
		   	} //error function
		});
		return found;
	 } //reqName
	 
	 function addBuilding(event) {
	 	var sdc = getSelectValue('sdc');
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addBuildingForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('building').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (sdc == "None") {
				showReqMsg('<%= messages.getString("please_select_sdc") %>','sdc');
				return false;
			} 
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "Building " + wName + " has been updated";
					formName.submit();
				} else {
					getID("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("location_already_exists") %>'+"</p>";
					getWidgetID('building').focus();
					return false;
				}
			} //if
			else {
				return false;
			}
	 } //addGeo
	 
	 function cancelForm(){
	 	var geo = "<%= geo %>";
	 	var country = "<%= country %>";
	 	var state = "<%= state %>";
	 	var city = "<%= city %>";
	 	var building = "<%= building %>";
	 	var param = "&geo=" + geo + "&country=" + country + "&state=" + state + "&city=" + city + "&building=" + building;
		document.location.href="/tools/print/servlet/prtgateway.wss?to_page_id=261_Select" + param;
	 } //cancelForm
	 
	 function onChangeCall(wName){
	 	return false;
	 } //onChange
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = dojo.byId(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addStatus(dID){
	 	var selectMenu = dijit.byId(dID);
	 	selectMenu.removeOption(dijit.byId(dID).getOptions());
	 	<%
   		while(LocationStatus_RS.next()) {
				String categoryvalue1 = LocationStatus_RS.getString("CATEGORY_VALUE1");
				String categorycode = LocationStatus_RS.getString("CATEGORY_CODE"); %>
   			var optionName = "<%= categoryvalue1 %>";
   			var optionValue = "<%= categoryvalue1 %>";
   			selectMenu.addOption({value: optionValue, label: optionName });
   		<% } %>
	 } //addStatus
	 
	 function addSDC(dID){
	 	var selectMenu = dijit.byId(dID);
	 	<%
   		while(SDCView_RS.next()) {
			String sdc = SDCView_RS.getString("CATEGORY_VALUE1"); %>
   			var optionName = "<%= sdc %>";
   			var optionValue = "<%= sdc %>";
   			selectMenu.addOption({value: optionValue, label: optionName });
   		<% } %>
	 } //addSDC
	 
	 function addTier(dID){
	 	var selectMenu = dijit.byId(dID);
	 	var optionName = "";
   		var optionValue = 0;
   		for (var x = 1; x < 5; x++) {
   			optionName = "Tier " + x;
   			optionValue = x+'';
   			selectMenu.addOption({value: optionValue, label: optionName });
   		} //for loop
	 } //addTier
	 
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '206');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','geo','<%=geo%>');
        createHiddenInput('logactionid','country','<%=country%>');
        createHiddenInput('logactionid','state','<%=state%>');
        createHiddenInput('logactionid','city','<%=city%>');
        createHiddenInput('logactionid','cityid','<%=cityid%>');
        createHiddenInput('logactionid','buildingid','<%=BuildingID%>');
        createpTag();
        createTextInput('building','building','building','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_building_regexp,'<%=building%>');
        createSelect('status', 'status', '', '', 'statusloc');
        createTextInput('sitecode','sitecode','sitecode','3',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','\\w{0,3}','<%=Sitecode%>');
        createSelect('tier', 'tier', 'None', '0', 'tierloc');
        createSelect('sdc', 'sdc', '<%= messages.getString("please_select_sdc") %>', 'None', 'sdcloc');
        createTextInput('wlcode','workloc','wlcode','5',false,'','','','\\w{0,5}','<%=Workloccode%>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_building');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_building','cancelForm()');
     	createPostForm('addBuilding','addBuildingForm','addBuildingForm','ibm-column-form','<%= prtgateway %>');
     	addStatus('status');
     	addSDC('sdc');
     	addTier('tier');
     	autoSelectValue('status','<%=status%>');
     	autoSelectValue('tier','<%=Tier%>');
     	console.log("Tier is " + dijit.byId('tier').get('value'));
     	autoSelectValue('sdc','<%=SDC%>');
     	dijit.byId('building').focus();
     	changeSelectStyle('200px');
     	var inputButton1 = dojo.byId("submit_add_building");
     	var submitButton = { 
     					onClick: function(evt){
     							addBuilding(evt);
							} //function
						};
     	dojo.connect(inputButton1, "onclick", submitButton.onClick);
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
				<li><a href="javascript:void(0);" onClick="cancelForm();"><%= messages.getString("location_administration") %></a></li>
			</ul>
			<h1><%= messages.getString("building_edit") %></h1>
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
				<%= messages.getString("required_info") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='addBuilding'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='building'><%= messages.getString("building") %>:<span class='ibm-required'>*</span></label>
					<span><div id='building'></div></span>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:<span class='ibm-required'>*</span></label>
					<span><div id='statusloc'></div></span>
				</div>
				<div class="pClass">
					<label for='sitecode'><%= messages.getString("site_code") %>:<span class='ibm-required'>*</span></label>
					<span><div id='sitecode'></div></span>
				</div>
				<div class="pClass">
					<label for='tier'><%= messages.getString("tier") %>:</label>
					<span><div id='tierloc'></div></span>
				</div>
				<div class="pClass">
					<label for='sdc'><%= messages.getString("sdc") %>:<span class='ibm-required'>*</span></label>
					<span><div id='sdcloc'></div></span>
				</div>
				<div class="pClass">
					<label for='wlcode'><%= messages.getString("work_location_code") %>:</label>
					<span><div id='wlcode'></div></span>
				</div>
				<div class='ibm-overlay-rule'><hr /></div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='submit_add_button'></div>
					</span>
					</div>
				</div>
			</div>
			
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>