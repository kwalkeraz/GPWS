<%
	TableQueryBhvr DeviceNotesView  = (TableQueryBhvr) request.getAttribute("DeviceNotes");
	TableQueryBhvrResultSet DeviceNotesView_RS = DeviceNotesView.getResults();
	TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
	AppTools tool = new AppTools();
	String name = tool.nullStringConverter(request.getParameter("name"));
	//String searchpageid = tool.nullStringConverter(request.getParameter("searchpageid"));
	String devicetype = tool.nullStringConverter(request.getParameter("devicetype"));
	String search = tool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	int noteseqValue = 0;
	String deviceid = tool.nullStringConverter(request.getParameter("deviceid"));
	String notecodeValue = "";	
	String notevalueValue = "";	
	String notevalueDisplay = "";
	String notecodeLookupValue = "";
	int noteid = 0;
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    //Load URL parameters:
    String geoURL = tool.nullStringConverter(request.getParameter("geo"));
	String countryURL = tool.nullStringConverter(request.getParameter("country"));
	String cityURL = tool.nullStringConverter(request.getParameter("city"));
	String buildingURL = tool.nullStringConverter(request.getParameter("building"));
	String floorURL = tool.nullStringConverter(request.getParameter("floor"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	DateTime dateTime = new DateTime();
	Timestamp modified = dateTime.getSQLTimestamp();
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website device note"/>
	<meta name="Description" content="Global print website administer a device note" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_note_administer") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.Select");	 
	 dojo.require("dijit.form.Textarea");
	 
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
										"<div class='pClass'><label for='noteseq'>"+'<%= messages.getString("device_note_sequence") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='noteseq'></div></span></div>"+
										"<div class='pClass'><label for='notecode'>"+'<%= messages.getString("device_note_code") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='notecode'></div></span></div>"+
										"<div class='pClass'><label for='notevalue'>"+'<%= messages.getString("device_note_value") %>'+":</label>"+
										"<span><div id='notevalue'></div></span></div>"+
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
		setWidgetIDValue('noteseq', '');
        autoSelectValue("notecode","None");
        setWidgetIDValue('notevalue', '');
	 } //clearValues
	 
	 function loadCodes(){
     	resetMenu('notecode');
     	<%	while (CategoryView_RS.next()) {
				String notecode = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_VALUE1")); %>
			<%  if (!notecode.equals("")) { %>
					var selectCode = getWidgetID('notecode');
					var optionName = "<%= notecode %>";
					addOption(selectCode, optionName, optionName);
		<%		}  //if not empty %>
		<%	} //while CategoryView_RS %>
     } //loadCodes
     
     function onChangeCall(wName){
     	return this;
	 } //onChangeCall
	 
	 function openDiag(overlay) {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        loadCodes();
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("device_note_add") %>';
        topageid.value = '7105';
        logactionid.value = "Device note for device" + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(noteid, noteseq, notecode, notevalue) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("device_note_edit") %>';
        topageid.value = '7135';
        logactionid.value = "Device note for device" + logaction;
        createHiddenInput('logactioniddiag','noteid',noteid);
        loadCodes();
        getID("processTitle").innerHTML = title;
        setWidgetIDValue('noteseq', noteseq);
        autoSelectValue("notecode",notecode);
        setWidgetIDValue('notevalue', notevalue);
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        getID("Msg").innerHTML = "";
		//setWidgetValue('noteseq', '');
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     /**
	 	Add process
	 **/          
	 var addInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','<%= BehaviorConstants.TOPAGE %>','','topageidadd');
        createHiddenInput('logactioniddiag','logaction','','logactionidadd');
        createHiddenInput('logactioniddiag','deviceid','<%= deviceid %>','deviceid');
        createHiddenInput('logactioniddiag','datetime','<%= modified %>','datetime');
        createTextInput('noteseq','noteseq','noteseq','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9]*$','');
        createSelect('notecode', 'notecode', '<%= messages.getString("device_note_select_code") %>...', 'None', 'notecode');
        createTextArea('notevalue', 'notevalue', '', '');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','addDeviceNote()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','<%= prtgateway %>');
	 }; //function
	 
	 dojo.addOnLoad(addInfo);  //addOnLoad
	 
	 function addDeviceNote() {
	 	var formName = getWidgetID("addProcessForm");
        var formValid = false;
        var wName = "<%= name %>";
        var notecode = getSelectValue('notecode');
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
   		var notevalue = getWidgetIDValue('notevalue').replace(/(\r\n|[\r\n])/g, "").trim();
        setWidgetIDValue('notevalue', notevalue);
        if (notevalue.length > 255) {
        	alert ("<%= messages.getString("device_note_limit") %>");
        	formValid = false;
        	return false;
        }
        if (notecode == "None") {
   			alert('<%= messages.getString("please_select_all_required_fields") %>');
        	return false;
   		}
		if (formValid) {
			if (submitForm('addProcessForm',msg)) {
				//location.reload();
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			return false;
		}
	}; //addDeviceNote
	
    function submitForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("device_note_exists") %>.'+"</p>";
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
    
    function setFormValues(noteid, msg){
		var topageid = "7140";
		createHiddenInput('logactionid','noteid',noteid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(noteid, noteseq) {
		var msg = "Device note sequence " + noteseq + " for device " + "<%= name %>" + " has been deleted";
		setFormValues(noteid, msg);
		var confirmDelete = confirm('<%= messages.getString("device_note_sure_delete") %> ' + noteseq + "?");
		if (confirmDelete) {
			deleteFunction(msg, noteseq);
			//location.reload();
			AddParameter("logaction", msg);
		} //if yesno
	};
	
	function deleteFunction(msg,noteseq){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Device note " + noteseq +" may be currently assigned to a device</p>";
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=281"><%= messages.getString("device_search") %></a></li>
				<% if (!search.equals("")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=282&<%=PrinterConstants.SEARCH_NAME %>=<%= search %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=283&<%=PrinterConstants.SEARCH_NAME %>=<%= search %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (request.getParameter("referer").equals("432")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (request.getParameter("referer").equals("431")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (request.getParameter("referer").equals("430")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("device_note_administer") %> <%= messages.getString("for") %> <%= name %></h1>
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
			<li><%= messages.getString("device_note_edit_info") %></li>
			<li><%= messages.getString("device_note_delete_info") %></li>
		</ul>
		<% if (!logaction.equals("")) { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %></p>
		<% } %>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current device notes information">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("device_note_add") %></a></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_note_sequence") %></th>
							<th scope="col"><%= messages.getString("device_note_code") %></th>
							<th scope="col"><%= messages.getString("device_note_value") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
						<% 
							if (DeviceNotesView_RS.getResultSetSize() > 0 ) { 
								while(DeviceNotesView_RS.next()) {
									noteseqValue= DeviceNotesView_RS.getInt("NOTE_SEQUENCE");
									notecodeValue = tool.nullStringConverter(DeviceNotesView_RS.getString("NOTE_CODE"));
									notevalueValue = tool.html2text(tool.nullStringConverter(DeviceNotesView_RS.getString("NOTE_VALUE")));
									noteid = DeviceNotesView_RS.getInt("DEVICE_NOTESID");
									//deviceid = DeviceNotesView_RS.getInt("DEVICEID");
									notecodeLookupValue = tool.nullStringConverter(DeviceNotesView_RS.getString("CATEGORY_VALUE1"));
									if (notecodeValue.equals("")) {
										notevalueDisplay = notevalueValue;
									} else {
										notevalueDisplay = notecodeLookupValue;
										if (!notevalueValue.equals("")) {
											notevalueDisplay = notevalueValue;
										}
									}
						%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<%= noteseqValue %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= notecodeValue %>
							</th>
							<th class="ibm-table-row" scope="row">
								<%= notevalueDisplay %>
							</th>
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= noteid %>', '<%= noteseqValue %>', '<%= notecodeValue %>','<%= notevalueDisplay %>')"><%= messages.getString("edit") %></a>
								<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= noteid %>', '<%= noteseqValue %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% } //while %>
						<% } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="4"><%= messages.getString("device_note_not_found") %></th>
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