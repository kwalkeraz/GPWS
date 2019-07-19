<%
	AppTools tool = new AppTools();

	java.text.NumberFormat number = java.text.NumberFormat.getNumberInstance();
	number = new java.text.DecimalFormat("###,##0");
   
   	int iGray = 0;
	DateTime dateTime = new DateTime();
	PrinterLog prtLog = new PrinterLog();
	
	String[] values = new String[7];
	values[1] = tool.nullStringConverter(request.getParameter("name"));
	values[2] = tool.nullStringConverter(request.getParameter("geo"));
	values[3] = tool.nullStringConverter(request.getParameter("country"));
	values[4] = tool.nullStringConverter(request.getParameter("city"));
	values[5] = tool.nullStringConverter(request.getParameter("building"));
	values[6] = tool.nullStringConverter(request.getParameter("floor"));
	
	String[] iBrowser = prtLog.getBrowser();
	String[] iOS = prtLog.getOS();
	if (values[1] != null && !values[1].equals("") && !values[1].equals("null")) {
		values[0] = "device";
	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null") && values[4] != null && !values[4].equals("") && !values[4].equals("null") && values[5] != null && !values[5].equals("") && !values[5].equals("null") && values[6] != null && !values[6].equals("") && !values[6].equals("null")) {
		values[0] = "floor";
	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null") && values[4] != null && !values[4].equals("") && !values[4].equals("null") && values[5] != null && !values[5].equals("") && !values[5].equals("null")) {
		values[0] = "building";
	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null") && values[4] != null && !values[4].equals("") && !values[4].equals("null")) {
		values[0] = "site";
	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null")) {
		values[0] = "country";
	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null")) {
		values[0] = "geo";
	} else {
		values[0] = "all";
	}
	prtLog.getInstallData(values);
	int[] iBrowserSuccess = prtLog.getBrowserSuccess();
	int[] iBrowserFail = prtLog.getBrowserFail();
	int[] iOSSuccess = prtLog.getOSSuccess();
	int[] iOSFail = prtLog.getOSFail();
	String[][] data = prtLog.getData();
	
	int count = 0; //iBrowser[0] + iBrowser[1] + iBrowser[2] + iBrowser[3] + iBrowser[4] + iBrowser[5];
	int success = 0;
	int fail = 0;
	for (int x = 0; x < iBrowser.length; x++) {
		success += iBrowserSuccess[x];
		fail += iBrowserFail[x];
	}
	count = success + fail;
	
	String name = tool.nullStringConverter(request.getParameter("name"));
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    String geoURL = tool.nullStringConverter(request.getParameter("geo"));
	String countryURL = tool.nullStringConverter(request.getParameter("country"));
	String cityURL = tool.nullStringConverter(request.getParameter("city"));
	String buildingURL = tool.nullStringConverter(request.getParameter("building"));
	String floorURL = tool.nullStringConverter(request.getParameter("floor"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	String deviceid = tool.nullStringConverter(request.getParameter("deviceid"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website install report"/>
	<meta name="Description" content="Global print website device installation report" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_install_report") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createChart.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dojox.charting.Chart2D");
	 dojo.require("dojox.charting.action2d.Tooltip");
	 dojo.require("dojox.charting.action2d.MoveSlice");
	 dojo.require("dojox.charting.themes.Claro");
	 	 
	function getOSData(){
		var chartData = [];
		<% for (int j = 0; j < iOSSuccess.length; j++) { %>
			chartData[<%=j%>] = {y: <%= iOSSuccess[j] + iOSFail[j] %>,tooltip: "<%= iOS[j].replace(":"," ") %>"};
		<% } %>
		console.log(chartData);
		return chartData;
	} //getData
	
	function getBrowserData() {
		var chartData = [];
		<% for (int j = 0; j < iBrowser.length; j++) { %>
			chartData[<%=j%>] = {y: <%= iBrowserSuccess[j] + iBrowserFail[j] %>,tooltip: "<%= iBrowser[j]%>"};
		<% } %>
		console.log(chartData);
		return chartData;
	} //getBrowserData

	dojo.ready(function() {
		var chartDataOS = getOSData();
		var chartDataBrowser = getBrowserData();
		createPieChart("chartNodeOS",chartDataOS);
		createPieChart("chartNodeBrowser",chartDataBrowser);
	});
    </script>
    
    </head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<% if (referer.equals("283")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=282&<%=PrinterConstants.SEARCH_NAME %>=<%= name %>%"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=283&<%=PrinterConstants.SEARCH_NAME %>=<%= name %>%"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("432")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("431")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("430")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("2802")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=520"><%= messages.getString("tableselect_reports_admin") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=2802"><%= messages.getString("device_install_report") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("device_install_report") %> </h1>
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
		<%if (values[1] != null && !values[1].equals("") && !values[1].equals("null")) { %>
			<h2><%= messages.getString("device") %>: <%= values[1] %></h2>
		<%	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null") && values[4] != null && !values[4].equals("") && !values[4].equals("null") && values[5] != null && !values[5].equals("") && !values[5].equals("null") && values[6] != null && !values[6].equals("") && !values[6].equals("null")) { %>
			<h2><%= messages.getString("floor") %>: <%= values[6] %> in building <%= values[5] %> in <%= values[4] %>, <%= values[3] %></h2>
		<%	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null") && values[4] != null && !values[4].equals("") && !values[4].equals("null") && values[5] != null && !values[5].equals("") && !values[5].equals("null")) { %>
			<h2><%= messages.getString("building") %>: <%= values[5] %> in <%= values[4] %>, <%= values[3] %></h2>
		<%	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null") && values[4] != null && !values[4].equals("") && !values[4].equals("null")) { %>
			<h2><%= messages.getString("site") %>: <%= values[4] %>, <%= values[3] %></h2>
		<%	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null") && values[3] != null && !values[3].equals("") && !values[3].equals("null")) { %>
			<h2><%= messages.getString("country") %>: <%= values[3] %></h2>
		<%	} else if (values[2] != null && !values[2].equals("") && !values[2].equals("null")) { %>
			<h2><%= messages.getString("geo") %>: <%= values[2] %></h2>
		<%	} else { %>
			<h2><%= messages.getString("device") %>: <%= messages.getString("all_devices") %></h2>
		<%	} %>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>

				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current device installation report">
				<caption><em><%= messages.getString("device_report_os_installs") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("os") %></th>
							<th scope="col"><%= messages.getString("success") %></th>
							<th scope="col"><%= messages.getString("error") %></th>
							<th scope="col"><%= messages.getString("total_installs") %></th>
						</tr>
					</thead>
					<tbody>
						<% for (int j = 0; j < iOS.length; j++) { %>
						<tr>
							<td><%= iOS[j].replace(':',' ') %></td>
						<% if (iOSSuccess[j] + iOSFail[j] == 0) { %>
							<td><%= iOSSuccess[j] %>&nbsp;&nbsp;&nbsp;(0%)</td>
							<td><%= iOSFail[j] %>&nbsp;&nbsp;&nbsp;(0%)</td>
						<% } else { %>
							<td><%= number.format(iOSSuccess[j]) %>&nbsp;&nbsp;&nbsp;(<%= (iOSSuccess[j]*100)/(iOSSuccess[j] + iOSFail[j]) %>%)</td>
							<td><%= number.format(iOSFail[j]) %>&nbsp;&nbsp;&nbsp;(<%= (iOSFail[j]*100)/(iOSSuccess[j] + iOSFail[j]) %>%)</td>
						<% }
						   if (count == 0) { %>
							<td><%= iOSSuccess[j] + iOSFail[j] %>&nbsp;&nbsp;&nbsp;(0%)</td>
						<% } else { %>
							<td><%= number.format(iOSSuccess[j] + iOSFail[j]) %>&nbsp;&nbsp;&nbsp;(<%= (iOSSuccess[j] + iOSFail[j])*100/count %>%)</td>
						<% } %>
						</tr>
						<% } %>
						<tr>
							<td><b><%= messages.getString("total") %></b></td>
							<% if (count == 0) { %>
								<td><b><%= success %>&nbsp;&nbsp;&nbsp;(0%)</b></td>
								<td><b><%= fail %>&nbsp;&nbsp;&nbsp;(0%)</b></td>
							<% } else { %>
								<td><b><%= number.format(success) %>&nbsp;&nbsp;&nbsp;(<%= success*100/count %>%)</b></td>
								<td><b><%= number.format(fail) %>&nbsp;&nbsp;&nbsp;(<%= fail*100/count %>%)</b></td>
							<% } %>
							<td><b><%= number.format(count) %></b></td>
						</tr>
					</tbody>
				</table>
				<div id="chartNodeOS"></div>
				<br /><br />
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current device installation report by browser">
				<caption><em><%= messages.getString("device_report_browser_installs") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("browser") %></th>
							<th scope="col"><%= messages.getString("success") %></th>
							<th scope="col"><%= messages.getString("error") %></th>
							<th scope="col"><%= messages.getString("total_installs") %></th>
						</tr>
					</thead>
					<tbody>
					<% for (int j = 0; j < iBrowser.length; j++) { %>
						<tr>
							<td><%= iBrowser[j] %></td>
						<% if (iBrowserSuccess[j] + iBrowserFail[j] == 0) { %>
							<td><%= iBrowserSuccess[j] %>&nbsp;&nbsp;&nbsp;(0%)</td>
							<td><%= iBrowserFail[j] %>&nbsp;&nbsp;&nbsp;(0%)</td>
						<% } else { %>
							<td><%= number.format(iBrowserSuccess[j]) %>&nbsp;&nbsp;&nbsp;(<%= (iBrowserSuccess[j]*100)/(iBrowserSuccess[j] + iBrowserFail[j]) %>%)</td>
							<td><%= number.format(iBrowserFail[j]) %>&nbsp;&nbsp;&nbsp;(<%= (iBrowserFail[j]*100)/(iBrowserSuccess[j] + iBrowserFail[j]) %>%)</td>
						<% }
						   if (count == 0) { %>
							<td><%= iBrowserSuccess[j] + iBrowserFail[j] %>&nbsp;&nbsp;&nbsp;(0%)</td>
						<% } else { %>
							<td><%= number.format(iBrowserSuccess[j] + iBrowserFail[j]) %>&nbsp;&nbsp;&nbsp;(<%= (iBrowserSuccess[j] + iBrowserFail[j])*100/count %>%)</td>
						<% } %>
						</tr>
					<% } %>
						<tr>
							<td><b><%= messages.getString("total") %></b></td>
							<% if (count == 0) { %>
								<td><b><%= success %>&nbsp;&nbsp;&nbsp;(0%)</b></td>
								<td><b><%= fail %>&nbsp;&nbsp;&nbsp;(0%)</b></td>
							<% } else { %>
								<td><b><%= number.format(success) %>&nbsp;&nbsp;&nbsp;(<%= success*100/count %>%)</b></td>
								<td><b><%= number.format(fail) %>&nbsp;&nbsp;&nbsp;(<%= fail*100/count %>%)</b></td>
							<% } %>
							<td><b><%= number.format(count) %></b></td>
						</tr>
					</tbody>
				</table>
				<div id="chartNodeBrowser"></div>
				<br />
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current device installation report details">
					<caption><em><%= messages.getString("device_install_report_details") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("date_time") %></th>
							<th scope="col"><%= messages.getString("device_name") %></th>
							<th scope="col"><%= messages.getString("geo") %></th>
							<th scope="col"><%= messages.getString("country") %></th>
							<th scope="col"><%= messages.getString("site") %></th>
							<th scope="col"><%= messages.getString("building") %></th>
							<th scope="col"><%= messages.getString("floor") %></th>
							<th scope="col"><%= messages.getString("os") %></th>
							<th scope="col"><%= messages.getString("browser") %></th>
							<th scope="col"><%= messages.getString("result") %></th>
						</tr>
					</thead>
					<tbody>
				<% String rc = "";
				   iGray = 0;
				   int iCount = 0;
				   int num = 0;
				   if (data[11][0] != null){
						num = Integer.parseInt(data[11][0]);
				   }
				   
				   for (int q = 0; q < num; q++) {
				    if (tool.nullStringConverter(data[10][iCount]).equals("0")) {
				    	rc = "Success";
				    } else {
				    	rc = "Error " + data[10][iCount];
				    } %>
						<tr>
							<td><%= dateTime.formatTime(tool.nullStringConverter(data[7][iCount])) %></td>
							<td><%= data[0][iCount] %></td>
							<td><%= data[1][iCount] %></td>
							<td><%= data[2][iCount] %></td>
							<td><%= data[4][iCount] %></td>
							<td><%= data[5][iCount] %></td>
							<td><%= data[6][iCount] %></td>
							<td><%= data[8][iCount] %></td>
							<td><%= data[9][iCount] %></td>
							<td><%= rc %></td>
						</tr>
					<% iCount++;  
					} //for loop%>
						<tr>
							<td colspan="10"><br /><%= messages.getString("number_of_installs") %>: <%= iCount %></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>