<%  
	TableQueryBhvr ProtocolView  = (TableQueryBhvr) request.getAttribute("ProtocolView");
	TableQueryBhvrResultSet ProtocolView_RS = ProtocolView.getResults();
	tools.print.prtadmin.ServerUpdate tool = new tools.print.prtadmin.ServerUpdate();
	boolean windowOnLoad = false;
	boolean redirect = false;
	String action = request.getParameter("submitvalue");
	int locid = 0;
	if (request.getParameter("locid") != null) {
		locid = Integer.parseInt(request.getParameter("locid"));
	}
	//String locid = (String)request.getAttribute("locid");
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print admin server results"/>
	<meta name="Description" content="Global print website server administration results" />
	<title><%= messages.getString("title") %> | <%= messages.getString("server_results") %></title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %> </a></li>
				<% if (action.equals("insert")) { %>
					<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5000"><%= messages.getString("server_add") %> </a></li>
				<% } else {%>
					<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5010"><%= messages.getString("server_select_location") %> </a></li>
					<% if (request.getParameter("server") == null) {%>
						<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5021&sdc=<%= request.getParameter("sdc") %>"><%= messages.getString("server_select_edit_delete") %></a></li>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5030&serverid=<%= request.getParameter("serverid") %>&locid=<%= locid%>&referer=5021&sdc=<%= request.getParameter("sdc")%>" ><%= messages.getString("server_edit") %> </a></li>
					<% } else { %>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5022&server=<%= request.getParameter("server") %>"><%= messages.getString("server_select_edit_delete") %> </a> &#62;
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5030&serverid=<%= request.getParameter("serverid") %>&locid=<%= locid%>&referer=5022&server=<%= request.getParameter("server") %>" ><%= messages.getString("server_edit") %> </a></li>
					<% } %>
				<% } %>
			</ul>
		<h1><%= messages.getString("server_results") %></h1>
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
<%	tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
	String[] protocolArray = new String[ProtocolView_RS.getResultSetSize()];
	String referer = request.getParameter("referer");
	int counter = 0;
	//initialize the array with all protocol ID's
	if (ProtocolView_RS.getResultSetSize() > 0 ) {
		while(ProtocolView_RS.next()) {
			if (!ProtocolView_RS.getString("PROTOCOL_NAME").equals("DIPP") && !ProtocolView_RS.getString("PROTOCOL_NAME").equals("IBMDIPP")) {
				protocolArray[counter] = ProtocolView_RS.getString("PROTOCOL_NAME");
			} //not DIPP
			counter++;
		}  //while
	} //if
	String logaction = "";
	int iReturnCode = 0;
	if (action.equals("insert")) {
		iReturnCode = tool.insertServer(request,protocolArray);
		if (iReturnCode == 0) { 
		 	logaction = request.getParameter("logaction");
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
			<p><%= logaction %></p>
			<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5000&logaction=<%=logaction%>"</script>
<%			} else { 
			try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
		   	  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
		    <%= messages.getString("server_results_error") %><br /><br />
		    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
		    <%  if( theErrorID.equals("-803") ) { %>
			    <b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[]{request.getParameter("servername")}) %></p>
		    <% } else {%>
		  		<b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
		  	<% }
		   } 
		   catch( Exception e ) { System.out.println("The update failed for name " + request.getParameter("servername") + " with error " + e); }
		} //else
	} else {  //it's an update
		iReturnCode = tool.updateServer(request,protocolArray);
		if (iReturnCode == 0) { 
				logaction = request.getParameter("logaction");
				logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin"); %>
				<p><%= logaction %></p>
				<% if (!request.getParameter("sdc").equals("null")) {%>
					<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5021&sdc=<%= request.getParameter("sdc") %>&logaction=<%= logaction%>"</script>
				<% } else { %>
					<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5022&servername=<%= request.getParameter("servername") %>&logaction=<%= logaction%>"</script>
				<% } %>
				
<%		} else { 
			try {
			   	  String theErrorID = (String)request.getAttribute("ERROR"); 
				  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
			    <%= messages.getString("server_results_error") %><br /><br />
			    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
			    <%  if( theErrorID.equals("-803") ) { %>
				    <b><%= messages.getString("error_message") %></b>:<br />
				   	<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[] {request.getParameter("servername")}) %></p>
			    <% } else {%>
			  		<b><%= messages.getString("error_message") %></b>:<br />
				   	<p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
			  	<% }
			 } 
			 catch( Exception e ) {
			 	System.out.println("The update failed for server " + request.getParameter("servername") + " with error " + e);
			 }
		} //else
	} //else
 %>
 	</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>