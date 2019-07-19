<%
   TableQueryBhvr VendorByIDView  = (TableQueryBhvr) request.getAttribute("VendorByIDView");
   TableQueryBhvrResultSet VendorByIDView_RS = VendorByIDView.getResults();
   String vendorname = "";
	int vendorid = 0;
	while (VendorByIDView_RS.next()) {
		vendorid = VendorByIDView_RS.getInt("VENDORID"); 
		vendorname = VendorByIDView_RS.getString("VENDOR_NAME"); 
	}
%>
	<%@ include file="metainfo.jsp" %>
		<meta name="Keywords" content="Global Print edit vendor set"/>
		<meta name="Description" content="Global print website edit vendor information page" />
		<title><%= messages.getString("global_print_title") %> | <%= messages.getString("vendor_edit") %></title>
		<%@ include file="metainfo2.jsp" %>
				
		<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
		
		<script type="text/javascript">
		dojo.require("dojo.parser");
		 dojo.require("dijit.Tooltip");
		 dojo.require("dijit.form.Form");
		 dojo.require("dijit.form.ValidationTextBox");
		 dojo.require("dijit.form.Button");
		 
		 function addVendor() {
		 	var formName = getWidgetID('Vendor');
		 	var logaction = getID('logaction');
		 	var vendor = getWidgetIDValue('vendor');
		 	var formValid = formName.validate();
		 	if (formValid) {
	 			logaction.value = "Vendor " + vendor + " has been updated";
				formName.submit();
			} else {
				return false;
			}
		 }; //addDriverSet
		 
		 function cancelForm(){
		 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=452";
		 } //cancelForm
		 
		 dojo.ready(function() {
	     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '454');
	        createHiddenInput('logactionid','logaction','');
	        createHiddenInput('logactionid','vendorid','<%= vendorid %>');
	        createpTag();
	        createTextInput('vendorloc','vendor','vendor','32',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;()-]*$','<%= vendorname %>');
	        //createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_vendor');
	 		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_vendor','addVendor()');
	 		createSpan('submit_add_button','ibm-sep');
		 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_vendor','cancelForm()');
	     	createPostForm('addVendor','Vendor','Vendor','ibm-column-form','<%= prtgateway %>');
	     	dijit.byId('vendor').focus();
	     	changeInputTagStyle("400px");
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=452"><%= messages.getString("vendor_administer") %></a></li>
			</ul>
			<h1><%= messages.getString("vendor_edit") %></h1>
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
			<div id='addVendor'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
				<label for='vendor'><%= messages.getString("vendor_name") %>:<span class='ibm-required'>*</span></label> 
				<span><div id='vendorloc'></div></span>
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