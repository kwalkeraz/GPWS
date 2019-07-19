<%
	PrinterTools tool = new PrinterTools();
	String[] sLoc = tool.getDeviceLocation(request.getParameter("name"));
	String OS = request.getParameter("os");
	String BrowVer = request.getParameter("browser");
	boolean isECPrint = tool.isECPrintDevice(request.getParameter("name"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print" />
	<meta name="Description" content="Global print website printer install success" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_install") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	
<script language="javascript">

function redirectPage() {
   var uRL = "index.html";
   params = "to_page_id=30&name="+name+"&geo=<%= sLoc[0] %>&country=<%= sLoc[1] %>&state=<%= sLoc[2] %>&city=<%= sLoc[3] %>&building=<%= sLoc[4] %>&floor=<%= sLoc[5] %>&os=<%= OS %>&browser=<%= BrowVer %>";
   <% if (isECPrint) { %>
   		uRL = "<%= tools.print.lib.CategoryTools.getCategoryValue1("ECPrint","PostInstallRedirect") %>";
   <% } else { %>
   		uRL = "/tools/print/servlet/printeruser.wss?"+params;
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