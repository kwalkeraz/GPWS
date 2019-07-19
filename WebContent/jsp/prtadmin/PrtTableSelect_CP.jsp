<%      
	// Check authorization levels
	PrinterUserProfileBean pupb2 = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	boolean hasAccess = false;
	boolean hasCPAccess = false;
	String[] sAuthTypes = pupb2.getAuthTypes();
	String CPAccess = "None";
	String KOAccess = "None";
	String GPWSAccess = "None";
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("CP")) {
			hasAccess = true;
			hasCPAccess = true;
			CPAccess = sAuthTypes[i];
		} else if (sAuthTypes[i].startsWith("Keyop")) {
			hasAccess = true;
			KOAccess = sAuthTypes[i];
		} else {
			hasAccess = true;
			GPWSAccess = sAuthTypes[i];
		}
	} //for
%>
<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print administration"/>
<meta name="Description" content="Global print website select an action item page" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("Common_process_administration") %> </title>
<%@ include file="metainfo2.jsp" %>

<script type="text/javascript" src="/tools/print/js/displayFields.js"></script>

<script language="Javascript">

function callNext(TabSel) {

	if (TabSel == "CPAssigneeAdd") {
		<% if ( pupb2.getAccess(UserAuthConstants.CPANALYST_ADD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=1000";
		<% } else { %>
			alert('<%= messages.getString("tableselect_cpassignee_administer_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "CPAssigneeMod") {
		<% if ( pupb2.getAccess(UserAuthConstants.CPANALYST_MOD).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=1020";
		<% } else { %>
			alert('<%= messages.getString("tableselect_cpassignee_administer_denied") %>');
			return false;
		<% } %>
	}
}
</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>

			<!-- LEADSPACE_BEGIN -->
			<div id="ibm-leadspace-head" class="ibm-alternate">
				<div id="ibm-leadspace-body">
					<h1 class="ibm-small"><%= messages.getString("Common_process_administration") %></h1>
				</div> <!--  Leadspace-body -->
			</div> <!--  Leadspace-head -->
			<!-- LEADSPACE_END -->
			<%@ include file="nav.jsp" %>
	<!-- All the main body stuff goes here -->

	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<%@ include file="NewsFeed.jsp" %>
					<p><%= messages.getString("tableselect_info") %>&nbsp;&nbsp;<%= messages.getString("tableselect_admin_contact") %></p>
					<div class="ibm-columns">
					<% if (hasAccess) { 
						if (hasCPAccess) { %>
							
						<div class="ibm-col-4-3">
							
							<!-- FIRST COLUMN OF ADMIN LINKS -->
							<div class="ibm-columns">
							    <div class="ibm-col-4-1">
									<!-- Common process -->
									<%  if (pupb2.getAccess(UserAuthConstants.CPANALYST_ADD).booleanValue() || pupb.getAccess(UserAuthConstants.CPANALYST_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.CPANALYST_DEL).booleanValue() || pupb.getAccess(UserAuthConstants.CPBILLING_ADD).booleanValue() || pupb.getAccess(UserAuthConstants.CPBILLING_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.CPBILLING_DEL).booleanValue() || pupb.getAccess(UserAuthConstants.CPROUTING_TEMP_ADD).booleanValue() || pupb.getAccess(UserAuthConstants.CPROUTING_TEMP_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.CPROUTING_TEMP_DEL).booleanValue()) { %>
										<h2><%= messages.getString("workflow_process") %></h2>
										<ul>
										<li><a href="<%= commonprocess %>?to_page_id=1805&show=bytype"><%= messages.getString("cp_view_by_device_requests") %></a></li>
										<li><a href="<%= commonprocess %>?to_page_id=1805&show=bysteps"><%= messages.getString("cp_view_by_routing_steps") %></a></li>
										<li><a href="<%= commonprocess %>?to_page_id=1805&show=bynumber"><%= messages.getString("cp_view_by_request_number") %></a></li>
									</ul>
									<% } %>
									<!-- CPAssignee administration -->
									<% if ( pupb2.getAccess(UserAuthConstants.CPANALYST_ADD).booleanValue() ) { %>
										<h2><%= messages.getString("tableselect_admin_cpassignee") %></h2>
										<ul>
											<li><a id="sign-in-out" href="javascript: callNext('CPAssigneeAdd');" ><%= messages.getString("tableselect_cpassignee_add") %></a></li>
											<li><a id="sign-in-out" href="javascript: callNext('CPAssigneeMod');" ><%= messages.getString("tableselect_cpassignee_mod") %></a></li>
										</ul>													
									<% } %>
									<!-- End of common process -->
								</div> <!-- END ibm-col-4-1 -->
								<!-- SECOND COLUMN OF ADMIN LINKS -->
								<div class="ibm-col-4-1">
									<h2><%= messages.getString("tableselect_admin_cproutingtemplate") %></h2>
									<ul>
										<li><a href="<%= commonprocess %>?to_page_id=7480"><%= messages.getString("tableselect_cproutingtemplate_mod") %></a></li>
									</ul>							
								</div> <!--  END ibm-col-4-1 -->
								<div class="ibm-col-4-1">&nbsp;</div>
							</div>
							<% } else { // user does not have keyop access %>
								<p><%= messages.getString("no_access_to_this_page") %></p>
<%								}
							 } else { //user does not have access %>
								<p><%= messages.getString("invalid_login") %>.  <%= messages.getString("believe_need_access") %> </p>
							<% } %>
						</div> <!-- END ibm-col-4-1 -->
						<div class="ibm-col-4-1">
							<h2><%= messages.getString("access_levels") %></h2>
						    <p><b><%= messages.getString("gpws") %>:</b>&nbsp;<%= messages.getString(GPWSAccess.replace(' ','_')) %></p>
						    <p><b><%= messages.getString("keyop_cap") %>:</b>&nbsp;<%= messages.getString(KOAccess.replace(' ','_')) %></p>
						    <p><b><%= messages.getString("common_process") %>:</b>&nbsp;<%= messages.getString(CPAccess.replace(' ','_')) %></p>
						    
						    <p><a href="<%= statichtmldir %>/AccessRequest.html"><%= messages.getString("access_request_page") %></a></p>
						    			    
						    <h3><%= messages.getString("support") %></h3>
						    <p><a href="<%= statichtmldir %>/GPWSHelp.html"><%= messages.getString("tableselect_GPWS_help_doc") %></a></p>
						    
							<% if (pupb2.getAccess(UserAuthConstants.ERROR_LOG).booleanValue() || pupb2.getAccess(UserAuthConstants.USER_LOG).booleanValue()) {%>
							    <h3><%= messages.getString("logs") %></h3>
								<% if (pupb2.getAccess(UserAuthConstants.ERROR_LOG).booleanValue()) { %>
							    <p><a href="javascript: callNext('ErrorLog');" onclick="javascript: callNext('ErrorLog');" ><%= messages.getString("error_log") %></a></p>
							    <% } 
								   if (pupb2.getAccess(UserAuthConstants.USER_LOG).booleanValue()) { %>
							    <p><a href="javascript: callNext('UserLog');" onclick="javascript: callNext('UserLog');" ><%= messages.getString("user_log") %></a></p>
							    <% } %>
						    <% } %> 
						</div>
				</div><!--  END ibm-columns ibm-graphics-tabs -->
			    <!-- ibm-content-main -->
			    <!-- FEATURES_END -->
					
			    <!-- CONTENT_BODY_END -->
			</div><!--  END ibm-content-main -->
		</div><!--  END ibm-content-body -->
	</div>
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>