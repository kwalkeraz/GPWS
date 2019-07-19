<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminView_RS = AdminView.getResults();

	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String error = appTool.nullStringConverter(request.getParameter("error"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin view"/>
<meta name="Description" content="This page allows admins to view the system administrators." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_admin_admin") %></title>

<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.form.Form");

	function callEdit(userid) {
		dojo.byId("userid").value = userid;
		dojo.byId("next_page_id").value = '3023';
		dojo.byId("submitvalue").value = 'Edit';
		dojo.byId("theForm").submit();
	}
	function callDelete(userid,username,authname) {
		YesNo = confirm('<%= messages.getString("admin_delete_check") %>: ' + username + '?');
		if (YesNo == true) {
			dojo.byId("userid").value = userid;
			dojo.byId("authname").value = authname;
			dojo.byId("next_page_id").value = '3026';
			dojo.byId("submitvalue").value = 'RemoveAdmin';
			dojo.byId("theForm").submit();
		} else {
			return false;
		}
	}
	
	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id', '3026');
		createHiddenInput('useridloc','userid','');
		createHiddenInput('submitvalueloc','submitvalue','EditAdmin');
		createHiddenInput('authnameloc','authname','');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		
		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
		
		<%if (!error.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-error-link'></a>"+"<%= error %>"+"<br /></p>";
		<% } %>
	});
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
			<h1><%= messages.getString("keyop_admin_admin") %></h1>
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
	<li><a href="<%= keyops %>?next_page_id=3020"><%= messages.getString("add_admin") %></a></li>
</ul>
<br />
<div id="response"></div>
<div id='Keyop'>
	<div id='nextpageid'></div>
	<div id='useridloc'></div>
	<div id='submitvalueloc'></div>
	<div id='authnameloc'></div>
</div>
			<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="A list of admins in the keyop request system.">
				<caption><em><%= messages.getString("Keyop_Admins") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("name") %></th>
							<th scope="col"><%= messages.getString("email") %></th>
							<th scope="col"><%= messages.getString("loginid") %></th>
							<th scope="col"><%= messages.getString("admin_type") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
<%
	int numAdmins = 0;
	int shading = 0;
	while (AdminView_RS.next()) { 
	
		int iUserid = AdminView_RS.getInt("USERID");
		String sName = appTool.nullStringConverter(AdminView_RS.getString("LAST_NAME")) + ", " + appTool.nullStringConverter(AdminView_RS.getString("FIRST_NAME"));
		String sEmail = appTool.nullStringConverter(AdminView_RS.getString("EMAIL"));
		String sLoginid = appTool.nullStringConverter(AdminView_RS.getString("LOGINID"));
		String sAuthName = appTool.nullStringConverter(AdminView_RS.getString("AUTH_NAME")); %>
		
			<tr>
				<td><a href="javascript:callEdit('<%= iUserid %>')"><%= sName %></a></td>
				<td><%= sEmail %></td>
				<td><%= sLoginid %></td>
				<td><%= sAuthName %></td>
				<td><center><a class="ibm-cancel-link" href="javascript:callDelete('<%= iUserid %>','<%= sName %>','<%= sAuthName %>')" ><%= messages.getString("delete") %></a></center></td>
			</tr>
<%		numAdmins++; 
	} %>
	</tbody>
	</table>
<%
	if (numAdmins == 0) {			
%>
		<p><%= messages.getString("sorry_no_admins_found") %></p>
<%	} else { %>
		
		<p><br /><br /><%= numAdmins %> <%= messages.getString("admins_found") %>.</p>
<%	}
%>

				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>