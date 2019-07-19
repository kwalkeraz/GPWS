<%  
	TableQueryBhvr AuthTypes = (TableQueryBhvr) request.getAttribute("AuthTypes");
    TableQueryBhvrResultSet AuthTypes_RS = AuthTypes.getResults();
    TableQueryBhvr AuthGroups = (TableQueryBhvr) request.getAttribute("AuthGroups");
    TableQueryBhvrResultSet AuthGroups_RS = AuthGroups.getResults();
    TableQueryBhvr UserLogin = (TableQueryBhvr) request.getAttribute("UserLogin");
    TableQueryBhvrResultSet UserLogin_RS = UserLogin.getResults();
    AppTools appTool = new AppTools();
	tools.print.prtadmin.UserEdit tool = new tools.print.prtadmin.UserEdit();
	boolean windowOnLoad = false;
	boolean redirect = false;
	String suserid = appTool.nullStringConverter(request.getParameter("userid"));
	int userid = 0;
	if (!suserid.equals("")) {
		userid = Integer.parseInt(suserid);
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print administer GPWS administrator"/>
	<meta name="Description" content="Global print website add/modify administrator results" />
	<title><%= messages.getString("title") %> | <%= messages.getString("administrator_results") %></title>
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
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332"><%= messages.getString("administer_gpws_admin") %></a></li>
				<% if (userid == 0 ) { %>
					<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=330&userid=<%= userid %>"><%= messages.getString("admin_add_info") %></a></li>
				<% } else { %>
					<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=330&userid=<%= userid %>"><%= messages.getString("admin_edit_info") %></a></li>
				<% } %>
			</ul>
		<h1><%= messages.getString("administrator_results") %></h1>
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
	SendMail mail = new SendMail();
	String action = appTool.nullStringConverter(request.getParameter("submitvalue"));
	String firstname = appTool.nullStringConverter(request.getParameter("firstname"));
	String lastname = appTool.nullStringConverter(request.getParameter("lastname"));
	String email = appTool.nullStringConverter(request.getParameter("email"));
	String loginid = appTool.nullStringConverter(request.getParameter("loginid"));
	//AuthGroups_RS = AuthGroups.getResults();
	String authgroup = "";
	String authgrouptype = "";
	String sgroupauth = "";
	int[] GroupArray = new int[AuthGroups_RS.getResultSetSize()];
	int[] authgroupArray = new int[AuthGroups_RS.getResultSetSize()];
	String[] GroupName = new String[AuthGroups_RS.getResultSetSize()];
	int x = 0;  //a counter
	while (AuthGroups_RS.next()) {
		authgroup = AuthGroups_RS.getString("AUTH_GROUP");
		if (authgroup != null) {
			GroupName[x] = authgroup;
			authgrouptype = appTool.nullStringConverter(request.getParameter(authgroup.toLowerCase()+"authtypeid"));
			int authgrouptypeid = 0;
			if (!authgrouptype.equals("")) {
				authgrouptypeid = Integer.parseInt(authgrouptype);
			}
			authgroupArray[x] = authgrouptypeid;
			sgroupauth = appTool.nullStringConverter(request.getParameter(authgroup+"Auth"));
			int Groupauth = 0;
			if (!sgroupauth.equals("")) {
				Groupauth = Integer.parseInt(sgroupauth);
			}
			GroupArray[x] = Groupauth;
			x++;
		} //if not null
	} //while AuthGroups
	
		tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
		String logaction = "";
		int iReturnCode = 0;
		if (action.equals("insert")) {	
			//Check to see if the loginid already exists, if so, return the user with an error
			String param = "";
			if (UserLogin_RS.getResultSetSize() > 0) { 
				Enumeration e = request.getParameterNames();
				while (e.hasMoreElements()) {
					String name = (String)e.nextElement();
					String value = request.getParameter(name);
					if (!name.equals("userpasswd") && !name.equals("confirmpasswd")) {
						param = param + "&"+name+"="+value;
					} //if not password
				}
				param = param + "&loginexists=true";
		%>
				<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=330<%= param %>"</script>
		<%	}
			if (param.equals("")) { 
				iReturnCode = tool.insertUser(request);
			} else {
				iReturnCode = 1;
			}
			if (iReturnCode == 0) {
				String sUserID = (String)request.getAttribute("userid");
			 	int UserID = Integer.parseInt(sUserID); 
			%>
			<p><a class='ibm-confirm-link' href='#'></a><%= messages.getStringArgs("user_added", new String[]{loginid}) %></p>
			<%	//update the authority
			for (int z=0; z < GroupArray.length; z++) {
				if (authgroupArray[z] == 0 && GroupArray[z] != 0) {
		 		iReturnCode = tool.insertAuth(request, GroupArray[z], UserID); 
		 		if (iReturnCode == 0) { 
		 			String[] sURLs = tool.getEmailURLs();
		 			mail.sendMail(email, "New Global Print (GPWS) userid created for you", "You have been granted \"" + tool.getAuthType(GroupArray[z]) + "\" access to the administrative section of GPWS on the following production and test systems.  Please use your intranet ID and password to log in.\n\n" + sURLs[0] + "\n\n" + sURLs[1] + "\n\n" + sURLs[2]); %>
					<p><a class='ibm-confirm-link' href='#'></a><%= messages.getStringArgs("authorization_updated", new String[]{GroupName[z],loginid}) %></p>
				<% } else { 
					   try {
					   	  String theErrorID = (String)request.getAttribute("ERROR"); 
						  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
					    <%= messages.getString("user_results_error") %><br /><br />
					    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
					    <%  if( theErrorID.equals("-803") ) { %>
						    <b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[]{loginid}) %></p>
					    <% } else {%>
					  		<b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
					  	<% }
					   } 
					   catch( Exception e ) {}
					} //else
		 		} //if GroupArray !=0
		 	} //for loop 
				
			logaction = "Administrator " + request.getParameter("loginid") + " has been added";
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
	%>
				<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=330&userid=0&logaction=<%=logaction%>"</script>
	<%	
			} else { //return code is not 0
	%>
				<%= messages.getString("user_results_error") %><br /><br />
				<% 
			   try {
			   	  String theErrorID = (String)request.getAttribute("ERROR");
			   	  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
			      <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
			    <% if( theErrorID.equals("-803") ) { %>
				    <b><%= messages.getString("error_message") %></b>:<br />
				   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_loginid_exists", new String[]{loginid}) %></p>
			  	<% } else {%>
			  		<b><%= messages.getString("error_message") %></b>:<br />
				   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
			  	<% } %>
			   <%}
			   catch( Exception e ) {}
			 	%>
	<% 		}
		 } else {  //it's a user update
		 	//first, update user settings
		 	iReturnCode = tool.editUser(request);
		 	if (iReturnCode == 0) { %>
				<p><a class='ibm-confirm-link' href='#'></a><%= messages.getStringArgs("user_updated", new String[]{loginid}) %></p>
			<%	logaction = "Administrator " + loginid + " has been updated";
				logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
				redirect = true; %>
			<% } else if (iReturnCode == 2) { 
					redirect = true; %>
					<p><%= messages.getStringArgs("no_user_updates", new String[]{loginid}) %></p>
			<% } else {
					redirect = false;  
				   try {
				   	  String theErrorID = (String)request.getAttribute("ERROR"); 
					  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
				    <%= messages.getString("user_results_error") %><br /><br />
				    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
				    <%  if( theErrorID.equals("-803") ) { %>
					    <b><%= messages.getString("error_message") %></b>:<br />
					   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_loginid_exists", new String[]{loginid}) %></p>
				    <% } else {%>
				  		<b><%= messages.getString("error_message") %></b>:<br />
					   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
				  	<% }
				   } 
				   catch( Exception e ) {}
			}
		 	for (int z=0; z < GroupArray.length; z++) {
		 	//now let's update the authorization
		 	if (authgroupArray[z] != 0 && GroupArray[z] == 0) {
		 		iReturnCode = tool.deleteAuth(request, authgroupArray[z], GroupArray[z], userid); %>
		 		<%if (iReturnCode == 0) { %>
					<p><a class='ibm-confirm-link' href='#'></a><%= messages.getStringArgs("authorization_updated", new String[]{GroupName[z],loginid}) %></p>
				<%	logaction = "Administrator " + loginid + " has been updated";
					logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");  %>
				<% 	if (redirect == true) {
						redirect = true;
					}
					} else {  
						redirect = false;
					   try {
					   	  String theErrorID = (String)request.getAttribute("ERROR"); 
						  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
					    <p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_authorization_update", new String[]{GroupName[z]}) %></p>
					    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
					    <%  if( theErrorID.equals("-803") ) { %>
						    <b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_loginid_exists", new String[]{loginid}) %></p>
					    <% } else {%>
					  		<b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
					  	<% }
					   } 
					   catch( Exception e ) {}
					}
		 	 	} 
		 	
		 	if (authgroupArray[z] == 0 && GroupArray[z] != 0) {
		 		iReturnCode = tool.insertAuth(request, GroupArray[z], userid); %>
		 		<%if (iReturnCode == 0) { %>
					<p><a class='ibm-confirm-link' href='#'></a><%= messages.getStringArgs("authorization_updated", new String[]{GroupName[z],loginid}) %></p>
					<%	logaction = "Administrator " + loginid + " has been updated";
					logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
					String[] sURLs = tool.getEmailURLs();
		 			mail.sendMail(email, "Global Print (GPWS) authorization updated", "You have been granted \"" + tool.getAuthType(GroupArray[z]) + "\" access to the administrative section of GPWS on the following system.  Please use your intranet ID and password to log in.\n\n" + sURLs[0] + "\n\n" + sURLs[1]); %>
				<% 	if (redirect == true) {
						redirect = true;
					}
					} else { 
						redirect = false;
					   try {
					   	  String theErrorID = (String)request.getAttribute("ERROR"); 
						  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
					    <p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_authorization_update", new String[]{GroupName[z]}) %></p>
					    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
					    <%  if( theErrorID.equals("-803") ) { %>
						    <b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_loginid_exists", new String[]{loginid}) %></p>
					    <% } else {%>
					  		<b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
					  	<% }
					   } 
					   catch( Exception e ) {}
					}
		 	} 
	
			if (authgroupArray[z] !=0 && GroupArray[z] !=0) {
		 		iReturnCode = tool.editAuth(request, authgroupArray[z], GroupArray[z], userid); %>
				<%if (iReturnCode == 0) { %>
					<p><a class='ibm-confirm-link' href='#'></a><%= messages.getStringArgs("authorization_updated", new String[]{GroupName[z],loginid}) %></p>
					<%	logaction = "Administrator " + request.getParameter("loginid") + " has been updated";
					logtool.logUserAction(pupb.getUserLoginID(), logaction, "GPWSAdmin");
					String[] sURLs = tool.getEmailURLs();
		 			mail.sendMail(email, "Global Print (GPWS) authorization updated", "You have been granted \"" + tool.getAuthType(GroupArray[z]) + "\" access to the administrative section of GPWS on the following system.  Please use your intranet ID and password to log in.\n\n" + sURLs[0] + "\n\n" + sURLs[1]);
					if (redirect == true) {
						redirect = true;
					} %>
				<% } else if (iReturnCode == 2) { %>
					<p><%= messages.getStringArgs("no_authorization_update", new String[]{GroupName[z],loginid}) %></p>
					<% 	if (redirect == true) {
							redirect = true;
						}
					} else {
						redirect = false;
					   try {
					   	  String theErrorID = (String)request.getAttribute("ERROR"); 
						  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
					    <p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_authorization_update", new String[]{GroupName[z]}) %></p>
					    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
					    <%  if( theErrorID.equals("-803") ) { %>
						    <b><%= messages.getString("error_message") %></b>:<br />
						   		<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_loginid_exists", new String[]{loginid}) %></p>
					    <% } else {%>
					  		<b><%= messages.getString("error_message") %></b>:<br />
						   	<p class="ibm-error"><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
					  	<% }
					   } 
					   catch( Exception e ) {}
					}
				} //if authgrouptype !=0 and groupauth !=0
			} //for loop
			if (redirect == true) { %>
				<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332&logaction=<%=logaction%>"</script>
		<%	} //if true
		}  //else it's an update 
	 %>
	</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>