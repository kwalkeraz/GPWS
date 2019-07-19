<%
    TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
   	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
    TableQueryBhvr ProtocolView  = (TableQueryBhvr) request.getAttribute("ProtocolView");
    TableQueryBhvrResultSet ProtocolView_RS = ProtocolView.getResults();
    AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    int osid = 0;
    int protocolid = Integer.parseInt(request.getParameter("protocolid"));
    int os_protocolid = 0;
    String osname = "";
    String osabbr = "";
    String protocol = "";
    String lastprotocol = "";  //the name of the last protocol loaded
    String protocol_type = "";   
    String version = "";
    String sPackage = ""; 
    String[] osArray = new String[OSView_RS.getResultSetSize()];
    //String[] osabbrArray = new String[OSView_RS.getResultSetSize()];
    int[] osidArray = new int[OSView_RS.getResultSetSize()];
    int oscounter = 0;  //just an os counter
    int x = 0 ;
    while(OSView_RS.next()) {
		osArray[x] = OSView_RS.getString("OS_NAME"); 
		//osabbrArray[x] = OSView_RS.getString("OS_ABBR");
		osidArray[x] = OSView_RS.getInt("OSID");
		x++; 
	} //while OSView 
	
	while(ProtocolView_RS.next()) {
		protocol = ProtocolView_RS.getString("PROTOCOL_NAME"); 
		protocol_type = ProtocolView_RS.getString("PROTOCOL_TYPE"); 
	} // while ProtocolViwe_RS
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website administer os protocol"/>
	<meta name="Description" content="Global print website administer an os specific printer protocol" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("protocol_os_administration") %> </title>
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
									"<div id=\"protocol\"></div>"+
									"<div id=\"osname\"></div>"+
									"<div id='Msg'></div>"+
									"<div id='formLoc'>"+
										"<div id='topageiddiag'></div>"+
										"<div id='logactioniddiag'></div>"+
										"<div class='pClass'><label for='protopkg'>"+'<%= messages.getString("protocol_package") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='protopkgloc'></div></span></div>"+
										"<div class='pClass'><label for='version'>"+'<%= messages.getString("version") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='versionloc'></div></span></div>"+
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
		setWidgetIDValue('package', '')
		setWidgetIDValue('version', '');
	 } //clearValues
	 
	 function openDiag(overlay,osname,protocol,osid,protocolid) {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " has been added";
        title = '<%= messages.getString("protocol_add_os_specific") %>';
        topageid.value = '318_Add';
        logactionid.value = "Protocol " + protocol + " for OS " + osname + logaction;
        getID("processTitle").innerHTML = title;
        setValue("osid", osid);
        setValue("protocolid", protocolid);
        getID("protocol").innerHTML = "<p><%= messages.getString("protocol_name") %>: " + protocol + "</p>";
        getID("osname").innerHTML = "<p><%= messages.getString("os_name") %>: " + osname + "</p><br />";
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(osname,protocol,osid,protocolid,osprotocolid,packageName,version) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " has been updated";
        title = '<%= messages.getString("options_file_edit") %>';
        topageid.value = '319_Edit';
        logactionid.value = "Protocol " + protocol + " for OS " + osname + logaction;
        createHiddenInput('logactioniddiag','osprotocolid',osprotocolid);
        getID("processTitle").innerHTML = title;
        setValue('osid', osid);
        setValue('protocolid', protocolid);
        getID("protocol").innerHTML = '<p><%= messages.getString("protocol_name") %>: ' + protocol + "</p>";
        getID("osname").innerHTML = '<p><%= messages.getString("os_name") %>: ' + osname + "</p><br />";
        setWidgetIDValue('package', packageName);
        setWidgetIDValue('version', version); 
		ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
		setValue('package', '');
		setValue('version', '');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     var addOptionsFileInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','osid','','osid');
        createHiddenInput('logactioniddiag','protocolid','','protocolid');
        createTextInput('protopkgloc','package','package','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,$/-]*$','');
        createTextInput('versionloc','version','version','16',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.,$/-]*$','');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addOSProtocol()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addOptionsFileInfo);  //addOnLoad
	 
	 function addOSProtocol() {
	 	var formName = getWidgetID("addProcessForm");
        var formValid = false;
        var logactionid = getID('logactionidadd');
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
	}; //addSpooler
	
    function submitForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				submitted = false;
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("protocol_os_exists") %>.'+"</p>";
	   			} else if (data.indexOf("Unknown") > -1) {
	   				submitted = false;
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("error_in_request") %>'+"</p>";
	   			} else {
	   				getID("Msg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				//location.reload();
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           		console.log(error);
	           		submitted = false;
	                getID("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           }
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
    
    function setFormValues(osprotocolid, msg){
		var topageid = "";
		topageid = "319_Delete";
		createHiddenInput('logactionid','osprotocolid',osprotocolid,'osprotocolid');
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(osprotocolid, osname, protocol) {
    	getID("Msg").innerHTML = "";
    	getID("response").innerHTML = "";
		var msg = "Protocol " + protocol + " for OS " + osname + " has been deleted.";
		setFormValues(osprotocolid, msg);
		var confirmDelete = confirm('<%= messages.getString("protocol_delete_sure") %> ' + protocol + ' - ' + osname + ' <%= messages.getString("protocol_delete_sure_2") %>' + '?');
		if (confirmDelete) {
			if(deleteFunction(msg, protocol)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //
		} //if yesno
	};
	
	function deleteFunction(msg,protocol){
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
        			getID("response").innerHTML = errorMsg + " Delete Restriction. OS Protocol " + protocol + " may be currently assigned to a printer definition</p>";
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
            sync: syncValue
        };
        dojo.xhrPost(xhrArgs);
        //console.log(submitted);
        return submitted;
	} //deleteFunction
    
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
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=311"><%= messages.getString("protocol_administration") %></a></li>
			</ul>
			<h1 class="ibm-small"><%= messages.getString("protocol_os_administration") %></h1>
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
			<li><%= messages.getString("protocol_os_specific_add_info") %></li>
			<li><%= messages.getString("protocol_os_specific_modify") %></li>
			<li><%= messages.getString("protocol_os_specific_delete") %></li>
		</ul>
		<p><%= messages.getString("protocol_name") %> : <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=312&protocolid=<%= protocolid %>"><%= protocol %></a></p>
		<p><%= messages.getString("protocol_type") %>  : <%= protocol_type %></p>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all OS protocol information">
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("os_name") %></th>
							<th scope="col"><%= messages.getString("protocol_package") %></th>
							<th scope="col"><%= messages.getString("version") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<%  	
								String sValue = "";
								for (int i=0; i < osidArray.length; i++) { 
								boolean found = false;
								ProtocolView_RS.first();
								while(ProtocolView_RS.next()) {
									if (osidArray[i] == ProtocolView_RS.getInt("OSID")) {
										found = true;
										break;
									}
								}
								if (found) {
									sValue = "<tr>"+	
												"<th class='ibm-table-row' scope='row'>"+
													tool.nullStringConverter(ProtocolView_RS.getString("OS_NAME")) +
												"</th>"+
												"<th class='ibm-table-row' scope='row'>"+
													tool.nullStringConverter(ProtocolView_RS.getString("PROTOCOL_PACKAGE")) +
												"</th>"+
												"<th class='ibm-table-row' scope='row'>"+
													tool.nullStringConverter(ProtocolView_RS.getString("PROTOCOL_VERSION")) +
												"</th>"+
												"<td>"+
													"<a class='ibm-signin-link' href='javascript:void(0);' onClick=\"editDiag('"+ ProtocolView_RS.getString("OS_NAME") + "', '"+ ProtocolView_RS.getString("PROTOCOL_NAME") + "', '"+ ProtocolView_RS.getInt("OSID") + "', '"+ ProtocolView_RS.getInt("PROTOCOLID") + "', '"+ ProtocolView_RS.getInt("OS_PROTOCOLID") + "', '"+ tool.nullStringConverter(ProtocolView_RS.getString("PROTOCOL_PACKAGE")) +"', '"+ tool.nullStringConverter(ProtocolView_RS.getString("PROTOCOL_VERSION")) +"')\">" + messages.getString("edit") + "</a>&nbsp;" +
													"<a id='delgeo' class='ibm-delete-link' href='javascript:void(0);' onClick=\"callDelete('"+ ProtocolView_RS.getInt("OS_PROTOCOLID") + "', '" + ProtocolView_RS.getString("OS_NAME") + "', '" + tool.nullStringConverter(ProtocolView_RS.getString("PROTOCOL_NAME")) + "')\">" + messages.getString("delete") + "</a>" +
												"</td>"+
											"</tr>";
								} else {
									sValue = "<tr>"+
												"<th class='ibm-table-row' scope='row'>"+
													osArray[i] +
												"</th>"+
												"<td colspan='3'>"+
													"<a class='ibm-maximize-link' href='javascript:void(0);' onClick=\"openDiag('add_osprotocol','"+ osArray[i] +"','"+ protocol +"','"+ osidArray[i] +"','"+ protocolid + "')\">" + messages.getString("protocol_add_os_specific") +"</a>"+
												"</td>"+
											"</tr>";
								}
						%>
						<%= sValue %>
						<%	} //for loop %>
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