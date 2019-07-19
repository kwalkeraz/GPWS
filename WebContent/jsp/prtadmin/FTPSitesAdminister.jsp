<%
   TableQueryBhvr SDCView = (TableQueryBhvr) request.getAttribute("SDC");
   TableQueryBhvrResultSet SDCView_RS = SDCView.getResults();
   PrinterTools tool = new PrinterTools();
   String ftpid = tool.nullStringConverter(request.getParameter("ftpid"));
   String nameexists = tool.nullStringConverter(request.getParameter("nameexists"));
   String ftpsite = "";
   String ftpuser = "";
   String sdc = "";
   String ftpemail = "";
   String homedir = "";
   String ftppass = "";
   String confirmftppass = "";
   TableQueryBhvr ftpSites = (TableQueryBhvr) request.getAttribute("ftpSites");
   TableQueryBhvrResultSet ftpSites_RS = ftpSites.getResults(); 
   String logaction = "";
   if (ftpSites_RS.getResultSetSize() > 0 ) {
		while( ftpSites_RS.next() ) { 
			ftpid = String.valueOf(ftpSites_RS.getInt("FTPID"));
			ftpsite = ftpSites_RS.getString("FTP_SITE");
			homedir = tool.nullStringConverter(ftpSites_RS.getString("HOME_DIRECTORY"));
			ftpuser = ftpSites_RS.getString("FTP_USER");
			sdc = ftpSites_RS.getString("FTP_GEO");
			ftppass = tool.DecryptString(ftpSites_RS.getString("FTP_PASS"));
			confirmftppass = tool.DecryptString(ftpSites_RS.getString("FTP_PASS"));
			ftpemail = ftpSites_RS.getString("FTP_CONTACT_EMAIL");
		} //while
	} //if
	if (!nameexists.equals("")) {
		ftpuser = tool.nullStringConverter(request.getParameter("ftpuser"));
		homedir = tool.nullStringConverter(request.getParameter("homedir"));
		sdc = tool.nullStringConverter(request.getParameter("sdc"));
		ftpemail = tool.nullStringConverter(request.getParameter("ftpcontactemail"));
	}
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print administer download repository"/>
	<meta name="Description" content="Global print website administer download repository information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("ftp_site_administration") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
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
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=340";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addSDC(dID){
	 	var selectMenu = dijit.byId(dID);
	 	<%
   		while(SDCView_RS.next()) {
			String currentsdc = SDCView_RS.getString("CATEGORY_VALUE1"); %>
   			var optionName = "<%= currentsdc %>";
   			var optionValue = "<%= currentsdc %>";
   			selectMenu.addOption({value: optionValue, label: optionName });
   		<% } %>
	 } //addSDC
	 
	 function adminFTP() {
	 	var sdc = getSelectValue('sdc');
	 	getID("errorMsg").innerHTML = "";
	 	var formName = getWidgetID('adminFTPForm');
	 	var formValid = formName.validate();
	 	var wName = getWidgetIDValue('ftpsite');
	 	var insertValue = getID('submitvalue');
	 	var logaction = getID('logaction');
	 	//var ftppass = getWidgetIDValue("ftppass");
	 	var ftppass = defaultValue("0",getWidgetIDValue('ftppass'));
	 	//var confirmftppass = getWidgetIDValue("confirmftppass");
	 	var confirmftppass = defaultValue("1",getWidgetIDValue('confirmftppass'));
	 	var ftpid = getIDValue("ftpid");
	 		if (ftpid == "0"){
	 			logaction.value = '<%= messages.getString("ftp_add_success") %>: ' + wName;
	 			insertValue.value = "insert";
	 		} else {
	 			logaction.value = '<%= messages.getString("ftp_update_success") %>: ' + wName;
	 			insertValue.value = "update";
	 		}
	 		if (sdc == "None") {
				showReqMsg('<%= messages.getString("please_select_sdc") %>','sdc');
				return false;
			}
			if (ftppass != confirmftppass) {
				alert('<%= messages.getString("ftp_pass_dont_match") %>');
				return false;
			}
			if (formValid) {
				formName.submit();
				return false;
			} else {
				return false;
			}
	 } //addServer
	 
	 dojo.ready(function() {
	 	if ('<%= ftpid %>' == 0) g_pass_variable = '';
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '346');
        createHiddenInput('logactionid','logaction','','logaction');
        createHiddenInput('logactionid','ftpid','<%= ftpid %>','ftpid');
        createHiddenInput('logactionid','submitvalue','','submitvalue');
        createpTag();
        createTextInput('ftpsiteloc','ftpsite','ftpsite','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _/:.;]*$','<%= ftpsite %>');
        createTextBox('homedirloc','homedir','homedir','128','','<%= homedir %>');
        createTextBox('ftpuserloc','ftpuser','ftpuser','16','','<%= ftpuser %>');
        createPasswordBox('ftppassloc','ftppass','ftppass','64','',g_pass_variable);
        createPasswordBox('confirmftppassloc','confirmftppass','confirmftppass','64','',g_pass_variable);
        secureField(["ftppass_1","confirmftppass_1"]);
        createSelect('sdc', 'sdc', '<%= messages.getString("please_select_sdc") %> ...', 'None', 'sdcloc');
        createTextInput('ftpemailloc','ftpcontactemail','ftpcontactemail','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_email_regexp,'<%= ftpemail %>');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_ftp','adminFTP()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_ftp','cancelForm()');
     	createPostForm('adminFTP','adminFTPForm','adminFTPForm','ibm-column-form','<%= prtgateway %>');
     	addSDC('sdc');
     	autoSelectValue('sdc',"<%= sdc %>");
     	changeInputTagStyle('350px');
     	changeSelectStyle('350px');
     	<%if (nameexists.equals("true")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[] {request.getParameter("ftpsite")}) %>"+"<br /></p>";
        <% } %>
        getWidgetID('ftpsite').focus();
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=340"><%= messages.getString("ftp_site_administration") %></a></li>
			</ul>
			<h1 class="ibm-small"><%= messages.getString("ftp_site_administration") %></h1>
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
			<div id='adminFTP'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<input id="ftppass_1" type="hidden" value="<%= ftppass %>" name="ftppass_1">
				<input id="confirmftppass_1" type="hidden" value = "<%= confirmftppass %>" name="confirmftppass_1">
				<div class="pClass">
					<label for='ftpsite'><%= messages.getString("ftp_site") %>:<span class='ibm-required'>*</span></label>
					<span><div id='ftpsiteloc'></div></span>
				</div>
				<div class="pClass">
					<label for='homedir'><%= messages.getString("home_dir") %>:</label>
					<span><div id='homedirloc'></div></span>
				</div>
				<div class="pClass">
					<label for='ftpuser'><%= messages.getString("ftp_user") %>:</label>
					<span><div id='ftpuserloc'></div></span>
				</div>
				<div class="pClass">
					<label for='ftppass'><%= messages.getString("ftp_pass") %>:</label>
					<span><div id='ftppassloc'></div></span>
				</div>
				<div class="pClass">
					<label for='confirmftppass'><%= messages.getString("ftp_pass_confirm") %>:</label>
					<span><div id='confirmftppassloc'></div></span>
				</div>
				<div class="pClass">
					<label for='sdc'><%= messages.getString("sdc") %>:<span class='ibm-required'>*</span></label>
					<span><div id='sdcloc'></div></span>
				</div>
				<div class="pClass">
					<label for='ftpemail'><%= messages.getString("ftp_contactemail") %>:<span class='ibm-required'>*</span></label>
					<span><div id='ftpemailloc'></div></span>
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