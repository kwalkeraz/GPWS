<%
   TableQueryBhvr CPAssigneeView  = (TableQueryBhvr) request.getAttribute("CPAssignee");
   TableQueryBhvrResultSet CPAssigneeView_RS = CPAssigneeView.getResults();
   TableQueryBhvr CPAnalyst  = (TableQueryBhvr) request.getAttribute("CPAnalyst");
   TableQueryBhvrResultSet CPAnalyst_RS = CPAnalyst.getResults();
   String geo = "";
   String country = "";
   String state = "";
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print search analyst"/>
	<meta name="Description" content="Global print website select an analyst location" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_analyst_search") %></title>
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
	<script type="text/javascript" src="/tools/print/js/addOption.js"></script>

	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.Button");
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function byAnalyst(event) {
	 	var formName = dijit.byId('analystForm');
	 	var analyst = getSelectValue('analyst');
	 	dojo.stopEvent(event);
	 	if (analyst == "None") {
			showReqMsg('<%= messages.getString("please_select_analyst") %>','analyst');
			return false;
		} else {
			dojo.create('input', {type: 'hidden',value: '1025',name: '<%= BehaviorConstants.TOPAGE %>'},formName.domNode,'first');
			formName.submit();
		}
	 } //bySDC
	 
	 function byGeo(event){
	 	var formName = getWidgetID('locForm');
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	var state = getSelectValue('state');
	 	dojo.stopEvent(event);
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
		dojo.create('input', {type: 'hidden',value: '1030',name: '<%= BehaviorConstants.TOPAGE %>'},formName.domNode,'first');
		formName.submit();
	 } //byGeo
	 
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry("<%= country %>"); addNewValue('country'); if (getSelectValue('geo') == '*') autoSelectValue('country','*'); break;
			case 'country': updateState("<%= state %>"); addNewValue('state'); if (getSelectValue('country') == '*') autoSelectValue('state','*'); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function addAnalyst(){
	 	var selectMenu = dijit.byId('analyst');
	 	<%
   		while(CPAnalyst_RS.next()) { %>
			var optionName = "<%= CPAnalyst_RS.getString("CP_ANALYST") %>";
   			var optionValue = "<%= CPAnalyst_RS.getString("CP_ANALYST") %>";
   			addOption(selectMenu,optionName,optionValue);
   		<% } %>
	 } //addAnalyst
	 
	 function addNewValue(dID){
	 	var selectMenu = dijit.byId(dID);
	 	addOption(selectMenu,'*','*');
	 } //addNewValue
	 
	 dojo.ready(function() {
	 	createpTag();
	 	createSelect('analyst', 'analyst', '<%= messages.getString("please_select_analyst") %>', 'None', 'analyst');
     	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	createSelect('state', 'state', '<%= messages.getString("select_state") %>...', 'None', 'stateloc');
      	createSubmitButton('submit_geo','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','submit_geo');
 		createSubmitButton('submit_analyst','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','submit_analyst');
 		createGetForm('analystform','analystForm','analystForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		createGetForm('locform','locForm','locForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		changeSelectStyle('250px');
		addAnalyst();
		updateGeo("<%= geo %>");
		addNewValue('geo');
        dojo.byId('geo').focus();
     });
     
     dojo.addOnLoad(function() {
    	dojo.connect(dojo.byId('locForm'), 'onsubmit', function(event) {
	 		byGeo(event);
	 	});
	 	dojo.connect(dojo.byId('analystForm'), 'onsubmit', function(event) {
	 		byAnalyst(event);
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
				<%= messages.getString("cp_analyst_search") %>
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
					<label id="statelabel" for="state">
						<%= messages.getString("state") %>:
						<span class="ibm-required">*</span>
					</label>
					<span>
					<div id='stateloc'></div>
					<div id='stateID' connectId="state" align="right"></div>
					</span>
				</div>
				
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='submit_geo'></div>
					</span>
					</div>
				</div>
			</div>
			<br />
			<div class="ibm-alternate-rule"><hr /></div>
	
			<div id='analystform'>
				<h2><span><%= messages.getString("by_analyst") %></span>:</h2>
				<div class="pClass">
					<label id="analystlabel" for="analyst">
						<%= messages.getString("analyst") %>:<span class="ibm-required">*</span>
					</label>
					<span>
					<div id='analyst'></div>
					<div id='analystID' connectId="analyst" align="right"></div>
					</span>
				</div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='submit_analyst'></div>
					</span>
					</div>
				</div>
			</div>
		</div>
		<!-- FEATURES_BEGIN -->
		<div id="ibm-content-sidebar">
		</div>
		<!-- FEATURES_END -->
		
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>