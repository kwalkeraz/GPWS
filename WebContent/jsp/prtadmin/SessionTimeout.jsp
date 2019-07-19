	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print session time out"/>
	<meta name="Description" content="Global print website session timed out page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("session_timed_out") %></title>
	<%@ include file="metainfo2.jsp" %>
	<script type="text/javascript">
// 	 dojo.require("dojo.parser");
// 	 dojo.ready(function() {
<%-- 	 	alert("<%= messages.getString("session_timed_out_info") %>"); --%>
// 	 });
	 
	</script>
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
			<h1><%= messages.getString("session_timed_out") %></h1>
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
			<p>
				<%= messages.getString("session_timed_out_info") %> <br /> 
				<%= messages.getString("session_redirect_info") %> <a href="<%= printeradmin %>?next_page_id=1"><%= messages.getString("click_here_close") %></a> <%= messages.getString("session_redirect_info_2") %>
			</p>
			
			<meta http-equiv="Refresh" content="0; url=<%= printeradmin %>?next_page_id=1&e=sto" />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>			
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>