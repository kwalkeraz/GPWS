<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopView_RS = AdminKeyopView.getResults();

	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	
	AppTools appTool = new AppTools();
	int sUserid = 0;
	sUserid = pupb.getUserID();
	int iVendorID = pupb.getVendorID();
	String[] sAuthTypes = pupb.getAuthTypes();
	boolean isKOSU = false;
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("Keyop Superuser")) {
			isKOSU = true;
		}
	}
	String sName = "";
	String sPager = "";
	String sEmail = "";
	String sLoginid = "";
	String sTimeZone = pupb.getTimeZone();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin keyop view"/>
<meta name="Description" content="<%= messages.getString("keyop_view_desc") %>" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_view") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.form.Form");

	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id', '');
		createHiddenInput('action','action', '');
		createHiddenInput('submitvalue','submitvalue', '');
		createHiddenInput('userid','userid', '');
		createHiddenInput('username','username', '');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');

		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>

	});

	function callDelete(userid,username) {
		var agree = confirm('<%= messages.getString("keyop_remove_check") %> ' + username + '?');
		if (agree) {
			document.theForm.username.value = username;
			document.theForm.userid.value = userid;
			document.theForm.next_page_id.value = "3026";
			document.theForm.submitvalue.value = "RemoveKeyop";
			document.theForm.submit();
		} 
	}

</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("Keyop_Admin_Home") %></a></li>  
			</ul>
			<h1><%= messages.getString("keyop_view") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<!-- All the main body stuff goes here -->
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
				<ul>
					<li><a href="<%= keyops %>?next_page_id=3010"><%= messages.getString("add_keyop") %></a></li>
				</ul>	
				<br />
				<% if (request.getParameter("msg") != null && request.getParameter("msg").equals("addkeyopsuccess")) { %>
				<p class="green-med-dark"><%= messages.getString("keyop_added_success") %></p>
				<% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("delkeyopsuccess")) { %>
				<p class="green-med-dark"><%= messages.getString("keyop_deleted_success") %></p>
				<% } %>
				<div id='response'></div>
				<div id='Keyop'>
					<div id='nextpageid'></div>
					<div id='action'></div>
					<div id='submitvalue'></div>
					<div id='userid'></div>
					<div id='username'></div>
					
					<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="A list of all keyops in the system.">
					<caption><em><%= messages.getString("all_keyops") %></em></caption>
					<thead>
						<tr>
							<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<% if (isKOSU) { %>
							<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("vendor_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<% } %>
							<th scope="col"><a href=""><span><%= messages.getString("pager") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<th scope="col"><a href=""><span><%= messages.getString("email") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("time_zone") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						int numKeyops = 0;
						while (AdminKeyopView_RS.next()) { 
							if (isKOSU == true || (isKOSU == false && iVendorID == AdminKeyopView_RS.getInt("VENDORID")) ) { %>
							<tr>
								<td scope="row"><a href="<%= keyops %>?next_page_id=3013&userid=<%= AdminKeyopView_RS.getInt("USERID") %>"><%= appTool.nullStringConverter(AdminKeyopView_RS.getString("LAST_NAME")) %>, <%= appTool.nullStringConverter(AdminKeyopView_RS.getString("FIRST_NAME")) %></a></td>
								<% if (isKOSU) { %>
								<td><%= appTool.nullStringConverter(AdminKeyopView_RS.getString("VENDOR_NAME")) %></td>
								<% } %>
								<td><%= appTool.nullStringConverter(AdminKeyopView_RS.getString("PAGER")) %></td>
								<td><%= appTool.nullStringConverter(AdminKeyopView_RS.getString("EMAIL")) %></td>
								<td><%= appTool.nullStringConverter(AdminKeyopView_RS.getString("TIME_ZONE")) %></td>
								<td align="center">
									<a class="ibm-cancel-link" href="javascript:callDelete('<%= AdminKeyopView_RS.getInt("USERID") %>','<%= appTool.nullStringConverter(AdminKeyopView_RS.getString("FIRST_NAME")) %> <%= appTool.nullStringConverter(AdminKeyopView_RS.getString("LAST_NAME")) %>')" ><%= messages.getString("delete") %></a>
								</td>
							</tr>
					<%		numKeyops++; 
							}
						}
					%>
					</tbody>
					</table>
				</div> <!-- END KEYOP FORM DIV -->
				<%	if (numKeyops == 0) {			
				%>
						<p><%= messages.getString("sorry_no_keyops_found") %></p>
				<%	} else { %>
						
						<p><%= numKeyops %> <%= messages.getString("keyops_found") %></p>
				<%	}
				%>

				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>