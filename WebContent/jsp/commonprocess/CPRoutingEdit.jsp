<%
    TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	TableQueryBhvr CPRoutingView  = (TableQueryBhvr) request.getAttribute("CPRouting");
	TableQueryBhvrResultSet CPRoutingView_RS = CPRoutingView.getResults();
	TableQueryBhvr NotifyList  = (TableQueryBhvr) request.getAttribute("NotifyList");
	TableQueryBhvrResultSet NotifyList_RS = NotifyList.getResults();
	AppTools tool = new AppTools();
	
	String start_date = "";
	String complete_date = "";
	java.util.Calendar cal = java.util.Calendar.getInstance();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
	start_date = sdf.format(cal.getTime());
	complete_date = sdf.format(cal.getTime());

	String referer = tool.nullStringConverter(request.getParameter("referer"));

	CPRoutingView_RS.next();
	int cproutingid = CPRoutingView_RS.getInt("CPROUTINGID");
	String reqnum = tool.nullStringConverter(CPRoutingView_RS.getString("REQ_NUM"));
	int step = CPRoutingView_RS.getInt("STEP");
	String actiontype = tool.nullStringConverter(CPRoutingView_RS.getString("ACTION_TYPE"));
	String status = tool.nullStringConverter(CPRoutingView_RS.getString("STATUS"));
	String assignee = tool.nullStringConverter(CPRoutingView_RS.getString("ASSIGNEE"));
	String schedflow = tool.nullStringConverter(CPRoutingView_RS.getString("SCHED_FLOW"));
	String startdate = tool.nullStringConverter(CPRoutingView_RS.getString("START_DATE"));
	String completedate = tool.nullStringConverter(CPRoutingView_RS.getString("COMPLETED_DATE"));
	String devicename = tool.nullStringConverter(CPRoutingView_RS.getString("DEVICE_NAME"));
	String comments = tool.nullStringConverter(CPRoutingView_RS.getString("ROUTING_COMMENTS"));
	int cpapprovalid = CPRoutingView_RS.getInt("CPAPPROVALID");
	String action = tool.nullStringConverter(CPRoutingView_RS.getString("ACTION"));
	String assigneeteam = tool.nullStringConverter(CPRoutingView_RS.getString("CATEGORY_VALUE1"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print routing edit page"/>
	<meta name="Description" content="Global Print website CPRouting edit page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_edit_routing_info") %></title>
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
	 	return false;
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
	 
	 function editRoutingStep(event) {
	 	var formName = dijit.byId("CPRoutingForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var step = dijit.byId('step').get('value');
        var reqnum = "<%= reqnum %>";
        var commentField = dijit.byId('comments');
        var appcomments = commentField.get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        commentField.set('value',appcomments);
        var actiontype = getSelectValue('actiontype');
        var status = getSelectValue('status');
        var assignee = getSelectValue('assignee');
        var logactionid = dojo.byId('logaction');
        var logaction = "Routing step " + step + " for request " + reqnum + " has been updated";
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
				var completedate = document.getElementsByName('completedate')[0];
				completedate.value = formatDated2M2y4(completedate.value);
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
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '7435');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cproutingid','<%= cproutingid %>');
        createHiddenInput('logactionid','cpapprovalid','<%= cpapprovalid %>');
        createHiddenInput('logactionid','reqnum','<%= reqnum %>');
        createpTag();
        createTextInput('step','step','step','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9]*$','<%= step %>');
        createSelect('actiontype', 'actiontype', '<%= messages.getString("please_select_value") %>... ', 'None', 'actiontype');
        addActionType();
        autoSelectValue('actiontype','<%= actiontype %>');
        createSelect('status', 'status', '<%= messages.getString("please_select_value") %>... ', 'None', 'status');
        addStatus();
        autoSelectValue('status','<%= status %>');
        createSelect('assignee', 'assignee', '<%= messages.getString("please_select_assignee") %>... ', 'None', 'assignee');
        addAssignee();
        autoSelectValue('assignee','<%= assignee %>');
        createTextInput('schedflow','schedflow','schedflow','32',false,null,'required','<%= messages.getString("field_problems") %>','^[0-9]*$','<%= schedflow %>');
        createTextArea('comments', 'comments', '', '<%= comments %>');
		createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_step');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_step','cancelForm()');
     	createPostForm('CPRouting','CPRoutingForm','CPRoutingForm','ibm-column-form','<%= commonprocess %>');
     	var startdate = document.getElementsByName('startdate')[0];
		var completedate = document.getElementsByName('completedate')[0];
		startdate.value = formatDatey4M2d2("<%= startdate %>");
		completedate.value = formatDatey4M2d2("<%= completedate %>");
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
     	dojo.style("comments", {
          "width": "250px"
		});
        dijit.byId('step').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('CPRoutingForm'),'onsubmit',function(event){
     		editRoutingStep(event);
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
			<h1><%= messages.getString("cp_edit_routing_info") %></h1>
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
				<p>
					<label for="completedate"><%= messages.getString("completed_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="completedate" id="completedate" value="" /> (dd/mm/yyyy)</span>
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
<%@ include file="bottominfo.jsp" %>