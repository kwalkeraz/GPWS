<%  
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	TableQueryBhvr DriverSetConfigView  = (TableQueryBhvr) request.getAttribute("DriverSetConfig");
	TableQueryBhvrResultSet DriverSetConfigView_RS = DriverSetConfigView.getResults();
	boolean redirect = false;
%>
<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global print website driver set configuration"/>
<meta name="Description" content="Global print website driver set configuration results page" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_config_admin_results") %></title>
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=352"><%= messages.getString("driver_set_administer") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=380&driver_setid=<%= request.getParameter("driver_setid") %>&referer=<%= request.getParameter("referer") %>"><%= messages.getString("driver_set_config_admin") %></a></li>
			</ul>
			<h1><%= messages.getString("driver_set_config_admin_results") %></h1>
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
	tools.print.prtadmin.DriverSetConfigUpdate tools = new tools.print.prtadmin.DriverSetConfigUpdate();
	tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
	String driversetid = request.getParameter("driver_setid");
	String referer = request.getParameter("referer");
	String driversetconfigid = request.getParameter("driversetconfigid");
	String logaction = "";
	String driversetname = "";
	while (DriverSetConfigView_RS.next()) {
		driversetname = DriverSetConfigView_RS.getString("DRIVER_SET_NAME");
	} //while
	int iReturnCode = 0;
	if (driversetconfigid.equals("0")) {
		//Insert action
		iReturnCode = tools.insertDriverSetConfig(request);
		if (iReturnCode == 0) { 
			logaction = "Driver set configuration for driver set " + driversetname + " has been added";
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
			<p><%= logaction %></p>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=380&driver_setid=<%= request.getParameter("driver_setid") %>&referer=<%= request.getParameter("referer") %>&logaction=<%= logaction %>"</script>
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
		iReturnCode = tools.updateDriverSetConfig(request);
		if (iReturnCode == 0) { 
			logaction = "Driver set configuration for driver set " + driversetname + " has been updated";
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
			<p><%= logaction %></p>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=380&driver_setid=<%= request.getParameter("driver_setid") %>&referer=<%= request.getParameter("referer") %>&logaction=<%= logaction %>"</script>
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
<%	} //if else %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>