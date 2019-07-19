<%
	com.ibm.aurora.bhvr.TableQueryBhvr KeyopSiteView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("KeyopSiteView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet KeyopSiteView_RS = KeyopSiteView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr SiteView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("SiteView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet SiteView_RS = SiteView.getResults();
	
	com.ibm.aurora.bhvr.TableQueryBhvr CountriesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CountriesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet CountriesView_RS = CountriesView.getResults();
	
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );

	AppTools appTool = new AppTools();
	keyopTools tool = new keyopTools();
	Connection con = null;
	PreparedStatement stmtCity = null;
	ResultSet rsCity = null;

	String sCity = tool.getSiteName(Integer.parseInt(request.getParameter("cityid")));
	String sCountry = request.getParameter("countryid");
	int iCountryID = 0;
	if (sCountry != null && !sCountry.equals("")) {
		iCountryID = Integer.parseInt(sCountry);
	}
	
	int iVendorID = pupb.getVendorID();
	String[] sAuthTypes = pupb.getAuthTypes();
	boolean isKOSU = false;
	for (int i = 0; i < sAuthTypes.length; i++) {
		if (sAuthTypes[i].startsWith("Keyop Superuser")) {
			isKOSU = true;
		}
	}
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));

%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin keyop view by site"/>
<meta name="Description" content="This page allows an admin to view the keyops in the system.  It sorts them based on the site they work at." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_view_by_site") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/keyopLocationUpdate.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.form.Form");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Button");

var info = new Array();

	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','');
		createHiddenInput('nextpageidRF','next_page_id','3017');
		createHiddenInput('submitvalue','submitvalue', '');
		createHiddenInput('userid','userid', '');
		createHiddenInput('username','username', '');
		createpTag();
		createSelect('countryid', 'countryid', '<%= messages.getString("please_select_country") %>', 'None', 'countryidloc');
		createSelect('cityid', 'cityid', '<%= messages.getString("please_select_site") %>', 'None', 'cityidloc');
		createPostForm('RefreshF','RefreshForm','RefreshForm','ibm-column-form','<%= keyops %>');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		createInputButton('submit_refresh_button','ibm-submit','<%= messages.getString("refresh") %>','ibm-btn-arrow-pri','next()','refreshView()');
		//addSites();
		addCountries();
		changeSelectStyle('225px');
		initialize();
		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
		document.RefreshForm.cityid.focus();
	});
	
	function initialize(){
	<%	int count1 = 0;
		while(SiteView_RS.next()) { %>
			info[<%= count1 %>] = "<%= SiteView_RS.getInt("COUNTRYID") %>" + "=" + "<%= SiteView_RS.getString("CITY") %>" + "=" + "<%= SiteView_RS.getInt("CITYID") %>";
	<%		count1++;
		} %>
	
	} //initialize()
		
	function addCountries() {
		<% while (CountriesView_RS.next()) { %>
			addOption('countryid','<%= appTool.nullStringConverter(CountriesView_RS.getString("COUNTRY")) %>','<%= CountriesView_RS.getInt("COUNTRYID") %>');
		<% } %>
	}
	
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
	
	function callDelete(userid,username) {
		var agree = confirm('<%= messages.getString("keyop_remove_check") %> ' + username + '?');
		if (agree) {
			document.theForm.username.value = username;
			document.theForm.userid.value = userid;
			document.theForm.next_page_id.value = "3026";
			document.theForm.submitvalue.value = "RemoveKeyop";
			document.theForm.submit();
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
			<h1><%= messages.getString("keyop_view_by_site") %></h1>
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
					<div id="RefreshF">
						<div id='nextpageidRF'></div>
						<div class="pClass">
							<label for="countryid"><%= messages.getString("country") %>:</label>
							<span><div id="countryidloc"></div></span>
						</div>
						<div class="pClass">
							<label for="cityid"><%= messages.getString("site") %>:</label>
							<span><div id="cityidloc"></div></span>
						</div>
						<div class="pClass">
							<span><div id="submit_refresh_button"></div></span>
						</div>
					</div>
					
					<div id='Keyop'>
						<div id='nextpageid'></div>
						<div id='submitvalue'></div>
						<div id='userid'></div>
						<div id='username'></div>
					<% if (request.getParameter("cityid").equals("0")) { %>
						<p><%= messages.getString("select_site_view_keyops") %></p>
					<% } else { %>
						<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="A list of keyops at site: <%= sCity %>.">
						<caption><em><%= messages.getString("keyops_at_site") %>:&nbsp;&nbsp;<%= sCity %></em></caption>
						<thead>
							<tr>
								<th scope="col" class="ibm-sort"><a href=""><%= messages.getString("name") %><span class="ibm-icon">&nbsp;</span></a></th>
								<% if (isKOSU) { %>
								<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("vendor_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
								<% } %>
								<th scope="col"><a href=""><span><%= messages.getString("pager") %></span><span class="ibm-icon">&nbsp;</span></a></th>
								<th scope="col"><a href=""><span><%= messages.getString("email") %></span><span class="ibm-icon">&nbsp;</span></a></th>
								<th scope="col"><a href=""><span><%= messages.getString("site") %></span><span class="ibm-icon">&nbsp;</span></a></th>
								<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("buildings") %></span><span class="ibm-icon">&nbsp;</span></a></th>
								<th scope="col"><%= messages.getString("delete") %></th>
								
							</tr>
						</thead>
						<tbody>
						<%
							int numKeyops = 0;
							int shading = 0;
							while (KeyopSiteView_RS.next()) { 
								if (isKOSU == true || (isKOSU == false && iVendorID == KeyopSiteView_RS.getInt("VENDORID")) ) { %>
								<tr>
									<td><a href="<%= keyops %>?next_page_id=3013&userid=<%= KeyopSiteView_RS.getInt("USERID") %>"><%= appTool.nullStringConverter(KeyopSiteView_RS.getString("LAST_NAME")) %>, <%= appTool.nullStringConverter(KeyopSiteView_RS.getString("FIRST_NAME")) %></a></td>
									<% if (isKOSU) { %>
									<td><%= appTool.nullStringConverter(KeyopSiteView_RS.getString("VENDOR_NAME")) %></td>
									<% } %>
									<td><%= appTool.nullStringConverter(KeyopSiteView_RS.getString("PAGER")) %></td>
									<td><%= appTool.nullStringConverter(KeyopSiteView_RS.getString("EMAIL")) %></td>
									<td><%= appTool.nullStringConverter(KeyopSiteView_RS.getString("CITY")) %></td>
									<% if (KeyopSiteView_RS.getString("ENTIRE_SITE").equals("N")) {
											try {
						  	
												con = appTool.getConnection();
												stmtCity = con.prepareStatement("SELECT BUILDING_NAME FROM GPWS.BUILDING BUILDING, GPWS.KEYOP_BUILDING KEYOP_BUILDING WHERE KEYOP_BUILDING.BUILDINGID IN (SELECT BUILDINGID FROM GPWS.BUILDING WHERE CITYID = ?) AND USERID = ? AND KEYOP_BUILDING.BUILDINGID = BUILDING.BUILDINGID");
												stmtCity.setInt(1,KeyopSiteView_RS.getInt("CITYID"));
												stmtCity.setInt(2,KeyopSiteView_RS.getInt("USERID"));
												rsCity = stmtCity.executeQuery(); %>
												<td>
											<%	while (rsCity.next()) { %>
													<%= appTool.nullStringConverter(rsCity.getString("BUILDING_NAME")) %>,&nbsp;
											<%	} %>
												</td>
										    <% } catch (Exception e) {
												System.out.println("Keyop error in AdminKeyopViewBySite.3 ERROR: " + e);
						  					} finally {
												try {
													if (rsCity != null)
														rsCity.close();
													if (stmtCity != null)
														stmtCity.close();
													if (con != null)
														con.close();
												} catch (Exception e){
													System.out.println("Keyop Error in AdminKeyopViewBySite.4 ERROR: " + e);
												}
						  					} %>
										
									<% } else { %>
										<td><%= messages.getString("all") %></td>
									<% } %>
									<td align="center">
										<a class="ibm-cancel-link" href="javascript:callDelete('<%= KeyopSiteView_RS.getInt("USERID") %>','<%= appTool.nullStringConverter(KeyopSiteView_RS.getString("FIRST_NAME")) %> <%= appTool.nullStringConverter(KeyopSiteView_RS.getString("LAST_NAME")) %>')" ><%= messages.getString("delete") %></a>
									</td>
								</tr>
						<%		numKeyops++; 
								}
							} %>
						</tbody>	
						</table>
						<%	if (numKeyops == 0) {			
						%>
								<p><%= messages.getString("no_keyops_found_site") %></p>
						<%	} else { %>
								
								<p><%= numKeyops %> <%= messages.getString("keyops_found") %></p>
						<%	}
						%>
						
						<% } %>
					</div> <!-- END KEYOP FORM DIV -->
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>