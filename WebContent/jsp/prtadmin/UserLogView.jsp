<%@page import="tools.print.lib.DateTime" %>
<%	
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	TableQueryBhvr UserLogView = (TableQueryBhvr) request.getAttribute("UserLogView");
    TableQueryBhvrResultSet UserLogView_RS = UserLogView.getResults();
    int iNumReq = 0;
	while (UserLogView_RS.next()) {
		iNumReq++;
	}
	UserLogView_RS.first();
	String topageid = tool.nullStringConverter(request.getParameter("to_page_id"));
	int iFirst = Integer.parseInt(tool.nullStringConverter(request.getParameter("ft")));
	if (Integer.toString(iFirst) == "") iFirst = 0;
	int iReqCounter = iFirst;
	int iReqPP = Integer.parseInt(tool.nullStringConverter(request.getParameter("mpp")));
	//int iReqPP = 20;
	if (iFirst > 0) {
		// Iterate to the iFirst value
		for (int j = 0; j < iFirst; j++) {
			UserLogView_RS.next();
		} // for loop
	}
	int iReqMax = iFirst + iReqPP;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print user log"/>
	<meta name="Description" content="Global print user log view page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("user_log") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	<script type="text/javascript" djConfig="parseOnLoad: true"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 dojo.addOnLoad(function() {
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
			<h1><%= messages.getString("user_log") %></h1>
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
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='addDriver'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<p class="ibm-table-navigation">
					<span class="ibm-primary-navigation"> 
						<% if (iReqMax > iNumReq) { %>
							<strong><%= iFirst + 1 %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("results") %>
						<% } else { %>
							<strong><%= iFirst + 1 %>-<%= iReqCounter + iReqPP %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("results") %>
						<% } %>
						<span class="ibm-table-navigation-links"> 
							<% if (iFirst > 0) { %>
							| <a class="ibm-back-em-link" href="<%= prtgateway %>?to_page_id=<%= topageid %>&ft=<%= iFirst - iReqPP %>&mpp=<%= iReqPP %>"><%= messages.getString("previous") %></a> 
							<% } //if > 0 %>
							<% if (iReqMax < iNumReq) { %>
							| <a class="ibm-forward-em-link" href="<%= prtgateway %>?to_page_id=<%= topageid %>&ft=<%= iReqMax %>&mpp=<%= iReqPP %>"><%= messages.getString("next") %></a>
							<% } //if iReqMax %>
						</span>
						<span class="ibm-secondary-navigation">
							<span><%= messages.getString("results_per_page") %>:</span> 
							<% if (iReqPP == 20) { %>
							<span class="ibm-table-navigation-links">
								<strong><%= iReqPP %></strong> | <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=<%= request.getParameter("to_page_id") %>&ft=<%= iFirst %>&mpp=50">50</a> | <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=<%= request.getParameter("to_page_id") %>&ft=<%= iFirst %>&mpp=100">100</a>
							</span>
							<% } else if (iReqPP == 50) { %>
							<span class="ibm-table-navigation-links">
								<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=<%= request.getParameter("to_page_id") %>&ft=<%= iFirst %>&mpp=20">20</a> | <strong><%= iReqPP %></strong> | <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=<%= request.getParameter("to_page_id") %>&ft=<%= iFirst %>&mpp=100">100</a>
							</span>
							<% } else { %>
							<span class="ibm-table-navigation-links">
								<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=<%= request.getParameter("to_page_id") %>&ft=<%= iFirst %>&mpp=20">20</a> | <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=<%= request.getParameter("to_page_id") %>&ft=<%= iReqMax %>&mpp=50">50</a> | <strong><%= iReqPP %></strong>
							</span>
							<% } %>
						</span>
					</span>
				</p>  
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display current user log information">
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("time_occurred") %></th>
							<th scope="col"><%= messages.getString("login_id") %></th>
							<th scope="col"><%= messages.getString("user_type") %></th>
							<th scope="col"><%= messages.getString("action") %></th>
						</tr>
					</thead>
					<tbody>
						<%
							int numActions = 0;
							while (UserLogView_RS.next() && iReqCounter < iReqMax) { %>
								<tr>
									<td><%= UserLogView_RS.getTimeStamp("DATE_TIME") %></td>
									<td><%= UserLogView_RS.getString("LOGINID") %></td>
									<td><%= UserLogView_RS.getString("USER_TYPE") %></td>
									<td><%= UserLogView_RS.getString("ACTION") %></td>
								</tr>
						<%		numActions++;
								iReqCounter++; 
							}
						%>
					</tbody>
				</table>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>