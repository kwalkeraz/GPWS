<%@page import="tools.print.lib.*" %>
<%
    TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	TableQueryBhvr CPApprovalView  = (TableQueryBhvr) request.getAttribute("CPApproval");
	TableQueryBhvrResultSet CPApprovalView_RS = CPApprovalView.getResults();
	AppTools tool = new AppTools();
	
	String referer = request.getParameter("referer");
	if (referer == null) referer = "";
	CPApprovalView_RS.next();
	int cpapprovalid = CPApprovalView_RS.getInt("CPAPPROVALID");
	String reqnum = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_NUM"));
	String action = tool.nullStringConverter(CPApprovalView_RS.getString("ACTION"));
	String reqname = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_NAME"));
	String reqemail = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_EMAIL"));
	String reqtie = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_PHONE"));
	String reqdate = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_DATE"));
	String reqjust = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_JUSTIFICATION"));
	String geo = tool.nullStringConverter(CPApprovalView_RS.getString("GEO"));
	String country = tool.nullStringConverter(CPApprovalView_RS.getString("COUNTRY"));
	String state = tool.nullStringConverter(CPApprovalView_RS.getString("STATE"));
	String city = tool.nullStringConverter(CPApprovalView_RS.getString("CITY"));
	String building = tool.nullStringConverter(CPApprovalView_RS.getString("BUILDING"));
	String floor = tool.nullStringConverter(CPApprovalView_RS.getString("FLOOR"));
	String room = tool.nullStringConverter(CPApprovalView_RS.getString("ROOM"));
	String devicename = tool.nullStringConverter(CPApprovalView_RS.getString("DEVICE_NAME"));
	String reqstatus = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_STATUS"));
	String scheddate = tool.nullStringConverter(CPApprovalView_RS.getString("SCHED_DATE"));
	String completedate = tool.nullStringConverter(CPApprovalView_RS.getString("COMPLETE_DATE"));
	String appdate = tool.nullStringConverter(CPApprovalView_RS.getString("REQ_DATE"));
	String appcomments = tool.nullStringConverter(CPApprovalView_RS.getString("COMMENTS"));
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
	 
	 function editControl(event) {
	 	var formName = dijit.byId("DeviceForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var justification = dijit.byId('appcomments').get('value').replace(/(\r\n|[\r\n])/g, " ").trim();
        dijit.byId('appcomments').set('value',justification);
        var building = getSelectValue('building');
        var floor = getSelectValue('floor');
        var logactionid = dojo.byId('logaction');
        var logaction = "CPApproval control information for request " + "<%= reqnum %>" + " has been updated";
        logactionid.value = logaction;
        formValid = formName.validate();
        if (justification.length > 255) {
			alert("<%= messages.getStringArgs("limit_comment_field_size", new String[] {"255"}) %> " + justfication.length);
			dijit.byId('appcomments').focus();
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
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1605','<%= BehaviorConstants.TOPAGE %>');
        createHiddenInput('logactionid','logaction','');
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
 		createTextInput('room','room','room','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','<%= room %>');
        createTextArea('appcomments', 'appcomments', '', '<%= appcomments %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_device');
        createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_device','cancelForm()');
     	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
     	var scheddate = document.getElementsByName('scheddate')[0];
		var completedate = document.getElementsByName('completedate')[0];
		scheddate.value = formatDatey4M2d2("<%= scheddate %>");
		completedate.value = formatDatey4M2d2("<%= completedate %>");
     	updateBuilding('<%= building %>');
     	changeInputTagStyle("300px");
     	changeSelectStyle('300px');
     	changeCommentStyle('appcomments','300px');
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(dojo.byId('DeviceForm'), 'onsubmit', function(event) {
		 	editControl(event);
		 });
		 dijit.byId('actiontype').focus();
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