<%
	com.ibm.aurora.bhvr.TableQueryBhvr CompletedSitesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CompletedSitesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet CompletedSitesView_RS = CompletedSitesView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr MinDateView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("ComDatesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet MinDateView_RS = MinDateView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr CompletedCountries  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CompletedCountriesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet CompletedCountries_RS = CompletedCountries.getResults();

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
	
	String sTimeZone = "America/New York";
	String sMinDate = "";
	int iMinDateYear = 0;
	int iMinDateMonth = 0;
	int iMinDateDay = 0;
	String sMinDateYear = "";
	String sMinDateMonth = "";
	String sMinDateDay = "";
	String sMinDateSQL = "";
	   
	String sMinRangeDate = appTool.nullStringConverter(request.getParameter("minDate"));
	int iMinRangeDateYear = 0;
	int iMinRangeDateMonth = 0;
	int iMinRangeDateDay = 0;
	String sMinRangeDateYear = "";
	String sMinRangeDateMonth = "";
	String sMinRangeDateDay = "";
	String sMinRangeDateSQL = "";
	   
	String sMaxRangeDate = appTool.nullStringConverter(request.getParameter("maxDate"));
	int iMaxRangeDateYear = 0;
	int iMaxRangeDateMonth = 0;
	int iMaxRangeDateDay = 0;
	String sMaxRangeDateYear = "";
	String sMaxRangeDateMonth = "";
	String sMaxRangeDateDay = "";
	String sMaxRangeDateSQL = "";
	   
	if (MinDateView != null) {
		MinDateView_RS.next();
		sMinDate = dateTime.timeStampToString(MinDateView_RS.getTimeStamp("TIME_SUBMITTED"));
	}
	   
	if (sMinDate != null && !sMinDate.equals("null") && !sMinDate.equals("")) {
		sMinDate = dateTime.convertTimeZoneFromUTC(sMinDate, sTimeZone);
		iMinDateYear = dateTime.getStringTimeStampValues(sMinDate, "year");
		iMinDateMonth = dateTime.getStringTimeStampValues(sMinDate, "month");
		iMinDateDay = dateTime.getStringTimeStampValues(sMinDate, "day");
			
		sMinDateYear = iMinDateYear + "";
		sMinDateMonth = dateTime.addLeadingZero(iMinDateMonth + "");
		sMinDateDay = dateTime.addLeadingZero(iMinDateDay + "");
					
		sMinDate = dateTime.formatTime(sMinDate);
		sMinDateSQL = sMinDateYear + "-" + sMinDateMonth + "-" + sMinDateDay + "-00.00.00.00";
	}
  
	if (sMinRangeDate != null && !sMinRangeDate.equals("null") && !sMinRangeDate.equals("")) {
		sMinRangeDate += ".00.00.00.00";
		sMinRangeDate = dateTime.convertTimeZoneFromUTC(sMinRangeDate, sTimeZone);
		iMinRangeDateYear = dateTime.getStringTimeStampValues(sMinRangeDate, "year");
		iMinRangeDateMonth = dateTime.getStringTimeStampValues(sMinRangeDate, "month");
		iMinRangeDateDay = dateTime.getStringTimeStampValues(sMinRangeDate, "day");
		
		sMinRangeDateYear = iMinRangeDateYear + "";
		sMinRangeDateMonth = dateTime.addLeadingZero(iMinRangeDateMonth + "");
		sMinRangeDateDay = dateTime.addLeadingZero(iMinRangeDateDay + "");
				
		sMinRangeDate = dateTime.formatTime(sMinRangeDate);
		sMinRangeDateSQL = sMinRangeDateYear + "-" + sMinRangeDateMonth + "-" + sMinRangeDateDay + "-00.00.00.00";
	}
 
	if (sMaxRangeDate != null && !sMaxRangeDate.equals("null") && !sMaxRangeDate.equals("")) {
		sMaxRangeDate += ".00.00.00.00";
		sMaxRangeDate = dateTime.convertTimeZoneFromUTC(sMaxRangeDate, sTimeZone);
		iMaxRangeDateYear = dateTime.getStringTimeStampValues(sMaxRangeDate, "year");
		iMaxRangeDateMonth = dateTime.getStringTimeStampValues(sMaxRangeDate, "month");
		iMaxRangeDateDay = dateTime.getStringTimeStampValues(sMaxRangeDate, "day");
		
		sMaxRangeDateYear = iMaxRangeDateYear + "";
		sMaxRangeDateMonth = dateTime.addLeadingZero(iMaxRangeDateMonth + "");
		sMaxRangeDateDay = dateTime.addLeadingZero(iMaxRangeDateDay + "");
				
		sMaxRangeDate = dateTime.formatTime(sMaxRangeDate);
		sMaxRangeDateSQL = sMaxRangeDateYear + "-" + sMaxRangeDateMonth + "-" + sMaxRangeDateDay + "-23.59.59.99";
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
<meta name="keywords" content="Global Print, keyop, admin view closed requests"/>
<meta name="Description" content="This page allows system administrators to view all closed keyop requests." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("completed_requests") %></title>	
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/keyopLocationUpdate.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createXHR.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/verifyReadyState.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");

	var info = new Array();
	var onMO = false;
	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','3098');
 		createpTag();
		createSelect('countryid', 'countryid', '<%= messages.getString("please_select_country") %>', 'None', 'countryidloc');
		createSelect('cityid', 'cityid', '<%= messages.getString("please_select_site") %>', 'None', 'cityidloc');
 		createPostForm('RefreshF','RefreshForm','RefreshForm','ibm-column-form','<%= keyops %>');
		createInputButton('submit_refresh_button','ibm-submit','<%= messages.getString("refresh") %>','ibm-btn-arrow-pri','next()','refreshView()');
 		addCountries();
 		addSites();
<%--  		autoSelectValue('countryid','<%= sCountry %>'); --%>
 		changeSelectStyle('225px');
 		
		document.RefreshForm.cityid.focus();
	});
		
	dojo.addOnLoad(function() {
		// Set constraints on date fields
		dojo.connect("onmouseover", function() {
			try {
				if (onMO == false) {
					dijit.byId('minDate').constraints.min = new Date('<%= sMinDateYear %>-<%= sMinDateMonth %>-<%= sMinDateDay %>');
		         	dijit.byId('minDate').constraints.max = new Date();
		         	
		         	dijit.byId('maxDate').constraints.min = new Date('<%= sMinDateYear %>-<%= sMinDateMonth %>-<%= sMinDateDay %>');
		         	dijit.byId('maxDate').constraints.max = new Date();
		         			         	
		         	onMO = true;
				}
			} catch (e) {
				console.log("Error setting date range constraints: " + e.message);
			}
		});
	});
	
	function onChangeCall(wName) {
		if (wName == 'countryid') {
			updateSite(info,'countryid','cityid','<%= messages.getString("loading_site_info") %>','<%= messages.getString("please_select_site") %>');
		} else {
			return false;
		}
	}  //onChangeCall
	
	function compareTime(date1, date2) {
		numDaysDiff = "";
		var url = "<%= keyops %>?next_page_id=10000&date1=" + date1 + "&date2=" + date2 + "&" + Math.random();
		callXMLCheckDate(url);
		return true;
	}
	
	function callXMLCheckDate(baseUrl) {
	 	dojo.xhrGet({
		   	url :baseUrl,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		try {
		 			numDaysDiff = response.getElementsByTagName("NumDaysDifference")[0].firstChild.data;
			   	} catch (e) {
					console.log("Exception in callXMLCheckDate: " + e);
			   	} //try and catch
		   	}, //load function
		   	preventCache: true,
		   	sync: true,
		   	error : function(response, args) {
		   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
		   	} //error function
		});
	} //rcallXMLCheckDate
	
	function validateFields() {		
		if (dijit.byId("countryid").get("value") == "None") {
			alert('<%= messages.getString("please_enter_all_required_fields") %>');
			dijit.byId("countryid").focus();
			return false
		} else if (dijit.byId("cityid").get("value") == "None" || dijit.byId("cityid").get("value") == "0") {
			alert('<%= messages.getString("please_enter_all_required_fields") %>');
			dijit.byId("cityid").focus();
			return false;
		} else if (dojo.byId("minDate").value == "") {
			alert('<%= messages.getString("please_enter_all_required_fields") %>');
			dojo.byId("minDate").focus();
			return false;
		} else if (dojo.byId("maxDate").value == "") {
			alert('<%= messages.getString("please_enter_all_required_fields") %>');
			dojo.byId("maxDate").focus();
			return false;
		} 
		compareTime(dojo.byId("minDate").value + "-00.00", dojo.byId("maxDate").value + "-00.00");
		if (numDaysDiff > 31 || numDaysDiff < -31) {
			alert("<%= messages.getString("please_select_valid_date_range") %>");
			return false;
		} else {
			return true;
		}
	}

	function refreshView() {
		if (validateFields() == false) {
			return false;
		}
		document.RefreshForm.submit();
	}
	function changeView(first) {
		self.location.href='<%= keyops %>?next_page_id=3098&date=<%= request.getParameter("date") %>&cityid=<%= request.getParameter("cityid") %>&ft=0&mpp=' + document.getElementById("view").value;
	}
	
	function addSites() {
	<%	int count1 = 0;
		while(CompletedSitesView_RS.next()) { %>
			info[<%= count1 %>] = "<%= CompletedSitesView_RS.getInt("COUNTRYID") %>" + "=" + "<%= CompletedSitesView_RS.getString("CITY") %>" + "=" + "<%= CompletedSitesView_RS.getInt("CITYID") %>";
	<%		count1++;
		}	%>
	}
	
	function addCountries() {
		<%	
		int c = 0;
		int cid = 0;
		while(CompletedCountries_RS.next()) {
			cid = CompletedCountries_RS.getInt("COUNTRYID"); %>
			addOption('countryid','<%= CompletedCountries_RS.getString("COUNTRY") %>','<%= cid %>');
<%			c++;
		} 
		if (c == 1) { %>
			autoSelectValue('countryid','<%= cid %>');
<%		} %>
	}
	
	function exportCSV() {
		if (<%= iCityID %> < 1 || <%= iCountryID %> < 1 || <%= request.getParameter("minDate") %> == null || <%= request.getParameter("maxDate") %> == null) {
			if (validateFields() == true) {
				self.location.href='<%= keyops %>?next_page_id=3098_CSV&orderby=<%= sOrderBy %>&cityid=' + dijit.byId("cityid").get("value") + '&minDate=' + dojo.byId("minDate").value + '&maxDate=' + dojo.byId("maxDate").value;
			}
		} else {
			self.location.href="<%= keyops %>?next_page_id=3098_CSV&orderby=<%= sOrderBy %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>";
		}
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
			<h1><%= messages.getString("completed_requests") %></h1>
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
		con = appTool.getConnection();
		stmtNewReq = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		stmtReqCount = con.createStatement();
		if (isKOSU == true) {
			rsReqCount = stmtReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST WHERE REQ_STATUS = 'completed' AND CITYID = " + iCityID + " AND TIME_FINISHED >= '" + sMinRangeDateSQL + "' AND TIME_FINISHED <= '" + sMaxRangeDateSQL + "'");
		} else {
			rsReqCount = stmtReqCount.executeQuery("SELECT COUNT(*) AS COUNT FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'completed' AND CITYID = " + iCityID + " AND TIME_FINISHED >= '" + sMinRangeDateSQL + "' AND TIME_FINISHED <= '" + sMaxRangeDateSQL + "' AND KO_COMPANYID = " + iVendorID);
		}
		rsReqCount.next();
		int count = rsReqCount.getInt("COUNT");
		if(iCityID != 0 && iCountryID !=0) {
			if (isKOSU == true) {
				rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM, KEYOP_NAME, KEYOP_USERID, KO_COMPANYID, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'completed' AND CITYID = " + iCityID + " AND TIME_FINISHED >= '" + sMinRangeDateSQL + "' AND TIME_FINISHED <= '" + sMaxRangeDateSQL + "' ORDER BY " + sOrderBy + " FETCH FIRST " + (iNumPerPage * iPage) + " ROWS ONLY");
			} else {
				rsNewReq = stmtNewReq.executeQuery("SELECT DISTINCT KEYOP_REQUESTID, REQUESTOR_EMAIL, REQUESTOR_NAME, REQUESTOR_TIELINE, REQUESTOR_EXT_PHONE, TIME_SUBMITTED, CITY, DEVICE_NAME, DEVICE_TYPE, BUILDING, FLOOR, ROOM, KEYOP_NAME, KEYOP_USERID, KO_COMPANYID, KO_COMPANY_NAME FROM GPWS.KEYOP_REQUEST_VIEW WHERE REQ_STATUS = 'completed' AND CITYID = " + iCityID + " AND TIME_FINISHED >= '" + sMinRangeDateSQL + "' AND TIME_FINISHED <= '" + sMaxRangeDateSQL + "' AND KO_COMPANYID = " + iVendorID + " ORDER BY " + sOrderBy + " FETCH FIRST " + (iNumPerPage * iPage) + " ROWS ONLY");
			}
		}
%>
		<p><%= messages.getString("select_location_date_range") %>&nbsp;<%= messages.getString("required_info") %></p>
		<p><a href='javascript:exportCSV()'><%= messages.getString("export_comma_delimited") %></a></p>
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
		<% if(iCityID > 0){ out.print(tool.getSiteName(iCityID)); }%></b>
		<br />
		<%= messages.getString("date_range") %>: <b><%= appTool.nullStringConverter(request.getParameter("minDate")) %> - <%= appTool.nullStringConverter(request.getParameter("maxDate")) %></b>
		</p>
		<div id="RefreshF">
			<div id="nextpageid"></div>
			<div class="pClass">
				<label id="countrylabel" for="countryid">
					<%= messages.getString("country") %>:<span class='ibm-required'>*</span>
				</label>
				<span>
					<div id='countryidloc'></div>
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
			<p>
				<label for="minDate"><%= messages.getString("date_range_start") %>:<span class='ibm-required'>*</span><span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
				<span><input type="text" class="ibm-date-picker" name="minDate" id="minDate" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
			</p>
			<p>
				<label for="maxDate"><%= messages.getString("date_range_end") %>:<span class='ibm-required'>*</span><span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
				<span><input type="text" class="ibm-date-picker" name="maxDate" id="maxDate" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
			</p>
			<div class="pClass">
					<span><div id="submit_refresh_button"></div></span>
			</div>
		</div><!--  END Refresh Form -->

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
			
			<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=3098&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage - 1 %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=3098&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage + 1 %>"><%= messages.getString("next") %></a><% } %></span>
			</p>
			<div class="ibm-rule"><hr /></div>
			<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_closed_keyop_requests") %>">
				<caption><em><%= messages.getString("keyop_requests_at_site") %>:&nbsp;&nbsp;<%= tool.getSiteName(iCityID) %></em></caption>
					<thead>
						<tr>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByTicketNum %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("ticket") %></a></th>
							<% if (isKOSU == true) { %>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByKOCompany %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("vendor_name") %></a></th>
							<% } %>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByReqName %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("opened_by") %></th>
							<th scope="col"><%= messages.getString("tieline") %></th>
							<th scope="col"><%= messages.getString("ext_phone_2") %></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByTimeSubmit %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("time_opened") %></a></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByCity %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("site") %></a></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByDevice %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("device") %></a></th>
							<th scope="col"><a href="<%= keyops %>?next_page_id=3098&page=<%= iPage %>&orderby=<%= sOrderByDeviceType %>&countryid=<%= iCountryID %>&cityid=<%= iCityID %>&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>"><%= messages.getString("type") %></a></th>
							<th scope="col"><%= messages.getString("keyop_2") %></th>
						</tr>
					</thead>
					<tbody>
<%		while (rsNewReq.next() && iReqCounter < iReqMax) {%>
				<tr>
					<td><a href="<%= keyops %>?next_page_id=3095&ticketno=<%= rsNewReq.getInt("KEYOP_REQUESTID") %>"><%= rsNewReq.getInt("KEYOP_REQUESTID") %></a></td>
					<% if (isKOSU == true) { %>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("KO_COMPANY_NAME")) %></td>
					<% } %>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_NAME")) %></td>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_TIELINE")) %></td>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("REQUESTOR_EXT_PHONE")) %></td>
					<td><%= dateTime.convertUTCtoTimeZone(rsNewReq.getTimestamp("TIME_SUBMITTED")) %></td>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("CITY")) %></td>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("DEVICE_NAME")) %></td>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("DEVICE_TYPE")) %></td>
					<td><%= appTool.nullStringConverter(rsNewReq.getString("KEYOP_NAME")) %></td>
				</tr>
<%			iReqCounter++;
 		} %>
					</tbody>
				</table>
				<div class="ibm-rule"><hr /></div>
				<p class="ibm-table-navigation"><span class="ibm-primary-navigation">
			<% if (iNumReq == 0) { %>
				<strong><%= iFirst %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
			<% } else if (iReqMax > iNumReq) { %>
				<strong><%= iFirst + 1 %>-<%= iNumReq %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
			<% } else { %>
				<strong><%= iFirst + 1 %>-<%= iFirst + iNumPerPage %></strong>&nbsp;<%= messages.getString("of") %>&nbsp;<strong><%= iNumReq %></strong>&nbsp;<%= messages.getString("requests") %>
			<% } %>
			<span class="ibm-table-navigation-links"> <% if (iFirst > 0) { %>| <a class="ibm-back-em-link" href="<%= keyops %>?next_page_id=3098&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage - 1 %>"><%= messages.getString("previous") %></a> <% } if (iReqMax < iNumReq) { %>| <a class="ibm-forward-em-link" href="<%= keyops %>?next_page_id=3098&minDate=<%= request.getParameter("minDate") %>&maxDate=<%= request.getParameter("maxDate") %>&cityid=<%= request.getParameter("cityid") %>&countryid=<%= request.getParameter("countryid") %>&page=<%= iPage + 1 %>"><%= messages.getString("next") %></a><% } %></span></p>

<%		if (iReqCounter == 0) { %>
			<p><%= messages.getString("no_requests_found") %></p>
<%		}
	}
	} catch (Exception e) {
		System.out.println("Keyop error in AdminViewClosedReq.jsp ERROR: " + e); %>
		<p><%= messages.getString("unknown_system_error_text") %>
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