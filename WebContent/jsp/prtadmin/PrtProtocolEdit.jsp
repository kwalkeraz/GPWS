<%
    TableQueryBhvr ProtocolView  = (TableQueryBhvr) request.getAttribute("ProtocolView");
    TableQueryBhvrResultSet ProtocolView_RS = ProtocolView.getResults();
    TableQueryBhvr HostPortConfig = (TableQueryBhvr) request.getAttribute("HostPortConfig");
    TableQueryBhvrResultSet HostPortConfig_RS = HostPortConfig.getResults();
    String protocol = "";
    String protocoltype= "";
    String hostportconfig = "";
    int protocolid = Integer.parseInt(request.getParameter("protocolid"));
    
	while(ProtocolView_RS.next()) { 
		protocol = ProtocolView_RS.getString("PROTOCOL_NAME");
		protocoltype = ProtocolView_RS.getString("PROTOCOL_TYPE");
		hostportconfig = ProtocolView_RS.getString("HOST_PORT_CONFIG");
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit protocol"/>
	<meta name="Description" content="Global print website edit a protocol page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("protocol_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
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
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=311";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addHostPort(dID){
	 	var selectMenu = getWidgetID(dID);
	 	<%
   		while(HostPortConfig_RS.next()) {
			String hostport = HostPortConfig_RS.getString("CATEGORY_VALUE1"); %>
   			var optionName = "<%= hostport %>";
   			var optionValue = "<%= hostport %>";
   			selectMenu.addOption({value: optionValue, label: optionName });
   		<% } %>
	 } //addSDC
	 
	 function onChangeCall(wName){
	 	return this;
	 } //onChangeCall
	 
	 function editProtocol(event) {
	 	var hostport = getSelectValue('hostport');
	 	getID("errorMsg").innerHTML = "";
	 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
	 	var formName = getWidgetID('editProtocolForm');
	 	var formValid = formName.validate();
	 	var protocol = getWidgetIDValue('protocol');
	 	var logaction = getID('logaction');
	 	var protocoltype = getWidgetIDValue('protocoltype');
	 	if (!showSelectMsg("None", hostport, '<%= messages.getString("please_enter_all_required_fields") %>', 'hostport')) return;
		if (formValid) {
			logaction.value = "Protocol " + protocol + "/" + protocoltype + " has been updated";
			formName.submit();
		} else {
			return false;
		}
	 } //addServer
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '316');
        createHiddenInput('logactionid','logaction','','logaction');
        createHiddenInput('logactionid','protocolid','<%= protocolid %>','protocolid');
        createpTag();
        createTextInput('protocolloc','protocol','protocol','16',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= protocol %>');
        createTextInput('protocoltypeloc','protocoltype','protocoltype','16',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= protocoltype %>');
        createSelect('hostport', 'hostport', '<%= messages.getString("protocol_select_hostport") %> ...', 'None', 'hostportloc');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_protocol');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_protocol','cancelForm()');
     	createPostForm('editProtocol','editProtocolForm','editProtocolForm','ibm-column-form','<%= prtgateway %>');
     	addHostPort('hostport');
     	autoSelectValue('hostport','<%= hostportconfig %>');
     	changeInputTagStyle('270px');
     	changeSelectStyle('270px');
     	getWidgetID('protocol').focus();
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('addProtocolForm'), 'onsubmit', function(event) {
		 	editProtocol(event);
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=311"><%= messages.getString("protocol_administration") %></a></li>
			</ul>
			<h1><%= messages.getString("protocol_edit") %></h1>
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
			<div id='editProtocol'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='protocol'><%= messages.getString("protocol_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='protocolloc'></div></span>
				</div>
				<div class="pClass">
					<label for='protocoltype'><%= messages.getString("protocol_type") %>:<span class='ibm-required'>*</span></label>
					<span><div id='protocoltypeloc'></div></span>
				</div>
				<div class="pClass">
					<label for='host'><%= messages.getString("protocol_hostport_config") %>:<span class='ibm-required'>*</span></label>
					<span><div id='hostportloc'></div></span>
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