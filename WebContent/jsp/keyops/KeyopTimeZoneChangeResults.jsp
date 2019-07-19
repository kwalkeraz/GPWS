<% if (request.getParameter("timezone") != null) { 
	session.setAttribute("zonecode", request.getParameter("timezone"));
	}
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, keyop time zone change results"/>
<meta name="Description" content="This page displays the results for when a keyop changes their time zone." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("resolve_and_close_ticket") %></title>
<%@ include file="metainfo2.jsp" %>

</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"> <%= messages.getString("keyop_page") %></a></li>
			</ul>
			<h1><%= messages.getString("result_update_profile") %></h1>
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
					<%
						KeyopTicket keyop = new KeyopTicket();
						
						boolean result = keyop.ChangeTimeZone(request);
						if (result == true) {
					 %>
						<%= messages.getString("success_update_profile") %><br /><br />
					<%	
						} else { 
					%>
						<%= messages.getString("error_update_profile") %><br /><br />
					<% } %>
					<a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("keyop_home") %></a>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>