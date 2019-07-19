<%
   TableQueryBhvr CPRoutingTemplateView  = (TableQueryBhvr) request.getAttribute("CPRoutingTemplate");
   TableQueryBhvrResultSet CPRoutingTemplateView_RS = CPRoutingTemplateView.getResults();
   TableQueryBhvr CPApproval  = (TableQueryBhvr) request.getAttribute("CPApproval");
   TableQueryBhvrResultSet CPApproval_RS = CPApproval.getResults();
	
	AppTools tool = new AppTools();
	String reqnum = "";
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	String template = tool.nullStringConverter(request.getParameter("templatename"));
	int cpapprovalid = 0;
	String devicename = "";
	String action = "";
	while (CPApproval_RS.next()) {
		reqnum = tool.nullStringConverter(CPApproval_RS.getString("REQ_NUM"));
		cpapprovalid = CPApproval_RS.getInt("CPAPPROVALID");
		devicename = tool.nullStringConverter(CPApproval_RS.getString("DEVICE_NAME"));
		action = tool.nullStringConverter(CPApproval_RS.getString("ACTION"));
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print routing template page"/>
	<meta name="Description" content="Global Print website select a routing template page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_select_routing_template") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	history.go(-1);
	 } //cancelForm
	 
	 function onChangeCall(wName){
		return false;
	 } //onChangeCall
	 
	 function addTemplateInfo(){
	 	var dID = "cptemplateid";
	 	<%
   		while(CPRoutingTemplateView_RS.next()) {
   			String templateName = tool.nullStringConverter(CPRoutingTemplateView_RS.getString("TEMPLATE_NAME"));
			String reqType = tool.nullStringConverter(CPRoutingTemplateView_RS.getString("REQUEST_TYPE"));
			int templateID = CPRoutingTemplateView_RS.getInt("CP_TEMPLATE_ID");
			if (action.equals(tool.nullStringConverter(CPRoutingTemplateView_RS.getString("REQUEST_TYPE"))) || tool.nullStringConverter(CPRoutingTemplateView_RS.getString("REQUEST_TYPE")).equals("")) {
		%>
				var optionName = "<%= templateName %>";
				var optionValue = "<%= templateID %>";
   				addOption(dID,optionName,optionValue);
   		<%  } //if
   		} %>
	 } //addActionType
	 
	 function addTemplate(event) {
	 	var formName = getWidgetID("CPRoutingForm");
        var formValid = false;
        var reqnum = "<%= reqnum %>";
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var template = dojo.byId('templatename');
        var cptemplateid = getSelectValue('cptemplateid');
        var logactionid = dojo.byId('logaction');
        var logaction = "Routing template for request " + reqnum + " has been added";
        logactionid.value = logaction;
        formValid = formName.validate();
        if (cptemplateid == "None") {
			showReqMsg('<%= messages.getString("please_enter_all_required_fields") %>','cptemplateid');
			return false;
		}
   		if (formValid) {
			template.value = getSelectValuebyName('cptemplateid');
			formName.submit();
		} else {
			return false;
		}
	}; //addTemplate
	
	function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	} //showReqMsg
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '7455');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cpapprovalid','<%= cpapprovalid %>');
        createHiddenInput('logactionid','reqnum','<%= reqnum %>');
        createHiddenInput('logactionid','templatename','');
        createpTag();
        createSelect('cptemplateid', 'cptemplateid', '<%= messages.getString("please_select_template") %>... ', 'None', 'cptemplateid');
        addTemplateInfo();
        autoSelectValue('cptemplateid','<%= template %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_step');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_step','cancelForm()');
     	createPostForm('CPRouting','CPRoutingForm','CPRoutingForm','ibm-column-form','<%= commonprocess %>');
     	changeSelectStyle('250px');
     	dijit.byId('cptemplateid').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('CPRoutingForm'),'onsubmit',function(event){
     		addTemplate(event);
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
			<h1><%= messages.getString("cp_select_routing_template") %></h1>
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
			<ul>
				<li><a href="<%= commonprocess %>?to_page_id=7480"><%= messages.getString("cp_administer_routing_template") %></a></li>
			</ul>
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
					<label for='cptemplateid'><%= messages.getString("template_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='cptemplateid'></div></span>
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