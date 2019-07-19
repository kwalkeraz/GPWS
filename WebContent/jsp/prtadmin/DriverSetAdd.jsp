<%	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	int driversetid = 0;
	String driversetname = "";
	/**
	if (logaction != null) {
		TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSet");
		TableQueryBhvrResultSet DriverSet_RS = DriverSet.getResults();
		while (DriverSet_RS.next()) {
			driversetid = DriverSet_RS.getInt("DRIVER_SETID");
			driversetname = DriverSet_RS.getString("DRIVER_SET_NAME");
		}
	}
	**/
%>
	<%@ include file="metainfo.jsp" %>
		<meta name="Keywords" content="Global Print add driver set"/>
		<meta name="Description" content="Global print website add driver set information page" />
		<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_add") %></title>
		<%@ include file="metainfo2.jsp" %>
				
		<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
		<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
		<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
		<script type="text/javascript" src="/tools/print/js/loadWaitMsg.js"></script>
		<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
		
		<script type="text/javascript">
		dojo.require("dojo.parser");
		 dojo.require("dijit.Tooltip");
		 dojo.require("dijit.form.Form");
		 dojo.require("dijit.form.ValidationTextBox");
		 dojo.require("dijit.form.Button");
		 
		 var addDriverSet = function(event) {
		 	var formName = dijit.byId('DriverSet');
		 	var logaction = dojo.byId('logaction');
		 	var driverset = dijit.byId('driverset').value;
		 	var formValid = formName.validate();
		 	event.preventDefault();
		 	dojo.stopEvent(event);
		 	if (formValid) {
	 			logaction.value = "Driver set " + driverset + " has been added";
				formName.submit();
			} else {
				return false;
			}
		 }; //addDriverSet
		 
		 function cancelForm(){
		 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
		 } //cancelForm
		 
		 dojo.ready(function() {
	     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '351');
	        createHiddenInput('logactionid','logaction','');
	        createpTag();
	        createTextInput('driversetloc','driverset','driverset','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;()-]*$','');
	        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_driver');
	 		createSpan('submit_add_button','ibm-sep');
		 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_driver','cancelForm()');
	     	createPostForm('addDriverSet','DriverSet','DriverSet','ibm-column-form','<%= prtgateway %>');
	     	dijit.byId('driverset').focus();
	     	changeInputTagStyle("400px");
	     	<%if (!logaction.equals("")){ %>
	        dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
	        <% } %>
	     	dojo.connect(dojo.byId('submit_add_driver'), "onclick", addDriverSet);
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
			</ul>
			<h1><%= messages.getString("driver_set_add") %></h1>
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
			<div id='addDriverSet'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
				<label for='driverset'><%= messages.getString("driver_set_name") %>:<span class='ibm-required'>*</span></label> 
				<span><div id='driversetloc'></div></span>
				</div>
				<div class="pClass">
				<div class='ibm-overlay-rule'><hr /></div>
				<div class='ibm-buttons-row'>
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