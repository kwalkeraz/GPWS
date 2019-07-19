<%
	TableQueryBhvr ServerProtocolSpooler  = (TableQueryBhvr) request.getAttribute("ServerProtocolSpooler");
	TableQueryBhvrResultSet ServerProtocolSpooler_RS = ServerProtocolSpooler.getResults();
	TableQueryBhvr ServerProtocolSupervisor  = (TableQueryBhvr) request.getAttribute("ServerProtocolSupervisor");
	TableQueryBhvrResultSet ServerProtocolSupervisor_RS = ServerProtocolSupervisor.getResults();
	TableQueryBhvr ServerProtocolComm  = (TableQueryBhvr) request.getAttribute("ServerProtocolComm");
	TableQueryBhvrResultSet ServerProtocolComm_RS = ServerProtocolComm.getResults();
	TableQueryBhvr CommSupervisorSpooler  = (TableQueryBhvr) request.getAttribute("CommSupervisorSpooler");
	TableQueryBhvrResultSet CommSupervisorSpooler_RS = CommSupervisorSpooler.getResults();
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String server = request.getParameter("server");
	String sdc = request.getParameter("sdc");
	String protocol = request.getParameter("protocol");
	String referer = request.getParameter("referer");
	String serverprotocolid = request.getParameter("serverprotocolid");  
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view server process"/>
	<meta name="Description" content="Global print website view server process information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_server_protocol_combo") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");

	function addSpoolerInfo(dID){
	 	<%if (ServerProtocolSpooler_RS.getResultSetSize() > 0) {
   		while(ServerProtocolSpooler_RS.next()) {
			String spooler = ServerProtocolSpooler_RS.getString("SPOOLER"); 
			int spoolerid = ServerProtocolSpooler_RS.getInt("SERVER_PROTOCOL_SPOOLERID");%>
   			var optionName = "<%= spooler %>";
   			var optionValue = "<%= spoolerid %>";
   			addOption(dID,optionName,optionValue);
   		<% } 
   		} else {%>
   			getID("nospooler").innerHTML = '<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7405&serverprotocolid=<%= serverprotocolid %>&server=<%= server %>&protocol=<%= protocol %>&sdc=<%= sdc %>&referer=<%= referer %>"><%= messages.getString("please_define_spooler") %></a>';
   	 <% } %>
	 } //addSpoolerInfo
	 
	 function addSupervisorInfo(dID){
	 	<% if (ServerProtocolSupervisor_RS.getResultSetSize() > 0) {
   		while(ServerProtocolSupervisor_RS.next()) {
			String supervisor = ServerProtocolSupervisor_RS.getString("SUPERVISOR"); 
			int supervisorid = ServerProtocolSupervisor_RS.getInt("SERVER_PROTOCOL_SUPERVISORID");%>
   			var optionName = "<%= supervisor %>";
   			var optionValue = "<%= supervisorid %>";
   			addOption(dID,optionName,optionValue);
   		<% } 
   		} else {%>
   			getID("nosuper").innerHTML = '<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7405&serverprotocolid=<%= serverprotocolid %>&server=<%= server %>&protocol=<%= protocol %>&sdc=<%= sdc %>&referer=<%= referer %>"><%= messages.getString("please_define_supervisor") %></a>';
   	 <% } %>
	 } //addSupervisorInfo
	 
	 function addCommInfo(dID){
	 	<%if (ServerProtocolComm_RS.getResultSetSize() > 0) {
   		while(ServerProtocolComm_RS.next()) {
			String comm = ServerProtocolComm_RS.getString("COMM"); 
			int commid = ServerProtocolComm_RS.getInt("SERVER_PROTOCOL_COMMID");%>
   			var optionName = "<%= comm %>";
   			var optionValue = "<%= commid %>";
   			addOption(dID,optionName,optionValue);
   		<% } 
   		} else { %>
   			getID("nocomm").innerHTML = '<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7405&serverprotocolid=<%= serverprotocolid %>&server=<%= server %>&protocol=<%= protocol %>&sdc=<%= sdc %>&referer=<%= referer %>"><%= messages.getString("please_define_comm") %></a>';
   	 <% } %>
	 } //addCommInfo
	 
	 function createLayout(overlayID){
	 	var content = ""+
	 			"<div id='response'>"+
					"<div class='ibm-common-overlay' id="+overlayID+">"+
						"<div class='ibm-head'>"+
							"<p><a class='ibm-common-overlay-close' href='javascript:closeLoc();'>Close [x]</a></p>"+
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
										"<div class='pClass'><label for='spooler'>"+'<%= messages.getString("spooler") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='spoolerloc'></div></span></div>"+
										"<div id='spoolerID' connectId='spooler' align='right'></div>"+
										"<div class='pClass'><label for='supervisor'>"+'<%= messages.getString("supervisor") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='superloc'></div></span></div>"+
										"<div id='superID' connectId='supervisor' align='right'></div>"+
										"<div class='pClass'><label for='comm'>"+'<%= messages.getString("communicator") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='commloc'></div></span></div>"+
										"<div id='commID' connectId='comm' align='right'></div>"+
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
        autoSelectValue('spooler','None');
        autoSelectValue('supervisor','None');
        autoSelectValue('comm','None');
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = "Server-Protocol process combination for server " + "<%= server %>" + " and protocol " + "<%= protocol %>" + " has been added";
        title = 'Add a new combination';
        topageid.value = '7421';
        logactionid.value = logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openDiag
     
     function editDiag(overlay, commspoolersuperid, spoolerid, superid, commid) {
        //locDiag.show();
        getID("Msg").innerHTML = "";
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = "Server-Protocol process combination for server " + "<%= server %>" + " and protocol " + "<%= protocol %>" + " has been updated";
        title = 'Edit a combo';
       	topageid.value = '7423';
       	logactionid.value = logaction;
       	createHiddenInput('logactioniddiag','commspoolsuperid',commspoolersuperid);
        getID("processTitle").innerHTML = title;
        autoSelectValue('spooler',spoolerid);
        autoSelectValue('supervisor',superid);
        autoSelectValue('comm',commid);
		ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function setFormValues(commspoolersuperid, msg){
		var topageid = "7422";
		createHiddenInput('logactionid','commspoolsuperid',commspoolersuperid);
		setValue('topageiddel',topageid);
		setValue('logactioniddel',msg);
	} //setFormValues
     
     function callDelete(commspoolersuperid, comboname) {
		var msg = "Server-Protocol process combination " + comboname + " has been deleted";
		setFormValues(commspoolersuperid, msg);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_process") %> ' + comboname + "?");
		if (confirmDelete) {
			deleteFunction(msg, comboname);
			//location.reload();
			AddParameter(dojo.byId('logactioniddel').name, dojo.byId('logactioniddel').value);
		} //if yesno
	};
	
	function deleteFunction(msg,comboname){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Process " + comboname +" may be currently assigned to a printer</p>";
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
    
     
     function closeLoc(loc){
     	var pop = 'addprocess';
     	dijit.hideTooltip(getID('spooler'));
     	dijit.hideTooltip(getID('supervisor'));
     	dijit.hideTooltip(getID('comm'));
        getID("Msg").innerHTML = "";
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function addCombo(event) {
	 	var spooler = getSelectValue('spooler');
	 	var supervisor = getSelectValue('supervisor');
	 	var comm = getSelectValue('comm');
	 	var logactionid = getID('logactionidadd');
		var msg = logactionid.value;
   		if (spooler == "None") {
			showReqMsg('<%= messages.getString("please_select_spooler") %>','spooler');
			return false;
		}
		if (supervisor == "None") {
			showReqMsg('<%= messages.getString("please_select_supervisor") %>','supervisor');
			return false;
		}
		if (comm == "None") {
			showReqMsg('<%= messages.getString("please_select_comm") %>','comm');
			return false;
		}
		submitForm('addProcessForm',msg);
		//location.reload();
		AddParameter(logactionid.name, logactionid.value);
	 }; //addCombo
	 
	 function submitForm(form,msg){
	 	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("process_combo_exists") %>.'+"</p>";
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
	               dojo.byId("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           }
	        };
	     dojo.xhrPost(xhrArgs);
    } //submitForm
    
	 var addComboInfo = function() {
		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','serverprotocolid','<%= serverprotocolid %>');
     	createSelect('spooler', 'spooler', '<%= messages.getString("please_select_spooler") %>', 'None', 'spoolerloc');
        createSelect('supervisor', 'supervisor', '<%= messages.getString("please_select_supervisor") %>', 'None', 'superloc');
        createSelect('comm', 'comm', '<%= messages.getString("please_select_comm") %>', 'None', 'commloc');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addCombo()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_spooler\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
        addSpoolerInfo('spooler');
        addSupervisorInfo('supervisor');
        addCommInfo('comm');
	};
	
	dojo.addOnLoad(addComboInfo);  //addOnLoad
	
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7405&serverprotocolid=<%= serverprotocolid %>&server=<%= server %>&protocol=<%= protocol %>&sdc=<%= sdc %>&referer=<%= referer %>"><%= messages.getString("administer_server_protocol_process") %></a> </li>
			</ul>
			<h1><%= messages.getString("administer_server_protocol_combo") %></h1>
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
			<li><%= messages.getString("add_new_combo_info") %></li>
			<li><%= messages.getString("edit_combo_info") %></li>
			<li><%= messages.getString("delete_combo_info") %></li>
		</ul>
		<p><a href="javascript:void(0);" onClick="openDiag('add_combo');"><%= messages.getString("add_new_combo") %></a></p>
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
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available spooler-supervisor-communicator combinations for the specified server and protocol">
					<caption><em><%= messages.getString("server_protocol_combo") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("spooler") %></th>
							<th scope="col"><%= messages.getString("supervisor") %></th>
							<th scope="col"><%= messages.getString("communicator") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% if (CommSupervisorSpooler_RS.getResultSetSize() > 0) {
							while (CommSupervisorSpooler_RS.next()) { %>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= CommSupervisorSpooler_RS.getString("SPOOLER")%>:<%= CommSupervisorSpooler_RS.getString("SPOOLER_PORT")%>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= CommSupervisorSpooler_RS.getString("SUPERVISOR")%>:<%= CommSupervisorSpooler_RS.getString("SUPERVISOR_PORT")%>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= CommSupervisorSpooler_RS.getString("COMM")%>:<%= CommSupervisorSpooler_RS.getString("COMM_PORT")%>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('edit_combo', '<%= CommSupervisorSpooler_RS.getInt("COMM_SPOOL_SUPERID") %>', '<%= CommSupervisorSpooler_RS.getInt("SERVER_PROTOCOL_SPOOLERID") %>', '<%= CommSupervisorSpooler_RS.getInt("SERVER_PROTOCOL_SUPERVISORID") %>', '<%= CommSupervisorSpooler_RS.getInt("SERVER_PROTOCOL_COMMID") %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= CommSupervisorSpooler_RS.getInt("COMM_SPOOL_SUPERID") %>', '<%= CommSupervisorSpooler_RS.getString("SPOOLER") %>:<%= CommSupervisorSpooler_RS.getString("SUPERVISOR") %>:<%= CommSupervisorSpooler_RS.getString("COMM") %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
					<%		} //while
						}  %>
						<tr>
							<th class="ibm-table-row" scope="row"><div id='nospooler'></div></th>
							<td><div id='nosuper'></div></td>
							<td><div id='nocomm'></div></td>
						</tr>
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