<%
	com.ibm.aurora.bhvr.TableQueryBhvr KeyopInfoView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("KeyopInfoView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet KeyopInfoView_RS = KeyopInfoView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopView_RS = AdminKeyopView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr TimeZoneView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TimeZoneView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TimeZoneView_RS = TimeZoneView.getResults();
	
	com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopSiteView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopSiteView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopSiteView_RS = AdminKeyopSiteView.getResults();

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
	while (KeyopInfoView_RS.next()) { 
		sFirstName = appTool.nullStringConverter(KeyopInfoView_RS.getString("FIRST_NAME"));
		sLastName = appTool.nullStringConverter(KeyopInfoView_RS.getString("LAST_NAME"));
		sPager = appTool.nullStringConverter(KeyopInfoView_RS.getString("PAGER"));
		sEmail = appTool.nullStringConverter(KeyopInfoView_RS.getString("EMAIL"));
		sLoginid = appTool.nullStringConverter(KeyopInfoView_RS.getString("LOGINID"));
		sTimeZone = appTool.nullStringConverter(KeyopInfoView_RS.getString("TIME_ZONE"));
		sOfficeStatus = appTool.nullStringConverter(KeyopInfoView_RS.getString("OFFICE_STATUS"));
		iBackup = KeyopInfoView_RS.getInt("BACKUPID");
	}
	
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin edit keyop"/>
<meta name="Description" content="This page allows an admin to edit the information about a keyop." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_admin_page") %> - <%= messages.getString("edit") %><%= messages.getString("keyop") %></title>
<%@ include file="metainfo2.jsp" %>
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

	function editKeyop() {
		var formName = dijit.byId("theForm");
		var formValid = false;
		var wName = dijit.byId("firstname").get('value') + ' ' + dijit.byId("lastname").get('value');
		var logactionid = dojo.byId('logaction');
		var logaction = wName + " has been edited.";
		logactionid.value = logaction;
		formValid = formName.validate();
		var msg = logactionid.value;
		if (formValid) {
			if (submitForm('theForm',msg)) {
				AddParameter(logactionid.name, logactionid.value);
			};
		} else {
			return false;
		};
	}; //addCategory
	
	function submitForm(form,msg){
		var submitted = true;
		var xhrArgs = {
			form:  form,
	           handleAs: "text",
	           sync: true,
               preventCache: true,
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Unknown") > -1) {
	   				dojo.byId("response").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("error_in_request") %>'+"</p>";
	   				submitted = false;
	   			} else {
	   				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   			};
	           },
	           error: function(error, ioArgs) {
	           	console.log(error);
	               dojo.byId("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           },
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
	 } //submitForm
	
	function cancelForm() {
		self.location.href = "<%= keyops %>?next_page_id=3012";
	}
	
	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id', '3026');
		createHiddenInput('userid','userid','<%= sUserid %>');
		createHiddenInput('submitvalue', 'submitvalue','EditKeyop');
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
		createInputButton('submit_button_name','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_button_name','editKeyop()');
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
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
			dojo.byId("response-hr").style.display = "";
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
					<li><a href="<%= keyops %>?next_page_id=3012"> <%= messages.getString("view_keyops") %></a></li>  
			</ul>
			<h1><%= messages.getString("edit_keyop") %></h1>
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
					<div id='response'></div>
					<div id="response-hr" class="ibm-rule" style="display: none;"><hr /></div>
					<p><%= messages.getString("update_keyop_info") %> <%= messages.getString("required_info") %></p>
					<div id='Keyop'>
						<div id='nextpageid'></div>
						<div id='userid'></div>
						<div id="submitvalue"></div>
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
							<label for='pagerno'><%= messages.getString("pager_no") %>:<span class='ibm-required'>*</span>&nbsp;<span class="ibm-item-note"><%= messages.getString("example_pagerno") %></span></label>
							<span><div id='pagerno'></div></span>
						</div>
						<div class="pClass">
							<label id="timezonelabel" for="timezone">
								<%= messages.getString("time_zone") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='timezoneloc'></div>
								<div id='timezoneID' connectId="timezone" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="officestatuslabel" for="officestatus">
								<%= messages.getString("out_of_office_status") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='officestatusloc'></div>
								<div id='officestatusID' connectId="officestatus" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="backuplabel" for="backup">
								<%= messages.getString("backup") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='backuploc'></div>
								<div id='backupID' connectId="backup" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label for="edit_keyop_sites"><a href='<%= keyops %>?next_page_id=3015&amp;userid=<%= sUserid %>'><%= messages.getString("edit_keyop_sites") %></a>:</label>
								<%		while (AdminKeyopSiteView_RS.next()) { %>
												<span><b><%= appTool.nullStringConverter(AdminKeyopSiteView_RS.getString("CITY")) %></b>:&nbsp;
											<% if (appTool.nullStringConverter(AdminKeyopSiteView_RS.getString("ENTIRE_SITE")).equals("Y")) { %>
													<%= messages.getString("all_buildings") %>
											<% } else { 
													int iCityID = AdminKeyopSiteView_RS.getInt("CITYID");
				  									Connection con = null; 
				  									Statement stmtBuilding = null; 
				  									Statement stmtBuilding2 = null; 
				  									ResultSet rsBuilding = null; 
				  									ResultSet rsBuilding2 = null;
													try {  
				  										con = appTool.getConnection();
														
				  										stmtBuilding2 = con.createStatement();
				  										rsBuilding2 = stmtBuilding2.executeQuery("SELECT BUILDING.CITYID, BUILDINGID, BUILDING_NAME FROM GPWS.BUILDING BUILDING, GPWS.CITY CITY WHERE BUILDING.CITYID = CITY.CITYID AND BUILDING.CITYID = " + iCityID + " ORDER BY BUILDING_NAME"); %> 
												<%		while (rsBuilding2.next()) { %>
			 											<%= rsBuilding2.getString("BUILDING_NAME") %>,&nbsp;
							 					<%		} %>
												<%	} catch (Exception e) {  
				   					   		     		System.out.println("AdminEditKeyopSites.jsp ERROR: " + e);  
				   					    	    		try {  
				   						   					appTool.logError("AdminEditKeyopSites.jsp","Keyop", e);  
				   						   				} catch (Exception ex) {  
				   						   					System.out.println("Keyop Error in AdminEditKeyopSites.jsp ERROR: " + ex);  
				   						   				}  
				   					    	   		} finally { 
				   					    	   			if (rsBuilding != null)  
				   					    	   				rsBuilding.close();  
				   					    	   			if (rsBuilding2 != null)  
				   					    	   				rsBuilding2.close();  
				   					    	   			if (stmtBuilding != null)  
				   					    	   				stmtBuilding.close();  
				   					    	   			if (stmtBuilding2 != null)  
				   					    	   				stmtBuilding2.close();  
				   					    	   		 	if (con != null)  
				  					    	   				con.close(); 
				  					    	   		}
							 						%>
													
											<% } %></span>			
			<% 							} // end while %>
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