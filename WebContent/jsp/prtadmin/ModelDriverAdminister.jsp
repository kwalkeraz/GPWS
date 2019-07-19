<%
	TableQueryBhvr DriverView  = (TableQueryBhvr) request.getAttribute("DriverView");
	TableQueryBhvrResultSet DriverView_RS = DriverView.getResults();
	TableQueryBhvr ModelDriver  = (TableQueryBhvr) request.getAttribute("ModelDriver");
	TableQueryBhvrResultSet ModelDriver_RS = ModelDriver.getResults();
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String modelid = request.getParameter("model_id");
	if (modelid == null) { modelid = "0"; }
	String driverid = request.getParameter("driver_id");
	if (driverid == null) { driverid = "0"; }
	String referer = tool.nullStringConverter(request.getParameter("referer"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website model driver"/>
	<meta name="Description" content="Global print website administer a model driver page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("model_driver_administer") %> </title>
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
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	
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
										"<div class='pClass'><label id='driverlabel' for='driver'>"+'<%= messages.getString("driver_name") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='driverloc'></div></span></div>"+
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
        title = '<%= messages.getString("model_driver_add") %>';
        topageid.value = '371';
        logactionid.value = "Model Driver" + logaction;
        getID("processTitle").innerHTML = title;
        loadDeviceModels("<%= modelid %>");
 		loadDrivers();
 		<%if (referer.equals("850")) {%>
 			removeOptions('driver','<%= modelid %>');
 		<%}%>
 		<%if (referer.equals("352")) {%>
 			autoSelectValue("driver","<%= driverid %>");
 			removeOptions('devicemodel','<%= driverid %>');
 		<%}%>
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function loadDeviceModels(selectedValue) {
     	var dID = "devicemodel";
	 	resetMenu(dID);
	 	var url = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10005&query=model";
	 	var tagName = "Name";
	 	var dataTag = "Model";
	 	getXMLDatabyId(url,tagName,dataTag,dID,selectedValue);
	 } //end updateCountry
     
     function loadDrivers(){
     	resetMenu('driver');
     	<%	while (DriverView_RS.next()) {
				int driver_id = 0;
				String drivername = "";
				driver_id = DriverView_RS.getInt("DRIVERID");
				drivername = tool.nullStringConverter(DriverView_RS.getString("DRIVER_MODEL")); %>
			<%  if (!drivername.equals("")) { %>
					var optionValue = "<%= driver_id %>";
					var optionName = "<%= drivername %>";
					addOption('driver',optionName,optionValue);
		<%		}  //if not empty %>
		<%	} //while ModelDriver_RS %>
     } //loadDriverSets
     
     function editDiag(modeldriverid, devicemodel, driver) {
        //locDiag.show();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("model_driver_edit") %>';
        topageid.value = '372';
        logactionid.value = "Model driver" + logaction;
        createHiddenInput('logactioniddiag','modeldriverid',modeldriverid);
        getID("processTitle").innerHTML = title;
        loadDeviceModels('<%= modelid %>');
 		loadDrivers();
        autoSelectValue("devicemodel",devicemodel);
        autoSelectValue("driver",driver);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
        ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     var addModelDriver = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createSelect('devicemodel', 'devicemodel', '<%= messages.getString("select_model") %>...', '0', 'devicemodelloc');
		createSelect('driver', 'driver', '<%= messages.getString("select_driver") %>...', '0', 'driverloc');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addInfo()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
 		changeSelectStyle('250px');
	 }; //function
	 
	 dojo.addOnLoad(addModelDriver);  //addOnLoad
	 
	 function removeOptions(wName, optionID) {
	 	var selectMenu = getWidgetID(wName);
	 	var removeID = "";
	 <% ModelDriver_RS.first();
	 	while (ModelDriver_RS.next()) {
	 		if (referer.equals("352")) { %>
	 			if (optionID == "<%= ModelDriver_RS.getInt("DRIVERID") %>") {
	 				removeID = "<%= ModelDriver_RS.getInt("MODELID") %>";
	 			}
	 	<%  } else if (referer.equals("850")) { %>
	 			if (optionID == "<%= ModelDriver_RS.getInt("MODELID") %>") {
	 				removeID = "<%= ModelDriver_RS.getInt("DRIVERID") %>";
	 			}
	 	<%  } //if-else %>
	 		selectMenu.removeOption(removeID);
	 <% } //while %>
	 } //removeOptions
	 
	 function addInfo() {
	 	var devicemodel = getWidgetID("devicemodel");
        var driverset = getWidgetID("driver");
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
        	var labeltext = getID('driver'+'label').innerHTML;
        	var textsize = labeltext.indexOf(":");
		 	labeltext = labeltext.substring(0,textsize);
        	showReqMsg(labeltext + ' <%= messages.getString("required_selected_info") %>', 'driver');
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
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("model_driver_exists") %>.'+"</p>";
	   			} else if (data.indexOf("Unknown") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("error_in_request") %>'+"</p>";
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
    
    function setFormValues(modeldriverid, msg){
		var topageid = "";
		topageid = "373";
		createHiddenInput('logactionid','modeldriverid',modeldriverid);
		setValue('topageiddel',topageid);
		setValue('logactioniddel',msg);
	} //setFormValues
    
    function callDelete(modeldriverid, modeldriver) {
		var msg = "Model driver information " + modeldriver + " has been deleted";
		setFormValues(modeldriverid, msg);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_model_driver") %> ' + modeldriver + "?");
		if (confirmDelete) {
			if(deleteFunction(msg, modeldriver)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,modeldriverset){
		var submitted = true;
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Model driver " + modeldriverset +" may be currently assigned to a printer</p>";
        			submitted = false;
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	submitted = false;
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue,
        };
        dojo.xhrPost(xhrArgs);
        return submitted;
	} //deleteFunction
		
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('ModelDriverAdmin','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
			<h1 class="ibm-small"><%= messages.getString("model_driver_administer") %></h1>
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
			<li><%= messages.getString("model_driver_add_info") %></li>
			<li><%= messages.getString("model_driver_edit_info") %></li>
			<li><%= messages.getString("model_driver_delete_info") %></li>
		</ul>
		<!-- LEADSPACE_END -->
			<div id='ModelDriverAdmin'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display a list of all model driver available">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("model_driver_add") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_model") %></th>
							<th scope="col"><%= messages.getString("driver_model") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% ModelDriver_RS.first();
							if (ModelDriver_RS.getResultSetSize() > 0) {
								while (ModelDriver_RS.next()) {
									if ((referer.equals("850") && ModelDriver_RS.getInt("MODELID") == Integer.parseInt(modelid)) || (referer.equals("352") && ModelDriver_RS.getInt("MODEL_DRIVERID") == Integer.parseInt(driverid))) { %>
									<tr>
										<th class="ibm-table-row" scope="row">
											<%= ModelDriver_RS.getString("MODEL")%>
										</th>
										<th class="ibm-table-row" scope="row">
											<%= ModelDriver_RS.getString("DRIVER_MODEL")%>
										</th>
										<td>
											<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= ModelDriver_RS.getInt("MODEL_DRIVERID")%>','<%= ModelDriver_RS.getInt("MODELID")%>','<%= ModelDriver_RS.getInt("DRIVERID")%>')"><%= messages.getString("edit") %></a>
											<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= ModelDriver_RS.getInt("MODEL_DRIVERID")%>','<%= ModelDriver_RS.getString("MODEL")%>/<%= ModelDriver_RS.getString("DRIVER_MODEL")%>')" ><%= messages.getString("delete") %></a>
										</td>
									</tr>
								<% } //if referer %>	
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_model_driver_found") %></th>
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