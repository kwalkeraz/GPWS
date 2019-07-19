<%@page import="tools.print.lib.*, tools.print.commonprocess.*" %>
<%
    TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	TableQueryBhvr NotifyList  = (TableQueryBhvr) request.getAttribute("NotifyList");
	TableQueryBhvrResultSet NotifyList_RS = NotifyList.getResults();
	TableQueryBhvr CPApproval  = (TableQueryBhvr) request.getAttribute("CPApproval");
	TableQueryBhvrResultSet CPApproval_RS = CPApproval.getResults();
	AppTools tool = new AppTools();
	UpdateRoutingSteps stepInfo = new UpdateRoutingSteps();
	int nStep = stepInfo.nextStep(request);
	//check to see if there are any steps in progress, true if there are
	boolean inProgress = false; inProgress = stepInfo.stepInProgress(request); 
	String selectedStatus = "";
	 
	String start_date = "";
	java.util.Calendar cal = java.util.Calendar.getInstance();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
	start_date = sdf.format(cal.getTime());

	//String cpapprovalid = request.getParameter("cpapprovalid");
	int cpapprovalid = 0;
	String referer = request.getParameter("referer");
	int cproutingid = 0;
	String reqnum = "";
	String step = "";
	String actiontype = "";
	String status = "";
	String assignee = "";
	String schedflow = "";
	String startdate = "";
	String completedate = "";
	String devicename = "";
	String action = "";
	
	while (CPApproval_RS.next()) {
		cpapprovalid = CPApproval_RS.getInt("CPAPPROVALID");
		reqnum = CPApproval_RS.getString("REQ_NUM");
		devicename = CPApproval_RS.getString("DEVICE_NAME");
		action = CPApproval_RS.getString("ACTION");
		status = CPApproval_RS.getString("REQ_STATUS");
	}
	if (inProgress) { 
		selectedStatus = "NEW";
	} else {
		selectedStatus = "IN PROGRESS";
	} 
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print routing add page"/>
	<meta name="Description" content="Global Print website CPRouting add page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_add_routing_info") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
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
	 
	 function cancelForm(){
	 	history.go(-1);
	 } //cancelForm
	 
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'status': if ("<%= selectedStatus %>" == "NEW" || "<%= selectedStatus %>" == "IN PROGRESS") dijit.byId('status').set('readOnly',true); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function addActionType(){
	 	var dID = "actiontype";
	 	<%
   		while(CategoryView_RS.next()) {
   			String categoryname = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_NAME"));
			String categoryvalue1 = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_VALUE1")); 
			if (categoryname.equals("CPRoutingActionType")) {
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
			if (categoryname.equals("CPRoutingStatus")) {
		%>
				var optionName = "<%= categoryvalue1 %>";
   				addOption(dID,optionName,optionName);
   		<%  } //if
   		} %>
	 } //addStatus
	 
	 function addAssignee(){
	 	var dID = "assignee";
	 	<%
   		while(NotifyList_RS.next()) {
   			String AssigneeName = tool.nullStringConverter(NotifyList_RS.getString("CATEGORY_CODE"));
			String NotifyValue = tool.nullStringConverter(NotifyList_RS.getString("CATEGORY_VALUE1")); 
		%>
				var optionName = "<%= AssigneeName %>";
   				addOption(dID,optionName,optionName);
   		<% } %>
	 } //addAssignee
	 
	 function addRoutingStep(event) {
	 	var formName = getWidgetID("CPRoutingForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var step =  getWidgetIDValue('step');
        var reqnum = "<%= reqnum %>";
        var commentField = getWidgetID('comments');
        var appcomments = commentField.get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        commentField.set('value',appcomments);
        var actiontype = getSelectValue('actiontype');
        var status = getSelectValue('status');
        var assignee = getSelectValue('assignee');
        var logactionid = getID('logaction');
        var logaction = "Routing step " + step + " for request " + reqnum + " has been added";
        logactionid.value = logaction;
        formValid = formName.validate();
   		if (formValid) {
			if (actiontype == "None") {
				showReqMsg('<%= messages.getString("please_enter_all_required_fields") %>','actiontype');
				return false;
			} else if (status == "None") {
				showReqMsg('<%= messages.getString("please_enter_all_required_fields") %>','status');
				return false;
			} else if (assignee == "None") {
				showReqMsg('<%= messages.getString("please_enter_all_required_fields") %>','assignee');
				return false;
			} else {
				var startdate = document.getElementsByName('startdate')[0];
				startdate.value = formatDated2M2y4(startdate.value);
				formName.submit();
			}
		} else {
			return false;
		}
	}; //addCategory
	
	function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '7405');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cproutingid','<%= cproutingid %>');
        createHiddenInput('logactionid','cpapprovalid','<%= cpapprovalid %>');
        createHiddenInput('logactionid','reqnum','<%= reqnum %>');
        createHiddenInput('logactionid','reqstatus','PENDING');
        createpTag();
        createTextInput('step','step','step','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9]*$','<%= nStep %>');
        createSelect('actiontype', 'actiontype', '<%= messages.getString("please_select_value") %>... ', 'None', 'actiontype');
        addActionType();
        createSelect('status', 'status', '<%= messages.getString("please_select_value") %>... ', 'None', 'status');
        addStatus();
        autoSelectValue('status','<%= selectedStatus %>');
        createSelect('assignee', 'assignee', '<%= messages.getString("please_select_assignee") %>... ', 'None', 'assignee');
        addAssignee();
        createTextInput('schedflow','schedflow','schedflow','32',false,null,'required','<%= messages.getString("field_problems") %>','^[0-9]*$','');
        createTextArea('comments', 'comments', '', '');
		createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_step');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_step','cancelForm()');
     	createPostForm('CPRouting','CPRoutingForm','CPRoutingForm','ibm-column-form','<%= commonprocess %>');
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
     	changeCommentStyle("comments", "250px");
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('CPRoutingForm'),'onsubmit',function(event){
     		addRoutingStep(event);
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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1105&devicename=<%= devicename %>&cpapprovalid=<%= cpapprovalid %>&referer=<%= referer %>&reqnum=<%= reqnum %>"><%= messages.getStringArgs("cp_manage_device", new String[] {action.toLowerCase(), devicename}) %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>"><%= messages.getString("cp_admin_routing_info") %></a></li>
			</ul>
			<h1><%= messages.getString("cp_add_routing_info") %></h1>
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
				<%= messages.getString("required_info") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='CPRouting'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='reqnum'><%= messages.getString("device_request_number") %>:</label>
					<%= reqnum %>
				</div>
				<div class="pClass">
					<label for='step'><%= messages.getString("step") %>:<span class='ibm-required'>*</span></label>
					<span><div id='step'></div></span>
				</div>
				<div class="pClass">
					<label for='actiontype'><%= messages.getString("action_type") %>:<span class='ibm-required'>*</span></label>
					<span><div id='actiontype'></div></span>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:<span class='ibm-required'>*</span></label>
					<span><div id='status'></div></span>
				</div>
				<div class="pClass">
					<label for='assignee'><%= messages.getString("assignee") %>:<span class='ibm-required'>*</span></label>
					<span><div id='assignee'></div></span>
				</div>
				<div class="pClass">
					<label for='schedflow'><%= messages.getString("schedule_flow") %>:</label>
					<span><div id='schedflow'></div></span>
				</div>
				<p>
					<label for="startdate"><%= messages.getString("start_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="startdate" id="startdate" value="" /> (dd/mm/yyyy)</span>
				</p>
				<div class="pClass">
					<label for='comments'><%= messages.getString("comments") %>:</label>
					<span><div id='comments'></div></span>
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
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>