<%
   TableQueryBhvr UserAdmin = (TableQueryBhvr) request.getAttribute("Admin");
   TableQueryBhvrResultSet UserAdmin_RS = UserAdmin.getResults();
   TableQueryBhvr AuthTypes = (TableQueryBhvr) request.getAttribute("AuthTypes");
   TableQueryBhvrResultSet AuthTypes_RS = AuthTypes.getResults();
   TableQueryBhvr AuthGroups = (TableQueryBhvr) request.getAttribute("AuthGroups");
   TableQueryBhvrResultSet AuthGroups_RS = AuthGroups.getResults();
   TableQueryBhvr TimeZoneView  = (TableQueryBhvr) request.getAttribute("TimeZoneView");
   TableQueryBhvrResultSet TimeZoneView_RS = TimeZoneView.getResults();
   TableQueryBhvr VendorView  = (TableQueryBhvr) request.getAttribute("VendorView");
   TableQueryBhvrResultSet VendorView_RS = VendorView.getResults();
   TableQueryBhvr AuthMethod  = (TableQueryBhvr) request.getAttribute("AuthMethod");
   TableQueryBhvrResultSet AuthMethod_RS = AuthMethod.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   String loginexists = request.getParameter("loginexists");
   boolean isExternal = PrinterConstants.isExternal;
   int userid = 0;
   String sUserID = tool.nullStringConverter(request.getParameter("userid"));
   if ((!sUserID.equals("0"))) {
   		userid = Integer.parseInt(sUserID);
   	}
   String firstname = tool.nullStringConverter(request.getParameter("firstname"));
   String lastname = tool.nullStringConverter(request.getParameter("lastname"));
   String fullname = "";
   String email = tool.nullStringConverter(request.getParameter("email"));
   String loginid = "";
   String timezone = tool.nullStringConverter(request.getParameter("timezone"));
   String pager = tool.nullStringConverter(request.getParameter("pager"));
   String password = "";
   String officestatus = tool.nullStringConverter(request.getParameter("officestatus"));
   String authgroup = "";
   String authname = "";
   int userauthtypeid = 0;
   int authtypeid = 0;
   int backupid = 0;
   int vendorid = 0;
   
   if (request.getParameter("backupid") != null) {
   	backupid = Integer.parseInt(request.getParameter("backupid"));
   }
   int iGray = 0;
   UserAdmin_RS.first();
	UserAdmin_RS = UserAdmin.getResults();
	if (UserAdmin_RS.getResultSetSize() > 0 ) {
		while (UserAdmin_RS.next()) {
			firstname = UserAdmin_RS.getString("FIRST_NAME");
			lastname = UserAdmin_RS.getString("LAST_NAME");
			fullname = lastname + ", " + firstname;
			email = UserAdmin_RS.getString("EMAIL");
			loginid = UserAdmin_RS.getString("LOGINID");
			password = tool.nullStringConverter(UserAdmin_RS.getString("PASSWORD"));
			//password = UserAdmin_RS.getString("PASSWORD");
			//password = tool.DecryptString(password);
			timezone = UserAdmin_RS.getString("TIME_ZONE");
			pager = UserAdmin_RS.getString("PAGER");
			backupid = UserAdmin_RS.getInt("BACKUPID");
			vendorid = UserAdmin_RS.getInt("VENDORID");
			officestatus = UserAdmin_RS.getString("OFFICE_STATUS");
			authgroup = UserAdmin_RS.getString("AUTH_GROUP");
			authname = UserAdmin_RS.getString("AUTH_NAME");
			userauthtypeid = UserAdmin_RS.getInt("USER_AUTH_TYPEID");
			authtypeid = UserAdmin_RS.getInt("AUTH_TYPEID");
		} //while
	} //if
	
	String authmethod = "";
	while (AuthMethod_RS.next()) {
		authmethod = AuthMethod_RS.getString("AUTH_METHOD");
	} //while AuthMethod
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print GPWS Administrator"/>
	<meta name="Description" content="Global print website add/modify an administrator" />
	<title><%= messages.getString("title") %> | <% if (userid == 0 ) { %><%= messages.getString("admin_add_info") %><%} else {%><%= messages.getString("admin_edit_info") %><% } %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>t/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function rsgET(response, tagName) {
		var rt = response.getElementsByTagName(tagName)[0].firstChild.data;
		return rt;
	 } //rsgET
	 
	 function reqName(sLook){
	 	var dID = 'backupid';
	 	var found = false;
	 	var syncValue = true;
	 	var tagName = 'FullName';
	 	var dataTag = 'Administrator';
	 	var optionName = "";
	 	var optionValue = "0";
	 	var wName = dijit.byId('loginid').get('value');
	 	var submitValue = dojo.byId('submitvalue').value;
	 	var userid =  "<%= userid %>";
	 	dojo.byId("errorMsg").innerHTML = "";
	 	//var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10015";
	 	var urlValue = "<%= statichtmldir %>/servlet/api.wss";
	 	var params = "";
	 	if (sLook == "addBackups" || sLook == "lookUpLogin") {
	 		//params = "&query=admin&type=all";
	 		params = "/administrator/type/all";
	 	} else {
	 		var lookupemail = dijit.byId('lookupEmail').get('value');
	 		//params = "&query=user&email=" + lookupemail;
	 		//urlValue = "<%= statichtmldir %>/servlet/api.wss";
	 		params = "/user/email/" + lookupemail;
	 	}
	 	if (sLook == "addBackups") {
	 		//params = "&query=admin&type=all";
	 		params = "/administrator/type/all";
	 		syncValue = false;
	 	}
	 	urlValue = urlValue + params;	 	
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 			var sValue = "";
			 		var selectedValue = "<%= backupid %>";
			 		var tn = response.getElementsByTagName(tagName);
		    		var dt = response.getElementsByTagName(dataTag);
		 			var selectMenu = dijit.byId(dID);
		 			if (sLook == "addBackups") {
				 		for (var i = 0; i < tn.length; i++) {
			      			try {
					   			optionName = tn[i].firstChild.data;
			      				optionValue = dt[i].getAttribute("id");
			      			} catch (e) {
			      				optionName = "";
			      				optionValue = "0";
			      				console.log("Error adding backups: " + e);
			      			}
			      			selectMenu.addOption({value: optionValue, label: optionName });
			      			if (selectedValue == optionValue) {
			      				sValue = optionValue;
			      			}
			      		} //for loop
			      		//console.log("sValue to autoselect is: "+ sValue + " with ID: " + dID);
			      		selectMenu.removeOption('<%= userid %>');
			      		autoSelectValue(dID,sValue);
		      		} else if (sLook == "lookUpLogin" && submitValue != "update"){
		      			for (var i = 0; i < tn.length; i++) {
				   			try {
					   			optionName = response.getElementsByTagName("LoginID")[i].firstChild.data;
					   			//console.log('optionName is ' + optionName);
					   		} catch(e) {
					   			optionName = "";
					   		}
				   			if (optionName == wName) {
				   				found = true;
				   				break;
				   			}
				   		} //for loop
		      		} else {
		      			if (userid == "0") {
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
								dojo.byId("errorMsg").innerHTML = '<p class="ibm-error"><a class="ibm-error-link" href="#"></a><%= messages.getString("email_not_found") %></p>';
							} else {
								setWidgetIDValue('firstname', firstname);
						   		setWidgetIDValue('lastname', lastname);
						   		setWidgetIDValue('email', email);
						   		setWidgetIDValue('loginid', loginid);
						   	} //if email
						} //is submitValue
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
	 
	 function addAdmin() {
	 	//dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addAdminForm');
	 	var formValid = formName.validate();
	 	var loginid = dijit.byId('loginid').get('value');
	 	var lastname = "";
	 	//var logaction = dojo.byId('logaction');
	 	var submitValue = dojo.byId('submitvalue');
	 	<% if (userid == 0) {%>
	 		submitValue.value = "insert";
	 	<% } else { %>
	 		submitValue.value = "update";
	 	<% } %>
	 	if (formValid) {
	 		if (!reqName('lookUpLogin')) {
				<% if (authmethod.toLowerCase().equals("password") || authmethod.toLowerCase().equals("db") || authmethod.toLowerCase().equals("database")) { %>
					if (dijit.byId("userpasswd").get('value') != dijit.byId("confpasswd").get('value')) {
						alert('<%= messages.getString("passwords_do_not_match") %>');
						dijit.byId("confpasswd").set('value','');
						dijit.byId("confpasswd").focus();
						return false;
					}
				<% } %>
				formName.submit();
			} else {
				dojo.byId("errorMsg").innerHTML = "<p class='ibm-error'><a class='ibm-error-link' href='#'></a>"+'<%=  messages.getString("error_id_exists") %>'+"</p>";
				dijit.byId('loginid').focus();
				return false;
			}
		} else {
			return false;
		}
	 } //addAdmin
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=332";
	 } //cancelForm
	 
	 function onChangeCall(wName){
	 	return false;
	 } //onChange
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = dojo.byId(tooltipID);
    	dijit.showTooltip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addTimeZone(){
	 	var dID = "timezone";
	 	var selectMenu = dijit.byId(dID);
	 	<%
   		while(TimeZoneView_RS.next()) {
			String categoryvalue1 = TimeZoneView_RS.getString("CATEGORY_VALUE1");
			String categorycode = TimeZoneView_RS.getString("CATEGORY_CODE"); %>
   			var optionName = "<%= categoryvalue1 %>";
   			var optionValue = "<%= categoryvalue1 %>";
   			selectMenu.addOption({value: optionValue, label: optionName });
   		<% } %>
	 } //addStatus
	 
	 function addOfficeStatus(){
	 	var dID = "officestatus";
	 	var selectMenu = dijit.byId(dID);
	 	selectMenu.removeOption(dijit.byId(dID).getOptions());
	 	selectMenu.addOption({value: 'Y', label: '<%= messages.getString("available") %>' });
	 	selectMenu.addOption({value: 'N', label: '<%= messages.getString("out_of_office") %>' });
	 } //addSDC
	 
	 function addAuth(){
	 	<%  AuthGroups_RS.first();
			AuthGroups_RS = AuthGroups.getResults();
			if (AuthGroups_RS.getResultSetSize() > 0 ) {
			while(AuthGroups_RS.next()) { %>
				var dID = "<%= AuthGroups_RS.getString("AUTH_GROUP") %>Auth";
	 			var selectMenu = dijit.byId(dID);
			<%	AuthTypes_RS.first();
				AuthTypes_RS = AuthTypes.getResults();
				if (AuthTypes_RS.getResultSetSize() > 0 ) {
					while(AuthTypes_RS.next()) { 
						if (AuthGroups_RS.getString("AUTH_GROUP") != null && AuthGroups_RS.getString("AUTH_GROUP").equals(AuthTypes_RS.getString("AUTH_GROUP"))) {%>
							var AuthName = "<%= AuthTypes_RS.getString("AUTH_NAME") %>";
							var AuthID = "<%= AuthTypes_RS.getInt("AUTH_TYPEID") %>";
							selectMenu.addOption({value: AuthID, label: AuthName });
		<%				} //if AuthGroup = AuthType
					} //while AuthTypes
				} //if AuthTypes
			} //while AuthGroups
		} //if AuthGroups	%>
	 } //addAuth
	 
	 function loadVendorValues(){
	 	<%  while(VendorView_RS.next()) { %>
				var VendorID = "<%= VendorView_RS.getInt("VENDORID")%>";
				var VendorName = "<%= VendorView_RS.getString("VENDOR_NAME")%>";
				var vendorSelect = dijit.byId("vendor");
				vendorSelect.addOption({value: VendorID, label: VendorName});
				if (VendorID == '<%= vendorid %>') {
					autoSelectValue('vendor',VendorID);
				}
		<% } //while VendorView	%>
	 } //loadVendorValues
	 
	 function loadAuthValues(){
	 	<%  UserAdmin_RS.first();
			if (UserAdmin_RS.getResultSetSize() > 0 ) {
				while(UserAdmin_RS.next()) { 
					AuthGroups_RS.first();
					if (AuthGroups_RS.getResultSetSize() > 0 ) {
						while(AuthGroups_RS.next()) { %>
							<% if (!tool.nullStringConverter(AuthGroups_RS.getString("AUTH_GROUP")).equals("") && AuthGroups_RS.getString("AUTH_GROUP").equals(UserAdmin_RS.getString("AUTH_GROUP"))) { %>
								var OptSelect = "<%=UserAdmin_RS.getInt("AUTH_TYPEID")%>";
								createHiddenInput('logactionid','<%= AuthGroups_RS.getString("AUTH_GROUP").toLowerCase() %>authtypeid','<%= UserAdmin_RS.getInt("USER_AUTH_TYPEID") %>');
								autoSelectValue('<%=AuthGroups_RS.getString("AUTH_GROUP")%>Auth',OptSelect);
							<% } //if AuthGroup = Admins
						} //while AuthGroups
					} // if AuthGroups	
				} //while UserAdmin
			} //if UserAdmin
		%>
	 } //loadAuthValues
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '331');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','userid','<%= userid %>');
        createHiddenInput('logactionid','submitvalue','');
        createpTag();
        <% if (userid == 0) { %>
        createTextBox('lookupEmail','lookupEmail','lookupEmail','64','','');
        createInputButton('lookup_button','ibm-submit','<%= messages.getString("lookup") %>','ibm-btn-arrow-pri','lookup_button','reqName()');
        <% } %>
        createTextInput('firstname','firstname','firstname','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'<%= firstname %>');
        createTextInput('lastname','lastname','lastname','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'<%= lastname %>');
        createTextInput('email','email','email','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_email_regexp,'<%= email %>');
        createTextInput('loginid','loginid','loginid','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_email_regexp,'<%= loginid %>');
        <% if (authmethod.toLowerCase().equals("password") || authmethod.toLowerCase().equals("db") || authmethod.toLowerCase().equals("database")) { %>
        	createTextInput('userpasswd','userpasswd','userpasswd','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;/+()-]*$','');
        	createTextInput('confpasswd','confpasswd','confpasswd','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;/+()-]*$','');
        <% } //if authmethod%>
        createTextBox('pager','pager','pager','64','','<%= pager %>');
        createSelect('timezone', 'timezone', '<%= messages.getString("please_select_option") %>', '0', 'timezoneloc');
        createSelect('vendor', 'vendor', '<%= messages.getString("please_select_option") %>', '0', 'vendorloc');
        createSelect('backupid', 'backupid', '<%= messages.getString("please_select_option") %>', '-1', 'backuploc');
        createSelect('officestatus', 'officestatus', '', '', 'officestatusloc');
     <% if (AuthGroups_RS.getResultSetSize() > 0 ) { 
			AuthGroups_RS.first();
			AuthGroups_RS = AuthGroups.getResults();
			while( AuthGroups_RS.next() ) { %>
				createSelect('<%= tool.nullStringConverter(AuthGroups_RS.getString("AUTH_GROUP")) %>Auth', '<%= tool.nullStringConverter(AuthGroups_RS.getString("AUTH_GROUP")) %>Auth', '<%= messages.getString("please_select_auth") %>', '0', '<%= tool.nullStringConverter(AuthGroups_RS.getString("AUTH_GROUP")) %>Authloc');	
		<% 	} //while 
		} //if AuthGroups %>
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_admin','addAdmin()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_admin','cancelForm()');
     	createPostForm('addAdmin','addAdminForm','addAdminForm','ibm-column-form','<%= prtgateway %>');
     	addTimeZone();
     	addOfficeStatus();
     	addAuth();
     	reqName('addBackups');
     	changeSelectStyle('300px');
     	changeInputTagStyle("300px");
     	autoSelectValue('timezone','<%= timezone %>');
     	autoSelectValue('officestatus','<%= officestatus %>');
     	loadAuthValues();
     	loadVendorValues();
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
     	dijit.byId('firstname').focus();
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
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332"><%= messages.getString("administer_gpws_admin") %> </a></li>
			</ul>
			<h1><% if (userid == 0 ) { %><%= messages.getString("admin_add_info") %><%} else {%><%= messages.getString("admin_edit_info") %><% } %></h1>
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
			<% if (userid == 0) { %>
				<p><%= messages.getString("lookup_user_info") %>:</p>
			<% } %>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='addAdmin'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<% if (userid == 0) { %>
				<div class="pClass">
					<label for='lookupEmail'><%= messages.getString("email_address") %>:</label>
					<span><div id='lookupEmail'></div></span>
				</div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span><div id='lookup_button'></div></span>
					</div>
				</div>
				<div class="ibm-rule"><hr /></div>
				<% } %>
				<div class="pClass">
					<label for='firstname'><%= messages.getString("first_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='firstname'></div></span>
				</div>
				<div class="pClass">
					<label for='lastname'><%= messages.getString("last_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='lastname'></div></span>
				</div>
				<div class="pClass">
					<label for='email'><%= messages.getString("email_address") %>:<span class='ibm-required'>*</span></label>
					<span><div id='email'></div></span>
				</div>
				<div class="pClass">
					<label for='loginid'><%= messages.getString("login_id") %>:<span class='ibm-required'>*</span></label>
					<span><div id='loginid'></div></span>
				</div>
				<% if (authmethod.toLowerCase().equals("password") || authmethod.toLowerCase().equals("db") || authmethod.toLowerCase().equals("database")) { %>
				<div class="pClass">
					<label for='userpasswd'><%= messages.getString("password") %>:<span class='ibm-required'>*</span></label>
					<span><div id='userpasswd'></div></span>
				</div>
				<div class="pClass">
					<label for='confpasswd'><%= messages.getString("password") %>:<span class='ibm-required'>*</span></label>
					<span><div id='confpasswd'></div></span>
				</div>
				<% } //if authmethod %>
				<div class="pClass">
					<label for='pager'><%= messages.getString("pager_number") %>:</label>
					<span><div id='pager'></div></span>(e.g. 12345@wirelessco.net)
				</div>
				<div class="pClass">
					<label for='timezone'><%= messages.getString("time_zone") %>:</label>
					<span><div id='timezoneloc'></div></span>
				</div>
				<div class="pClass">
					<label for='vendor'><%= messages.getString("company") %>:</label>
					<span><div id='vendorloc'></div></span>
				</div>
				<div class="pClass">
					<label for='backup'><%= messages.getString("backup") %>:</label>
					<span><div id='backuploc'></div></span>
				</div>
				<div class="pClass">
					<label for='officestatus'><%= messages.getString("office_status") %>:</label>
					<span><div id='officestatusloc'></div></span>
				</div>
				<%  if (AuthGroups_RS.getResultSetSize() > 0 ) { 
						AuthGroups_RS.first();
						AuthGroups_RS = AuthGroups.getResults();
						while( AuthGroups_RS.next() ) { %>
							<div class="pClass">
								<label for='timezone'><%= tool.nullStringConverter(AuthGroups_RS.getString("AUTH_GROUP")) %> <%= messages.getString("authorization") %>:</label>
								<span><div id='<%= tool.nullStringConverter(AuthGroups_RS.getString("AUTH_GROUP")) %>Authloc'></div></span>
							</div>
					<% 	} //while 
					} //if AuthGroups %>
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