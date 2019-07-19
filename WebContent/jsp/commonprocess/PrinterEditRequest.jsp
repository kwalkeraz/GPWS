<%
	TableQueryBhvr Printer = (TableQueryBhvr) request.getAttribute("Printer");
	TableQueryBhvrResultSet Printer_RS = Printer.getResults();
	
	TableQueryBhvr RoomAccess  = (TableQueryBhvr) request.getAttribute("RoomAccess");
	TableQueryBhvrResultSet RoomAccess_RS = RoomAccess.getResults();
	
	AppTools appTool = new AppTools();
	
%>
	<%@ include file="GetCurrentDateTime.jsp" %>
	<% String reqnumVal = CurrentMonthLit + CurrentDay + CurrentYear + CurrentHour + CurrentMinute;

	String geo = appTool.nullStringConverter(request.getParameter("geo"));
	String country = appTool.nullStringConverter(request.getParameter("country"));
	String state = "";
	String city = appTool.nullStringConverter(request.getParameter("city"));
	String building = appTool.nullStringConverter(request.getParameter("building"));
	String floor = appTool.nullStringConverter(request.getParameter("floor"));
	String topageid = appTool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
	String searchName = appTool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	String referer = appTool.nullStringConverter(request.getParameter("referer"));

	keyopTools keyTool = new keyopTools();
	String sServerName = keyTool.getServerName();
	
	boolean cs = false;
	boolean vm = false;
	boolean mvs = false;
	boolean sap = false;
	boolean wts = false;
	String room = "";
	String devicename = "";
	String model = "";
	String duplex = ""; 
	String numtrays = ""; 
	String serialnum = ""; 
	String macaddr = "";
	
	String roomaccess = "";
	String roomphone = "";
	String landrop = ""; 
	String dipp = ""; 
	String connecttype = ""; 
	String koname = ""; 
	String kophone = ""; 
	String koemail = ""; 
	String kopager = ""; 
	String koco = ""; 
	String billdept = "";
	String billdiv = "";
	String billdetail = "";
	String billemail = "";
	String billname = "";
	String iphostname = "";
	String ipaddress = "";
	String ipdomain = "";
	String ipsubnet = "";
	String ipgateway = "";
	String igsasset = "";
	String igsdevice = "";
	String itcomment = "";
	String sdc = "";
	boolean ps = false;
	boolean pcl = false;
	boolean ascii = false;
	boolean ipds = false;
	boolean ppds = false;
	
	while (Printer_RS.next()) {
		if(appTool.nullStringConverter(Printer_RS.getString("CS")).equals("Y"))cs = true;
		if(appTool.nullStringConverter(Printer_RS.getString("VM")).equals("Y"))vm = true;
		if(appTool.nullStringConverter(Printer_RS.getString("MVS")).equals("Y"))mvs = true;
		if(appTool.nullStringConverter(Printer_RS.getString("SAP")).equals("Y"))sap = true;
		if(appTool.nullStringConverter(Printer_RS.getString("WTS")).equals("Y"))wts = true;
		//
		geo = appTool.nullStringConverter(Printer_RS.getString("GEO"));
		country = appTool.nullStringConverter(Printer_RS.getString("COUNTRY"));
		state = appTool.nullStringConverter(Printer_RS.getString("STATE"));
		city = appTool.nullStringConverter(Printer_RS.getString("CITY"));
		building = appTool.nullStringConverter(Printer_RS.getString("BUILDING_NAME"));
		floor = appTool.nullStringConverter(Printer_RS.getString("FLOOR_NAME"));
		room = appTool.nullStringConverter(Printer_RS.getString("ROOM"));
		devicename = appTool.nullStringConverter(Printer_RS.getString("DEVICE_NAME"));
		model = appTool.nullStringConverter(Printer_RS.getString("MODEL"));
		duplex = appTool.nullStringConverter(Printer_RS.getString("DUPLEX")); 
		numtrays = appTool.nullStringConverter(Printer_RS.getString("NUMBER_TRAYS")); 
		serialnum = appTool.nullStringConverter(Printer_RS.getString("SERIAL_NUMBER")); 
		macaddr = appTool.nullStringConverter(Printer_RS.getString("MAC_ADDRESS"));
		
		roomaccess = appTool.nullStringConverter(Printer_RS.getString("ROOM_ACCESS"));
		roomphone = appTool.nullStringConverter(Printer_RS.getString("ROOM_PHONE"));
		landrop  = appTool.nullStringConverter(Printer_RS.getString("LAN_DROP")); 
		dipp  = appTool.nullStringConverter(Printer_RS.getString("DIPP")); 
		connecttype  = appTool.nullStringConverter(Printer_RS.getString("CONNECT_TYPE")); 
		koname = appTool.nullStringConverter(Printer_RS.getString("KO_NAME")); 
		kophone = appTool.nullStringConverter(Printer_RS.getString("KO_PHONE")); 
		koemail = appTool.nullStringConverter(Printer_RS.getString("KO_EMAIL")); 
		kopager = appTool.nullStringConverter(Printer_RS.getString("KO_PAGER")); 
		koco = appTool.nullStringConverter(Printer_RS.getString("KO_COMPANY")); 
		billdept = appTool.nullStringConverter(Printer_RS.getString("BILL_DEPT"));
		billdiv = appTool.nullStringConverter(Printer_RS.getString("BILL_DIV"));
		billdetail = appTool.nullStringConverter(Printer_RS.getString("BILL_DETAIL"));
		billemail = appTool.nullStringConverter(Printer_RS.getString("BILL_EMAIL"));
		billname = appTool.nullStringConverter(Printer_RS.getString("BILL_NAME"));
		ipaddress = appTool.nullStringConverter(Printer_RS.getString("IP_ADDRESS"));
		iphostname = appTool.nullStringConverter(Printer_RS.getString("IP_HOSTNAME"));
		ipdomain = appTool.nullStringConverter(Printer_RS.getString("IP_DOMAIN"));
		ipsubnet = appTool.nullStringConverter(Printer_RS.getString("IP_SUBNET"));
		ipgateway = appTool.nullStringConverter(Printer_RS.getString("IP_GATEWAY"));
		igsasset  = appTool.nullStringConverter(Printer_RS.getString("IGS_ASSET"));
		igsdevice  = appTool.nullStringConverter(Printer_RS.getString("IGS_DEVICE"));
		itcomment  = appTool.nullStringConverter(Printer_RS.getString("COMMENT"));
		sdc = appTool.nullStringConverter(Printer_RS.getString("SERVER_SDC"));
		if(appTool.nullStringConverter(Printer_RS.getString("PS")).equals("Y")) ps = true;
		if(appTool.nullStringConverter(Printer_RS.getString("PCL")).equals("Y")) pcl = true;
		if(appTool.nullStringConverter(Printer_RS.getString("ASCII")).equals("Y")) ascii = true;
		if(appTool.nullStringConverter(Printer_RS.getString("IPDS")).equals("Y")) ipds = true;
		if(appTool.nullStringConverter(Printer_RS.getString("PPDS")).equals("Y")) ppds = true;
		String geoplex = appTool.nullStringConverter(Printer_RS.getString("SERVER_SDC"));
	} //while
	
	String datereq = "";
	String justification = "";
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device change request information"/>
	<meta name="Description" content="Global print website request change device information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_change_req") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
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
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function updateBuilding(selectedValue) {
		resetMenu('floor');
	 	resetMenu('building');
	 	//var selectedValue = "9032";
	 	var geo = "<%= geo %>";
	 	var country = "<%= country %>";
	 	var site = "<%= city %>";
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10000&query=building&geo="+geo+"&country="+country+"&city="+site;
	 	var tagName = "Name";
	 	var dataTag = "Building";
	 	var dID = "building";
	 	if (site != "None" && site != "0" && site != "*") {
	 		getXMLData(url,tagName,dataTag,dID,selectedValue);
	 	}
	 } //end updateBuilding
	 
	 function updateFloor(selectedValue) {
		resetMenu('floor');
	 	var geo = "<%= geo %>";
	 	var country = "<%= country %>";
	 	var site = "<%= city %>";
	 	var building = getSelectValue('building');
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10000&query=floor&geo="+geo+"&country="+country+"&city="+site+"&building="+building;
	 	var tagName = "Name";
	 	var dataTag = "Floor";
	 	var dID = "floor";
	 	if (building != "None" && building != "0" && building != "*") {
	 		getXMLData(url,tagName,dataTag,dID,selectedValue);
	 	}
	 } //end updateFloor
	 
	 function editDevice(event) {
	 	var formName = getWidgetID("DeviceForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var justification = getWidgetIDValue('justification').replace(/(\r\n|[\r\n])/g, " ").trim();
        setWidgetIDValue('justification',justification);
        var building = getSelectValue('building');
        var floor = getSelectValue('floor');
        var emailLookup = getWidgetID('emailLookup');
        var email = getID('email');
        email.value = emailLookup.get('value');
        var Duplex = getSelectValue('Duplex');
        if (Duplex == 'None') {
        	setValue('duplex','');
        } else {
        	setValue('duplex',Duplex);
        }
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
		} else if (justification == "") {
			alert('<%= messages.getString("justification") %> <%= messages.getString("is_required") %>');
			getWidgetID('justification').focus();
			return false;
		}
		if (building == "None" || building == "") {
			showReqMsg('<%= messages.getString("please_select_building") %>','building');
			return false;
		}
		if (floor == "None" || floor == "") {
			showReqMsg('<%= messages.getString("please_select_floor") %>','floor');
			return false;
		}
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
			return false;
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
			case 'building': updateFloor('<%= floor %>'); break;
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
	 	
	 } //addDeviceFunctions
	 
	 function addEnablements(){
	 	createCheckBox('cs','Y','<%= messages.getString("cs") %>',<%= cs %>,'enablements');
	 	createCheckBox('vm','Y','<%= messages.getString("vm") %>',<%= vm %>,'enablements');
	 	createCheckBox('mvs','Y','<%= messages.getString("mvs") %>',<%= mvs %>,'enablements');
	 	createCheckBox('sap','Y','<%= messages.getString("sap") %>',<%= sap %>,'enablements');
	 	createCheckBox('wts','Y','<%= messages.getString("wts") %>',<%= wts %>,'enablements');
	 	if (<%= cs %> || <%= vm %> || <%= mvs %> || <%= sap %> || <%= wts %>) {
	 		showEnblInfo();
	 	}
	 } //addEnablements
	 
	 function addDataStreams(){
	 	createCheckBox('ps','Y','<%= messages.getString("ps") %>',<%= ps %>,'datastreams');
	 	createCheckBox('pcl','Y','<%= messages.getString("pcl") %>',<%= pcl %>,'datastreams');
	 	createCheckBox('ascii','Y','<%= messages.getString("ascii") %>',<%= ascii %>,'datastreams');
	 	createCheckBox('ipds','Y','<%= messages.getString("ipds") %>',<%= ipds %>,'datastreams');
	 	createCheckBox('ppds','Y','<%= messages.getString("ppds") %>',<%= ppds %>,'datastreams');
	 } //addDataStreams
	 
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
	 	addOption('Duplex','Yes','Y');
	 	addOption('Duplex','No','N');
	 } //addDuplex
	 
	 function showPrinterInfo() {
	 	var device = getWidgetID('printtype').checked;
	 	var displayValue = "none";
	 	if (device)	{
	 		displayValue = "";
	 	} else {
	 		getWidgetID('cs').set('checked', false);
			getWidgetID('vm').set('checked', false);
			getWidgetID('mvs').set('checked', false);
			getWidgetID('sap').set('checked', false);
			getWidgetID('wts').set('checked', false);
			autoSelectValue('dipp','None');
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
			changeRequiredValues(["serialnum"],true);
		} else {
			autoSelectValue('devicemodel','None');
			setWidgetIDValue('othermodel','');
			getWidgetID('ps').set('checked', false);
			getWidgetID('pcl').set('checked', false);
			getWidgetID('ascii').set('checked', false);
			getWidgetID('ipds').set('checked', false);
			getWidgetID('ppds').set('checked', false);
			autoSelectValue('Duplex','None');
			setWidgetIDValue('numtrays','');
			setWidgetIDValue('serialnum','');
			changeRequiredValues(["serialnum"],false);
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
	 	dojo.byId("response").innerHTML = "";
	 	found = false;
	 	//var email = dijit.byId('emailLookup').get('value');
	 	var email = getWidgetIDValue('emailLookup');
	 	var reqName = dijit.byId('requestername');
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
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1200','<%= BehaviorConstants.TOPAGE %>');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','action','CHANGE');
        createHiddenInput('logactionid','reqnum','');
        createHiddenInput('logactionid','geo','<%= geo %>');
        createHiddenInput('logactionid','country','<%= country %>');
        createHiddenInput('logactionid','state','<%= state %>');
        createHiddenInput('logactionid','city','<%= city %>');
        createHiddenInput('logactionid','status','NEW');
        createHiddenInput('logactionid','devicename','<%= devicename %>');
        createHiddenInput('logactionid','iphostname','<%= iphostname %>');
        createHiddenInput('logactionid','email','');
        createHiddenInput('logactionid','duplex','','duplex');
        createpTag();
        var fieldArray = ["enblinfo"];
		displayFields(fieldArray,"none");
        createTextInput('emailLookup','emailLookup','emailLookup','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','');
        createTextInput('requestername','requestername','requestername','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'');
        createTextInput('phone','phone','phone','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_phone_number_regexp,'');
        createInputButton('emp_lookup_button','ibm-cancel','<%= messages.getString("emp_lookup") %>','ibm-btn-cancel-sec','submit_email','lookupEmail()');
        createTextInput('room','room','room','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','<%= room %>');
        createSelect('roomaccess', 'roomaccess', '<%= messages.getString("device_select_roomaccess") %> ...', 'None', 'roomaccess');
        addRoomAccess();
        autoSelectValue('roomaccess','<%= roomaccess %>');
        createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');
        createTextBox('roomphone','roomphone','roomphone','64','','<%= roomphone %>');
        createTextBox('landrop','landrop','landrop','32','','<%= landrop %>');
        createTextArea('justification', 'justification', '', '');
        addEnablements();
        addDataStreams();
        createTextBox('reqsystems','reqsystems','reqsystems','64','','');
        createSelect('Duplex', 'Duplex', '<%= messages.getString("device_select_yes") %> ...', 'None', 'Duplex');
        addDuplex();
        autoSelectValue('Duplex','<%= duplex %>');
        createTextBox('numtrays','numtrays','numtrays','16','','<%= numtrays %>');
        createTextInput('serialnum','serialnum','serialnum','32',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','<%= serialnum %>');
        createTextBox('macaddr','macaddr','macaddr','32','','<%= macaddr %>');
        createTextInput('ipdomain','ipdomain','ipdomain','64',false,null,'required','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9 _.-]*$','<%= ipdomain %>');
        createTextInput('ipaddress','ipaddress','ipaddress','16',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9.]*$','<%= ipaddress %>');
        createTextInput('ipgateway','ipgateway','ipgateway','16',false,null,'required','<%= messages.getString("field_problems") %>','^[0-9.]*$','<%= ipgateway %>');
        createTextInput('ipsubnet','ipsubnet','ipsubnet','16',false,null,'required','<%= messages.getString("field_problems") %>','^[0-9.]*$','<%= ipsubnet %>');
        createTextBox('billdiv','billdiv','billdiv','16','','<%= billdiv %>');
        createTextBox('billdept','billdept','billdept','16','','<%= billdept %>');
        createTextBox('billdetail','billdetail','billdetail','16','','<%= billdetail %>');
        createTextBox('billemail','billemail','billemail','64','','<%= billemail %>');
        createTextBox('billname','billname','billname','64','','<%= billname %>');
        createTextBox('requestnumber','requestnumber','requestnumber','16','','');
        createTextBox('koname','koname','koname','32','','<%= koname %>');
        createTextBox('koemail','koemail','koemail','64','','<%= koemail %>');
        createTextBox('kophone','kophone','kophone','16','','<%= kophone %>');
        createTextBox('kopager','kopager','kopager','16','','<%= kopager %>');
        createTextBox('kocompany','kocompany','kocompany','16','','<%= koco %>');
        
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_device');
        createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_device','cancelForm()');
     	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
     	createGetForm('lookupEmail','lookupEmailForm','lookupEmailForm','ibm-column-form','#');
     	updateBuilding('<%= building %>');
     	changeInputTagStyle("300px");
     	changeSelectStyle('300px');
     	changeCommentStyle('justification','300px');
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(dojo.byId('DeviceCopyForm'), 'onsubmit', function(event) {
		 	lookupEmail(event);
		 });
		 dojo.connect(dojo.byId('DeviceForm'), 'onsubmit', function(event) {
		 	editDevice(event);
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
						<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1020"><%= messages.getString("device_modify_request") %></a></li>
						<% if (!searchName.equals("")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1025&<%=PrinterConstants.SEARCH_NAME %>=<%= searchName %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } else if (referer.equals("1023")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1023&geo=<%= geo %>&country=<%= country %>&city=<%= city %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } else if (referer.equals("1022")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1022&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } else if (referer.equals("1021")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1021&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } %>
					</ul>
					<h1><%= messages.getString("device_change_req") %></h1>
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
				<div class="pClass">
					<label for='devicename'><%= messages.getString("device_name") %>:</label>
					<span><%= devicename %></span>
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
					<label for='model'><%= messages.getString("device_model") %>:</label>
					<span><%= model %></span>
				</div>
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
					<label for='datastreams'><%= messages.getString("device_datastreams") %>:</label>
					<span class="ibm-input-group"><div id='datastreams'></div></span>
				</div>
				<div class="pClass">
					<label for='Duplex'><%= messages.getString("device_duplex") %>:</label>
					<span><div id='Duplex'></div></span>
				</div>
				<div class="pClass">
					<label for='numtrays'><%= messages.getString("device_num_trays") %>:</label>
					<span><div id='numtrays'></div></span>
				</div>
				<div class="pClass">
					<label for='serialnum'><%= messages.getString("device_serial_number") %>:</label>
					<span><div id='serialnum'></div></span>
				</div>
				<div class="pClass">
					<label for='macaddr'><%= messages.getString("mac_address") %>:</label>
					<span><div id='macaddr'></div></span>
				</div>
				<div class="pClass">
					<label for='iphostname'><%= messages.getString("ip_hostname") %>:</label>
					<span><%= iphostname %></span>
				</div>
				<div class="pClass">
					<label for='ipdomain'><%= messages.getString("ip_domain") %>:</label>
					<span><div id='ipdomain'></div></span>
				</div>
				<div class="pClass">
					<label for='ipaddress'><%= messages.getString("ip_address") %>:</label>
					<span><div id='ipaddress'></div></span>
				</div>
				<div class="pClass">
					<label for='ipgateway'><%= messages.getString("ip_gateway") %>:</label>
					<span><div id='ipgateway'></div></span>
				</div>
				<div class="pClass">
					<label for='ipsubnet'><%= messages.getString("ip_subnet") %>:</label>
					<span><div id='ipsubnet'></div></span>
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