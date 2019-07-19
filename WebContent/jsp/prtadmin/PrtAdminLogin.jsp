<%	
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String error = tool.nullStringConverter(request.getParameter("e"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print login page"/>
	<meta name="Description" content="Global print website administration login page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("GPWS_administration") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function callSubmit(event) {
	 	var formName = getWidgetID('GPWSAdminLoginForm');
	 	var formValid = formName.validate();
	 	//var wName = getWidgetIDValue('UserId');
	 	setWidgetIDValue('UserId',getWidgetIDValue('UserId').toLowerCase());
	 	var passwd = getWidgetIDValue('password');
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (passwd == "") {
	 				alert('<%= messages.getString("please_enter_all_required_fields") %>');
	 				getWidgetID('password').focus();
	 				return false;
	 			} else {
	 				getID('GPWSAdminLoginForm').submit();
	 			}
			} else {
				return false;
			}
	 } //callSubmit
	 
	 function cancelForm(){
	 	var formName = getWidgetID('GPWSAdminLoginForm');
	 	formName.reset();
	 } //cancelForm
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','next_page_id', '2');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('userid','UserId','UserId','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;@/-]*$','');
        createPasswordBox('password','Password','password','256','','');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_login');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
     	createPostForm('GPWSAdminLogin','GPWSAdminLoginForm','GPWSAdminLoginForm','ibm-column-form','<%= printeradmin %>');
     	changeInputTagStyle("250px");
		<%if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        <%if (error.equals("sto")){ %>
    		getID("errorMsg").innerHTML = "<p id='errorMsgLabel'><a class='ibm-error-link'></a><%= messages.getString("session_timed_out_info") %><br /></p>";
    		dojo.addClass("errorMsgLabel","ibm-error");
    	<% } %>
        var login = getWidgetID('UserId');
        login.focus();
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('GPWSAdminLoginForm'), 'onsubmit', function(event) {
		 	callSubmit(event);
		 });
	 });
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("GPWS_administration") %></h1>
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
				<%= messages.getString("printer_admin_IIP_note") %>.  <%= messages.getString("required_info") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='GPWSAdminLogin'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<!--  KW Message -->
				<div>
				<p>Please review the Print@IBM privacy notice (<a href="http://ibm.biz/print-privacy">http://ibm.biz/print-privacy</a>) before logging in.
				</p>
				</div>
				<!-- KW End Message -->
				<div class="pClass">
				<label for='UserId'><%= messages.getString("login_id") %>:<span class='ibm-required'>*</span></label>
				<span><div id='userid'></div></span>
				</div>
				<div class="pClass">
				<label for='password'><%= messages.getString("password") %>:<span class='ibm-required'>*</span></label>
				<span><div id='password'></div></span>
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