<%@page import="tools.print.lib.*, tools.print.commonprocess.*" %>
<%  
	//boolean windowOnLoad = false;
	//boolean redirect = false;
	TableQueryBhvr CPApproval  = (TableQueryBhvr) request.getAttribute("CPApproval");
    TableQueryBhvrResultSet CPApproval_RS = CPApproval.getResults();
    AppTools logtool = new tools.print.lib.AppTools();
	String cpapprovalid = logtool.nullStringConverter(request.getParameter("cpapprovalid"));
	String devicename = "";
	String action = "";
	String reqnum = "";
	String referer = logtool.nullStringConverter(request.getParameter("referer"));
	while (CPApproval_RS.next()) {
		reqnum = logtool.nullStringConverter(CPApproval_RS.getString("REQ_NUM"));
		devicename = logtool.nullStringConverter(CPApproval_RS.getString("DEVICE_NAME"));
		action = logtool.nullStringConverter(CPApproval_RS.getString("ACTION"));
	}

%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print routing template steps results"/>
	<meta name="Description" content="Global Print routing template steps results page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_select_routing_template_results") %></title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1105&devicename=<%= devicename %>&cpapprovalid=<%= cpapprovalid %>&referer=<%= referer %>&reqnum=<%= reqnum %>"><%= messages.getStringArgs("cp_manage_device", new String[] {action.toLowerCase(), devicename}) %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>"><%= messages.getString("cp_admin_routing_info") %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7450&cpapprovalid=<%= cpapprovalid %>"><%= messages.getString("cp_select_routing_template") %></a></li>
			</ul>
			<h1><%= messages.getString("cp_select_routing_template_results") %></h1>
		</div>
	</div>
	<%@ include file="../prtadmin/nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
<%
	UpdateRoutingTemplateInfo tools = new UpdateRoutingTemplateInfo();
	String cptemplateid = logtool.nullStringConverter(request.getParameter("cptemplateid"));
	String templatename = logtool.nullStringConverter(request.getParameter("templatename"));
	String logaction = "";
	int iReturnCode = 0;
		//Insert action
		iReturnCode = tools.insertTemplateSteps(request);
		if (iReturnCode == 0) { 
			logaction = "Routing template steps " + templatename + " for request " + reqnum + " has been added";
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "CommonProcess"); %>
			<p><%= logaction %></p>                                   
			<script type="text/javascript">self.location.href = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>&logaction=<%= logaction %>"</script>
<%		} else { 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
			  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
			  <%= messages.getString("user_results_error") %><br /><br />
			  <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br /> 
			  <b><%= messages.getString("error_message") %></b>:<br />
			  <p><a class="ibm-error-link" href="#"></a><%= errorMessage %></p>
<%
			} 
		   	catch( Exception e ) {}
		} //else	
%>
	</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>