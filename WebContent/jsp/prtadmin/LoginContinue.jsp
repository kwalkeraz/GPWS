	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print login continue"/>
	<meta name="Description" content="Global print website administration login continue" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("GPWS_administration") %></title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("please_wait_authenticating") %></h1>
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
			<div class="ibm-columns">
				<div class="ibm-col-6-1">&nbsp;</div>
				<div class="ibm-col-6-1">&nbsp;</div>
				<div class="ibm-col-6-1">
					<p><%= messages.getString("please_wait_authenticating") %></p>
					<p class="ibm-spinner-large"></p>
					<script language="javascript">
					<!--
						document.location.href = "<%= prtgateway %>"+"?"+"<%= BehaviorConstants.TOPAGE %>"+"=250";
					//-->
				</script>
				</div>
				<div class="ibm-col-6-1">&nbsp;</div>
				<div class="ibm-col-6-1">&nbsp;</div>
				<div class="ibm-col-6-1">&nbsp;</div>
			</div>
		<!-- CONTENT_BODY_END -->
		</div>
	</div>
	<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>