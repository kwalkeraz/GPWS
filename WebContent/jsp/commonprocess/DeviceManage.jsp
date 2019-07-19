<%@page import="tools.print.lib.DateTime" %>
<%@page import="java.text.*, java.sql.Timestamp" %>
<%
  	TableQueryBhvr DeviceType = (TableQueryBhvr) request.getAttribute("DeviceType");
    TableQueryBhvrResultSet DeviceType_RS = DeviceType.getResults();
    TableQueryBhvr DeviceFunction = (TableQueryBhvr) request.getAttribute("DeviceFunction");
    TableQueryBhvrResultSet DeviceFunction_RS = DeviceFunction.getResults();
	TableQueryBhvr AddInfoView = (TableQueryBhvr) request.getAttribute("AddInfo");
	TableQueryBhvrResultSet AddInfoView_RS = AddInfoView.getResults();
	TableQueryBhvr RoutingInfo = (TableQueryBhvr) request.getAttribute("RoutingInfo");
	TableQueryBhvrResultSet RoutingInfo_RS = RoutingInfo.getResults();
	TableQueryBhvrResultSet RoutingInfo_RS_2 = RoutingInfo.getResults();
	AppTools appTool = new AppTools();
  	String referer = appTool.nullStringConverter(request.getParameter("referer"));
  	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String Action = "";
	String Reqnum = "";
	String Requester = "";
	String Email = "";
	String Tie = "";
	String Reqdate = "";
	String Reqjust = "";
	String Geo = "";
	String Country = "";
	String State = "";
	String City = "";
	String Building = "";
	String Floor = "";
	String Room = "";
	String devicename = "";
	String ReqStatus = "";
	String SchedDate = "";
	String CompleteDate = "";
	String Appdate = "";
	String AppComments = "";
	String Cs = "";
	String Vm = "";
	String Mvs = "";
	String Sap = "";
	String Wts = "";
	String Ims = "";
	int deviceid = 0;
	int cpapprovalid = 0;
	
	DateTime dateTime = new DateTime();
	int iGray = 0;
	int step = 0;
	int activestep = 0;
	String actiontype = "";	
	String status = "";
	String assignee = "";
	String startdate = "";
	String datetime_created = "";
	DateTime dateT = new DateTime();
	Timestamp notes_date_time = dateT.getSQLTimestamp();
	String datework = "";
	String notecode = "";
	String notevalue = "";
	String wholenote = "";
	String notetag = "";
	String fontstart = "";
	String fontend = "";
	String trstart = "";
	int cpnotesid = 0;
	int cproutingid = 0;
	int prevcproutingid = 0;
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd MMM yyyy");
	java.util.Date dValid = null;
	int year = 0;
	String createdby = "";
	
	String[] aFunctions = new String[DeviceType_RS.getResultSetSize()];
	int x = 0;
	if (DeviceFunction_RS.getResultSetSize() > 0) {
		while (DeviceFunction_RS.next()) {
			aFunctions[x] = DeviceFunction_RS.getString("FUNCTION_NAME");
			x++;
			deviceid = DeviceFunction_RS.getInt("DEVICEID");
		} //while DeviceFunction
	} //if > 0
	
	int devFuncCounter = 0;
	boolean printB = false;  //is function print available?
	for (int z = 0; z < aFunctions.length; z++) {
		if (aFunctions[z] != null && aFunctions[z].equals("print")) {
			printB = true;
		}
	} //for loop
	if (AddInfoView_RS.getResultSetSize() > 0) {
		while (AddInfoView_RS.next()) {
			cpapprovalid = AddInfoView_RS.getInt("CPAPPROVALID");
			Action	= appTool.nullStringConverter(AddInfoView_RS.getString("ACTION"));
			Reqnum	= appTool.nullStringConverter(AddInfoView_RS.getString("REQ_NUM"));
			Requester   = appTool.nullStringConverter(AddInfoView_RS.getString("REQ_NAME"));	
			Email   = appTool.nullStringConverter(AddInfoView_RS.getString("REQ_EMAIL"));	
			Tie   = appTool.nullStringConverter(AddInfoView_RS.getString("REQ_PHONE"));	
			Reqdate   = appTool.nullStringConverter(AddInfoView_RS.getString("REQ_DATE"));	
			Reqjust   = appTool.nullStringConverter(AddInfoView_RS.getString("REQ_JUSTIFICATION"));	
			Geo   = appTool.nullStringConverter(AddInfoView_RS.getString("GEO"));	
			Country   = appTool.nullStringConverter(AddInfoView_RS.getString("COUNTRY"));	
			State   = appTool.nullStringConverter(AddInfoView_RS.getString("STATE"));	
			City   = appTool.nullStringConverter(AddInfoView_RS.getString("CITY"));	
			Building   = appTool.nullStringConverter(AddInfoView_RS.getString("BUILDING"));	
			Floor   = appTool.nullStringConverter(AddInfoView_RS.getString("FLOOR"));	
			Room   = appTool.nullStringConverter(AddInfoView_RS.getString("ROOM"));	
			devicename   = appTool.nullStringConverter(AddInfoView_RS.getString("DEVICE_NAME"));
			ReqStatus   = appTool.nullStringConverter(AddInfoView_RS.getString("REQ_STATUS"));
			Appdate   = appTool.nullStringConverter(AddInfoView_RS.getString("SCHED_DATE"));
			AppComments   = appTool.nullStringConverter(AddInfoView_RS.getString("COMMENTS"));
			Cs   = appTool.nullStringConverter(AddInfoView_RS.getString("CS"));	
			Vm   = appTool.nullStringConverter(AddInfoView_RS.getString("VM"));	
			Mvs   = appTool.nullStringConverter(AddInfoView_RS.getString("MVS"));	
			Sap   = appTool.nullStringConverter(AddInfoView_RS.getString("SAP"));	
			Wts   = appTool.nullStringConverter(AddInfoView_RS.getString("WTS"));	
		} //while AddInfoView
	} //if > 0
	int locid = 0;	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website manage device request"/>
	<meta name="Description" content="Global print website Manage a device request page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getStringArgs("cp_manage_device", new String[] {Action.toLowerCase(), devicename}) %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loginPrompt.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Textarea");
	 
	 <%@ include file="CPRoutingCalls.jsp" %>
	 
	 function openPopup(link,h,w) {
		var chasm = screen.availWidth;
		var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + 'toolbar=1,location=1,menubar=1,resizable=1,status=1,scrollbars=1';	
		args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		window.open(link,'_blank',args);
	 }  //openPopup
	 
	 function openWindow(url) {
	 	window.open(url, '_blank', 'toolbar=1,location=1,menubar=1,resizable=1,status=1,scrollbars=1');
	 } //openWindow
	 	 
	 function openDeviceAdmin() {
		var deviceid = "<%= deviceid %>";
		var url = "";
		if (deviceid == "0") {
			url='<%=prtgateway%>?<%=  BehaviorConstants.TOPAGE %>=280&devicename=<%= devicename%>&geooption=<%= Geo %>&countryoption=<%= Country%>&cityoption=<%= City %>&buildingoption=<%= Building%>&flooroption=<%= Floor %>&room=<%= Room %>&requestnumber=<%= Reqnum%>&status=I';
		} else {
			url='<%=prtgateway%>?<%=  BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=282&SearchName=<%= devicename.toUpperCase() %>%';
		}
		openWindow(url);
	 }  //openDeviceAdmin
	 
	 function openDeviceCompare(cpapprovalid, devicename) {
		var url='<%=commonprocess%>?<%=  BehaviorConstants.TOPAGE %>=1610&cpapprovalid='+cpapprovalid+'&name='+devicename;
		openWindow(url);
	 }  //openDeviceAdmin
	
	 function callAddNote(cproutingid,step) {
		//var url='<%=commonprocess%>?<%=  BehaviorConstants.TOPAGE %>=7100&cproutingid='+cproutingid;
		//openPopup(url,810, 1070);
		openNoteDiag('admin_note',cproutingid,step);
	 } //CPAddNotes
	 
	 function callEditNote(cproutingid,cpnotesid,notevalue,step) {
		//var url='<%=commonprocess%>?<%=  BehaviorConstants.TOPAGE %>=7120&cproutingid='+cproutingid;
		//openPopup(url,810, 1070);
		editNoteDiag(cproutingid,cpnotesid, notevalue, step);
	 } //CPEditNotes
	 
	 //-- CP Notes stuff --
	 function createNoteLayout(overlayID){
	 	var content = ""+
	 			"<div id='responseNote'>"+
					"<div class='ibm-common-overlay ibm-overlay-alt' id="+overlayID+">"+
						"<div class='ibm-head'>"+
							"<p><a class='ibm-common-overlay-close' href='#close'>Close [x]</a></p>"+
						"</div>"+
						"<div class='ibm-body'>"+
							"<div class='ibm-main'>"+
							"<div class='ibm-title ibm-subtitle'>"+
								"<h1><div id='processNoteTitle'></div></h1>"+
							"</div>"+
							"<div class='ibm-container ibm-alternate ibm-buttons-last'>"+
								"<div class='ibm-container-body'>"+
									"<p class='ibm-overlay-intro'>"+'<%= messages.getString("required_info") %>'+".</p>"+
									"<div id='MsgNote'></div>"+
									"<div id='formNoteLoc'>"+
										"<div id='topageidaddnote'></div>"+
										"<div id='logactionidaddnote'></div>"+
										"<div class='pClass'><label for='notevalue'>"+'<%= messages.getString("device_note_value") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='notevalue'></div></span></div>"+
										"<div class='ibm-overlay-rule'><hr /></div>"+
										"<div class='ibm-buttons-row'>"+
										"<div class='pClass'><span>"+
										"<div id='submit_note_button'></div>"+
										"</span></div>"+
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
	 
	 function clearNoteValues(){
	 	if (getID("MsgNote")) getID("MsgNote").innerHTML = "";
		setWidgetIDValue('notevalue', '');
	 } //clearValues
	 
	 function openNoteDiag(overlay,cprouting,step) {
        //locDiag.show();
        clearValues();
        var pop = 'addNoteprocess';
        var title = '';
        var topageid = getID('topageidnote');
        var logactionid = getID('logactionidnote');
        var cproutingid = getID('cproutingid');
        var logaction = " has been added";
        title = '<%= messages.getString("add_routing_step_note") %>';
        topageid.value = '7105';
        cproutingid.value = cprouting;
        logactionid.value = "Routing step note for request <%= Reqnum %>, step " + step + logaction;
        getID("processNoteTitle").innerHTML = title;
        setWidgetIDValue('notevalue','');
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editNoteDiag(cprouting, cpnotesid, notevalue, step) {
        //locDiag.show();
        clearValues();
		var pop = 'addNoteprocess';
        var title = '';
        var topageid = getID('topageidnote');
        var logactionid = getID('logactionidnote');
        var cproutingid = getID('cproutingid');
        var logaction = " has been updated";
        title = '<%= messages.getString("edit_routing_step_note") %>';
        topageid.value = '7135';
        cproutingid.value = cprouting;
        logactionid.value = "Routing step note for request <%= Reqnum %>, step " + step + logaction;
        createHiddenInput('logactionidaddnote','cpnotesid',cpnotesid);
        getID("processNoteTitle").innerHTML = title;
        setWidgetIDValue('notevalue', notevalue);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeNoteLoc(loc){
     	var pop = 'addNoteprocess';
        getID("MsgNote").innerHTML = "";
		setWidgetIDValue('notevalue', '');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     var addNoteInfo = function(){
 		var title = "Title";
 		var content = createNoteLayout('addNoteprocess');
 		createDialog(title,content,'processNoteDiag');
 		createpTag();
 		createHiddenInput('topageidaddnote','<%= BehaviorConstants.TOPAGE %>','','topageidnote');
        createHiddenInput('logactionidaddnote','logaction','','logactionidnote');
        createHiddenInput('logactionidaddnote','cproutingid','','cproutingid');
        createTextArea('notevalue', 'notevalue', '', '');
        changeCommentStyle('notevalue','390px');
        createInputButton('submit_note_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_note_process','addNote()');
 		createSpan('submit_note_button','ibm-sep');
	 	createInputButton('submit_note_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_note_process','closeNoteLoc(\'admin_note\')');
 		createPostForm('formNoteLoc', 'adminNoteForm','adminNoteForm','ibm-column-form','<%= commonprocess %>');
	 }; //function
	 
	 dojo.addOnLoad(addNoteInfo);  //addOnLoad
	 
	 function addNote() {
	 	//var formName = getWidgetID("adminNoteForm");
        var formValid = true;
        var notevalue = getWidgetID("notevalue");
        var logactionid = getID('logactionidnote');
        var msg = logactionid.value;
        if (notevalue.value == "") {
        	alert ("<%= messages.getString("please_enter_all_required_fields") %>");
        	formValid = false;
        	return false;
        }
        if (notevalue.value.length > 1024) {
        	alert ("<%= messages.getString("device_note_limit_1024") %>");
        	formValid = false;
        	return false;
        }
		if (formValid) {
			if (submitForm('adminNoteForm',msg)) {
				//location.reload();
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			return false;
		}
	} //addNote
	
    function submitNoteForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("MsgNote").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Routing step note already exists.  Please use a different note value.'+"</p>";
	   				submitted = false;
	   			} else if (data.indexOf("Unknown") > -1) {
	   				getID("MsgNote").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'There was an error in the request'+"</p>";
	   				submitted = false;
	   			} else {
	   				getID("MsgNote").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				//location.reload();
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           	submitted = false;
	           	console.log(error);
	               getID("MsgNote").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           }
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
    
    function setNoteFormValues(cpnotesid, msg){
		var topageid = "";
		topageid = "7140";
		createHiddenInput('logactionid','cpnotesid',cpnotesid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callNoteDelete(cpnotesid, step) {
    	var cpnotesvalue = "for request <%= Reqnum %>, step " + step;
		var msg = "Routing step note " + cpnotesvalue + " has been deleted";
		setNoteFormValues(cpnotesid, msg);
		var confirmDelete = confirm('<%= messages.getString("routing_step_note_sure_delete") %> ' + ' request <%= Reqnum %>, step ' + step + "?");
		if (confirmDelete) {
			deleteNoteFunction(msg, cpnotesvalue);
			//location.reload();
			AddParameter("logaction", msg);
		} //if yesno
	}
	
	function deleteNoteFunction(msg,ofname){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. CP Notes " + ofname +" may be currently assigned to a routing step</p>";
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
	
	 //-- End of CP Notes stuff --
	 
	 dojo.ready(function() {
	 	createpTag();
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= commonprocess %>');  
        var bodyHTML = getID('deleteForm').innerHTML;
        <% if (pupb.getValidSession() == null || pupb.getUserFirstName() == null) {	%>
	 		openDiag();
	 		getID('deleteForm').innerHTML = "";
		<% } else { %>   
			getID('deleteForm').innerHTML = bodyHTML;
		<% } %>
		<% if (!logaction.equals("")){ %>
        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        createToolTip('<%= messages.getString("cp_complete_step_help") %>', 'completeId');
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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
				<% if (referer.equals("540")) { %>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=540&reqstatus=<%= request.getParameter("reqstatus") %>&actiontype=<%= Action.toUpperCase() %>&orderby=<%= request.getParameter("orderby") %>"><%= messages.getString("requests_results") %></a></li>
				<% } else if (referer.equals("545")) { %>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=545&reqstatus_steps=<%= request.getParameter("reqstatus_steps") %>&stepstatus=<%= request.getParameter("stepstatus") %>&actiontype_steps=<%= Action.toUpperCase() %>&orderby_steps=<%= request.getParameter("orderby_steps") %>"><%= messages.getString("requests_results") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getStringArgs("cp_manage_device", new String[] {Action.toLowerCase(), devicename}) %></h1>
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
			<li><a href="javascript:callModifyRequest('<%= cpapprovalid %>','<%= Action %>');"><%= messages.getString("cp_modify_control_info") %></a></li>
			<% if (deviceid == 0) { %>
			<li><p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("device_not_found", new String[] {devicename}) %></p></li>
			<% } else { %>
			<li><%= messages.getString("cp_modify_device_info") %></li>
			<% } %>
			<% if(Action.toUpperCase().equals("CHANGE")) {%><li><%= messages.getString("compare_change_requested") %></li><% } %>
		</ul>
		
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("request_control") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='reqnum'><%= messages.getString("device_request_number") %>:</label>
					<%= Reqnum %>
				</div>
				<div class="pClass">
					<label for='reqstatus'><%= messages.getString("request_status") %>:</label>
					<%= ReqStatus %>
				</div>
				<div class="pClass">
					<label for='actiontype'><%= messages.getString("request_action") %>:</label>
					<% if(Action.toUpperCase().equals("CHANGE")) { %><a href="javascript:openDeviceCompare('<%= cpapprovalid %>','<%= devicename %>');"> <% } else {%> <% } %><%= Action %>
				</div>
				<div class="pClass">
					<label for='devicename'><%= messages.getString("device_name") %>:</label>
					<a href="javascript:openDeviceAdmin();"><%= devicename %></a>
				</div>
				<div class="pClass">
					<label for='devfunc'><%= messages.getString("device_functions") %>:</label>
					<%	if (DeviceType_RS.getResultSetSize() > 0 ) {
							DeviceType_RS.first();
							while(DeviceType_RS.next()) { 
								while (devFuncCounter < aFunctions.length) {
									if (aFunctions[devFuncCounter] != null && DeviceType_RS.getString("CATEGORY_VALUE1").toLowerCase().equals(aFunctions[devFuncCounter])) {	%>
										<%= aFunctions[devFuncCounter] %>,
							<% 			devFuncCounter++;
										break;
									} else {  %>
							<%			devFuncCounter++;
									} //if they're equal %>
							<%	} //while devicefunction
								devFuncCounter = 0; %>
						<%	} //while
						} //if > 0 %>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_location_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='geo'><%= messages.getString("geography") %>:</label>
					<%= Geo %>
				</div>
				<div class="pClass">
					<label for='country'><%= messages.getString("country") %>:</label>
					<%= Country %>
				</div>
				<div class="pClass">
					<label for='city'><%= messages.getString("city") %>:</label>
					<%= City %>
				</div>
				<div class="pClass">
					<label for='building'><%= messages.getString("building") %>:</label>
					<%= Building %>
				</div>
				<div class="pClass">
					<label for='floor'><%= messages.getString("floor") %>:</label>
					<%= Floor %>
				</div>
				<div class="pClass">
					<label for='room'><%= messages.getString("room") %>:</label>
					<%= Room %>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("requester_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='reqname'><%= messages.getString("requester_name") %>:</label>
					<%= Requester %>
				</div>
				<div class="pClass">
					<label for='email'><%= messages.getString("email_address") %>:</label>
					<%= Email %>
				</div>
				<div class="pClass">
					<label for='phone'><%= messages.getString("phone") %>:</label>
					<%= Tie %>
				</div>
				<div class="pClass">
					<label for='datereq'><%= messages.getString("requested_completion_date") %>:</label>
					<%= Reqdate %>
				</div>
				<div class="pClass">
					<label for='justification'><%= messages.getString("justification") %>:</label>
					<%= Reqjust %>
				</div>
				<br />
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display device enablements">
					<caption><em><%= messages.getString("prt_enbl") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("client_server") %></th>
							<th scope="col"><%= messages.getString("vm") %></th>
							<th scope="col"><%= messages.getString("mvs") %></th>
							<th scope="col"><%= messages.getString("sap") %></th>
							<th scope="col"><%= messages.getString("wts") %></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><%= Cs %></td>
							<td><%= Vm %></td>
							<td><%= Mvs %></td>
							<td><%= Sap %></td> 
							<td><%= Wts %></td>
						</tr>
					</tbody>
				</table> 
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Lists the routing information for a particular device">
					<caption><em><%= messages.getString("request_routing") %> - <a href="javascript:callModifyRouting('<%= cpapprovalid %>','<%= Reqnum %>');"><%= messages.getString("cp_admin_routing_info") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("step") %></th>
							<th scope="col"><%= messages.getString("action_type") %></th>
							<th scope="col"><%= messages.getString("status") %></th>
							<th scope="col"><%= messages.getString("assignee") %></th>
							<th scope="col"><%= messages.getString("start_date") %></th>
							<th scope="col"><%= messages.getString("action") %></th>
						</tr>
					</thead>
					<tbody>
						<%	int counter = 0;
							while(RoutingInfo_RS.next()) {
								step= RoutingInfo_RS.getInt("STEP");
								actiontype = RoutingInfo_RS.getString("ACTION_TYPE");
								status = RoutingInfo_RS.getString("STATUS");
								assignee = RoutingInfo_RS.getString("ASSIGNEE");
								startdate = RoutingInfo_RS.getString("START_DATE");
								wholenote = appTool.html2text(appTool.nullStringConverter(RoutingInfo_RS.getString("NOTE_VALUE")));
								createdby = RoutingInfo_RS.getString("CREATED_BY");
								if (wholenote == null) wholenote = "";
								try {
									if (startdate != null && !startdate.equals("")) {
								    	dValid = dateFormat.parse(startdate);
								    	startdate = dateFormat2.format(dValid);
							    	} else {
								    	startdate = "";
								    }
							  	}
							  	catch(NullPointerException e) {
							  		startdate = "";
								    //Ignore any null pointer exceptions that may occur
								    //dValidStart is still null, so a start date won't be used
							  	}
							  	catch(Exception e) {
							  		startdate = RoutingInfo_RS.getString("START_DATE");
								    //If startdate is already at dd mm yyyy format, then leave as is
							  	}
							  	datework = RoutingInfo_RS.getTimeStamp("DATE_TIME")+"";
							  	if ((datework == null) || (datework.equals("null")) || (datework.equals(""))) {
									datetime_created = "";
								} else {
									datetime_created = dateTime.formatTime(datework);
								}
								
								cproutingid = RoutingInfo_RS.getInt("CPROUTINGID");
								//cpnotesid = RoutingInfo_RS.getInt("CPNOTESID");
								if (startdate == null) { startdate = ""; }
						%>
						<% if (cproutingid != prevcproutingid) {
							prevcproutingid = cproutingid;
							if (status.toLowerCase().equals("in progress")) {
								fontstart = "<b>";
								fontend = "</b>";
							} else {
								fontstart = "";
								fontend = "";
							} %>
						<tr>
							<td><a href="javascript:callModifyRoutingStep('<%= cproutingid %>');"/><%= fontstart %><%= step %><%= fontend %></a></td>
							<td><%= fontstart %><%= actiontype %><%= fontend %></td>
							<td><%= fontstart %><%= status %><%= fontend %></td>
							<td><%= fontstart %><%= assignee %><%= fontend %></td>
							<td><%= fontstart %><%= startdate %><%= fontend %></td>
							<td>
							<ul>
							<% if (status.toLowerCase().equals("in progress")) { %>
								<li>
									<a id="completeId" href="javascript:callCompleteRoutingStep('<%= cproutingid %>');"><%= messages.getString("complete_step") %></a>
									<a class="ibm-information-link"></a>
								</li>	
							<% } %>
								<li><a class="ibm-maximize-link" href="javascript:void(0);" onClick="javascript:callAddNote('<%= cproutingid %>','<%= step %>');"><%= messages.getString("add_note") %></a></li>
							</ul>
							</td>
						</tr>
						<% if (!wholenote.equals("")) { %>
						<tr>
							<td></td>
							<td colspan="5">
								<b><%= messages.getString("notes") %></b>:
							</td>
						</tr>
						<% 	RoutingInfo_RS_2.first();
							while(RoutingInfo_RS_2.next()) { 
								int thiscproutingid = RoutingInfo_RS_2.getInt("CPROUTINGID");
								cpnotesid = RoutingInfo_RS_2.getInt("CP_NOTESID");
								wholenote = appTool.html2text(appTool.nullStringConverter(RoutingInfo_RS_2.getString("NOTE_VALUE")));
								createdby = RoutingInfo_RS_2.getString("CREATED_BY");
								Timestamp datetime = RoutingInfo_RS_2.getTimeStamp("NOTES_DATE_TIME");
								if (createdby == null || createdby.equals("")) { createdby = "none"; }
						%>
						<% 	if (cproutingid == thiscproutingid) { %>
						<tr>
							<td></td>
							<td colspan="4"><%= wholenote %> (<%= createdby %> - <%= dateTime.formatTimeStamp(datetime) %>)  </td>
							<td>
								<ul>
									<li><a class="ibm-signin-link" href="javascript:void(0);" onClick="javascript:var wholenote='<%= wholenote.replace("&#39;", "\\'") %>'; callEditNote('<%= cproutingid %>','<%= cpnotesid %>',wholenote,'<%= step %>');"><%= messages.getString("update") %></a></li>
									<li><a class="ibm-delete-link" href="javascript:void(0);" onClick="javascript:callNoteDelete('<%= cpnotesid %>','<%= step %>');"><%= messages.getString("delete") %></a></li>
								</ul>
							</td>
						</tr>
						<% 	} //if cproutingid equal %>
					<% 	} //while %>
				<% 		} //if wholenote != "" %>
			<%  		}  //if not equal
					}  //while CPRoutingView_RS	%>
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