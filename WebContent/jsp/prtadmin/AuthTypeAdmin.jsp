<%
    TableQueryBhvr AuthTypeView  = (TableQueryBhvr) request.getAttribute("AuthTypeView");
    TableQueryBhvrResultSet AuthTypeView_RS = AuthTypeView.getResults();
    
    TableQueryBhvr AuthActionsTypeView  = (TableQueryBhvr) request.getAttribute("AuthActionsTypeView");
    TableQueryBhvrResultSet AuthActionsTypeView_RS = AuthActionsTypeView.getResults();
    
    TableQueryBhvr AuthActionsNoTypeView  = (TableQueryBhvr) request.getAttribute("AuthActionsNoTypeView");
    TableQueryBhvrResultSet AuthActionsNoTypeView_RS = AuthActionsNoTypeView.getResults();
    
    TableQueryBhvr AuthGroupView  = (TableQueryBhvr) request.getAttribute("AuthGroupView");
    TableQueryBhvrResultSet AuthGroupView_RS = AuthGroupView.getResults();
     
    AppTools tool = new AppTools();
    String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String sAuthType = "";
	String sDescription = "";
	String sAuthGroup = "";
	int authtypeid = 0;
	while (AuthTypeView_RS.next()) {
		authtypeid = AuthTypeView_RS.getInt("AUTH_TYPEID");
		sAuthType = tool.nullStringConverter(AuthTypeView_RS.getString("AUTH_NAME"));
		sDescription = tool.nullStringConverter(AuthTypeView_RS.getString("DESCRIPTION"));
		sAuthGroup = tool.nullStringConverter(AuthTypeView_RS.getString("AUTH_GROUP"));
	}
%>

<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print website auth type admin"/>
	<meta name="Description" content="Global print website auth type admin page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("authorization_type_admin") %></title>
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
	 dojo.require("dijit.form.MultiSelect");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=3302";
	 } //cancelForm
	 
	 function callAdd() {
	 	var selectMenu = dijit.byId('availauthactions');
	 	var options = selectMenu.get('value');
	 	dojo.byId('submitvalue').value = "Add";
	 	var logactionid = dojo.byId('logaction');
	 	logactionid.value = "Authorization action for authorization type <%= sAuthType %> has been added";
	 	var msg = logactionid.value;
		if (options != "") {
			if (submitForm('authtypeForm',msg)) {
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			alert('<%= messages.getString("at_least_one_action") %>');
			selectMenu.focus();
			return false;
		}
	 } //callAdd
	 
	 function callRemove() {
	 	var selectMenu = dijit.byId('authactions');
	 	var options = selectMenu.get('value');
	 	dojo.byId('submitvalue').value = "Remove";
	 	var logactionid = dojo.byId('logaction');
	 	logactionid.value = "Authorization action for authorization type <%= sAuthType %> has been deleted";
	 	var msg = logactionid.value;
		if (options != "") {
			if (submitForm('authtypeForm',msg)) {
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			alert('<%= messages.getString("at_least_one_action") %>');
			selectMenu.focus();
			return false;
		}
	 } //callRemove
	 
	 function submitForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Authorization action already exists.  Please use a different action.'+"</p>";
	   				submitted = false;
	   			} else if (data.indexOf("Unknown") > -1) {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'There was an error in the request'+"</p>";
	   				submitted = false;
	   			} else {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           	submitted = false;
	           	console.log(error);
	               dojo.byId("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           },
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
	 
	 function addAvailAuthActions(){
	 	var dID = "availauthactions";
	 	<%  while(AuthActionsNoTypeView_RS.next()) {
				String authtype = tool.nullStringConverter(AuthActionsNoTypeView_RS.getString("ACTION_TYPE"));
				int sauthid = AuthActionsNoTypeView_RS.getInt("AUTH_ACTIONID"); %>
	   			var optionName = "<%= authtype %>";
	   			var optionValue = "<%= sauthid %>";
	   			addMultiOption(dID, optionName, optionValue);
   		<% } //while%>
	 } //addAvailAuthActions
	 
	 function addAuthActions(){
	 	var dID = "authactions";
	 	<% 	while(AuthActionsTypeView_RS.next()) {
				String authtype = tool.nullStringConverter(AuthActionsTypeView_RS.getString("ACTION_TYPE"));
				int sauthid = AuthActionsTypeView_RS.getInt("AUTH_ACTIONID"); %>
	   			var optionName = "<%= authtype %>";
	   			var optionValue = "<%= sauthid %>";
	   			addMultiOption(dID, optionName, optionValue);
   		<% } //while%>
	 } //addAuthActions
	 
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
	 
	 function editAuthType(event) {
	 	var formName = getWidgetID("authtypeForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var wName = getWidgetIDValue("authtype");
        var descField = getWidgetID('description');
        var description = descField.get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        descField.set('value',description);
        var authgroup = getSelectValue('authgroup');
        var logactionid = getID('logaction');
        var logaction = "Authorization type " + wName + " has been updated";
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
				dojo.byId('<%= BehaviorConstants.TOPAGE %>').value = "3310";
				formName.submit();
			}
		} else {
			return false;
		}
	}; //editAuthType
	
	function callDelete(authtype) {
		YesNo = confirm('<%= messages.getString("delete_auth_type") %> ' + authtype +'?');
		if (YesNo == true) {
			dojo.byId('<%= BehaviorConstants.TOPAGE %>').value = "3311";
	 		var logactionid = dojo.byId('logaction');
	 		logactionid.value = "Authorization type " + authtype + " has been deleted";
			dojo.byId('authtypeForm').submit();
		} else {
			return false;
		}
	} //callDelete
	
	function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	} //showReqMsg
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '3301');
     	createHiddenInput('logactionid','authtypeid','<%= authtypeid %>');
     	createHiddenInput('logactionid','submitvalue','');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('authtype','authtype','authtype','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 +-]*$','<%= sAuthType %>');
        createTextArea('description', 'description', '', '<%= sDescription %>');
        createSelect('authgroup', 'authgroup', '<%= messages.getString("please_select_auth_group") %>', 'None', 'authgroup');
        createSubmitButton('submit_edit_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_edit_authtype');
 		createSpan('submit_edit_button','ibm-sep');
	 	createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("delete") %>','ibm-btn-cancel-sec','del_edit_authtype','callDelete(\'<%= sAuthType %>\')');
 		createSpan('submit_edit_button','ibm-sep');
	 	createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_edit_authtype','cancelForm()');
     	createMultiSelect('authactions','authactions');
     	createMultiSelect('availauthactions','availauthactions');
     	createInputButton('authbuttons','ibm-cancel','< <%= messages.getString("add") %>','ibm-btn-cancel-sec','add_authtype','callAdd()');
 		createSpan('authbuttons','ibm-sep');
	 	createInputButton('authbuttons','ibm-cancel','<%= messages.getString("remove") %> >','ibm-btn-cancel-sec','remove_authtype','callRemove()');
     	createPostForm('AuthType','authtypeForm','authtypeForm','ibm-column-form','<%= prtgateway %>');
     	addAuthGroup();
     	addAvailAuthActions();
     	addAuthActions();
     	autoSelectValue('authgroup','<%= sAuthGroup %>');
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
     	dojo.style("description", {
          "width": "250px"
		});
		<% if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('authtype').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('authtypeForm'),'onsubmit',function(event){
     		editAuthType(event);
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
			<h1 class="ibm-small"><%= messages.getString("authorization_type_admin") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
	<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<p>
				<%= messages.getString("required_info") %>
			</p>
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
				<div class='ibm-buttons-row' align="right">
					<div class="pClass">
						<div id='submit_edit_button'></div>
					</div>
				</div>	
				
				<div class='ibm-alternate-rule'><hr /></div>	
				<div class="ibm-columns">
					<div class="ibm-col-6-2">
						<label for='description'><%= messages.getString("current_auth_actions") %>:</label>
						<span><div id='authactions'></div></span>
					</div>
					<div class="ibm-col-6-2">
						<br /><br /><br />
						<span><div id='authbuttons'></div></span>
					</div>
					<div class="ibm-col-6-2">
						<label for='description'><%= messages.getString("available_auth_actions") %>:</label>
						<span><div id='availauthactions'></div></span>
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