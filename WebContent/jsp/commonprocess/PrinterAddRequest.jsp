<%
	TableQueryBhvr PrtTypes  = (TableQueryBhvr) request.getAttribute("PrtTypes");
	TableQueryBhvrResultSet PrtTypes_RS = PrtTypes.getResults();
	
	TableQueryBhvr RoomAccess  = (TableQueryBhvr) request.getAttribute("RoomAccess");
	TableQueryBhvrResultSet RoomAccess_RS = RoomAccess.getResults();
	
	TableQueryBhvr DeviceType  = (TableQueryBhvr) request.getAttribute("DeviceType");
	TableQueryBhvrResultSet DeviceType_RS = DeviceType.getResults();
	
	TableQueryBhvr BuildingView  = (TableQueryBhvr) request.getAttribute("BuildingInfo");
	TableQueryBhvrResultSet BuildingView_RS = BuildingView.getResults();
	BuildingView_RS.next();
	AppTools appTool = new AppTools();
	String sitecode = appTool.nullStringConverter(BuildingView_RS.getString("SITE_CODE"));
	String sdc = appTool.nullStringConverter(BuildingView_RS.getString("SDC"));
	String countryabbr = appTool.nullStringConverter(BuildingView_RS.getString("COUNTRY_ABBR"));
	String state = appTool.nullStringConverter(BuildingView_RS.getString("STATE"));
	
	Cookie cGeo = new Cookie("globalPrintGeo",appTool.nullStringConverter(request.getParameter("geo")));
	Cookie cCountry = new Cookie("globalPrintCountry",appTool.nullStringConverter(request.getParameter("country")));
	Cookie cSite = new Cookie("globalPrintSite",appTool.nullStringConverter(request.getParameter("city")));
	Cookie cBuilding = new Cookie("globalPrintBuilding",appTool.nullStringConverter(request.getParameter("building")));
	Cookie cFloor = new Cookie("globalPrintFloor",appTool.nullStringConverter(request.getParameter("floor")));
	cGeo.setMaxAge(31449600);
	cCountry.setMaxAge(31449600);
	cSite.setMaxAge(31449600);
	cBuilding.setMaxAge(31449600);
	cFloor.setMaxAge(31449600);
	response.addCookie(cGeo);
	response.addCookie(cCountry);
	response.addCookie(cSite);
	response.addCookie(cBuilding);
	response.addCookie(cFloor); 
%>
	<%@ include file="GetCurrentDateTime.jsp" %>
	
	<% String reqnumVal = CurrentMonthLit + CurrentDay + CurrentYear + CurrentHour + CurrentMinute;

	String geo = appTool.nullStringConverter(request.getParameter("geo"));
	String country = appTool.nullStringConverter(request.getParameter("country"));
	String city = appTool.nullStringConverter(request.getParameter("city"));
	String building = appTool.nullStringConverter(request.getParameter("building"));
	String floor = appTool.nullStringConverter(request.getParameter("floor"));

	keyopTools keyTool = new keyopTools();
	String sServerName = keyTool.getServerName();
	
	String sReqDate = "";
	String sJust = "";
	String sSDC = "";
	String sBillDept = "";
	String sBillDiv = "";
	String sBillDet = "";
	String sBillName = "";
	String sBillEmail = "";
	String sRoom = "";
	String sRoomAccess = "";
	String sRoomPhone = "";
	String sLanDrop = "";
	String sConnect = "";
	String sModel = "";
	String sOModel = "";
	String sNumTrays = "";
	String sDevSerial = "";
	String sMac = "";
	String sComment = "";
	String sKOName = "";
	String sKOPhone = "";
	String sKOEmail = "";
	String sKOPager = "";
	String sKOCO = "";
	
	if (request.getParameter("DtReqComp") != null)
		sReqDate = appTool.nullStringConverter(request.getParameter("DtReqComp"));
	if (request.getParameter("Justification") != null)
		sJust = appTool.nullStringConverter(request.getParameter("Justification"));
	if (request.getParameter("geoplexoption") != null)
		sSDC = appTool.nullStringConverter(request.getParameter("geoplexoption"));
	if (request.getParameter("BillToDept") != null)
		sBillDept = appTool.nullStringConverter(request.getParameter("BillToDept"));
	if (request.getParameter("BillToDiv") != null)
		sBillDiv = appTool.nullStringConverter(request.getParameter("BillToDiv"));
	if (request.getParameter("BillToDetail") != null)
		sBillDet = appTool.nullStringConverter(request.getParameter("BillToDetail"));
	if (request.getParameter("BillToName") != null)
		sBillName = appTool.nullStringConverter(request.getParameter("BillToName"));
	if (request.getParameter("BillToEmail") != null)
		sBillEmail = appTool.nullStringConverter(request.getParameter("BillToEmail"));
	if (request.getParameter("room") != null)
		sRoom = appTool.nullStringConverter(request.getParameter("room"));
	if (request.getParameter("RmAccess") != null)
		sRoomAccess = appTool.nullStringConverter(request.getParameter("RmAccess"));
	if (request.getParameter("PrtRmPhone") != null)
		sRoomPhone = appTool.nullStringConverter(request.getParameter("PrtRmPhone"));
	if (request.getParameter("LANDrp") != null)
		sLanDrop = appTool.nullStringConverter(request.getParameter("LANDrp"));
	if (request.getParameter("connecttype") != null)
		sConnect = appTool.nullStringConverter(request.getParameter("connecttype"));
	if (request.getParameter("PType") != null)
		sModel = appTool.nullStringConverter(request.getParameter("PType"));
	if (request.getParameter("OtherModel") != null)
		sOModel = appTool.nullStringConverter(request.getParameter("OtherModel"));
	if (request.getParameter("NumTrays") != null)
		sNumTrays = appTool.nullStringConverter(request.getParameter("NumTrays"));
	if (request.getParameter("PSerial") != null)
		sDevSerial = appTool.nullStringConverter(request.getParameter("PSerial"));
	if (request.getParameter("MACAddr") != null)
		sMac = appTool.nullStringConverter(request.getParameter("MACAddr"));
	if (request.getParameter("ITcomments") != null)
		sComment = appTool.nullStringConverter(request.getParameter("ITcomments"));
	if (request.getParameter("KeyopName") != null)
		sKOName = appTool.nullStringConverter(request.getParameter("KeyopName"));
	if (request.getParameter("KeyopTieLine") != null)
		sKOPhone = appTool.nullStringConverter(request.getParameter("KeyopTieLine"));
	if (request.getParameter("KeyopEmail") != null)
		sKOEmail = appTool.nullStringConverter(request.getParameter("KeyopEmail"));
	if (request.getParameter("KeyopPager") != null)
		sKOPager = appTool.nullStringConverter(request.getParameter("KeyopPager"));
	if (request.getParameter("KeyopCo") != null)
		sKOCO = appTool.nullStringConverter(request.getParameter("KeyopCo"));
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device add request information"/>
	<meta name="Description" content="Global print website request add device information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_add_request") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/formatDate.js"></script>
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
	 dojo.require("dijit.form.DateTextBox");
	 
	 function cancelForm(){
	 	document.location.href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1010";
	 } //cancelForm
	 
	 function addDevice(event) {
	 	var formName = getWidgetID("DeviceForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var igsdevice = getSelectValue('igsdevice');
        var comments = getWidgetIDValue('itcomment').replace(/(\r\n|[\r\n])/g, " ").trim();
        setWidgetIDValue('itcomment',comments);
        var justification = getWidgetIDValue('justification').replace(/(\r\n|[\r\n])/g, " ").trim();
        setWidgetIDValue('justification',justification);
        var emailLookup = getWidgetID('emailLookup');
        var email = getID('email');
        email.value = emailLookup.get('value');
        if (email.value == ""){
        	alert('<%= messages.getString("email_address") %> <%= messages.getString("is_required") %>');
        	emailLookup.focus();
        	return false;
        }
        formValid = formName.validate();
        if (justification.length > 255) {
			alert("<%= messages.getStringArgs("limit_justification_field_size", new String[] {"255"}) %> " + justification.length);
			getWidgetID('justification').focus();
			return false;
		}
		var functionBoolean = false;
		<%
		DeviceType_RS.first();
		if (DeviceType_RS.getResultSetSize() > 0 ) {
			while(DeviceType_RS.next()) {
		%>
				if(getWidgetID('<%= appTool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type').checked) {
					functionBoolean = true;
				}
		<% } //while
		} //if > 0 %>
		if (!functionBoolean) {
			alert('<%= messages.getString("device_select_one_function") %>');
			return false;
		}
		if (igsdevice == "None") {
			showReqMsg('<%= messages.getString("device_select_yes") %>','igsdevice');
			return false;
		} //sdc
		if (formValid){
			var datereq = document.getElementsByName('datereq')[0];
			datereq.value = formatDated2M2y4(datereq.value);
			//Get the date in seconds
		 	var d = new Date();
			var n = d.getSeconds();
			n = (n.toString().length == 1) ? '0' + n : n;
			var reqnum = '<%= reqnumVal%>' + n;
			setValue('reqnum', reqnum);
			formName.submit();
		} else {
			return false;
		}
	 } //addDevice
	  
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'igsdevice': showAddInfo(); break;
			case 'printtype': showPrinterInfo(); break;
			case 'vm': showEnblInfo(); break;
			case 'mvs': showEnblInfo(); break;
			case 'sap': showEnblInfo(); break;
			case 'wts': showEnblInfo(); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function addRoomAccess() {
	 	<%
			if (RoomAccess_RS.getResultSetSize() > 0 ) {
				while(RoomAccess_RS.next()) { %>
					addOption('roomaccess',"<%= appTool.nullStringConverter(RoomAccess_RS.getString("CATEGORY_VALUE1")) %>","<%= appTool.nullStringConverter(RoomAccess_RS.getString("CATEGORY_VALUE1")) %>");
		<%		}
			}
		%>
	 } //addRoomAccess
	 
	 function addDeviceFunctions(dID){
	 	var check = true;
	 	<% 
	 		//boolean check = true;
	 		DeviceType_RS.first();
	 		while(DeviceType_RS.next()) { %>
		 		if ('<%= appTool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type' == 'faxtype') {
		 			check = false;
		 		}
	 		
				createCheckBox('<%= appTool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type','<%= appTool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>', '<%= appTool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>', check, dID);
				if ('<%= appTool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type' == 'printtype' && check) {
					showPrinterInfo();
				}
				check = true;
		<%  } //while %>
	 } //addDeviceFunctions
	 
	 function addEnablements(){
	 	createCheckBox('cs','Y','<%= messages.getString("cs") %>',true,'enablements');
	 	createCheckBox('vm','Y','<%= messages.getString("vm") %>',false,'enablements');
	 	createCheckBox('mvs','Y','<%= messages.getString("mvs") %>',false,'enablements');
	 	createCheckBox('sap','Y','<%= messages.getString("sap") %>',false,'enablements');
	 	createCheckBox('wts','Y','<%= messages.getString("wts") %>',false,'enablements');
	 } //addEnablements
	 
	 function addDataStreams(){
	 	createCheckBox('ps','Y','<%= messages.getString("ps") %>',false,'datastreams');
	 	createCheckBox('pcl','Y','<%= messages.getString("pcl") %>',false,'datastreams');
	 	createCheckBox('ascii','Y','<%= messages.getString("ascii") %>',false,'datastreams');
	 	createCheckBox('ipds','Y','<%= messages.getString("ipds") %>',false,'datastreams');
	 	createCheckBox('ppds','Y','<%= messages.getString("ppds") %>',false,'datastreams');
	 } //addEnablements
	 
	 function changeRequiredValues(fieldArray,requiredValue){
	 	dojo.forEach(fieldArray, function(args){
			getWidgetID(args).set('required',requiredValue);
		});
	 } //changeRequiredValues
	 	 
	 function addIGSAsset() {
	 	addOption('igsdevice','Yes','Y');
	 	addOption('igsdevice','No','N');
	 } //addIGSAsset
	 
	 function addDIPP() {
	 	addOption('dipp','Yes','Y');
	 	addOption('dipp','No','N');
	 } //addIGSAsset
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function showHelp(anchor) {
		onGo('<%= statichtmldir %>/HelpForm.html#' + anchor, 810, 1070);
	 } //showHelp
	 
	 function onGo(link,h,w) {
		var chasm = screen.availWidth;
		var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + ',scrollbars=yes,resizable=yes,status=yes';	
		args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		w = window.open(link,'_blank',args);
		return false;
	 }  //onGo
	 
	 function loadDeviceModels() {
	 	var selectedValue = "";
	 	var syncValue = false;
     	var dID = "devicemodel";
	 	resetMenu(dID);
	 	var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10005&query=model";
	 	var tagName = "Name";
	 	var dataTag = "Model";
	 	//getXMLDatabyId(url,tagName,dataTag,dID,selectedValue);
	 	dojo.xhrGet({
	      	url : urlValue,
	      	handleAs : "xml",
	    	load : function(response, args) {
	    		var tn = response.getElementsByTagName(tagName);
	      		var dt = response.getElementsByTagName(dataTag);
	      		var selectMenu = getWidgetID(dID);
	      		var optionName = "";
	      		var optionValue = "0";
	      		var strategic = "";
	      		for (var i = 0; i < tn.length; i++) {
	      			try {
			   			optionName = tn[i].firstChild.data;
	      				optionValue = dt[i].getAttribute("id");
		      			strategic = response.getElementsByTagName("Strategic")[i].firstChild.data;
	      			} catch (e) {
	      				console.log("Exception: " + e);
	      				optionName = "";
	      				optionValue = "0";
	      				strategic = "";
	      			}
	      			if (strategic == "Y") {
		      			selectMenu.addOption({value: optionValue, label: optionName });
		      			if (selectedValue == optionValue) {
		      				sValue = optionValue;
		      			}
		      		} //if strategic
	      		} //for loop
	      		autoSelectValue(dID,sValue);
	      	}, //load function
	      	preventCache: true,
	      	sync: (syncValue) ? syncValue : 'false',
	      	error : function(response, args) {
	      		console.log("Error getting XML data: " + args.xhr.status);
	      	} //error function
	      });
	 } //loadDeviceModels
	 
	 function addDuplex() {
	 	addOption('duplex','Yes','Y');
	 	addOption('duplex','No','N');
	 } //addDuplex
	 
	 function showPrinterInfo() {
	 	var device = getWidgetID('printtype').checked;
	 	var displayValue = "none";
	 	if (device)	{
	 		displayValue = "";
	 	} else {
	 		getWidgetID('cs').set('checked', true);
			getWidgetID('vm').set('checked', false);
			getWidgetID('mvs').set('checked', false);
			getWidgetID('sap').set('checked', false);
			getWidgetID('wts').set('checked', false);
			autoSelectValue('dipp','N');
	 	}
	 	displayFields(["printerinfo"],displayValue);
	 } //showPrinterInfo
	 
	 function showEnblInfo() {
	 	var isChecked = false;
	 	if (getWidgetID('vm').checked || getWidgetID('mvs').checked || getWidgetID('sap').checked || getWidgetID('wts').checked) {
	 		isChecked = true;
	 	}
	 	var displayValue = "none";
	 	if (isChecked)	{
	 		displayValue = "";
	 	}
	 	displayFields(["enblinfo"],displayValue);
	 } //showPrinterInfo
	 
	 function showAddInfo(){
	 	var displayValue = "none";
	 	var igsasset = getSelectValue('igsdevice');
		if (igsasset == "N") {
			displayValue = "";
			//changeRequiredValues(["serialnum"],true);
		} else {
			autoSelectValue('devicemodel','None');
			setWidgetIDValue('othermodel','');
			getWidgetID('ps').set('checked', false);
			getWidgetID('pcl').set('checked', false);
			getWidgetID('ascii').set('checked', false);
			getWidgetID('ipds').set('checked', false);
			getWidgetID('ppds').set('checked', false);
			autoSelectValue('duplex','None');
			setWidgetIDValue('numtrays','');
			setWidgetIDValue('serialnum','');
			//changeRequiredValues(["serialnum"],false);
			setWidgetIDValue('macaddr','');
			setWidgetIDValue('itcomment','');
		}
		displayFields(["igsinfo"],displayValue);
	 } //showRequiredFields
	 
	 function rsgET(response, tagName) {
		var rt = response.getElementsByTagName(tagName)[0].firstChild.data;
		return rt;
	 } //rsgET
	 
	 function lookupEmail(){
	 	getID("response").innerHTML = "";
	 	found = false;
	 	var email = getWidgetIDValue('emailLookup');
	 	var reqName = getWidgetID('requestername');
	 	var phone = getWidgetID('phone');
	 	//var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10015&query=user&email=" + email;
	 	var urlValue = "<%= statichtmldir %>/servlet/api.wss/user/email/" + email;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var emailAddr = "";
		   		try {
	   				emailAddr = rsgET(response, 'EmailAddress');
		   		} catch (e) {
		   			console.log('no email found' + e);
		   			getID("response").innerHTML = "<p><a class='ibm-error-link'></a>"+"<%= messages.getString("email_not_found") %>"+"<br /></p>";
		   		} //try and catch
	   			//console.log('optionName is ' + optionName);
	   			if (emailAddr != "") {
	   				try {
	   					var username = fixName(rsgET(response, 'FullName'));
	   					setWidgetIDValue(reqName, username);
	   					setWidgetIDValue(phone, rsgET(response, 'Phone'));
	   					getWidgetID('datereq').focus();
			   		} catch (e) {
			   			console.log("error setting values: " + e);
			   			//setWidgetIDValue(reqName, '');
	   					//setWidgetIDValue(phone, '');
	   					getWidgetID('emailLookup').focus();
			   		} //try and catch
	   			}
		   	}, //load function
		   	preventCache: true,
		   	sync: true,
		   	error : function(response, args) {
		   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
		   	} //error function
		});
		return found;
	 } //reqName
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1100','<%= BehaviorConstants.TOPAGE %>');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','action','ADD');
        createHiddenInput('logactionid','status','NEW');
        createHiddenInput('logactionid','reqnum','');
        createHiddenInput('logactionid','geo','<%= geo %>');
        createHiddenInput('logactionid','country','<%= country %>');
        createHiddenInput('logactionid','countryabbr','<%= countryabbr %>');
        createHiddenInput('logactionid','state','<%= state %>');
        createHiddenInput('logactionid','city','<%= city %>');
        createHiddenInput('logactionid','building','<%= building %>');
        createHiddenInput('logactionid','floor','<%= floor %>');
        createHiddenInput('logactionid','sdc','<%= sdc %>');
        createHiddenInput('logactionid','status','NEW');
        createHiddenInput('logactionid','email','');
        createHiddenInput('logactionid','IGSAssetMgnt','N'); //IGS_Asset defaults to N
        createpTag();
        var fieldArray = ["printerinfo","igsinfo","enblinfo"];
		displayFields(fieldArray,"none");
        createTextInput('emailLookup','emailLookup','emailLookup','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','');
        createTextInput('requestername','requestername','requestername','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'');
        createTextInput('phone','phone','phone','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_phone_number_regexp,'');
        createInputButton('emp_lookup_button','ibm-cancel','<%= messages.getString("emp_lookup") %>','ibm-btn-cancel-sec','submit_email','lookupEmail()');
        createTextInput('room','room','room','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_room_regexp,'');
        createSelect('roomaccess', 'roomaccess', '<%= messages.getString("device_select_roomaccess") %> ...', 'None', 'roomaccess');
        addRoomAccess();
        createTextBox('roomphone','roomphone','roomphone','64','','');
        createTextBox('landrop','landrop','landrop','32','','');
        addDeviceFunctions("functions");
        createSelect('igsdevice', 'igsdevice', '<%= messages.getString("device_select_yes") %> ...', 'None', 'igsdevice');
        addIGSAsset();
        autoSelectValue('igsdevice','N');
        createTextArea('justification', 'justification', '', '');
        addEnablements();
        addDataStreams();
        createTextBox('reqsystems','reqsystems','reqsystems','64','','');
        createSelect('dipp', 'dipp', '<%= messages.getString("device_select_yes") %> ...', 'None', 'dipp');
        addDIPP();
        autoSelectValue('dipp','N');
        createSelect('devicemodel', 'devicemodel', '<%= messages.getString("device_select_model") %> ...', '0', 'devicemodel');
        loadDeviceModels();
        createTextBox('othermodel','othermodel','othermodel','32','','');
        createSelect('duplex', 'duplex', '<%= messages.getString("device_select_yes") %> ...', 'None', 'duplex');
        addDuplex();
        createTextBox('numtrays','numtrays','numtrays','16','','');
        //createTextInput('serialnum','serialnum','serialnum','32',false,'','','','^[^]*$','');
        createTextBox('macaddr','macaddr','macaddr','32','','');
        createTextArea('itcomment', 'itcomment', '', '');
        createTextBox('billdiv','billdiv','billdiv','16','','');
        createTextBox('billdept','billdept','billdept','16','','');
        createTextBox('billdetail','billdetail','billdetail','16','','');
        createTextBox('billemail','billemail','billemail','64','','');
        createTextBox('billname','billname','billname','64','','');
        createTextBox('requestnumber','requestnumber','requestnumber','16','','');
        createTextBox('koname','koname','koname','32','','');
        createTextBox('koemail','koemail','koemail','64','','');
        createTextBox('kophone','kophone','kophone','16','','');
        createTextBox('kopager','kopager','kopager','16','','');
        createTextBox('kocompany','kocompany','kocompany','16','','');
        
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_device');
        createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_device','cancelForm()');
     	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
     	createGetForm('lookupEmail','lookupEmailForm','lookupEmailForm','ibm-column-form','#');
     	createHiddenInput('copytopageid','<%= BehaviorConstants.TOPAGE %>', '292','copytopageid');
     	changeInputTagStyle('300px');
     	changeSelectStyle('300px');
     	changeCommentStyle('justification','300px');
     	changeCommentStyle('itcomment','300px');    	
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(dojo.byId('DeviceCopyForm'), 'onsubmit', function(event) {
		 	lookupEmail(event);
		 });
		 dojo.connect(dojo.byId('DeviceForm'), 'onsubmit', function(event) {
		 	addDevice(event);
		 });
		 getWidgetID('emailLookup').focus();
	 });
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead.jsp" %>
		<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<ul id="ibm-navigation-trail">
					<li><a href="<%= statichtmldir %>/ServiceRequests.html"><%= messages.getString("service_requests") %></a></li>
					<li><a href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("macdel_requests") %></a></li>
					<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1010"><%= messages.getString("device_request_connection") %></a></li>
				</ul>
				<h1><%= messages.getString("device_add_request") %></h1>
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
				<%= messages.getString("required_info") %>. <%= messages.getString("use_help_icon") %> <a class="ibm-information-link"></a> <%= messages.getString("next_sections_get_help") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id="lookupEmail">
				<div id='copytopageid'></div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<a class="ibm-information-link" href="javascript:showHelp('requester');" ><%= messages.getString("requester_info") %></a>
					</em>
				</div>
				<div id='notfound'></div>
				<div class="pClass">
					<label for='emailLookup'><%= messages.getString("email_address") %>:<span class='ibm-required'>*</span></label>
					<span><div id='emailLookup'></div></span>
				</div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='emp_lookup_button'></div>
					</span>
					</div>
				</div>
			</div>
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='Device'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='requestername'><%= messages.getString("requester_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='requestername'></div></span>
				</div>
				<div class="pClass">
					<label for='phone'><%= messages.getString("phone_number") %>:<span class='ibm-required'>*</span></label>
					<span><div id='phone'></div></span>
				</div>
				<p>
					<label for="datereq"><%= messages.getString("requested_complete_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="datereq" id="datereq" value="" /> (dd/mm/yyyy)</span>
				</p>
				<div class="pClass">
					<label for='justification'><%= messages.getString("justification_comments") %>:<span class='ibm-required'>*</span></label>
					<span><div id='justification'></div></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_info") %></h2>
					</em>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<a class="ibm-information-link" href="javascript:showHelp('location');" ><%= messages.getString("device_location_info") %></a>
					</em>
				</div>
				<div class="pClass">
					<label id="geolabel" for="geo">
						<%= messages.getString("geography") %>: 
					</label>
					<span>
						<%= geo %>
					</span>
				</div>
				<div class="pClass">
					<label id="countrylabel" for="country">
						<%= messages.getString("country") %>: 
					</label>
					<span>
						<%= country %>
					</span>
				</div>
				<div class="pClass">
					<label id="sitelabel" for="site">
						<%= messages.getString("site") %>: 
					</label>
					<span>
						<%= city %>
					</span>
				</div>
				<div class="pClass">	
					<label id="buildinglabel" for="building">
						<%= messages.getString("building") %>: 
					</label>
					<span>
						<%= building %>
					</span>
				</div>
				<div class="pClass">
					<label id="floorlabel" for="floor">
						<%= messages.getString("floor") %>: 
					</label>
					<span>
						<%= floor %>
					</span>
				</div>
				<div class="pClass">
					<label for='room'><%= messages.getString("room") %>:<span class='ibm-required'>*</span></label>
					<span><div id='room'></div></span>
				</div>
				<div class="pClass">
					<label for='roomaccess'><%= messages.getString("room_access") %>:</label>
					<span><div id='roomaccess'></div></span>
				</div>
				<div class="pClass">
					<label for='roomphone'><%= messages.getString("room_phone") %>:</label>
					<span><div id='roomphone'></div></span>
				</div>
				<div class="pClass">
					<label for='landrop'><%= messages.getString("lan_drop") %> <%= messages.getString("walljack") %>:</label>
					<span><div id='landrop'></div></span>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<a class="ibm-information-link" href="javascript:showHelp('device');" ><%= messages.getString("device_info") %></a>
					</em>
				</div>
				<div class="pClass">
					<label for='functions'><%= messages.getString("device_functions_wanted") %>:<span class='ibm-required'>*</span></label>
					<span class="ibm-input-group"><div id='functions'></div></span>
				</div>
				<div id="printerinfo">
					<div class="pClass">
						<label for='functions'><%= messages.getString("device_enablements") %>:</label>
						<span class="ibm-input-group"><div id='enablements'></div></span>
					</div>
					<div id="enblinfo">
						<div class="pClass">
							<label for='reqsystems'><%= messages.getString("system_name_requested") %>:</label>
							<span><div id='reqsystems'></div></span>
						</div>
						<br /><br />
					</div>
					<div class="pClass">
						<label for='dipp'><%= messages.getString("device_dipp") %>:</label>
						<span><div id='dipp'></div></span>
					</div>
				</div>
				<div class="pClass">
					<label for='igsdevice'><%= messages.getString("igs_provide_device") %>:<span class='ibm-required'>*</span></label>
					<span><div id='igsdevice'></div></span>
				</div>
				
				<div id="igsinfo">
					<div class="pClass">
						<label for='devicemodel'><%= messages.getString("device_select_model") %>:</label>
						<span><div id='devicemodel'></div></span>
					</div>
					<div class="pClass">
						<label for='othermodel'><%= messages.getString("other_device_model") %>:</label>
						<span><div id='othermodel'></div></span>
					</div>
					<div class="pClass">
						<label for='datastreams'><%= messages.getString("device_datastreams") %>:</label>
						<span class="ibm-input-group"><div id='datastreams'></div></span>
					</div>
					<div class="pClass">
						<label for='duplex'><%= messages.getString("device_duplex") %>:</label>
						<span><div id='duplex'></div></span>
					</div>
					<div class="pClass">
						<label for='numtrays'><%= messages.getString("device_num_trays") %>:</label>
						<span><div id='numtrays'></div></span>
					</div>
					<%-- <div class="pClass">
						<label for='serialnum'><%= messages.getString("device_serial_number") %>:</label>
						<span><div id='serialnum'></div></span>
					</div> --%>
					<div class="pClass">
						<label for='macaddr'><%= messages.getString("mac_address") %>:</label>
						<span><div id='macaddr'></div></span>
					</div>
					<div class="pClass">
						<label for='itcomment'><%= messages.getString("comments") %>:</label>
						<span><div id='itcomment'></div></span>
					</div>
				</div>
				<div class="pClass">
					<em>
						<a class="ibm-information-link" href="javascript:showHelp('billing');" ><%= messages.getString("device_bill_info") %></a>
					</em>
				</div>
				<div class="pClass">
					<label for='billdiv'><%= messages.getString("device_bill_division") %>:</label>
					<span><div id='billdiv'></div></span>
				</div>
				<div class="pClass">
					<label for='billdept'><%= messages.getString("device_bill_dept") %>:</label>
					<span><div id='billdept'></div></span>
				</div>
				<div class="pClass">
					<label for='billdetail'><%= messages.getString("device_bill_detail") %>:</label>
					<span><div id='billdetail'></div></span>
				</div>
				<div class="pClass">
					<label for='billemail'><%= messages.getString("device_bill_email") %>:</label>
					<span><div id='billemail'></div></span>
				</div>
				<div class="pClass">
					<label for='billname'><%= messages.getString("device_bill_name") %>:</label>
					<span><div id='billname'></div></span>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<a class="ibm-information-link" href="javascript:showHelp('keyop');" ><%= messages.getString("device_keyop_info") %></a>
					</em>
				</div>
				<div class="pClass">
					<label for='koname'><%= messages.getString("device_keyop_name") %>:</label>
					<span><div id='koname'></div></span>
				</div>
				<div class="pClass">
					<label for='koemail'><%= messages.getString("device_keyop_email") %>:</label>
					<span><div id='koemail'></div></span>
				</div>
				<div class="pClass">
					<label for='kophone'><%= messages.getString("device_keyop_phone") %>:</label>
					<span><div id='kophone'></div></span>
				</div>
				<div class="pClass">
					<label for='kopager'><%= messages.getString("device_keyop_pager") %>:</label>
					<span><div id='kopager'></div></span>
				</div>
				<div class="pClass">
					<label for='kocompany'><%= messages.getString("device_keyop_company") %>:</label>
					<span><div id='kocompany'></div></span>
				</div>
				<!-- End of entries -->
				<div class='ibm-alternate-rule'><hr /></div>
				<div class='ibm-buttons-row' align="right">
					<div class="pClass">
					<div id='submit_add_button'></div>
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