	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print invalid message"/>
	<meta name="Description" content="Global print website invalid id error message page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("invalid_login") %></title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= printeradmin %>?next_page_id=1"><%= messages.getString("printer_admin_login_welcome") %></a></li>
			</ul>
			<h1><%= messages.getString("invalid_login") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<p><%= messages.getString("invalid_login_text") %> <%= messages.getString("believe_need_access") %></p>
			<a class="prtadmin-textlink" href="<%= printeradmin %>?next_page_id=1"><%= messages.getString("back_login") %></a>
			<div id='response'></div>
			<div id='errorMsg'></div>	
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>