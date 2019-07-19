<%
    // THIS IS WHERE WE LOAD ALL THE BEANS
   com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopSiteView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopSiteView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopSiteView_RS = AdminKeyopSiteView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopSiteView2  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopSiteView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopSiteView2_RS = AdminKeyopSiteView2.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr AdminSiteView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminSiteView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminSiteView_RS = AdminSiteView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr CountriesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CountriesView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet CountriesView_RS = CountriesView.getResults();
   
   AppTools appTool = new AppTools();
   keyopTools tool = new keyopTools();
   int iUserID = 0;
   if (request.getParameter("userid") != null) {
	   iUserID = Integer.parseInt(request.getParameter("userid"));
   }
   
   String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
   String sError = appTool.nullStringConverter(request.getParameter("error"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin edit keyop sites"/>
<meta name="Description" content="This page allows and admin to edit a keyop's sites." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_admin_page") %> - <%= messages.getString("edit") %><%= messages.getString("keyop") %><%= messages.getString("sites") %></title>
<%@ include file="metainfo2.jsp" %>

<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/keyopLocationUpdate.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.MultiSelect");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");
	var info = new Array();
	
	dojo.ready(function() {
		createHiddenInput('nextpageidloc','next_page_id','3016');
  		createHiddenInput('nextpageidDelloc','next_page_id','3016');
 		createHiddenInput('submitvalueloc','submitvalue', '');
 		createHiddenInput('submitvalueDelloc','submitvalue', '');
 		createHiddenInput('useridloc','userid', '<%= request.getParameter("userid") %>');
 		createHiddenInput('useridDelloc','userid', '<%= request.getParameter("userid") %>');
 		createHiddenInput('cityidDelloc','cityid', '');
 		createpTag();
		createSelect('countryid', 'countryid', '<%= messages.getString("please_select_country") %>', 'None', 'countryidloc');
		createMultiSelect('availsites','availsitesloc');
		createMultiSelect('sites','sitesloc');
		createCheckBox('entiresite', 'Y', '', false, 'entiresiteloc');
		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','addButtonExec()');
			createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("addSiteOverlay", this);');
		createPostForm('ListSitesForm','ListSites','ListSites','ibm-column-form','<%= keyops %>');
		createPostForm('DelSiteForm','DelSite','DelSite','ibm-column-form','<%= keyops %>');
		addSites();
		changeSelectStyle('175px');
		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } 
		if (!sError.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-error-link'></a><%= sError %><br /></p>";
		<% } %>

		addCountries();
		addAvailSites();
	});
	
	function addAvailSites() { 
	<%	int count1 = 0;
		while(AdminSiteView_RS.next()) { %>
			info[<%= count1 %>] = "<%= AdminSiteView_RS.getInt("COUNTRYID") %>" + "=" + "<%= AdminSiteView_RS.getString("CITY") %>" + "=" + "<%= AdminSiteView_RS.getInt("CITYID") %>";
	<%		count1++;
		} %>
		addMultiOption('availsites','<%= messages.getString("please_select_country") %>','0');
	}

	function addCountries() {
		<% while (CountriesView_RS.next()) { %>
			addOption('countryid','<%= appTool.nullStringConverter(CountriesView_RS.getString("COUNTRY")) %>','<%= CountriesView_RS.getInt("COUNTRYID") %>');
		<% } %>
	}
	
	function addSites() {
		<% while (AdminKeyopSiteView_RS.next()) { %>
				addMultiOption('sites','<%= AdminKeyopSiteView_RS.getString("CITY") %>','<%= AdminKeyopSiteView_RS.getInt("CITYID") %>');
		<%	} %>
	}
	
	function onChangeCall(wName) {
		if (wName == 'countryid') {
			dojo.empty("availsites");
			updateMultiSite(info,'countryid','availsites','','');
		} else {
			return false;
		}
	}  //onChangeCall

	function refreshView() {
		document.RefreshForm.submit();
	}
	
	function addButtonExec() {
		if (dijit.byId("countryid").get("value") == "None") {
			alert('<%= messages.getString("required_info") %>');
			dijit.byId("countryid").focus();
		} else if (dijit.byId("availsites").get("value") == "") {
			alert('<%= messages.getString("required_info") %>');
			dijit.byId("availsites").focus();
		} else {
			document.ListSites.submitvalue.value = "add";
			dojo.byId("ListSites").submit();
		}
	}
		
	function showAddSite() {
		ibmweb.overlay.show('addSiteOverlay', this);
	}
		
	function callDelete(cityid,city) {
		yesno = confirm("<%= messages.getString("confirm_remove_site_from_keyop") %> " + city);
		if (yesno) {
			document.DelSite.submitvalue.value = "remove";
			document.DelSite.cityid.value = cityid;
			dojo.byId("DelSite").submit();
		} 
	}
	
	function onGo(link,h,w) {
		var chasm = screen.availWidth;
		var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + ',scrollbars=yes,resizable=yes';	
		args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		w = window.open(link,'_blank',args);
		return false;
	}
	
	function editSite(userid,cityid,entiresite) {
		if (entiresite != null && entiresite == 'Y') {
			entiresite = true;
		} else {
			entiresite = false;
		}
		var link = '<%= keyops %>?next_page_id=3018&userid=' + userid + '&cityid=' + cityid + '&entiresite=' + entiresite;
		onGo(link,450,450);
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
					<li><a href="<%= keyops %>?next_page_id=3012"> <%= messages.getString("view_keyops") %></a></li>  
					<li><a href="<%= keyops %>?next_page_id=3013&userid=<%= request.getParameter("userid") %>"> <%= messages.getString("edit_keyop") %></a></li>
			</ul>
			<h1><%= messages.getString("edit_keyop_sites") %></h1>
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
					<div id="DelSiteForm">
						<div id="response"></div>
						<div id="nextpageidDelloc"></div>
						<div id="submitvalueDelloc"></div>
						<div id="cityidDelloc"></div>
						<div id="useridDelloc"></div>
						<p><a href="javascript:showAddSite()"><%= messages.getString("add_a_site") %></a></p>
						<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="A list of sites for the keyop">
						<caption><em><%= messages.getString("editing_sites") %>:&nbsp;<%= tool.returnInfo(iUserID,"name") %></em></caption>
						<thead>
							<tr>
								<th scope="col"><span><%= messages.getString("site") %></span><span class="ibm-icon">&nbsp;</span></th>
								<th scope="col"><span><%= messages.getString("entire_site") %></span><span class="ibm-icon">&nbsp;</span></th>
								<th scope="col"><span><%= messages.getString("buildings") %></span><span class="ibm-icon">&nbsp;</span></th>
								<th scope="col"><span><%= messages.getString("delete") %></span><span class="ibm-icon">&nbsp;</span></th>
							</tr>
						</thead>
						<tbody>
						<%	int count = 0;	
							while (AdminKeyopSiteView2_RS.next()) { 
								count++; %>
	 								<tr>
										<td scope="row"><a href="javascript:editSite('<%= request.getParameter("userid") %>','<%= AdminKeyopSiteView2_RS.getInt("CITYID") %>', '<%= appTool.nullStringConverter(AdminKeyopSiteView2_RS.getString("ENTIRE_SITE")) %>')"><%= appTool.nullStringConverter(AdminKeyopSiteView2_RS.getString("CITY")) %></a></td>
										<td><%= appTool.nullStringConverter(AdminKeyopSiteView2_RS.getString("ENTIRE_SITE")) %></td>
										<% if (appTool.nullStringConverter(AdminKeyopSiteView2_RS.getString("ENTIRE_SITE")).equals("Y")) { %>
												<td>All</td>
										<% } else { 
												int iCityID = AdminKeyopSiteView2_RS.getInt("CITYID");
			  									Connection con = null; 
			  									Statement stmtBuilding = null; 
			  									Statement stmtBuilding2 = null; 
			  									ResultSet rsBuilding = null; 
			  									ResultSet rsBuilding2 = null;
												try {  
			  										con = appTool.getConnection();
			  										stmtBuilding2 = con.createStatement(); 
			  										rsBuilding2 = stmtBuilding2.executeQuery("SELECT KEYOP_BUILDING.BUILDINGID, BUILDING_NAME FROM GPWS.KEYOP_BUILDING KEYOP_BUILDING, GPWS.BUILDING BUILDING WHERE KEYOP_BUILDING.BUILDINGID = BUILDING.BUILDINGID AND USERID = " + request.getParameter("userid") + " AND KEYOP_BUILDING.BUILDINGID IN (SELECT BUILDINGID FROM GPWS.BUILDING WHERE CITYID = " + iCityID + ") ORDER BY BUILDING_NAME"); %> 
			  										<td> 
											<%		while (rsBuilding2.next()) { %>
		 											<%= rsBuilding2.getString("BUILDING_NAME") %>,&nbsp;
						 					<%		} %>
						 							</td>
											<%	} catch (Exception e) {  
			   					   		     		System.out.println("AdminEditKeyopSites.jsp ERROR: " + e);  
			   					    	    		try {  
			   						   					appTool.logError("AdminEditKeyopSites.jsp","Keyop", e);  
			   						   				} catch (Exception ex) {  
			   						   					System.out.println("Keyop Error in AdminEditKeyopSites.jsp ERROR: " + ex);  
			   						   				}  
			   					    	   		} finally { 
			   					    	   			if (rsBuilding != null)  
			   					    	   				rsBuilding.close();  
			   					    	   			if (rsBuilding2 != null)  
			   					    	   				rsBuilding2.close();  
			   					    	   			if (stmtBuilding != null)  
			   					    	   				stmtBuilding.close();  
			   					    	   			if (stmtBuilding2 != null)  
			   					    	   				stmtBuilding2.close();  
			   					    	   		 	if (con != null)  
			  					    	   				con.close(); 
			  					    	   		}
						 					} %>
										<td align="center">
											<a class="ibm-cancel-link" href="javascript:callDelete('<%= AdminKeyopSiteView2_RS.getInt("CITYID") %>','<%= appTool.nullStringConverter(AdminKeyopSiteView2_RS.getString("CITY")) %>')" ><%= messages.getString("delete") %></a>
										</td>
									</tr>
	<% 							} // end while %>
								
	 						</tbody>
						</table>
<%						if (count == 0) {  %>
							<p><%= messages.getStringArgs("keyop_not_assigned_to_sites", new String[]{tool.returnInfo(iUserID,"name")}) %></p>
					<% 	} %>
					</div>
						
						<!-- ADD SITE OVERLAY STARTS HERE -->
						<div class="ibm-common-overlay" id="addSiteOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("add_keyop_sites") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("add_keyop_sites_desc") %>&nbsp;<%= messages.getString("required_info") %></p>
											<div id="ListSitesForm">
												<div id='nextpageidloc'></div>
												<div id='submitvalueloc'></div>
												<div id="useridloc"></div>							
												<div class="pClass">
													<label for="countryid"><%= messages.getString("country") %>:<span class="ibm-required">*</span></label>
													<span><div id="countryidloc"></div></span>
												</div>
												<div class="pClass">
													<label for="availsites"><%= messages.getString("available_sites") %>:<span class="ibm-required">*</span></label>
													<span><div id="availsitesloc"></div></span>
												</div>
												<div class="pClass">
<%-- 													<label for="checkbuilding"><%= messages.getString("check_here_all_buildings") %></label> --%>
														<label for="entiresite"><%= messages.getString("all_buildings_?") %></label>
<!-- 														<span><input type="checkbox" name="entiresite" id="checkbuilding" value="yes" checked/></span> -->
														<span><div id="entiresiteloc"></div></span>
												</div>
												<div class="ibm-overlay-rule"><hr /></div>
												<div class="ibm-buttons-row" align="right">
													<div id="submit_add_button"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>						
						</div>
						<!-- ADD SITE OVERLAY ENDS HERE -->						
					</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>