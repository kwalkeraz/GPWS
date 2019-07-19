<%
	PrinterTools tool = new PrinterTools();
	String[] sLoc = tool.getDeviceLocation(request.getParameter("name"));
	String OS = request.getParameter("os");
	String BrowVer = request.getParameter("browser");
	boolean isECPrint = tool.isECPrintDevice(request.getParameter("name"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print" />
	<meta name="Description" content="Global print website printer install error" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_install") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	
<script language="javascript">

function redirectPage() {
	var uRL = "index.html";
	var rc = '<%= request.getParameter("rc") %>';
	<% if (isECPrint) { %>
		uRL = "<%= tools.print.lib.CategoryTools.getCategoryValue1("ECPrint","PostInstallErrorRedirect") %>";
   <% } else { %>
	    if (rc == '2') {
	    	uRL = "<%= statichtmldir %>/ErrorWebPlugin2.html";
		} else if (rc == '3' ) {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin3.html";
		} else if (rc == '5') {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin5.html";
		} else if (rc == '6') {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin6.html";
		} else if (rc == '8') {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin8.html";
		} else if (rc == '126') {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin126.html";
		} else if (rc == '1722') {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin1722.html";
		} else if (rc == '1796') {
			uRL = "<%= statichtmldir %>/ErrorWebPlugin1796.html";
		} else {
			uRL = "<%= statichtmldir %>/WebInstallErrors.html";
		}
   <% } %>
   
   self.location.href = uRL;
	
}

dojo.ready(function() {
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
			<p><%= messages.getString("processing") %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>