<%
    // THIS IS WHERE WE LOAD ALL THE BEANS
   TableQueryBhvr UserLogDevice  = (TableQueryBhvr) request.getAttribute("UserLogDevice");
   TableQueryBhvrResultSet UserLogDevice_RS = UserLogDevice.getResults();
   PrinterTools tool = new PrinterTools();
	String loginid = "";	
	String action = "";
	int x = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website device history"/>
	<meta name="Description" content="Global print website display device update history" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_history") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript">
		ibmweb.config.set({
			greeting: { enabled: false }
		});
	</script>

	</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="mastheadPopup.jsp" %>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<h1><%= messages.getString("device_history") %></h1>
			</div> 
		</div>
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display device history">
							<caption><em><%= messages.getString("device_history_caption") %> </em></caption>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("date_time") %></th>
									<th scope="col"><%= messages.getString("loginid") %></th>
									<th scope="col"><%= messages.getString("action") %></th>
								</tr>
							</thead>
							<tbody>
							<%
								while(UserLogDevice_RS.next()) {
								x++;
							 %>
								<tr>
									<td width="15%"><%= UserLogDevice_RS.getTimeStamp("DATE_TIME") %></td>
									<td width="15%"><%= tool.nullStringConverter(UserLogDevice_RS.getString("LOGINID")) %></td>
									<td width="70%"><%= tool.nullStringConverter(UserLogDevice_RS.getString("ACTION")) %></td>
								</tr> 
							<%	} //while UserLogDevice
								if (x == 0) { %>
										<tr><td><%= messages.getString("no_device_activity") %></td></tr>
							<%	} //if %>
							</tbody>
						</table> 
						<div align="right"><span><a class="ibm-cancel-link" href="javascript:window.close();parent.opener.window.focus();"><%= messages.getString("close") %></a></span></div>
					</div>
				</div>
			</div>
			<!-- CONTENT_END -->
		</div>
	</div>
</body>