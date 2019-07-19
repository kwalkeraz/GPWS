<%
	TableQueryBhvr AuthActionView  = (TableQueryBhvr) request.getAttribute("AuthActionView");
    TableQueryBhvrResultSet AuthActionView_RS = AuthActionView.getResults(); 
	AppTools tool = new AppTools();
	String sAuthAction = "";
	String sDescription = "";
	int authactionid = 0;
	while (AuthActionView_RS.next()) {
		authactionid = AuthActionView_RS.getInt("AUTH_ACTIONID");
		sAuthAction = tool.nullStringConverter(AuthActionView_RS.getString("ACTION_TYPE"));
		sDescription = tool.nullStringConverter(AuthActionView_RS.getString("DESCRIPTION"));
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print website auth action edit"/>
	<meta name="Description" content="Global print website auth action edit page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("edit_auth_action") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
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
	 
	 function editAuthAction(event) {
	 	var formName = dijit.byId("authactionForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var wName = dijit.byId("authaction").get('value');
        var descField = dijit.byId('description');
        var description = descField.get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        descField.set('value',description);
        var logactionid = dojo.byId('logaction');
        var logaction = "Authorization action " + wName + " has been updated";
        logactionid.value = logaction;
        formValid = formName.validate();
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
	}; //
	
	function callDelete(authName) {
		var formName = dijit.byId("authactionForm");
		YesNo = confirm("<%= messages.getString("delete_auth_action_check") %> " + authName + "?");
		if (YesNo == true) {
			dojo.byId('<%= BehaviorConstants.TOPAGE %>').value = "3307";
			var logactionid = dojo.byId('logaction');
       		var logaction = "Authorization action " + authName + " has been deleted";
       		logactionid.value = logaction;
			formName.submit();
		} else {
			return false;
		}
	} //callDelete
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '3306');
     	createHiddenInput('logactionid','authactionid','<%= authactionid %>');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('authaction','authaction','authaction','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9]*$','<%= sAuthAction %>');
        createTextArea('description', 'description', '', '<%= sDescription %>');
        createSubmitButton('submit_edit_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_edit_authaction');
 		createSpan('submit_edit_button','ibm-sep');
	 	createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("delete") %>','ibm-btn-cancel-sec','del_edit_authaction','callDelete(\'<%= sAuthAction %>\')');
	 	createSpan('submit_edit_button','ibm-sep');
	 	createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_edit_authaction','cancelForm()');
     	createPostForm('AuthAction','authactionForm','authactionForm','ibm-column-form','<%= prtgateway %>');
     	changeInputTagStyle("250px");
     	dojo.style("description", {
          "width": "250px"
		});
        dijit.byId('authaction').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('authactionForm'),'onsubmit',function(event){
     		editAuthAction(event);
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
			<h1><%= messages.getString("edit_auth_action") %></h1>
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
			<div id='AuthAction'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='authaction'><%= messages.getString("authorization_action") %>:<span class='ibm-required'>*</span></label>
					<span><div id='authaction'></div></span>
				</div>
				<div class="pClass">
					<label for='description'><%= messages.getString("description") %>:<span class='ibm-required'>*</span></label>
					<span><div id='description'></div></span>
				</div>
				<div class='ibm-overlay-rule'><hr /></div>
				<div class='ibm-buttons-row'>
					<div class='ibm-buttons-row' align="right">
					<div class="pClass">
						<div id='submit_edit_button'></div>
					</div>
				</div>		
				</div>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>