<%
    TableQueryBhvr miscTableView  = (TableQueryBhvr) request.getAttribute("misc");
	TableQueryBhvrResultSet misc_RS = miscTableView.getResults();
	PrinterTools tool = new PrinterTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	misc_RS.next();
   	int settingid = misc_RS.getInt("APP_SETTINGSID");
	String clsid = tool.nullStringConverter(misc_RS.getString("CLSID"));
	String clsid64bit = tool.nullStringConverter(misc_RS.getString("CLSID_64BIT"));
	String pluginurl = tool.nullStringConverter(misc_RS.getString("PLUGIN_URL"));
	String pluginspage = tool.nullStringConverter(misc_RS.getString("PLUGINS_PAGE"));
	String successurl = tool.nullStringConverter(misc_RS.getString("SUCCESS_URL"));
	String errorurl = tool.nullStringConverter(misc_RS.getString("ERROR_URL"));
	String pluginver = tool.nullStringConverter(misc_RS.getString("PLUGIN_VERSION"));
	String widgetver = tool.nullStringConverter(misc_RS.getString("WIDGET_VERSION"));
	String authmethod = tool.nullStringConverter(misc_RS.getString("AUTH_METHOD"));
	String encryptpasswd = tool.nullStringConverter(misc_RS.getString("ENCRYPT_PASSWORD"));
	String ils = tool.nullStringConverter(misc_RS.getString("ILS"));
	String clientuserid = tool.nullStringConverter(misc_RS.getString("CLIENT_USER_ID"));
	String clientpasswd = tool.nullStringConverter(misc_RS.getString("CLIENT_PASSWORD"));

	encryptpasswd = tool.DecryptString(encryptpasswd);
	clientpasswd = tool.DecryptString(clientpasswd);
	String clientdumpdir = tool.nullStringConverter(misc_RS.getString("CLIENT_DUMP_DIR"));
	clsid  = clsid.replace('"','!');
	clsid64bit  = clsid64bit.replace('"','!');
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print administer application settings information"/>
	<meta name="Description" content="Global print website edit application settings information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("app_settings") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function showPass(){
	 	var pass = getWidgetIDValue('clientpasswd');
	 	alert("Password: " + pass);
	 } //showPass
	 
	 function addMisc() {
	 	var ils = getSelectValue('ils');
	 	var formName = getWidgetID('MiscForm');
	 	var formValid = formName.validate();
	 	var logaction = getID("logaction");
	 	logaction.value = "Application settings have been updated";
	 	if (ils == "None") {
			showReqMsg('<%= messages.getString("device_select_yes") %>','ils');
			return false;
		}
		if (formValid) {
			formName.submit();
		} else {
			return false;
		}
	 } //addServer
	 
	 function cancelForm(){
	 	document.location.href="/tools/print/servlet/prtgateway.wss?to_page_id=250";
	 } //cancelForm
	 
	 function addILS(){
	 	var selectMenu = getWidgetID('ils');
	 	selectMenu.addOption({value: 'Y', label: 'Yes' });
	 	selectMenu.addOption({value: 'N', label: 'No' });
	 } //addILS
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '512');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','settingid','<%= settingid %>');
        createpTag();
        createTextInput('clsidloc','clsid','clsid','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= clsid %>');
        createTextInput('clsid64bitloc','clsid64bit','clsid64bit','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= clsid64bit %>');
        createTextInput('pluginurlloc','pluginurl','pluginurl','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= pluginurl %>');
        createTextInput('pluginspageloc','pluginspage','pluginspage','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= pluginspage %>');
        createTextInput('successurlloc','successurl','successurl','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= successurl %>');
        createTextInput('errorurlloc','errorurl','errorurl','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= errorurl %>');
        createTextInput('pluginverloc','pluginver','pluginver','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= pluginver %>');
        createTextInput('widgetverloc','widgetver','widgetver','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= widgetver %>');
        createTextInput('authmethodloc','authmethod','authmethod','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,!#=|:/<>?&+-]*$','<%= authmethod %>');
        createPasswordBox('encryptpasswdloc','encryptpasswd','encryptpasswd','32','','<%= encryptpasswd %>');
        createSelect('ils', 'ils', '<%= messages.getString("device_select_yes") %>...', 'None', 'ilsloc');
        addILS();
        autoSelectValue('ils',"<%= ils %>");
        createTextBox('clientuseridloc','clientuserid','clientuserid','32','','<%= clientuserid %>');
        createPasswordBox('clientpasswdloc','clientpasswd','clientpasswd','32','','<%= clientpasswd %>');
        createTextBox('clientdumpdirloc','clientdumpdir','clientdumpdir','255','','<%= clientdumpdir %>');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_site','addMisc()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_site','cancelForm()');
     	createPostForm('Misc','MiscForm','MiscForm','ibm-column-form','<%= prtgateway %>');
     	getWidgetID('clsid').focus();
     	changeInputTagStyle('350px');
     	changeSelectStyle('200px');
     	<%if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
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
			<h1 class="ibm-small"><%= messages.getString("app_settings") %></h1>
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
			<div id='Misc'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='clsid'><%= messages.getString("clsid") %>:<span class='ibm-required'>*</span></label>
					<span><div id='clsidloc'></div></span>
				</div>
				<div class="pClass">
					<label for='clsid64bit'><%= messages.getString("clsid64bit") %>:<span class='ibm-required'>*</span></label>
					<span><div id='clsid64bitloc'></div></span>
				</div>
				<div class="pClass">
					<label for='pluginurl'><%= messages.getString("pluginurl") %>:<span class='ibm-required'>*</span></label>
					<span><div id='pluginurlloc'></div></span>
				</div>
				<div class="pClass">
					<label for='pluginspage'><%= messages.getString("pluginspage") %>:<span class='ibm-required'>*</span></label>
					<span><div id='pluginspageloc'></div></span>
				</div>
				<div class="pClass">
					<label for='successurl'><%= messages.getString("successurl") %>:<span class='ibm-required'>*</span></label>
					<span><div id='successurlloc'></div></span>
				</div>
				<div class="pClass">
					<label for='errorurl'><%= messages.getString("errorurl") %>:<span class='ibm-required'>*</span></label>
					<span><div id='errorurlloc'></div></span>
				</div>
				<div class="pClass">
					<label for='pluginver'><%= messages.getString("pluginver") %>:<span class='ibm-required'>*</span></label>
					<span><div id='pluginverloc'></div></span>
				</div>
				<div class="pClass">
					<label for='widgetver'><%= messages.getString("widget_version") %>:<span class='ibm-required'>*</span></label>
					<span><div id='widgetverloc'></div></span>
				</div>
				<div class="pClass">
					<label for='authmethod'><%= messages.getString("auth_method") %>:<span class='ibm-required'>*</span></label>
					<span><div id='authmethodloc'></div></span>
				</div>
				<div class="pClass">
					<label for='encryptpasswd'><%= messages.getString("encrypt_password") %>:</label>
					<span><div id='encryptpasswdloc'></div></span>
				</div>
				<div class="pClass">
					<label for='ils'><%= messages.getString("ils") %>:<span class='ibm-required'>*</span></label>
					<span><div id='ilsloc'></div></span>
				</div>
				<div class="pClass">
					<label for='clientuserid'><%= messages.getString("client_userid") %>:</label>
					<span><div id='clientuseridloc'></div></span>
				</div>
				<div class="pClass">
					<label for='clientpasswd'><span><a class="ibm-popup-link" href="#" onClick="javascript:showPass();"></a></span><%= messages.getString("client_password") %>:</label>
					<span><div id='clientpasswdloc'></div></span>
				</div>
				<div class="pClass">
					<label for='clientdumpdir'><%= messages.getString("client_dump_dir") %>:</label>
					<span><div id='clientdumpdirloc'></div></span>
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