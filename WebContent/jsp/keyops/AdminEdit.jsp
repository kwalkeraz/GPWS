<%
	// THIS IS WHERE WE LOAD ALL THE BEANS
	com.ibm.aurora.bhvr.TableQueryBhvr AdminViewEdit  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminViewEdit");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminViewEdit_RS = AdminViewEdit.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr AuthTypeView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AuthTypeView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AuthTypeView_RS = AuthTypeView.getResults();
	
	com.ibm.aurora.bhvr.TableQueryBhvr TimeZoneView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TimeZoneView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TimeZoneView_RS = TimeZoneView.getResults();
	
	com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopView_RS = AdminKeyopView.getResults();
	
	AppTools appTool = new AppTools();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String msg = appTool.nullStringConverter(request.getParameter("msg"));
	String sUserid = request.getParameter("userid");
	String sFirstName = "";
	String sLastName = "";
	String sPager = "";
	String sEmail = "";
	String sLoginid = "";
	String sTimeZone = "";
	String sOfficeStatus = "N";
	int iBackup = 0;
	int iUseridTemp = 0;
	String sNameTemp = "";
	String sTimeZoneTemp = "";
	boolean userExist = false;
	while (AdminViewEdit_RS.next()) { 
		userExist = true;
		sFirstName = appTool.nullStringConverter(AdminViewEdit_RS.getString("FIRST_NAME"));
		sLastName = appTool.nullStringConverter(AdminViewEdit_RS.getString("LAST_NAME"));
		sPager = appTool.nullStringConverter(AdminViewEdit_RS.getString("PAGER"));
		sEmail = appTool.nullStringConverter(AdminViewEdit_RS.getString("EMAIL"));
		sLoginid = appTool.nullStringConverter(AdminViewEdit_RS.getString("LOGINID"));
		sTimeZone = appTool.nullStringConverter(AdminViewEdit_RS.getString("TIME_ZONE"));
		sOfficeStatus = appTool.nullStringConverter(AdminViewEdit_RS.getString("OFFICE_STATUS"));
		iBackup = AdminViewEdit_RS.getInt("BACKUPID");
	}	
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin edit"/>
<meta name="Description" content="This page allows a superuser to edit the information about an admin" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("edit_admin") %></title>
<%@ include file="metainfo2.jsp" %>

<% if (!userExist) { logaction = messages.getString("user_not_found"); } %>

<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");

	function onChangeCall(wName) {
		return true;
	}
	
	function editAdmin() {
		validForm = dijit.byId("theForm").validate();
		if (validForm) {
			dijit.byId("theForm").submit();
		} else {
			return false;
		}
	}
	
	function cancelForm() {
		self.location.href = "<%= keyops %>?next_page_id=3012";
	}
	
	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id', '3026');
		createHiddenInput('userid','userid','<%= sUserid %>');
		createHiddenInput('submitvalue','submitvalue','EditAdmin');
		createHiddenInput('logactionid','logaction','');
		createpTag();
		createTextInput('firstname','firstname','firstname','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= sFirstName %>');
		createTextInput('lastname','lastname','lastname','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= sLastName %>');
		createTextInput('loginid','loginid','loginid','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$','<%= sLoginid %>');
		createTextInput('email','email','email','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$','<%= sEmail %>');
		createTextInput('pagerno','pagerno','pagerno','64',false,'','','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$','<%= sPager %>');
		createSelect('timezone', 'timezone', '<%= messages.getString("please_select_time_zone") %>', 'None', 'timezoneloc');
		createSelect('officestatus', 'officestatus', '<%= messages.getString("please_select_office_status") %>', 'None', 'officestatusloc');
		createSelect('backup', 'backup', '<%= messages.getString("please_select_backup") %>', '0', 'backuploc');
		createInputButton('submit_button_name','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_button_name','editAdmin()');
			createSpan('submit_button_name','ibm-sep');
		createInputButton('submit_button_name','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-arrow-pri','cancel_button_name','cancelForm()');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		changeInputTagStyle("250px");
		changeSelectStyle('280px');
		addTimeZones();
		autoSelectValue('timezone','<%= sTimeZone %>');
		addOfficeStatus();
		autoSelectValue('officestatus','<%= sOfficeStatus %>');
		addBackup();
		autoSelectValue('backup','<%= iBackup %>');
		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-error-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
		dijit.byId('firstname').focus();
	});
	
	function addTimeZones() {
		<%	
		while(TimeZoneView_RS.next()) {  %>
			addOption('timezone','<%= appTool.nullStringConverter(TimeZoneView_RS.getString("CATEGORY_VALUE1")) %>','<%= appTool.nullStringConverter(TimeZoneView_RS.getString("CATEGORY_VALUE1")) %>');
<%		} %>
	}
	
	function addOfficeStatus() {
			addOption('officestatus','<%= messages.getString("available") %>','Y');
			addOption('officestatus','<%= messages.getString("out_of_office") %>','N');
	}
	
	function addBackup() {
		<% while (AdminKeyopView_RS.next()) { %>
			addOption('backup','<%= AdminKeyopView_RS.getString("LAST_NAME") + "," + AdminKeyopView_RS.getString("FIRST_NAME") %>','<%= AdminKeyopView_RS.getInt("USERID") %>');
<%		 } %>
	}
	
	function dispalyMsg() {
		<% if (!msg.equals("")) { %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
		<% }%>
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
				<li><a href="<%= keyops %>?next_page_id=3022"> <%= messages.getString("view_admins") %></a></li>  
			</ul>
			<h1><%= messages.getString("edit_admin") %></h1>
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
					<p><%= messages.getString("update_keyop_info") %> <%= messages.getString("required_info") %></p>
					<div id='response'></div>
					<div id='Keyop'>
						<div id='nextpageid'></div>
						<div id='userid'></div>
						<div id='submitvalue'></div>
						<div id='logactionid'></div>
						
						<div class="pClass">
							<label for='firstname'><%= messages.getString("first_name") %>:<span class='ibm-required'>*</span></label>
							<span><div id='firstname'></div></span>
						</div>
						<div class="pClass">
							<label for='lastname'><%= messages.getString("last_name") %>:<span class='ibm-required'>*</span></label>
							<span><div id='lastname'></div></span>
						</div>
						<div class="pClass">
							<label for='loginid'><%= messages.getString("loginid") %>:<span class='ibm-required'>*</span></label>
							<span><div id='loginid'></div></span>
						</div>
						<div class="pClass">
							<label for='email'><%= messages.getString("email") %>:<span class='ibm-required'>*</span></label>
							<span><div id='email'></div></span>
						</div>
						<div class="pClass">
							<label for='pagerno'><%= messages.getString("pager_no") %>:&nbsp;<%= messages.getString("example_pagerno") %></label>
							<span><div id='pagerno'></div></span>
						</div>
						<div class="pClass">
							<label for="timezone"><%= messages.getString("time_zone_keyop_located") %>:</label>
							<span><div id="timezoneloc"></div></span>
						</div>
						<div class="pClass">
							<label id="officestatuslabel" for="officestatus">
								<%= messages.getString("out_of_office_status") %>:
							</label>
							<span>
								<div id='officestatusloc'></div>
								<div id='officestatusID' connectId="officestatus" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="backuplabel" for="backup">
								<%= messages.getString("backup") %>:
							</label>
							<span>
								<div id='backuploc'></div>
								<div id='backupID' connectId="backup" align="right"></div>
							</span>
						</div>
						<div class="ibm-rule"><hr /></div>
						<div class="ibm-buttons-row" align="right">
								<div id="submit_button_name"></div>
						</div>
					</div><!-- Keyop Div -->
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>