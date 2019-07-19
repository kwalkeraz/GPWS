<%  
	TableQueryBhvr FTPName = (TableQueryBhvr) request.getAttribute("FTPName");
    TableQueryBhvrResultSet FTPName_RS = FTPName.getResults();
	PrinterTools tool = new PrinterTools(); 
	boolean windowOnLoad = false;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print administer download repository"/>
	<meta name="Description" content="Global print website administer download repository information results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("ftp_site_administration_results") %></title>
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
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=340"><%= messages.getString("ftp_site_administration") %></a></li>
			</ul>
			<h1><%= messages.getString("ftp_site_administration_results") %></h1>
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
	String action = request.getParameter("submitvalue");
	tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	
	if (action.equals("insert")) {	
	
		//Check to see if the loginid already exists, if so, return the user with an error
			String param = "";
			if (FTPName_RS.getResultSetSize() > 0) { 
				Enumeration e = request.getParameterNames();
				while (e.hasMoreElements()) {
					String name = (String)e.nextElement();
					String value = request.getParameter(name);
					if (!name.equals("ftppass") && !name.equals("confirmftppass")) {
						param = param + "&"+name+"="+value;
					} //if not password
				}
				param = param + "&nameexists=true";
		%>
				<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=344<%= param %>"</script>
		<%	}
		
		int iReturnCode = tool.InsertFTPPassword(request);
		if (iReturnCode == 0) {
		//logaction = "Download repository site " + request.getParameter("ftpsite") + " has been added";
		logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
%>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=340&logaction=<%=logaction%>"</script>
<%	
		} else { 
%>
			<%= messages.getString("ftp_results_error") %><br /><br />
			<% 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR");
		   	  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
		      <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
		    <% if( theErrorID.equals("-803") ) { %>
			    <b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[] {request.getParameter("ftpsite")}) %></p>
		  	<% } else {%>
		  		<b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
		  	<% } %>
		   <%}
		   catch( Exception e ) {}
		 	%>
<% 		}
	 } else {
	 	int iReturnCode = tool.UpdateFTPPassword(request);
		if (iReturnCode == 0) {
		//logaction = "Download repository site " + request.getParameter("ftpsite") + " has been edited";
		logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
%>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=340&logaction=<%=logaction%>"</script>
<%	
		} else { 
%>
			<%= messages.getString("ftp_results_error") %><br /><br />
			<% 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
			  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
		    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
		    <%  if( theErrorID.equals("-803") ) { %>
			    <b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[] {request.getParameter("ftpsite")}) %></p>
		    <% } else {%>
		  		<b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
		  	<% } %>
		  <% } 
		   catch( Exception e ) {}
		 	%>
<% 		}
	 	
	}
%>
</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>