<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, request service results"/>
<meta name="Description" content="This page contains the results of the key operator request that was opened." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("request_service_results") %></title>
<%@ include file="metainfo2.jsp" %>

</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= statichtmldir %>/index.html"><%= messages.getString("global_print") %></a></li>
				<li><a href="<%= statichtmldir %>/USKeyOperatorServices.html"> <%= messages.getString("us_keyop_services") %></a></li>
				<li><a href="<%= keyops %>?next_page_id=2005"> <%= messages.getString("keyop_request_form") %></a></li>
			</ul>
			<h1><%= messages.getString("request_service_results") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
				
<% 
String sDevice = request.getParameter("devicename");
int iRC = Integer.parseInt(request.getParameter("rc"));
int iRC2 = Integer.parseInt(request.getParameter("rc2"));
String sRC2 = request.getParameter("rc2");

	if (iRC == 0) { %>
		<p><%= messages.getString("thanks_for_request") %><br /><br />
		<%= messages.getString("your_ticket_num") %>&nbsp;<%= iRC2 %>. <a href='<%= keyops %>?next_page_id=2015&amp;ticketno=<%= iRC2 %>'><%= messages.getString("view_ticket") %></a><br /><br />
		</p>
<%	} else if (iRC == 1) { %>
		<p><%= messages.getString("thanks_for_request_email_error") %><br /><br />
		<%= messages.getString("your_ticket_num") %>&nbsp;<%= iRC2 %>. <a href='<%= keyops %>?next_page_id=2015&amp;ticketno=<%= iRC2 %>'><%= messages.getString("view_ticket") %></a><br /><br />
		</p>
<%	} else if (iRC == 9 || iRC == 3) { %>
		<p><%= messages.getStringArgs("thanks_for_request_already_exists", new String[] {sDevice, iRC2 + ""}) %><br /><br />
		<%= messages.getString("your_ticket_num") %>&nbsp;<%= iRC2 %>. <a href='<%= keyops %>?next_page_id=2015&amp;ticketno=<%= iRC2 %>'><%= messages.getString("view_ticket") %></a><br />
		</p>
<%	} else { %>
		<p><%= messages.getString("open_ticket_error") %><br />
		</p>
<%	} %>

				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>