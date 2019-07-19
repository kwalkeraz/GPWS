<%@page import = "java.sql.*,java.util.*,java.io.*,java.net.*" %>
<%
	PrinterTools tool = new PrinterTools(); 
	String Command = tool.nullStringConverter(request.getParameter("SqlCommand"));	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print sql command results"/>
	<meta name="Description" content="Global print website execute an sql command results page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("sql_command_results") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=700"><%= messages.getString("sql_command") %></a></li>
			</ul>
			<h1><%= messages.getString("sql_command_results") %></h1>
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

<%  tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
	String result = (String)request.getAttribute("RESULT"); 
	int rs = 0;
	try {
		rs = Integer.parseInt(result);
	} catch (Exception e) {
		rs = -1;
	} //try and catch
	String theErrorID = (String)request.getAttribute("ERROR"); 
	String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); 
	String logaction = request.getParameter("logaction");
%>

<% if (rs > 0) { %>
	<% logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
	<%= messages.getStringArgs("sql_command_executed", new String[]{Command})%>
<% } else { %>
	<%= messages.getString("sql_command_error") %>: <br />
	<%= messages.getStringArgs("sql_command_not_executed", new String[]{Command})%><br />
	<% if ((theErrorID != null) && (errorMessage != null)) { %>
		<br />
		<b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />
		<b><%= messages.getString("error_message") %></b>:<br />
		<p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
	<% } %>
<% } %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>