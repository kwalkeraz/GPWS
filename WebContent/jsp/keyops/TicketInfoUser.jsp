<%
    // THIS IS WHERE WE LOAD ALL THE BEANS
   com.ibm.aurora.bhvr.TableQueryBhvr TicketInfoUserView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketInfoUserView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketInfoUserView_RS = TicketInfoUserView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr TicketNotes = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketNotes");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketNotes_RS = TicketNotes.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr TicketProblems = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketProblems");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketProblems_RS = TicketProblems.getResults();

%>
<%
	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	int numTickets = 0;
	int iTicketNo = 0;
	int iCityid = 0;
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
		numTickets++;
	}
	
	String cityid = "0";
	if (request.getParameter("cityid") != null) {
		cityid = request.getParameter("cityid");
	} else {
		cityid = iCityid + "";
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
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, ticket info user"/>
<meta name="Description" content="A Site to request Key Operator service for most US printers. Also includes the handling of these requests by key operators and admins. This page is only viewable by system administrators." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("ticket_information") %></title>
<%@ include file="metainfo2.jsp") %>

<script type="text/javascript">
	dojo.ready(function() {		
		fixAlignment();
	});
	
	function fixAlignment() {
		dojo.query(".leftcol").forEach(function(x){
			if (x.id == "timesrefs") {
				x.style = "float: left; width:300px";
			} else {
				x.style = "float: left; width:150px";
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
				<li><a href="<%= statichtmldir %>/index.html"><%= messages.getString("global_print") %></a></li>
				<li><a href="<%= statichtmldir %>/USKeyOperatorServices.html"> <%= messages.getString("us_keyop_services") %></a></li>
				<li><a href="<%= keyops %>?next_page_id=2036&cityid=<%= cityid %>&ft=0&mpp=50"> <%= messages.getString("in_progress_keyop_requests") %></a></li>
			</ul>
			<h1><%= messages.getString("ticket_information") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<!-- All the main body stuff goes here -->
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
							<div class="leftcol">
								<strong><%= messages.getString("ticket_number") %>:</strong><br />
								<strong><%= messages.getString("status") %>:</strong><br />
<%-- 								<strong><%= messages.getString("assigned_to") %>:</strong>&nbsp; --%>
<%-- 									<% if (sKeyop.equals("")) { %> --%>
<%-- 								   		<%= messages.getString("unassigned") %> --%>
<%-- 									<% } else { %> --%>
<%-- 								   		<%= sKeyop %> --%>
<%-- 									<% } %><br /> --%>
								<strong><%= messages.getString("time_opened") %>:</strong><br /><br />
							</div>
							<div>
								<%= iTicketNo %><br />
								<%= sStatus %><br />
								<%= sTimeSubmitted %><br /><br />
							</div>
							<br />

							<h2 class="ibm-rule-alternate"><strong><%= messages.getString("user_info") %></strong></h2><br />
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

							<h2 class="ibm-rule-alternate"><%= messages.getString("device_info") %></h2><br />
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

							<h2 class="ibm-rule-alternate"><%= messages.getString("device") %>&nbsp;<%= messages.getString("problems") %></h2><br />
							<p>
								<ul>
							<% while (TicketProblems_RS.next()) { %>
									<li><%= TicketProblems_RS.getString("PROBLEM_NAME") %></li>
							<% } %>
								</ul>
							</p>
							<h2 class="ibm-rule-alternate"><%= messages.getString("prob_desc_alt_contact") %></h2><br />
							<p>
							<%  if (sDescription.equals("")) { %>
									<%= messages.getString("none") %>
							<%	} else { %>
									<%= sDescription %>
							<%	} %>
							</p>
							<br />

							<h2 class="ibm-rule-alternate"><%= messages.getString("key_operator") %>&nbsp;<%= messages.getString("notes") %></h2><br />
							<p>
							<%	while (TicketNotes_RS.next()) { %>
								<strong><%= dateTime.convertUTCtoTimeZone(TicketNotes_RS.getTimeStamp("DATE_TIME")) %>&nbsp;-&nbsp;</strong>
<%-- 								<%= TicketNotes_RS.getString("ADDED_BY") %> -  --%>
								<%= TicketNotes_RS.getString("NOTE") %>
								<br />
							<% } 
								if (TicketNotes_RS.getResultSetSize() == 0) { %>
									<%= messages.getString("none") %>
							<%  } %>
							</p>
						<% if (sStatus.equals("completed")) { %>
							<h2 class="ibm-rule-alternate"><%= messages.getString("resolution") %></h2><br />
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