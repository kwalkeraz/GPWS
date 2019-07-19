<%
    // THIS IS WHERE WE LOAD ALL THE BEANS
   com.ibm.aurora.bhvr.TableQueryBhvr TicketInfoUserView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketInfoUserView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketInfoUserView_RS = TicketInfoUserView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr SuppliesView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("SuppliesView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet SuppliesView_RS = SuppliesView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsView_RS = PartsView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsView2 = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsView2_RS = PartsView2.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsReplaced = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsReplaced");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsReplaced_RS = PartsReplaced.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsAdded = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsAdded");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsAdded_RS = PartsAdded.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr SuppliesReplaced = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("SuppliesReplaced");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet SuppliesReplaced_RS = SuppliesReplaced.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr CloseCodesView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CloseCodesView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet CloseCodesView_RS = CloseCodesView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr HoldTimes = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("HoldTimes");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet HoldTimes_RS = HoldTimes.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopView_RS = AdminKeyopView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr TicketNotes = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketNotes");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketNotes_RS = TicketNotes.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr TicketProblems = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketProblems");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketProblems_RS = TicketProblems.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PurchaseOrderView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PurchaseOrderView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PurchaseOrderView_RS = PurchaseOrderView.getResults();
%>
<%
	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	int numTickets = 0;
	int iTicketNo = 0;
	String sRequestedBy = "";
	String sTieLine = "";
	String sExtPhone = "";
	String sTimeSubmitted = "";
	String sPrinter = "";
	String sBuilding = "";
	String sFloor = "";
	String sRoom = "";
	String sKeyop = "";
	String sDescription = "";
	String sNotes = "";
	String sSolution = "";
	String sEmail = "";
	String sStatus = "";
	String sSite = "";
	String sCEReferralNum = "";
	String sHDReferralNum = "";
	String sCustContacted = "";
	String sKeyopTimeStart = "";
	String sKeyopTimeFinish = "";
	String sSuppliesReplaced = "";
	String sPartsReplaced = "";
	String sPartsAdded = "";
	String sPurchaseOrders = "";
	String sPurchaseOrderDates = "";
	String sCloseCode = "";
	String sCCEmail = "";
	String sEndToEnd = "";
	String sTier = "";
	String sDeviceModel = "";
	String sPSerNo = "";
	String sCEReferralDate = "";
	String sHDReferralDate = "";
	String sBondReqNum = "";
	int iVendorID = 0;
	
	while(TicketInfoUserView_RS.next()) {
		iTicketNo = TicketInfoUserView_RS.getInt("KEYOP_REQUESTID");
		sRequestedBy = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_NAME"));
		sTieLine = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_TIELINE"));
		sExtPhone = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_EXT_PHONE"));
		sTimeSubmitted = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("TIME_SUBMITTED"));
		sPrinter = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DEVICE_NAME"));
		sDeviceModel = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DEVICE_TYPE")); 
		sBuilding = appTool.nullStringConverter(TicketInfoUserView_RS.getString("BUILDING"));
		sFloor = appTool.nullStringConverter(TicketInfoUserView_RS.getString("FLOOR"));
		sRoom = appTool.nullStringConverter(TicketInfoUserView_RS.getString("ROOM"));
		sKeyop = appTool.nullStringConverter(TicketInfoUserView_RS.getString("KEYOP_NAME"));
		sDescription = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DESCRIPTION"));
		sSolution = appTool.nullStringConverter(TicketInfoUserView_RS.getString("SOLUTION"));
		sEmail = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_EMAIL"));
		sSite = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CITY"));
		sStatus = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQ_STATUS"));
		sCEReferralNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CE_REFERRAL_NUM"));
		sHDReferralNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("HD_REFERRAL_NUM"));
		sCustContacted = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("CUSTOMER_CONTACTED"));
		sKeyopTimeStart = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_START"));
		sKeyopTimeFinish = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_FINISH"));
		sCCEmail = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CC_EMAIL"));
		sEndToEnd = appTool.nullStringConverter(TicketInfoUserView_RS.getString("E2E_CATEGORY"));
		sTier = appTool.nullStringConverter(TicketInfoUserView_RS.getString("TIER"));
		sPSerNo = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DEVICE_SERIAL"));
		sCEReferralDate = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("CE_REFERRAL_DATE"));
		sHDReferralDate = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("HD_REFERRAL_DATE"));
		sBondReqNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("BOND_REQ_NUM"));
		iVendorID = TicketInfoUserView_RS.getInt("KO_COMPANYID");
		numTickets++;
	}
	if(sCustContacted.equals("invalid time")) {
		sCustContacted = "";
	}
	if(sKeyopTimeStart.equals("invalid time")) {
		sKeyopTimeStart = "";
	}
	if(sKeyopTimeFinish.equals("invalid time")) {
		sKeyopTimeFinish = "";
	}
	if(sCEReferralDate.equals("invalid time")) {
		sCEReferralDate = "";
	}
	if(sHDReferralDate.equals("invalid time")) {
		sHDReferralDate = "";
	}
	if(sCEReferralNum == null || sCEReferralNum.equals("")) {
		sCEReferralNum = "";
	}
	if(sHDReferralNum == null || sHDReferralNum.equals("")) {
		sHDReferralNum = "";
	}
	if (sSolution == null || sSolution.equals("")) {
		sSolution = "";
	}
	
	Connection con = null;
	Statement stTicket = null;
	ResultSet rsTicket = null;
   try {
	if (sStatus.equals("completed")) {
		con = appTool.getConnection();
		stTicket = con.createStatement();
		rsTicket = stTicket.executeQuery("SELECT CLOSE_CODE_NAME FROM GPWS.KEYOP_CLOSECODES WHERE CLOSE_CODEID = (SELECT CLOSE_CODEID FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iTicketNo + ")");
		while (rsTicket.next()) {
			sCloseCode = rsTicket.getString("CLOSE_CODE_NAME");
		}
	}
   } catch (Exception e) {
   		System.out.print("Keyop error in TicketInfoAdmin.jsp ERROR: " + e);
   		try {
	   		appTool.logError("TicketInfoKeyop.jsp","Keyop", e);
	   	} catch (Exception ex) {
	   		System.out.println("Keyop Error in TicketInfoAdmin.jsp ERROR: " + ex);
	   	}
   } finally {
   		if (rsTicket != null)
   			rsTicket.close();
   		if (stTicket != null)
   			stTicket.close();
   		if (con != null)
   			con.close();
   }
   
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	
	//int sUserid = 0;
	//sUserid = pupb.getUserID();
	//int iVendorID = pupb.getVendorID();
// 	String[] sAuthTypes = pupb.getAuthTypes();
// 	boolean isKOSU = false;
// 	for (int i = 0; i < sAuthTypes.length; i++) {
// 		if (sAuthTypes[i].startsWith("Keyop Superuser")) {
// 			isKOSU = true;
// 		}
// 	}
   
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, ticket info admin"/>
<meta name="Description" content="A Site to request Key Operator service for most US printers. Also includes the handling of these requests by key operators and admins. This page is only viewable by system administrators." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("ticket_information") %></title>
<%@ include file="metainfo2.jsp") %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.form.Form");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Button");

	dojo.ready(function() {
		fixAlignment();
		
		createpTag();
		<% if (sStatus.equals("new") || sStatus.equals("in progress") || sStatus.equals("HOLD")) { %> 
			createHiddenInput('nextpageid','next_page_id','3026');
			createHiddenInput('submitvalue','submitvalue', 'assignTicket');
			createHiddenInput('ticketno','ticketno', '<%= iTicketNo %>');
			createHiddenInput('keyopname','keyopname','');
		
			createSelect('keyopuserid', 'keyopuserid', 'Select keyop', '', 'keyopuseridloc');
		
			createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
			createInputButton('submit_assign_button','ibm-submit','<%= messages.getString("assign") %>','ibm-btn-arrow-pri','next()','assignTicket()');
			addKeyops();
			changeSelectStyle('225px');
		<% } %>
		
		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
		
		
	});
	
	function addKeyops() {
		<% while (AdminKeyopView_RS.next()) {  
			System.out.println("vendor ids    " + iVendorID + " : " + AdminKeyopView_RS.getInt("VENDORID"));
			if (iVendorID == AdminKeyopView_RS.getInt("VENDORID")) { %>
				addOption('keyopuserid','<%= AdminKeyopView_RS.getString("LAST_NAME") + ", " + AdminKeyopView_RS.getString("FIRST_NAME") %>','<%= AdminKeyopView_RS.getInt("USERID") %>');
		<%	}
		   } %>
	}

	function assignTicket() {
		validForm = dijit.byId("theForm").validate();
		if (validForm) {
			dijit.byId('theForm').submit();
		} else {
			alert('<%= messages.getString("please_select_keyop_to_assign") %>');
			return false;
		}
	}
	
	function fixAlignment() {
		dojo.query(".leftcol").forEach(function(x){
			if (x.id == "timesrefs") {
				x.style = "float: left; width:300px";
			} else {
				x.style = "float: left; width:200px";
			}
		});
	}

</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>	
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("Keyop_Admin_Home") %></a></li>  
			</ul>
			<h1><%= messages.getString("ticket_information") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
				<div id="response"></div>

					<% if (numTickets == 1) { %>
					<div class="ibm-columns">
						<div class="ibm-col-1-1">
						
							<h2 class="ibm-rule-alternate"><%= messages.getString("ticket_information") %></h2><br />
							<div class="pClass">
								<div class="leftcol">
									<strong><%= messages.getString("ticket_number") %>:</strong><br />
									<strong><%= messages.getString("status") %>:</strong><br />
									<strong><%= messages.getString("assigned_to") %>:</strong><br />
									<strong><%= messages.getString("time_opened") %>:</strong><br /><br />
								</div>
								<div>
									<span><%= iTicketNo %></span><br />
									<span><%= sStatus %></span><br />
									<span>
									<% if (sKeyop.equals("")) { %>
								   		<%= messages.getString("unassigned") %>
									<% } else { %>
								   		<%= sKeyop %>
									<% } %></span><br />
									<span><%= sTimeSubmitted %></span><br /><br />
								</div>
							</div>

							<h2 class="ibm-rule-alternate"><strong><%= messages.getString("user_info") %></strong></h2><br />
							<div class="pClass">
								<div class="leftcol">
									<strong><%= messages.getString("name") %>:</strong><br />
									<strong><%= messages.getString("ext_phone") %>:</strong><br />
									<strong><%= messages.getString("tieline") %>:</strong><br />
									<strong><%= messages.getString("email") %>:</strong><br />
									<strong><%= messages.getString("additional_email") %>:</strong><br /><br />
								</div>
								<div>
									<%= sRequestedBy %><br />
									<%= sExtPhone %><br />
									<%= sTieLine %><br />
									<%= sEmail %><br />
									<%= sCCEmail %><br /><br />
								</div>
							</div>

							<h2 class="ibm-rule-alternate"><%= messages.getString("device_info") %></h2><br />
							<div class="pClass">
								<div class="leftcol">
									<strong><%= messages.getString("device_name") %>:</strong><br />
									<strong><%= messages.getString("site") %>:</strong><br />
									<strong><%= messages.getString("building") %>:</strong><br />
									<strong><%= messages.getString("floor") %>:</strong><br />
									<strong><%= messages.getString("room") %>:</strong><br />
									<strong><%= messages.getString("device_model") %>:</strong><br />
									<strong><%= messages.getString("device_serial") %>:</strong><br />
									<strong><%= messages.getString("e2e_category") %>:</strong><br />
									<strong><%= messages.getString("tier") %>:</strong><br /><br />
								</div>
								<div>
									<%= sPrinter %><br />
									<%= sSite %><br />
									<%= sBuilding %><br />
									<%= sFloor %><br />
									<%= sRoom %><br />
									<%= sDeviceModel %><br />
									<%= sPSerNo %><br />
									<%= sEndToEnd %><br />
									<%= sTier %><br /><br />
								</div>
							</div>

							<h2 class="ibm-rule-alternate"><%= messages.getString("device") %>&nbsp;<%= messages.getString("problems") %></h2><br />
							<div class="pClass">
								<ul>
							<% while (TicketProblems_RS.next()) { %>
									<li><%= TicketProblems_RS.getString("PROBLEM_NAME") %></li>
							<% } %>
								</ul>
							</div>
							<br />
							<h2 class="ibm-rule-alternate"><%= messages.getString("prob_desc_alt_contact") %></h2><br />
							<div class="pClass">
							<%  if (sDescription.equals("")) { %>
									<%= messages.getString("none") %>
							<%	} else { %>
									<%= sDescription %>
							<%	} %>
							</div>
							<br />

							<h2 class="ibm-rule-alternate"><%= messages.getString("key_operator") %>&nbsp;<%= messages.getString("notes") %></h2><br />
							<div class="pClass">
							<%	while (TicketNotes_RS.next()) { %>
								<strong><%= dateTime.convertUTCtoTimeZone(TicketNotes_RS.getTimeStamp("DATE_TIME")) %>&nbsp;-&nbsp;
								<%= TicketNotes_RS.getString("ADDED_BY") %>:&nbsp;</strong>
								<%= TicketNotes_RS.getString("NOTE") %>
								<br />
							<% } 
								if (TicketNotes_RS.getResultSetSize() == 0) { %>
									<%= messages.getString("none") %>
							<%  } %>
							</div>
					<% if (HoldTimes_RS.getResultSetSize() > 0) { %>
							<br />
							<h2 class="ibm-rule-alternate"><%= messages.getString("hold_times") %></h2>
							<div class="pClass">
							<% while (HoldTimes_RS.next()) { %>
								<%= messages.getString("time_stop") %>:  <%= dateTime.convertUTCtoTimeZone(HoldTimes_RS.getTimeStamp("TIME_ON_HOLD")) %> - 
								<%= messages.getString("time_start") %>: <%= dateTime.convertUTCtoTimeZone(HoldTimes_RS.getTimeStamp("TIME_OFF_HOLD")) %>
								<br />
							<% } %>
							</div>
					<% } %>
						<br />
							<h2 class="ibm-rule-alternate"><%= messages.getString("times_and_referrals") %></h2><br />
							<div class="pClass">
								<div class="leftcol" id="timesrefs">
									<strong><%= messages.getString("customer_contacted") %>:</strong><br />
									<strong><%= messages.getString("work_started") %>:</strong><br />
									<strong><%= messages.getString("work_completed") %>:</strong><br />
									<strong><%= messages.getString("ce_referral_number_date") %>:</strong><br />
									<strong><%= messages.getString("helpdesk_referral_number_date") %>:</strong><br /><br />
								</div>
								<div>
									<%= sCustContacted %><br />
									<%= sKeyopTimeStart %><br />
									<%= sKeyopTimeFinish %><br />
									<%= sCEReferralNum %> - <%= sCEReferralDate %><br />
									<%= sHDReferralNum %> - <%= sHDReferralDate %><br /><br />
								</div>
							</div>
							<h2 class="ibm-rule-alternate"><%= messages.getString("resolution") %></h2><br />
							<div class="pClass">
								<div class="leftcol">
									<strong><%= messages.getString("solution") %>:</strong><br />
									<strong><%= messages.getString("close_code_singular") %>:</strong><br />
									<strong><%= messages.getString("customer_contacted") %>:</strong><br />
									<strong><%= messages.getString("work_started") %>:</strong><br />
									<strong><%= messages.getString("work_completed") %>:</strong><br /><br />
								</div>
								<div>
									<%= sSolution %><br />
									<%= sCloseCode %><br />
									<%= sCustContacted %><br />
									<%= sKeyopTimeStart %><br />
									<%= sKeyopTimeFinish %><br /><br />
								</div>
							</div>
							
							<h2 class="ibm-rule-alternate"><%= messages.getString("parts_and_supplies") %></h2><br />
							<div class="pClass">
								<div class="leftcol" id="parts">
								<strong><label for="supplyreplaced"><%= messages.getString("supplies_replaced") %>:</label>&nbsp;</strong>
									
									<br />
								<strong><label for="partreplaced"><%= messages.getString("parts_replaced") %>:</label></strong>&nbsp;
									
									<br />
								<strong><label for="partadded"><%= messages.getString("parts_added") %>:</label></strong>&nbsp;
									
									<br />
								<strong><label for="bondreqnum"><%= messages.getString("bond_req_num") %>:</label></strong>&nbsp;
									
								</div>
								<div>
									<% while (SuppliesReplaced_RS.next()) { %>
										<%= SuppliesReplaced_RS.getString("SUPPLY_NAME") %>,&nbsp;
									<% } %>
									<br />
									<% while (PartsReplaced_RS.next()) { %>
								 		 <%= PartsReplaced_RS.getString("PART_NAME") %>,&nbsp;
									<% }%>
									<br />
									<% while (PartsAdded_RS.next()) { %>
								 		 <%= PartsAdded_RS.getString("PART_NAME") %>,&nbsp;
									<% }%>
									<br />
									<% if (sBondReqNum == null) { %> 
										<%= messages.getString("none") %>
									<% } else { %> 
										<%= sBondReqNum %>
									<% } %>
									<br />
								</div>
									<br />
								<strong><%= messages.getString("purchase_order_number") %> - <%= messages.getString("purchase_order_date") %></strong><br />
									<%	while (PurchaseOrderView_RS.next()) { %>
											<%= appTool.nullStringConverter(PurchaseOrderView_RS.getString("PURCHASE_ORDER_NUMBER")) %> - <%= dateTime.convertUTCtoTimeZone(PurchaseOrderView_RS.getTimeStamp("PURCHASE_ORDER_DATE")) %><br />
									<% } %>
									<% if (PurchaseOrderView_RS.getResultSetSize() < 1) { %>
										<%= messages.getString("none") %>
									<% } %>
							</div>
							<br />
						<% if (sStatus.equals("new") || sStatus.equals("in progress") || sStatus.equals("HOLD")) { %> 
							<h2 class="ibm-rule-alternate"><%= messages.getString("assign_ticket") %></h2><br />
							<p><%= messages.getString("assign_ticket_desc") %></p>
							<div id="Keyop">
								<div id="nextpageid"></div>
								<div id="submitvalue"></div>
								<div id="ticketno"></div>
								<div id="keyopname"></div>
								<br />
								<div class="pClass">
									<label for="keyopuserid"><%= messages.getString("keyop_cap") %>:</label>
									<span><div id="keyopuseridloc"></div></span>
								</div>
								<div class="pClass">
									<span><div id="submit_assign_button"></div></span>
								</div>
								</div>
						<% } %>
					</div>
					</div>
					<% } else if (numTickets == 0) { %>
						<p>
							<%= messages.getString("sorry_request") %> <%= request.getParameter("ticketno") %> <%= messages.getString("not_found") %>.
						</p>
					<% } else { %>
							<p><%= messages.getString("an_error_has_occurred") %>.</p>
					<% } %>	
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>