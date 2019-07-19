<%
	PrinterTools tool = new PrinterTools();
	AppTools appTool = new AppTools();
	
	String[] sLoc = tool.getDeviceLocation(request.getParameter("device"));
	boolean isECPrint = tool.isECPrintDevice(request.getParameter("device"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print printer install" />
	<meta name="Description" content="Global print website printer install" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_install") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/OSBrowserCheck.js"></script>
	
<script language="javascript">
// Find the user's OS and browser
var OS, Browser, BVersion, BrowVer;

function setVariables() {
	OS = getOSVersion();
	Browser = getBrowser();
	BVersion = getBVersion();
	BrowVer = Browser + " " + BVersion;
	return true;
}

function redirectPage() {
	var name = "<%= request.getParameter("device") %>";
	var rc = "<%= request.getParameter("rc") %>";
	var params = "";

	if (rc != null && rc != "" && rc == "0") { // Successful install
		params = "to_page_id=40a&name="+name+"&geo=<%= sLoc[0] %>&country=<%= sLoc[1] %>&state=<%= sLoc[2] %>&city=<%= sLoc[3] %>&building=<%= sLoc[4] %>&floor=<%= sLoc[5] %>&os="+OS+"&browser="+BrowVer+"&rc="+rc;
		var uRL = "/tools/print/servlet/printeruser.wss?"+params;
		self.location.href = uRL;
	} else if (rc != null && rc != "" && rc == "-1") { // User canceled install
		var uRL = "index.html";
		params = "to_page_id=30&name="+name+"&geo=<%= sLoc[0] %>&country=<%= sLoc[1] %>&state=<%= sLoc[2] %>&city=<%= sLoc[3] %>&building=<%= sLoc[4] %>&floor=<%= sLoc[5] %>&os="+OS+"&browser="+BrowVer+"&rc="+rc;
		<% if (isECPrint) { %>
			 uRL = "<%= tools.print.lib.CategoryTools.getCategoryValue1("ECPrint","CancelInstallRedirect") %>";
		<% } else { %>			
			 uRL = "/tools/print/servlet/printeruser.wss?"+params;
		<% } %>
		self.location.href = uRL;
	} else { // Error code returned by plugin/object
		params = "to_page_id=30a&name="+name+"&geo=<%= sLoc[0] %>&country=<%= sLoc[1] %>&state=<%= sLoc[2] %>&city=<%= sLoc[3] %>&building=<%= sLoc[4] %>&floor=<%= sLoc[5] %>&os="+OS+"&browser="+BrowVer+"&rc="+rc;
		var uRL = "/tools/print/servlet/printeruser.wss?"+params;
		self.location.href = uRL;
	}
}

dojo.ready(function() {
	setVariables();
	redirectPage();
});

</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("printer_install") %></h1>
		</div>
	</div>
	<%@ include file="../prtadmin/nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<p><%= messages.getString("checking_workstation") %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>