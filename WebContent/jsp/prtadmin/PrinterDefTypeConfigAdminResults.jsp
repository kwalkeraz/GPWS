<%@page import="tools.print.prtadmin.*" %>
<%  
%>
<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global print website printer definition type results"/>
<meta name="Description" content="Global print website administer printer definition type config resultse" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_def_type_config_admin_results") %></title>
<%@ include file="metainfo2.jsp" %>
	<script language="Javascript">
		function callMain() {
			document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250";
		}
	</script>
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=392"><%= messages.getString("printer_def_type_select") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=396&printerdeftypeid=<%= request.getParameter("printerdeftypeid") %>&referer=<%= request.getParameter("referer") %>"><%= messages.getString("printer_def_type_config_admin") %></a></li>
			</ul>
			<h1><%= messages.getString("printer_def_type_config_admin_results") %></h1>
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

<%
	PrinterDefTypeConfigUpdate tools = new PrinterDefTypeConfigUpdate();
	AppTools logtool = new AppTools();
	String printerdeftypeid = request.getParameter("printerdeftypeid");
	String referer = request.getParameter("referer");
	String serverdef = logtool.nullStringConverter(request.getParameter("serverdeftype"));
	String clientdef = logtool.nullStringConverter(request.getParameter("clientdeftype"));
	String printerdeftypeconfigid = logtool.nullStringConverter(request.getParameter("printerdeftypeconfigid"));
	String logaction = "";
	int iReturnCode = 0;
	if (printerdeftypeconfigid.equals("0")) {
		//Insert action
		iReturnCode = tools.insertPrinterDefTypeConfig(request);
		if (iReturnCode == 0) { 
			logaction = "Printer definition type configuration for " + serverdef + "/" + clientdef + " has been added";
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
			<p><%= logaction %></p>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=392&logaction=<%= logaction %>"</script>
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
		
	} else {
		iReturnCode = tools.updatePrinterDefTypeConfig(request);
		if (iReturnCode == 0) { 
			logaction = "Printer definition type configuration for " + serverdef + "/" + clientdef + " has been edited";
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
			<p><%= logaction %></p>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=392&logaction=<%= logaction %>"</script>
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
	} //if else
%>
	</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>