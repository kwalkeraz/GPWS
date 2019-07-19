<% //cookies
   String sGeoCookie = "";
   String sCountryCookie = "";
   String sSiteCookie = "";
   String sBuildingCookie = "";
   String sFloorCookie = "";
   String sSearchNameCookie = "";
   String geo = "";
   String country = "";
   String state = "";
   String city = "";
   String building = "";
   String floor = "";
   String searchName = "";
   
   Cookie[] cookies = request.getCookies();
   if (cookies != null) {
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
			} else if(cookies[x].getName().equals("globalPrintSearchName")) {
				sSearchNameCookie = cookies[x].getValue();
			}
		} //for loop
		geo = sGeoCookie;
		country = sCountryCookie;
		city = sSiteCookie;
		building = sBuildingCookie;
		floor = sFloorCookie;
		searchName = sSearchNameCookie;
	}
%>	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print request device page"/>
	<meta name="Description" content="Request a new device page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_request_connection") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/updateGeographyInfo.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function byGeo(event){
	 	var formName = dijit.byId('geographicInfo');
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	//var state = getSelectValue('state');
	 	var city = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
	 	var geoArray = new Array(geo, country, city, building, floor);
	 	var idArray = new Array("geo","country","city","building","floor");
	 	for (var i=0; i < geoArray.length; i++) {
	 		if (dojo.byId(idArray[i])) {
		 		if (geoArray[i] == 'None') {
		 			var labeltag = idArray[i]+'label';
		 			var labeltext = dojo.byId(labeltag).innerHTML;
		 			var textsize = labeltext.indexOf(":");
		 			labeltext = labeltext.substring(0,textsize);
		 			var tooltip = dojo.byId(idArray[i]);
		    		showReqMsg(labeltext + ' <%= messages.getString("required_selected_info") %>', tooltip);
		 			return false;
		 		} //if equal to None
	 		} //if field exists
	 	} //for loop
	 	var uRL = "";
	 	var params = "";
	 	if (geo != "None" && country != "None"  && city != "None" && building != "None" && floor != "None") {
			//params = "&geo=" + geo + "&country=" + country +  "&city=" + city + "&building=" + building + "&floor=" + floor;
			//uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=430"+params;
			formName.submit();
		}
	 } //byGeo
	 
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry('<%= country %>'); break;
			case 'country': (dojo.byId('state')) ? updateState() : updateCity('<%= city %>'); break;
			case 'city': updateBuilding('<%= building %>'); break;
			case 'building': updateFloor('<%= floor %>'); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 dojo.ready(function() {
	 	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1011');
	 	createpTag();
	 	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	//createSelect('state', 'state', '<%= messages.getString("select_state") %>...', 'None', 'stateloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');   
 		createInputButton('search_button_geo','ibm-submit','<%= messages.getString("go") %>','ibm-btn-arrow-pri','submit_search_geo','');
        createGetForm('locform','geographicInfo','geographicInfo','ibm-column-form ibm-styled-form','<%= commonprocess %>');
 		updateGeo("<%= geo %>");
 		changeSelectStyle('250px');
 		getID('geo').focus();
     });
     
     dojo.addOnLoad(function() {
     	 dojo.connect(dojo.byId('submit_search_geo'), 'onclick', function(event) {
		 	 byGeo(event);
		 });
	 });
	 
	</script>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp"%>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= statichtmldir %>/ServiceRequests.html"><%= messages.getString("service_requests") %></a></li>
				<li><a href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("macdel_requests") %></a></li>
			</ul>
			<h1>
				<%= messages.getString("device_request_connection") %>
			</h1>
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
			<p>
				<%= messages.getString("required_info") %>
			</p>
			<div class="ibm-alternate-rule"><hr /></div>
			<!-- LEADSPACE_END -->
			<div id='locform'>
				<div id='topageid'></div>
				<p>
					<% String sPath = "/tools/print/Feedback.html"; %>
					<%= messages.getStringArgs("listsearchadd_info", new String[] {"", sPath}) %>
				</p>
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
						<%= messages.getString("floor") %>:<span class='ibm-required'>*</span>
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
			</div>
			<br />
			<div class="ibm-alternate-rule"><hr /></div>
	
		</div>
		<!-- ADDITIONAL_INFO_BEGIN -->
		<!-- ADDITIONAL_INFO_END -->
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>