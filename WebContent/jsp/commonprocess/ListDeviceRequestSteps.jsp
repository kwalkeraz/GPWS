<%
   	TableQueryBhvr NameView  = (TableQueryBhvr) request.getAttribute("NameInfo");
   	TableQueryBhvrResultSet NameView_RS = NameView.getResults();
   	keyopTools tool = new keyopTools();
   	
   	String reqstatusParam = tool.nullStringConverter(request.getParameter("reqstatus_steps"));
   	String reqstatusHead = reqstatusParam;
	if (reqstatusParam.equals("%")) {
    	reqstatusHead = "All";
	}
   
   String actionTypeParam = tool.nullStringConverter(request.getParameter("actiontype"));
   String orderbyParam = tool.nullStringConverter(request.getParameter("orderby_steps"));
   String orderbyHead  = orderbyParam;
   
   	String statusParam = tool.nullStringConverter(request.getParameter("stepstatus"));
   	String statusHead = statusParam.toLowerCase();
   	if (statusParam.equals("%")) {
    	statusHead = "";
   	}

   	if ((orderbyParam.equals("REQ_NUM")) || (orderbyParam.equals("CPAPPROVAL.REQNUM"))) orderbyHead = "request number";
   	if (orderbyParam.equals("DEVICE_NAME")) orderbyHead = "device name";
   	if (orderbyParam.equals("ACTION")) orderbyHead = "request action";
   	if (orderbyParam.equals("REQ_STATUS")) orderbyHead = "request status";
  	if (orderbyParam.equals("STEP")) orderbyHead = "step";
   	if (orderbyParam.equals("ACTION_TYPE")) orderbyHead = "step action";
   	if (orderbyParam.equals("STATUS")) orderbyHead = "step status";
   	if (orderbyParam.equals("ASSIGNEE")) orderbyHead = "assignee";
   	if (orderbyParam.equals("START_DATE")) orderbyHead = "start date";
   	if (orderbyParam.equals("DATE_TIME")) orderbyHead = "date created";
   	if (orderbyParam.equals("REQ_NAME")) orderbyHead = "requester";
   	if (orderbyParam.equals("GEO")) orderbyHead = "geography";
   	if (orderbyParam.equals("CITY")) orderbyHead = "site";
	if (orderbyParam.equals("BUILDING")) orderbyHead = "building";
   
	String theHeading = reqstatusHead+" request "+statusHead+"steps by "+orderbyHead;
   
	DateTime time = new DateTime();
	String sLoggedOnName = "";
	if (request.getSession(false) != null && session.getAttribute("userid") != null) {
		sLoggedOnName = tool.getName(tool.returnInfo( (String)session.getAttribute("serial"), "name"));
	}
	
	String actionVal="";
	String reqnumVal="";
	String reqnameVal="";
	String reqemailVal="";
	String reqtieVal="";
	String reqdateVal="";
	String reqjustVal="";
	String geoVal = "";
	String countryVal = "";
	String stateVal = "";
	String cityVal = "";
	String buildingVal = "";
	String floorVal = "";
	String roomVal = "";
	String prtnameVal = "";	
	String reqstatusVal = "";
	String scheddateVal = "";	
	String devicetypeVal = "";
	int stepVal = 0;
	String actiontypeVal = "";
	String statusVal = "";
	String assigneeVal = "";
	String startdateVal = "";
	
	java.sql.Timestamp datetime;
	boolean bFlag = true;
	int numRequests = 0;
	int shading = 0;
	int cpapprovalid = 0;
	String lastreqnum = "";
	
	String param = "";
	Enumeration e = request.getParameterNames();
	while (e.hasMoreElements()) {
		String name = (String)e.nextElement();
		String value = request.getParameter(name);
		if (!name.equals("ft") && !name.equals("mpp"))
		param = param + "&"+name+"="+value;
	}
	String topageid = tool.nullStringConverter(request.getParameter("to_page_id"));
	String ft = tool.nullStringConverter(request.getParameter("ft"));
	//String mpp = tool.nullStringConverter(request.getParameter("mpp"));
	if (ft.equals("")) ft = "0";
	//if (mpp.equals("")) mpp = "50";
	
	int iNumReq = 0;
	while (NameView_RS.next()) {
		iNumReq++;
	}
	NameView_RS.first();
	
	int iFirst = Integer.parseInt(ft);
	//if (Integer.toString(iFirst) == "") iFirst = 0;
	int iReqCounter = iFirst;
	//int iReqPP = Integer.parseInt(tool.nullStringConverter(request.getParameter("mpp")));
	int iReqPP = 20;
	if (iFirst > 0) {
		// Iterate to the iFirst value
		for (int j = 0; j < iFirst; j++) {
			NameView_RS.next();
		} // for loop
	}
	int iReqMax = iFirst + iReqPP;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device requests by steps"/>
	<meta name="Description" content="Global print view device requests by steps" />
	<title><%= messages.getString("global_print_title") %> | <%= theHeading %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 
	 function callRequest(devicename,cpapprovalid,referer,reqstatus,stepstatus,actiontype,orderby) {
	 	var params ="&devicename=" + devicename + "&cpapprovalid=" + cpapprovalid + "&referer=" + referer + "&reqstatus_steps=" + reqstatus + "&stepstatus=" + stepstatus + "&actiontype_steps=" + actiontype + "&orderby_steps=" + orderby;
		var targettype = "1105";
		var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=" + targettype + params;
		document.location.href = uRL;
	 } //callRequest
	 	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 dojo.addOnLoad(function() {
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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
			</ul>
			<h1><%= theHeading %></h1>
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
			<div id='addDriver'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<p class="ibm-table-navigation">
					<span class="ibm-primary-navigation"> 
						<% if (iReqMax > iNumReq) { %>
							<strong><%= iFirst + 1 %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("results") %>
						<% } else { %>
							<strong><%= iFirst + 1 %>-<%= iReqCounter + iReqPP %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("results") %>
						<% } %>
						<span class="ibm-table-navigation-links"> 
							<% if (iFirst > 0) { %>
							| <a class="ibm-back-em-link" href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=<%= topageid %>&reqstatus=<%= reqstatusParam %>&stepstatus=<%= statusParam %>&actiontype=<%= actionTypeParam %>&orderby=<%= orderbyParam %>&ft=<%= iFirst - iReqPP %>"><%= messages.getString("previous") %></a> 
							<% } //if > 0 %>
							<% if (iReqMax < iNumReq) { %>
							| <a class="ibm-forward-em-link" href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=<%= topageid %>&reqstatus=<%= reqstatusParam %>stepstatus=<%= statusParam %>&actiontype=<%= actionTypeParam %>&orderby=<%= orderbyParam %>&ft=<%= iReqMax %>"><%= messages.getString("next") %></a>
							<% } //if iReqMax %>
						</span>
					</span>
				</p> 
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display current workflow requests">
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_request_number") %></th>
							<th scope="col"><%= messages.getString("device_name") %></th>
							<th scope="col"><%= messages.getString("request_action") %></th>
							<th scope="col"><%= messages.getString("request_status") %></th>
							<th scope="col"><%= messages.getString("step") %></th>
							<th scope="col"><%= messages.getString("routing_status") %></th>
							<th scope="col"><%= messages.getString("assignee") %></th>
							<th scope="col"><%= messages.getString("start_date") %></th>
							<th scope="col"><%= messages.getString("city") %></th>
							<th scope="col"><%= messages.getString("building") %></th>
						</tr>
					</thead>
					<tbody>
						<%	int numActions = 0;
							while(NameView_RS.next()) {
								cpapprovalid=NameView_RS.getInt("CPAPPROVALID");
								actionVal=NameView_RS.getString("ACTION");
								reqnumVal=NameView_RS.getString("REQ_NUM");
								reqnameVal=NameView_RS.getString("REQ_NAME");
								reqemailVal=NameView_RS.getString("REQ_EMAIL");
								reqtieVal=NameView_RS.getString("REQ_PHONE");
								reqdateVal=NameView_RS.getString("REQ_DATE");
								reqjustVal=NameView_RS.getString("REQ_JUSTIFICATION");
								geoVal = NameView_RS.getString("GEO");
								countryVal = NameView_RS.getString("COUNTRY");
								stateVal = NameView_RS.getString("STATE");
								cityVal = NameView_RS.getString("CITY");
								buildingVal = NameView_RS.getString("BUILDING");
								floorVal = NameView_RS.getString("FLOOR");
								roomVal = NameView_RS.getString("ROOM");
								prtnameVal = NameView_RS.getString("DEVICE_NAME");
								reqstatusVal = NameView_RS.getString("REQ_STATUS");
								scheddateVal = NameView_RS.getString("APPROVAL_SCHED_DATE");
								datetime = NameView_RS.getTimeStamp("DATE_TIME");
								stepVal = NameView_RS.getInt("STEP");
								actiontypeVal = NameView_RS.getString("ACTION_TYPE");
								statusVal = NameView_RS.getString("STATUS");
								assigneeVal = NameView_RS.getString("ASSIGNEE");
								startdateVal = NameView_RS.getString("START_DATE");
							%>
								<tr>
									<% if (!lastreqnum.equals(reqnumVal)) { %>
									<td>
										<a class="prtadmin-navlink-small" href="javascript:callRequest('<%= prtnameVal%>','<%= cpapprovalid %>','<%= request.getParameter(BehaviorConstants.TOPAGE) %>','<%= request.getParameter("reqstatus_steps") %>','<%= request.getParameter("stepstatus") %>','<%= request.getParameter("actiontype_steps") %>','<%= request.getParameter("orderby_steps") %>');"><%= reqnumVal %></a>
									</td>
									<td><%= prtnameVal %></td>
									<td><%= actionVal %></td>
									<td><%= reqstatusVal %></td>
									<% } else { %>
									<td colspan="4"></td>
									<% } %>
									<td><%= stepVal %></td>
									<td><%= statusVal %></td>
									<td><%= assigneeVal %></td>
									<td><% if (startdateVal != null) { %><%= startdateVal %><% } %></td>
									<td><%= cityVal %></td>
									<td><%= buildingVal %></td>
								</tr>
						<%		numActions++;
								iReqCounter++; 
								lastreqnum = reqnumVal;
							}
						%>
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