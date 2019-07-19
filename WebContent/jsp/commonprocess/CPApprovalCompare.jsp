<%
	TableQueryBhvr CPApproval = (TableQueryBhvr) request.getAttribute("CPApprovalInfo");
	TableQueryBhvrResultSet CPApproval_RS = CPApproval.getResults();
	
	TableQueryBhvr DeviceInfo = (TableQueryBhvr) request.getAttribute("DeviceInfo");
	TableQueryBhvrResultSet DeviceInfo_RS = DeviceInfo.getResults();
	AppTools appTool = new AppTools();
	
	String devicename = "";
	String reqno = "";
	String duplex = "";
	String new_duplex = "";
	String notrays = "";
	String new_notrays = "";
	String serialno = "";
	String new_serialno = "";
	String macadd = "";
	String new_macadd = "";
	String roomaccess = "";
	String new_roomaccess = "";
	String roomphone = "";
	String new_roomphone = "";
	String landrop = "";
	String new_landrop = "";
	String dipp = "";
	String new_dipp = "";
	String koname = "";
	String new_koname = "";
	String kotie = "";
	String new_kotie = "";
	String koemail = "";
	String new_koemail = "";
	String kopage = "";
	String new_kopage = "";
	String koco = "";
	String new_koco = "";
	String billdept = "";
	String new_billdept = "";
	String billdiv = "";
	String new_billdiv = "";
	String billdetail = "";
	String new_billdetail = "";
	String billemail = "";
	String new_billemail = "";
	String billname = "";
	String new_billname = "";
	String ipdomain = "";
	String new_ipdomain = "";
	String ipsubnet = "";
	String new_ipsubnet = "";
	String ipgateway = "";
	String new_ipgateway = "";
	String geo = "";
	String new_geo = "";
	String country = "";
	String new_country = "";
	String city = "";
	String new_city = "";
	String building = "";
	String new_building = "";
	String floor = "";
	String new_floor = "";
	String room = "";
	String new_room = "";
	String cs = "";
	String new_cs = "";
	String sap = "";
	String new_sap = "";
	String vm = "";
	String new_vm = "";
	String mvs = "";
	String new_mvs = "";
	String wts = "";
	String new_wts = "";
	String ps = "";
	String pcl = "";
	String ascii = "";
	String ipds = "";
	String ppds = "";
	String new_ps = "";
	String new_pcl = "";
	String new_ascii = "";
	String new_ipds = "";
	String new_ppds = "";
	String comments = "";
	boolean diff = false;
	
	while (CPApproval_RS.next()) {
		devicename = appTool.nullStringConverter(CPApproval_RS.getString("DEVICE_NAME"));
		reqno = appTool.nullStringConverter(CPApproval_RS.getString("REQ_NUM"));
		comments = appTool.nullStringConverter(CPApproval_RS.getString("COMMENTS"));
		new_duplex = appTool.nullStringConverter(CPApproval_RS.getString("DUPLEX"));
		new_notrays = appTool.nullStringConverter(CPApproval_RS.getString("NUMBER_TRAYS"));
		new_serialno = appTool.nullStringConverter(CPApproval_RS.getString("SERIAL_NUMBER"));
		new_macadd = appTool.nullStringConverter(CPApproval_RS.getString("MAC_ADDRESS"));
		new_roomaccess = appTool.nullStringConverter(CPApproval_RS.getString("ROOM_ACCESS"));
		new_roomphone = appTool.nullStringConverter(CPApproval_RS.getString("ROOM_PHONE"));
		new_landrop = appTool.nullStringConverter(CPApproval_RS.getString("LAN_DROP"));
		new_koname = appTool.nullStringConverter(CPApproval_RS.getString("KO_NAME"));
		new_kotie = appTool.nullStringConverter(CPApproval_RS.getString("KO_PHONE"));
		new_koemail = appTool.nullStringConverter(CPApproval_RS.getString("KO_EMAIL"));
		new_kopage = appTool.nullStringConverter(CPApproval_RS.getString("KO_PAGER"));
		new_koco = appTool.nullStringConverter(CPApproval_RS.getString("KO_COMPANY"));
		new_billdept = appTool.nullStringConverter(CPApproval_RS.getString("BILL_DEPT"));
		new_billdiv = appTool.nullStringConverter(CPApproval_RS.getString("BILL_DIV"));
		new_billdetail = appTool.nullStringConverter(CPApproval_RS.getString("BILL_DETAIL"));
		new_billemail = appTool.nullStringConverter(CPApproval_RS.getString("BILL_EMAIL"));
		new_billname = appTool.nullStringConverter(CPApproval_RS.getString("BILL_NAME"));
		new_ipdomain = appTool.nullStringConverter(CPApproval_RS.getString("IP_DOMAIN"));
		new_ipsubnet = appTool.nullStringConverter(CPApproval_RS.getString("IP_SUBNET"));
		new_ipgateway = appTool.nullStringConverter(CPApproval_RS.getString("IP_GATEWAY"));
		new_geo = appTool.nullStringConverter(CPApproval_RS.getString("GEO"));
		new_country = appTool.nullStringConverter(CPApproval_RS.getString("COUNTRY"));
		new_city = appTool.nullStringConverter(CPApproval_RS.getString("CITY"));
		new_building = appTool.nullStringConverter(CPApproval_RS.getString("BUILDING"));
		new_floor = appTool.nullStringConverter(CPApproval_RS.getString("FLOOR"));
		new_room = appTool.nullStringConverter(CPApproval_RS.getString("ROOM"));
		new_cs = appTool.nullStringConverter(CPApproval_RS.getString("CS"));
		new_sap = appTool.nullStringConverter(CPApproval_RS.getString("SAP"));
		new_vm = appTool.nullStringConverter(CPApproval_RS.getString("VM"));
		new_mvs = appTool.nullStringConverter(CPApproval_RS.getString("MVS"));
		new_wts = appTool.nullStringConverter(CPApproval_RS.getString("WTS"));
		new_ps = appTool.nullStringConverter(CPApproval_RS.getString("PS"));
		new_pcl = appTool.nullStringConverter(CPApproval_RS.getString("PCL"));
		new_ascii = appTool.nullStringConverter(CPApproval_RS.getString("ASCII"));
		new_ipds = appTool.nullStringConverter(CPApproval_RS.getString("IPDS"));
		new_ppds = appTool.nullStringConverter(CPApproval_RS.getString("PPDS"));
	} //while
		new_cs=new_cs.equals("")||new_cs.equals("N")||new_cs.equals("-")?"N":"Y";
		new_sap=new_sap.equals("")||new_sap.equals("N")||new_sap.equals("-")?"N":"Y";
		new_vm=new_vm.equals("")||new_vm.equals("N")||new_vm.equals("-")?"N":"Y";
		new_mvs=new_mvs.equals("")||new_mvs.equals("N")||new_mvs.equals("-")?"N":"Y";
		new_wts=new_wts.equals("")||new_wts.equals("N")||new_wts.equals("-")?"N":"Y";
		new_ps=new_ps.equals("")||new_ps.equals("N")||new_ps.equals("-")?"N":"Y";
		new_pcl=new_pcl.equals("")||new_pcl.equals("N")||new_pcl.equals("-")?"N":"Y";
		new_ascii=new_ascii.equals("")||new_ascii.equals("N")||new_ascii.equals("-")?"N":"Y";
		new_ipds=new_ipds.equals("")||new_ipds.equals("N")||new_ipds.equals("-")?"N":"Y";
		new_ppds=new_ppds.equals("")||new_ppds.equals("N")||new_ppds.equals("-")?"N":"Y";
	
	while (DeviceInfo_RS.next()) {
		duplex = appTool.nullStringConverter(DeviceInfo_RS.getString("DUPLEX"));
		notrays = appTool.nullStringConverter(DeviceInfo_RS.getString("NUMBER_TRAYS"));
		notrays=notrays.equals("")?notrays="0":new_notrays;
		serialno = appTool.nullStringConverter(DeviceInfo_RS.getString("SERIAL_NUMBER"));
		macadd = appTool.nullStringConverter(DeviceInfo_RS.getString("MAC_ADDRESS"));
		roomaccess = appTool.nullStringConverter(DeviceInfo_RS.getString("ROOM_ACCESS"));
		roomphone = appTool.nullStringConverter(DeviceInfo_RS.getString("ROOM_PHONE"));
		landrop = appTool.nullStringConverter(DeviceInfo_RS.getString("LAN_DROP"));
		koname = appTool.nullStringConverter(DeviceInfo_RS.getString("KO_NAME"));
		kotie = appTool.nullStringConverter(DeviceInfo_RS.getString("KO_PHONE"));
		koemail = appTool.nullStringConverter(DeviceInfo_RS.getString("KO_EMAIL"));
		kopage = appTool.nullStringConverter(DeviceInfo_RS.getString("KO_PAGER"));
		koco = appTool.nullStringConverter(DeviceInfo_RS.getString("KO_COMPANY"));
		billdept = appTool.nullStringConverter(DeviceInfo_RS.getString("BILL_DEPT"));
		billdiv = appTool.nullStringConverter(DeviceInfo_RS.getString("BILL_DIV"));
		billdetail = appTool.nullStringConverter(DeviceInfo_RS.getString("BILL_DETAIL"));
		billemail = appTool.nullStringConverter(DeviceInfo_RS.getString("BILL_EMAIL"));
		billname = appTool.nullStringConverter(DeviceInfo_RS.getString("BILL_NAME"));
		ipdomain = appTool.nullStringConverter(DeviceInfo_RS.getString("IP_DOMAIN"));
		ipsubnet = appTool.nullStringConverter(DeviceInfo_RS.getString("IP_SUBNET"));
		ipgateway = appTool.nullStringConverter(DeviceInfo_RS.getString("IP_GATEWAY"));
		geo = appTool.nullStringConverter(DeviceInfo_RS.getString("GEO"));
		country = appTool.nullStringConverter(DeviceInfo_RS.getString("COUNTRY"));
		city = appTool.nullStringConverter(DeviceInfo_RS.getString("CITY"));
		building = appTool.nullStringConverter(DeviceInfo_RS.getString("BUILDING_NAME"));
		floor = appTool.nullStringConverter(DeviceInfo_RS.getString("FLOOR_NAME"));
		room = appTool.nullStringConverter(DeviceInfo_RS.getString("ROOM"));
		cs = appTool.nullStringConverter(DeviceInfo_RS.getString("CS"));
		sap = appTool.nullStringConverter(DeviceInfo_RS.getString("SAP"));
		vm = appTool.nullStringConverter(DeviceInfo_RS.getString("VM"));
		mvs = appTool.nullStringConverter(DeviceInfo_RS.getString("MVS"));
		wts = appTool.nullStringConverter(DeviceInfo_RS.getString("WTS"));
		ps = appTool.nullStringConverter(DeviceInfo_RS.getString("PS"));
		pcl = appTool.nullStringConverter(DeviceInfo_RS.getString("PCL"));
		ascii = appTool.nullStringConverter(DeviceInfo_RS.getString("ASCII"));
		ipds = appTool.nullStringConverter(DeviceInfo_RS.getString("IPDS"));
		ppds = appTool.nullStringConverter(DeviceInfo_RS.getString("PPDS"));
	} //while
		cs=cs.equals("")||cs.equals("N")||cs.equals("-")?"N":"Y";
		sap=sap.equals("")||sap.equals("N")||sap.equals("-")?"N":"Y";
		vm=vm.equals("")||vm.equals("N")||vm.equals("-")?"N":"Y";
		mvs=mvs.equals("")||mvs.equals("N")||mvs.equals("-")?"N":"Y";
		wts=wts.equals("")||wts.equals("N")||wts.equals("-")?"N":"Y";
		ps=ps.equals("")||ps.equals("N")||ps.equals("-")?"N":"Y";
		pcl=pcl.equals("")||pcl.equals("N")||pcl.equals("-")?"N":"Y";
		ascii=ascii.equals("")||ascii.equals("N")||ascii.equals("-")?"N":"Y";
		ipds=ipds.equals("")||ipds.equals("N")||ipds.equals("-")?"N":"Y";
		ppds=ppds.equals("")||ppds.equals("N")||ppds.equals("-")?"N":"Y";
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website compare device information"/>
	<meta name="Description" content="Global print website compare device information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("compare_device") %> </title>
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
				<h1><%= messages.getString("compare_device") %></h1>
			</div> 
		</div>
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<p>
							<label for='reqnum'><strong><%= messages.getString("device_name") %></strong>:</label>
							<%= devicename %>
						</p>
						<p>
							<label for='reqnum'><strong><%= messages.getString("device_request_number") %></strong>:</label>
							<%= reqno %>
						</p>
						<p>
							<label for='reqnum'><strong><%= messages.getString("comments") %></strong>:</label>
							<%= comments %>
						</p>
						<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Compare device changes from common process">
							<caption><em><%= messages.getString("compare_device_info") %> </em></caption>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("device_info") %></th>
									<th scope="col"><%= messages.getString("current_value") %></th>
									<th scope="col"><%= messages.getString("changes_requested") %></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th scope="col" colspan="3"><strong><%= messages.getString("device_location_info") %></strong></th>
								</tr>
								<tr>
									<td>
										<%= messages.getString("geo") %>:
									</td>
									<td>
										<%= geo %>
									</td>
									<td>
										<%= new_geo %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("country") %>:
									</td>
									<td>
										<%= country %>
									</td>
									<td>
										<%= new_country %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("city") %>:
									</td>
									<td>
										<%= city %>
									</td>
									<td>
										<%= new_city %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("building") %>:
									</td>
									<td>
										<%= building %>
									</td>
									<td>
										<%= new_building %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("floor") %>:
									</td>
									<td>
										<%= floor %>
									</td>
									<td>
										<%= new_floor %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("room") %>:
									</td>
									<td>
										<%= room %>
									</td>
									<td>
										<%= new_room %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("room_access") %>:
									</td>
									<td>
										<%= roomaccess %>
									</td>
									<td>
										<%= new_roomaccess %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("room_phone") %>:
									</td>
									<td>
										<%= roomphone %>
									</td>
									<td>
										<%= new_roomphone%>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("lan_drop") %>:
									</td>
									<td>
										<%= landrop %>
									</td>
									<td>
										<%= new_landrop %>
									</td>
								</tr>
								<tr>
									<th scope="col" colspan="3"><strong><%= messages.getString("device_info") %></strong></th>
								</tr>
								<tr>
									<td>
										<%= messages.getString("cs") %>:
									</td>
									<td>
										<%= cs %>
									</td>
									<td>
										<%= new_cs %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("vm") %>:
									</td>
									<td>
										<%= vm %>
									</td>
									<td>
										<%= new_vm %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("mvs") %>:
									</td>
									<td>
										<%= mvs %>
									</td>
									<td>
										<%= new_mvs %>
									</td>
								</tr>
								<tr class="gray">
									<td>
										<%= messages.getString("sap") %>:
									</td>
									<td>
										<%= sap %>
									</td>
									<td>
										<%= new_sap %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("wts") %>:
									</td>
									<td>
										<%= wts %>
									</td>
									<td>
										<%= new_wts %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ps") %>:
									</td>
									<td>
										<%= ps %>
									</td>
									<td>
										<%= new_ps %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("pcl") %>:
									</td>
									<td>
										<%= pcl %>
									</td>
									<td>
										<%= new_pcl %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ascii") %>:
									</td>
									<td>
										<%= ascii %>
									</td>
									<td>
										<%= new_ascii %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ipds") %>:
									</td>
									<td>
										<%= ipds %>
									</td>
									<td>
										<%= new_ipds %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ppds") %>:
									</td>
									<td>
										<%= ppds %>
									</td>
									<td>
										<%= new_ppds %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("duplex") %>:
									</td>
									<td>
										<%= duplex %>
									</td>
									<td>
										<%= new_duplex %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("device_num_trays") %>:
									</td>
									<td>
										<%= notrays %>
									</td>
									<td>
										<%= new_notrays %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("serial_number") %>:
									</td>
									<td>
										<%= serialno %>
									</td>
									<td>
										<%= new_serialno %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("mac_address") %>:
									</td>
									<td>
										<%= macadd %>
									</td>
									<td>
										<%= new_macadd %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ip_domain") %>:
									</td>
									<td>
										<%= ipdomain %>
									</td>
									<td>
										<%= new_ipdomain %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ip_subnet") %>:
									</td>
									<td>
										<%= ipsubnet %>
									</td>
									<td>
										<%= new_ipsubnet %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ip_gateway") %>:
									</td>
									<td>
										<%= ipgateway %>
									</td>
									<td>
										<%= new_ipgateway %>
									</td>
								</tr>
								<tr>
									<th scope="col" colspan="3"><strong><%= messages.getString("device_keyop_info") %></strong></th>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ko_company") %>:
									</td>
									<td>
										<%= koco %>
									</td>
									<td>
										<%= new_koco %>
									</td>
								</tr>
								<tr class="gray">
									<td>
										<%= messages.getString("ko_name") %>:
									</td>
									<td>
										<%= koname %>
									</td>
									<td>
										<%= new_koname %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ko_phone") %>:
									</td>
									<td>
										<%= kotie %>
									</td>
									<td>
										<%= new_kotie %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ko_email") %>:
									</td>
									<td>
										<%= koemail %>
									</td>
									<td>
										<%= new_koemail %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("ko_pager") %>:
									</td>
									<td>
										<%= kopage %>
									</td>
									<td>
										<%= new_kopage %>
									</td>
								</tr>
								<tr>
									<th scope="col" colspan="3"><strong><%= messages.getString("billing_info") %></strong></th>
								</tr>
								<tr>
									<td>
										<%= messages.getString("device_bill_dept") %>:
									</td>
									<td>
										<%= billdept %>
									</td>
									<td>
										<%= new_billdept %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("device_bill_division") %>:
									</td>
									<td>
										<%= billdiv %>
									</td>
									<td>
										<%= new_billdiv %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("device_bill_detail") %>:
									</td>
									<td>
										<%= billdetail %>
									</td>
									<td>
										<%= new_billdetail %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("device_bill_name") %>:
									</td>
									<td>
										<%= billname %>
									</td>
									<td>
										<%= new_billname %>
									</td>
								</tr>
								<tr>
									<td>
										<%= messages.getString("device_bill_email") %>:
									</td>
									<td>
										<%= billemail %>
									</td>
									<td>
										<%= new_billemail %>
									</td>
								</tr>
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