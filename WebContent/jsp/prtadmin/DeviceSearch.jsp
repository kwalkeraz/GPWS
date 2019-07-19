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
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_search") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/updateGeographyInfoNoStatus.js"></script>
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
	 } //showReqMsg
	 
	 function byGeo(event){
	 	var formName = getWidgetID('geographicInfo');
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	//var state = getSelectValue('state');
	 	var city = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
	 	var geoArray = new Array(geo, country, city);
	 	var idArray = new Array("geo","country", "city");
	 	for (var i=0; i < geoArray.length; i++) {
	 		if (getID(idArray[i])) {
		 		if (geoArray[i] == 'None') {
		 			var labeltag = idArray[i]+'label';
		 			var labeltext = getID(labeltag).innerHTML;
		 			var textsize = labeltext.indexOf(":");
		 			labeltext = labeltext.substring(0,textsize);
		 			var tooltip = getID(idArray[i]);
		    		showReqMsg(labeltext + ' <%= messages.getString("required_selected_info") %>', tooltip);
		 			return false;
		 		} //if equal to None
	 		} //if field exists
	 	} //for loop
	 	var uRL = "";
	 	var params = "";
	 	if (geo != "None" && country != "None"  && city != "None" && building != "None" && floor != "None") {
			params = "&geo=" + geo + "&country=" + country +  "&city=" + city + "&building=" + building + "&floor=" + floor;
			uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=430"+params;
		}
		else if (geo != "None" && country != "None"  && city != "None" && building != "None") {
			params = "&geo=" + geo + "&country=" + country + "&city=" + city + "&building=" + building;
			uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=431"+params;
		}
		else if (geo != "None" && country != "None"  && city != "None") {
			params = "&geo=" + geo + "&country=" + country +"&city=" + city;
			uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=432"+params;
		}
		document.location.href=uRL;
	 } //byGeo
	 
	 function searchByName(deviceName) {
	 	var params = "&<%= PrinterConstants.SEARCH_NAME %>="+deviceName.toLowerCase();
	 	document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=282" + params;
	 } //searchByName
	 
	 function byName(event) {
	 	var formName = getWidgetID('searchbyName');
	 	var formValid = formName.validate();
	 	var SearchName = getWidgetID('<%= PrinterConstants.SEARCH_NAME %>');
	 	var SearchValue = SearchName.get('value');
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			SearchName.set("lowercase", true);
	 			SearchName.set("value", SearchValue + "%");
	 			formName.submit();
			} //if
			else {
				return false;
			}
	 } //byName
	 
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
	 	createHiddenInput('nametopageid','<%= BehaviorConstants.TOPAGE %>', '282','nametopageid');
	 	createpTag();
	 	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	//createSelect('state', 'state', '<%= messages.getString("select_state") %>...', 'None', 'stateloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');   
 		createTextInput('inputloc','<%= PrinterConstants.SEARCH_NAME %>','<%= PrinterConstants.SEARCH_NAME %>','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("search_invalid") %>','^[A-Za-z0-9%]{3,32}$'); 
 		createInputButton('search_button_geo','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','submit_search_geo','');
        createSubmitButton('search_button_name','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','submit_search_name');
		createGetForm('locform','geographicInfo','geographicInfo','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		createGetForm('byname','searchbyName','searchbyName','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		updateGeo("<%= geo %>");
 		changeSelectStyle('250px');
 		changeInputTagStyle("250px");
		dojo.byId('geo').focus();
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('submit_search_geo'), 'onclick', function(event) {
		 	 byGeo(event);
		 });
		 dojo.connect(getID('searchbyName'), 'onsubmit', function(event) {
		 	byName(event);
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
				<%= messages.getString("device_search") %>
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
			<p>
				<%= messages.getString("required_info") %>
			</p>
			<div class="ibm-alternate-rule"><hr /></div>
			<!-- LEADSPACE_END -->
			<div id='topageid'></div>
			<div id='locform'>
				<div id='loctopageid'></div>
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
				<div class="pClass">
					<span>
						<div id="search_button_geo"></div>
					</span>
				</div>
			</div>
			<br />
			<div class="ibm-alternate-rule"><hr /></div>
	
			<div id="byname">
				<div id='nametopageid'></div>
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
			</div>
		</div>
		<!-- ADDITIONAL_INFO_BEGIN -->
		<div id="ibm-content-sidebar">
			<div id="ibm-contact-module">
			<!--IBM Contact Module-->
				<% if (!searchName.equals("")) { %>
				<ul>
					<li>Last device searched for: </li>
					<li><a href="javascript:searchByName('<%= searchName %>');"><%= searchName %></a></li>
				</ul>
				<% } %>
			</div>
			<div id="ibm-merchandising-module">
			<!--IBM Web Merchandising Module-->
			</div>
		</div>
		<!-- ADDITIONAL_INFO_END -->
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>