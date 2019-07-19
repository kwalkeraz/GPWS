<%
	TableQueryBhvr DriverSetView  = (TableQueryBhvr) request.getAttribute("DriverSetView");
	TableQueryBhvrResultSet DriverSetView_RS = DriverSetView.getResults();
	TableQueryBhvr Model  = (TableQueryBhvr) request.getAttribute("Types");
	TableQueryBhvrResultSet Model_RS = Model.getResults();
	TableQueryBhvr ModelDriverSet  = (TableQueryBhvr) request.getAttribute("ModelDriverSet");
	TableQueryBhvrResultSet ModelDriverSet_RS = ModelDriverSet.getResults();
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String modelid = request.getParameter("model_id");
	if (modelid == null) { modelid = "0"; }
	String driversetid = request.getParameter("driverset_id");
	String driverset = request.getParameter("driversetname");
	if (driversetid == null) { driversetid = "0"; }
	String referer = tool.nullStringConverter(request.getParameter("referer"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website model driver set"/>
	<meta name="Description" content="Global print website administer a model driver set page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("model_driver_set_administer") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.Select");	
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //showReqMsg 
	 
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
										"<div class='pClass'><label id='devicemodellabel' for='devicemodel'>"+'<%= messages.getString("device_model") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='devicemodelloc'></div></span></div>"+
										"<div class='pClass'><label id='driversetlabel' for='driverset'>"+'<%= messages.getString("driver_set_name") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='driversetloc'></div></span></div>"+
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
	 
	 function openDiag(overlay) {
        //locDiag.show();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("model_driver_set_add") %>';
        topageid.value = '361';
        logactionid.value = "Model Driver set" + logaction;
        getID("processTitle").innerHTML = title;
        loadDeviceModels();
 		loadDriverSets();
 		<%if (referer.equals("850")) {%>
 			autoSelectValue("devicemodel","<%= modelid %>");
 			removeOptions('driverset','<%= modelid %>');
 		<%}%>
 		<%if (referer.equals("352")) {%>
 			autoSelectValue("driverset","<%= driversetid %>");
 			removeOptions('devicemodel','<%= driversetid %>');
 		<%}%>
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function loadDeviceModels(){
     	resetMenu('devicemodel');
     	<%	while (Model_RS.next()) {
				int optionsfileid = 0;
				String optionsfilename = "";
				optionsfileid = Model_RS.getInt("MODELID");
				optionsfilename = tool.nullStringConverter(Model_RS.getString("MODEL")); %>
			<%  if (!optionsfilename.equals("")) { %>
					addOption('devicemodel',"<%= optionsfilename %>","<%= optionsfileid %>");
		<%		}  //if not empty %>
		<%	} //while Model_RS %>
     } //loadDeviceModels
     
     function loadDriverSets(){
     	resetMenu('driverset');
     	<%	while (DriverSetView_RS.next()) {
				int optionsfileid = 0;
				String optionsfilename = "";
				optionsfileid = DriverSetView_RS.getInt("DRIVER_SETID");
				optionsfilename = tool.nullStringConverter(DriverSetView_RS.getString("DRIVER_SET_NAME")); %>
			<%  if (!optionsfilename.equals("")) { %>
					addOption('driverset',"<%= optionsfilename %>","<%= optionsfileid %>");
		<%		}  //if not empty %>
		<%	} //while DriverSetView_RS %>
     } //loadDriverSets
     
     function onChangeCall(wName){
		return this;
	 } //onChangeCall
     
     function editDiag(modeldriversetid, devicemodel, driverset) {
        //locDiag.show();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("model_driver_set_edit") %>';
        topageid.value = '362';
        logactionid.value = "Model driver set" + logaction;
        createHiddenInput('logactioniddiag','modeldriversetid',modeldriversetid);
        getID("processTitle").innerHTML = title;
        loadDeviceModels();
 		loadDriverSets();
        autoSelectValue("devicemodel",devicemodel);
        autoSelectValue("driverset",driverset);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
        ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     var addModelDriverSet = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createSelect('devicemodel', 'devicemodel', '<%= messages.getString("select_model") %>...', '0', 'devicemodelloc');
		createSelect('driverset', 'driverset', '<%= messages.getString("select_driver_set") %>...', '0', 'driversetloc');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addInfo()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addModelDriverSet);  //addOnLoad
	 
	 function removeOptions(wName, optionID) {
	 	var selectMenu = getWidgetID(wName);
	 	var removeID = "";
	 <% ModelDriverSet_RS.first();
	 	while (ModelDriverSet_RS.next()) {
	 		if (referer.equals("352")) { %>
	 			if (optionID == "<%= ModelDriverSet_RS.getInt("DRIVER_SETID") %>") {
	 				removeID = "<%= ModelDriverSet_RS.getInt("MODELID") %>";
	 			}
	 	<%  } else if (referer.equals("850")) { %>
	 			if (optionID == "<%= ModelDriverSet_RS.getInt("MODELID") %>") {
	 				removeID = "<%= ModelDriverSet_RS.getInt("DRIVER_SETID") %>";
	 			}
	 	<%  } //if-else %>
	 		selectMenu.removeOption(removeID);
	 <% } //while %>
	 } //removeOptions
	 
	 function addInfo() {
	 	var devicemodel = getWidgetID("devicemodel");
        var driverset = getWidgetID("driverset");
        var wName = devicemodel.get("displayedValue") + "/" + driverset.get("displayedValue");
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        var msg = logactionid.value;
        if (devicemodel.get('value') == 0) {
        	var labeltext = getID('devicemodel'+'label').innerHTML;
        	var textsize = labeltext.indexOf(":");
		 	labeltext = labeltext.substring(0,textsize);
        	showReqMsg(labeltext + ' <%= messages.getString("required_selected_info") %>', 'devicemodel');
        	return false;
        }
        if (driverset.get('value') == 0) {
        	var labeltext = getID('driverset'+'label').innerHTML;
        	var textsize = labeltext.indexOf(":");
		 	labeltext = labeltext.substring(0,textsize);
        	showReqMsg(labeltext + ' <%= messages.getString("required_selected_info") %>', 'driverset');
        	return false;
        }
        submitForm('addProcessForm',msg);
        AddParameter(logactionid.name, logactionid.value);
	}; //addSpooler
	
    function submitForm(form,msg){
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Model/Driver set combination already exists.  Please use a different combination.'+"</p>";
	   			} else if (data.indexOf("Unknown") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'There was an error in the request'+"</p>";
	   			} else {
	   				getID("Msg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				//location.reload();
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           	console.log(error);
	               getID("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           },
	        };
	     dojo.xhrPost(xhrArgs);
    } //submitForm
    
    function setFormValues(modeldriversetid, msg){
		var topageid = "";
		topageid = "363";
		createHiddenInput('logactionid','modeldriversetid',modeldriversetid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(modeldriversetid, modeldriverset) {
		var msg = "Model driver set information " + modeldriverset + " has been deleted";
		setFormValues(modeldriversetid, msg);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_model_driver_set") %> ' + modeldriverset + "?");
		if (confirmDelete) {
			deleteFunction(msg, modeldriverset);
			//location.reload();
			AddParameter("logaction", msg);
		} //if yesno
	};
	
	function deleteFunction(msg,modeldriverset){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Model driver set " + modeldriverset +" may be currently assigned to a printer</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue,
        };
        dojo.xhrPost(xhrArgs);
	} //deleteFunction
		
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('ModelDriverSetAdmin','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
				<% if (referer != null) { %>
					<% if (referer.equals("850")) { %>
						<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=850"><%= messages.getString("administer_device_type") %></a></li>
					<% } else if (referer.equals("352")) {%>
						<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=352"><%= messages.getString("driver_set_administer") %></a></li>
					<% } %>
				<% } %>
			</ul>
			<h1><%= messages.getString("model_driver_set_administer") %></h1>
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
		<ul>
			<li><%= messages.getString("model_driver_set_add_info") %></li>
			<li><%= messages.getString("model_driver_set_edit_info") %></li>
			<li><%= messages.getString("model_driver_set_delete_info") %></li>
		</ul>
		<!-- LEADSPACE_END -->
			<div id='ModelDriverSetAdmin'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display a list of all model driver sets available">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("model_driver_set_add") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_model") %></th>
							<th scope="col"><%= messages.getString("driver_set_name") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% ModelDriverSet_RS.first();
							if (ModelDriverSet_RS.getResultSetSize() > 0) {
								while (ModelDriverSet_RS.next()) {
									if ((referer.equals("850") && ModelDriverSet_RS.getInt("MODELID") == Integer.parseInt(modelid)) || (referer.equals("352") && ModelDriverSet_RS.getInt("DRIVER_SETID") == Integer.parseInt(driversetid))) { %>
									<tr>
										<th class="ibm-table-row" scope="row">
											<%= ModelDriverSet_RS.getString("MODEL")%>
										</th>
										<th class="ibm-table-row" scope="row">
											<%= ModelDriverSet_RS.getString("DRIVER_SET_NAME")%>
										</th>
										<td>
											<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= ModelDriverSet_RS.getInt("MODEL_DRIVER_SETID")%>','<%= ModelDriverSet_RS.getInt("MODELID")%>','<%= ModelDriverSet_RS.getInt("DRIVER_SETID")%>')"><%= messages.getString("edit") %></a>
											<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= ModelDriverSet_RS.getInt("MODEL_DRIVER_SETID")%>','<%= ModelDriverSet_RS.getString("MODEL")%>/<%= ModelDriverSet_RS.getString("DRIVER_SET_NAME")%>')" ><%= messages.getString("delete") %></a>
										</td>
									</tr>
								<% } //if referer %>	
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_model_driver_sets_found") %></th>
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