<%
	com.ibm.aurora.bhvr.TableQueryBhvr TimeZoneView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TimeZoneView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TimeZoneView_RS = TimeZoneView.getResults();

	AppTools appTool = new AppTools();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String error = appTool.nullStringConverter(request.getParameter("error"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print keyop administration"/>
<meta name="Description" content="This page allows an admin to add a keyop to the system." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_admin_page") %> - <%= messages.getString("add") %>&nbsp;<%= messages.getString("admin") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>

<script language="Javascript">

dojo.require("dojo.parser");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.Select");
dojo.require("dojox.validate.web");

function cancelForm() {
	self.location.href = "<%= prtgateway %>?to_page_id=250_KO";
}

function rsgET(response, tagName) {
		var rt = response.getElementsByTagName(tagName)[0].firstChild.data;
		return rt;
} //rsgET

function reqName(sLook) {
	var found = false;
	var syncValue = true;
	var lookupemail = dijit.byId('lookupEmail').get('value');
	dojo.byId("errorMsg").innerHTML = "";
	//var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10015";
	var urlValue = "<%= statichtmldir %>/servlet/api.wss";
	var params = "";
	if (sLook == "lookUpAdmin") {
		//params = "&query=admin&loginid=" + lookupemail;
		params = "/administrator/login/" + lookupemail;
	} else {
		//params = "&query=user&email=" + lookupemail;
		params = "/user/email/" + lookupemail;
	}
	urlValue = urlValue + params;
	dojo.xhrGet({
		url : urlValue,
		handleAs : "xml",
		load : function(response, args) {
				var Auth = "";
		 		var tn = response.getElementsByTagName("Keyop");
				if (sLook == "lookUpAdmin"){ // look up in database
					dojo.byId("errorMsg").innerHTML = "";
					for (var i = 0; i < tn.length; i++) {
						try {
							Auth = tn[i].firstChild.data;
						} catch (e) {
							optionName = "";
							optionValue = "0";
						}
					} //for loop
					if (Auth != "" && Auth != null && (Auth == "Keyop Admin" || Auth == "Keyop Superuser")) {
						dojo.byId("errorMsg").innerHTML = '<a class="ibm-error-link" href="#"></a><%= messages.getString("admin_already_exist") %>';
						dijit.byId('firstname').set('value','');
						dijit.byId('lastname').set('value','');
						dijit.byId('email').set('value','');
						dijit.byId('loginid').set('value','');
					} else {
						if (Auth != "" && Auth != null && Auth == "Keyop") {
							dojo.byId("errorMsg").innerHTML = '<a class="ibm-caution-link" href="#"></a><%= messages.getString("already_keyop_submit_to_update") %>';
						}
						try {
							firstname = fixName(rsgET(response, 'FirstName'));
					   		lastname = rsgET(response, 'LastName');
					   		email = rsgET(response, 'EmailAddress');
					   		loginid = rsgET(response, 'LoginID');
							
						} catch(e) {
							console.log('exception is ' + e);
							firstname = "";
							lastname = "";
							email = "";
							loginid = "";
						}
						if (email == "" || email == null) {
							reqName('lookupBP');
						} else {
							setWidgetIDValue('firstname', firstname);
						   	setWidgetIDValue('lastname', lastname);
						   	setWidgetIDValue('email', email);
						   	setWidgetIDValue('loginid', loginid);
						} //if email
					}
				} else { // look up in bluepages
						var firstname = "";
						var lastname = "";
						var email = "";
						var loginid = "";
						dojo.byId("errorMsg").innerHTML = "";
						try {
							firstname = fixName(rsgET(response, 'FirstName'));
					   		lastname = rsgET(response, 'LastName');
					   		email = rsgET(response, 'EmailAddress');
					   		loginid = rsgET(response, 'LoginID');
						} catch(e) {
							console.log('exception is ' + e);
							firstname = "";
							lastname = "";
							email = "";
							loginid = "";
						}
						if (email == "" || email == null) {
							dojo.byId("errorMsg").innerHTML = '<a class="ibm-error-link" href="#"></a><%= messages.getString("email_not_found") %>';
							setWidgetIDValue('firstname', '');
						   	setWidgetIDValue('lastname', '');
						   	setWidgetIDValue('email', '');
						   	setWidgetIDValue('loginid', '');
						} else {
							setWidgetIDValue('firstname', firstname);
						   	setWidgetIDValue('lastname', lastname);
						   	setWidgetIDValue('email', email);
						   	setWidgetIDValue('loginid', loginid);
						} //if email
				} // if then else
		}, //load function
		preventCache: true,
		sync: syncValue,
		error : function(response, args) {
			console.log("Error getting XML data: " + response + " " + args.xhr.status);
		} //error function
	});
	return found;
} //reqName

dojo.ready(function() {
	createHiddenInput('next_page_id', 'next_page_id','3026');
	createHiddenInput('submitvalue', 'submitvalue','AddAdmin');
	createHiddenInput('userid', 'userid','');
	//createHiddenInput('userexist', 'userexist','<%//= sUserExist %>');
	createpTag();
	createTextInput('lookupEmail','lookupEmail','lookupEmail','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_email_regexp,'');
	createInputButton('lookup_button','ibm-submit','<%= messages.getString("lookup") %>','ibm-btn-arrow-pri','lookup_button','reqName("lookUpAdmin")');
	createTextInput('firstname','firstname','firstname','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'');
	createTextInput('lastname','lastname','lastname','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'');
	createTextInput('email','email','email','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_email_regexp,'');
	createTextInput('loginid','loginid','loginid','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_email_regexp,'');
	createTextBox('pager','pager','pager','64','','');
	createSelect('timezone', 'timezone', '<%= messages.getString("please_select_time_zone") %>', 'None', 'timezone');
	createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','addKeyop()');
	createSpan('submit_add_button','ibm-sep');
	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
	createPostForm('theForm', 'theForm', 'theForm', 'ibm-column-form', '<%= keyops %>');
	dijit.byId("lookupEmail").focus();
 	changeInputTagStyle("200px");
 	changeSelectStyle('300px');
    addTimeZones();
    
    <%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
	<% } %>
	
	<%if (!error.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-error-link'></a>"+"<%= error %>"+"<br /></p>";
	<% } %>
});

function addTimeZones() {
	<%	
		while(TimeZoneView_RS.next()) {  %>
			addOption('timezone','<%= appTool.nullStringConverter(TimeZoneView_RS.getString("CATEGORY_VALUE1")) %>','<%= appTool.nullStringConverter(TimeZoneView_RS.getString("CATEGORY_VALUE1")) %>');
<%		} %>
}

function addKeyop() {
	validForm = dijit.byId("theForm").validate();
	if (validForm) {
		dijit.byId("theForm").submit();
	} else {
		return false;
	}
}

function next() {
	if (dijit.byId("loginid").value == "") {
		alert('<%= messages.getString("required_info") %>');
		dijit.byId("loginid").focus();
		return false;
	} else if(!dojox.validate.isEmailAddress(dijit.byId("loginid").value)) {
		alert('<%= messages.getString("invalid_email") %>');
		dijit.byId("loginid").focus();
		return false;
	}
	dijit.byId("theForm").submit();
}
</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("Keyop_Admin_Home") %></a></li> 
			</ul>
			<h1><%= messages.getString("keyop_admin_page") %> - <%= messages.getString("add_admin") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<!-- All the main body stuff goes here -->
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<p><%= messages.getString("fill_out_info_keyop") %> <%= messages.getString("required_info") %><br /></p>
					<div id='response'></div>
					<div id='errorMsg'></div>
					<div id="theForm">
						<div id="next_page_id"></div>
						<div id="submitvalue"></div>
						<div id="userid"></div>
						<div class="pClass">
							<label for="lookupEmail"><%= messages.getString("email") %>:<span class="ibm-required">*</span></label>
							<span><div id="lookupEmail"></div></span>
						</div>
						<div class='ibm-buttons-row'>
							<div class="pClass">
							<span><div id='lookup_button'></div></span>
							</div>
						</div>
						<div class="ibm-alternate-rule"><hr /></div>
						<div class="pClass"><label for="firstname"><%= messages.getString("first_name") %>:<span class="ibm-required">*</span></label><span><div id="firstname"></div></span></div>
						<div class="pClass">
							<label for="lastname"><%= messages.getString("last_name") %>:<span class="ibm-required">*</span></label> 
							<span><div id="lastname"></div></span>
						</div>
						<div class="pClass">
							<label for="email"><%= messages.getString("email") %>:<span class="ibm-required">*</span></label>
							<span><div id="email"></div></span>
						</div>
						<div class="pClass">
							<label for="loginid"><%= messages.getString("loginid") %>:<span class="ibm-required">*</span></label>
							<span><div id="loginid"></div></span>
						</div>
						<div class="pClass">
							<label for="pager"><%= messages.getString("pager_number") %>:</label>
							<span><div id="pager"></div></span>
						</div>
						<div class="pClass">
							<label for="timezone"><%= messages.getString("time_zone_keyop_located") %>:</label>
							<span><div id="timezone"></div></span>
						</div>
						<div class="ibm-alternate-rule"><hr /></div>
						<div class='ibm-buttons-row'>
							<div class="pClass">
							<span>
							<div id='submit_add_button'></div>
							</span>
							</div>
						</div>				
					</div>
    			</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>