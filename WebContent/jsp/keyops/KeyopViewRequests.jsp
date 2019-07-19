<%
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	
	String sNextPageId = request.getParameter("next_page_id");

	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	String sOrderBy = "KEYOP_REQUESTID DESC";
	String sOrderByTicketNum = "KEYOP_REQUESTID DESC";
	String sOrderByReqName = "REQUESTOR_NAME ASC";
	String sOrderByTimeSubmit = "TIME_SUBMITTED DESC";
	String sOrderByCity = "CITY ASC, BUILDING, ROOM, FLOOR";
	String sOrderByDevice = "DEVICE_NAME ASC";
	String sOrderByDeviceType = "DEVICE_TYPE ASC";
	Connection con = null;
	Statement stmtReq = null;
	ResultSet rsReq = null;
	int iUserID = Integer.parseInt(request.getParameter("userid"));
	
	int iKOCompanyID = pupb.getVendorID();
	
	if(request.getParameter("orderby") != null) {
		sOrderBy = request.getParameter("orderby");
	}
	
	if (sOrderBy.equals("KEYOP_REQUESTID DESC")) {
		sOrderByTicketNum = "KEYOP_REQUESTID ASC";
	}
	
	if (sOrderBy.equals("REQUESTOR_NAME ASC")) {
		sOrderByReqName = "REQUESTOR_NAME DESC";
	}
	
	if (sOrderBy.equals("TIME_SUBMITTED DESC")) {
		sOrderByTimeSubmit = "TIME_SUBMITTED ASC";
	}
	
	if (sOrderBy.equals("CITY ASC, BUILDING, ROOM, FLOOR")) {
		sOrderByCity = "CITY DESC, BUILDING, ROOM, FLOOR";
	}
	
	if (sOrderBy.equals("DEVICE_NAME ASC")) {
		sOrderByDevice = "DEVICE_NAME DESC";
	}
	
	if (sOrderBy.equals("DEVICE_TYPE ASC")) {
		sOrderByDeviceType = "DEVICE_TYPE DESC";
	}
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, view requests"/>
<meta name="Description" content="This page lists keyop requests in the system and is only viewable by key operators." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_requests") %></title>
<%@ include file="metainfo2.jsp" %>
<%
	String sTitle = "requests";
	if (sNextPageId.equals("2042")) {
		sTitle = messages.getString("new_requests");
	} else if (sNextPageId.equals("2044")) {
		sTitle = messages.getString("in_progress_requests");
	} else if (sNextPageId.equals("2046")) {
		sTitle = messages.getString("in_progress_requests") + " - " + messages.getString("assigned_to") + " " + pupb.getUserFirstName() + " " + pupb.getUserLastName();
	} else if (sNextPageId.equals("2045")) {
		sTitle = messages.getString("completed_requests");
	} else if (sNextPageId.equals("2043")) {
		sTitle = messages.getString("completed_requests") + " - " + messages.getString("assigned_to") + " " + pupb.getUserFirstName() + " " + pupb.getUserLastName();
	}
%>
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
			<h1><%= sTitle %></h1>
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

<%
	String sql = "";	
	if (sNextPageId.equals("2042")) { // New my sites
		sql = "SELECT R.KEYOP_REQUESTID, R.REQ_STATUS, R.REQUESTOR_EMAIL, R.REQUESTOR_NAME, R.REQUESTOR_TIELINE, R.REQUESTOR_EXT_PHONE, R.TIME_SUBMITTED, R.CITY, R.DEVICE_NAME, R.DEVICE_TYPE, R.BUILDING, R.FLOOR, R.ROOM FROM GPWS.KEYOP_REQUEST_VIEW R WHERE LOWER(R.REQ_STATUS) = 'new' AND R.KO_COMPANYID = " + iKOCompanyID + " AND (R.CITYID IN (SELECT CITYID FROM GPWS.KEYOP_SITE WHERE ENTIRE_SITE = 'Y' AND USERID = " + iUserID + ") OR R.BUILDINGID IN (SELECT BUILDINGID FROM GPWS.KEYOP_BUILDING WHERE USERID = " + iUserID + ")) ORDER BY R.KEYOP_REQUESTID";
	} else if (sNextPageId.equals("2044")) { // In progress my sites
		sql = "SELECT R.KEYOP_REQUESTID, R.REQ_STATUS, R.REQUESTOR_EMAIL, R.REQUESTOR_NAME, R.REQUESTOR_TIELINE, R.REQUESTOR_EXT_PHONE, R.TIME_SUBMITTED, R.CITY, R.DEVICE_NAME, R.DEVICE_TYPE, R.BUILDING, R.FLOOR, R.ROOM, R.KEYOP_USERID, R.KEYOP_FNAME, R.KEYOP_LNAME FROM GPWS.KEYOP_REQUEST_VIEW R WHERE R.KO_COMPANYID = " + iKOCompanyID + " AND (LOWER(REQ_STATUS) = 'in progress' OR UPPER(REQ_STATUS) = 'HOLD') AND (R.CITYID IN (SELECT CITYID FROM GPWS.KEYOP_SITE WHERE USERID = " + iUserID + " AND ENTIRE_SITE = 'Y') OR R.BUILDINGID IN (SELECT BUILDINGID FROM GPWS.KEYOP_BUILDING WHERE USERID = " + iUserID + ")) ORDER BY " + sOrderBy;
	} else if (sNextPageId.equals("2046")) { //In progress assigned to me
		sql = "SELECT R.KEYOP_REQUESTID, R.REQ_STATUS, R.REQUESTOR_EMAIL, R.REQUESTOR_NAME, R.REQUESTOR_TIELINE, R.REQUESTOR_EXT_PHONE, R.TIME_SUBMITTED, R.CITY, R.DEVICE_NAME, R.DEVICE_TYPE, R.BUILDING, R.FLOOR, R.ROOM, R.KEYOP_USERID FROM GPWS.KEYOP_REQUEST_VIEW R WHERE R.KO_COMPANYID = " + iKOCompanyID + " AND R.KEYOP_USERID = " + iUserID + " AND (R.REQ_STATUS = 'in progress' OR R.REQ_STATUS = 'HOLD') ORDER BY " + sOrderBy;
	} else if (sNextPageId.equals("2045")) { // Completed my sites
		sql = "SELECT R.KEYOP_REQUESTID, R.REQ_STATUS, R.REQUESTOR_EMAIL, R.REQUESTOR_NAME, R.REQUESTOR_TIELINE, R.REQUESTOR_EXT_PHONE, R.TIME_SUBMITTED, R.CITY, R.DEVICE_NAME, R.DEVICE_TYPE, R.BUILDING, R.FLOOR, R.ROOM, R.KEYOP_NAME, R.KEYOP_FNAME, R.KEYOP_LNAME FROM GPWS.KEYOP_REQUEST_VIEW R WHERE R.KO_COMPANYID = " + iKOCompanyID + " AND LOWER(REQ_STATUS) = 'completed' AND (R.CITYID IN (SELECT CITYID FROM GPWS.KEYOP_SITE WHERE USERID = " + iUserID + " AND ENTIRE_SITE = 'Y') OR R.BUILDINGID IN (SELECT BUILDINGID FROM GPWS.KEYOP_BUILDING WHERE USERID = " + iUserID + ")) ORDER BY " + sOrderBy;
	} else if (sNextPageId.equals("2043")) { // Completed closed by me
		sql = "SELECT R.KEYOP_REQUESTID, R.REQ_STATUS, R.REQUESTOR_EMAIL, R.REQUESTOR_NAME, R.REQUESTOR_TIELINE, R.REQUESTOR_EXT_PHONE, R.TIME_SUBMITTED, R.CITY, R.DEVICE_NAME, R.DEVICE_TYPE, R.BUILDING, R.FLOOR, R.ROOM, R.KEYOP_NAME FROM GPWS.KEYOP_REQUEST_VIEW R WHERE R.KO_COMPANYID = " + iKOCompanyID + " AND LOWER(R.REQ_STATUS) = 'completed' AND R.KEYOP_USERID = " + iUserID + " ORDER BY " + sOrderBy;
	}
	
	try {
		con = tool.getConnection();
		stmtReq = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		rsReq = stmtReq.executeQuery(sql);
		
%>
<% if(sOrderBy.equals("KEYOP_REQUESTID DESC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("ticket_number") %> (<%= messages.getString("descending") %>)</p>
<% } else if(sOrderBy.equals("KEYOP_REQUESTID ASC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("ticket_number") %> (<%= messages.getString("ascending") %>)</p>
<% } else if(sOrderBy.equals("TIME_SUBMITTED DESC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("time_opened") %> (<%= messages.getString("descending") %>)</p>
<% } else if(sOrderBy.equals("TIME_SUBMITTED ASC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("time_opened") %> (<%= messages.getString("ascending") %>)</p>
<% } else if(sOrderBy.equals("CITY ASC, BUILDING, ROOM, FLOOR")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("site") %> (<%= messages.getString("ascending") %>)</p>
<% } else if(sOrderBy.equals("CITY DESC, BUILDING, ROOM, FLOOR")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("site") %> (<%= messages.getString("descending") %>)</p>
<% } else if(sOrderBy.equals("DEVICE_NAME ASC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("device") %> (<%= messages.getString("ascending") %>)</p>
<% } else if(sOrderBy.equals("DEVICE_NAME DESC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("device") %> (<%= messages.getString("descending") %>)</p>
<% } else if(sOrderBy.equals("DEVICE_TYPE ASC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("type") %> (<%= messages.getString("ascending") %>)</p>
<% } else if(sOrderBy.equals("DEVICE_TYPE DESC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("type") %> (<%= messages.getString("descending") %>)</p>
<% } else if(sOrderBy.equals("REQUESTOR_NAME ASC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("opened_by") %> (<%= messages.getString("ascending") %>)</p>
<% } else if(sOrderBy.equals("REQUESTOR_NAME DESC")) { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("opened_by") %> (<%= messages.getString("descending") %>)</p>
<% } else { %>
		<p><%= messages.getString("sorted_by") %>: <%= messages.getString("unsorted") %></p>
<% } %>
<%  int iNumReq = 0;
	while (rsReq.next()) {
		iNumReq++;
	}
	rsReq.beforeFirst();
	int iFirst = 0;
	if (request.getParameter("ft") != null) {
		iFirst = Integer.parseInt(request.getParameter("ft"));
	}
	int iReqCounter = iFirst;
	int iReqPP = 100;
	if (request.getParameter("mpp") != null) {
		iReqPP = Integer.parseInt(request.getParameter("mpp"));
	}
	if (iFirst > 0) {
		rsReq.absolute(iFirst);	
	}
	int iReqMax = iFirst + iReqPP;
%>
<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
<% if (iNumReq == 0) { %>
	<strong><%= iFirst %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("requests") %>
<% } else if (iReqMax > iNumReq) { %>
	<strong><%= iFirst + 1 %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("requests") %>
<% } else { %>
	<strong><%= iFirst + 1 %>-<%= iReqCounter + iReqPP %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("requests") %>
<% } %>
<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderBy %>&userid=<%= iUserID %>&ft=<%= iFirst - iReqPP %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderBy %>&userid=<%= iUserID %>&ft=<%= iReqMax %>"><%= messages.getString("next") %></a><% } %></span></p>
	<div class="ibm-rule"><hr /></div>
			<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="A list of keyop requests.">
				<caption><em><%= messages.getString("keyop_requests") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><a href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderByTicketNum %>&userid=<%= iUserID %>&ft=<%= iFirst %>"><%= messages.getString("ticket") %></a></th>
							<th scope="col"><%= messages.getString("status") %></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderByReqName %>&userid=<%= iUserID %>&ft=<%= iFirst %>"><%= messages.getString("opened_by") %></a></th>
							<th scope="col"><%= messages.getString("tieline") %></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderByTimeSubmit %>&userid=<%= iUserID %>&ft=<%= iFirst %>"><%= messages.getString("time_opened") %></a></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderByDevice %>&userid=<%= iUserID %>&ft=<%= iFirst %>"><%= messages.getString("device") %></a></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderByDeviceType %>&userid=<%= iUserID %>&ft=<%= iFirst %>"><%= messages.getString("type") %></a></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=<%= sNextPageId %>&orderby=<%= sOrderByCity %>&userid=<%= iUserID %>&ft=<%= iFirst %>"><%= messages.getString("site") %></a></th>
							<th scope="col"><%= messages.getString("building") %></th>
							<th scope="col"><%= messages.getString("floor") %></th>
							<th scope="col"><%= messages.getString("room") %></th>
							<% if (sNextPageId.equals("2045") || sNextPageId.equals("2044")) { %>
							<th scope="col"><%= messages.getString("Keyop") %></th>
							<% } %>
						</tr>
					</thead>
					<tbody>
<%
	DateTime dateTime = new DateTime();
	int numRequests = 0;
	int shading = 0;
	while (rsReq.next() && iReqCounter < iReqMax) { %>
			<tr>
				<td><a href='<%= keyops %>?next_page_id=2017&amp;ticketno=<%= rsReq.getInt("KEYOP_REQUESTID") %>'><%= rsReq.getInt("KEYOP_REQUESTID") %></a></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("REQ_STATUS")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("REQUESTOR_NAME")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("REQUESTOR_TIELINE")) %></td>
				<td><%= dateTime.convertUTCtoTimeZone(rsReq.getTimestamp("TIME_SUBMITTED")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("DEVICE_NAME")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("DEVICE_TYPE")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("CITY")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("BUILDING")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("FLOOR")) %></td>
				<td><%= appTool.nullStringConverter(rsReq.getString("ROOM")) %></td>
				<% if (sNextPageId.equals("2045") || sNextPageId.equals("2044")) { %>
				<td><%= appTool.nullStringConverter(rsReq.getString("KEYOP_LNAME")) %>, <%= appTool.nullStringConverter(rsReq.getString("KEYOP_FNAME")) %></td>
				<% } %>
			</tr>
<%		numRequests++;
		iReqCounter++;
	}
%>
					</tbody>
				</table>
	<div class="ibm-rule"><hr /></div>
<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
<% if (iNumReq == 0) { %>
	<strong><%= iFirst %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("requests") %>
<% } else if (iReqMax > iNumReq) { %>
	<strong><%= iFirst + 1 %>-<%= iNumReq %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("requests") %>
<% } else { %>
	<strong><%= iFirst + 1 %>-<%= iReqCounter + iReqPP %></strong> <%= messages.getString("of") %> <strong><%= iNumReq %></strong> <%= messages.getString("requests") %>
<% } %>
<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=<%= sNextPageId %>&userid=<%= iUserID %>&ft=<%= iFirst - iReqPP %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=<%= sNextPageId %>&userid=<%= iUserID %>&ft=<%= iReqMax %>"><%= messages.getString("next") %></a><% } %></span></p>
<%
	if (numRequests == 0) {			
%>
		<p><%= messages.getString("no_requests_found") %></p>
<%	}
	
	} catch (Exception e) {
		System.out.println("Keyop error in KeyopViewRequests.jsp ERROR: " + e);
	} finally {
		if (rsReq != null)
			rsReq.close();
		if (stmtReq != null)
			stmtReq.close();
		if (con != null)
			con.close();
	}
%>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>