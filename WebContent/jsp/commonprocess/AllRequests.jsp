<%
   TableQueryBhvr AllRequests  = (TableQueryBhvr) request.getAttribute("AllReqView");
   TableQueryBhvrResultSet AllRequests_RS = AllRequests.getResults();
   
   TableQueryBhvr AllSites  = (TableQueryBhvr) request.getAttribute("AllSitesView");
   TableQueryBhvrResultSet AllSites_RS = AllSites.getResults();
   
   keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	int cityid = 0;
	cityid = Integer.parseInt(request.getParameter("cityid"));
	String ft = tool.nullStringConverter(request.getParameter("ft"));
	String month = tool.nullStringConverter(request.getParameter("month"));
	//String mpp = tool.nullStringConverterrequest.getParameter("mpp"));
	if (ft.equals("")) ft = "0";
	int iNumReq = 0;
	
	while (AllRequests_RS.next()) {
		iNumReq++;
	}
	AllRequests_RS.first();
	String topageid = tool.nullStringConverter(request.getParameter("to_page_id"));
	
	int iFirst = Integer.parseInt(ft);
	//if (Integer.toString(iFirst) == "") iFirst = 0;
	int iReqCounter = iFirst;
	//int iReqPP = Integer.parseInt(tool.nullStringConverter(request.getParameter("mpp")));
	int iReqPP = 20;
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
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("view_macdel_req") %>: <%= tool.getSiteName(Integer.parseInt(request.getParameter("cityid"))) %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.Button");
	 	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function addSite(){
	 	var dID = "cityid";
	 	var selectMenu = dijit.byId(dID);
	 	selectMenu.removeOption(selectMenu.getOptions());
	 	<% while(AllSites_RS.next()) {
				int iCityid = AllSites_RS.getInt("CITYID");
				String city = appTool.nullStringConverter(AllSites_RS.getString("CITY")); %>
   			var optionName = "<%= city %>";
   			var optionValue = "<%= iCityid %>";
   			addOption(dID,optionName,optionValue);
   		<% } %>
	 } //addSite
	 
	 function addMonths() {
	 	var dID = "month";
	 	var selectMenu = dijit.byId(dID);
	 	selectMenu.removeOption(selectMenu.getOptions());
	 	addOption(dID,"3 <%= messages.getString("months") %>",3);
	 	addOption(dID,"6 <%= messages.getString("months") %>",6);
	 	addOption(dID,"9 <%= messages.getString("months") %>",9);
	 	addOption(dID,"12 <%= messages.getString("months") %>",12);
	 	addOption(dID,"24 <%= messages.getString("months") %>",24);
	 } //addMonths
	 
	 function onChangeCall(){
	 	return false;
	 } //onChangeCall
	 
	 function refreshView() {
		var formName = dijit.byId("CityForm");
		formName.submit();
	 } //refreshView
	 
	 dojo.addOnLoad(function() {
	 	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1001');
        createpTag();
	 	createSelect('cityid', 'cityid', '', '', 'site');
	 	addSite();
	 	autoSelectValue('cityid','<%=cityid%>');
	 	createSelect('month', 'month', '', '', 'months');
	 	addMonths();
	 	autoSelectValue('month','<%=month%>');
	 	createInputButton('submit_refresh_button','ibm-cancel','<%= messages.getString("refresh_view") %>','ibm-btn-cancel-sec','refresh_view','refreshView()');
	 	createGetForm('City','CityForm','CityForm','ibm-column-form','<%= commonprocess %>');
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
			<h1><%= messages.getString("view_macdel_req") %></h1>
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
			<ul>
				<li><%= messages.getString("view_select_site") %></li>
				<li><%= messages.getString("view_select_last_month") %></li>
			</ul>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='City'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="ibm-container-body ibm-three-column">
					<div class="ibm-column ibm-first">
						<h2><%= messages.getString("current_site") %>: </h2>
					</div>
					<div class="ibm-column ibm-second">
						<h2><label for='months'><%= messages.getString("show_last") %></label></h2>
					</div>
					<div class="ibm-column ibm-third">
						<h2><label for='site'><%= messages.getString("select_site") %></label></h2>
					</div>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="ibm-container-body ibm-three-column">
					<div class="ibm-column ibm-first">
						<strong><%= tool.getSiteName(Integer.parseInt(request.getParameter("cityid"))) %></strong>
					</div>
					<div class="ibm-column ibm-second">
						<span><div id='months'></div></span>
					</div>
					<div class="ibm-column ibm-third">
						<span><div id='site'></div></span>
					</div>
				</div>
				<br />
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="ibm-container-body ibm-three-column">
					<div class="ibm-column ibm-first">
						<span><div id='submit_refresh_button'></div></span>
					</div>
					<div class="ibm-column ibm-second">
						<span></span>
					</div>
					<div class="ibm-column ibm-third">
						<span></span>
					</div>
				</div>
				<div class="pClass"></div>
			</div>
			<% if (request.getParameter("cityid").equals("0")) { %>
			<p><%= messages.getString("select_site_view_macdel_req") %></p>
			<% } else { %>
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