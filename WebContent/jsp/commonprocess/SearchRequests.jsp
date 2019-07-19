<%
   TableQueryBhvr AllRequests  = (TableQueryBhvr) request.getAttribute("SearchReqView");
   TableQueryBhvrResultSet AllRequests_RS = AllRequests.getResults();
   
   keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	String ft = tool.nullStringConverter(request.getParameter("ft"));
	System.out.println("ft is " + ft);
	//String mpp = tool.nullStringConverterrequest.getParameter("mpp"));
	if (ft.equals("")) ft = "0";
	int iNumReq = 0;
	String reqnum = tool.nullStringConverter(request.getParameter("reqnum"));
	reqnum = reqnum.replaceAll("%","%25");
	
	while (AllRequests_RS.next()) {
		iNumReq++;
	}
	AllRequests_RS.first();
	String topageid = tool.nullStringConverter(request.getParameter("to_page_id"));
	
	int iFirst = 0; 
	iFirst = Integer.parseInt(ft);
	//if (Integer.toString(iFirst) == "") iFirst = 0;
	int iReqCounter = iFirst;
	//int iReqPP = Integer.parseInt(tool.nullStringConverter(request.getParameter("mpp")));
	int iReqPP = 20;
	System.out.println("did it make it this far? ");
	if (iFirst > 0) {
		// Iterate to the iFirst value
		for (int j = 0; j < iFirst; j++) {
			AllRequests_RS.next();
		} // for loop
	}
	int iReqMax = iFirst + iReqPP;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device requests"/>
	<meta name="Description" content="Global print lists the results from the request search" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_view_by_request_number") %>: <%= reqnum %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.Button");
	 	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function onChangeCall(){
	 	return false;
	 } //onChangeCall
	 
	 dojo.addOnLoad(function() {
	 	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1001');
        createpTag();
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
			<h1><%= messages.getString("cp_view_by_request_number") %>: <%= reqnum %></h1>
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
			<div id='City'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
			</div>
			<% if (iNumReq == 0) { %>
			<p><%= messages.getString("no_requests_found") %></p>
			<% } else {%>
			<p class="ibm-table-navigation">
				<span class="ibm-primary-navigation"> 
					<% if (iReqMax > iNumReq) { %>
						<strong><%= iFirst + 1 %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("results") %>
					<% } else { %>
						<strong><%= iFirst + 1 %>-<%= iReqCounter + iReqPP %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("results") %>
					<% } %>
					<span class="ibm-table-navigation-links"> 
						<% if (iFirst > 0) { %>
						| <a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1002&reqnum=&ft=<%= iFirst - iReqPP %>"><%= messages.getString("previous") %></a> 
						<% } //if > 0 %>
						<% if (iReqMax < iNumReq) { %>
						| <a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1002&reqnum=&ft=<%= iReqMax %>"><%= messages.getString("next") %></a>
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
						<th scope="col"><%= messages.getString("status") %></th>
						<th scope="col"><%= messages.getString("time_submitted") %></th>
						<th scope="col"><%= messages.getString("requester_name") %></th>
						<th scope="col"><%= messages.getString("city") %></th>
						<th scope="col"><%= messages.getString("building") %></th>
					</tr>
				</thead>
				<tbody>
					<%	DateTime dateTime = new DateTime();
						while(AllRequests_RS.next() && iReqCounter < iReqMax) { %>
							<tr>
								<td><a href='<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1003&reqnum=<%= appTool.nullStringConverter(AllRequests_RS.getString("REQ_NUM")).toUpperCase() %>&cpapprovalid=<%= AllRequests_RS.getInt("CPAPPROVALID") %>'><%= appTool.nullStringConverter(AllRequests_RS.getString("REQ_NUM")) %></a></td>
								<td><%= appTool.nullStringConverter(AllRequests_RS.getString("DEVICE_NAME")) %></td>
								<td><%= appTool.nullStringConverter(AllRequests_RS.getString("ACTION")) %></td>
								<td><%= appTool.nullStringConverter(AllRequests_RS.getString("REQ_STATUS")) %></td>
								<td><%= dateTime.convertUTCtoTimeZone(AllRequests_RS.getTimeStamp("DATE_TIME")) %></td>
								<td><%= appTool.nullStringConverter(AllRequests_RS.getString("REQ_NAME")) %></td>
								<td><%= appTool.nullStringConverter(AllRequests_RS.getString("CITY")) %></td>
								<td><%= appTool.nullStringConverter(AllRequests_RS.getString("BUILDING")) %></td>
							</tr>
					<%		iReqCounter++; 
						}
					%>
				</tbody>
			</table>
			<% } %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>