<%@page import="tools.print.lib.*" %>
<%
    TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	TableQueryBhvr CPApprovalTemp  = (TableQueryBhvr) request.getAttribute("CPApprovalTemp");
	TableQueryBhvrResultSet CPApprovalTemp_RS = CPApprovalTemp.getResults();
	TableQueryBhvr CPApprovalView  = (TableQueryBhvr) request.getAttribute("CPApproval");
	TableQueryBhvrResultSet CPApprovalView_RS = CPApprovalView.getResults();
	//TableQueryBhvr LocationView  = (TableQueryBhvr) request.getAttribute("LocationView");
    //TableQueryBhvrResultSet LocationView_RS = LocationView.getResults();
    //TableQueryBhvr ConnectType  = (TableQueryBhvr) request.getAttribute("ConnectType");
    //TableQueryBhvrResultSet ConnectType_RS = ConnectType.getResults();
    TableQueryBhvr RoomAccess  = (TableQueryBhvr) request.getAttribute("RoomAccess");
    TableQueryBhvrResultSet RoomAccess_RS = RoomAccess.getResults();
    AppTools tool = new AppTools();
	
	String referer = request.getParameter("referer");
	if (referer == null) referer = "";
	CPApprovalView_RS.next();
	int cpapprovalid = CPApprovalView_RS.getInt("CPAPPROVALID");
	String reqnum = CPApprovalView_RS.getString("REQ_NUM");
	String action = CPApprovalView_RS.getString("ACTION");
	//String reqser = CPApprovalView_RS.getString("REQ_SERIAL");
	String reqname = CPApprovalView_RS.getString("REQ_NAME");
	String reqemail = CPApprovalView_RS.getString("REQ_EMAIL");
	String reqtie = CPApprovalView_RS.getString("REQ_PHONE");
	String reqdate = CPApprovalView_RS.getString("REQ_DATE");
	String reqjust = CPApprovalView_RS.getString("REQ_JUSTIFICATION");
	String geo = CPApprovalView_RS.getString("GEO");
	String country = CPApprovalView_RS.getString("COUNTRY");
	String state = CPApprovalView_RS.getString("STATE");
	String city = CPApprovalView_RS.getString("CITY");
	String building = CPApprovalView_RS.getString("BUILDING");
	String floor = CPApprovalView_RS.getString("FLOOR");
	String room = CPApprovalView_RS.getString("ROOM");
	String devicename = CPApprovalView_RS.getString("DEVICE_NAME");
	String reqstatus = CPApprovalView_RS.getString("REQ_STATUS");
	String scheddate = CPApprovalView_RS.getString("SCHED_DATE");
	String completedate = CPApprovalView_RS.getString("COMPLETE_DATE");
	//String endtoend = CPApprovalView_RS.getString("E2E_CATEGORY");
	String appdate = CPApprovalView_RS.getString("REQ_DATE");
	String appcomments = CPApprovalView_RS.getString("COMMENTS");
	if(reqnum == null) { reqnum = ""; }
	if(action == null) { action = ""; }
	//if(reqser == null) { reqser = ""; }
	if(reqname == null) { reqname = ""; }
	if(reqemail == null) { reqemail = ""; }
	if(reqtie == null) { reqtie = ""; }
	if(reqdate == null) { reqdate = ""; }
	if(reqjust == null) { reqjust = ""; }
	if(geo == null) { geo = ""; }
	if(country == null) { country = ""; }
	if(state == null) { state = ""; }
	if(city == null) { city = ""; }
	if(building == null) { building = ""; }
	if(floor == null) { floor = ""; }
	if(room == null) { room = ""; }
	if(devicename == null) { devicename = ""; }
	if(reqstatus == null) { reqstatus = ""; }
	if(scheddate == null) { scheddate = ""; }
	if(completedate == null) { completedate = ""; }
	//if(endtoend == null) { endtoend = ""; }
	if(appdate == null) { appdate = ""; }
	if(appcomments == null) { appcomments = ""; }
	
	int cpapprovaltempid = 0;
	String duplex = "";
	String numtrays = "";
	String serialnumber = "";
	String macaddress = "";
	String roomaccess = "";
	String roomphone = "";
	String landrop = "";
	String connecttype = "";
	String billdept = "";
	String billdiv = "";
	String billdetail = "";
	String billemail = "";
	String billname = "";
	String ipdomain = "";
	String ipsubnet = "";
	String ipgateway = "";
	boolean cs = false;
	boolean vm = false;
	boolean mvs = false;
	boolean sap = false;
	boolean wts = false;
	boolean ps = false;
	boolean pcl = false;
	boolean ascii = false;
	boolean ipds = false;
	boolean ppds = false;
	
	//Keyop info
	String KONAME = ""; 
	String KOTIE = ""; 
	String KOADD = ""; 
	String KOPAGE = ""; 
	String KOCO = ""; 
	
	while (CPApprovalTemp_RS.next()) {
		cpapprovaltempid = CPApprovalTemp_RS.getInt("CPAPPROVAL_TEMPID");
		duplex = tool.nullStringConverter(CPApprovalTemp_RS.getString("DUPLEX"));
		numtrays = tool.nullStringConverter(CPApprovalTemp_RS.getString("NUMBER_TRAYS"));
		serialnumber = tool.nullStringConverter(CPApprovalTemp_RS.getString("SERIAL_NUMBER"));
		macaddress = tool.nullStringConverter(CPApprovalTemp_RS.getString("MAC_ADDRESS"));
		roomaccess = tool.nullStringConverter(CPApprovalTemp_RS.getString("ROOM_ACCESS"));
		roomphone = tool.nullStringConverter(CPApprovalTemp_RS.getString("ROOM_PHONE"));
		landrop = tool.nullStringConverter(CPApprovalTemp_RS.getString("LAN_DROP"));
		connecttype = tool.nullStringConverter(CPApprovalTemp_RS.getString("CONNECT_TYPE"));
		billdept = tool.nullStringConverter(CPApprovalTemp_RS.getString("BILL_DEPT"));
		billdiv = tool.nullStringConverter(CPApprovalTemp_RS.getString("BILL_DIV"));
		billdetail = tool.nullStringConverter(CPApprovalTemp_RS.getString("BILL_DETAIL"));
		billemail = tool.nullStringConverter(CPApprovalTemp_RS.getString("BILL_EMAIL"));
		billname = tool.nullStringConverter(CPApprovalTemp_RS.getString("BILL_NAME"));
		KONAME = tool.nullStringConverter(CPApprovalTemp_RS.getString("KO_NAME")); 
		KOTIE = tool.nullStringConverter(CPApprovalTemp_RS.getString("KO_PHONE")); 
		KOADD = tool.nullStringConverter(CPApprovalTemp_RS.getString("KO_EMAIL")); 
		KOPAGE = tool.nullStringConverter(CPApprovalTemp_RS.getString("KO_PAGER")); 
		KOCO = tool.nullStringConverter(CPApprovalTemp_RS.getString("KO_COMPANY")); 
		ipdomain = tool.nullStringConverter(CPApprovalTemp_RS.getString("IP_DOMAIN"));
		ipsubnet = tool.nullStringConverter(CPApprovalTemp_RS.getString("IP_SUBNET"));
		ipgateway = tool.nullStringConverter(CPApprovalTemp_RS.getString("IP_GATEWAY"));
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("CS")).equals("Y"))cs = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("VM")).equals("Y"))vm = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("MVS")).equals("Y"))mvs = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("SAP")).equals("Y"))sap = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("WTS")).equals("Y"))wts = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("PS")).equals("Y")) ps = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("PCL")).equals("Y")) pcl = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("ASCII")).equals("Y")) ascii = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("IPDS")).equals("Y")) ipds = true;
		if(tool.nullStringConverter(CPApprovalTemp_RS.getString("PPDS")).equals("Y")) ppds = true;
	} //while
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device edit control page"/>
	<meta name="Description" content="Global print website request control edit page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_modify_control_info") %></title>
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
	 	history.go(-1);
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function updateBuilding(selectedValue) {
		resetMenu('floor');
	 	resetMenu('building');
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
	 
	 function editControl(event) {
	 	var formName = getWidgetID("DeviceForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var justification = getWidgetIDValue('appcomments').replace(/(\r\n|[\r\n])/g, " ").trim();
        setWidgetIDValue('appcomments', justification);
        var status = getSelectValue('status');
        var building = getSelectValue('building');
        var floor = getSelectValue('floor');
        var logactionid = getID('logaction');
        var logaction = "CPApproval control information for request " + "<%= reqnum %>" + " has been updated";
        logactionid.value = logaction;
        formValid = formName.validate();
        if (status == "None" || status == "") {
			showReqMsg('<%= messages.getString("please_select_value") %>','status');
			return false;
		}
        if (justification.length > 255) {
			alert("<%= messages.getStringArgs("limit_comment_field_size", new String[] {"255"}) %> " + justfication.length);
			getWidgetID('appcomments').focus();
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
			var scheddate = document.getElementsByName('scheddate')[0];
			var completedate = document.getElementsByName('completedate')[0];
			scheddate.value = formatDated2M2y4(scheddate.value);
			completedate.value = formatDated2M2y4(completedate.value);
			formName.submit();
		} else {
			return false;
		}
	 } //addControl
	  
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'building': updateFloor('<%= floor %>'); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function addActionType(){
	 	var dID = "actiontype";
	 	<%
   		while(CategoryView_RS.next()) {
   			String categoryname = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_NAME"));
			String categoryvalue1 = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_VALUE1")); 
			if (categoryname.equals("CPApprovalAction")) {
		%>
				var optionName = "<%= categoryvalue1 %>";
   				addOption(dID,optionName,optionName);
   		<%  } //if
   		} %>
	 } //addActionType
	 
	 function addStatus(){
	 	var dID = "status";
	 	<%
	 	CategoryView_RS.first();
   		while(CategoryView_RS.next()) {
   			String categoryname = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_NAME"));
			String categoryvalue1 = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_VALUE1")); 
			if (categoryname.equals("CPApprovalReqStatus")) {
		%>
				var optionName = "<%= categoryvalue1 %>";
   				addOption(dID,optionName,optionName);
   		<%  } //if
   		} %>
	 } //addStatus
	 
	 function addRoomAccess() {
	 	<%
			if (RoomAccess_RS.getResultSetSize() > 0 ) {
				while(RoomAccess_RS.next()) { %>
					addOption('roomaccess',"<%= tool.nullStringConverter(RoomAccess_RS.getString("CATEGORY_VALUE1")) %>","<%= tool.nullStringConverter(RoomAccess_RS.getString("CATEGORY_VALUE1")) %>");
		<%		}
			}
		%>
	 } //addRoomAccess
	 
	 function addEnablements(){
	 	createCheckBox('cs','Y','<%= messages.getString("cs") %>',<%= cs %>,'enablements');
	 	createCheckBox('vm','Y','<%= messages.getString("vm") %>',<%= vm %>,'enablements');
	 	createCheckBox('mvs','Y','<%= messages.getString("mvs") %>',<%= mvs %>,'enablements');
	 	createCheckBox('sap','Y','<%= messages.getString("sap") %>',<%= sap %>,'enablements');
	 	createCheckBox('wts','Y','<%= messages.getString("wts") %>',<%= wts %>,'enablements');
	 } //addEnablements
	 
	 function addDataStreams(){
	 	createCheckBox('ps','Y','<%= messages.getString("ps") %>',<%= ps %>,'datastreams');
	 	createCheckBox('pcl','Y','<%= messages.getString("pcl") %>',<%= pcl %>,'datastreams');
	 	createCheckBox('ascii','Y','<%= messages.getString("ascii") %>',<%= ascii %>,'datastreams');
	 	createCheckBox('ipds','Y','<%= messages.getString("ipds") %>',<%= ipds %>,'datastreams');
	 	createCheckBox('ppds','Y','<%= messages.getString("ppds") %>',<%= ppds %>,'datastreams');
	 } //addDataStreams
	 
	 function addDuplex() {
	 	addOption('duplex','Yes','Y');
	 	addOption('duplex','No','N');
	 } //addDuplex
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1606','<%= BehaviorConstants.TOPAGE %>');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cpapprovaltempid','<%= cpapprovaltempid %>');
        createHiddenInput('logactionid','cpapprovalid','<%= cpapprovalid %>');
        createHiddenInput('logactionid','reqnum','<%= reqnum %>');
        createHiddenInput('logactionid','geo','<%= geo %>');
        createHiddenInput('logactionid','country','<%= country %>');
        createHiddenInput('logactionid','state','<%= state %>');
        createHiddenInput('logactionid','city','<%= city %>');
        createpTag();
        createSelect('actiontype', 'actiontype', '<%= messages.getString("please_select_value") %>... ', 'None', 'actiontype');
        addActionType();
        autoSelectValue('actiontype','<%= action %>');
        createTextInput('devicename','devicename','devicename','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9 _,.-]*$','<%= devicename %>');
        createSelect('status', 'status', '<%= messages.getString("please_select_value") %>... ', 'None', 'status');
        addStatus();
        autoSelectValue('status','<%= reqstatus %>');
        createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');
 		createTextInput('room','room','room','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','[^+*\\^`~\'\"\\{\\}\\[\\]!@#%\\\\&\\$|\\<\\>;=,?]*$','<%= room %>');
        createTextArea('appcomments', 'appcomments', '', '<%= appcomments %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_device');
        createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_device','cancelForm()');
     	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
     	var scheddate = document.getElementsByName('scheddate')[0];
		var completedate = document.getElementsByName('completedate')[0];
		scheddate.value = formatDatey4M2d2("<%= scheddate %>");
		completedate.value = formatDatey4M2d2("<%= completedate %>");
		
		createTextBox('roomphone','roomphone','roomphone','64','','<%= roomphone %>');
		createSelect('roomaccess', 'roomaccess', '<%= messages.getString("device_select_roomaccess") %> ...', 'None', 'roomaccess');
        addRoomAccess();
        autoSelectValue('roomaccess','<%= roomaccess %>');
        createTextBox('landrop','landrop','landrop','32','','<%= landrop %>');
        createTextArea('justification', 'justification', '', '');
        addEnablements();
        addDataStreams();
        createTextBox('reqsystems','reqsystems','reqsystems','64','','');
        createSelect('duplex', 'duplex', '<%= messages.getString("device_select_yes") %> ...', 'None', 'duplex');
        addDuplex();
        autoSelectValue('duplex','<%= duplex %>');
        createTextBox('numtrays','numtrays','numtrays','16','','<%= numtrays %>');
        createTextInput('serialnum','serialnum','serialnum','32',false,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','.+','<%= serialnumber %>');
        createTextBox('macaddr','macaddr','macaddr','32','','<%= macaddress %>');
        createTextInput('ipdomain','ipdomain','ipdomain','64',false,null,'required','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9 _.-]*$','<%= ipdomain %>');
        createTextInput('ipgateway','ipgateway','ipgateway','16',false,null,'required','<%= messages.getString("field_problems") %>','^[0-9.]*$','<%= ipgateway %>');
        createTextInput('ipsubnet','ipsubnet','ipsubnet','16',false,null,'required','<%= messages.getString("field_problems") %>','^[0-9.]*$','<%= ipsubnet %>');
        createTextBox('billdiv','billdiv','billdiv','16','','<%= billdiv %>');
        createTextBox('billdept','billdept','billdept','16','','<%= billdept %>');
        createTextBox('billdetail','billdetail','billdetail','16','','<%= billdetail %>');
        createTextBox('billemail','billemail','billemail','64','','<%= billemail %>');
        createTextBox('billname','billname','billname','64','','<%= billname %>');
        createTextBox('koname','koname','koname','32','','<%= KONAME %>');
        createTextBox('koemail','koemail','koemail','64','','<%= KOADD %>');
        createTextBox('kophone','kophone','kophone','16','','<%= KOTIE %>');
        createTextBox('kopager','kopager','kopager','16','','<%= KOPAGE %>');
        createTextBox('kocompany','kocompany','kocompany','16','','<%= KOCO %>');
		
     	updateBuilding('<%= building %>');
     	changeInputTagStyle("300px");
     	changeSelectStyle('300px');
     	changeCommentStyle('appcomments','300px');
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('DeviceForm'), 'onsubmit', function(event) {
		 	editControl(event);
		 });
		 getWidgetID('actiontype').focus();
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
					<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
					<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1105&devicename=<%= devicename %>&cpapprovalid=<%= cpapprovalid %>&referer=<%= referer %>&reqnum=<%= reqnum %>"><%= messages.getStringArgs("cp_manage_device", new String[] {action.toLowerCase(), devicename}) %></a></li>
				</ul>
				<h1><%= messages.getString("cp_modify_control_info") %></h1>
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
				<%= messages.getString("required_info") %>. 
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='Device'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("request_control") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='reqnum'><%= messages.getString("device_request_number") %>:</label>
					<span><%= reqnum %></span>
				</div>
				<div class="pClass">
					<label for='actiontype'><%= messages.getString("action_type") %>:<span class='ibm-required'>*</span></label>
					<span><div id='actiontype'></div></span>
				</div>
				<div class="pClass">
					<label for='devicename'><%= messages.getString("device_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='devicename'></div></span>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:<span class='ibm-required'>*</span></label>
					<span><div id='status'></div></span>
				</div>
				<p>
					<label for="scheddate"><%= messages.getString("scheduled_completion_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="scheddate" id="scheddate" value="" /> (dd/mm/yyyy)</span>
				</p>
				<p>
					<label for="completedate"><%= messages.getString("completion_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="completedate" id="completedate" value="" /> (dd/mm/yyyy)</span>
				</p>
				<div class="pClass">
					<label for='appcomments'><%= messages.getString("comments") %>:</label>
					<span><div id='appcomments'></div></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_misc_info") %></h2>
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
					<label for='serialnum'><%= messages.getString("device_serial_number") %>:</label>
					<span><div id='serialnum'></div></span>
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
				<div class="pClass">
					<label for='landrop'><%= messages.getString("lan_drop") %> <%= messages.getString("walljack") %>:</label>
					<span><div id='landrop'></div></span>
				</div>
				<div class="pClass">
					<label for='macaddr'><%= messages.getString("mac_address") %>:</label>
					<span><div id='macaddr'></div></span>
				</div>
				<div class="pClass">
					<label for='ipdomain'><%= messages.getString("ip_domain") %>:</label>
					<span><div id='ipdomain'></div></span>
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
					<label for='functions'><%= messages.getString("device_enablements") %>:</label>
					<span class="ibm-input-group"><div id='enablements'></div></span>
				</div>
				<div class="pClass">
					<label for='datastreams'><%= messages.getString("device_datastreams") %>:</label>
					<span class="ibm-input-group"><div id='datastreams'></div></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_location_info") %></h2>
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
					<em>
						<h2 class="ibm-rule"><%= messages.getString("requester_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='requestername'><%= messages.getString("requester_name") %>:</label>
					<span><%= reqname %></span>
				</div>
				<div class="pClass">
					<label for='requestername'><%= messages.getString("email") %>:</label>
					<span><%= reqemail %></span>
				</div>
				<div class="pClass">
					<label for='phone'><%= messages.getString("phone") %>:</label>
					<span><%= reqtie %></span>
				</div>
				<div class="pClass">
					<label for="datereq"><%= messages.getString("requested_complete_date") %>: </label> 
				 	<%= reqdate %>
				</div>
				<div class="pClass">
					<label for='justification'><%= messages.getString("justification_comments") %>:</label>
					<span><%= reqjust %></span>
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