<%
	AppTools tool = new AppTools();

	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String topageid = tool.nullStringConverter(request.getParameter("to_page_id"));
	
	
	if (topageid.equals("5026")) {
		// Add Equitrac servers to DB
		String[] esIDs = request.getParameterValues("servers");
		String sVPSXID = request.getParameter("serverid");
		int vpsxID = Integer.parseInt(request.getParameter("serverid"));
		int rc = tools.print.prtadmin.ServerUpdate.insertEquitracServer(esIDs, vpsxID);
		if (rc != 0) {
			logaction = "An error occurred and the server was not added. Please try your request again.";
		}
	} else if (topageid.equals("5027")) {
		// Add Equitrac countries to DB
		String[] sCountries = request.getParameterValues("country");
		String sVPSXID = request.getParameter("serverid");
		int vpsxID = Integer.parseInt(request.getParameter("serverid"));
		int rc = tools.print.prtadmin.ServerUpdate.insertCountries(sCountries, vpsxID);
		if (rc != 0) {
			logaction = "An error occurred and the country was not added. Please try your request again.";
		}
	} else if (topageid.equals("284")) {
		// Update device languages
		String[] sDevLang = request.getParameterValues("devdislangE");
		int deviceID = Integer.parseInt(request.getParameter("deviceidLang"));
		int rc = tools.print.prtadmin.DeviceUpdate.updateDeviceLang(sDevLang,deviceID);
		if (rc != 0) {
			logaction = "An error occurred and the languages were not updated. Please try your request again.";
		}
	}
	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print admin results"/>
	<meta name="Description" content="Global print website results page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("results") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("results") %></h1>
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
				<%= logaction %>
			</p>
		<!-- LEADSPACE_END -->
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>