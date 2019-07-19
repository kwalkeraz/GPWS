<% 
	TableQueryBhvr SDC = (TableQueryBhvr) request.getAttribute("SDC");
	TableQueryBhvrResultSet SDC_RS = SDC.getResults();
	TableQueryBhvr RequestStatus = (TableQueryBhvr) request.getAttribute("RequestStatus");
	TableQueryBhvrResultSet RequestStatus_RS = RequestStatus.getResults();
	TableQueryBhvr StepStatus = (TableQueryBhvr) request.getAttribute("StepStatus");
	TableQueryBhvrResultSet StepStatus_RS = StepStatus.getResults();
	TableQueryBhvr ActionType = (TableQueryBhvr) request.getAttribute("ActionType");
	TableQueryBhvrResultSet ActionType_RS = ActionType.getResults();
	AppTools appTool = new AppTools();
	String showby = appTool.nullStringConverter(request.getParameter("show"));
	if (showby == null) {
		showby = "";
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print work flow page"/>
	<meta name="Description" content="Global Print Website common process workflow page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_workflow_process") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function byReqNum(event){
	 	//alert("here");
	 	var formName = dijit.byId("DeviceReqnumForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var requestnum = dijit.byId('reqnum');
		if (requestnum.get('value').length < 9) {
			alert('<%= messages.getString("cp_enter_valid_request_number") %>');
			requestnum.focus();
			return false;
		} 
		var tempreq = requestnum.get('value');
		var upperReq = tempreq.toUpperCase();
		requestnum.set('value',upperReq);
		formValid = formName.validate();
		if (formValid){
			formName.submit();
		}
	 } //byreqNum
	 
	 function byRequests(event){
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
		var formName = dijit.byId("DeviceRequestForm");
		formName.submit();
	 } //byRequests
	 
	 function bySteps(event){
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
		var formName = dijit.byId("DeviceStepsForm");
		formName.submit();
	 }
	 
	 function showInfo(wName) {
	 	switch (wName) {
			case 'bytype': displayFields(["drinfo"],""); displayFields(["stepinfo","reqinfo"],"none"); break;
			case 'bysteps': displayFields(["stepinfo"],""); displayFields(["drinfo","reqinfo"],"none"); break;
			case 'bynumber': displayFields(["reqinfo"],""); displayFields(["drinfo","stepinfo"],"none"); break;
			default: displayFields(["drinfo","stepinfo","reqinfo"],"none");
		} //switch
	 } //showInfo
	 
	 function addReqStatus(wID) {
	 	dijit.byId(wID).removeOption(dijit.byId(wID).getOptions());
	 	<% while (RequestStatus_RS.next()) { %>
			addOption(wID,'<%= RequestStatus_RS.getString("CATEGORY_VALUE1") %>','<%= RequestStatus_RS.getString("CATEGORY_CODE").toUpperCase() %>');
		<% } %>
	 } //addReqStatus
	 
	 function addStepStatus() {
	 	var wID = 'stepstatus';
	 	dijit.byId(wID).removeOption(dijit.byId(wID).getOptions());
	 	<% while (StepStatus_RS.next()) { %>
			addOption(wID,'<%= StepStatus_RS.getString("CATEGORY_VALUE1") %>','<%= StepStatus_RS.getString("CATEGORY_CODE").toUpperCase() %>');
		<% } %>
	 } //addStepStatus
	 
	 function addActionType(wID) {
	 	<% while (ActionType_RS.next()) { %>
			addOption(wID,'<%= ActionType_RS.getString("CATEGORY_VALUE1") %>','<%= ActionType_RS.getString("CATEGORY_VALUE1").toUpperCase() %>');
		<% } %>
	 } //addActiontype
	 
	 function addOrderBy() {
	 	var wID = 'orderby';
	 	dijit.byId(wID).removeOption(dijit.byId(wID).getOptions());
	 	addOption(wID,'<%= messages.getString("device_request_number") %>','REQ_NUM');
	 	addOption(wID,'<%= messages.getString("device_name") %>','DEVICE_NAME');
	 	addOption(wID,'<%= messages.getString("action_type") %>','ACTION');
	 	addOption(wID,'<%= messages.getString("request_status") %>','REQ_STATUS');
	 	addOption(wID,'<%= messages.getString("date_created") %>','DATE_TIME DESC',true);
	 	addOption(wID,'<%= messages.getString("requester_name") %>','REQ_NAME');
	 	addOption(wID,'<%= messages.getString("geography") %>','GEO');
	 	addOption(wID,'<%= messages.getString("city") %>','CITY');
	 } //addOrderBy
	 
	 function addOrderBySteps() {
	 	var wID = 'orderby_steps';
	 	dijit.byId(wID).removeOption(dijit.byId(wID).getOptions());
	 	addOption(wID,'<%= messages.getString("device_request_number") %>','REQ_NUM');
	 	addOption(wID,'<%= messages.getString("device_name") %>','DEVICE_NAME');
	 	addOption(wID,'<%= messages.getString("action_type") %>','ACTION');
	 	addOption(wID,'<%= messages.getString("request_status") %>','REQ_STATUS');
	 	addOption(wID,'<%= messages.getString("step") %>','STEP');
	 	addOption(wID,'<%= messages.getString("step_action_type") %>','ACTION_TYPE');
	 	addOption(wID,'<%= messages.getString("step_status") %>','STATUS');
	 	addOption(wID,'<%= messages.getString("assignee") %>','ASSIGNEE');
	 	addOption(wID,'<%= messages.getString("geography") %>','GEO');
	 	addOption(wID,'<%= messages.getString("city") %>','CITY');
	 } //addOrderBy
	 
	 dojo.ready(function() {
	 	createpTag();
	 	showInfo('<%= showby %>');
		createHiddenInput('topageidreq','<%= BehaviorConstants.TOPAGE %>', '540','reqid');
		createSelect('reqstatus', 'reqstatus', null, null, 'reqstatus');
		addReqStatus('reqstatus');
		createSelect('actiontype', 'actiontype', 'ALL', '%', 'actiontype');
		addActionType('actiontype');
		createSelect('orderby', 'orderby', null, null, 'orderby');
		addOrderBy();
		createSubmitButton('submit_view_requests','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_view_requests');
        createSpan('submit_view_requests','ibm-sep');
	 	createInputButton('submit_view_requests','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_requests','showInfo()');
     	createGetForm('DeviceRequest','DeviceRequestForm','DeviceRequestForm','ibm-column-form','<%= commonprocess %>');
     	
     	createHiddenInput('topageidsteps','<%= BehaviorConstants.TOPAGE %>', '545','stepsid');
     	createSelect('reqstatus_steps', 'reqstatus_steps', null, null, 'reqstatus_steps');
		addReqStatus('reqstatus_steps');
     	createSelect('stepstatus', 'stepstatus', null, null, 'stepstatus');
		addStepStatus();
		createSelect('actiontype_steps', 'actiontype_steps', 'ALL', '%', 'actiontype_steps');
		addActionType('actiontype_steps');
		createSelect('orderby_steps', 'orderby_steps', null, null, 'orderby_steps');
		addOrderBySteps();
     	createSubmitButton('submit_view_steps','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_view_steps');
        createSpan('submit_view_steps','ibm-sep');
	 	createInputButton('submit_view_steps','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_steps','showInfo()');
     	createGetForm('DeviceSteps','DeviceStepsForm','DeviceStepsForm','ibm-column-form','<%= commonprocess %>');
     	
     	createHiddenInput('topageidreqnum','<%= BehaviorConstants.TOPAGE %>', '549','reqnumid');
     	createTextInput('reqnum','reqnum','reqnum','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9]*$','');
    	createSubmitButton('submit_view_reqnum','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_view_reqnum');
        createSpan('submit_view_reqnum','ibm-sep');
	 	createInputButton('submit_view_reqnum','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_reqnum','showInfo()');
    	createGetForm('DeviceReqnum','DeviceReqnumForm','DeviceReqnumForm','ibm-column-form','<%= commonprocess %>');
    	changeInputTagStyle("300px");
     	changeSelectStyle('300px');
     	autoSelectValue('orderby','DATE_TIME DESC');
     });
     
     dojo.addOnLoad(function() {
     	 dojo.connect(dojo.byId('DeviceRequestForm'), 'onsubmit', function(event) {
		 	byRequests(event);
		 });
		 dojo.connect(dojo.byId('DeviceStepsForm'), 'onsubmit', function(event) {
		 	bySteps(event);
		 });
		 dojo.connect(dojo.byId('DeviceReqnumForm'), 'onsubmit', function(event) {
		 	byReqNum(event);
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
				<%= messages.getString("cp_workflow_process") %>
			</h1>
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
				<%= messages.getString("workflow_process_info") %>
			</p>
			<div class="ibm-alternate-rule"><hr /></div>
			<!-- LEADSPACE_END -->
			<div id='locform'>
				<div id='topageid'></div>
				<p>
					<ul>
						<li><a href="javascript:showInfo('bytype');"><%= messages.getString("cp_view_by_device_requests") %></a></li>
						<div id="drinfo">
							<div id="DeviceRequest">
								<div id='topageidreq'></div>
								<div class="ibm-alternate-rule"><hr /></div>
								<div class="pClass">
									<em>
										<%= messages.getString("cp_view_device_requests") %>
									</em>
								</div>
								<div class="pClass">
									<label for='reqstatus'><%= messages.getString("request_status") %>:</label>
									<span><div id='reqstatus'></div></span>
								</div>
								<div class="pClass">
									<label for='actiontype'><%= messages.getString("request_action") %>:</label>
									<span><div id='actiontype'></div></span>
								</div>
								<div class="pClass">
									<label for='orderby'><%= messages.getString("sort_by") %>:</label>
									<span><div id='orderby'></div></span>
								</div>
								<div class='ibm-buttons-row'>
									<div class="pClass">
										<span>
										<div id='submit_view_requests'></div>
										</span>
									</div>
								</div>	
							</div>		
						</div>
						
						<li><a href="javascript:showInfo('bysteps');"><%= messages.getString("cp_view_by_routing_steps") %></a></li>
						<div id="stepinfo">
							<div id="DeviceSteps">
								<div id='topageidsteps'></div>
								<div class="ibm-alternate-rule"><hr /></div>
								<div class="pClass">
									<em>
										<%= messages.getString("cp_view_routing_steps") %>
									</em>
								</div>
								<div class="pClass">
									<label for='reqstatus_steps'><%= messages.getString("request_status") %>:</label>
									<span><div id='reqstatus_steps'></div></span>
								</div>
								<div class="pClass">
									<label for='stepstatus'><%= messages.getString("step_status") %>:</label>
									<span><div id='stepstatus'></div></span>
								</div>
								<div class="pClass">
									<label for='actiontype_steps'><%= messages.getString("request_action") %>:</label>
									<span><div id='actiontype_steps'></div></span>
								</div>
								<div class="pClass">
									<label for='orderby_steps'><%= messages.getString("sort_by") %>:</label>
									<span><div id='orderby_steps'></div></span>
								</div>
								<div class='ibm-buttons-row'>
									<div class="pClass">
										<span>
										<div id='submit_view_steps'></div>
										</span>
									</div>
								</div>	
							</div>
						</div>
						
						<li><a href="javascript:showInfo('bynumber');"><%= messages.getString("cp_view_by_request_number") %></a></li>
						<div id="reqinfo">
							<div id="DeviceReqnum">
								<div id='topageidreqnum'></div>
								<div class="ibm-alternate-rule"><hr /></div>
								<div class="pClass">
									<em>
										<%= messages.getString("cp_view_request_number") %>
									</em>
								</div>
								<div class="pClass">
									<label for='reqnum'><%= messages.getString("device_request_number") %>:</label>
									<span><div id='reqnum'></div></span>
								</div>
								<div class='ibm-buttons-row'>
									<div class="pClass">
										<span>
										<div id='submit_view_reqnum'></div>
										</span>
									</div>
								</div>	
							</div>
						</div>
					</ul>
				</p>
			</div>
			<br />
			<div class="ibm-alternate-rule"><hr /></div>
	
		</div>
		<!-- ADDITIONAL_INFO_BEGIN -->
		<!-- ADDITIONAL_INFO_END -->
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>