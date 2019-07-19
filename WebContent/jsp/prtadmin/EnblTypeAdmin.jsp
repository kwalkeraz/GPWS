
<%
   TableQueryBhvr EnblType  = (TableQueryBhvr) request.getAttribute("EnblType");
   TableQueryBhvrResultSet EnblType_RS = EnblType.getResults();
   AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String enbltype = "";	
	int enbltypeid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website enablement type"/>
	<meta name="Description" content="Global print website administer enablement types" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("enbl_type_admin_info") %> </title>
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
										"<div class='pClass'><label for='enbltype'>"+'<%= messages.getString("enbl_type") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='enbltype'></div></span></div>"+
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
		setWidgetIDValue('enbltype', '');
	 } //clearValues
	 
	 function openDiag(overlay) {
        
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("enbl_type_add") %>';
        topageid.value = '7251';
        logactionid.value = "Enablement type" + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(enbltype, enbltypeid) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("enbl_type_edit") %>';
        topageid.value = '7252';
        logactionid.value = "Enablement type" + logaction;
        createHiddenInput('logactioniddiag','enbltypeid',enbltypeid);
        getID("processTitle").innerHTML = title;
        setWidgetIDValue('enbltype',enbltype);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
		setWidgetIDValue('enbltype', '');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     /**
	 	Add enablement
	 **/          
	 var addInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createTextInput('enbltype','enbltype','enbltype','16',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addEnblType()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addInfo);  //addOnLoad
	 
	 function addEnblType() {
	 	var formName = dijit.byId("addProcessForm");
        var formValid = false;
        var wName = getWidgetIDValue('enbltype');
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
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("enbl_type_exists") %>.'+"</p>";
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
	               getID("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           },
	        };
	      
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
    
    function setFormValues(enbltypeid, msg){
    	
		var topageid = "";
		topageid = "7253";
		createHiddenInput('logactionid','enbltypeid',enbltypeid);
		setValue('topageiddel', topageid);
		setValue('logactionid', msg);
	} //setFormValues
    
    function callDelete(enbltype, enbltypeid) {
    	var msg = "Enablement type " + enbltype + " has been deleted";
		setFormValues(enbltypeid, msg);
		var confirmDelete = confirm('<%= messages.getString("enbl_type_delete_sure") %> ' + enbltype + "?" + ' <%= messages.getString("enbl_type_delete_warning") %>');
		
		if (confirmDelete) {
			deleteFunction(msg, enbltype);
			//KW THIS IS THE OFFENDING RELOAD OF DATA 
			//location.reload();
			//AddParameter("logaction", msg);
		} //if yesno
		
	};
	
	function deleteFunction(msg,enbltype){
		
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            
              	if (data.indexOf("Delete Restriction") > -1) {
            		
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Enablement type " + enbltype +" may be currently assigned to a printer</p>";
        			
        		} else {
        			
        			getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
        			//KW added the reload & addparameter here instead 
        			location.reload();
        			AddParameter("logaction", msg);
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
	
	function callAdd(enbltype,enbltypeid) {
		var params ="&enbltype=" + enbltype + "&enbltypeid=" + enbltypeid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7280" + params;
	} //callAdd
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        //createHiddenInput('logactionid','logaction','','logactioniddel');
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
			</ul>
			<h1><%= messages.getString("enbl_type_admin_info") %></h1>
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
			<li><%= messages.getString("enbl_type_add_info") %></li>
			<li><%= messages.getString("enbl_type_edit_info") %></li>
			<li><%= messages.getString("enbl_type_delete_info") %></li>
		</ul>
		<% if (!logaction.equals("")) { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %></p>
		<% } %>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all current available enablement types">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("enbl_type_add") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("enbl_type") %></th>
							<th scope="col"><%= messages.getString("enbl_field_info") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% 
							if (EnblType_RS.getResultSetSize() > 0 ) { 
								while(EnblType_RS.next()) {
									enbltype = tool.nullStringConverter(EnblType_RS.getString("ENBL_TYPE"));
									enbltypeid = EnblType_RS.getInt("ENBL_TYPEID");
						%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= enbltype %>
							</th>
							<th class="ibm-table-row" scope="row">
								<a href="javascript:callAdd('<%= enbltype %>','<%= enbltypeid %>');"><%= messages.getString("enbl_field_admin_info") %></a>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="javascript:editDiag('<%= enbltype %>','<%= enbltypeid %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="javascript:callDelete('<%= enbltype %>','<%= enbltypeid %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_enbl_type_found") %></th>
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