<%
	com.ibm.aurora.bhvr.TableQueryBhvr InProgressSitesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("InProgressSitesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet InProgressSitesView_RS = InProgressSitesView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr InProgressCountriesAdmin  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("InProgressCountriesAdmin");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet InProgressCountriesAdmin_RS = InProgressCountriesAdmin.getResults();
   
	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	
	Connection con = null;
	Statement stmtNewReq = null;
	Statement stmtNewReqCount = null;
	ResultSet rsNewReq = null;
	ResultSet rsNewReqCount = null;
	
	String sOrderBy = "keyop_requestid";
	int iCityID = Integer.parseInt(request.getParameter("cityid"));
	String sCountry = request.getParameter("countryid");
	int iCountryID = 0;
	
	if (sCountry != null && !sCountry.equals("")) {
		iCountryID = Integer.parseInt(sCountry);
	}
	if(request.getParameter("orderby") != null) {
		sOrderBy = request.getParameter("orderby");
	}
	
	if(sOrderBy.equals("city")) {
		sOrderBy = "city, building, room, floor";
	}
	
	int iNumPerPage = 50;
	int iPage = 1;
	if (request.getParameter("page") != null) {
		iPage = Integer.parseInt(request.getParameter("page"));
	}
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, in progress tickets"/>
<meta name="Description" content="This page allows system administrators to view the in progress keyop requests." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("in_progress_requests") %></title>
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
		createHiddenInput('nextpageid','next_page_id','2036');
 		createpTag();
		createSelect('countryid', 'countryid', '<%= messages.getString("please_select_country") %>', 'None', 'countryidloc');
		createSelect('cityid', 'cityid', '<%= messages.getString("please_select_site") %>', 'None', 'cityidloc');
 		createPostForm('RefreshF','RefreshForm','RefreshForm','ibm-column-form','<%= keyops %>');
		createInputButton('submit_refresh_button','ibm-submit','<%= messages.getString("refresh") %>','ibm-btn-arrow-pri','next()','refreshView()');
 		addCountries();
 		addSites();
 		changeSelectStyle('225px');
		document.RefreshForm.cityid.focus();
	});
	
	function onChangeCall(wName) {
		if (wName == 'countryid') {
			updateSite(info,'countryid','cityid','None','<%= messages.getString("please_select_site") %>');
			dojo.byId("countryReq").style.display = "none";
			dojo.removeClass("countrylabel","ibm-error");
		} else if (wName == 'cityid') {
			dojo.byId("cityReq").style.display = "none";
			dojo.removeClass("citylabel","ibm-error");
		} else {
			return false;
		}
	}  //onChangeCall

	function refreshView() {
		if (!showSelectMsg("None", dijit.byId('countryid').attr("value"), '<%= messages.getString("please_select_country") %>', 'countryid')) {
			dojo.byId("countryReq").style.display = "";
			dojo.addClass("countrylabel","ibm-error");
			return false;
		} else if (!showSelectMsg("0", dijit.byId('cityid').attr("value"), '<%= messages.getString("please_select_site") %>', 'cityid')) {
			dojo.byId("cityReq").style.display = "";
			//dojo.byId("citylabel") class="ibm-error";
			dojo.addClass("citylabel","ibm-error");
			return false;
		} else {
			document.RefreshForm.submit();
		}
	}
	
	function changeView(first) {
		self.location.href='<%= keyops %>?next_page_id=2036&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&ft=0&mpp=' + document.getElementById("view").value;
	}
	function addSites() {
	<%	int count1 = 0;
		while(InProgressSitesView_RS.next()) { %>
			info[<%= count1 %>] = "<%= InProgressSitesView_RS.getInt("COUNTRYID") %>" + "=" + "<%= InProgressSitesView_RS.getString("CITY") %>" + "=" + "<%= InProgressSitesView_RS.getInt("CITYID") %>";
	<%		count1++;
		} %>
	}
	
	function addCountries() {
		<% while (InProgressCountriesAdmin_RS.next()) { %>
			addOption('countryid','<%= InProgressCountriesAdmin_RS.getString("COUNTRY") %>','<%= InProgressCountriesAdmin_RS.getInt("COUNTRYID") %>');
		<% } %>
	}
	
	function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
		showTTip(reqMsg, tooltip);
	 } //showReqMsg
	
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
			</ul>
			<h1><%= messages.getString("in_progress_requests") %></h1>
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
<%	try {
		con = tool.getConnection();
		stmtNewReq = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		stmtNewReqCount = con.createStatement();
		rsNewReqCount = stmtNewReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST WHERE (UPPER(REQ_STATUS) = 'NEW' OR UPPER(REQ_STATUS) = 'IN PROGRESS' OR UPPER(REQ_STATUS) = 'HOLD') AND CITYID = " + iCityID);
		rsNewReqCount.next();
		int count = rsNewReqCount.getInt("COUNT");
		
		if(iCityID != 0) {
			rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM FROM GPWS.KEYOP_REQUEST WHERE (UPPER(REQ_STATUS) = 'NEW' OR UPPER(REQ_STATUS) = 'IN PROGRESS' OR UPPER(REQ_STATUS) = 'HOLD') AND CITYID = " + iCityID + " ORDER BY " + sOrderBy + "  FETCH FIRST " + (iNumPerPage * iPage) + " ROWS ONLY");
		}
%>
<p><%= messages.getString("select_location_from_list") %>&nbsp;<%= messages.getString("required_info") %></p>
<p><%= messages.getString("sorted_by") %>:&nbsp;<b>
<% if(sOrderBy.equals("keyop_requestid")) { %>
		<%= messages.getString("ticket_number") %>
<% } else if(sOrderBy.equals("time_submitted")) { %>
		<%= messages.getString("time_opened") %>
<% } else if(sOrderBy.equals("city, building, room, floor")) { %>
		<%= messages.getString("site") %>
<% } else if(sOrderBy.equals("device_name")) { %>
		<%= messages.getString("device") %>
<% } else if(sOrderBy.equals("device_type")) { %>
		<%= messages.getString("type") %>
<% } else if(sOrderBy.equals("requestor_name")) { %>
		<%= messages.getString("opened_by") %>
<% } else { %>
		<%= messages.getString("unsorted") %>
<% } %>
</b>
<br />
		<%= messages.getString("selected_location") %>: <b><% if(iCountryID > 0 ) { out.print(tool.getCountryName(iCountryID)); } %>,&nbsp; 
		<% if(iCityID > 0){ out.print(tool.getSiteName(iCityID)); }%></b>
<br />
</p>
		<div id="RefreshF">
			<div id="nextpageid"></div>
			<div class="pClass">
				<label id="countrylabel" for="countryid">
					<%= messages.getString("country") %>:<span class='ibm-required'>*</span>
				</label>
				<span>
					<div id='countryidloc'></div>
					<div id='countryid' connectId="country" align="right"></div><a title="Error link" href="#" id="countryReq" class="ibm-error-link" style="display: none;"></a>
				</span>
			</div>
			<div class="pClass">
				<label id="citylabel" for="cityid">
					<%= messages.getString("site") %>:<span class='ibm-required'>*</span>
				</label>
				<span>
					<div id='cityidloc'></div>
					<div id='cityid' connectId="city" align="right"></div><a title="Error link" href="#" id="cityReq" class="ibm-error-link" style="display: none;"></a>
				</span>
			</div>
			<div class="pClass">
					<span><div id="submit_refresh_button"></div></span>
			</div>
		</div><!--  END Refresh Form -->
	
<% 
	if(iCityID > 0) { 
		int iNumReq = count;
		int iFirst = (iNumPerPage * iPage - iNumPerPage);
		int iReqCounter = iFirst;
		int iReqMax = iFirst + iNumPerPage;
%>
				<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
					<% if (iNumReq == 0) { %>
						<strong><%= iFirst %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else if (iReqMax > iNumReq) { %>
						<strong><%= iFirst + 1 %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else { %>
						<strong><%= iFirst + 1 %>-<%= iReqCounter + iNumPerPage %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } %>
					<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=2036&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=2036&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>"><%= messages.getString("next") %></a><% } %></span></p>
				<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_inprog_keyop_requests") %>">
					<caption><em><%= messages.getString("keyop_requests_at_site") %>:&nbsp;&nbsp;<%= tool.getSiteName(iCityID) %></em></caption>
						<thead>
							<tr>
								<th scope="col"><a href="<%= keyops %>?next_page_id=2036&orderby=keyop_requestid&cityid=<%= iCityID %>&countryid=<%= iCountryID %>&page=<%= iPage %>"><%= messages.getString("ticket") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=2036&orderby=requestor_name&cityid=<%= iCityID %>&countryid=<%= iCountryID %>&page=<%= iPage %>"><%= messages.getString("opened_by") %></th>
								<th scope="col"><%= messages.getString("tieline") %></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=2036&orderby=time_submitted&cityid=<%= iCityID %>&countryid=<%= iCountryID %>&page=<%= iPage %>"><%= messages.getString("time_opened") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=2036&orderby=city&cityid=<%= iCityID %>&countryid=<%= iCountryID %>&page=<%= iPage %>"><%= messages.getString("site") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=2036&orderby=device_name&cityid=<%= iCityID %>&countryid=<%= iCountryID %>&page=<%= iPage %>"><%= messages.getString("device") %></a></th>
								<th scope="col"><a href="<%= keyops %>?next_page_id=2036&orderby=device_type&cityid=<%= iCityID %>&countryid=<%= iCountryID %>&page=<%= iPage %>"><%= messages.getString("type") %></a></th>
								<th scope="col"><%= messages.getString("building") %></th>
								<th scope="col"><%= messages.getString("floor") %></th>
								<th scope="col"><%= messages.getString("room") %></th>
							</tr>
						</thead>
						<tbody>
						<%	rsNewReq.absolute((iNumPerPage * iPage) - iNumPerPage);
							while (rsNewReq.next() && iReqCounter < iReqMax) { %>
									<tr>
										<td><a href='<%= keyops %>?next_page_id=2015&amp;ticketno=<%= rsNewReq.getInt("KEYOP_REQUESTID") %>'><%= rsNewReq.getInt("KEYOP_REQUESTID") %></a></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_NAME")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_TIELINE")) %></td>
										<td><%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("TIME_SUBMITTED")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("CITY")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("DEVICE_NAME")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("DEVICE_TYPE")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("BUILDING")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("FLOOR")) %></td>
										<td><%= appTool.nullStringConverter(rsNewReq.getString("ROOM")) %></td>
									</tr>
						<%		iReqCounter++;
							} %>
						</tbody>
					</table>
					<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
					<% if (iNumReq == 0) { %>
						<strong><%= iFirst %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else if (iReqMax > iNumReq) { %>
						<strong><%= iFirst + 1 %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } else { %>
						<strong><%= iFirst + 1 %>-<%= iFirst + iNumPerPage %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
					<% } %>
					<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=2036&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage - 1 %>&orderby=<%= sOrderBy %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=2036&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage + 1 %>&orderby=<%= sOrderBy %>"><%= messages.getString("next") %></a><% } %></span></p>
					
					<%	if (iReqCounter == 0) {			
					%>
							<p><%= messages.getString("no_requests_found") %></p>
					<%	}
						}
						} catch (Exception e) {
							System.out.println("Keyop error in InProgressTicket.jsp ERROR: " + e);
						} finally {
							if (rsNewReq != null)
								rsNewReq.close();
							if (stmtNewReq != null)
								stmtNewReq.close();
							if (rsNewReqCount != null)
								rsNewReqCount.close();
							if (stmtNewReqCount != null)
								stmtNewReqCount.close();
							if (con != null)
								con.close();
						}
					%>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>