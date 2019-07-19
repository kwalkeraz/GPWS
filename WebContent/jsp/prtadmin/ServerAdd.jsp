<%	
	AppTools tool = new AppTools();
	TableQueryBhvr SDCView  = (TableQueryBhvr) request.getAttribute("SDC");
   	TableQueryBhvrResultSet SDCView_RS = SDCView.getResults();
  	TableQueryBhvr ProtocolView  = (TableQueryBhvr) request.getAttribute("ProtocolView");
   	TableQueryBhvrResultSet ProtocolView_RS = ProtocolView.getResults();
   	TableQueryBhvr ServerCustomerCategory  = (TableQueryBhvr) request.getAttribute("ServerCustomerCategory");
   	TableQueryBhvrResultSet ServerCustomerCategory_RS = ServerCustomerCategory.getResults();
	String geo = tool.nullStringConverter(request.getParameter("geo"));
	String country = tool.nullStringConverter(request.getParameter("country"));
	String state = tool.nullStringConverter(request.getParameter("state"));
	String city = tool.nullStringConverter(request.getParameter("city"));
	String building = tool.nullStringConverter(request.getParameter("building"));
	String floor = tool.nullStringConverter(request.getParameter("floor"));
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print add server"/>
	<meta name="Description" content="Global print website add server information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("server_add") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/updateGeographyServerInfo.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addServerCustomerCategory(){
	 	getWidgetID('customer').removeOption(getWidgetID('customer').getOptions());
	 	<%
   		while(ServerCustomerCategory_RS.next()) { %>
   			addOption('customer','<%= tool.nullStringConverter(ServerCustomerCategory_RS.getString("CATEGORY_VALUE1")) %>','<%= tool.nullStringConverter(ServerCustomerCategory_RS.getString("CATEGORY_VALUE1")) %>');
   		<% } %>
	 } //addStatus
	 
	 function addSDC(){
	 	<%
   		while(SDCView_RS.next()) { %>
   			addOption('sdc','<%= tool.nullStringConverter(SDCView_RS.getString("CATEGORY_VALUE1")) %>','<%= tool.nullStringConverter(SDCView_RS.getString("CATEGORY_VALUE1")) %>');
   		<% } %>
	 } //addSDC
	 
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
	 
	 function addProtocol(dID){
	 	<% while(ProtocolView_RS.next()) {
			if (!ProtocolView_RS.getString("HOST_PORT_CONFIG").equals("Hostname/Port")) { %>
				createCheckBoxList('protocol<%= ProtocolView_RS.getString("PROTOCOL_NAME") %>', '<%= ProtocolView_RS.getInt("PROTOCOLID") %>', '<%= ProtocolView_RS.getString("PROTOCOL_NAME") %>', false, dID);
		<% } else if (ProtocolView_RS.getResultSetSize() == 0) {%>
				getID(dID).innerHTML = "<p><a class='ibm-error-link'></a>"+'<%= messages.getString("server_no_protocols") %>.  <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=310"><%= messages.getString("protocol_add_new") %></a>';
		<% } %>
   		<% } //while %>
	 } //addProtocol
	 
	 function addServer(event) {
	 	var sdc = getSelectValue('sdc');
	 	getID("errorMsg").innerHTML = "";
	 	var formName = getWidgetID('addServerForm');
	 	var formValid = formName.validate();
	 	var wName = getWidgetIDValue('servername');
	 	var logaction = getID('logaction');
	 	//reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (!showSelectMsg("None", sdc, '<%= messages.getString("please_select_sdc") %>', 'sdc')) return;
			var isChecked = false;
			<%	ProtocolView_RS.first();
				if (ProtocolView_RS.getResultSetSize() > 0 ) {
				while(ProtocolView_RS.next()) { 
					if (!ProtocolView_RS.getString("HOST_PORT_CONFIG").equals("Hostname/Port")) {%>
						if(getWidgetID('protocol'+'<%= ProtocolView_RS.getString("PROTOCOL_NAME") %>').checked) {
							isChecked = true;
						} //if not checked
				<% 	}  //if not DIPP
					} //while 
				}  //if%>
			if (isChecked == false) {
				alert('<%= messages.getString("server_select_one_protocol") %>');
				return false;
			} //if false 
	 		if (formValid) {
	 			logaction.value = "Server " + wName + " has been added";
				formName.submit();
			} else {
				return false;
			}
	 } //addServer
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '5040');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','submitvalue','insert');
        createpTag();
        createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', '0', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', '0', 'countryloc');
      	createSelect('state', 'state', '<%= messages.getString("select_state") %>...', '0', 'stateloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', '0', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', '0', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', '0', 'floorloc');
        createTextBox('room','room','room','64','','');
        createSelect('sdc', 'sdc', '<%= messages.getString("please_select_sdc") %>', 'None', 'sdcloc');
        createTextInput('servername','servername','servername','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_server_name,'');
        createTextBox('serveros','serveros','serveros','16','','');
        createTextBox('serversn','serversn','serversn','16','','');
        createTextBox('servermodel','servermodel','servermodel','16','','');
        createTextInput('ipaddress','ipaddress','ipaddress','16',false,'','','<%= messages.getString("field_problems") %>','(\[0-9]{1,3})\.(\[0-9]{1,3})\.(\[0-9]{1,3})\.(\[0-9]{1,3})','');
        createTextInput('contactemail','contactemail','contactemail','128',true,'','','<%= messages.getString("field_problems") %>',g_emailList_regexp,'');
        createSelect('customer', 'customer', '', '', 'customerloc');
        createTextArea('comments', 'comments', '', '');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_building');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_building','cancelForm()');
     	createPostForm('addServer','addServerForm','addServerForm','ibm-column-form','<%= prtgateway %>');
     	updateGeo("<%= geo %>");
     	addSDC('sdc');
     	addServerCustomerCategory('customer');
     	addProtocol('protocols');
     	getWidgetID('servername').focus();
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
     	<%if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('addServerForm'), 'onsubmit', function(event) {
		 	addServer(event);
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
			</ul>
			<h1><%= messages.getString("server_add") %></h1>
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
			<div id='addServer'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
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
					<label id="statelabel" for="state">
						<%= messages.getString("state") %>:
					</label>
					<span>
						<div id='stateloc'></div>
						<div id='stateID' connectId="state" align="right"></div>
					</span>
				</div>
				<div class="pClass">
					<label id="sitelabel" for="site">
						<%= messages.getString("site") %>:
					</label>
					<span>
						<div id='cityloc'></div>
						<div id='siteID' connectId="site" align="right"></div>
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
					<label for='room'><%= messages.getString("room") %>:</label>
					<span><div id='room'></div></span>
				</div>
				<div class="pClass">
					<label for='sdc'><%= messages.getString("sdc") %>:<span class='ibm-required'>*</span></label>
					<span><div id='sdcloc'></div></span>
				</div>
				<div class="pClass">
					<label for='servername'><%= messages.getString("server_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='servername'></div></span>
				</div>
				<div class="pClass">
					<label for='serveros'><%= messages.getString("server_os") %>:</label>
					<span><div id='serveros'></div></span>
				</div>
				<div class="pClass">
					<label for='serversn'><%= messages.getString("server_serial") %>:</label>
					<span><div id='serversn'></div></span>
				</div>
				<div class="pClass">
					<label for='servermodel'><%= messages.getString("server_model") %>:</label>
					<span><div id='servermodel'></div></span>
				</div>
				<div class="pClass">
					<label for='ipaddress'><%= messages.getString("ip_address") %>:</label>
					<span><div id='ipaddress'></div></span>
				</div>
				<div class="pClass">
					<label for='contactemail'><%= messages.getString("contact_email") %>:<span class='ibm-required'>*</span></label>
					<span><div id='contactemail'></div></span>
				</div>
				<div class="pClass">
					<label for='customer'><%= messages.getString("customer") %>:</label>
					<span><div id='customerloc'></div></span>
				</div>
				<div class="pClass">
					<label for='comments'><%= messages.getString("comments") %>:</label>
					<span><div id='comments'></div></span>
				</div>
				<div class="pClass">
					<label for='protocols'><%= messages.getString("server_select_protocol") %>:<span class='ibm-required'>*</span></label>
					<span class="ibm-input-group"><div id='protocols'></div></span>
				</div>
				<div class='ibm-alternate-rule'><hr /></div>
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