<%
	TableQueryBhvr DriverView  = (TableQueryBhvr) request.getAttribute("DriverView");
    TableQueryBhvrResultSet DriverView_RS = DriverView.getResults();
    AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    
    int driverid = 0;
    String drivername = "";
    String drivermodel = "";
    
    while(DriverView_RS.next()) { 
		driverid = DriverView_RS.getInt("DRIVERID");
		drivername = tool.nullStringConverter(DriverView_RS.getString("DRIVER_NAME"));
		drivermodel = tool.nullStringConverter(DriverView_RS.getString("DRIVER_MODEL"));
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit driver"/>
	<meta name="Description" content="Global print website edit driver information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 var found = false;
	 
	 function reqName(wName){
	 	//console.log('wName is ' + wName);
	 	found = false;
	 	var tagName = 'Model';
	 	var dataTag = 'Driver';
	 	var currentID = '<%=driverid%>';
	 	var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10005&query=driver&driver_model=" + wName;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		 		var dt = response.getElementsByTagName(dataTag);
		   		for (var i = 0; i < tn.length; i++) {
		   			var optionName = tn[i].firstChild.data;
		   			var tagID = dt[i].getAttribute("id");
		   			//console.log('optionName is ' + optionName);
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
	 
	 function editDriver(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('editDriverForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('drivermodel').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "Driver name " + wName + " has been updated";
					formName.submit();
				} else {
					dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("driver_exists") %>'+"</p>";
					dijit.byId('drivermodel').focus();
					return false;
				}
			} //if
			else {
				return false;
			}
	 } //addGeo
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321";
	 } //cancelForm
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '326_Drv');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','driverid','<%= driverid %>');
        createpTag();
        createTextInput('drivername','drivername','drivername','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_driver_regexp,'<%= drivername %>');
        createTextInput('drivermodel','drivermodel','drivermodel','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_driver_model_regexp,'<%= drivermodel %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_driver');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_driver','cancelForm()');
     	createPostForm('editDriver','editDriverForm','editDriverForm','ibm-column-form','<%= prtgateway %>');
     	dijit.byId('drivername').focus();
		changeInputTagStyle("250px");
     	var inputButton1 = dojo.byId("submit_add_driver");
     	var submitButton = { 
     					onClick: function(evt){
     							editDriver(evt);
							} //function
						};
     	dojo.connect(inputButton1, "onclick", submitButton.onClick);
     	<%if (!logaction.equals("")){ %>
        dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321"><%= messages.getString("driver_administration") %></a></li>
			</ul>
			<h1><%= messages.getString("driver_edit") %></h1>
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
			<div id='editDriver'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
				<label for='newdriver'><%= messages.getString("driver_name") %>:<span class='ibm-required'>*</span></label>
				<span><div id='drivername'></div></span>
				</div>
				<div class="pClass">
				<label for='newmodel'><%= messages.getString("driver_model") %>:<span class='ibm-required'>*</span></label>
				<span><div id='drivermodel'></div></span>
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