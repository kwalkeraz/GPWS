<%
	TableQueryBhvr ServerProtocolSpooler  = (TableQueryBhvr) request.getAttribute("ServerProtocolSpooler");
	TableQueryBhvrResultSet ServerProtocolSpooler_RS = ServerProtocolSpooler.getResults();
	TableQueryBhvr ServerProtocolSupervisor  = (TableQueryBhvr) request.getAttribute("ServerProtocolSupervisor");
	TableQueryBhvrResultSet ServerProtocolSupervisor_RS = ServerProtocolSupervisor.getResults();
	TableQueryBhvr ServerProtocolComm  = (TableQueryBhvr) request.getAttribute("ServerProtocolComm");
	TableQueryBhvrResultSet ServerProtocolComm_RS = ServerProtocolComm.getResults();
	AppTools appTool = new AppTools();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String server = request.getParameter("server");
	String sdc = request.getParameter("sdc");
	String protocol = request.getParameter("protocol");
	String serverprotocolid = request.getParameter("serverprotocolid");   
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view server process"/>
	<meta name="Description" content="Global print website view server process information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_server_protocol_process") %> </title>
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
										"<div class='pClass'><label for='procname'>"+'<%= messages.getString("name") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='procnameid'></div></span></div>"+
										"<div class='pClass'><label for='port'>"+'<%= messages.getString("port") %>'+":<span id='reqPort' class='ibm-required'>*</span></label>"+
										"<span><div id='portid'></div></span></div>"+
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
        getID("Msg").innerHTML = "";
		setWidgetIDValue('process','');
		setWidgetIDValue('port','');
		dojo.style('reqPort',"display",'none');
		getWidgetID('port').set('required',false);
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        if (overlay == 'add_spooler') {
        	title = '<%= messages.getString("add_new_spooler") %>';
        	dojo.style('reqPort',"display",'none');
        	topageid.value = '7401';
        	logactionid.value = "Spooler" + logaction;
        } else if (overlay =='add_supervisor') {
        	title = '<%= messages.getString("add_new_supervisor") %>';
        	dojo.style('reqPort',"display",'none');
        	topageid.value = '7402';
        	logactionid.value = "Supervisor" + logaction;
        } else if (overlay =='add_comm') {
        	var port = dijit.byId('port');
        	title = '<%= messages.getString("add_new_comm") %>';
        	dojo.style('reqPort',"display",'inline');
        	port.set('required',true);
        	port.set('promptMessage','<%= messages.getString("required_info") %>');
        	topageid.value = '7403';
        	logactionid.value = "Communicator" + logaction;
        }
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(overlay,processid, process, port) {
        //locDiag.show();
        getID("Msg").innerHTML = "";
		setWidgetIDValue('process','');
		setWidgetIDValue('port','');
		dojo.style('reqPort',"display",'none');
		getWidgetID('port').set('required',false);
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        if (overlay == 'edit_spooler') {
        	title = '<%= messages.getString("edit_spooler") %>';
        	dojo.style('reqPort',"display",'none');
        	topageid.value = '7406';
        	logactionid.value = "Spooler" + logaction;
        	createHiddenInput('logactioniddiag','serverprotocolspoolerid',processid);
        } else if (overlay =='edit_supervisor') {
        	title = '<%= messages.getString("edit_supervisor") %>';
        	dojo.style('reqPort',"display",'none');
        	topageid.value = '7407';
        	logactionid.value = "Supervisor" + logaction;
        	createHiddenInput('logactioniddiag','serverprotocolsupervisorid',processid);
        } else if (overlay =='edit_comm') {
        	var portw = dijit.byId('port');
        	title = '<%= messages.getString("edit_comm") %>';
        	dojo.style('reqPort',"display",'inline');
        	portw.set('required',true);
        	portw.set('promptMessage','<%= messages.getString("required_info") %>');
        	topageid.value = '7408';
        	logactionid.value = "Communicator" + logaction;
        	createHiddenInput('logactioniddiag','serverprotocolcommid',processid);
        }
        getID("processTitle").innerHTML = title;
        setWidgetIDValue('process',process);
        setWidgetIDValue('port',port);
		ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
		setWidgetIDValue('process','');
		setWidgetIDValue('port','');
     	ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     /**
	 	Add spooler
	 **/          
	 var addSpoolerInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','serverprotocolid','<%= serverprotocolid %>');
        createTextInput('procnameid','process','process','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
        createTextInput('portid','port','port','16',false,'','','<%= messages.getString("field_problems") %>','^[0-9]+$','');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addSpooler(dojo.query(\"label[for=procname]\").innerHTML)');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_spooler\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addSpoolerInfo);  //addOnLoad
	 
	 function addSpooler(event) {
	 	var formName = dijit.byId("addProcessForm");
        var formValid = false;
        var wName = getWidgetIDValue('process');
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
		if (formValid) {
			submitForm('addProcessForm',msg);
			//location.reload();
			AddParameter(logactionid.name, logactionid.value);
		} else {
			return false;
		}
	}; //addSpooler
	
    function submitForm(form,msg){
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Process already exists.  Please use different name.'+"</p>";
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
	           }
	        };
	     dojo.xhrPost(xhrArgs);
    } //submitForm
    
    function setFormValues(process, processid, msg){
		var topageid = "";
		if (process == "Spooler") {
			topageid = "7409";
			createHiddenInput('logactionid','serverprotocolspoolerid',processid);
		} else if (process == "Supervisor"){
			topageid = "7410";
			createHiddenInput('logactionid','serverprotocolsupervisorid',processid);
		} else {
			topageid = "7411";
			createHiddenInput('logactionid','serverprotocolcommid',processid);
		}
		setValue('topageiddel',topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(process, procname, processid) {
		var msg = process + " " + procname + " has been deleted";
		setFormValues(process, processid, msg);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_process") %> ' + process + " " + procname + "?");
		if (confirmDelete) {
			deleteFunction(msg, procname);
			location.reload();
		} //if yesno
	};
	
	function deleteFunction(msg,procname){
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Process " + procname +" may be currently assigned to a printer</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
	} //deleteFunction
    
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
	});
	
	function callAdminCombo(serverprotocolid, server, protocol, sdc, referer) {
		var params = "&serverprotocolid=" + serverprotocolid + "&server=" + server + "&protocol=" + protocol + "&sdc=" + sdc + "&referer=" + referer;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7420" + params;
	} //callAdminCombo
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5010"><%= messages.getString("server_select_location") %></a></li>
				<% if (request.getParameter("referer").equals("5021")) {%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5021&sdc=<%= request.getParameter("sdc") %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } else if (request.getParameter("referer").equals("5022")){%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5022&server=<%= server.toUpperCase() %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } else {%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7400"><%= messages.getString("select_server_protocol_process") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("administer_server_protocol_process") %></h1>
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
			<li><%= messages.getString("add_new_process_info") %></li>
			<li><%= messages.getString("edit_process_info") %></li>
			<li><%= messages.getString("delete_process_info") %></li>
		</ul>
		<p><a href="javascript:callAdminCombo('<%= serverprotocolid %>','<%= server %>','<%= protocol %>','<%= sdc %>','<%= request.getParameter("referer") %>');"><%= messages.getString("administer_server_protocol_combo") %></a></p>
		<% if (!logaction.equals("")) { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %></p>
		<% } %>
		<p><%= messages.getString("server_name") %>: <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5022&servername=<%= server.toUpperCase() %>"><%= server %></a>
		<br /><%= messages.getString("protocol_name") %>:<%= protocol %></p>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all spoolers">
					<caption><em><%= messages.getString("spooler_info") %> - <a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_spooler');"><%= messages.getString("add_new_spooler") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("spooler") %></th>
							<th scope="col"><%= messages.getString("port") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% if (ServerProtocolSpooler_RS.getResultSetSize() > 0 ) { %> 
							<% while(ServerProtocolSpooler_RS.next()) { %>
						<tr>
							<th class="ibm-table-row" scope="row"><%= ServerProtocolSpooler_RS.getString("SPOOLER") %></th>
							<td><%= ServerProtocolSpooler_RS.getString("PORT") %></td>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('edit_spooler', '<%= ServerProtocolSpooler_RS.getInt("SERVER_PROTOCOL_SPOOLERID") %>', '<%= ServerProtocolSpooler_RS.getString("SPOOLER") %>', '<%= ServerProtocolSpooler_RS.getString("PORT") %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('Spooler', '<%= ServerProtocolSpooler_RS.getString("SPOOLER") %>', '<%= ServerProtocolSpooler_RS.getInt("SERVER_PROTOCOL_SPOOLERID") %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_spooler_found") %></th>
						</tr>
						<% } %>
					</tbody>
				</table> 
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all supervisors">
					<caption><em><%= messages.getString("supervisor_info") %> - <a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_supervisor')"><%= messages.getString("add_new_supervisor") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("supervisor") %></th>
							<th scope="col"><%= messages.getString("port") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% if (ServerProtocolSupervisor_RS.getResultSetSize() > 0 ) { %> 
							<% while(ServerProtocolSupervisor_RS.next()) { %>
						<tr>
							<th class="ibm-table-row" scope="row"><%= ServerProtocolSupervisor_RS.getString("SUPERVISOR") %></th>
							<td><%= ServerProtocolSupervisor_RS.getString("PORT") %></td>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('edit_supervisor', '<%= ServerProtocolSupervisor_RS.getInt("SERVER_PROTOCOL_SUPERVISORID") %>', '<%= ServerProtocolSupervisor_RS.getString("SUPERVISOR") %>', '<%= ServerProtocolSupervisor_RS.getString("PORT") %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('Supervisor', '<%= ServerProtocolSupervisor_RS.getString("SUPERVISOR") %>', '<%= ServerProtocolSupervisor_RS.getInt("SERVER_PROTOCOL_SUPERVISORID") %>')"><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_supervisor_found") %></th>
						</tr>
						<% } %>
					</tbody>
				</table> 
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all communicators">
					<caption><em><%= messages.getString("comm_info") %> - <a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_comm')"><%= messages.getString("add_new_comm") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("communicator") %></th>
							<th scope="col"><%= messages.getString("port") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% if (ServerProtocolComm_RS.getResultSetSize() > 0 ) { %> 
							<% while(ServerProtocolComm_RS.next()) { %>
						<tr>
							<th class="ibm-table-row" scope="row"><%= ServerProtocolComm_RS.getString("COMM") %></th>
							<td><%= ServerProtocolComm_RS.getString("PORT") %></td>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('edit_comm', '<%= ServerProtocolComm_RS.getInt("SERVER_PROTOCOL_COMMID") %>', '<%= ServerProtocolComm_RS.getString("COMM") %>', '<%= ServerProtocolComm_RS.getString("PORT") %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('Communicator', '<%= ServerProtocolComm_RS.getString("COMM") %>', '<%= ServerProtocolComm_RS.getInt("SERVER_PROTOCOL_COMMID") %>')"><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_comm_found") %></th>
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