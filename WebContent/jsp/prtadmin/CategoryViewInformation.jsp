<%
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String categoryName = tool.nullStringConverter(request.getParameter("category"));
	TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	String categoryname = "";
	String categorycode = "";
	String categoryvalue1 = "";	
	String categoryvalue2 = "";	
	String categoryid = tool.nullStringConverter(request.getParameter("categoryid"));
	int categoryinfoid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website category information"/>
	<meta name="Description" content="Global print website list available category information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_category_information") %> </title>
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
										"<div class='pClass'><label for='categorycode'>"+'<%= messages.getString("category_code") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='categorycode'></div></span></div>"+
										"<div class='pClass'><label for='categoryvalue1'>"+'<%= messages.getString("category_code_value1") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='categoryvalue1'></div></span></div>"+
										"<div class='pClass'><label for='categoryvalue2'>"+'<%= messages.getString("category_code_value2") %>'+":</label>"+
										"<span><div id='categoryvalue2'></div></span></div>"+
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
		setWidgetIDValue('categorycode', '');
		setWidgetIDValue('categoryvalue1', '');
        setWidgetIDValue('categoryvalue2', '');
	 } //clearValues
	 
	 function openDiag(overlay) {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("add_new_category_info") %>';
        topageid.value = '7005';
        logactionid.value = "Category information" + logaction;
        getID('processTitle').innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(categoryinfoid, categorycode, categoryvalue1, categoryvalue2) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("edit_category_information") %>';
        topageid.value = '7035';
        logactionid.value = "Category information" + logaction;
        createHiddenInput('logactioniddiag','categoryinfoid',categoryinfoid);
        getID('processTitle').innerHTML = title;
        setWidgetIDValue('categorycode', categorycode);
        setWidgetIDValue('categoryvalue1', categoryvalue1);
        setWidgetIDValue('categoryvalue2', categoryvalue2);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID('Msg').innerHTML = "";
		setWidgetIDValue('categorycode', '');
		setWidgetIDValue('categoryvalue1', '');
		setWidgetIDValue('categoryvalue2', '');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     var addInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','categoryid','<%= categoryid %>','categoryid');
        createTextInput('categorycode','categorycode','categorycode','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','.+','');
        createTextInput('categoryvalue1','categoryvalue1','categoryvalue1','255',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','.+','');
        createTextBox('categoryvalue2','categoryvalue2','categoryvalue2','255','','');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addCategoryInfo()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addInfo);  //addOnLoad
	 
	 function addCategoryInfo() {
	 	var formName = getWidgetID("addProcessForm");
        var formValid = false;
        var wName = getWidgetIDValue("categorycode");
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
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("category_info_exists") %>.'+"</p>";
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
	           }
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
    
    function setFormValues(categoryinfoid, msg){
		var topageid = "";
		topageid = "7007";
		createHiddenInput('logactionid','categoryinfoid',categoryinfoid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(categoryinfoid, categoryvalue1) {
		var msg = "Category information " + categoryvalue1 + " has been deleted";
		setFormValues(categoryinfoid, msg);
		var confirmDelete = confirm('<%= messages.getString("category_information_sure_delete") %> ' + categoryvalue1 + "?");
		if (confirmDelete) {
			deleteFunction(msg, categoryvalue1);
			//location.reload();
			AddParameter("logaction", msg);
		} //if yesno
	};
	
	function deleteFunction(msg,ofname){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Options file " + ofname +" may be currently assigned to a driver set</p>";
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7002"><%= messages.getString("administer_category") %></a></li>
			</ul>
			<h1 class="ibm-small"><%= messages.getString("administer_category_information") %></h1>
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
			<li><%= messages.getString("modify_category_information") %></li>
			<li><%= messages.getString("add_category_information") %></li>
		</ul>
		<p><%= messages.getString("category_name") %> : <%= categoryName %></p>
		<% if (!logaction.equals("")) { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %></p>
		<% } %>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current category information">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("add_new_category_info") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("category_code") %></th>
							<th scope="col"><%= messages.getString("category_code_value1") %></th>
							<th scope="col"><%= messages.getString("category_code_value2") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% boolean hasRecords = false;
							while(CategoryView_RS.next()) {
								if (!tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_CODE")).equals("")) {
									hasRecords = true;
								}
							}
						 %>
						<% 
							CategoryView_RS.first();
							if (hasRecords) { 
								while(CategoryView_RS.next()) {
									categoryname = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_NAME"));
									categorycode = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_CODE"));
									categoryvalue1 = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_VALUE1"));
									categoryvalue2 = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_VALUE2"));
									categoryinfoid = CategoryView_RS.getInt("CATEGORY_INFOID");
						%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= categorycode %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= categoryvalue1 %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= categoryvalue2 %>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= categoryinfoid %>', '<%= categorycode %>', '<%= categoryvalue1 %>','<%= categoryvalue2 %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= categoryinfoid %>', '<%= categoryvalue1 %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_category_info_found") %></th>
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