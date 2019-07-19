<%
	TableQueryBhvr CPTemplateSteps  = (TableQueryBhvr) request.getAttribute("CPTemplateSteps");
	TableQueryBhvrResultSet CPTemplateSteps_RS = CPTemplateSteps.getResults();
	TableQueryBhvr CPRoutingTemplate  = (TableQueryBhvr) request.getAttribute("CPRoutingTemplate");
	TableQueryBhvrResultSet CPRoutingTemplate_RS = CPRoutingTemplate.getResults();
	TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	TableQueryBhvr NotifyList  = (TableQueryBhvr) request.getAttribute("NotifyList");
	TableQueryBhvrResultSet NotifyList_RS = NotifyList.getResults();
	AppTools tool = new AppTools();
	
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String sCptemplateid = tool.nullStringConverter(request.getParameter("cptemplateid"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	if (sCptemplateid.equals("")) { sCptemplateid = "0"; }
	
	String cptemplatename = "";
	while (CPRoutingTemplate_RS.next()) {
		cptemplatename = tool.nullStringConverter(CPRoutingTemplate_RS.getString("TEMPLATE_NAME"));
	}
	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website administer routing template steps"/>
	<meta name="Description" content="Global print website administer routing template steps" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_admin_routing_template_steps_info") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Textarea");
	 
	 function createLayout(overlayID){
	 	var content = ""+
	 			"<div id='response'>"+
					"<div class='ibm-common-overlay' id="+overlayID+">"+
						"<div class='ibm-head'>"+
							"<p><a class='ibm-common-overlay-close' href='#close'>Close [x]</a></p>"+
						"</div>"+
						"<div class='ibm-body'>"+
							"<div class='ibm-main'>"+
							"<div class='ibm-title ibm-subtitle'>"+
								"<h1><div id='processTitle'></div></h1>"+
							"</div>"+
							"<div class='ibm-container ibm-alternate ibm-buttons-last'>"+
								"<div class='ibm-container-body'>"+
									"<p class='ibm-overlay-intro'>"+'<%= messages.getString("required_info") %>'+".</p>"+
									"<div id='Msg'></div>"+
									"<div id='formLoc'>"+
										"<div id='topageiddiag'></div>"+
										"<div id='logactioniddiag'></div>"+
										"<div class='pClass'><label for='step'>"+'<%= messages.getString("step") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='step'></div></span></div>"+
										"<div class='pClass'><label for='actiontype'>"+'<%= messages.getString("action_type") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='actiontype'></div></span></div>"+
										"<div class='pClass'><label for='assignee'>"+'<%= messages.getString("assignee") %>'+":</label>"+
										"<span><div id='assignee'></div></span></div>"+
										"<div class='pClass'><label for='schedflow'>"+'<%= messages.getString("schedule_flow") %>'+":</label>"+
										"<span><div id='schedflow'></div></span></div>"+
										"<div class='pClass'><label for='comments'>"+'<%= messages.getString("comments") %>'+":</label>"+
										"<span><div id='comments'></div></span></div>"+
										"<div class='ibm-overlay-rule'><hr /></div>"+
										"<div class='ibm-buttons-row'>"+
										"<div id='submit_add_button' align='right'></div>"+
									"</div>"+
								"</div>"+
							"</div>"+
						"</div>"+
					"</div>"+
				"</div>"+
				"<div class='ibm-footer'></div>"+
				"</div>"+
				"</div>";
			return content;
	 } //createLayout
	 
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
	 
	 function clearValues(){
	 	if (getID("Msg")) getID("Msg").innerHTML = "";
		setWidgetIDValue('step','');
		autoSelectValue('actiontype','');
		autoSelectValue('assignee','');
		setWidgetIDValue('schedflow','');
        setWidgetIDValue('comments','');
	 } //clearValues
	 
	 function openDiag(overlay) {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = dojo.byId('topageidadd');
        var logactionid = dojo.byId('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("cp_add_routing_steps_info") %>';
        topageid.value = '7491';
        logactionid.value = "Template step " + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(cptemplatestepsid, actiontype, assignee, step, schedflow, comments) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("cp_edit_routing_steps_info") %>';
        topageid.value = '7493';
        logactionid.value = "Template step " + logaction;
        createHiddenInput('logactioniddiag','cptemplatestepsid',cptemplatestepsid);
        getID("processTitle").innerHTML = title;
        setWidgetIDValue('step',step);
        autoSelectValue('actiontype',actiontype);
        autoSelectValue('assignee',assignee);
        setWidgetIDValue('schedflow',schedflow);
        setWidgetIDValue('comments',comments);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        clearValues();
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     var addInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','cptemplateid','<%= sCptemplateid %>','cptemplateid');
        createTextInput('step','step','step','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9]*$','');
        createSelect('actiontype', 'actiontype', '<%= messages.getString("please_select_value") %>... ', 'None', 'actiontype');
        addActionType();
        createSelect('assignee', 'assignee', '<%= messages.getString("please_select_assignee") %>... ', 'None', 'assignee');
        addAssignee();
        createTextBox('schedflow','schedflow','schedflow','32','','');
        createHiddenInput('logactioniddiag','status','NEW','');
        createTextArea('comments', 'comments', '', '');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addTemplateInfo()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= commonprocess %>');
		changeSelectStyle('200px');
 		changeInputTagStyle('200px');
 		changeCommentStyle('comments', '200px');
	 }; //function
	 
	 dojo.addOnLoad(addInfo);  //addOnLoad
	 
	 function addTemplateInfo() {
	 	var formName = dijit.byId("addProcessForm");
        var formValid = false;
        var wName = getWidgetIDValue('step');
        var actiontype = getSelectValue('actiontype');
        wName = wName + " for template name " + "<%= cptemplatename %>";
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
		if (formValid) {
			if (actiontype == "None") {
				showReqMsg('<%= messages.getString("please_select_all_required_fields") %>','actiontype');
				return false;
			}
			if (submitForm('addProcessForm',msg)) {
				//location.reload();
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			return false;
		}
	}; //addTemplateInfo
	
    function submitForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				dojo.byId("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Step already exists.  Please use a different name.'+"</p>";
	   				submitted = false;
	   			} else if (data.indexOf("Unknown") > -1) {
	   				dojo.byId("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'There was an error in the request'+"</p>";
	   				submitted = false;
	   			} else {
	   				dojo.byId("Msg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				//location.reload();
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           	submitted = false;
	           	console.log(error);
	               dojo.byId("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           }
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
    
    function setFormValues(cptemplatestepsid, msg){
		var topageid = "";
		topageid = "7494";
		createHiddenInput('logactionid','cptemplatestepsid',cptemplatestepsid);
		setValue('topageiddel',topageid);
		setValue('logactioniddel',msg);
	} //setFormValues
    
    function callDelete(cptemplatestepsid, step) {
		var msg = "Template step " + step + " for template name " + "<%= cptemplatename %>" + " has been deleted";
		setFormValues(cptemplatestepsid, msg);
		var confirmDelete = confirm('<%= messages.getString("cp_delete_routing_template_step_info") %> ' + step + "?");
		if (confirmDelete) {
			deleteFunction(msg, step);
			//location.reload();
			AddParameter("logaction", msg);
		} //if yesno
	};
	
	function deleteFunction(msg,step){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Template step " + step +" may be currently in use</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue
        };
        dojo.xhrPost(xhrArgs);
	} //deleteFunction
	
	function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	} //showReqMsg
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= commonprocess %>');
        <%if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
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
			<h1><%= messages.getString("cp_admin_routing_template_steps_info") %></h1>
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
			<li><%= messages.getString("cp_edit_routing_steps_info") %></li>
			<li><%= messages.getString("cp_delete_routing_steps_info") %></li>
		</ul>
		<p><strong><%= messages.getString("template_name") %></strong> : <%= cptemplatename %></p>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current routing template steps">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("cp_add_routing_steps_info") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("step") %></th>
							<th scope="col"><%= messages.getString("action_type") %></th>
							<th scope="col"><%= messages.getString("status") %></th>
							<th scope="col"><%= messages.getString("assignee") %></th>
							<th scope="col"><%= messages.getString("schedule_flow") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% 
							int step = 0;
							String actiontype = "";
							String status = "";
							String assignee = "";
							String schedflow = "";
							String comments = "";
							int cptemplatestepsid = 0;
							if (CPTemplateSteps_RS.getResultSetSize() > 0 ) { 
								while(CPTemplateSteps_RS.next()) {
									actiontype = tool.nullStringConverter(CPTemplateSteps_RS.getString("ACTION_TYPE"));
									status = tool.nullStringConverter(CPTemplateSteps_RS.getString("STATUS"));
									assignee = tool.nullStringConverter(CPTemplateSteps_RS.getString("ASSIGNEE"));
									schedflow = tool.nullStringConverter(CPTemplateSteps_RS.getString("SCHED_FLOW"));
									step = CPTemplateSteps_RS.getInt("STEP");
									comments = tool.nullStringConverter(CPTemplateSteps_RS.getString("COMMENTS"));
									cptemplatestepsid = CPTemplateSteps_RS.getInt("CP_TEMPLATE_STEPS_ID");
						%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= step %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= actiontype %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= status %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= assignee %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= schedflow %>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= cptemplatestepsid %>', '<%= actiontype %>', '<%= assignee %>','<%= step %>','<%= schedflow %>','<%= comments %>')"><%= messages.getString("edit") %></a>
								<a class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= cptemplatestepsid %>', '<%= step %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("cp_routing_template_steps_found") %></th>
						</tr>
						<% } %>
					</tbody>
				</table> 
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>