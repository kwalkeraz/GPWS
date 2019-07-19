<%
	TableQueryBhvr PrtFloorTableView  = (TableQueryBhvr) request.getAttribute("FloorTableView");
	TableQueryBhvrResultSet PrtFloorTableView_RS = PrtFloorTableView.getResults();
	TableQueryBhvr LocationStatus  = (TableQueryBhvr) request.getAttribute("LocationStatus");
    TableQueryBhvrResultSet LocationStatus_RS = LocationStatus.getResults();
    AppTools tool = new AppTools();
	int locid = 0;
  	int buildingid = 0;
  	String floor = "";
  	String status = "";
  	String building = tool.nullStringConverter(request.getParameter("building"));
  	String city = tool.nullStringConverter(request.getParameter("city"));
  	String state = tool.nullStringConverter(request.getParameter("state"));
  	String country = tool.nullStringConverter(request.getParameter("country"));
  	String geo = tool.nullStringConverter(request.getParameter("geo"));
  	floor = request.getParameter("floor");
  	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	while (PrtFloorTableView_RS.next()) {
	   	locid = PrtFloorTableView_RS.getInt("LOCID");
	   	buildingid = PrtFloorTableView_RS.getInt("BUILDINGID");
		floor = tool.nullStringConverter(PrtFloorTableView_RS.getString("FLOOR_NAME"));
		status = tool.nullStringConverter(PrtFloorTableView_RS.getString("FLOOR_STATUS"));
	} //while
	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit floor"/>
	<meta name="Description" content="Global print website edit floor information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("floor_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
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
	 	var building = "<%= building %>";
	 	var currentID = '<%=locid%>';
	 	var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=floor&geo=" + geo + "&country=" + country + "&state=" + state + "&city=" + city + "&building=" + building;
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
	 
	 function addFloor(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addFloorForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('floor').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "Floor " + wName + " has been updated";
					formName.submit();
				} else {
					dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("location_already_exists") %>'+"</p>";
					dijit.byId('floor').focus();
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
	 	var floor = "<%= floor %>";
	 	var param = "&geo=" + geo + "&country=" + country + "&state=" + state + "&city=" + city + "&building=" + building + "&floor=" + floor;
		document.location.href="/tools/print/servlet/prtgateway.wss?to_page_id=261_Select" + param;
	 } //cancelForm
	 
	 function onChangeCall(wName){
	 	return false;
	 } //onChange
	 
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
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '216');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','geo','<%=geo%>');
        createHiddenInput('logactionid','country','<%=country%>');
        createHiddenInput('logactionid','state','<%=state%>');
        createHiddenInput('logactionid','city','<%=city%>');
        createHiddenInput('logactionid','building','<%=building%>');
        createHiddenInput('logactionid','locid','<%=locid%>');
        createpTag();
        createTextInput('floor','floor','floor','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_floor_regexp,'<%= floor %>');
        createSelect('status', 'status', '', '', 'statusloc');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_floor');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_floor','cancelForm()');
     	createPostForm('addFloor','addFloorForm','addFloorForm','ibm-column-form','<%= prtgateway %>');
     	addStatus('status');
     	autoSelectValue('status','<%=status%>');
     	dijit.byId('floor').focus();
     	changeSelectStyle('200px');
     	var inputButton1 = dojo.byId("submit_add_floor");
     	var submitButton = { 
     					onClick: function(evt){
     							addFloor(evt);
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
			<h1><%= messages.getString("floor_edit") %></h1>
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
			<div id='addFloor'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='floor'><%= messages.getString("floor") %>:<span class='ibm-required'>*</span></label>
					<span><div id='floor'></div></span>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:<span class='ibm-required'>*</span></label>
					<span><div id='statusloc'></div></span>
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