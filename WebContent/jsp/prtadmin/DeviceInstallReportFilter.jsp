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
   //end of cookies 
	boolean isExternal = PrinterConstants.isExternal;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print search device information"/>
	<meta name="Description" content="Global print website search for a device information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_install_report") %></title>
	<%@ include file="metainfo2.jsp" %>
	
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
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = dojo.byId(tooltipID);
    	dijit.showTooltip(reqMsg, tooltip);
	 } //editLoc
	 
	 function byGeo(event){
	 	var formName = dijit.byId('geographicInfo');
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	var city = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	var name = dijit.byId("name").get("value");
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
	 	var uRL = "";
	 	var params = "&geo=" + geo + "&country=" + country +  "&city=" + city + "&building=" + building + "&floor=" + floor + "&name=" + name + "&referer=2802";
		uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=2800"+params;

		document.location.href=uRL;
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
	 	createHiddenInput('loctopageid','<%= BehaviorConstants.TOPAGE %>', '','<%= BehaviorConstants.TOPAGE %>');
	 	createpTag();
	 	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', '', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', '', 'countryloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', '', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', '', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', '', 'floorloc');   
 		createTextInput('inputloc','name','name','32',false,'','required','<%= messages.getString("device_search_invalid") %>','^[A-Za-z0-9%]{3,32}$'); 
 		createInputButton('search_button_geo','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','submit_search_geo','');
		createGetForm('locform','geographicInfo','geographicInfo','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		updateGeo("<%= geo %>");
 		changeSelectStyle('250px');
 		changeInputTagStyle("250px");
		dojo.byId('geo').focus();
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
	<%@ include file="mastheadSecure.jsp"%>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
			</ul>
			<h1>
				<%= messages.getString("device_install_report") %>
			</h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<!-- LEADSPACE_BEGIN -->
			<p><%= messages.getString("device_install_report_desc") %><br /></p>
			<div id='topageid'></div>
			<div id='locform'>
				<div id='loctopageid'></div>
				<br />
				<h3><span><%= messages.getString("by_location") %></span>:</h3>
				<div class="pClass">
					<label id="geolabel" for="geo">
						<%= messages.getString("geography") %>:
					</label>
					<span>
						<div id='geoloc'></div>
						<div id='geoID' connectId="geo" align="right"></div>
					</span>
				</div>
				<div class="pClass">
					<label id="countrylabel" for="country">
						<%= messages.getString("country") %>:
					</label>
					<span>
						<div id='countryloc'></div>
						<div id='countryID' connectId="country" align="right"></div>
					</span>
				</div>
				<div class="pClass">
					<label id="citylabel" for="city">
						<%= messages.getString("city") %>:
					</label>
					<span>
						<div id='cityloc'></div>
						<div id='cityID' connectId="city" align="right"></div>
					</span>
				</div>
				<div class="pClass">	
					<label id="buildinglabel" for="building">
						<%= messages.getString("building") %>:
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
				<br />
				<h3><%= messages.getString("by_name") %>:</h3>
				<div class="pClass">
					<label for="text" id="text"><%= messages.getString("search_for") %>:</label>
					<span>
						<div id="inputloc"></div>
					</span>
				</div>	
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
						<div id="search_button_geo"></div>
					</span>
					</div>
				</div>			
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>