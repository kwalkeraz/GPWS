<%
   TableQueryBhvr CPAnalyst  = (TableQueryBhvr) request.getAttribute("CPAnalyst");
   TableQueryBhvrResultSet CPAnalyst_RS = CPAnalyst.getResults();
   TableQueryBhvr CPAnalystView  = (TableQueryBhvr) request.getAttribute("CPAssignee");
   TableQueryBhvrResultSet CPAnalystView_RS = CPAnalystView.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   
   String referer = tool.nullStringConverter(request.getParameter("referer"));
   String geo = "";
   String country = "";
   String state = "";
   String city = "";
   String building = "";
   String floor = "";
   String analyst = "";
   int cpanalystid = 0;
   int priority = 0;
   
	while(CPAnalystView_RS.next()) {
		geo = CPAnalystView_RS.getString("GEO");
		country = CPAnalystView_RS.getString("COUNTRY");
		state = CPAnalystView_RS.getString("STATE");
		city = CPAnalystView_RS.getString("CITY");
		building = CPAnalystView_RS.getString("BUILDING");
		floor = CPAnalystView_RS.getString("FLOOR");
		analyst = CPAnalystView_RS.getString("CP_ANALYST");
		cpanalystid = CPAnalystView_RS.getInt("CPANALYSTID");
		priority = CPAnalystView_RS.getInt("CP_ANALYST_PRIORITY");
	}
	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit analyst"/>
	<meta name="Description" content="Global print website edit an analyst page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_analyst_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/resetMenu.js"></script>
	<script type="text/javascript" src="/tools/print/js/getXMLData.js"></script>
	<script type="text/javascript" src="/tools/print/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="/tools/print/js/updateGeographyInfo.js"></script>
	<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
	<script type="text/javascript" src="/tools/print/js/createSelect.js"></script>
	<script type="text/javascript" src="/tools/print/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/addOption.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	var url = "";
	 	<% if (referer.equals("1025")) { %>
		url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1025&analyst=<%= analyst %>";
		<% } else { %>
		url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1030&geo=<%= geo %>&country=<%= country %>&state=<%= state %>";
		<% } %>
	 	document.location.href=url;
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addAnalyst(){
	 	var selectMenu = dijit.byId('analyst');
	 	<%
   		while(CPAnalyst_RS.next()) { %>
			var optionName = "<%= CPAnalyst_RS.getString("CATEGORY_CODE") %>";
   			var optionValue = "<%= CPAnalyst_RS.getString("CATEGORY_CODE") %>";
   			addOption(selectMenu,optionName,optionValue);
   		<% } %>
	 } //addAnalyst
	 
	 function addNewValue(dID){
	 	var selectMenu = dijit.byId(dID);
	 	addOption(selectMenu,'*','*');
	 } //addNewValue
	 
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry("<%= country %>"); addNewValue('country'); if (getSelectValue('geo') == '*') autoSelectValue('country','*'); break;
			case 'country': updateState("<%= state %>"); addNewValue('state'); if (getSelectValue('country') == '*') autoSelectValue('state','*'); break;
			case 'state': updateCity("<%= city %>"); addNewValue('city'); if (getSelectValue('state') == '*') autoSelectValue('city','*'); break;
			case 'city': updateBuilding("<%= building %>"); addNewValue('building'); if (getSelectValue('city') == '*') autoSelectValue('building','*'); break;
			case 'building': updateFloor("<%= floor %>"); addNewValue('floor'); if (getSelectValue('building') == '*') autoSelectValue('floor','*'); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function callSubmit(event){
	 	var formName = getWidgetID('ListAddForm');
	 	var formValid = formName.validate();
	 	var logaction = getID('logaction');
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	var state = getSelectValue('state');
	 	var city = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	var analyst = getSelectValue('analyst');
	 	if (geo == "None") {
			showReqMsg('<%= messages.getString("please_select_geo") %>','geo');
			return false;
		}
		if (country == "None") {
			showReqMsg('<%= messages.getString("please_select_country") %>','country');
			return false;
		}
		if (state == "None") {
			showReqMsg('<%= messages.getString("please_select_state") %>','state');
			return false;
		}
		if (city == "None") {
			showReqMsg('<%= messages.getString("please_select_city") %>','city');
			return false;
		}
		if (building == "None") {
			showReqMsg('<%= messages.getString("please_select_building") %>','building');
			return false;
		}
		if (floor == "None") {
			showReqMsg('<%= messages.getString("please_select_floor") %>','floor');
			return false;
		}
		if (analyst == "None") {
			showReqMsg('<%= messages.getString("please_select_analyst") %>','analyst');
			return false;
		}
		var priority = 0;
		if (geo != "*") {
			priority = parseInt(priority) + 1;
		}
		if (country != "*") {
			priority = parseInt(priority) + 2;
		}
		if (state != "*") {
			priority = parseInt(priority) + 4;
		}
		if (city != "*") {
			priority = parseInt(priority) + 8;
		}
		if (building != "*") {
			priority = parseInt(priority) + 16;
		}
		if (floor != "*") {
			priority = parseInt(priority) + 32;
		}
		if (formValid) {
			<% if (referer.equals("1025")) {%>
			getID('<%= BehaviorConstants.TOPAGE %>').value = "1065";
			<% } else { %>
			getID('<%= BehaviorConstants.TOPAGE %>').value = "1060";
			<% } %>
			getID('priority').value = priority;
 			logaction.value = "CP Analyst " + analyst + " for " + geo + "," + country + "," + state + "," + city + "," + building + "," + floor + " has been updated";
			formName.submit();
		} else {
			return false;
		}
	 } //callSubmit	 
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '');
     	createHiddenInput('logactionid','cpanalystid','<%= cpanalystid %>');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','priority','');
        createpTag();
        createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	createSelect('state', 'state', '<%= messages.getString("select_state") %>...', 'None', 'stateloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');
        createSelect('analyst', 'analyst', '<%= messages.getString("please_select_analyst") %>', 'None', 'analyst');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_analyst');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_analyst','cancelForm()');
     	createPostForm('ListAdd','ListAddForm','ListAddForm','ibm-column-form','<%= prtgateway %>');
     	changeSelectStyle('250px');
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('geo').focus();
     });
     
     dojo.addOnLoad(function() {
     	updateGeo("<%= geo %>");
     	addNewValue('geo');
     	addAnalyst('analyst');
     	autoSelectValue('analyst','<%= analyst %>');
		 dojo.connect(dojo.byId('ListAddForm'), 'onsubmit', function(event) {
		 	callSubmit(event);
		 });
	 });
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1020"><%= messages.getString("cp_analyst_search") %></a></li>
				<% if (referer.equals("1025")) { %>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1025&analyst=<%= analyst %>"><%= messages.getString("cp_analyst_admin") %></a></li>
				<% } else { %>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1030&geo=<%= geo %>&country=<%= country %>&state=<%= state %>"><%= messages.getString("cp_analyst_admin") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("cp_analyst_edit") %></h1>
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
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='ListAdd'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
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
					<label id="statelabel" for="state">
						<%= messages.getString("state") %>:<span class='ibm-required'>*</span>
					</label>
					<span>
						<div id='stateloc'></div>
						<div id='stateID' connectId="state" align="right"></div>
					</span>
				</div>
				<div class="pClass">
					<label id="sitelabel" for="site">
						<%= messages.getString("city") %>:<span class='ibm-required'>*</span>
					</label>
					<span>
						<div id='cityloc'></div>
						<div id='siteID' connectId="site" align="right"></div>
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
					<label for='analyst'><%= messages.getString("analyst") %>:<span class='ibm-required'>*</span></label>
					<span><div id='analyst'></div></span>
				</div>
				<div class='ibm-overlay-rule'><hr /></div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='submit_add_button'></div>
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