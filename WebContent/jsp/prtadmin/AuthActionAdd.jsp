<%	
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print website auth action add"/>
	<meta name="Description" content="Global print website auth action add page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("add_auth_action") %></title>
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
	 
	 function addAuthAction(event) {
	 	var formName = dijit.byId("authactionForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var wName = dijit.byId("authaction").get('value');
        var descField = dijit.byId('description');
        var description = descField.get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        descField.set('value',description);
        var logactionid = dojo.byId('logaction');
        var logaction = "Authorization action " + wName + " has been added";
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
	}; //addCategory
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '3304');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('authaction','authaction','authaction','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9]*$','');
        createTextArea('description', 'description', '', '');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_authaction');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_authaction','cancelForm()');
     	createPostForm('AuthAction','authactionForm','authactionForm','ibm-column-form','<%= prtgateway %>');
     	changeInputTagStyle("250px");
     	dojo.style("description", {
          "width": "250px"
		});
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('authaction').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('authactionForm'),'onsubmit',function(event){
     		addAuthAction(event);
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
			<h1><%= messages.getString("add_auth_action") %></h1>
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
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>