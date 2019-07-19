<%
	TableQueryBhvr OptionFilesFunctionCategory  = (TableQueryBhvr) request.getAttribute("OptionFilesCategory");
	TableQueryBhvrResultSet OptionFilesFunctionCategory_RS = OptionFilesFunctionCategory.getResults();
	TableQueryBhvr OSDriverView  = (TableQueryBhvr) request.getAttribute("OSDriverView");
	TableQueryBhvrResultSet OSDriverView_RS = OSDriverView.getResults();
	TableQueryBhvr OptionFilesView  = (TableQueryBhvr) request.getAttribute("OptionFilesView");
	TableQueryBhvrResultSet OptionFilesView_RS = OptionFilesView.getResults();
	AppTools appTool = new AppTools();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	logaction = URLDecoder.decode(logaction, "UTF-8");
		
	int os_driverid = 0 ;
	String osname = "";
	String drivername = "";
	String drivermodel = "";
	int driverid = 0;
	int osid = 0;
	int iGray = 0;
	int optionsfileid = 0;
	while( OSDriverView_RS.next()) {
		os_driverid = OSDriverView_RS.getInt("OS_DRIVERID");
		osname = OSDriverView_RS.getString("OS_NAME");
		drivername = OSDriverView_RS.getString("DRIVER_NAME");
		drivermodel = OSDriverView_RS.getString("DRIVER_MODEL");
		driverid = OSDriverView_RS.getInt("DRIVERID");
		osid = OSDriverView_RS.getInt("OSID");
	}
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website add a print driver options file"/>
	<meta name="Description" content="Global print website driver options file" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_options_file") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
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
										"<div class='pClass'><label for='ofname'>"+'<%= messages.getString("name") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='ofnameid'></div></span></div>"+
										"<div class='pClass'><label for='offunction'>"+'<%= messages.getString("functions") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span class='ibm-input-group'><div id='functions'></div></span></div>"+
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
	 	getID("Msg").innerHTML = "";
		setWidgetIDValue('ofname', '');
		<%	OptionFilesFunctionCategory_RS.first();
			while(OptionFilesFunctionCategory_RS.next()) { %>
				getWidgetID("offunction"+"<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_CODE") %>").setChecked(false);
		<% } %>
	 } //clearValues
	 
	 function openDiag(overlay) {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("options_file_add") %>';
        topageid.value = '3011';
        logactionid.value = "Options file" + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function prefillInfo(functions) {
		var functionsArray = new Array();
		var curr = 0;
		var last = 0;
		var j = 0;
		for (var i = 0; i < functions.length; i++) {	
			if(functions.charAt(i) == (',')) {	
				if (last == 0) {
					functionsArray[j] = functions.substring(last,curr); 
				} else {
					functionsArray[j] = functions.substring(last+1,curr);   
				}	
				j++;		
				last = curr++;	
			} else {		
				curr++;	
			}
		}
		<%	OptionFilesFunctionCategory_RS.first();
			if (OptionFilesFunctionCategory_RS.getResultSetSize() > 0 ) { %>
				for (var z = 0; z < functionsArray.length; z++) {
		<%		while(OptionFilesFunctionCategory_RS.next()) { %>
					if (functionsArray[z] == "<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_VALUE1") %>") {
						getWidgetID("offunction"+"<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_CODE") %>").setChecked(true);
					}
			<% } //while %>
				}
		<%	}  //if%>
	} //prefillInfo
     
     function editDiag(optionsfileid, ofname, functions) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("options_file_edit") %>';
        topageid.value = '3012';
        logactionid.value = "Options file" + logaction;
        createHiddenInput('logactioniddiag','optionsfileid',optionsfileid);
        getID("processTitle").innerHTML = title;
        setWidgetIDValue('ofname', ofname);
        prefillInfo(functions);
		ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
		setWidgetIDValue('ofname','');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     /**
	 	Add options
	 **/          
	 var addOptionsFileInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','osdriverid','<%= os_driverid %>','osdriverid');
        createHiddenInput('logactioniddiag','offunctions','','offunctions');
        createTextInput('ofnameid','ofname','ofname','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_option_file_regexp,'');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addOptionFile()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
 		addFunctions('functions');
	 }; //function
	 
	 dojo.addOnLoad(addOptionsFileInfo);  //addOnLoad
	 
	 function addOptionFile() {
	 	var formName = getWidgetID("addProcessForm");
        var formValid = false;
        var wName = getWidgetIDValue('ofname');
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
   		var isChecked = false;
   		var functions = "";
		<%	OptionFilesFunctionCategory_RS.first();
			if (OptionFilesFunctionCategory_RS.getResultSetSize() > 0 ) {
			while(OptionFilesFunctionCategory_RS.next()) { %>
				if(getWidgetID("offunction"+"<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_CODE") %>").checked == true) {
					functions = functions + "<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_VALUE1") %>" + ",";
					isChecked = true;
				} //if not checked
			<% } //while 
			}  //if%>
			setValue('offunctions',functions);
		if (isChecked == false) {
			alert("<%= messages.getString("select_one_optionsfile") %>");
			return false;
		} //if false
		if (formValid) {
			submitForm('addProcessForm',msg);
			//location.reload();
			AddParameter(logactionid.name, escape(logactionid.value));
		} else {
			return false;
		}
	}; //addOptionfile
	
    function submitForm(form,msg){
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("options_file_exists") %>.'+"</p>";
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
	           }
	        };
	     dojo.xhrPost(xhrArgs);
    } //submitForm
    
    function setFormValues(optionsfileid, msg){
		var topageid = "";
		topageid = "3013";
		createHiddenInput('logactionid','optionsfileid',optionsfileid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function DisplayMsg(msg) {
		this.msg = msg;
		this.getMsg = function() {
			return msg;
		};
	} //displayMsg
	
	function OptionFileName(name) {
		this.name = name;
		this.getName = function() {
			return name;
		};
	} //OptionFileName
	
	var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
	var msg = new DisplayMsg("");
	var ofName = new OptionFileName("");
	var submitted = true;
	var xhrArgs = {
       	form:  "deleteForm",
           handleAs: "text",
           load: function(data, ioArgs) {
           	//console.log(ioArgs);
           	if (data.indexOf("Delete Restriction") > -1) {
       			getID("response").innerHTML = errorMsg + " Delete Restriction. Options file " + ofName.getName() +" may be currently assigned to a driver set</p>";
       			submitted = false;
       		} else {
   				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg.getMsg() +"</p>";
   			}
           },
           error: function(error, ioArgs) {
           	   console.log(error);
               getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
               submitted = false;
           },
           sync: false
       };
    
    function callDelete(optionsfileid, ofname) {
    	ofName = new OptionFileName(ofname);
    	msg = new DisplayMsg("Options file " + ofName.getName() + " has been deleted");
		setFormValues(optionsfileid, msg.getMsg());
		var confirmDelete = confirm('<%= messages.getString("sure_delete_optionsfile") %> ' + ofName.getName() + "?");
		if (confirmDelete) {
			var def = dojo.xhrPost(xhrArgs);
			def.then(function(res){
				if (submitted) AddParameter("logaction", escape(msg.getMsg()));
			},function(err){
				// Display error message
				alert("An error occurred: " + err);
			});
		} //if yesno
	};
	
	function onChangeCall(wName){
	 	return this;
	} //onChangeCall
	
	function addFunctions(dID){
	 	<%  OptionFilesFunctionCategory_RS.first();
	 	while(OptionFilesFunctionCategory_RS.next()) {
			if (OptionFilesFunctionCategory_RS.getResultSetSize() > 0) { %>
				createCheckBoxList('offunction<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_CODE") %>','<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_VALUE1")%>', '<%= OptionFilesFunctionCategory_RS.getString("CATEGORY_VALUE1") %>', false, dID);
		<% } else {%>
				getID(dID).innerHTML = "<p><a class='ibm-error-link'></a>"+'<%= messages.getString("server_no_protocols") %>';
		<% } %>
   		<% } //while %>
	 } //addFunctions
    
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
	<div id="ibm-leadspace-head" class="ibm-alternate ibm-alternate-5col">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321"><%= messages.getString("driver_administration") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=324&driverid=<%= driverid %>&osid=<%= osid %>"><%= messages.getString("driver_edit_os_specific") %></a></li>
			</ul>
			<h1><%= messages.getString("administer_options_file") %></h1>
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
			<li><%= messages.getString("add_options_file_info") %></li>
			<li><%= messages.getString("edit_options_file_info") %></li>
			<li><%= messages.getString("delete_options_file_info") %></li>
		</ul>
		<p><%= messages.getString("driver_name") %> : <%= drivername %></p>
		<p><%= messages.getString("driver_model") %>  : <%= drivermodel %></p>
		<p><%= messages.getString("os_name") %> : <%= osname %></p>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all driver option files">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("options_file_add") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("name") %></th>
							<th scope="col"><%= messages.getString("functions") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% 
							if (OptionFilesView_RS.getResultSetSize() > 0 ) { 
								while(OptionFilesView_RS.next()) {
						%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= appTool.nullStringConverter(OptionFilesView_RS.getString("NAME")) %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= appTool.nullStringConverter(OptionFilesView_RS.getString("FUNCTIONS")) %>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= OptionFilesView_RS.getInt("OPTIONS_FILEID") %>', '<%= appTool.nullStringConverter(OptionFilesView_RS.getString("NAME")) %>', '<%= appTool.nullStringConverter(OptionFilesView_RS.getString("FUNCTIONS")) %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= OptionFilesView_RS.getInt("OPTIONS_FILEID") %>', '<%= appTool.nullStringConverter(OptionFilesView_RS.getString("NAME")) %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_options_file_found") %></th>
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