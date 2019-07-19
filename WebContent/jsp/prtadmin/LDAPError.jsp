<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print LDAP error"/>
<meta name="Description" content="Global print website LDAP error message" />
<title><%= messages.getString("global_print_title") %> | <%= messages.getString("unknown_system_error") %></title>
<%@ include file="metainfo2.jsp" %>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
			<!-- LEADSPACE_BEGIN -->
			<div id="ibm-leadspace-head" class="ibm-alternate">
				<div id="ibm-leadspace-body">
					<h1><%= messages.getString("ldap_error") %></h1>
				</div> <!--  Leadspace-body -->
			</div> <!--  Leadspace-head -->
			<!-- LEADSPACE_END -->
			<%@ include file="nav.jsp" %>
	<!-- All the main body stuff goes here -->
	<div id="ibm-pcon">

		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<p><%= messages.getString("ldap_error_message") %></p>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>