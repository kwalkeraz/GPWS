<%
	TableQueryBhvr AuthGroupView  = (TableQueryBhvr) request.getAttribute("AuthGroupView");
    TableQueryBhvrResultSet AuthGroupView_RS = AuthGroupView.getResults();
    AppTools tool = new AppTools();
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print website auth type add"/>
	<meta name="Description" content="Global print website auth type add page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("add_auth_type") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=3302";
	 } //cancelForm
	
	 function addAuthGroup(){
	 	var dID = "authgroup";
	 	<%
   		while(AuthGroupView_RS.next()) {
			String categoryvalue1 = tool.nullStringConverter(AuthGroupView_RS.getString("CATEGORY_VALUE1"));
			String categorycode = tool.nullStringConverter(AuthGroupView_RS.getString("CATEGORY_VALUE1")); %>
   			var optionName = "<%= categoryvalue1 %>";
   			var optionValue = "<%= categoryvalue1 %>";
   			addOption(dID,optionName,optionValue);
   		<% } %>
	 } //addAuthGroup
	 
	 function addAuthType(event) {
	 	var formName = getWidgetID("authtypeForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var wName = getWidgetIDValue("authtype");
        var descField = getWidgetID('description');
        var description = descField.get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        descField.set('value',description);
        var authgroup = getSelectValue('authgroup');
        var logactionid = getID('logaction');
        var logaction = "Authorization type " + wName + " has been added";
        logactionid.value = logaction;
        formValid = formName.validate();
        if (authgroup == "None") {
			showReqMsg('<%= messages.getString("please_enter_all_required_fields") %>','authgroup');
			return false;
		}
   		if (formValid) {
			if (description == "") {
				alert('<%= messages.getString("please_enter_all_required_fields") %>');
				descField.focus();
				return false;
			} else {
				formName.submit();
			}
		} else {
			return false;
		}
	}; //addAuthType
	
	function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '3309');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('authtype','authtype','authtype','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 +-]*$','');
        createTextArea('description', 'description', '', '');
        createSelect('authgroup', 'authgroup', '<%= messages.getString("please_select_auth_group") %>', 'None', 'authgroup');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_authtype');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_authtype','cancelForm()');
     	createPostForm('AuthType','authtypeForm','authtypeForm','ibm-column-form','<%= prtgateway %>');
     	addAuthGroup();
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
     	changeCommentStyle('description','250px');
        getWidgetID('authtype').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(getID('authtypeForm'),'onsubmit',function(event){
     		addAuthType(event);
     	});
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=3302"><%= messages.getString("authorization_type_admin") %></a></li>
			</ul>
			<h1><%= messages.getString("add_auth_type") %></h1>
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
			<div id='AuthType'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='authtype'><%= messages.getString("auth_type_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='authtype'></div></span>
				</div>
				<div class="pClass">
					<label for='description'><%= messages.getString("description") %>:<span class='ibm-required'>*</span></label>
					<span><div id='description'></div></span>
				</div>
				<div class="pClass">
					<label for='authgroup'><%= messages.getString("auth_group") %>:<span class='ibm-required'>*</span></label>
					<span><div id='authgroup'></div></span>
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