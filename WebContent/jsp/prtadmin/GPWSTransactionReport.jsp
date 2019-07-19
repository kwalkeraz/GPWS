<%@ page import="java.text.DecimalFormat,java.text.NumberFormat,java.text.DateFormat,java.text.SimpleDateFormat" %>
<%	
	TableQueryBhvr PrinterLogStartDate  = (TableQueryBhvr) request.getAttribute("PrinterLogStartDate");
	TableQueryBhvrResultSet PrinterLogStartDate_RS = PrinterLogStartDate.getResults();
	
	TableQueryBhvr PrinterLogStopDate  = (TableQueryBhvr) request.getAttribute("PrinterLogStopDate");
	TableQueryBhvrResultSet PrinterLogStopDate_RS = PrinterLogStopDate.getResults();
	
	TableQueryBhvr UserLogGPAdminCount  = (TableQueryBhvr) request.getAttribute("UserLogGPAdminCount");
	TableQueryBhvrResultSet UserLogGPAdminCount_RS = UserLogGPAdminCount.getResults();
	
	TableQueryBhvr UserLogKeyopCount  = (TableQueryBhvr) request.getAttribute("UserLogKeyopCount");
	TableQueryBhvrResultSet UserLogKeyopCount_RS = UserLogKeyopCount.getResults();
	
	TableQueryBhvr UserLogCPAdminCount  = (TableQueryBhvr) request.getAttribute("UserLogCPAdminCount");
	TableQueryBhvrResultSet UserLogCPAdminCount_RS = UserLogCPAdminCount.getResults();
	
	TableQueryBhvr PrinterLogCount  = (TableQueryBhvr) request.getAttribute("PrinterLogCount");
	TableQueryBhvrResultSet PrinterLogCount_RS = PrinterLogCount.getResults();
	
	Timestamp startTime = null;
	Timestamp stopTime = null;
	int iGPWSAdminLogCount = 0;
	int iKeyopLogCount = 0;
	int iCPLogCount = 0;
	int iPrinterLogCount = 0;
	
	NumberFormat number = NumberFormat.getNumberInstance();
	number = new DecimalFormat("###,##0");
	
	DateFormat formatter = new SimpleDateFormat("yyyy'-'MM'-'dd' 'HH:mm", Locale.US);
	
	while (PrinterLogStartDate_RS.next()) {
		startTime = PrinterLogStartDate_RS.getTimeStamp("DATE_TIME");
	}
	
	while (PrinterLogStopDate_RS.next()) {
		stopTime = PrinterLogStopDate_RS.getTimeStamp("DATE_TIME");
	}
	
	while (UserLogGPAdminCount_RS.next()) {
		iGPWSAdminLogCount = UserLogGPAdminCount_RS.getInt("COUNT");
	}
	
	while (UserLogKeyopCount_RS.next()) {
		iKeyopLogCount = UserLogKeyopCount_RS.getInt("COUNT");
	}
	
	while (UserLogCPAdminCount_RS.next()) {
		iCPLogCount = UserLogCPAdminCount_RS.getInt("COUNT");
	}
	
	while (PrinterLogCount_RS.next()) {
		iPrinterLogCount = PrinterLogCount_RS.getInt("COUNT");
	}
	
	float timeDiff = (stopTime.getTime() - startTime.getTime())/1000;
	float iTransMonth = (timeDiff/(60*60*24*30));
	float iTransWeek = (timeDiff/(60*60*24*7));
	float iTransDay = (timeDiff/(60*60*24));
	float iTransHour = (timeDiff/(60*60));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website transaction report"/>
	<meta name="Description" content="Global print website transaction report" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("gpws_transaction_report") %> </title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
	<div id="ibm-leadspace-head" class="ibm-alternate">
	<div id="ibm-leadspace-body">
		<ul id="ibm-navigation-trail">
			<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
			<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=520"><%= messages.getString("tableselect_reports_admin") %></a></li>
		</ul>
		<h1><%= messages.getString("gpws_transaction_report") %></h1>
	</div>
</div>
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<p><%= messages.getString("transaction_report_info1") %>: <%= formatter.format(startTime) %> - <%= formatter.format(stopTime) %></p>
			<p><%= messages.getString("transaction_report_info2") %>:<br />
			<%= messages.getString("number_of_months") %>: <%= iTransMonth %><br />
			<%= messages.getString("number_of_weeks") %>: <%= iTransWeek %><br />
			<%= messages.getString("number_of_days") %>: <%= iTransDay %><br />
			<%= messages.getString("number_of_hours") %>: <%= iTransHour %><br />
			</p>
			<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List transaction statistics">
				<thead>
					<tr>
						<th scope="col"><%= messages.getString("Transaction_type") %></th>
						<th scope="col"><%= messages.getString("Hourly") %></th>
						<th scope="col"><%= messages.getString("Daily") %></th>
						<th scope="col"><%= messages.getString("Weekly") %></th>
						<th scope="col"><%= messages.getString("Monthly") %></th>
						<th scope="col"><%= messages.getString("total") %></th>
					</tr>
				</thead>
				<tbody>
					<tr id='trGPAdmin'>
						<th class="ibm-table-row" scope="row"><%= messages.getString("gpws_admin_transactions") %></th>
						<td><%= number.format(iGPWSAdminLogCount/iTransHour) %></td>
						<td><%= number.format(iGPWSAdminLogCount/iTransDay) %></td>
						<td><%= number.format(iGPWSAdminLogCount/iTransWeek) %></td>
						<td><%= number.format(iGPWSAdminLogCount/iTransMonth) %></td>
						<td><%= number.format(iGPWSAdminLogCount) %></td>
					</tr>
					<tr id='trKeyop'>
						<th class="ibm-table-row" scope="row"><%= messages.getString("keyop_transactions") %></th>
						<td><%= number.format(iKeyopLogCount/iTransHour) %></td>
						<td><%= number.format(iKeyopLogCount/iTransDay) %></td>
						<td><%= number.format(iKeyopLogCount/iTransWeek) %></td>
						<td><%= number.format(iKeyopLogCount/iTransMonth) %></td>
						<td><%= number.format(iKeyopLogCount) %></td>
					</tr>
					<tr id='trCP'>
						<th class="ibm-table-row" scope="row"><%= messages.getString("cp_transactions") %></th>
						<td><%= number.format(iCPLogCount/iTransHour) %></td>
						<td><%= number.format(iCPLogCount/iTransDay) %></td>
						<td><%= number.format(iCPLogCount/iTransWeek) %></td>
						<td><%= number.format(iCPLogCount/iTransMonth) %></td>
						<td><%= number.format(iCPLogCount) %></td>
					</tr>
					<tr id='trPrtInstalls'>
						<th class="ibm-table-row" scope="row"><%= messages.getString("printer_installs") %></th>
						<td><%= number.format(iPrinterLogCount/iTransHour) %></td>
						<td><%= number.format(iPrinterLogCount/iTransDay) %></td>
						<td><%= number.format(iPrinterLogCount/iTransWeek) %></td>
						<td><%= number.format(iPrinterLogCount/iTransMonth) %></td>
						<td><%= number.format(iPrinterLogCount) %></td>
					</tr>
					<tr id='trTOTAL'>
						<th class="ibm-table-row" scope="row"><b><%= messages.getString("total_transactions") %></b></th>
						<td><b><%= number.format((iGPWSAdminLogCount + iKeyopLogCount + iCPLogCount + iPrinterLogCount)/iTransHour) %></b></td>
						<td><b><%= number.format((iGPWSAdminLogCount + iKeyopLogCount + iCPLogCount + iPrinterLogCount)/iTransDay) %></b></td>
						<td><b><%= number.format((iGPWSAdminLogCount + iKeyopLogCount + iCPLogCount + iPrinterLogCount)/iTransWeek) %></b></td>
						<td><b><%= number.format((iGPWSAdminLogCount + iKeyopLogCount + iCPLogCount + iPrinterLogCount)/iTransMonth) %></b></td>
						<td><b><%= number.format((iGPWSAdminLogCount + iKeyopLogCount + iCPLogCount + iPrinterLogCount)) %></b></td>
					</tr>
				</tbody>
			</table> 
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>