<%
   com.ibm.aurora.bhvr.TableQueryBhvr RequestInfo  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("RequestInfo");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet RequestInfo_RS = RequestInfo.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr CPRouting  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CPRouting");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet CPRouting_RS = CPRouting.getResults();
   
   DateTime dateTime = new DateTime();
	AppTools appTool = new AppTools();
	int numTickets = 0;
	int iCPApprovalID = 0;
	String sAction = "";
	String sReqName = "";
	String sDeviceName = "";
	String sReqEmail = "";
	String sReqPhone = "";
	String sReqDate = "";
	String sReqJust = "";
	String sReqNum = "";
	String sGeo = "";
	String sCountry = "";
	String sState = "";
	String sCity = "";
	String sBuilding = "";
	String sFloor = "";
	String sRoom = "";
	String sReqStatus = "";
	String sSchedDate = "";
	String sCompleteDate = "";
	String sComments = "";
	String sTimeSubmitted = "";
	String sOtherModel = "";
	
	while(RequestInfo_RS.next()) {
		iCPApprovalID = RequestInfo_RS.getInt("CPAPPROVALID");
		sAction = appTool.nullStringConverter(RequestInfo_RS.getString("ACTION"));
		sReqName = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_NAME"));
		sDeviceName = appTool.nullStringConverter(RequestInfo_RS.getString("DEVICE_NAME"));
		sReqEmail = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_EMAIL"));
		sReqPhone = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_PHONE"));
		sReqDate = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_DATE"));
		sReqJust = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_JUSTIFICATION"));
		sReqNum = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_NUM"));
		sGeo = appTool.nullStringConverter(RequestInfo_RS.getString("GEO"));
		sCountry = appTool.nullStringConverter(RequestInfo_RS.getString("COUNTRY"));
		sState = appTool.nullStringConverter(RequestInfo_RS.getString("STATE"));
		sCity = appTool.nullStringConverter(RequestInfo_RS.getString("CITY"));
		sBuilding = appTool.nullStringConverter(RequestInfo_RS.getString("BUILDING"));
		sFloor = appTool.nullStringConverter(RequestInfo_RS.getString("FLOOR"));
		sRoom = appTool.nullStringConverter(RequestInfo_RS.getString("ROOM"));
		sReqStatus = appTool.nullStringConverter(RequestInfo_RS.getString("REQ_STATUS"));
		sSchedDate = appTool.nullStringConverter(RequestInfo_RS.getString("SCHED_DATE"));
		sCompleteDate = appTool.nullStringConverter(RequestInfo_RS.getString("COMPLETE_DATE"));
		sComments = appTool.nullStringConverter(RequestInfo_RS.getString("COMMENTS"));
		sTimeSubmitted = dateTime.convertUTCtoTimeZone(RequestInfo_RS.getTimeStamp("DATE_TIME"));
		sOtherModel = appTool.nullStringConverter(RequestInfo_RS.getString("OTHER_MODEL"));
		
		numTickets++;
	}

%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device request information"/>
	<meta name="Description" content="Global print website information regarding a MACDEL request, including the status and the steps that have been completed" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("request_information") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/formatDate.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.ready(function() {
	 	createpTag();
	 	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
	 });
	 
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead.jsp" %>
		<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
					<ul id="ibm-navigation-trail">
						<li><a href="<%= statichtmldir %>/ServiceRequests.html"><%= messages.getString("service_requests") %></a></li>
						<li><a href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("macdel_requests") %></a></li>
					</ul>
					<h1><%= messages.getString("request_information") %></h1>
				</div>
			</div>
			<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
		<!-- CONTENT_BODY -->
		<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<% if (numTickets == 1) { %>
			<div id='Device'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("required_information") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:</label>
					<span><strong><%= sReqStatus %></strong></span>
				</div>
				<div class="pClass">
					<label for='timeopened'><%= messages.getString("time_opened") %>:</label>
					<span><%= sTimeSubmitted %></span>
				</div>
				<div class="pClass">
					<label for='action'><%= messages.getString("action") %>:</label>
					<span><%= sAction %></span>
				</div>
				<div class="pClass">
					<label for='justification'><%= messages.getString("justification") %>:</label>
					<span><%= sReqJust %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("user_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='requestername'><%= messages.getString("name") %>:</label>
					<span><%= sReqName %></span>
				</div>
				<div class="pClass">
					<label for='phone'><%= messages.getString("ext_phone") %>:</label>
					<span><%= sReqPhone %></span>
				</div>
				<div class="pClass">
					<label for='email'><%= messages.getString("email") %>:</label>
					<span><%= sReqEmail %></span>
				</div>
				<div class="pClass">
					<label for='completedate'><%= messages.getString("requested_complete_date") %> (dd/mm/yyyy):</label>
					<span><%= sReqDate %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for="device">
						<%= messages.getString("device_name") %>: 
					</label>
					<span>
						<%= sDeviceName %>
					</span>
				</div>
				<div class="pClass">
					<label for="site">
						<%= messages.getString("site") %>: 
					</label>
					<span>
						<%= sCity %>
					</span>
				</div>
				<div class="pClass">	
					<label id="buildinglabel" for="building">
						<%= messages.getString("building") %>:
					</label>
					<span>
						<%= sBuilding %>
					</span>
				</div>
				<div class="pClass">
					<label for="floor">
						<%= messages.getString("floor") %>:
					</label>
					<span>
						<%= sFloor %>
					</span>
				</div>
				<div class="pClass">
					<label for='room'><%= messages.getString("room") %>:</label>
					<span><%= sRoom %></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("date") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='schedate'><%= messages.getString("scheduled_date") %> (dd/mm/yyyy):</label>
					<span><%= sSchedDate %></span>
				</div>
				<div class="pClass">
					<label for='completedate'><%= messages.getString("completed_date") %> (dd/mm/yyyy):</label>
					<span><%= sCompleteDate %></span>
				</div>
				<div class="pClass">
					<label for='comments'><%= messages.getString("comments") %>:</label>
					<span>
						<%  if (sComments.equals("")) { %>
								<%= messages.getString("none") %>
						<%	} else { %>
								<%= sComments %>
						<%	} %>
					</span>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List of common process request steps">
					<caption><em></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("step") %></th>
							<th scope="col"><%= messages.getString("action_type") %></th>
							<th scope="col"><%= messages.getString("status") %></th>
							<th scope="col"><%= messages.getString("start_date") %> (dd/mm/yyyy)</th>
						</tr>
					</thead>
					<tbody>
					<% while (CPRouting_RS.next()) { %>
					   	<tr>
							<td><%= CPRouting_RS.getInt("STEP") %></td>
							<td><%= appTool.nullStringConverter(CPRouting_RS.getString("ACTION_TYPE")) %></td>
							<td><%= appTool.nullStringConverter(CPRouting_RS.getString("STATUS")) %></td>
							<td><%= appTool.nullStringConverter(CPRouting_RS.getString("START_DATE")) %></td>
						</tr>
					<% } %>
					</tbody>
				</table>
			</div>
			<% } else if (numTickets == 0) { %>
			<div class="pClass">
				<%= messages.getString("sorry_request") %> <strong><%= request.getParameter("reqnum") %></strong> <%= messages.getString("not_found") %>.
			</div>
			<% } else { %>
			<div class="pClass">
				<%= messages.getString("an_error_has_occurred") %>
			</div>
			<% } %>	
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>