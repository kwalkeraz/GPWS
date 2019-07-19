<%
	// Check authorization levels
	PrinterUserProfileBean pupb2 = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	boolean hasAccess = false;
	boolean hasKOAccess = false;
	String[] sAuthTypes = pupb2.getAuthTypes();
	String CPAccess = "None";
	String KOAccess = "None";
	String GPWSAccess = "None";
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("CP")) {
			hasAccess = true;
			CPAccess = sAuthTypes[i];
		} else if (sAuthTypes[i].startsWith("Keyop")) {
			hasAccess = true;
			hasKOAccess = true;
			KOAccess = sAuthTypes[i];
		} else {
			hasAccess = true;
			GPWSAccess = sAuthTypes[i];
		}
	} //for
	
	String sTS = "2017";
	if (KOAccess.equals("Keyop Superuser")) {
		sTS = "3095";
	}
%>
<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print keyop administration"/>
<meta name="Description" content="Global print website select a keyop action item page" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("Keyop_administration") %> </title>
<%@ include file="metainfo2.jsp" %>

<script type="text/javascript" src="/tools/print/js/displayFields.js"></script>

<script language="Javascript">
 
function SearchTicket() {
	if (document.TicketForm.ticketno.value == null || document.TicketForm.ticketno.value == "") {
		alert("<%= messages.getString("device_request_number") %> <%= messages.getString("is_required") %>");
		document.TicketForm.ticketno.focus();
		return false;
	} else {
		document.TicketForm.submit();
	}
}

function callNext(TabSel) {
	if (TabSel == "ErrorLog") {
		<% if ( pupb2.getAccess(UserAuthConstants.ERROR_LOG).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=570&ft=0&mpp=50";
		<% } else { %>
			alert('<%= messages.getString("tableselect_errorlog_denied") %>');
			return false;
		<% } %>
	}
	if (TabSel == "UserLog") {
		<% if ( pupb2.getAccess(UserAuthConstants.USER_LOG).booleanValue() ) {%>
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=570&ft=0&mpp=50";
		<% } else { %>
			alert('<%= messages.getString("tableselect_userlog_denied") %>');
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
			<h1 class="ibm-small"><%= messages.getString("Keyop_administration") %></h1>
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
					<%
						String colCount0 = "6-2";
						String colCount1 = "6-6";
						String colCount2 = "6-1";
						String colCount3 = "6-1";
						if (KOAccess.equals("Keyop")) {
							colCount0 = "6-0";
							colCount1 = "6-6";
							colCount2 = "6-3";
							colCount3 = "6-3";
						}
					 %>
					<div class="ibm-columns">
						<div class="ibm-col-<%= colCount1 %>">
							<!-- FIRST COLUMN OF ADMIN LINKS -->
							<div class="ibm-columns">
					<% if (hasAccess) { 
							if (hasKOAccess) { %>		
								<!-- Keyop Access -->
								<div class="ibm-col-<%= colCount0 %>">
								<% if (pupb.getAccess(UserAuthConstants.KOKEYOP_MOD).booleanValue()) { %>
										<!-- Keyop Administration -->
										<h2><%= messages.getString("tableselect_keyop_admin") %></h2>
										<ul>
											<li><a href="<%= keyops %>?next_page_id=3010"><%= messages.getString("add_keyop") %></a></li>
											<li><a href="<%= keyops %>?next_page_id=3012"><%= messages.getString("view_keyops") %></a></li>
											<li><a href="<%= keyops %>?next_page_id=3017&cityid=0"><%= messages.getString("view_keyops_by_site") %></a></li>
										</ul>
								<% } %>
								<% if ( pupb.getAccess(UserAuthConstants.KOHANDLE_REQUESTS_ADMIN).booleanValue() ) {	 %>
										<!-- Keyop Tickets -->
										<h2><%= messages.getString("keyop_admin_view_tickets") %></h2>
										<ul>
											<li><a href="<%= keyops %>?next_page_id=3096&orderby=keyop_requestid&cityid=-1"><%= messages.getString("new") %></a></li>
											<li><a href="<%= keyops %>?next_page_id=3097&orderby=keyop_requestid&cityid=-1"><%= messages.getString("in_progress") %></a></li>
											<li><a href="<%= keyops %>?next_page_id=3098&orderby=keyop_requestid&cityid=-1&date=0"><%= messages.getString("completed") %></a></li>
											<li><a href="<%= keyops %>?next_page_id=2016"><%= messages.getString("ticket_search") %></a></li>
										</ul>												
								<% } %>
								</div> <!-- END ibm-col-4-1 -->
								<% if ( pupb.getAccess(UserAuthConstants.KOPARTS_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.KOSUPPLIES_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.KOPROBLEMS_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.KOCLOSECODES_MOD).booleanValue() || pupb.getAccess(UserAuthConstants.KOADMIN_MOD).booleanValue() ) { %>
								<!-- SECOND COLUMN OF ADMIN LINKS -->
								<div class="ibm-col-<%= colCount0 %>">
									<% if ( pupb.getAccess(UserAuthConstants.KOPARTS_MOD).booleanValue() ) { %>
									<!-- Keyop Parts Administration -->
									<h2><%= messages.getString("keyop_parts_admin") %></h2>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=3074"><%= messages.getString("admin_parts") %></a></li>
									</ul>
									<% } %>
									<% if ( pupb.getAccess(UserAuthConstants.KOSUPPLIES_MOD).booleanValue() ) { %>
									<!-- Keyop Supplies Administration -->
									<h2 class="bar-gray-light"><%= messages.getString("keyop_supplies_admin") %></h2>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=3078"><%= messages.getString("admin_supplies") %></a></li>
									</ul>
									<% } %>	
									<% if ( pupb.getAccess(UserAuthConstants.KOPROBLEMS_MOD).booleanValue() ) { %>
									<!-- Keyop Problems Administration -->
									<h2><%= messages.getString("keyop_problems_admin") %></h2>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=3072"><%= messages.getString("admin_problems") %></a></li>
									</ul>
									<% } %>	
									<% if ( pupb.getAccess(UserAuthConstants.KOCLOSECODES_MOD).booleanValue() ) { %>
									<!-- Keyop Close Codes Administration -->
									<h2><%= messages.getString("keyop_closecode_admin") %></h2>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=3076"><%= messages.getString("admin_closecode") %></a></li>
									</ul>
									<% } %>	
									<% if ( pupb.getAccess(UserAuthConstants.KOADMIN_MOD).booleanValue() ) { %>
									<!-- Keyop Admin Administration -->
									<h2><%= messages.getString("keyop_admin_admin") %></h2>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=3020"><%= messages.getString("add_admin") %></a></li>
										<li><a href="<%= keyops %>?next_page_id=3022"><%= messages.getString("view_admins") %></a></li>
									</ul>
									<% } %>
								</div> <!--  END ibm-col-6-2 -->
								<% } %>		
								<% if (pupb.getAccess(UserAuthConstants.KOHANDLE_REQUESTS).booleanValue()) { %>
								<div class="ibm-col-<%= colCount2 %>">
								<h2><%= messages.getString("ticket_information") %></h2>
								
								<h3><%= messages.getString("new") %></h3>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=2042&amp;userid=<%= pupb.getUserID() %>"><%= messages.getString("my_sites") %></a></li>
									</ul>
								<h3><%= messages.getString("in_progress") %></h3>
									<ul>
										<li><a href="<%= keyops %>?next_page_id=2044&amp;userid=<%= pupb.getUserID() %>"><%= messages.getString("my_sites") %></a></li>
										<li><a href="<%= keyops %>?next_page_id=2046&amp;userid=<%= pupb.getUserID() %>"><%= messages.getString("assigned_to_me") %></a></li>
									</ul>
								<h3><%= messages.getString("completed") %></h3>
									<ul>
										<li><a href='<%= keyops %>?next_page_id=2045&amp;userid=<%= pupb.getUserID() %>'><%= messages.getString("my_sites") %></a></li>
										<li><a href='<%= keyops %>?next_page_id=2043&amp;userid=<%= pupb.getUserID() %>&amp;sorttype=TICKETNO'><%= messages.getString("closed_by_me") %></a></li>
									</ul>
								</div>
								<% } %>
							<% } else { // user does not have keyop access %>
								<p><%= messages.getString("no_access_to_this_page") %></p>
								<div class="ibm-col-6-5"></div>
<%								}
							} else { //user does not have access %>
								<p><%= messages.getString("invalid_login") %>.  <%= messages.getString("believe_need_access") %> </p>
								<div class="ibm-col-6-5"></div>
						<% } %>
						<div class="ibm-col-<%= colCount3 %>">
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
					</div>
					</div>
				</div> <!-- ibm-columns -->
				<% if (pupb.getAccess(UserAuthConstants.KOHANDLE_REQUESTS).booleanValue() || pupb.getAccess(UserAuthConstants.KOHANDLE_REQUESTS_ADMIN).booleanValue()) { %>
				<!-- search form -->
				<h2 class="ibm-rule-alternate"><%= messages.getString("ticket_search") %></h2>
				<p>
					<form name="TicketForm" action="<%= keyops %>" method="post">
						<label for="ticketno"><%= messages.getString("device_request_number") %>:<span class="ibm-required">*</span>&nbsp;</label>
						<input type="hidden" name="next_page_id" value="<%= sTS %>"/>
						<input type="text" size="14" name="ticketno" id="ticketno"/>&nbsp;
						<input id="Search" value="<%= messages.getString("search") %>" type="button" name="ibm-submit" class="ibm-btn-arrow-pri" onclick="javascript:SearchTicket();" />
					</form>
				</p>
				<!-- end of search form -->
				<% } %>
				</div><!--  END ibm-content-main -->
			</div><!--  END ibm-content-body -->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>