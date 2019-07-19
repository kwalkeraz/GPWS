<%	
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
%>

<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print sql command"/>
	<meta name="Description" content="Global print website provide sql command page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("sql_command") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
	<script type="text/javascript" src="/tools/print/js/createSelect.js"></script>
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createTextArea.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function submitSQL() {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('SQLForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('SqlCommand').get('value').trim();
	 	var logaction = dojo.byId('logaction');
	 		if (wName != "") {
	 			logaction.value = "SQL command: " + wName + " - has been executed";
	 			logaction.value = logaction.value.replace(/'/g, "\''");
				formName.submit();
			} else {
				alert('<%= messages.getString("please_enter_all_required_fields") %>');
				dijit.byId('SqlCommand').focus();
				return false;
			}
	 } //addServer
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '710');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextArea('SqlCommand', 'SqlCommand', '', '');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_sql','submitSQL()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_sql','cancelForm()');
     	createPostForm('SQL','SQLForm','SQLForm','ibm-column-form','<%= prtgateway %>');
     	dojo.style("SqlCommand", {
          "width": "350px",
          "height": "70px"
		});
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('SqlCommand').focus();
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
			<h1><%= messages.getString("sql_command") %></h1>
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
			<div id='SQL'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='SqlCommand'><%= messages.getString("sql") %>:<span class='ibm-required'>*</span></label>
					<span><div id='SqlCommand'></div></span>
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