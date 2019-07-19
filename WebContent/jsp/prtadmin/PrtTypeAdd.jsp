	<%
		AppTools appT = new AppTools();
   		String logaction = appT.nullStringConverter(request.getParameter("logaction"));
   		
   		int iMaxLang= 0;
   		String sMaxLang = CategoryTools.getCategoryValue1("DeviceDisplayLanguages", "MAX");
   		if (sMaxLang != null && !sMaxLang.equals("")) {
   			iMaxLang = Integer.parseInt(sMaxLang);
   		}
	%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print add device model"/>
	<meta name="Description" content="Global print website add a device model page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("add_strategic_device_type") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.RadioButton");
	 
	 function reqName(wName){
	 	//console.log('wName is ' + wName);
	 	var found = false;
	 	var tagName = 'Name';
	 	var optionName = "";
<%-- 	 	var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10005&query=model"; --%>
	 	var urlValue = "/tools/print/servlet/api.wss/model";
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		   		for (var i = 0; i < tn.length; i++) {
		   			try {
			   			optionName = tn[i].firstChild.data;
			   		} catch(e) {
			   			optionName = "";
			   		}
		   			if (optionName == wName) {
		   				found = true;
		   				break;
		   			}
		   		} //for loop
		   	}, //load function
		   	preventCache: true,
		   	sync: true,
		   	error : function(response, args) {
		   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
		   	} //error function
		});
		return found;
	 } //reqName
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function addDeviceModel(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = getWidgetID('DeviceModel');
	 	var formValid = formName.validate();
	 	var wName = getWidgetIDValue('devicemodel');
	 	var confprint = getSelectValue('confprint');
	 	var logaction = getID('logaction');
	 	event.preventDefault();
	 	dojo.stopEvent(event);
			if (confprint == 'None') {
				showReqMsg('<%= messages.getString("confidential_print") %> <%= messages.getString("required_selected_info") %>','confprint');
				return false;
			}
			if (getSelectValue('color') == 'None') {
				showReqMsg('<%= messages.getString("Color") %> <%= messages.getString("required_selected_info") %>','color');
				return false;
			}
			if (formValid) {
				if (reqName(wName)) {
	 				getID("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("device_model_exists") %>'+"</p>";
					getWidgetID('devicemodel').focus();
					return false;
				} else {
					logaction.value = "Device model " + wName + " has been added";
					formName.submit();
				}
			}
	 } //addDeviceModel
	 
	 function cancelForm(){
		document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function createRadioB(bChecked, wID, wName, wValue, wLoc){
	 	var radioOne = new dijit.form.RadioButton({
		    checked: bChecked,
		    value: wValue,
		    name: wName,
		    id: wID,
		  }, wLoc);
	 } //createRadioB
	 
	 function addValues(){
	 	var selectMenu = dijit.byId('confprint');
	 	selectMenu.addOption({value: 'Y', label: 'Yes' });
	 	selectMenu.addOption({value: 'N', label: 'No' });
	 	
	 	var selectMenuColor = dijit.byId('color');
	 	selectMenuColor.addOption({value: 'Y', label: 'Yes' });
	 	selectMenuColor.addOption({value: 'N', label: 'No' });
	 	
	 	console.log("adding lang values");
	 	var selectMenuLang = dijit.byId('numlangdis');
	 	for (var x = 1; x <= <%= iMaxLang %>; x++) {
	 		selectMenuLang.addOption({value: x, label: x });
	 	}
	 } //addValues
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '810');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('devicemodelloc','devicemodel','devicemodel','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;/+()-]*$','');
        createSelect('confprint', 'confprint', '<%= messages.getString("device_select_yes") %>...', 'None', 'confprintloc');
        createSelect('color', 'color', '<%= messages.getString("device_select_yes") %>...', 'None', 'colorloc');
        createSelect('numlangdis', 'numlangdis', '<%= messages.getString("please_select_option") %>...', '0', 'numlangdisloc');
        addValues();
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_model');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_model','cancelForm()');
     	createPostForm('addDeviceModel','DeviceModel','DeviceModel','ibm-column-form','<%= prtgateway %>');
     	createRadioB(true, 'strategic','strategic', 'Y', 'strategicloc');
     	createRadioB(false, 'nonstrategic','strategic', 'N', 'nonstrategicloc');
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
     	getWidgetID('devicemodel').focus();
     	var inputButton1 = getID("submit_add_model");
     	var submitButton = { 
     					onClick: function(evt){
     							addDeviceModel(evt);
							} //function
						};
     	dojo.connect(inputButton1, "onclick", submitButton.onClick);
     	<%if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
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
			<h1><%= messages.getString("add_strategic_device_type") %></h1>
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
			<div id='addDeviceModel'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='devicemodel'><%= messages.getString("device_model") %>:<span class='ibm-required'>*</span></label>
					<span><div id='devicemodelloc'></div></span>
				</div>
				<div class="pClass">
					<label for='strategic'><%= messages.getString("strategic") %>:<span class='ibm-required'>*</span></label>
					<span class="ibm-input-group">
						<div id='strategicloc'></div><label for="strategic"><%= messages.getString("strategic") %></label>
						<div id='nonstrategicloc'></div><label for="nonstrategic"><%= messages.getString("non_strategic") %></label>
					</span>
				</div>
				<div class="pClass">
					<label for='confprint'><%= messages.getString("confidential_print") %>:<span class='ibm-required'>*</span></label>
					<span><div id='confprintloc'></div></span>
				</div>
				<div class="pClass">
					<label for='color'><%= messages.getString("Color") %><span class='ibm-required'>*</span>:</label>
					<span><div id='colorloc'></div></span>
				</div>
				<div class="pClass">
					<label for='numlangdis'><%= messages.getString("number_of_display_lang") %>:</label>
					<span><div id='numlangdisloc'></div></span>
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