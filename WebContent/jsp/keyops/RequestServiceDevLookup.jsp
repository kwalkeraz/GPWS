<%
   String sGeoCookie = "";
   String sCountryCookie = "";
   String sSiteCookie = "";
   String sBuildingCookie = "";
   String sFloorCookie = "";
   String geo = "";
   String country = "";
   String city = "";
   String building = "";
   String floor = "";
   
   Cookie[] cookies = request.getCookies();
   for (int x = 0; x < cookies.length; x++) {
		if(cookies[x].getName().equals("globalPrintGeo")) {
			sGeoCookie = cookies[x].getValue();
		} else if(cookies[x].getName().equals("globalPrintCountry")) {
			sCountryCookie = cookies[x].getValue();
		} else if(cookies[x].getName().equals("globalPrintSite")) {
			sSiteCookie = cookies[x].getValue();
		} else if(cookies[x].getName().equals("globalPrintBuilding")) {
			sBuildingCookie = cookies[x].getValue();
		} else if(cookies[x].getName().equals("globalPrintFloor")) {
			sFloorCookie = cookies[x].getValue();
		}
	}
	geo = sGeoCookie;
	country = sCountryCookie;
	city = sSiteCookie;
	building = sBuildingCookie;
	floor = sFloorCookie;
%>
<%@ include file="metainfo.jsp" %>
<% boolean windowOnLoad = true; %>
<meta name="keywords" content="Global Print, keyop, request service device lookup"/>
<meta name="Description" content="Global print website printer search for keyop request" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("device_search") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/createXHR.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/verifyReadyState.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/displayMsg.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/hide-unhide_fields.js"></script>

	<script type="text/javascript" src="/tools/print/js/resetMenu.js"></script>
	<script type="text/javascript" src="/tools/print/js/getXMLData.js"></script>
	<script type="text/javascript" src="/tools/print/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="/tools/print/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="/tools/print/js/updateGeographyInfo.js"></script>
	<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
	<script type="text/javascript" src="/tools/print/js/createSelect.js"></script>
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>

	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");

dojo.ready(function() {
 	createHiddenInput('nextpageid','next_page_id', '2009','nextpageid');
 	createHiddenInput('nextpageid2','next_page_id', '2009','nextpageid2');
 	createpTag();
 	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
 	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
  	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
  	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
	createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');   
	createTextInput('inputloc','devicename','devicename','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("search_invalid") %>','^[A-Za-z0-9%]{3,32}$'); 
	createInputButton('search_button_geo','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','','callSearch()');
    createInputButton('search_button_name','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','next()','callSearch2()');
	createGetForm('locform','geographicInfo','geographicInfo','ibm-column-form ibm-styled-form','<%= prtgateway %>');
	createGetForm('byname','searchbyName','searchbyName','ibm-column-form ibm-styled-form','<%= keyops %>');
	updateGeo("<%= geo %>");
	changeSelectStyle('250px');
	changeInputTagStyle("250px");
	dojo.byId('geo').focus();
 });
  
function onChangeCall(wName){
 	switch (wName) {
		case 'geo': updateCountry('<%= country %>'); break;
		case 'country': (dojo.byId('state')) ? updateState() : updateCity('<%= city %>'); break;
		case 'city': updateBuilding('<%= building %>'); break;
		case 'building': updateFloor('<%= floor %>'); break;
	} //switch
	return this;
 } //onChangeCall

function callSearch() {
	var params = "";
	var varGeo = dijit.byId("geo").get("value");
	var varCountry = dijit.byId("country").get("value");
	var varSite = dijit.byId("city").get("value");
	var varBuilding = dijit.byId("building").get("value");
	var varFloor = dijit.byId("floor").get("value");
	var href= "";
	if (varGeo != "None" && varCountry != "None" && varSite != "None" && varBuilding != "None" && varFloor != "None") {
		params = "&geo=" + varGeo + "&country=" + varCountry + "&site=" + varSite +  "&building=" + varBuilding + "&floor=" + varFloor;
		
		var uRL = "<%= keyops %>?next_page_id=2008"+params;
		document.location.href = uRL;
		return true;
	} else if (varGeo != "None" && varCountry != "None" && varSite != "None" && varBuilding != "None") {
		params = "&geo=" + varGeo + "&country=" + varCountry + "&site=" + varSite + "&building=" + varBuilding;
		var uRL = "<%= keyops %>?next_page_id=2008a"+params;
		document.location.href = uRL;
		return true;
	} else if (varGeo == "None") {
		alert ('<%= messages.getString("required_info") %>');
		dojo.byId("geo").focus();
		return false;
	} else if (varCountry == "None") {
		alert ('<%= messages.getString("required_info") %>');
		dojo.byId("country").focus();
		return false;
	} else if (varSite == "None") {
		alert ('<%= messages.getString("required_info") %>');
		dojo.byId("city").focus();
		return false;
	} else if (varBuilding == "None") {
		alert ('<%= messages.getString("required_info") %>');
		dojo.byId("building").focus();
		return false;
	} else {
		return true;
	}
}

function callSearch2() {
	var searchName = dojo.byId("devicename").value;
	if (searchName == "" || searchName == null || searchName == "null") {	
		alert ('<%= messages.getString("required_info") %>');
		dojo.byId("devicename").focus();
		return false;
	} else {
		searchName = "%" + dojo.byId("devicename").value + "%";
		dojo.byId("devicename").value = searchName;
		dojo.byId("searchbyName").submit();
		return true;
	}
}
</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-popup">
	<%@ include file="mastheadPopup.jsp" %>
	<!-- All the main body stuff goes here -->
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("device_search") %></h1>
		</div>  <!-- Leadspace-body -->
	</div>  <!-- Leadspace-head -->
	<!-- LEADSPACE_END -->
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<p class="ibm-intro ibm-alternate-three"><em><%= messages.getString("device_search") %></em></p><br />

					<p><%= messages.getString("searchall_message_loc") %></p>
					<br />
					<div id='locform'>
						<div id='nextpageid'></div>
						<h2><span><%= messages.getString("by_location") %></span>:</h2>
						<p><%= messages.getString("device_search_info") %></p>
						<div class="pClass">
							<label id="geolabel" for="geo">
								<%= messages.getString("geography") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='geoloc'></div>
								<div id='geoID' connectId="geo" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="countrylabel" for="country">
								<%= messages.getString("country") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='countryloc'></div>
								<div id='countryID' connectId="country" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="citylabel" for="city">
								<%= messages.getString("city") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
								<div id='cityloc'></div>
								<div id='cityID' connectId="city" align="right"></div>
							</span>
						</div>
						<div class="pClass">	
							<label id="buildinglabel" for="building">
								<%= messages.getString("building") %>:<span class='ibm-required'>*</span>
							</label>
							<span>
							<div id='buildingloc'></div>
								<div id='buildingID' connectId="building" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<label id="floorlabel" for="floor">
								<%= messages.getString("floor") %>:
							</label>
							<span>
								<div id='floorloc'></div>
								<div id='floorID' connectId="floor" align="right"></div>
							</span>
						</div>
						<div class="pClass">
							<span>
								<div id="search_button_geo"></div>
							</span>
						</div>
					</div> <!-- End div locForm -->
					<br />
					<div class="ibm-alternate-rule"><hr /></div>
			
					<div id="byname">
						<div id='nametopageid'></div>
						<div id='nextpageid2'></div>
						<div class="pClass">
							<h2><%= messages.getString("device_search_name") %>:</h2>
							<p><%= messages.getString("device_search_name_info") %></p>
						</div>
						<div class="pClass">
							<label for="text" id="text"><%= messages.getString("search_for") %>:<span class="ibm-required">*</span></label>
							<span>
								<div id="inputloc"></div>
							</span>
						</div>	
						<div class='ibm-buttons-row'>
							<div class="pClass">
							<span>
							<div id='search_button_name'></div>
							</span>
							</div>
						</div>			
					</div> <!-- End div byname -->

					<div class="hrule-dots">&nbsp;</div>
					<p align="right"><a href="javascript:window.close()"><%= messages.getString("close_window") %></a></p>
					</form>
				</div><!-- CONTENT_MAIN END -->
			</div><!-- CONTENT_BODY END -->
		</div><!-- END ibm-content -->
	</div>
	</div>
</body>
</html>