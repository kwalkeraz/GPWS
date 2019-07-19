<%
    TableQueryBhvr SDCView  = (TableQueryBhvr) request.getAttribute("SDC");
    TableQueryBhvrResultSet SDCView_RS = SDCView.getResults();
    String geo = "";
    String country = "";
    String state = "";
    String city = "";
    String building = "";
    String floor = "";
    boolean isExternal = PrinterConstants.isExternal;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print search server"/>
	<meta name="Description" content="Global print website select server" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("server_select_location") %></title>
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
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.ProgressBar");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function bySDC(event) {
	 	var formName = getWidgetID('sdcForm');
	 	var sdc = getSelectValue('sdc');
	 	dojo.stopEvent(event);
	 	if (sdc == "None") {
			showReqMsg('<%= messages.getString("please_select_sdc") %>','sdc');
			return false;
		} else {
			dojo.create('input', {type: 'hidden',value: '5021',name: '<%= BehaviorConstants.TOPAGE %>'},formName.domNode,'first');
			formName.submit();
		}
	 } //bySDC
	 
	 function byGeo(event){
	 	var formName = getWidgetID('geographicInfo');
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	//var state = getSelectValue('state');
	 	var city = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	var geoArray = new Array(geo, country, city);
	 	var idArray = new Array("geo","country", "city");
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
	 	for (var i=0; i < geoArray.length; i++) {
	 		if (getID(idArray[i])) {
		 		if (geoArray[i] == 'None') {
		 			var labeltag = idArray[i]+'label';
		 			var labeltext = getID(labeltag).innerHTML;
		 			var textsize = labeltext.indexOf(":");
		 			labeltext = labeltext.substring(0,textsize).replace(/\s+/g, ' ').trim();
		 			idArray[i] = idArray[i]+'ID';
		 			var tooltip = getID(idArray[i]);
		    		//showReqMsg(labeltext + ' <%= messages.getString("required_selected_info") %>', tooltip);
		    		alert(labeltext + ' <%= messages.getString("required_selected_info") %>');
		    		getID(tooltip).focus;
		 			return false;
		 		} //if equal to None
	 		} //if field exists
	 	} //for loop
	 	(building == 'None') ? changeOptionValue('building') : '';
	 	(floor == 'None') ? changeOptionValue('floor') : '';
	 	//console.log('building value is now ', dijit.byId('building').get('value'));
	 	dojo.create('input', {type: 'hidden',value: '5020',name: '<%= BehaviorConstants.TOPAGE %>'},formName.domNode,'first');
		formName.submit();
	 } //byGeo
	 
	 function changeOptionValue(dID){
		var selectMenu = getWidgetID(dID);
	 	var optionValue = '%';
	 	var optionName = selectMenu.options[0].label;
	 	selectMenu.removeOption(getWidgetID(dID).getOptions());
	 	addOption(dID, optionName, optionValue);
	 	selectMenu.set(optionValue,optionName);
	 } //resetMenu
	 
	 function byName(event) {
	 	var formName = getWidgetID('searchbyName');
	 	var formValid = formName.validate();
	 	var SearchName = getWidgetID('servername');
	 	var SearchValue = getWidgetIDValue('servername');
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			SearchName.set("uppercase", true);
	 			SearchName.set("value", SearchValue + "%");
	 			dojo.create('input', {type: 'hidden',value: '5022',name: '<%= BehaviorConstants.TOPAGE %>'},formName.domNode,'first');
				formName.submit();
			} //if
			else {
				return false;
			}
	 } //byName
	 
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry("<%= country %>"); break;
			case 'country': (dojo.byId('state')) ? updateState("<%= state %>") : updateCity("<%= city %>"); break;
			case 'state': updateCity("<%= city %>"); break;
			case 'city': updateBuilding("<%= building %>"); break;
			case 'building': updateFloor("<%= floor %>"); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function addSDC(dID){
	 	<%
   		while(SDCView_RS.next()) {
			String sdc = SDCView_RS.getString("CATEGORY_VALUE1"); %>
   			var optionName = "<%= sdc %>";
   			var optionValue = "<%= sdc %>";
   			addOption(dID, optionName, optionValue);
   		<% } %>
	 } //addSDC
	 
	 dojo.ready(function() {
	 	createpTag();
	 	createSelect('sdc', 'sdc', '<%= messages.getString("please_select_sdc") %> ...', 'None', 'sdcloc');
	 	addSDC('sdc');
     	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	//createSelect('state', 'state', '<%= messages.getString("select_state") %>...', 'None', 'stateloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');   
 		updateGeo("<%= geo %>");
 		createTextInput('inputloc','servername','servername','128',true,'<%= messages.getString("search_server_name") %>','required','<%= messages.getString("search_server_invalid") %>','^[A-Za-z0-9%.-_]{3,32}$'); 
 		createSubmitButton('inputButton1','go1','<%= messages.getString("search") %>','ibm-btn-view-pri','go1');
 		createSubmitButton('inputButton2','go2','<%= messages.getString("search") %>','ibm-btn-view-pri','go2');
 		createSubmitButton('inputButton3','go3','<%= messages.getString("search") %>','ibm-btn-view-pri','go3');
 		createGetForm('sdcform','sdcForm','sdcForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		createGetForm('locform','geographicInfo','geographicInfo','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		createGetForm('byname','searchbyName','searchbyName','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		changeSelectStyle('250px');
 		changeInputTagStyle('250px');
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('go1'), 'onclick', function(event) {
		 	 bySDC(event);
		 });
		 dojo.connect(getID('geographicInfo'), 'onsubmit', function(event) {
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
				<%= messages.getString("server_select_location") %>
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
				<%= messages.getString("required_info") %>.
			</p>
			<!-- LEADSPACE_END -->
			<div id='topageid'></div>
			<div id='sdcform'>
				<h2><span><%= messages.getString("by_sdc") %></span>:</h2>
					<p><%= messages.getString("server_select_sdc_info") %></p>
				<div class="pClass">
					<label id="sdclabel" for="sdc">
						<%= messages.getString("sdc") %>:<span class="ibm-required">*</span>
					</label>
					<span>
						<div id='sdcloc'></div>
						<div id='sdcID' connectId="sdc"></div>
					</span>
				</div>
				<div class="pClass">
					<span>
						<div id="inputButton1"></div>
					</span>
				</div>
			</div>
			<br />
			<div class="ibm-alternate-rule"><hr /></div>
			
			<div id='locform'>
				<h2><span><%= messages.getString("by_location") %></span>:</h2>
				<p><%= messages.getString("server_select_name_info") %></p>
				<div class="pClass">
					<label id="geolabel" for="geo">
						<%= messages.getString("geography") %>:<span class="ibm-required">*</span>
					</label>
					<span>
					<div id='geoloc'></div>
					<div id='geoID' connectId="geo" align="right"></div>
					</span>
				</div>
				<div class="pClass">
					<label id="countrylabel" for="country">
						<%= messages.getString("country") %>:<span class="ibm-required">*</span>
					</label>
					<span>
					<div id='countryloc'></div>
					<div id='countryID' connectId="country" align="right"></div>
					</span>
				</div>
				<div class="pClass">
					<label id="citylabel" for="city">
						<%= messages.getString("site") %>:<span class="ibm-required">*</span>
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
					<div id="inputButton2"></div>
					</span>
				</div>
			</div>
			<br />
			<div class="ibm-alternate-rule"><hr /></div>
	
			<div id="byname">
				<h2><span><%= messages.getString("by_name") %>:</span></h2>
				<p><%= messages.getString("search_server_name") %></p>
				<div class="pClass">
					<label for="text" id="text"><%= messages.getString("search_for") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="inputloc"></div>
					</span>
				</div>
				<div class="pClass">
					<span>
						<div id="inputButton3"></div>
					</span>
				</div>	
			</div>
		</div>		
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>