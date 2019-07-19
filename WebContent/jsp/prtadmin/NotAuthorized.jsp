<%@ include file="metainfo.jsp" %>
<meta name="Description" content="Global print website access denied message page" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("access_denied") %></title>
<%@ include file="metainfo2.jsp" %>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
			<!-- LEADSPACE_BEGIN -->
			<div id="ibm-leadspace-head" class="ibm-alternate">
				<div id="ibm-leadspace-body">
					<ul id="ibm-navigation-trail">
						<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
					</ul>
					<h1><%= messages.getString("access_denied") %></h1>
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
					
					<p><%= messages.getString("no_access_to_this_page") %></p>
					<!-- ibm-content-main -->
				    <!-- FEATURES_END -->		
				    <!-- CONTENT_BODY_END -->
				</div><!--  END ibm-content-main -->
			</div><!--  END ibm-content-body -->
</div><!-- END ibm-content -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>