<%
   TableQueryBhvr PrinterDefType  = (TableQueryBhvr) request.getAttribute("PrinterDefType");
   TableQueryBhvrResultSet PrinterDefType_RS = PrinterDefType.getResults();
   TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	TableQueryBhvr PrinterDefTypeConfig  = (TableQueryBhvr) request.getAttribute("PrtDefTypeView");
	TableQueryBhvrResultSet PrinterDefTypeConfig_RS = PrinterDefTypeConfig.getResults();
	String[] osArray = new String[OSView_RS.getResultSetSize()];
	PrinterTools tool = new PrinterTools();
	String serverdeftype = "";
	String clientdeftype = "";	
	int printerdeftypeid = 0;
	String lastserver = "";
	int oscounter = 0;
	int x = 0;
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website printer definition help"/>
	<meta name="Description" content="Global print website printer definition type help page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_def_type") %> </title>
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
				<h1><%= messages.getString("printer_def_type") %></h1>
			</div> 
		</div>
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available printer definition types">
							<caption><em><%= messages.getString("printer_def_type_caption") %>  <%= PrinterDefType_RS.getResultSetSize() %> <%= messages.getString("printer_def_type_found") %></em></caption>
							<% if (PrinterDefType_RS.getResultSetSize() > 0) { %>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("server_client_definition") %></th>
									<% while (OSView_RS.next()) {  
										osArray[x] = OSView_RS.getString("OS_NAME"); %>
									<th scope="col"><%= osArray[x] %></th>
									<% 	x++;
										} //while %>
								</tr>
							</thead>
							<tbody>
							<%
								while(PrinterDefType_RS.next()) {
									serverdeftype = PrinterDefType_RS.getString("SERVER_DEF_TYPE");
									clientdeftype = PrinterDefType_RS.getString("CLIENT_DEF_TYPE");
									printerdeftypeid = PrinterDefType_RS.getInt("PRINTER_DEF_TYPEID");
									serverdeftype = tool.nullStringConverter(serverdeftype);
									clientdeftype = tool.nullStringConverter(clientdeftype);
							 %>
								<tr>
									<td>
										<%= serverdeftype %> / <%= clientdeftype %>
									</td>
									<% 	PrinterDefTypeConfig_RS.first();
										while (PrinterDefTypeConfig_RS.next()) { 
											if(printerdeftypeid == PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPEID")) {
												while (oscounter < osArray.length) {
													if (osArray[oscounter].equals(PrinterDefTypeConfig_RS.getString("OS_NAME"))) { %>
									<td>
										<%= PrinterDefTypeConfig_RS.getString("PROTOCOL_NAME") %>
									</td>
									<% 				oscounter++;
													break;
													} else { %>
									<td></td>
									<%				oscounter++;
													} //ifOsArray
												} //while oscounter
											} //if printertypeid
										} //while PrinteDefTypeConfig %>
								</tr>
									<% oscounter = 0; %>
								<% } //while PrinterDefType %>
							</tbody>
							<% } //if there are records %>
						</table> 
						<div align="right"><span><a class="ibm-cancel-link" href="javascript:window.close();parent.opener.window.focus();"><%= messages.getString("close") %></a></span></div>
					</div>
				</div>
			</div>
			<!-- CONTENT_END -->
		</div>
	</div>
</body>