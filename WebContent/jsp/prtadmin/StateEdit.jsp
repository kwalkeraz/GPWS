<%
	TableQueryBhvr StateTableView  = (TableQueryBhvr) request.getAttribute("StateTableView");
	TableQueryBhvrResultSet StateTableView_RS = StateTableView.getResults();
	AppTools tool = new AppTools();
	int StateID = 0;
  	int countryid = 0;
  	String state = tool.nullStringConverter(request.getParameter("state"));
  	String country = tool.nullStringConverter(request.getParameter("country"));
  	String geo = tool.nullStringConverter(request.getParameter("geo"));
  	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	StateTableView_RS.next();
		StateID	= StateTableView_RS.getInt("STATEID");
		state = tool.nullStringConverter(StateTableView_RS.getString("STATE"));
		countryid = StateTableView_RS.getInt("COUNTRYID");
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit state"/>
	<meta name="Description" content="Global print website edit state information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("state_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
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
	 	var dataTag = 'Geography';
	 	var currentID = '<%=StateID%>';
	 	var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=state&geo=" + geo + "&country=" + country;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		   		for (var i = 0; i < tn.length; i++) {
		   			var optionName = tn[i].firstChild.data;
		   			var dt = response.getElementsByTagName(dataTag);
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
	 
	 function addState(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addStateForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('state').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "State " + wName + " has been updated";
					formName.submit();
				} else {
					dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("location_already_exists") %>'+"</p>";
					dijit.byId('state').focus();
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
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '186');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','geo','<%=geo%>');
        createHiddenInput('logactionid','countryid','<%=countryid%>');
        createHiddenInput('logactionid','country','<%=country%>');
        createHiddenInput('logactionid','stateid','<%=StateID%>');
        createpTag();
        createTextInput('state','state','state','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_state_regexp,'<%= state %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_state');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_state','cancelForm()');
     	createPostForm('addState','addStateForm','addStateForm','ibm-column-form','<%= prtgateway %>');
     	dijit.byId('state').focus();
     	var inputButton1 = dojo.byId("submit_add_state");
     	var submitButton = { 
     					onClick: function(evt){
     							addState(evt);
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
			<li><a href="javascript: void(0);" onClick="cancelForm();"><%= messages.getString("location_administration") %></a></li>
		</ul>
		<h1><%= messages.getString("state_edit") %></h1>
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
			<div id='addState'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='state'><%= messages.getString("state") %>:<span class='ibm-required'>*</span></label>
					<span><div id='state'></div></span>
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