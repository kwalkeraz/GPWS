<%@ page import="tools.print.lib.DateTime"%> 
<% TableQueryBhvr ftpSites = (TableQueryBhvr) request.getAttribute("ftpSites");
   TableQueryBhvrResultSet ftpSites_RS = ftpSites.getResults();
   TableQueryBhvr DeviceType = (TableQueryBhvr) request.getAttribute("DeviceType");
   TableQueryBhvrResultSet DeviceType_RS = DeviceType.getResults();
   TableQueryBhvr DeviceStatus = (TableQueryBhvr) request.getAttribute("DeviceStatus");
   TableQueryBhvrResultSet DeviceStatus_RS = DeviceStatus.getResults();
   TableQueryBhvr DeviceE2E = (TableQueryBhvr) request.getAttribute("DeviceE2ECategory");
   TableQueryBhvrResultSet DeviceE2E_RS = DeviceE2E.getResults();
   TableQueryBhvr SDCView = (TableQueryBhvr) request.getAttribute("SDC");
   TableQueryBhvrResultSet SDCView_RS = SDCView.getResults();
   TableQueryBhvr PrinterDefConfigView = (TableQueryBhvr) request.getAttribute("PrinterDefConfigView");
   TableQueryBhvrResultSet PrinterDefConfigView_RS = PrinterDefConfigView.getResults();
   TableQueryBhvr PrinterDefView = (TableQueryBhvr) request.getAttribute("PrinterDefView");
   TableQueryBhvrResultSet PrinterDefView_RS = PrinterDefView.getResults();
   TableQueryBhvr SeparatorPage = (TableQueryBhvr) request.getAttribute("SeparatorPageView");
   TableQueryBhvrResultSet SeparatorPage_RS = SeparatorPage.getResults();
   TableQueryBhvr ConnectTypeView = (TableQueryBhvr) request.getAttribute("ConnectionTypeView");
   TableQueryBhvrResultSet ConnectTypeView_RS = ConnectTypeView.getResults();
   TableQueryBhvr RoomAccess = (TableQueryBhvr) request.getAttribute("RoomAccess");
   TableQueryBhvrResultSet RoomAccess_RS = RoomAccess.getResults();
   TableQueryBhvr VendorView  = (TableQueryBhvr) request.getAttribute("VendorView");
   TableQueryBhvrResultSet VendorView_RS = VendorView.getResults();
   TableQueryBhvr DeviceDisplayLang  = (TableQueryBhvr) request.getAttribute("DeviceDisplayLang");
   TableQueryBhvrResultSet DeviceDisplayLang_RS = DeviceDisplayLang.getResults();
   TableQueryBhvr DisplayLang  = (TableQueryBhvr) request.getAttribute("DisplayLang");
   TableQueryBhvrResultSet DisplayLang_RS = DisplayLang.getResults();
   PrinterTools tool = new PrinterTools();
    String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    //Load URL parameters:
    String geoURL = tool.nullStringConverter(request.getParameter("geo"));
	String countryURL = tool.nullStringConverter(request.getParameter("country"));
	String cityURL = tool.nullStringConverter(request.getParameter("city"));
	String buildingURL = tool.nullStringConverter(request.getParameter("building"));
	String floorURL = tool.nullStringConverter(request.getParameter("floor"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	String topageid = tool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
	String searchName = tool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	//Load initial java variables
	String geo = "";
	String country = "";
	String city = "";
	String building = "";
	String floor = "";
	String room = "";
	// device information
	int deviceid = 0;
	String devicename = "";
	String status = "";
	String roomaccess ="";
	String roomphone ="";
	String landrop ="";
	String connecttype ="";
	String e2ecategory ="";
	String cs ="";
	boolean csB = false;
	String vm ="";
	boolean vmB = false;
	String mvs ="";
	boolean mvsB = false;
	String sap ="";
	boolean sapB = false;
	String wts ="";
	boolean wtsB = false;
	String restrict = "";
	String lpname ="";
	String port ="";
	String separatorpage ="";
	String requestnumber ="";
	String igsasset ="";
	String igsdevice ="";
	String igskeyop ="";
	String duplex ="";
	String numtrays ="";
	String bodytray = "";
	String headertray = "";
	String serialnum = "";
	String macaddress = "";
	String comment = "";
	String dipp = "";
	String koname = "";
	String kophone = "";
	String koemail = "";
	//String kocompany = "";
	int kocompany = 0;
	String kopager = "";
	String faxnumber = "";
	String billdept = "";
	String billdiv = "";
	String billdetail = "";
	String billemail = "";
	String billname = "";
	String ipdomain = "";
	String ipsubnet ="";
	String ipgateway = "";
	String iphostname = "";
	String ipaddress = "";
	String poolname = "";
	String ipm = "";
	String psname = "";
	String afp = "";
	String ps = "";
	boolean psB = false;
	String pcl = "";
	boolean pclB = false;
	String ascii = "";
	boolean asciiB = false;
	String ipds = "";
	boolean ipdsB = false;
	String ppds ="";
	boolean ppdsB = false;
	String webvisible = "";
	String installable = "";
	String sdc = "";
	String createdby = "";
	String lastmodifiedby = "";
	String creationmethod = "";
	DateTime dateTime = new DateTime();
	Timestamp createdate = dateTime.getSQLTimestamp();
	Timestamp lastmodified = dateTime.getSQLTimestamp();
	String installdate = "";
	String deletedate = "";
	String model = "";
	String ftp = "";
	String printerdeftype = "";
	String clientdeftype = "";
	String driverset = "";
	String comm = "";
	String spooler = "";
	String supervisor = "";
	String commspoolsuper = "";
	int commspoolsuperid = 0;
	int serverid = 0;
	int printerdeftypeid = 0;
	int modelid = 0;
	int ftpid = 0;
	int driversetid = 0;
	String server = "";
	boolean notfound = false;
	DateTime dateT = new DateTime();
	TableQueryBhvr DeviceFunctions = (TableQueryBhvr) request.getAttribute("DeviceFunctions");
   	TableQueryBhvrResultSet DeviceFunctions_RS = DeviceFunctions.getResults();
   	TableQueryBhvr DeviceQuery = null;
	TableQueryBhvrResultSet DeviceQuery_RS = null;
	DeviceQuery = (TableQueryBhvr) request.getAttribute("DeviceView");
	DeviceQuery_RS = DeviceQuery.getResults();
 	if (DeviceQuery_RS.getResultSetSize() > 0 ) {
		DeviceQuery_RS.next();
		deviceid = DeviceQuery_RS.getInt("DEVICEID");
		geo = DeviceQuery_RS.getString("GEO");
		country = DeviceQuery_RS.getString("COUNTRY");
		city = DeviceQuery_RS.getString("CITY");
		building = DeviceQuery_RS.getString("BUILDING_NAME");
		floor = DeviceQuery_RS.getString("FLOOR_NAME");
		room = DeviceQuery_RS.getString("ROOM");
		devicename = DeviceQuery_RS.getString("DEVICE_NAME");
		lpname =  tool.nullStringConverter(DeviceQuery_RS.getString("LPNAME"));
		status = tool.nullStringConverter(DeviceQuery_RS.getString("STATUS"));
		roomaccess = tool.nullStringConverter(DeviceQuery_RS.getString("ROOM_ACCESS"));
		roomphone = tool.nullStringConverter(DeviceQuery_RS.getString("ROOM_PHONE"));
		landrop = tool.nullStringConverter(DeviceQuery_RS.getString("LAN_DROP"));
		connecttype = tool.nullStringConverter(DeviceQuery_RS.getString("CONNECT_TYPE"));
		e2ecategory = tool.nullStringConverter(DeviceQuery_RS.getString("E2E_CATEGORY"));
		cs = tool.nullStringConverter(DeviceQuery_RS.getString("CS"));
		vm = tool.nullStringConverter(DeviceQuery_RS.getString("VM"));
		mvs = tool.nullStringConverter(DeviceQuery_RS.getString("MVS"));
		sap = tool.nullStringConverter(DeviceQuery_RS.getString("SAP"));
		wts = tool.nullStringConverter(DeviceQuery_RS.getString("WTS"));
		port = tool.nullStringConverter(DeviceQuery_RS.getString("PORT"));
		//lpname =DeviceCopy_RS.getString("LPNAME");
		//port =DeviceCopy_RS.getString("PORT");
		restrict = DeviceQuery_RS.getString("RESTRICT");
		restrict = tool.nullStringConverter(restrict);
		restrict = tool.DecryptString(restrict);
		separatorpage = tool.nullStringConverter(DeviceQuery_RS.getString("SEPARATOR_PAGE"));
		requestnumber = tool.nullStringConverter(DeviceQuery_RS.getString("REQUEST_NUMBER"));
		igsasset = tool.nullStringConverter(DeviceQuery_RS.getString("IGS_ASSET"));
		igsdevice = tool.nullStringConverter(DeviceQuery_RS.getString("IGS_DEVICE"));
		igskeyop = tool.nullStringConverter(DeviceQuery_RS.getString("IGS_KEYOP"));
		duplex = tool.nullStringConverter(DeviceQuery_RS.getString("DUPLEX"));
		numtrays = tool.nullStringConverter(DeviceQuery_RS.getString("NUMBER_TRAYS"));
		bodytray = tool.nullStringConverter(DeviceQuery_RS.getString("BODY_TRAY"));
		headertray = tool.nullStringConverter(DeviceQuery_RS.getString("HEADER_TRAY"));
		serialnum = tool.nullStringConverter(DeviceQuery_RS.getString("SERIAL_NUMBER"));
		macaddress = tool.nullStringConverter(DeviceQuery_RS.getString("MAC_ADDRESS"));
		comment = tool.nullStringConverter(DeviceQuery_RS.getString("COMMENT"));
		comment = comment.replaceAll("\\n","  ");
		comment = comment.replaceAll("\\r","  ");
		dipp = tool.nullStringConverter(DeviceQuery_RS.getString("DIPP"));
		koname = tool.nullStringConverter(DeviceQuery_RS.getString("KO_NAME"));
		kophone = tool.nullStringConverter(DeviceQuery_RS.getString("KO_PHONE"));
		koemail = tool.nullStringConverter(DeviceQuery_RS.getString("KO_EMAIL"));
		//kocompany = tool.nullStringConverter(DeviceQuery_RS.getString("KO_COMPANY"));
		kocompany = DeviceQuery_RS.getInt("KO_COMPANYID");
		kopager = tool.nullStringConverter(DeviceQuery_RS.getString("KO_PAGER"));
		faxnumber = tool.nullStringConverter(DeviceQuery_RS.getString("FAX_NUMBER"));
		billdept = tool.nullStringConverter(DeviceQuery_RS.getString("BILL_DEPT"));
		billdiv = tool.nullStringConverter(DeviceQuery_RS.getString("BILL_DIV"));
		billdetail = tool.nullStringConverter(DeviceQuery_RS.getString("BILL_DETAIL"));
		billemail = tool.nullStringConverter(DeviceQuery_RS.getString("BILL_EMAIL"));
		billname = tool.nullStringConverter(DeviceQuery_RS.getString("BILL_NAME"));
		ipdomain = tool.nullStringConverter(DeviceQuery_RS.getString("IP_DOMAIN"));
		ipsubnet = tool.nullStringConverter(DeviceQuery_RS.getString("IP_SUBNET"));
		ipgateway = tool.nullStringConverter(DeviceQuery_RS.getString("IP_GATEWAY"));
		iphostname = tool.nullStringConverter(DeviceQuery_RS.getString("IP_HOSTNAME"));
		ipaddress = tool.nullStringConverter(DeviceQuery_RS.getString("IP_ADDRESS"));
		poolname = tool.nullStringConverter(DeviceQuery_RS.getString("POOL_NAME"));
		ipm = tool.nullStringConverter(DeviceQuery_RS.getString("IPM_QUEUE_NAME"));
		psname = tool.nullStringConverter(DeviceQuery_RS.getString("PS_DEST_NAME"));
		afp = tool.nullStringConverter(DeviceQuery_RS.getString("AFP_DEST_NAME"));
		ps = tool.nullStringConverter(DeviceQuery_RS.getString("PS"));
		pcl = tool.nullStringConverter(DeviceQuery_RS.getString("PCL"));
		ascii = tool.nullStringConverter(DeviceQuery_RS.getString("ASCII"));
		ipds = tool.nullStringConverter(DeviceQuery_RS.getString("IPDS"));
		ppds = tool.nullStringConverter(DeviceQuery_RS.getString("PPDS"));
		webvisible = tool.nullStringConverter(DeviceQuery_RS.getString("WEB_VISIBLE"));
		installable = tool.nullStringConverter(DeviceQuery_RS.getString("INSTALLABLE"));
		sdc = tool.nullStringConverter(DeviceQuery_RS.getString("SERVER_SDC"));
		installdate = tool.nullStringConverter(DeviceQuery_RS.getString("INSTALL_DATE"));
		deletedate = tool.nullStringConverter(DeviceQuery_RS.getString("DELETE_DATE"));
		modelid = DeviceQuery_RS.getInt("MODELID");
		ftp = tool.nullStringConverter(DeviceQuery_RS.getString("FTP_SITE"));
		ftpid = DeviceQuery_RS.getInt("FTPID");
		printerdeftype = tool.nullStringConverter(DeviceQuery_RS.getString("SERVER_DEF_TYPE"));
		printerdeftypeid = DeviceQuery_RS.getInt("PRINTER_DEF_TYPEID");
		clientdeftype = tool.nullStringConverter(DeviceQuery_RS.getString("CLIENT_DEF_TYPE"));
		driverset = tool.nullStringConverter(DeviceQuery_RS.getString("DRIVER_SET_NAME"));
		driversetid = DeviceQuery_RS.getInt("DRIVER_SETID");
		comm = tool.nullStringConverter(DeviceQuery_RS.getString("COMM"));
		spooler = tool.nullStringConverter(DeviceQuery_RS.getString("SPOOLER"));
		supervisor = tool.nullStringConverter(DeviceQuery_RS.getString("SUPERVISOR"));
		commspoolsuper = comm + ":" + spooler + ":" + supervisor;
		commspoolsuperid = DeviceQuery_RS.getInt("COMM_SPOOL_SUPERID");
		server = tool.nullStringConverter(DeviceQuery_RS.getString("SERVER_NAME"));
		serverid = DeviceQuery_RS.getInt("SERVERID");
		createdby = tool.nullStringConverter(DeviceQuery_RS.getString("CREATED_BY"));
		creationmethod = tool.nullStringConverter(DeviceQuery_RS.getString("CREATION_METHOD"));
		lastmodifiedby = tool.nullStringConverter(DeviceQuery_RS.getString("MODIFIED_BY"));
		createdate = DeviceQuery_RS.getTimeStamp("CREATION_DATE");
		lastmodified = DeviceQuery_RS.getTimeStamp("MODIFIED_DATE");

		//} 
		if (cs.equals("Y")) csB = true;
		if (vm.equals("Y")) vmB = true;
		if (mvs.equals("Y")) mvsB = true;
		if (sap.equals("Y")) sapB = true;
		if (wts.equals("Y")) wtsB = true;
		if (ps.equals("Y")) psB = true;
		if (pcl.equals("Y")) pclB = true;
		if (ascii.equals("Y")) asciiB = true;
		if (ipds.equals("Y")) ipdsB = true;
		if (ppds.equals("Y")) ppdsB = true;
		
	} else { //Resultset is greater than zero
		notfound = true;
	}
	//done
	String search = tool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	
	int maxLang = Integer.parseInt(tools.print.lib.CategoryTools.getCategoryValue1("DeviceDisplayLanguages", "DEFAULT"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device edit"/>
	<meta name="Description" content="Global print website edit device information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_edit_page") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/updateGeographyInfo.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/formatDate.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.MultiSelect");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.DateTextBox");
	 
	 //Global variables
	 var portRequired = false;
	 var serverRequired = false;
	 var ipRequired = false;
	 var processRequired = false;
	 var sdcRequired = false;
	 var hostnameRequired = false;
	 
	 function cancelForm(){
	 	var url = "";
	 	<% if (!search.equals("")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=282&<%=PrinterConstants.SEARCH_NAME %>="+"<%= search %>";
		<% } else if (referer.equals("432")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>";
		<% } else if (referer.equals("431")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>";
		<% } else if (referer.equals("430")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>";
		<% } %>
	 	document.location.href = url;
	 } //cancelForm
	 
	 function resetForm(){
	 	var formName = getWidgetID('DeviceForm');
	 	formName.reset();
	 	updateGeo('<%= geo %>');
	 	updateCountry('<%= country %>');
	 	updateCity('<%= city %>');
	 	updateBuilding('<%= building %>');
	 	updateFloor('<%= floor %>');
	 	autoSelectValue('roomaccess','<%= roomaccess %>');
		autoSelectValue('devicemodel','<%= modelid %>');
		autoSelectValue('status','<%= status %>');
		autoSelectValue('webvisible','<%= webvisible %>');
		autoSelectValue('installable','<%= installable %>');
		autoSelectValue('dipp','<%= dipp %>');
		autoSelectValue('separatorpage','<%= separatorpage %>');
		autoSelectValue('driverset','<%= driverset %>');
		autoSelectValue('printerdeftype','<%= printerdeftypeid %>');
		autoSelectValue('sdc','<%= sdc %>');
		autoSelectValue('ftpsite','<%= ftpid %>');
		autoSelectValue('duplex','<%= duplex %>');
		autoSelectValue('connecttype','<%= connecttype %>');
		autoSelectValue('igsasset','<%= igsasset %>');
		autoSelectValue('igsdevice','<%= igsdevice %>');
		autoSelectValue('igskeyop','<%= igskeyop %>');
		autoSelectValue('end2end','<%= e2ecategory %>');
		autoSelectValue('kocompany','<%= kocompany %>');
	 } //cancelForm
	 
	 function setRequiredFields(requiredFields,requiredValue){
	 	dojo.forEach(requiredFields, function(args){
			getWidgetID(args).set('required',requiredValue);
		});
	 } //setRequiredFields
	 
	 function showRequiredFields(){
	 	var displayValue = "none";
	 	var status = getSelectValue('status').toUpperCase();
		if (status == 'COMPLETED') displayValue = "";
		dojo.query(".isRequired").forEach(function(x){
     		displayFields([x],displayValue);
     	});
	 } //showRequiredFields
	 
	 function validDeviceName() {
		var devicename = getWidgetIDValue('devicename');
		var dipp = getSelectValue('dipp');
		var vpsx = getSelectValuebyName('printerdeftype');
		var char_at = devicename.charAt(5);
		var dipp_index = "x";
		var vpsx_index = "v";
		var copy_index = "c";
		var fax_index = "f";
		var print_index = "l";
		var functionName = "";
		var functionBoolean = false;
		var validName = true;
		console.log("status = " + getSelectValue('status'));
		if (getSelectValue('status') == 'Completed') {
			<%
				DeviceType_RS.first();
				if (DeviceType_RS.getResultSetSize() > 0 ) {
					while(DeviceType_RS.next()) {
			%>
						if(isChecked("<%= DeviceType_RS.getString("CATEGORY_VALUE1") %>"+"type")) {
							functionName = functionName + "<%= DeviceType_RS.getString("CATEGORY_VALUE1") %>";
							functionBoolean = true;
						}
				<% } //while
				} //if > 0 %>
			if (devicename != "" && functionBoolean == true) {
				if (dipp == "Y") {
					if (char_at.toLowerCase() != dipp_index) {
						validName = false;
						alert('<%= messages.getString("device_name_function_no_match") %>');
						return;
					}
				} else if (vpsx.toUpperCase().indexOf("VPSX") >= 0) {
					if (char_at.toLowerCase() != vpsx_index) {
						validName = false;
						alert('<%= messages.getString("device_name_function_no_match") %>');
						return;
					}
				} else if (functionName == "copy" || functionName == "copyfax" || functionName == "copyscan" || functionName == "copyfaxscan") {
					if (char_at.toLowerCase() != copy_index) {
						validName = false;
						alert('<%= messages.getString("device_name_function_no_match") %>');
						return;
					}
				} else if (functionName == "fax" || functionName == "faxscan") {
					if (char_at.toLowerCase() != fax_index) {
						validName = false;
						alert('<%= messages.getString("device_name_function_no_match") %>');
						return;
					}
				} else {
					if (char_at.toLowerCase() != print_index) {
						validName = false;
						alert('<%= messages.getString("device_name_function_no_match") %>');
						return;
					}
				}
			}
		}
		console.log("validName = " + validName);
		return validName;
	 } //validDeviceName
	 
	 function clearMessages(reqID,reqLabel) {
		 dojo.byId(reqID).innerHTML = "";
		 dojo.removeClass(reqLabel,"ibm-error");
	 }
	 
	 function editDevice(event) {
		clearMessages("errorMsg","devicename_label");
	 	var formName = getWidgetID('DeviceForm');
        var formValid = false;
        var deviceName = getWidgetIDValue('devicename');
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var geo = getSelectValue('geo');
        var country = getSelectValue('country');
        var site = getSelectValue('city');
        var building = getSelectValue('building');
        var floor = getSelectValue('floor');
        var devicemodel = getSelectValue('devicemodel');
        var status = getSelectValue('status');
        var webvisible = getSelectValue('webvisible');
        var installable = getSelectValue('installable');
        var dipp = getSelectValue('dipp');
        var driverset = getSelectValue('driverset');
        var printerdeftype = getSelectValue('printerdeftype');
        var sdc = getSelectValue('sdc');
        var server = getSelectValue('server');
        var process = getSelectValue('process');
        var ftpsite = getSelectValue('ftpsite');
        var e2ecategory = getSelectValue('end2end');
        var comments = getWidgetIDValue('comment').replace(/(\r\n|[\r\n])/g, "").trim();
        var igskeyop = getSelectValue('igskeyop');
        var kocompany = getSelectValue('kocompany');
        setWidgetIDValue('comment', comments);
        var logaction = "Device " + deviceName + " has been updated";
        setValue('logaction', logaction);
        formValid = formName.validate();
        var requiredFields = ["room","lpname"];
        if (!validDeviceName()) {
        	return;
        } else if (reqName(deviceName)) {
			getID('errorMsg').innerHTML = "<p><a class='ibm-error-link' href='#'></a><%= messages.getString("device_name_exists") %>&nbsp" + deviceName + "</p>";
			dojo.addClass("devicename_label","ibm-error");
			// Scroll the window so users can see the error message. We have to pick an item above the errorMsg div because the grey w3 banner blocks what you scroll to.
 			getID("ibm-content-main").scrollIntoView();
		} else {
			if (!showSelectMsg("None", geo, '<%= messages.getString("please_select_geo") %>', 'geo')) return;
			if (!showSelectMsg("None", country, '<%= messages.getString("please_select_country") %>', 'country')) return;
			if (!showSelectMsg("None", site, '<%= messages.getString("please_select_site") %>', 'city')) return;
			if (!showSelectMsg("None", building, '<%= messages.getString("please_select_building") %>', 'building')) return;
			if (!showSelectMsg("None", floor, '<%= messages.getString("please_select_floor") %>', 'floor')) return;
			var functionBoolean = false;
			<%
			DeviceType_RS.first();
			if (DeviceType_RS.getResultSetSize() > 0 ) {
				while(DeviceType_RS.next()) {
			%>
					if (isChecked('<%= tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type')) {
						functionBoolean = true;
					}
			<% } //while
			} //if > 0 %>
			if (!functionBoolean) {
				alert('<%= messages.getString("device_select_one_function") %>');
				return;
			}
			if (!showSelectMsg("0", devicemodel, '<%= messages.getString("device_select_model") %>', 'devicemodel')) return;
			if (!showSelectMsg("None", status, '<%= messages.getString("device_select_status") %>', 'status')) return;
			if (status.toUpperCase() == "COMPLETED") {
				setRequiredFields(requiredFields,true);
				if (isChecked('faxtype')) {
					setRequiredFields(["faxnumber"],true);
				}
				if (isChecked('printtype')) {
					if (!showSelectMsg("None", webvisible, '<%= messages.getString("device_select_yes") %>', 'webvisible')) return;
					if (!showSelectMsg("None", installable, '<%= messages.getString("device_select_yes") %>', 'installable')) return;
					if (!checkPassword()) return;
					if (!showSelectMsg("None", dipp, '<%= messages.getString("device_select_yes") %>', 'dipp')) return;
					if (!showSelectMsg("0", driverset, '<%= messages.getString("device_select_driverset") %>', 'driverset')) return;
					if (!showSelectMsg("0", printerdeftype, '<%= messages.getString("device_select_printerdeftype") %>', 'printerdeftype')) return;
					//--
					if (sdcRequired == true) {
						if (!showSelectMsg("None", sdc, '<%= messages.getString("device_select_sdc") %>', 'sdc')) return;
					} //sdc required
					if (serverRequired == true) {
						if (!showSelectMsg("0", server, '<%= messages.getString("server_select") %>', 'server')) return;
					} //server required
					if (portRequired == true) {
						setRequiredFields(["port"],true);
					}  //port required
					if (processRequired == true) {
						if (!showSelectMsg("0", process, '<%= messages.getString("device_select_server_process") %>', 'process')) return;
					} //process required
					if (ipRequired == true || hostnameRequired == true) {
						setRequiredFields(["ipaddress"],true);
						autoSelectValue('dipp','Y');
					} //ip required	
					//--
					if (!showSelectMsg("0", ftpsite, '<%= messages.getString("device_select_ftpsite") %>', 'ftpsite')) return;
				} //if print check
				if (country.toLowerCase() == 'united states' || geo.toLowerCase() == 'europe middle east and africa' || geo.toLowerCase() == 'emea') {
					if (!showSelectMsg("None", e2ecategory, '<%= messages.getString("category_select") %>', 'end2end')) return;
				} //if US
				if (igskeyop == 'Y' || igskeyop == 'y') {
					setRequiredFields(['kocompany'], true);
					if (kocompany == 0) {
						if (!showSelectMsg("0", kocompany, '<%= messages.getString("please_select_option") %>', 'kocompany')) return;
					}
				}
			} //add rest of required fields
			else {
				showRequiredFields("");
				setRequiredFields(requiredFields,false);
			}
			if (formValid){
				var installdate = document.getElementsByName('installdate')[0];
				var deletedate = document.getElementsByName('deletedate')[0];
				installdate.value = formatDated2M2y4(installdate.value);
				deletedate.value = formatDated2M2y4(deletedate.value);
				formName.submit();
			} else {
				return;
			}
		 }
	 }; //editDevice
	 
	 function reqName(wName){
	 	//console.log('wName is ' + wName);
	 	found = false;
	 	var tagName = 'DeviceName';
	 	var dataTag = 'DeviceID';
	 	var deviceid = '';
	 	var currentdeviceid = "<%= deviceid %>";
	 	var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10000&query=device&device=" + wName;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		 		var dt = response.getElementsByTagName(dataTag);
		   		for (var i = 0; i < tn.length; i++) {
		   			try{
			   			var optionName = tn[i].firstChild.data;
			   			deviceid = dt[i].firstChild.data;
			   		} catch (e) {
			   			optionName = "";
			   			deviceid = '';
			   		} //try and catch
		   			//console.log('optionName is ' + optionName);
		   			if (optionName == wName && deviceid != currentdeviceid) {
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
	  
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry('<%= country %>'); break;
			case 'country': (getID('state')) ? updateState() : updateCity('<%= city %>'); break;
			case 'city': updateBuilding('<%= building %>'); break;
			case 'building': updateFloor('<%= floor %>'); break;
			case 'devicemodel': loadDriverSets(); break;
			case 'status': showRequiredFields(); break;
			case 'sdc': loadServers(); break;
			case 'server': loadProcess(); break;
			case 'printtype': showPrinterInfo(); break;
			case 'faxtype': showFaxInfo(); break;
			case 'printerdeftype': loadPrinterDefTypeFields(); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function addRoomAccess() {
	 	<%
			if (RoomAccess_RS.getResultSetSize() > 0 ) {
				while(RoomAccess_RS.next()) { %>
					addOption('roomaccess',"<%= tool.nullStringConverter(RoomAccess_RS.getString("CATEGORY_VALUE1")) %>","<%= tool.nullStringConverter(RoomAccess_RS.getString("CATEGORY_VALUE1")) %>");
		<%		}
			}
		%>
	 } //addRoomAccess
	 
	 function addDeviceFunctions(dID){
	 	<% 
	 		boolean check = false;
	 		DeviceType_RS.first();
	 		while(DeviceType_RS.next()) { 
	 			check = false;
				DeviceFunctions_RS.first();
	 			while (DeviceFunctions_RS.next()) {
					if (tool.nullStringConverter(DeviceFunctions_RS.getString("FUNCTION_NAME")).equals(tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")))) {
						check = true;
						break;
					} //if
				} //while DeviceFunction
	 	%>
				createCheckBox('<%= tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type','<%= tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>', '<%= tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>', <%= check %>, dID);
				if ('<%= tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type' == 'printtype' && <%= check %>) {
					showPrinterInfo();
				} else if ('<%= tool.nullStringConverter(DeviceType_RS.getString("CATEGORY_VALUE1")) %>type' == 'faxtype' && <%= check %>){
					showFaxInfo();
				}
		<%  } //while %>
	 } //addDeviceFunctions
	 
	 function addEnablements(){
	 	createCheckBox('cs','Y','<%= messages.getString("cs") %>',<%= csB %>,'enablements');
	 	createCheckBox('vm','Y','<%= messages.getString("vm") %>',<%= vmB %>,'enablements');
	 	createCheckBox('mvs','Y','<%= messages.getString("mvs") %>',<%= mvsB %>,'enablements');
	 	createCheckBox('sap','Y','<%= messages.getString("sap") %>',<%= sapB %>,'enablements');
	 	createCheckBox('wts','Y','<%= messages.getString("wts") %>',<%= wtsB %>,'enablements');
	 } //addEnablements
	 
	 function addDataStreams(){
	 	createCheckBox('ps','Y','<%= messages.getString("ps") %>',<%= psB %>,'datastreams');
	 	createCheckBox('pcl','Y','<%= messages.getString("pcl") %>',<%= pclB %>,'datastreams');
	 	createCheckBox('ascii','Y','<%= messages.getString("ascii") %>',<%= asciiB %>,'datastreams');
	 	createCheckBox('ipds','Y','<%= messages.getString("ipds") %>',<%= ipdsB %>,'datastreams');
	 	createCheckBox('ppds','Y','<%= messages.getString("ppds") %>',<%= ppdsB %>,'datastreams');
	 } //addEnablements
	 
	 function loadDeviceModels() {
	 	var selectedValue = "<%= modelid %>";
     	var dID = "devicemodel";
	 	resetMenu(dID);
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10005&query=model";
	 	var tagName = "Name";
	 	var dataTag = "Model";
	 	getXMLDatabyId(url,tagName,dataTag,dID,selectedValue);
	 } //loadDeviceModels
	 
	 function addStatus(){
	 	var dID = 'status';
	 <%
	 	while(DeviceStatus_RS.next()) { %>
			addOption(dID,"<%= tool.nullStringConverter(DeviceStatus_RS.getString("CATEGORY_VALUE1")) %>","<%= tool.nullStringConverter(DeviceStatus_RS.getString("CATEGORY_VALUE1")) %>");
	 <%	} //while %>
	 } //addStatus
	 
	 function addWebVisible() {
	 	addOption('webvisible','Yes','Y');
	 	addOption('webvisible','No','N');
	 } //addWebVisible
	 
	 function addInstallable() {
	 	addOption('installable','Yes','Y');
	 	addOption('installable','No','N');
	 } //addInstallable
	 
	 function addDIPP() {
	 	addOption('dipp','Yes','Y');
	 	addOption('dipp','No','N');
	 } //addDIPP
	 
	 function addSeparatorPage(){
	 	var dID = "separatorpage";
	 <%
	 	while(SeparatorPage_RS.next()) { %>
			addOption(dID,"<%= tool.nullStringConverter(SeparatorPage_RS.getString("CATEGORY_VALUE1")) %>","<%= tool.nullStringConverter(SeparatorPage_RS.getString("CATEGORY_VALUE1")) %>");
	 <%	} %>
	 } //addSeparatorPage
	 
	 function loadDriverSets() {
	 	var dID = "driverset";
	 	resetMenu(dID);
	 	var selectMenu = getWidgetID(dID);
	 	var selectedModel = getSelectValue('devicemodel');
	 	if (selectedModel != '0') {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("device_select_driverset") %> ...','0');
	 	} else if (selectedModel == '0') {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("device_select_valid_model") %> ...','0');
	 	}
	 	var selectedValue = "<%= driversetid %>";
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10005&query=model_driverset&modelid=" + selectedModel;
	 	var tagName = "Model-DriverSet";
	 	var dataTag = "DriverSetName";
	 	getXMLDatabyIdSpecific(url,tagName,dataTag,dID,selectedValue);
	 	for (var i = 0; i in getWidgetID(dID).getOptions(); i++) {} // for loop
	 	if (i < 2 && selectedModel != '0') {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("driver_set_not_found") %> ...','0');
	 	}
	 } //loadDriverSets
	 
	 function addPrinterDefTypes(){
	 	var dID = "printerdeftype";
	 <%
	 	while(PrinterDefView_RS.next()) { %>
	 		var serverdef = "<%= tool.nullStringConverter(PrinterDefView_RS.getString("SERVER_DEF_TYPE")) %>";
			var clientdef = "<%= tool.nullStringConverter(PrinterDefView_RS.getString("CLIENT_DEF_TYPE")) %>";
			var printerdefid = "<%= PrinterDefView_RS.getInt("PRINTER_DEF_TYPEID") %>";
			var servclientdef = serverdef+"/"+clientdef;
			addOption(dID,servclientdef,printerdefid);
	<%	} //while %>
	 } //addPrinterDefTypes
	 
	 function changeRequiredValues(fieldArray,requiredValue){
	 	dojo.forEach(fieldArray, function(args){
			getWidgetID(args).set('isRequired',requiredValue);
		});
	 } //changeRequiredValues
	 
	 function selectPrinterDefType(hostportconfig) {
	 	switch (hostportconfig) {
			case "Server/Server Process": 
				var fieldArray = ["sdcinfo","serverinfo","serverprocessinfo"];
				displayFields(fieldArray,"");
				portRequired = false;
				serverRequired = true;
				ipRequired = false;
				processRequired = true;
				sdcRequired = true;
				hostnameRequired = false;
				var fieldArray2 = ["portinfo","ipaddressinfo"];
				displayFields(fieldArray2,"none");
				break;
			case "Server/Port":
				var fieldArray = ["sdcinfo","serverinfo","portinfo"];
				displayFields(fieldArray,"");
				portRequired = true;
				serverRequired = true;
				ipRequired = false;
				processRequired = false;
				sdcRequired = true;
				hostnameRequired = false;
				var fieldArray2 = ["serverprocessinfo","ipaddressinfo"];
				displayFields(fieldArray2,"none");
				break;
			case "Hostname/Port":
				var fieldArray = ["portinfo","ipaddressinfo"];
				displayFields(fieldArray,"");
				portRequired = true;
				serverRequired = false;
				ipRequired = true;
				processRequired = false;
				sdcRequired = false;
				hostnameRequired = true;
				var fieldArray2 = ["sdcinfo","serverinfo","serverprocessinfo"];
				displayFields(fieldArray2,"none");
				autoSelectValue('dipp','Y');
				break;
			case "Server Only":
				var fieldArray = ["sdcinfo","serverinfo"];
				displayFields(fieldArray,"");
				portRequired = false;
				serverRequired = true;
				ipRequired = false;
				processRequired = false;
				sdcRequired = true;
				hostnameRequired = false;
				var fieldArray2 = ["serverprocessinfo","portinfo","ipaddressinfo"];
				displayFields(fieldArray2,"none");
				break;
		} //switch
		return this;
	 } //selectPrinterDefType
	 
	 function loadPrinterDefTypeFields() {
		var selectedpdeftype = getSelectValuebyName('printerdeftype');
		var hostportconfig = "";
		var serverdef = "";
		var clientdef = "";
		var printerdeftype = "";
		var printerdeftypeid = "";
		<%	PrinterDefConfigView_RS.first();
			if (PrinterDefConfigView_RS.getResultSetSize() > 0 ) {
				while(PrinterDefConfigView_RS.next()) {
		%>
					serverdef = "<%= PrinterDefConfigView_RS.getString("SERVER_DEF_TYPE") %>";
					clientdef = "<%= PrinterDefConfigView_RS.getString("CLIENT_DEF_TYPE") %>";
					printerdeftype = serverdef +"/"+ clientdef;
					printerdeftypeid = "<%= PrinterDefConfigView_RS.getInt("PRINTER_DEF_TYPEID") %>";
					hostportconfig= "<%= PrinterDefConfigView_RS.getString("HOST_PORT_CONFIG") %>";
					
					if (printerdeftype == selectedpdeftype) {
						selectPrinterDefType(hostportconfig);
					} else if (selectedpdeftype == "<%= messages.getString("device_select_printerdeftype") %> ...") {
						//hide everything else
						var fieldArray = ["sdcinfo","serverinfo","serverprocessinfo","portinfo","ipaddressinfo"];
						displayFields(fieldArray,"none");
					}
		<% 		}  //while
			} %>
	 }  //loadPrinterDefTypeFields
	 
	 function addSDC(){
	 	<%
   		while(SDCView_RS.next()) { %>
   			addOption('sdc','<%= tool.nullStringConverter(SDCView_RS.getString("CATEGORY_VALUE1")) %>','<%= tool.nullStringConverter(SDCView_RS.getString("CATEGORY_VALUE1")) %>');
   		<% } %>
	 } //addSDC
	 
	 function loadServers() {
	 	var dID = "server";
	 	resetMenu('process');
	 	resetMenu(dID);
	 	var selectMenu = getWidgetID(dID);
	 	var selectedSDC = getSelectValue('sdc');
	 	if (selectedSDC == 'None') {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("device_select_sdc_first") %> ...','0');
	 	} else {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("server_select") %> ...','0');
	 	}
	 	var selectedValue = "<%= serverid %>";
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10010&query=server&sdc=" + selectedSDC;
	 	var tagName = "Name";
	 	var dataTag = "Server";
	 	getXMLDatabyId(url,tagName,dataTag,dID,selectedValue,true);
	 } //loadServers
	 
	 function loadProcess() {
	 	var dID = "process";
	 	resetMenu(dID);
	 	var selectMenu = getWidgetID(dID);
	 	var selectedServer = getSelectValue('server');
	 	if (selectedServer == '0') {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("device_select_server_first") %> ...','0');
	 	} else {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("device_select_server_process") %> ...','0');
	 	}
	 	var selectedValue = "<%= commspoolsuperid %>";
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10010&query=process&serverid=" + selectedServer;
	 	var tagName = "Process";
	 	var dataTag = "Comm_Spooler_Supervisor";
	 	getXMLDatabyId(url,tagName,dataTag,dID,selectedValue,true);
	 	for (var i = 0; i in getWidgetID(dID).getOptions(); i++) {} // for loop
	 	if (i < 2 && selectedServer != '0') {
	 		selectMenu.removeOption('0');
	 		addOption(dID,'<%= messages.getString("server_process_not_found") %> ...','0');
	 	}
	 } //loadProcess
	 
	 function addDownloadRepo(){
	 <% while (ftpSites_RS.next()) {%>
			addOption('ftpsite',"<%= tool.nullStringConverter(ftpSites_RS.getString("FTP_SITE")) %>","<%= ftpSites_RS.getInt("FTPID") %>");
   	 <% } %>
	 } //addDownloadRepo
	 
	 function addDuplex() {
	 	addOption('duplex','Yes','Y');
	 	addOption('duplex','No','N');
	 } //addInstallable
	 
	 function addConnectType(){
	 <% while (ConnectTypeView_RS.next()) { %>
			addOption('connecttype',"<%= tool.nullStringConverter(ConnectTypeView_RS.getString("CATEGORY_VALUE1")) %>","<%= tool.nullStringConverter(ConnectTypeView_RS.getString("CATEGORY_VALUE1")) %>");
   	 <% } %>
	 } //addConnectType
	 
	 function addIGSAsset() {
	 	addOption('igsasset','Yes','Y');
	 	addOption('igsasset','No','N');
	 } //addIGSAsset
	 
	 function addIGSDevice() {
	 	addOption('igsdevice','Yes','Y');
	 	addOption('igsdevice','No','N');
	 } //addIGSAsset
	 
	 function addIGSKeyop() {
	 	addOption('igskeyop','Yes','Y');
	 	addOption('igskeyop','No','N');
	 } //addIGSkeyop
	 
	 function addEnd2End(){
	 <% while (DeviceE2E_RS.next()) { %>
			addOption('end2end','<%= tool.nullStringConverter(DeviceE2E_RS.getString("CATEGORY_VALUE1")) %>','<%= tool.nullStringConverter(DeviceE2E_RS.getString("CATEGORY_VALUE2")) %>');
   	 <% } %>
	 } //addConnectType
	 
	 function addKOCompany(){
 	<%  while(VendorView_RS.next()) { %>
 			addOption('kocompany','<%= VendorView_RS.getString("VENDOR_NAME")%>','<%= VendorView_RS.getInt("VENDORID")%>');
	<% } //while VendorView	%>
	 } //loadVendorValues
	 
	 function addDeviceLanguages() {
		 var devLang = document.getElementById("displaylang");
		 var selectDevLangs = dijit.byId('devdislangE');
		 var selectLangs = dijit.byId('dislangE');
		 selectLangs.removeOption(selectLangs.getOptions());
		 <% String sDevLangs = "<ol>";
		    while(DeviceDisplayLang_RS.next()) {
		    	String sLangCode = DeviceDisplayLang_RS.getString("LANG_CODE");
			    String sLang = CategoryTools.getCategoryValue1("DeviceLanguages",sLangCode);
 		    	sDevLangs += "<li>" + sLang + " (" + sLangCode + ")</li>"; %>
 		    	addMultiOption(selectDevLangs, "<%= sLang %> (<%= sLangCode %>)", "<%= sLangCode %>");
		 <% } //while DeviceDisplayLang
 		 	sDevLangs += "</ol>";%> 
		 devLang.innerHTML = "<%= sDevLangs %>";
	 }
	 
	 function editDevLang() {
		 getID("msgEditLang").innerHTML = "";
		 var select = document.getElementById("devdislangE");
		 for (var x = 0; x < select.options.length; x++) {
			 select.options[x].selected = false;
		 }
		 ibmweb.overlay.show('editLangOverlay', this);
// 		 var devLang = document.getElementById("displaylang");
	 }
	 
	 function loadDevLangs() {
		 var selectLangs = dijit.byId('dislangE');
		 <% while(DisplayLang_RS.next()) { %>
		    	addOption(selectLangs, "<%= DisplayLang_RS.getString("CATEGORY_VALUE1") %> (<%= DisplayLang_RS.getString("CATEGORY_CODE") %>)", "<%= DisplayLang_RS.getString("CATEGORY_CODE") %>");
		 <% } //while DeviceDisplayLang %>
	 }
	 
	 function addLang() {
		 getID("msgEditLang").innerHTML = "";
		 var langValue = getSelectValuebyName('dislangE');
		 var langID = getSelectValue('dislangE');
		 var select = document.getElementById("devdislangE");
		 var exist = false;
		 for (var x = 0; x < select.options.length; x++) {
			 if (select.options[x].value == langID) {
				 exist = true;
				 getID("msgEditLang").innerHTML = '<p><a class="ibm-error-link"></a> <%= messages.getString("language_already_assigned") %>';
				 break;
			 } 
		 }
		 if (exist == false) {
			 if (select.options.length < <%= maxLang %>) {
		 		addMultiOption("devdislangE", langValue, langID);
		 	 } else {
			 	getID("msgEditLang").innerHTML = '<p><a class="ibm-error-link"></a> <%= messages.getString("maximum_number_lang_reached") %>';
		 	 }
		 }
	 }
	 
	 function deleteLang() {
		 var value = dijit.byId('devdislangE').getSelected();
		 value.remove();
	 }
	 
	 function moveLangUp() {
		var select = document.getElementById("devdislangE");
		for (var x = 0; x < select.options.length; x++) {
			if (select.options[x].selected) {
				if (x == 0) {
					break;
				} else {
					// Store selected text and values in temporary variables
					var tempText = select.options[x].text;
					var tempValue = select.options[x].value;
					// Updated the selected option to be the previous option
					select.options[x].text = select.options[x-1].text;
					select.options[x].value = select.options[x-1].value;
					// Updated the previous option to be the selected option which is stored in the temp variables
					select.options[x-1].text = tempText;
					select.options[x-1].value = tempValue;
					// Change which option is selected
					select.options[x].selected = false;
					select.options[x-1].selected = true;
					break;
				}
			} 
		}
	 }
	 
	 function moveLangDown() {
		var select = document.getElementById("devdislangE");
		for (var x = 0, len = select.options.length; x < len; x++) {
			if (select.options[x].selected) {
				if (x == len-1) {
					break;
				} else {
					// Store selected text and values in temporary variables
					var tempText = select.options[x].text;
					var tempValue = select.options[x].value;
					// Updated the selected option to be the next option
					select.options[x].text = select.options[x+1].text;
					select.options[x].value = select.options[x+1].value;
					// Updated the next option to be the selected option which is stored in the temp variables
					select.options[x+1].text = tempText;
					select.options[x+1].value = tempValue;
					// Change which option is selected
					select.options[x].selected = false;
					select.options[x+1].selected = true;
					break;
				}
			} 
		}
	 }
	 
	 function submitLangForm() {
		var msg = '<%= messages.getString("dev_dis_lang_successful") %>';
		var select = document.getElementById("devdislangE");
		for (var x = 0; x < select.options.length; x++) {
			select.options[x].selected = true;
		}
		var errorMsg = '<p><a class="ibm-error-link"></a><%= messages.getString("error_during_delete") %>: ';
		var syncValue = true;
		var xhrArgs = {
        	form:  "DeviceLangForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	if (data.indexOf("Error") > -1) {
        			getID("langResponse").innerHTML = errorMsg + ' <%= messages.getString("an_error_occurred") %></p>';
        		} else {
    				reloadLangs();
    				cancelLangForm();
    				getID("langResponse").innerHTML = "<br /><a class='ibm-confirm-link'></a> " + msg;
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	console.log(error);
                getID("langResponse").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
	 }
	 
	 function reloadLangs() {
		var devLang = document.getElementById("displaylang");
		devLang.innerHTML = "";
		var select = document.getElementById("devdislangE");
		var sDevLangs = "<ol>";
		for (var x = 0, len = select.options.length; x < len; x++) {
			sDevLangs += "<li>" + select.options[x].text + "</li>";
		}
		sDevLangs += "</ol>";
		devLang.innerHTML = sDevLangs;
	 }
	 
	 function cancelLangForm() {
		 getID("msgEditLang").innerHTML = "";
		 var pop = 'editLangOverlay';
     	 ibmweb.overlay.hide(pop,this);
     } //closeLoc
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function showDriverSetHelp() {
		var modelid = getSelectValue('devicemodel');
		if (modelid == 0) {
			showReqMsg('<%= messages.getString("device_select_valid_model") %>','devicemodel');
		} else {
			var myurl = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=283_DriverSet&modelid=" + modelid;
			var x = "690";
			var y = "1050";
			onGo(myurl, x, y);
		}
	 } //showDriverSetHelp
	 
	 function showHelp(anchor) {
		onGo('<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=283h#' + anchor, 810, 1070);
	 } //showHelp
	 
	 function showDeviceHistory() {
		var devicename = '<%= devicename %>';
		var myurl = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283dh&device=%25"+devicename+"%25";
		var h = "690";
		var w = "1050";
		onGo(myurl, h, w);
	 } //showDeviceHistory
	 
	 function onGo(link,h,w) {
		var chasm = screen.availWidth;
		var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + ',scrollbars=yes,resizable=yes,status=yes';	
		args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		w = window.open(link,'_blank',args);
		return;
	 }  //onGo
	 
	 function showPrinterInfo() {
	 	var device = isChecked('printtype');
	 	var displayValue = "none";
	 	if (device)	{
	 		displayValue = "";
	 	} else {
	 		var YesNo=confirm("<%= messages.getString("device_print_deselect") %>" + "?");
			if (YesNo) {
				autoSelectValue('installable','None');
				setChecked('cs', false);
				setChecked('vm', false);
				setChecked('mvs', false);
				setChecked('sap', false);
				setChecked('wts', false);
				setWidgetValue('restict','');
				setWidgetValue('lpname', '');
				autoSelectValue('dipp','None');
				autoSelectValue('separatorpage','None');
				autoSelectValue('driverset','0');
				autoSelectValue('printerdeftype','0');
				autoSelectValue('sdc','None');
				autoSelectValue('server','0');
				setWidgetValue('port','');
				autoSelectValue('process','0');
				setChecked('ps', false);
				setChecked('pcl', false);
				setChecked('ascii', false);
				setChecked('ipds', false);
				setChecked('ppds', false);
				setWidgetValue('poolname','');
				setWidgetValue('ipm','');
				setWidgetValue('psname','');
				setWidgetValue('afp','');
				autoSelectValue('ftpsite','0');
				autoSelectValue('duplex','None');
				setWidgetValue('numtrays','');
				setWidgetValue('bodytray','');
				setWidgetValue('headertray','');
				setWidgetValue('macaddress','');
				setWidgetValue('ipdomain','');
				setWidgetValue('iphostname','');
				setWidgetValue('ipaddress','');
				setWidgetValue('ipgateway','');
				setWidgetValue('ipsubnet','');
				setWidgetValue('landrop','');
				autoSelectValue('connecttype','None');
			} //if confirm
	 	}
	 	displayFields(['printerinfo'],displayValue);
	 } //showPrinterInfo
	 
	 function showFaxInfo() {
	 	var device = isChecked('faxtype');
	 	var displayValue = "none";
	 	if (device)	displayValue = "";
	 	displayFields(["faxinfo"],displayValue);
	 } //showFaxInfo
	 
	 function showPass(){
	 	var pass = getInputDijitValue('restrict');
	 	if (pass == "") {
	 		alert('<%= messages.getString("device_no_password_info") %>');
		} else {
			alert('<%= messages.getString("device_password_info") %> ' + pass);
		}
	 } //showPass
	 
	 function checkPassword() {
		var restrict = getWidgetIDValue('restrict');
		if (restrict.length > 0 && restrict.length < 7) {
			alert('<%= messages.getString("device_password_min_chars") %>');
			getWidgetID('restrict').focus();
			return false;
		} else {
			return true;
		}
	 } //checkpassword
	 
	 function redirectPage(topageid){
	 	var deviceid = getHiddenValue('deviceid');
		var devicename = getInputDijitValue('devicename');
		var referer = "";
		<% if (!searchName.equals("")) {%>
			referer = "&referer=<%= topageid %>&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName %>";
		<% } else if (tool.nullStringConverter(request.getParameter("referer")).equals("432")) {%>
			referer = "&referer=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>";
		<% } else if (tool.nullStringConverter(request.getParameter("referer")).equals("431")) {%>
			referer = "&referer=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>";
		<% } else if (tool.nullStringConverter(request.getParameter("referer")).equals("430")) {%>
			referer = "&referer=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>";
		<% } %>
		var params = "&name="+devicename+"&deviceid="+deviceid+referer;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>="+topageid+params;
	 }  //redirectPage
	 
	 function addDeviceNote() {
		redirectPage('7120');
	 } //addDeviceNote
	 
	 function addEnblInfo() {
		redirectPage('7210');
	 } //addEnblInfo
	 
	 function installReport() {
		redirectPage('2800');
	 } //installReport
	 
	 function deviceTroubleshooter() {
		redirectPage('621&device=<%= devicename %>');
	 } //installReport
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '286','<%= BehaviorConstants.TOPAGE %>');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','deviceid','<%= deviceid %>');
        createHiddenInput('logactionid','referer','<%= tool.nullStringConverter(request.getParameter("referer")) %>');
        createHiddenInput('logactionid','<%= PrinterConstants.SEARCH_NAME %>','<%= tool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME)) %>');
		createHiddenInput('logactionid','submitvalue','update');
		createHiddenInput('logactionid','lastmodifiedby','<%= pupb.getUserLoginID() %>');
        createpTag();
        var fieldArray = ["faxinfo","sdcinfo","serverinfo","serverprocessinfo","portinfo","ipaddressinfo","printerinfo"];
		displayFields(fieldArray,"none");
        createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');
        createTextInput('room','room','room','64',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_room_regexp,'<%= room %>');
        createSelect('roomaccess', 'roomaccess', '<%= messages.getString("device_select_roomaccess") %> ...', 'None', 'roomaccess');
        addRoomAccess();
        autoSelectValue('roomaccess','<%= roomaccess %>');
        createTextBox('roomphone','roomphone','roomphone','64','','<%= roomphone %>');
        createTextInput('devicename','devicename','devicename','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_device_regexp,'<%= devicename %>');
        addDeviceFunctions("functions");
        createSelect('devicemodel', 'devicemodel', '<%= messages.getString("device_select_model") %> ...', '0', 'devicemodel');
        loadDeviceModels();
        createTextBox('serialnum','serialnum','serialnum','16','','<%= serialnum %>');
        createSelect('status', 'status', '<%= messages.getString("device_select_status") %> ...', 'None', 'status');
        addStatus();
        autoSelectValue('status','<%= status %>');
        createSelect('webvisible', 'webvisible', '<%= messages.getString("device_select_yes") %> ...', 'None', 'webvisible');
        addWebVisible();
        autoSelectValue('webvisible','<%= webvisible %>');
        createTextArea('comment', 'comment', '', '<%= comment %>');
        createTextInput('faxnumber','faxnumber','faxnumber','32',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_fax_number_regexp,'<%= faxnumber %>');
        createSelect('installable', 'installable', '<%= messages.getString("device_select_yes") %> ...', 'None', 'installable');
        addInstallable();
        autoSelectValue('installable','<%= installable %>');
        addEnablements();
        addDataStreams();
        createPasswordBox('restrict','restrict','restrict','64','','<%= restrict %>');
        createTextInput('lpname','lpname','lpname','64',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_device_regexp,'<%= lpname %>');
        createSelect('dipp', 'dipp', '<%= messages.getString("device_select_yes") %> ...', 'None', 'dipp');
        addDIPP();
        autoSelectValue('dipp','<%= dipp %>');
        createSelect('separatorpage', 'separatorpage', '<%= messages.getString("device_select_seppage") %> ...', 'None', 'separatorpage');
        addSeparatorPage();
        autoSelectValue('separatorpage','<%= separatorpage %>');
        createSelect('driverset', 'driverset', '<%= messages.getString("device_select_valid_model") %> ...', '0', 'driverset');
        createSelect('printerdeftype', 'printerdeftype', '<%= messages.getString("device_select_printerdeftype") %> ...', '0', 'printerdeftype');
        addPrinterDefTypes();
        autoSelectValue('printerdeftype','<%= printerdeftypeid %>');
        createSelect('sdc', 'sdc', '<%= messages.getString("please_select_sdc") %> ...', 'None', 'sdc');
        addSDC();
        autoSelectValue('sdc','<%= sdc %>');
        createSelect('server', 'server', '<%= messages.getString("device_select_sdc_first") %> ...', '0', 'serverloc');
        createSelect('process', 'process', '<%= messages.getString("device_select_server_first") %> ...', '0', 'processloc');
        createTextInput('port','port','port','32',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_port_regexp,'<%= port %>');
        createTextBox('poolname','poolname','poolname','32','','<%= poolname %>');
        createTextBox('ipm','ipm','ipm','32','','<%= ipm %>');
        createTextBox('psname','psname','psname','32','','<%= psname %>');
        createTextBox('afp','afp','afp','32','','<%= afp %>');
        createSelect('ftpsite', 'ftpsite', '<%= messages.getString("device_select_ftpsite") %> ...', '0', 'ftpsite');
        addDownloadRepo();
        autoSelectValue('ftpsite','<%= ftpid %>');
        createSelect('duplex', 'duplex', '<%= messages.getString("device_select_yes") %> ...', 'None', 'duplex');
        addDuplex();
        autoSelectValue('duplex','<%= duplex %>');
        createTextBox('numtrays','numtrays','numtrays','2','','<%= numtrays %>');
        createTextBox('bodytray','bodytray','bodytray','2','','<%= bodytray %>');
        createTextBox('headertray','headertray','headertray','2','','<%= headertray %>');
        createTextInput('macaddress','macaddress','macaddress','24',false,null,'required','<%= messages.getString("field_problems") %>',g_macaddr_regexp,'<%= macaddress %>');
        createTextInput('iphostname','iphostname','iphostname','16',false,null,'required','<%= messages.getString("field_problems") %>',g_iphost_regexp,'<%= iphostname %>');
        createTextInput('ipdomain','ipdomain','ipdomain','64',false,null,'required','<%= messages.getString("field_problems") %>',g_iphost_regexp,'<%= ipdomain %>');
        createTextInput('ipaddress','ipaddress','ipaddress','16',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_ipaddr_regexp,'<%= ipaddress %>');
        createTextInput('ipgateway','ipgateway','ipgateway','16',false,null,'required','<%= messages.getString("field_problems") %>',g_ipaddr_regexp,'<%= ipgateway %>');
        createTextInput('ipsubnet','ipsubnet','ipsubnet','16',false,null,'required','<%= messages.getString("field_problems") %>',g_ipaddr_regexp,'<%= ipsubnet %>');
        createTextInput('landrop','landrop','landrop','16',false,null,'required','<%= messages.getString("field_problems") %>','.+','<%= landrop %>');
        createSelect('connecttype', 'connecttype', '<%= messages.getString("device_select_connecttype") %> ...', 'None', 'connecttype');
        addConnectType();
        autoSelectValue('connecttype','<%= connecttype %>');
        createSelect('igsasset', 'igsasset', '<%= messages.getString("device_select_yes") %> ...', 'None', 'igsasset');
        addIGSAsset();
        autoSelectValue('igsasset','<%= igsasset %>');
        createSelect('igsdevice', 'igsdevice', '<%= messages.getString("device_select_yes") %> ...', 'None', 'igsdevice');
        addIGSDevice();
        autoSelectValue('igsdevice','<%= igsdevice %>');
        createSelect('igskeyop', 'igskeyop', '<%= messages.getString("device_select_yes") %> ...', 'None', 'igskeyop');
        addIGSKeyop();
        autoSelectValue('igskeyop','<%= igskeyop %>');
        createSelect('end2end', 'end2end', '<%= messages.getString("category_select") %> ...', 'None', 'end2end');
        addEnd2End();
        autoSelectValue('end2end','<%= e2ecategory %>');
        createTextBox('billdiv','billdiv','billdiv','16','','<%= billdiv %>');
        createTextBox('billdept','billdept','billdept','16','','<%= billdept %>');
        createTextBox('billdetail','billdetail','billdetail','16','','<%= billdetail %>');
        createTextBox('billemail','billemail','billemail','64','','<%= billemail %>');
        createTextBox('billname','billname','billname','64','','<%= billname %>');
        createTextBox('requestnumber','requestnumber','requestnumber','16','','<%= requestnumber %>');
        createTextBox('koname','koname','koname','32','','<%= koname %>');
        createTextBox('koemail','koemail','koemail','64','','<%= koemail %>');
        createTextBox('kophone','kophone','kophone','16','','<%= kophone %>');
        createTextBox('kopager','kopager','kopager','16','','<%= kopager %>');
		createSelect('kocompany', 'kocompany', '<%= messages.getString("please_select_option") %>', '0', 'kocompanyloc');
		addKOCompany();
		autoSelectValue('kocompany','<%= kocompany %>');
		
		createMultiSelect('devdislangE', 'devdislangEloc','4');
		createSelect('dislangE', 'dislangE', '', 'None', 'dislangEloc');
		addDeviceLanguages();
		loadDevLangs();
		createHiddenInput('topageidLang','<%= BehaviorConstants.TOPAGE %>', '284','<%= BehaviorConstants.TOPAGE %>');
		createHiddenInput('varLoc','logactionLang', '');
		createHiddenInput('varLoc','deviceidLang', '<%= deviceid %>');
		createPostForm('DeviceLang','DeviceLangForm','DeviceLangForm','ibm-column-form','<%= prtgateway %>');
		createInputButton('submit_lang_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_lang_device','submitLangForm()');
        createSpan('submit_lang_button','ibm-sep');
	 	createInputButton('submit_lang_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_lang_device','cancelLangForm()');
		
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_edit_device');
        createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("reset") %>','ibm-btn-cancel-sec','reset_edit_device','resetForm()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_edit_device','cancelForm()');
     	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= prtgateway %>');
     	updateGeo("<%= geo %>");
     	changeInputTagStyle("300px");
     	changeSelectStyle('300px');
     	changeCommentStyle('comment','300px');
     	showRequiredFields();
     	var installdate = document.getElementsByName('installdate')[0];
		var deletedate = document.getElementsByName('deletedate')[0];
		installdate.value = formatDatey4M2d2("<%= installdate %>");
		deletedate.value = formatDatey4M2d2("<%= deletedate %>");
     	<% if (!logaction.equals("")){ %>
        	getID('response').innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        //dijit.byId('category').focus();
        <% if (notfound){ %>
        	getID('notfound').innerHTML = "<p><a class='ibm-error-link'></a>"+"<%= messages.getString("device_no_devices_found") %>"+"<br /></p>";
        <% } %>
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('devicename'), 'onblur', function() {
		 	if (getWidgetIDValue('lpname') == "") setWidgetIDValue('lpname',this.value);
		 });
		 dojo.connect(getID('DeviceForm'), 'onsubmit', function(event) {
		 	if (getWidgetIDValue('lpname') == "") setWidgetIDValue('lpname',getWidgetIDValue('devicename'));
		 	editDevice(event);
		 });
		 if ('<%= faxnumber %>' != ''){
			displayFields(["faxinfo"],'');
		 }
		 if (!isChecked('faxtype')) {
			setRequiredFields(["faxnumber"],false);
		 }
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=281"><%= messages.getString("device_search") %></a></li>
				<% if (!search.equals("")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=282&<%=PrinterConstants.SEARCH_NAME %>=<%= search %>"><%= messages.getString("device_administer") %></a></li>
				<% } else if (request.getParameter("referer").equals("432")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_administer") %></a></li>
				<% } else if (request.getParameter("referer").equals("431")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_administer") %></a></li>
				<% } else if (request.getParameter("referer").equals("430")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_administer") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("device_edit_page") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<div class="ibm-columns">
				<div class="ibm-col-4-3">
		<!-- LEADSPACE_BEGIN -->
			<p>
				<%= messages.getString("required_info") %>
			</p>
			<div class=ibm-columns">
				<div class="ibm-col-6-2">
					<ul>
						<li><a href="javascript:addDeviceNote();"><%= messages.getString("device_note_administer") %></a></li>
						<li><a href="javascript:addEnblInfo();"><%= messages.getString("enbl_admin") %></a></li>
					</ul>
				</div>
				<div class="ibm-col-6-2">
					<ul>
						<li><a href="javascript:installReport();"><%= messages.getString("installation_statistics") %></a></li>
						<li><a href="javascript:deviceTroubleshooter();"><%= messages.getString("troubleshoot_this_device") %></a></li>
					</ul>
				</div>
			</div>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='Device'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_info") %></h2>
					</em>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<%= messages.getString("device_location_info") %>
					</em>
				</div>
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
					<label id="sitelabel" for="site">
						<%= messages.getString("site") %>:<span class='ibm-required'>*</span>
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
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<%= messages.getString("device_info") %>
					</em>
				</div>
				<div class="pClass">
					<label id='devicename_label' for='devicename'><%= messages.getString("device_name") %>:<span class='ibm-required'>*</span></label>
					<span>
						<div id='devicename'></div>
					</span>
				</div>
				<div class="pClass">
					<label for='functions'><%= messages.getString("device_functions") %>:<span class='ibm-required'>*</span></label>
					<span class="ibm-input-group"><div id='functions'></div></span>
				</div>
				<div class="pClass">
					<label for='devicemodel'><%= messages.getString("device_select_model") %>:<span class='ibm-required'>*</span></label>
					<span><div id='devicemodel'></div></span>
				</div>
				<div class="pClass">
					<label for='serialnum'><%= messages.getString("device_serial_number") %>:</label>
					<span><div id='serialnum'></div></span>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("device_status") %>:<span class='ibm-required'>*</span></label>
					<span><div id='status'></div></span>
				</div>
				<div class="pClass">
					<label for='webvisible'><%= messages.getString("device_web_visible") %>:<span class='ibm-required isRequired'>*</span></label>
					<span><div id='webvisible'></div></span>
				</div>
				<div class="pClass">
					<label for='comment'><%= messages.getString("comments") %>:</label>
					<span><div id='comment'></div></span>
				</div>
				<div id="faxinfo">
					<div class="pClass">
						<label for='faxnumber'><%= messages.getString("fax_number") %>:<span class='ibm-required isRequired'>*</span></label>
						<span><div id='faxnumber'></div></span>
					</div>
				</div>
				<div class="pClass">
					<label for='displaylang'><%= messages.getString("device_display_languages_priority") %>:<br /><a href="javascript:editDevLang()"><%= messages.getString("edit") %></a></label>
					<span><div id='displaylang'></div></span>
					<span><div id="langResponse"></div></span>
				</div>
				<div id="printerinfo">
					<div class="pClass">
						<em>
							<h2 class="ibm-rule"><%= messages.getString("device_printer_info") %></h2>
						</em>
					</div>
					<div class="pClass">
						<label for='installable'><%= messages.getString("device_installable") %>:<span class='ibm-required isRequired'>*</span></label>
						<span><div id='installable'></div></span>
					</div>
					<div class="pClass">
						<label for='functions'><%= messages.getString("device_enablements") %>:</label>
						<span class="ibm-input-group"><div id='enablements'></div></span>
					</div>
					<div class="pClass">
						<label for='functions'><%= messages.getString("device_datastreams") %>:</label>
						<span class="ibm-input-group"><div id='datastreams'></div></span>
					</div>
					<div class="pClass">
						<label for='restrict'><span><a class="ibm-popup-link" href="javascript:void(0)" onClick="javascript:showPass();"></a></span><%= messages.getString("device_password") %>:</label>
						<span><div id='restrict'></div></span>
					</div>
					<div class="pClass">
						<label for='lpname'><%= messages.getString("device_lpname") %>:<span class='ibm-required isRequired'>*</span></label>
						<span><div id='lpname'></div></span>
					</div>
					<div class="pClass">
						<label for='dipp'><%= messages.getString("device_dipp") %>:<span class='ibm-required isRequired'>*</span></label>
						<span><div id='dipp'></div></span>
					</div>
					<div class="pClass">
						<label for='separatorpage'><%= messages.getString("device_separator_page") %>:</label>
						<span><div id='separatorpage'></div></span>
					</div>
					<div class="pClass">
						<label for='driverset'><%= messages.getString("driver_set_name") %>:<span class='ibm-required isRequired'>*</span></label>
						<span>
							<div id='driverset'></div>
							<a class="ibm-popup-link" href="javascript:showDriverSetHelp();"><%= messages.getString("help") %></a>
						</span>
					</div>
					<div class="pClass">
						<label for='printerdeftype'><%= messages.getString("printer_def_type") %>:<span class='ibm-required isRequired'>*</span></label>
						<span>
							<div id='printerdeftype'></div>
							<a class="ibm-popup-link" href="javascript:showHelp('prtdeftype');"><%= messages.getString("help") %></a>
						</span>
					</div>
					<div id="sdcinfo">
						<div class="pClass">
							<label for='sdc'><%= messages.getString("sdc") %>:<span class='ibm-required isRequired'>*</span></label>
							<span><div id='sdc'></div></span>
						</div>
					</div>
					<div id="serverinfo">
						<div class="pClass">
							<label for='server'><%= messages.getString("server") %>:<span class='ibm-required isRequired'>*</span></label>
							<span><div id='serverloc'></div></span>
						</div>
					</div>
					<div id="serverprocessinfo">
						<div class="pClass">
							<label for='process'><%= messages.getString("server_process") %>:<span class='ibm-required isRequired'>*</span></label>
							<span><div id='processloc'></div></span>
						</div>
					</div>
					<div id="portinfo">
						<div class="pClass">
							<label for='port'><%= messages.getString("port") %>:<span class='ibm-required isRequired'>*</span></label>
							<span><div id='port'></div></span>
						</div>
					</div>
					<div class="pClass">
						<label for='poolname'><%= messages.getString("device_pool_name") %>:</label>
						<span><div id='poolname'></div></span>
					</div>
					<div class="pClass">
						<label for='ipm'><%= messages.getString("device_ipm_queue_name") %>:</label>
						<span><div id='ipm'></div></span>
					</div>
					<div class="pClass">
						<label for='psname'><%= messages.getString("device_ps_dest_name") %>:</label>
						<span><div id='psname'></div></span>
					</div>
					<div class="pClass">
						<label for='afp'><%= messages.getString("device_afp_dest_name") %>:</label>
						<span><div id='afp'></div></span>
					</div>
					<div class="pClass">
						<label for='ftpsite'><%= messages.getString("device_ftp_site") %>:<span class='ibm-required isRequired'>*</span></label>
						<span><div id='ftpsite'></div></span>
					</div>
					<div class="ibm-alternate-rule"><hr /></div>
					<div class="pClass">
						<em>
							<%= messages.getString("device_misc_info") %>
						</em>
					</div>
					<div class="pClass">
						<label for='duplex'><%= messages.getString("device_duplex") %>:</label>
						<span><div id='duplex'></div></span>
					</div>
					<div class="pClass">
						<label for='numtrays'><%= messages.getString("device_num_trays") %>:</label>
						<span><div id='numtrays'></div></span>
					</div>
					<div class="pClass">
						<label for='bodytray'><%= messages.getString("device_body_tray") %>:</label>
						<span><div id='bodytray'></div></span>
					</div>
					<div class="pClass">
						<label for='headertray'><%= messages.getString("device_header_tray") %>:</label>
						<span><div id='headertray'></div></span>
					</div>
					<div class="ibm-alternate-rule"><hr /></div>
					<div class="pClass">
						<em>
							<%= messages.getString("device_ip_info") %>
						</em>
					</div>
					<div class="pClass">
						<label for='macaddress'><%= messages.getString("device_mac_address") %>:</label>
						<span><div id='macaddress'></div></span>
					</div>
					<div class="pClass">
						<label for='iphostname'><%= messages.getString("ip_hostname") %>:</label>
						<span><div id='iphostname'></div></span>
					</div>
					<div class="pClass">
						<label for='ipdomain'><%= messages.getString("ip_domain") %>:</label>
						<span><div id='ipdomain'></div></span>
					</div>
					<div class="pClass">
						<label for='ipaddress'><%= messages.getString("ip_address") %>:<span id="ipaddressinfo" class='ibm-required'>*</span></label>
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
						<label for='landrop'><%= messages.getString("lan_drop") %>:</label>
						<span><div id='landrop'></div></span>
					</div>
					<div class="pClass">
						<label for='connecttype'><%= messages.getString("device_connect_type") %>:</label>
						<span><div id='connecttype'></div></span>
					</div>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_bill_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='igsasset'><%= messages.getString("device_igs_asset") %>:</label>
					<span><div id='igsasset'></div></span>
				</div>
				<div class="pClass">
					<label for='igsdevice'><%= messages.getString("device_igs_device") %>:</label>
					<span><div id='igsdevice'></div></span>
				</div>
				<div class="pClass">
					<label for='igskeyop'><%= messages.getString("device_igs_keyop") %>:</label>
					<span><div id='igskeyop'></div></span>
				</div>
				<div class="pClass">
					<label for='end2end'><%= messages.getString("device_category") %>: (<%= messages.getString("required_certain_countries") %>)</label>
					<span><div id='end2end'></div></span>
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
				<p>
					<label for="installdate"><%= messages.getString("device_install_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="installdate" id="installdate" value="" /> (dd/mm/yyyy)</span>
				</p>
				<p>
					<label for="deletedate"><%= messages.getString("device_delete_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="deletedate" id="deletedate" value="" /> (dd/mm/yyyy)</span>
				</p>
				<div class="pClass">
					<label for='requestnumber'><%= messages.getString("device_request_number") %>:</label>
					<span><div id='requestnumber'></div></span>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<%= messages.getString("device_keyop_info") %>
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
					<span><div id='kocompanyloc'></div></span>
				</div>
				<!-- End of entries -->
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
		<div class="ibm-col-4-1">
			<!-- ADDITIONAL_INFO_BEGIN -->
				<ul>
					<li><%= messages.getString("device_created_as") %>: <%= creationmethod %></li>
					<li><%= messages.getString("device_created_on") %>: <%= dateT.convertUTCtoTimeZone(createdate) %></li>
					<li><%= messages.getString("device_created_by") %>: <%= createdby %></li>
					<% if (lastmodified != null) { %>
						<li><%= messages.getString("device_last_modified_on") %>: <%= dateT.convertUTCtoTimeZone(lastmodified) %></li>
						<li><%= messages.getString("device_last_modified_by") %>: <%= tool.nullStringConverter(lastmodifiedby) %></li>
					<% } %>	
					<li><a href="javascript:showDeviceHistory();"><%= messages.getString("view_full_device_history") %></a></li>
				</ul>
		</div>
			<!-- ADDITIONAL_INFO_END -->
		</div>
		<!--  Edit device languages overlay starts here -->
			<div id="response">
				<div class="ibm-common-overlay" id="editLangOverlay">
					<div class="ibm-head">
						<p><a class="ibm-common-overlay-close" href="#close">Close [x]</a></p>
					</div>
					<div class="ibm-body">
						<div class="ibm-main">
							<div class="ibm-title ibm-subtitle">
								<h1><%= messages.getString("edit_device_display_languages") %></h1>
							</div>
						<div class="ibm-container ibm-alternate ibm-buttons-last">
							<div class="ibm-container-body">
<%-- 								<p class="ibm-overlay-intro"><%= messages.getString("edit_device_display_languages_desc") %>Add a language by selecting a language from the "Available display languages" drop down and click "Add". Languages are listed by priority, so use the "Move up" and "Move down" links to reorder. Delete a language by clicking "Delete". The maximum number of languages for this device is <%= maxLang %>. <%= messages.getString("required_info") %>.</p> --%>
								<p class="ibm-overlay-intro"><%= messages.getString("edit_device_display_languages_desc") %> <%= maxLang %>.</p>
								<div id="msgEditLang"></div>
									<div id="DeviceLang">
										<div id="topageidLang"></div>
										<div id="varLoc"></div>
										<div class="pClass"><label for="devdislangEloc"><%= messages.getString("device_display_languages") %>:<span class="ibm-required">*</span></label>
											<span><div id="devdislangEloc"></div><a href="javascript:moveLangUp()"><%= messages.getString("move_up") %></a>&nbsp;|&nbsp;<a href="javascript:moveLangDown()"><%= messages.getString("move_down") %></a>&nbsp;|&nbsp;<a href="javascript:deleteLang()"><%= messages.getString("delete") %></a></span>
										</div>
										<p><br /></p>
	 									<div class="pClass"><label for="dislangEloc"><%= messages.getString("avail_display_languages") %>:<span class="ibm-required">*</span></label>
											<span><div id="dislangEloc"></div><a href="javascript:addLang()"><%= messages.getString("add") %></a></span>
										</div>
										<div class="ibm-overlay-rule"><hr /></div>
										<div class="ibm-buttons-row">
											<div id="submit_lang_button" align="right"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
			<!--  Edit device languages overlay ends here -->
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>