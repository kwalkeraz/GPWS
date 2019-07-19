<%	 AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String enbltype = tool.nullStringConverter(request.getParameter("enbltype"));
	String enbltypeid = tool.nullStringConverter(request.getParameter("enbltypeid"));
	TableQueryBhvr EnblField  = (TableQueryBhvr) request.getAttribute("EnblField");
	TableQueryBhvrResultSet EnblField_RS = EnblField.getResults();
	String enblfield = "";	
	int enblfieldid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website enablement field"/>
	<meta name="Description" content="Global print website administer enablement fields" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("enbl_field_admin_info") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.CheckBox");
	 
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
										"<div class='pClass'><label for='enblfield'>"+'<%= messages.getString("enbl_field") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='enblfield'></div></span></div>"+
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
	 
	 function clearValues(){
	 	if (getID("Msg")) getID("Msg").innerHTML = "";
		setWidgetIDValue('enblfield', '');
	 } //clearValues
	 
	 function openDiag(overlay) {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = dojo.byId('topageidadd');
        var logactionid = dojo.byId('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("enbl_field_add") %>';
        topageid.value = '7281';
        logactionid.value = "Enablement field" + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(enblfield, enblfieldid) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = dojo.byId('topageidadd');
        var logactionid = dojo.byId('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("enbl_field_edit") %>';
        topageid.value = '7282';
        logactionid.value = "Enablement field" + logaction;
        createHiddenInput('logactioniddiag','enblfieldid',enblfieldid);
        getID("processTitle").innerHTML = title;
        setWidgetIDValue('enblfield', enblfield);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
		setWidgetIDValue('enblfield', '');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     /**
	 	Add spooler
	 **/          
	 var addInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','enbltypeid','<%= enbltypeid %>','enbltypeid');
        createTextInput('enblfield','enblfield','enblfield','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addEnblField()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addInfo);  //addOnLoad
	 
	 function addEnblField() {
	 	var formName = getWidgetID("addProcessForm");
        var formValid = false;
        var wName = getWidgetIDValue('enblfield');
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
		if (formValid) {
			if (submitForm('addProcessForm',msg)) {
				//location.reload();
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			return false;
		}
	}; //addCategoryInfo
	
    function submitForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("enbl_field_exists") %>.'+"</p>";
	   				submitted = false;
	   			} else if (data.indexOf("Unknown") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("error_in_request") %>'+"</p>";
	   				submitted = false;
	   			} else {
	   				getID("Msg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
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
    
    function setFormValues(enblfieldid, msg){
		var topageid = "";
		topageid = "7283";
		createHiddenInput('logactionid','enblfieldid',enblfieldid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(enblfield, enblfieldid) {
		var msg = "Enablement field " + enblfield + " has been deleted";
		setFormValues(enblfieldid, msg);
		var confirmDelete = confirm('<%= messages.getString("enbl_field_delete_sure") %> ' + enblfield + "?");
		if (confirmDelete) {
			deleteFunction(msg, enblfield);
			//location.reload();
			AddParameter("logaction", msg);
		} //if yesno
	};
	
	function deleteFunction(msg,enblfield){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Enablement field " + enblfield +" may be currently assigned to a printer</p>";
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
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7250"><%= messages.getString("enbl_type_admin_info") %></a></li>
			</ul>
			<h1><%= messages.getString("enbl_field_admin_info") %></h1>
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
			<li><%= messages.getString("enbl_field_add_info") %></li>
			<li><%= messages.getString("enbl_field_edit_info") %></li>
			<li><%= messages.getString("enbl_field_delete_info") %></li>
		</ul>
		<p><%= messages.getString("enbl_type") %> : <%= enbltype %></p>
		<% if (!logaction.equals("")) { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %></p>
		<% } %>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all current available enablement types">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("enbl_field_add") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("enbl_field") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% 
							if (EnblField_RS.getResultSetSize() > 0 ) { 
								while(EnblField_RS.next()) {
									enblfield = tool.nullStringConverter(EnblField_RS.getString("ENBL_FIELD_NAME"));
									enblfieldid = EnblField_RS.getInt("ENBL_FIELDID");
						%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= enblfield %>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="javascript:editDiag('<%= enblfield %>','<%= enblfieldid %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="javascript:callDelete('<%= enblfield %>','<%= enblfieldid %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_enbl_field_found") %></th>
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