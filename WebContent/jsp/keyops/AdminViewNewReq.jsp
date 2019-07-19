<%
	com.ibm.aurora.bhvr.TableQueryBhvr NewReqSitesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("NewReqSitesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet NewReqSitesView_RS = NewReqSitesView.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr NewReqCountriesAdmin  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("NewReqCountriesAdmin");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet NewReqCountriesAdmin_RS = NewReqCountriesAdmin.getResults();
   
	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	int iVendorID = pupb.getVendorID();
	
	String[] sAuthTypes = pupb.getAuthTypes();
	boolean isKOSU = false;
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("Keyop Superuser")) {
			isKOSU = true;
		}
	}
	
	String sOrderBy = "KEYOP_REQUESTID DESC";
	String sOrderByTicketNum = "KEYOP_REQUESTID DESC";
	String sOrderByKOCompany = "KO_COMPANY_NAME ASC, KEYOP_REQUESTID DESC";
	String sOrderByReqName = "REQUESTOR_NAME ASC";
	String sOrderByTimeSubmit = "TIME_SUBMITTED DESC";
	String sOrderByCity = "CITY ASC, BUILDING, ROOM, FLOOR";
	String sOrderByDevice = "DEVICE_NAME ASC";
	String sOrderByDeviceType = "DEVICE_TYPE ASC";
	Connection con = null;
	Statement stmtNewReq = null;
	Statement stmtReqCount = null;
	ResultSet rsReqCount = null;
	ResultSet rsNewReq = null;
	
	if(request.getParameter("orderby") != null) {
		sOrderBy = request.getParameter("orderby");
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
	String sCity = request.getParameter("cityid");
	int iCityID = 0;
	String sCountry = request.getParameter("countryid");
	int iCountryID = 0;
	
	if (sCity != null && !sCity.equals("")) {
		iCityID = Integer.parseInt(sCity);
	}
	if (sCountry != null && !sCountry.equals("")) {
		iCountryID = Integer.parseInt(sCountry);
	}
   
	int iNumPerPage = 50;
	int iPage = 1;
	if (request.getParameter("page") != null) {
		iPage = Integer.parseInt(request.getParameter("page"));
	}
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin view new requests"/>
<meta name="Description" content="This page allows system administrators to view all new keyop requests." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("new_requests") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/keyopLocationUpdate.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");

	var info = new Array();
	
	dojo.ready(function() {
	     createHiddenInput('nextpageid','next_page_id', '3096');
	     createpTag();
	     createSelect('countryid', 'countryid', '<%= messages.getString("please_select_country") %>', 'None', 'countryloc');
	     createSelect('cityid', 'cityid', '<%= messages.getString("please_select_site") %>', 'None', 'cityidloc');
	     createInputButton('submit_refresh_button','ibm-submit','<%= messages.getString("refresh") %>','ibm-btn-arrow-pri','next()','refreshView()');
	     createPostForm('RefreshF','RefreshForm','RefreshForm','ibm-column-form','<%= keyops %>');
	     	changeInputTagStyle("250px");
	     	changeSelectStyle('225px');
	     addCountries();
	     addSites();
<%-- 	     autoSelectValue('countryid','<%= sCountry %>'); --%>
   });
		
	function onChangeCall(wName) {
		if (wName == 'countryid') {
			updateSite(info,'countryid','cityid','<%= messages.getString("loading_site_info") %>','<%= messages.getString("all_sites_2") %>');
		} else {
			return false;
		}
	}  //onChangeCall
	
	function refreshView() {
		document.RefreshForm.submit();
	}
	
	function changeView(first) {
		self.location.href='<%= keyops %>?next_page_id=3096&cityid=<%= request.getParameter("cityid") %>&ft=0&mpp=' + document.getElementById("view").value;
	}

	function addSites(){
	<%
		int count1 = 0;
		while(NewReqSitesView_RS.next()) {
	%>
			info[<%= count1 %>] = "<%= NewReqSitesView_RS.getInt("COUNTRYID") %>" + "=" + "<%= NewReqSitesView_RS.getString("CITY") %>" + "=" + "<%= NewReqSitesView_RS.getInt("CITYID") %>";
	<%		count1++;
		}	
	%>
		
	} //initialize()	
	
	function addCountries() {
		<%	
		int c = 0;
		int cid = 0;
		while(NewReqCountriesAdmin_RS.next()) {
			cid = NewReqCountriesAdmin_RS.getInt("COUNTRYID"); %>
			addOption('countryid','<%= NewReqCountriesAdmin_RS.getString("COUNTRY") %>','<%= cid %>');
<%			c++;
		} 
		if (c == 1) { %>
			autoSelectValue('countryid','<%= cid %>');
<%		} %>
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
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("admin_home") %></a></li>  
			</ul>
			<h1><%= messages.getString("new_requests") %></h1>
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
					<% 
						try {
							int count = 0;
							if (iCityID >= 0) {
								con = appTool.getConnection();
								stmtNewReq = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
								stmtReqCount = con.createStatement();
								if(iCityID != 0 && iCountryID != 0) {
									if (isKOSU == true) {
										rsReqCount = stmtReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST WHERE REQ_STATUS = 'new' AND CITYID = " + iCityID);
									} else {
										rsReqCount = stmtReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'new' AND CITYID = " + iCityID + " AND KO_COMPANYID = " + iVendorID);	
									}
								} else if (iCityID == 0 && iCountryID != 0) {
									if (isKOSU == true) {
										rsReqCount = stmtReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST WHERE REQ_STATUS = 'new'");
									} else {
										rsReqCount = stmtReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'new' AND KO_COMPANYID = " + iVendorID);	
									}
								}

								if (rsReqCount != null) {
									rsReqCount.next();
									count = rsReqCount.getInt("COUNT");
								}
								if(iCityID != 0 && iCountryID != 0) {
									if (isKOSU == true) {
										rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM, KO_COMPANYID, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'new' AND CITYID = " + iCityID +  " ORDER BY " + sOrderBy);
									} else {
										rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM, KO_COMPANYID, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'new' AND CITYID = " + iCityID +  " AND KO_COMPANYID = " + iVendorID + " ORDER BY " + sOrderBy);
									}
								} else if (iCityID == 0 && iCountryID != 0) {
									if (isKOSU == true) {
										rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM, KO_COMPANYID, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'new' ORDER BY " + sOrderBy);
									} else {
										rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM, KO_COMPANYID, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'new' AND KO_COMPANYID = " + iVendorID + " ORDER BY " + sOrderBy);
									}
								}
							} // end if (iCityID >= 0)
					%>
					<p><%= messages.getString("select_location_from_list") %>&nbsp;<%= messages.getString("required_info") %></p>
					<p><%= messages.getString("sorted_by") %>:&nbsp;<b>
					<% if(sOrderBy.equals("KEYOP_REQUESTID DESC")) { %>
							<%= messages.getString("ticket_number") %> (<%= messages.getString("descending") %>)
					<% } else if(sOrderBy.equals("KEYOP_REQUESTID ASC")) { %>
							<%= messages.getString("ticket_number") %> (<%= messages.getString("ascending") %>)
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
					</b>
					<br />
						<%= messages.getString("selected_location") %>: <b><% if(iCountryID > 0 ) { out.print(tool.getCountryName(iCountryID)); } %>,&nbsp; 
						<% if(iCityID > 0){ out.print(tool.getSiteName(iCityID)); } System.out.println("Next if here");%></b>
					</p>
					<div id='RefreshF'>
						<div id='nextpageid'></div>
						<div class="pClass">
							<label id="countrylabel" for="countryid">
								<%= messages.getString("country") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='countryloc'></div>
								<div id='countryid' connectId="country" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="citylabel" for="cityid">
								<%= messages.getString("site") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='cityidloc'></div>
								<div id='cityid' connectId="city" align="right"></div>
							</span>
						</div>
						<div class="pClass">
								<span><div id="submit_refresh_button"></div></span>
						</div>
					</div><!--  END RefreshF Form -->
					<% if(iCityID >= 0) { 
						int iNumReq = count;
						int iFirst = (iNumPerPage * iPage - iNumPerPage);
						int iReqCounter = iFirst;
						int iReqMax = iFirst + iNumPerPage;
						
						rsNewReq.absolute((iNumPerPage * iPage) - iNumPerPage);
					%>
					<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
					<% if (iNumReq == 0) { %>
						<strong><%= iFirst %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else if (iReqMax > iNumReq) { %>
						<strong><%= iFirst + 1 %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else { %>
						<strong><%= iFirst + 1 %>-<%= iFirst + iNumPerPage %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } %>
					<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=3096&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage - 1%>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=3096&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage + 1%>"><%= messages.getString("next") %></a><% } %></span></p>
					<div class="ibm-rule"><hr /></div>
					
					<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_new_keyop_requests") %>">
					<caption><em><%= messages.getString("keyop_requests_at_site") %>:&nbsp;&nbsp;<%= tool.getSiteName(iCityID) %></em></caption>
						<thead>
							<tr>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByTicketNum %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("ticket") %></a></th>
								<% if (isKOSU == true) { %>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByKOCompany %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("vendor_name") %></a></th>
								<% } %>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByReqName %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("opened_by") %></th>
								<th scope="col"><%= messages.getString("tieline") %></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByTimeSubmit %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("time_opened") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByDevice %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("device") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByDeviceType %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("type") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=3096&orderby=<%= sOrderByCity %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&page=<%= iPage %>"><%= messages.getString("site") %></a></th>
								<th scope="col"><%= messages.getString("building") %></th>
								<th scope="col"><%= messages.getString("floor") %></th>
								<th scope="col"><%= messages.getString("room") %></th>
							</tr>
						</thead>
						<tbody>
					<%
						while (rsNewReq.next() && iReqCounter < iReqMax) {
							if (isKOSU == true || (isKOSU == false && iVendorID == rsNewReq.getInt("KO_COMPANYID")) ) { %>
								<tr>
									<td><a href="<%= keyops %>?next_page_id=3095&ticketno=<%= rsNewReq.getString("KEYOP_REQUESTID") %>"><%= rsNewReq.getString("KEYOP_REQUESTID") %></a></td>
									<% if (isKOSU == true) { %>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("KO_COMPANY_NAME")) %></td>
									<% } %>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_NAME")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_TIELINE")) %></td>
									<td><%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("TIME_SUBMITTED")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("DEVICE_NAME")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("DEVICE_TYPE")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("CITY")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("BUILDING")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("FLOOR")) %></td>
									<td><%= appTool.nullStringConverter(rsNewReq.getString("ROOM")) %></td>
								</tr>
					<%		iReqCounter++;
							}
						}
					%>
						</tbody>
					</table>
					
					<div class="ibm-rule"><hr /></div>
					<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
					<%   if (iNumReq == 0) { %>
						<strong><%= iFirst %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else if (iReqMax > iNumReq) { %>
						<strong><%= iFirst + 1 %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else { %>
						<strong><%= iFirst + 1 %>-<%= iFirst + iNumPerPage %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } %>
					<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=3096&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage - 1 %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=3096&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage + 1 %>"><%= messages.getString("next") %></a><% } %></span></p>
					<%
						if (iReqCounter == 0) {			
					%>
							<p><%= messages.getString("no_requests_found") %></p>
					<%	}
						}
						} catch (Exception e) {
							System.out.println("Keyop error in AdminViewNewReq.jsp ERROR: " + e); %>
							<p><%= messages.getString("unknown_system_error_text") %></p>	
					<%	} finally {
							if (rsNewReq != null)
								rsNewReq.close();
							if (stmtNewReq != null)
								stmtNewReq.close();
							if (rsReqCount != null)
								rsReqCount.close();
							if (stmtReqCount != null)
								stmtReqCount.close();
							if (con != null)
								con.close();
						}
					%>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>