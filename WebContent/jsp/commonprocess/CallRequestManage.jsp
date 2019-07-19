<%
	TableQueryBhvr RequestView = (TableQueryBhvr) request.getAttribute("CPApproval");
	TableQueryBhvrResultSet RequestView_RS = RequestView.getResults();
	String action = "";
	String reqnum = "";
	String devicename = "";
	String reqstatus = "";
	String devicetype = "";
	int cpapprovalid = 0;
	if (RequestView_RS.next()) {
		cpapprovalid = RequestView_RS.getInt("CPAPPROVALID");
		action = RequestView_RS.getString("ACTION");
		reqnum = RequestView_RS.getString("REQ_NUM");
		devicename = RequestView_RS.getString("DEVICE_NAME");
		reqstatus = RequestView_RS.getString("REQ_STATUS");
		//devicetype = RequestView_RS.getString("DEVICETYPE");
	}
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print workflow results page"/>
	<meta name="Description" content="Global Print Website common process workflow results page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_request_results") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

	<script type="text/javascript">
	 dojo.require("dojo.parser");
	
	function callRequest(devicename,cpapprovalid,referer,reqnum) {
		var params ="&devicename=" + devicename + "&cpapprovalid=" + cpapprovalid + "&referer=" + referer + "&reqnum=" + reqnum;
		var targettype = "1105";
		
		var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=" + targettype + params;
		document.location.href = uRL;
	} //callRequest
	
	function callReturn() {
		var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=1805";
		document.location.href = uRL;
	} //callReturn
<%
	String actionVal = action;
	if (actionVal == "") {
		reqnum = request.getParameter("reqnum");
%>
		alert("Request "+"<%= reqnum %>"+" was not found");
		callReturn();
<%
	} else {
%>
		callRequest("<%= devicename %>","<%= cpapprovalid %>",'<%= request.getParameter(BehaviorConstants.TOPAGE) %>',"<%= reqnum %>");
<% } %>
	</script>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp"%>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
			</ul>
			<h1>
				<%= messages.getString("device_request_results") %>
			</h1>
		</div>
	</div>
	<%@ include file="../prtadmin/nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<!-- LEADSPACE_BEGIN -->
		<!-- ADDITIONAL_INFO_BEGIN -->
		<!-- ADDITIONAL_INFO_END -->
		<!-- CONTENT_BODY_END -->
		</div>
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>