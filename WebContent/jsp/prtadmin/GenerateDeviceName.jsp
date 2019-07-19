<%
	TableQueryBhvr DeviceType = (TableQueryBhvr) request.getAttribute("DeviceType");
	TableQueryBhvrResultSet DeviceType_RS = DeviceType.getResults();
	AppTools tool = new AppTools();
	String geo = tool.nullStringConverter(request.getParameter("geo"));
	String country = tool.nullStringConverter(request.getParameter("country"));
	String city = tool.nullStringConverter(request.getParameter("city"));
	String building = tool.nullStringConverter(request.getParameter("building"));
	String dipp = tool.nullStringConverter(request.getParameter("dipp"));
	String devname = "";
	String devinitial = "";
		if (DeviceType_RS.getResultSetSize() > 0 ) {
			while(DeviceType_RS.next()) {
				if (request.getParameter(DeviceType_RS.getString("CATEGORY_VALUE1") + "type") != null && request.getParameter(DeviceType_RS.getString("CATEGORY_VALUE1").toLowerCase()+"type").equals("Y")) {
					devname = devname + DeviceType_RS.getString("CATEGORY_VALUE1").toLowerCase();
				}
			} //while
		} //if > 0 
		
	if (devname.equals("copy") || devname.equals("copyfax") || devname.equals("copyscan") || devname.equals("copyfaxscan")) {
		devinitial = "c";
	} else if (devname.equals("fax") || devname.equals("faxscan")) {
		devinitial = "f";
	} else if (dipp.equals("Y")) {
		devinitial = "x";
	} else {
		devinitial = "l";
	}
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website generate device name" />
	<meta name="Description" content="Global print website generate a device name" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_generate_name") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
		ibmweb.config.set({
			greeting: { enabled: false }
		});
		dojo.require("dojo.parser");
		dojo.require("dijit.form.Form");
	 	dojo.require("dijit.form.Button");
	
		function callSubmit(){
			var devicename = getID('deviceid').innerHTML;
			parent.opener.setWidgetIDValue('devicename',devicename);
			parent.opener.setWidgetIDValue('lpname',devicename);
			parent.opener.window.focus();
			window.close();
		} //callSubmit
	
		function callCancel() {
			parent.opener.getWidgetID('devicename').focus();
			parent.opener.window.focus();
			window.close();
		} //callCancel
		
		dojo.ready(function() {
	     	createpTag();
	     	createInputButton('submit_add_button','ibm-submit','<%= messages.getString("use_name") %>','ibm-btn-arrow-pri','submit_add_os','callSubmit()');
	 		createSpan('submit_add_button','ibm-sep');
		 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_os','callCancel()');
	     });
	</script>

</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="mastheadPopup.jsp" %>
		<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
					<jsp:useBean id="GetDeviceName" scope="page" class="tools.print.printer.GetDeviceName" />
					<%
						int buildingid = 0;
						String sitecode = "";
						String countryabbr = "";
						String devicename = "";
						Connection con = null;
						PreparedStatement psGetBuildingID = null;
						ResultSet BuildingID_RS = null;
						PreparedStatement psSiteCode = null;
						ResultSet SiteCode_RS = null;
						PreparedStatement psCountryAbbr = null;
						ResultSet CountryAbbr_RS = null;
						try {
							con = tool.getConnection();
							String sqlgetBuildingID = "";
							sqlgetBuildingID = "SELECT BUILDINGID FROM GPWS.LOCATION_VIEW WHERE BUILDING_NAME = ? AND CITY = ? AND COUNTRY = ? AND GEO = ?";
							psGetBuildingID = con.prepareStatement(sqlgetBuildingID,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
						  	psGetBuildingID.setString(1, building);
						  	psGetBuildingID.setString(2, city);
						  	psGetBuildingID.setString(3, country);
						  	psGetBuildingID.setString(4, geo);
						  	BuildingID_RS = psGetBuildingID.executeQuery();
						  	while( BuildingID_RS.next() ) {
								buildingid = BuildingID_RS.getInt("BUILDINGID"); 
							} //while
							
							String sqlgetSiteCode = "";
							sqlgetSiteCode = "SELECT SITE_CODE FROM GPWS.BUILDING WHERE BUILDINGID = ?";
							psSiteCode = con.prepareStatement(sqlgetSiteCode,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
						  	psSiteCode.setInt(1, buildingid);
						  	SiteCode_RS = psSiteCode.executeQuery();
						  	while( SiteCode_RS.next() ) {
								sitecode = SiteCode_RS.getString("SITE_CODE"); 
							} //while
							
							String sqlgetCountryAbbr = "";
							sqlgetCountryAbbr = "SELECT COUNTRY_ABBR FROM GPWS.COUNTRY WHERE COUNTRY = ? AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = ?)";
							psCountryAbbr = con.prepareStatement(sqlgetCountryAbbr,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
						  	psCountryAbbr.setString(1, country);
						  	psCountryAbbr.setString(2, geo);
						  	CountryAbbr_RS = psCountryAbbr.executeQuery();
						  	while( CountryAbbr_RS.next() ) {
								countryabbr = CountryAbbr_RS.getString("COUNTRY_ABBR"); 
							} //while
							
							if (buildingid != 0 && (countryabbr != null && !countryabbr.equals("")) && (sitecode != null && !sitecode.equals(""))) {
								GetDeviceName.setParams(countryabbr.toLowerCase(),sitecode.toLowerCase());				
								devicename = GetDeviceName.getName(countryabbr.toLowerCase(),sitecode.toLowerCase());
								devicename = devicename.substring(0,5) + devinitial + devicename.substring(5+1);
					%>
					<h1><label for="devicename"><%= messages.getString("device_generate_name") %></label></h1>
					<p>
						<%= messages.getString("device_available_name") %>: <strong id="deviceid"><%= devicename %></strong><br />
					</p>
					<div class='ibm-alternate-rule'><hr /></div>
					<div class='ibm-buttons-row'>
					<div id='submit_add_button' align='center'></div>
					</div>
					<%		} else {
					%>
							<p><%= messages.getString("device_error_generate_name") %></p>
							<b><%= messages.getString("error_message") %></b>:<br />
							<% if (buildingid == 0) { %>
								<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("device_building_not_found", new String[] {building}) %></p>
							<% } else if (countryabbr == null || countryabbr.equals("")) { %>
								<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("device_country_no_abbr", new String[] {country}) %></p>
							<% } else if (sitecode == null || sitecode.equals("")) {%>
								<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("device_building_no_sitecode", new String[] {building}) %></p>
							<% } else {%>
								<p><a class='ibm-error-link' href='#'></a><%= messages.getString("error_see_sysadmin") %></p>
							<% } %>
						<br />
						<div class="hrule-dots">&nbsp;</div>
							<p align="right">
								<a class="float-center" href="javascript:callCancel();"><%= messages.getString("close_window") %></a>
							</p>
					<%		} //else
						} catch (Exception e) {
							System.out.println("Error in GenerateDeviceName.jsp ERROR: " + e);
					%>
							<p><%= messages.getString("device_error_generate_name") %></p>
							<b><%= messages.getString("error_message") %></b>:<br />
							<p><a class='ibm-error-link' href='#'></a><%= e %></p>
					<%
						} finally {
							psGetBuildingID.close();
							BuildingID_RS.close();
							psSiteCode.close();
							SiteCode_RS.close();
							psCountryAbbr.close();
							CountryAbbr_RS.close();
							con.close();
						}
					%>
					</div>
				</div>
			</div>
			<!-- CONTENT_END -->
		</div>
	</div>
</body>