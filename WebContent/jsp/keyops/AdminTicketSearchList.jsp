<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin ticket search list"/>
<meta name="Description" content="This is the results page for when an admin updates, adds, or delets a system close code." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("admin_ticket_search_list_title") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript">
function goBack() {
		self.location.href = "<%= keyops %>?next_page_id=3076";
	}
</script>
<% 
	AppTools appTool = new AppTools();
	keyopTools tool = new keyopTools();

	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	int iVendorID = pupb.getVendorID();
	
	String[] sAuthTypes = pupb.getAuthTypes();
	boolean isKOSU = false;
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("Keyop Superuser")) {
			isKOSU = true;
		}
	}

	Connection con = null;
	Statement stmtTicket = null;
	ResultSet rsTicket = null;
	String sTicketNum = "";
	String sPrinter = "";
	String sReqName = "";
	String sKeyopName = "";
	int iKeyopID = 0;
	String sSiteName = "";
	String sBuilding = "";
	sTicketNum = request.getParameter("ticketstart");
	sPrinter = request.getParameter("printer");
	sReqName = request.getParameter("reqname");
	//sKeyopName = request.getParameter("keyopname");
	sKeyopName = request.getParameter("keyopuserid");
	if (sKeyopName != null && !sKeyopName.equals("") && sKeyopName.length() > 0) {
		iKeyopID = Integer.parseInt(sKeyopName);
	}
	sSiteName = request.getParameter("site");
	sBuilding = request.getParameter("building");
	
	String sOrderBy = "KEYOP_REQUESTID DESC";
	String sOrderByStatus = "REQ_STATUS ASC";
	String sOrderByTicketNum = "KEYOP_REQUESTID DESC";
	String sOrderByKOCompany = "KO_COMPANY_NAME ASC, KEYOP_REQUESTID DESC";
	String sOrderByReqName = "REQUESTOR_NAME ASC";
	String sOrderByTimeSubmit = "TIME_SUBMITTED DESC";
	String sOrderByCity = "CITY ASC, BUILDING, ROOM, FLOOR";
	String sOrderByDevice = "DEVICE_NAME ASC";
	String sOrderByDeviceType = "DEVICE_TYPE ASC";
	
	if(request.getParameter("orderby") != null) {
		sOrderBy = request.getParameter("orderby");
	}
	if (sOrderBy.equals("REQ_STATUS ASC")) {
		sOrderByStatus = "REQ_STATUS DESC";
	}
	if (sOrderBy.equals("KEYOP_REQUESTID DESC")) {
		sOrderByTicketNum = "KEYOP_REQUESTID ASC";
	}
	if (sOrderBy.equals("KO_COMPANY_NAME ASC, KEYOP_REQUESTID DESC")) {
		sOrderByKOCompany = "KO_COMPANY DESC, KEYOP_REQUESTID DESC";
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
	
	String sQueryCol = "SELECT DISTINCT KEYOP_REQUEST.KEYOP_REQUESTID, KEYOP_REQUEST.REQUESTOR_EMAIL, KEYOP_REQUEST.REQUESTOR_NAME, KEYOP_REQUEST.REQUESTOR_TIELINE, KEYOP_REQUEST.REQUESTOR_EXT_PHONE, KEYOP_REQUEST.REQ_STATUS, KEYOP_REQUEST.TIME_SUBMITTED, KEYOP_REQUEST.CITY, KEYOP_REQUEST.DEVICE_NAME, KEYOP_REQUEST.DEVICE_TYPE, KEYOP_REQUEST.BUILDING, KEYOP_REQUEST.FLOOR, KEYOP_REQUEST.ROOM, KEYOP_REQUEST.KEYOP_NAME, KEYOP_REQUEST.KO_COMPANYID, KEYOP_REQUEST.KO_COMPANY_NAME ";
	String sQueryFrom = "FROM GPWS.KEYOP_REQUEST_VIEW KEYOP_REQUEST, GPWS.BUILDING BUILDING";
	String sQueryWhere = " WHERE 1=1 ";
	String sQueryOrder = "ORDER BY " + sOrderBy;
	String sQueryFetch = " FETCH FIRST 250 ROWS ONLY";
	
	if (sTicketNum != null && !sTicketNum.equals("")) {
		sQueryWhere += "AND KEYOP_REQUESTID = " + sTicketNum + " ";
	}
	if (sPrinter != null && !sPrinter.equals("")) {
		sQueryWhere += "AND UPPER(DEVICE_NAME) LIKE '%" + sPrinter.toUpperCase() + "%' ";
	}
	if (sReqName != null && !sReqName.equals("")) {
		sQueryWhere += "AND UPPER(KEYOP_REQUEST.REQUESTOR_NAME) LIKE '%" + sReqName.toUpperCase() + "%' ";
	}
	if (sKeyopName != null && !sKeyopName.equals("")) {
		//sQueryFrom += ", GPWS.USER USER";
		//sQueryWhere += "AND KEYOP_REQUEST.KEYOP_USERID = USER.USERID AND UPPER(USER.LAST_NAME) LIKE '%" + sKeyopName.toUpperCase() + "%' ";
		sQueryWhere += "AND KEYOP_REQUEST.KEYOP_USERID = " + sKeyopName + " ";
	}
	if (sSiteName != null && !sSiteName.equals("")) {
		sQueryWhere += "AND UPPER(KEYOP_REQUEST.CITY) LIKE '%" + sSiteName.toUpperCase() + "%' ";
	}
	if (sBuilding != null && !sBuilding.equals("")) {
		sQueryWhere += "AND UPPER(KEYOP_REQUEST.BUILDING) like '%" + sBuilding.toUpperCase() + "%' ";
	}
	if (isKOSU == false) {
		sQueryWhere += "AND KEYOP_REQUEST.KO_COMPANYID = " + iVendorID + " ";
	}

	try {
		con = appTool.getConnection();
		stmtTicket = con.createStatement();
		//System.out.println(sQueryCol + sQueryFrom + sQueryWhere + sQueryOrder + sQueryFetch);
		rsTicket = stmtTicket.executeQuery(sQueryCol + sQueryFrom + sQueryWhere + sQueryOrder + sQueryFetch);
		
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
				<li><a href="<%= keyops %>?next_page_id=2016"> <%= messages.getString("admin_ticket_search_title") %></a></li>
			</ul>
			<h1><%= messages.getString("admin_ticket_search_list_title") %></h1>
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


<p><%= messages.getString("sorted_by") %>:&nbsp;<strong>
<% if(sOrderBy.equals("KEYOP_REQUESTID DESC")) { %>
		<%= messages.getString("ticket_number") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("KEYOP_REQUESTID ASC")) { %>
		<%= messages.getString("ticket_number") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("REQ_STATUS ASC")) { %>
		<%= messages.getString("status") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("REQ_STATUS DESC")) { %>
		<%= messages.getString("status") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("KO_COMPANY_NAME ASC, KEYOP_REQUESTID DESC")) { %>
		<%= messages.getString("vendor_name") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("KO_COMPANY_NAME DESC, KEYOP_REQUESTID DESC")) { %>
		<%= messages.getString("vendor_name") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("TIME_SUBMITTED DESC")) { %>
		<%= messages.getString("time_opened") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("TIME_SUBMITTED ASC")) { %>
		<%= messages.getString("time_opened") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("CITY ASC, BUILDING, ROOM, FLOOR")) { %>
		<%= messages.getString("site") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("CITY DESC, BUILDING, ROOM, FLOOR")) { %>
		<%= messages.getString("site") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("DEVICE_NAME ASC")) { %>
		<%= messages.getString("device") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("DEVICE_NAME DESC")) { %>
		<%= messages.getString("device") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("DEVICE_TYPE ASC")) { %>
		<%= messages.getString("type") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("DEVICE_TYPE DESC")) { %>
		<%= messages.getString("type") %> (<%= messages.getString("descending") %>)
<% } else if(sOrderBy.equals("REQUESTOR_NAME ASC")) { %>
		<%= messages.getString("opened_by") %> (<%= messages.getString("ascending") %>)
<% } else if(sOrderBy.equals("REQUESTOR_NAME DESC")) { %>
		<%= messages.getString("opened_by") %> (<%= messages.getString("descending") %>)
<% } else { %>
		<%= messages.getString("unsorted") %>
<% } %> 
</strong>
<p><strong><%= messages.getString("admin_ticket_search_list_criteria") %>:</strong></p>
<p>
<%
 	if (sTicketNum != null && !sTicketNum.equals("")) { %> 
		<%= messages.getString("ticket_number") %>: <strong><%= sTicketNum %></strong><br />
<%	}
 	if (sPrinter != null && !sPrinter.equals("")) { %> 
		<%= messages.getString("device_name") %>: <strong><%= sPrinter %></strong><br />
<%	}
 	if (sReqName != null && !sReqName.equals("")) { %> 
		<%= messages.getString("admin_ticket_search_req_name") %>: <strong><%= sReqName %></strong><br />
<%	}
 	if (sKeyopName != null && !sKeyopName.equals("")) { %> 
		<%= messages.getString("admin_ticket_search_keyop_name") %>: <strong><%= tool.returnKeyopInfo(iKeyopID, "name") %></strong><br />
<%	}
 	if (sSiteName != null && !sSiteName.equals("")) { %> 
		<%= messages.getString("site") %>: <strong><%= sSiteName %></strong><br />
<%	}
 	if (sBuilding != null && !sBuilding.equals("")) { %> 
		<%= messages.getString("building") %>: <strong><%= sBuilding %></strong><br />
<%	}
%> 
<br /></p>
			<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="A list of keyop requests based on submitted search criteria.">
				<caption><em><%= messages.getString("search_results") %> - <%= messages.getString("only_first_250_rows") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByTicketNum %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("ticket") %></a></th>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByStatus %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("status") %></a></th>
							<% if (isKOSU == true) { %>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByKOCompany %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("vendor_name") %></a></th>
							<% } %>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByReqName %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("opened_by") %></a></th>
<%-- 							<th scope="col"><%= messages.getString("tieline") %></th> --%>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByTimeSubmit %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("time_opened") %></a></th>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByDevice %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("device") %></a></th>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByDeviceType %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("type") %></a></th>
							<th scope="col"><a href="<%= keyops%>?next_page_id=2016a&orderby=<%= sOrderByCity %>&ticketstart=<%= sTicketNum%>&printer=<%= sPrinter %>&reqname=<%= sReqName %>&keyopuserid=<%= sKeyopName %>&site=<%= sSiteName %>&building=<%= sBuilding %>"><%= messages.getString("site") %></a></th>						
							<th scope="col"><%= messages.getString("building") %></th>
							<th scope="col"><%= messages.getString("floor") %></th>
							<th scope="col"><%= messages.getString("room") %></th>
							
						</tr>
					</thead>
					<tbody>
<%
	DateTime dateTime = new DateTime();
	int numRequests = 0;
	int shading = 0;
	while (rsTicket.next()) { %>
			<tr>
				<td><a href='<%= keyops %>?next_page_id=3095&ticketno=<%= rsTicket.getInt("KEYOP_REQUESTID") %>'><%= rsTicket.getInt("KEYOP_REQUESTID") %></a></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("REQ_STATUS")) %></td>
				<% if (isKOSU == true) { %>
				<td><%= appTool.nullStringConverter(rsTicket.getString("KO_COMPANY_NAME")) %></td>
				<% } %>
				<td><%= appTool.nullStringConverter(rsTicket.getString("REQUESTOR_NAME")) %></td>
<%-- 				<td><%= appTool.nullStringConverter(rsTicket.getString("REQUESTOR_TIELINE")) %></td> --%>
				<td><%= dateTime.convertUTCtoTimeZone(rsTicket.getTimestamp("TIME_SUBMITTED")) %></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("DEVICE_NAME")) %></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("DEVICE_TYPE")) %></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("CITY")) %></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("BUILDING")) %></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("FLOOR")) %></td>
				<td><%= appTool.nullStringConverter(rsTicket.getString("ROOM")) %></td>
				
			</tr>
<%		numRequests++; %>
					
<%	} %>
 	</tbody>
	</table>
<% 	if (numRequests == 0) { %>
		<p><%= messages.getString("no_requests_found") %></p>
<%	} 

	} catch (Exception e) {
		System.out.println("Keyop error in AdminTicketSearchList.jsp ERROR1: " + e); %>
		<p><%= messages.getString("unknown_system_error_text") %>
<% 	
	  	try {
	   		appTool.logError("AdminTicketSearchList.jsp","Keyop", e);
	   	} catch (Exception ex) {
	   		System.out.println("Keyop Error in AdminTicketSearchList.jsp.1 ERROR: " + ex);
	   	}
	} finally {
		try {
			if (rsTicket != null)
				rsTicket.close();
			if (stmtTicket != null)
				stmtTicket.close();
			if (con != null)
				con.close();
		} catch (Exception e){
			System.out.println("Keyop Error in AdminTicketSearchList.jsp.2 ERROR: " + e);
		}
  	}
%>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>