<%
   TableQueryBhvr LocationStatus  = (TableQueryBhvr) request.getAttribute("LocationStatus");
   TableQueryBhvrResultSet LocationStatus_RS = LocationStatus.getResults();
   AppTools appT = new AppTools();
	String geo = appT.nullStringConverter(request.getParameter("geo"));
	String country = appT.nullStringConverter(request.getParameter("country"));
	String state = appT.nullStringConverter(request.getParameter("state"));
	String logaction = appT.nullStringConverter(request.getParameter("logaction"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print add city"/>
	<meta name="Description" content="Global print website add city information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("city_add") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
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
	 	var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=city&geo=" + geo + "&country=" + country + "&state=" + state;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		   		for (var i = 0; i < tn.length; i++) {
		   			var optionName = tn[i].firstChild.data;
		   			//console.log('optionName is ' + optionName);
		   			if (optionName == wName) {
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
	 
	 function addSite(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addSiteForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('site').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "Site " + wName + " has been added";
					formName.submit();
				} else {
					dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("location_already_exists") %>'+"</p>";
					dijit.byId('site').focus();
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
	 	var param = "&geo=" + geo + "&country=" + country + "&state=" + state;
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
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '409');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','geo','<%=geo%>');
        createHiddenInput('logactionid','country','<%=country%>');
        createHiddenInput('logactionid','state','<%=state%>');
        createpTag();
        createTextInput('site','city','site','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_city_regexp,'');
        createSelect('status', 'status', '', '', 'statusloc');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_site');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_site','cancelForm()');
     	createPostForm('addSite','addSiteForm','addSiteForm','ibm-column-form','<%= prtgateway %>');
     	addStatus('status');
     	dijit.byId('site').focus();
     	changeSelectStyle('150px');
     	var inputButton1 = dojo.byId("submit_add_site");
     	var submitButton = { 
     					onClick: function(evt){
     							addSite(evt);
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
			<h1><%= messages.getString("city_add") %></h1>
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
			<div id='addSite'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='site'><%= messages.getString("city") %>:<span class='ibm-required'>*</span></label>
					<span><div id='site'></div></span>
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