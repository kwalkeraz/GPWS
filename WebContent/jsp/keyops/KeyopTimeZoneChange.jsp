<%   
	com.ibm.aurora.bhvr.TableQueryBhvr TimeZoneView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TimeZoneView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TimeZoneView_RS = TimeZoneView.getResults();
	
	com.ibm.aurora.bhvr.TableQueryBhvr KeyopProfileInfoView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("KeyopProfileInfoView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet KeyopProfileInfoView_RS = KeyopProfileInfoView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopView_RS = AdminKeyopView.getResults();
	
	com.ibm.aurora.bhvr.TableQueryBhvr KeyopProfileSiteView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("KeyopProfileSiteView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet KeyopProfileSiteView_RS = KeyopProfileSiteView.getResults();

	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	
	PrinterUserProfileBean pupb3 = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	
	int sUserid = 0;
	sUserid = pupb3.getUserID();
	String sName = "";
	String sPager = "";
	String sEmail = "";
	String sLoginid = "";
	String sTimeZone = pupb3.getTimeZone();
	String sOfficeStatus = "N";
	int iVendorID = pupb3.getVendorID();
	int iBackup = 0;
	int iUseridTemp = 0;
	String sNameTemp = "";
	String sTimeZoneTemp = "";
	while (KeyopProfileInfoView_RS.next()) { 
		sName = appTool.nullStringConverter(KeyopProfileInfoView_RS.getString("LAST_NAME")) + ", " + appTool.nullStringConverter(KeyopProfileInfoView_RS.getString("FIRST_NAME"));
		sPager = appTool.nullStringConverter(KeyopProfileInfoView_RS.getString("PAGER"));
		sEmail = appTool.nullStringConverter(KeyopProfileInfoView_RS.getString("EMAIL"));
		sLoginid = appTool.nullStringConverter(KeyopProfileInfoView_RS.getString("LOGINID"));
		sOfficeStatus = appTool.nullStringConverter(KeyopProfileInfoView_RS.getString("OFFICE_STATUS"));
		iBackup = KeyopProfileInfoView_RS.getInt("BACKUPID");
	}
	
	if (sTimeZone == null) {
		sTimeZone = "";
	}
   
%>

<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, time zone change"/>
<meta name="Description" content="This page allows a keyop to change their time zone." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("resolve_and_close_ticket") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");

	var FormName = "RefreshForm";
	var info = new Array();
	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','2061');
 		createpTag();
		createSelect('timezone', 'timezone', '<%= messages.getString("please_select_time_zone") %>', 'None', 'timezoneloc');
		createSelect('officestatus', 'officestatus', '<%= messages.getString("please_select_office_status") %>', 'None', 'officestatusloc');
		createSelect('backup', 'backup', '<%= messages.getString("please_select_backup") %>', '0', 'backuploc');
		
 		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
 		
 		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','updateProfile()');
		createSpan('submit_add_button','ibm-sep');
 		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
 		
 		addTimeZones();
 		addOfficeStatus();
 		addBackups();
 		changeSelectStyle('225px');
 		
 		autoSelectValue('timezone','<%= sTimeZone %>');
 		autoSelectValue('officestatus','<%= sOfficeStatus %>');
 		autoSelectValue('backup','<%= iBackup %>');
	});
	
	function addTimeZones() {
		<% while(TimeZoneView_RS.next()) { %>
			addOption('timezone','<%= TimeZoneView_RS.getString("CATEGORY_VALUE1") %>','<%= TimeZoneView_RS.getString("CATEGORY_VALUE1") %>');
		<% } %>
	}
	
	function addOfficeStatus() {
		addOption('officestatus','<%= messages.getString("available") %>','Y');
		addOption('officestatus','<%= messages.getString("out_of_office") %>','N');
	}

	function addBackups() {
		<% while(AdminKeyopView_RS.next()) { 
				if (iVendorID == AdminKeyopView_RS.getInt("VENDORID")) { %>
					addOption('backup','<%= AdminKeyopView_RS.getString("LAST_NAME") %>, <%= AdminKeyopView_RS.getString("FIRST_NAME") %>','<%= AdminKeyopView_RS.getInt("USERID") %>');
		<% 		}
			} %>
	}
	
	function updateProfile() {
		validForm = dijit.byId("theForm").validate();
		if (validForm) {
			dojo.byId("theForm").submit();
		} else {
			return false;
		}
	}
	
	function submitForm() {
		document.theForm.submit();
	}
	
	function cancelForm() {
<%-- 		self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= sTicketNo %>"; --%>
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
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"> <%= messages.getString("keyop_page") %></a></li>
			</ul>
			<h1><%= messages.getString("update_time_zone") %></h1>
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
					<p><%= messages.getString("time_zone_change_info") %></p><br /><br />
					<div id="Keyop">
						<div id="nextpageid"></div>
						<div class="pClass">
							<label for="timezone"><%= messages.getString("time_zone") %>: </label>
							<span><div id="timezoneloc"></div></span>
						</div>
						<div class="pClass">
							<label for="officestatus"><%= messages.getString("out_of_office_status") %>: </label>
							<span><div id="officestatusloc"></div></span>
						</div>
						<div class="pClass">
							<label for="backup"><%= messages.getString("please_select_backup") %>:</label><br />
								<span><div id="backuploc"></div></span>
							<div class="ibm-buttons-row" align="right">
								<div id="submit_add_button"></div>
							</div>
						</div>
					
					<h3><%= messages.getString("keyop_sites_you_support") %></h3>
					<p class="ibm-note"><%= messages.getString("keyop_sites_desc") %></p>
					<div class="pClass">
							<label for="edit_keyop_sites"><%= messages.getString("Keyop") %>&nbsp;<%= messages.getString("sites") %>:</label>
								<%		while (KeyopProfileSiteView_RS.next()) { %>
												<span><strong><%= appTool.nullStringConverter(KeyopProfileSiteView_RS.getString("CITY")) %></strong>:&nbsp;
											<% if (appTool.nullStringConverter(KeyopProfileSiteView_RS.getString("ENTIRE_SITE")).equals("Y")) { %>
													<%= messages.getString("all_buildings") %>
											<% } else { 
													int iCityID = KeyopProfileSiteView_RS.getInt("CITYID");
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
 				   					   		     		System.out.println("KeyopTimeZoneChange.jsp ERROR: " + e);
 				   					    	    		try {   
  				   						   					appTool.logError("KeyopTimeZoneChange.jsp","Keyop", e);
 				   						   				} catch (Exception ex) {
 				   						   					System.out.println("Keyop Error in KeyopTimeZoneChange.jsp ERROR: " + ex);
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
						</div>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>