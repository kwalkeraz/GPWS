<%
	TableQueryBhvr RequestType  = (TableQueryBhvr) request.getAttribute("RequestType");
	TableQueryBhvrResultSet RequestType_RS = RequestType.getResults();
    AppTools tool = new AppTools();
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print routing template add"/>
	<meta name="Description" content="Global print website routing template add page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_add_routing_template") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7480";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function addRequestType(){
	 	var dID = "requesttype";
	 	<%
	 	RequestType_RS.first();
   		while(RequestType_RS.next()) {
   			String categoryname = tool.nullStringConverter(RequestType_RS.getString("CATEGORY_NAME"));
			String categoryvalue1 = tool.nullStringConverter(RequestType_RS.getString("CATEGORY_VALUE1")); %>
				var optionName = "<%= categoryvalue1 %>";
   				addOption(dID,optionName,optionName);
   	<% } %>
	 } //addRequestType
	 
	 function addTemplate(event) {
	 	var formName = getWidgetID("TemplateForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var wName = getWidgetIDValue('templatename');
        var requesttype = getSelectValue('requesttype');
        var logactionid = getID('logaction');
        var logaction = "Routing template " + wName + " has been added";
        logactionid.value = logaction;
        formValid = formName.validate();
   		if (formValid) {
			if (requesttype == "None") {
				showReqMsg('<%= messages.getString("please_enter_all_required_fields") %>','requesttype');
				return false;
			} else {
				formName.submit();
			}
		} else {
			return false;
		}
	}; //addCategory
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '7482');
        createHiddenInput('logactionid','logaction','');
        createpTag();
        createTextInput('templatename','templatename','templatename','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;,()\/-]*$','');
        createSelect('requesttype', 'requesttype', '<%= messages.getString("please_select_value") %>... ', 'None', 'requesttype');
        addRequestType();
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_template');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_template','cancelForm()');
     	createPostForm('Template','Templateform','TemplateForm','ibm-column-form','<%= commonprocess %>');
     	changeInputTagStyle("250px");
     	changeSelectStyle('250px');
        dijit.byId('templatename').focus();
     });
     
     dojo.addOnLoad(function(){
     	dojo.connect(dojo.byId('TemplateForm'),'onsubmit',function(event){
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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7480"><%= messages.getString("cp_administer_routing_template") %></a></li>
			</ul>
			<h1><%= messages.getString("cp_add_routing_template") %></h1>
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
			<div id='Template'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='templatename'><%= messages.getString("template_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='templatename'></div></span>
				</div>
				<div class="pClass">
					<label for='requesttype'><%= messages.getString("request_type") %>:<span class='ibm-required'>*</span></label>
					<span><div id='requesttype'></div></span>
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