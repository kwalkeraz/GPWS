<%  PrinterTools tool = new PrinterTools(); %>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print administer application settings"/>
	<meta name="Description" content="Global print website administer application settings" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("app_settings_results") %></title>
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
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=510"><%= messages.getString("app_settings") %></a></li>
			</ul>
		<h1><%= messages.getString("app_settings_results") %></h1>
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
<%
		int iReturnCode = tool.UpdatePassword(request);
		String logaction = request.getParameter("logaction");
		AppTools logtool = new AppTools();
		if (iReturnCode == 0) {
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
%>
			<%= messages.getString("app_settings_success") %>  <a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=510"><%= messages.getString("app_settings") %></a><br /><br />
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=510&logaction=<%=logaction%>"</script>
<%	
		} else { 
%>
			<%= messages.getString("app_settings_error") %>.<br /><br />
			<% 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR");
		   	  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
		      <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
		      <b><%= messages.getString("error_message") %></b>:<br />
			  <p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
		   <%}
		   catch( Exception e ) {}
		 	%>
<% 		}%>	
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>