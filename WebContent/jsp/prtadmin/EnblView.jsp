<%
    TableQueryBhvr EnblHdrView  = (TableQueryBhvr) request.getAttribute("EnblHeader");
	TableQueryBhvrResultSet EnblHdrView_RS = EnblHdrView.getResults();
	TableQueryBhvr EnblView  = (TableQueryBhvr) request.getAttribute("Enbl");
	TableQueryBhvrResultSet EnblView_RS = EnblView.getResults();
	TableQueryBhvr EnblStatus  = (TableQueryBhvr) request.getAttribute("EnblStatus");
	TableQueryBhvrResultSet EnblStatus_RS = EnblStatus.getResults();
	TableQueryBhvr EnblType  = (TableQueryBhvr) request.getAttribute("EnblType");
	TableQueryBhvrResultSet EnblType_RS = EnblType.getResults();
	AppTools tool = new AppTools();
	String search = tool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    //Load URL parameters:
    String geoURL = tool.nullStringConverter(request.getParameter("geo"));
	String countryURL = tool.nullStringConverter(request.getParameter("country"));
	String cityURL = tool.nullStringConverter(request.getParameter("city"));
	String buildingURL = tool.nullStringConverter(request.getParameter("building"));
	String floorURL = tool.nullStringConverter(request.getParameter("floor"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	String deviceid = tool.nullStringConverter(request.getParameter("deviceid"));
	String name = tool.nullStringConverter(request.getParameter("name"));
	String cs = "";
	String vm = "";
	String mvs = "";
	String sap = "";
	String wts = "";
	String devicename = "";
	String enbltype = "";
	String status = "";
	String comments = "";
	int enbltypeid = 0;
	int enblheaderid = 0;
	int enbldetailid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print enablement administration"/>
	<meta name="Description" content="Global print website maintain enablement information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("enbl_admin") %> </title>
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
	 
	 function callAdminDetail(enbltypeid,enblheaderid){
	 	var url = "";
	 	<% if (!search.equals("")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7230&name=<%= name %>&enbltypeid="+enbltypeid+"&enblheaderid="+enblheaderid+"&deviceid=<%= deviceid %>&referer=283&<%=PrinterConstants.SEARCH_NAME %>=<%= search %>";
		<% } else if (request.getParameter("referer").equals("432")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7230&name=<%= name %>&enbltypeid="+enbltypeid+"&enblheaderid="+enblheaderid+"&deviceid=<%= deviceid %>&referer=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>";
		<% } else if (request.getParameter("referer").equals("431")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7230&name=<%= name %>&enbltypeid="+enbltypeid+"&enblheaderid="+enblheaderid+"&deviceid=<%= deviceid %>&referer=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>";
		<% } else if (request.getParameter("referer").equals("430")) { %>
			url = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7230&name=<%= name %>&enbltypeid="+enbltypeid+"&enblheaderid="+enblheaderid+"&deviceid=<%= deviceid %>&referer=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>";
		<% } %>
		document.location.href = url;
	 } //callAdminDetail
	 
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
										"<div class='pClass'><label for='status'>"+'<%= messages.getString("enbl_status") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='status'></div></span></div>"+
										"<div class='pClass'><label for='comment'>"+'<%= messages.getString("comments") %>'+":</label>"+
										"<span><div id='comment'></div></span></div>"+
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
		autoSelectValue("enbltype","0");
        autoSelectValue("status","None");
        setWidgetIDValue('comment','');
	 } //clearValues
	 
	 function loadStatus(){
	 	resetMenu('status');
	 	<%	while (EnblStatus_RS.next()) { %>
		 		var statusname = "<%= tool.nullStringConverter(EnblStatus_RS.getString("CATEGORY_VALUE1")) %>";
				var statusvalue = "<%= tool.nullStringConverter(EnblStatus_RS.getString("CATEGORY_VALUE2")) %>";
				addOption('status',statusname,statusvalue);
		<%	} //while CategoryView_RS %>
     } //loadCodes
     
     function loadEnblType(){
	 	resetMenu('enbltype');
	 	<%	while (EnblType_RS.next()) { %>
		 		var enbltype = "<%= EnblType_RS.getString("ENBL_TYPE")  %>";
				var enbltypeid = "<%= EnblType_RS.getInt("ENBL_TYPEID")  %>";
				addOption('enbltype',enbltype,enbltypeid);
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
        loadStatus();
        loadEnblType();
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("enbl_header_add") %>';
        topageid.value = '7225';
        logactionid.value = "Enablement header for" + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(enblheaderid, status, enbltype, comment) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("enbl_header_edit") %>';
        topageid.value = '7245';
        logactionid.value = "Enablement header for" + logaction;
        createHiddenInput('logactioniddiag','enblheaderid',enblheaderid);
        loadStatus();
        autoSelectValue('status',status);
        loadEnblType();
        autoSelectValue('enbltype',enbltype);
        setWidgetIDValue('comment',comment);
        getID("processTitle").innerHTML = title;
        ibmweb.overlay.show(pop,this);
     } //editDialog
     
     function closeLoc(loc){
     	var pop = 'addprocess';
        clearValues();
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
        createHiddenInput('logactioniddiag','deviceid','<%= deviceid %>','deviceid');
        createHiddenInput('logactioniddiag','enbltypeid','<%= enbltypeid %>','enbltypeid');
        createSelect('enbltype', 'enbltype', '<%= messages.getString("enbl_type_select") %>...', '0', 'enbltype');
        createSelect('status', 'status', '<%= messages.getString("enbl_select_status") %>...', 'None', 'status');
        createTextArea('comment', 'comment', '', '');
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
        var status = getSelectValue('status');
        var enbltype = getSelectValue('enbltype');
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
   		var comment = getWidgetIDValue('comment').replace(/(\r\n|[\r\n])/g, "").trim();
        setWidgetIDValue('comment',comment);
   		if (status == "None") {
   			alert('<%= messages.getString("please_select_all_required_fields") %>');
        	return false;
   		}
   		if (enbltype == "0") {
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
	   				getID("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("enbl_header_exists") %>.'+"</p>";
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
    
    function setFormValues(enblheaderid, msg){
		var topageid = "7260";
		createHiddenInput('logactionid','enblheaderid',enblheaderid);
		setValue('topageiddel',topageid);
		setValue('logactioniddel',msg);
	} //setFormValues
    
    function callDelete(enblheaderid, enbltype) {
		var msg = "Enablement header information for enablement type " + enbltype + " for device " + "<%= name %>" + " has been deleted";
		setFormValues(enblheaderid, msg);
		var confirmDelete = confirm('<%= messages.getString("enbl_header_delete_info") %> ' + enbltype + "?");
		if (confirmDelete) {
			deleteFunction(msg, enbltype);
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
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Enablement type " + enbltype +" may currently have enablement detail information assigned</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    				AddParameter("logaction", msg);
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue,
        };
        dojo.xhrPost(xhrArgs);
	} //deleteFunction
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','','topageiddel');
        createHiddenInput('logactionid','logaction','','logactioniddel');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
        <% if (!logaction.equals("")){ %>
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
			<h1><%= messages.getString("enbl_admin") %></h1>
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
			<li><%= messages.getString("enbl_header_add_info") %></li>
			<li><%= messages.getString("enbl_header_edit_info") %></li>
			<li><%= messages.getString("enbl_header_delete") %></li>
			<li><%= messages.getString("enbl_detail_admin_info") %></li>
		</ul>
		
		<h2><%= messages.getString("current_device_enbl") %></h2>
		<%	
				while(EnblView_RS.next()) {
					cs = tool.nullStringConverter(EnblView_RS.getString("CS"));
					vm = tool.nullStringConverter(EnblView_RS.getString("VM"));
					mvs = tool.nullStringConverter(EnblView_RS.getString("MVS"));
					sap = tool.nullStringConverter(EnblView_RS.getString("SAP"));
					wts = tool.nullStringConverter(EnblView_RS.getString("WTS"));
					devicename = tool.nullStringConverter(EnblView_RS.getString("DEVICE_NAME"));
				} //while
				if (cs.equals("")) cs = "N";
				if (vm.equals("")) vm = "N";
				if (mvs.equals("")) mvs = "N";
				if (sap.equals("")) sap = "N";
				if (wts.equals("")) wts = "N";
		%>
		<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current device enablements">
			<caption><em></em></caption>
			<thead>
				<tr>
					<th><%= messages.getString("device_name") %></th>
					<th><%= messages.getString("cs") %></th>
					<th><%= messages.getString("vm") %></th>
					<th><%= messages.getString("mvs") %></th>
					<th><%= messages.getString("sap" )%></th>
					<th><%= messages.getString("wts") %></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><%= devicename %></td>
					<td><% if (cs.equals("Y")) { %><a class='ibm-confirm-link'></a><% } %></td>
					<td><% if (vm.equals("Y")) { %><a class='ibm-confirm-link'></a><% } %></td>
					<td><% if (mvs.equals("Y")) { %><a class='ibm-confirm-link'></a><% } %></td>
					<td><% if (sap.equals("Y")) { %><a class='ibm-confirm-link'></a><% } %></td>
					<td><% if (wts.equals("Y")) { %><a class='ibm-confirm-link'></a><% } %></td>
				</tr>
			</tbody>
		</table>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<div id='errorMsg'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current enablement header information">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("enbl_header_add") %></a></em></caption>
					<thead>
						<tr>
							<tr>
							<th scope="col"><%= messages.getString("enbl_type") %></th>
							<th scope="col"><%= messages.getString("enbl_status") %></th>
							<th scope="col"><%= messages.getString("comments") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
				<%  if (EnblHdrView_RS.getResultSetSize() > 0) { 
						EnblHdrView_RS.first();
						while (EnblHdrView_RS.next()) {
							enbltype = EnblHdrView_RS.getString("ENBL_TYPE");
							status = EnblHdrView_RS.getString("ENBL_STATUS");
							comments = EnblHdrView_RS.getString("ENBL_COMMENTS");
							enbltypeid = EnblHdrView_RS.getInt("ENBL_TYPEID");
							enblheaderid = EnblHdrView_RS.getInt("ENBL_HEADERID"); %>
						<tr>
							<td><a href="javascript:void(0);" onClick="callAdminDetail('<%= enbltypeid %>','<%= enblheaderid %>')"> <%= enbltype %></a></td>
							<td><%= status %></td> 
							<td><%= comments %></td> 
							<td>
								<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= enblheaderid %>', '<%= status %>', '<%= enbltypeid %>', '<%= comments %>')"> <%= messages.getString("edit") %></a>
								<a class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= enblheaderid %>','<%= enbltype %>')" ><%= messages.getString("delete") %></a>
							</td>
						</tr>
				<% 		} //while EnblHdrView %>
				<%  } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_enbl_info_found") %> <%= devicename %></th>
						</tr>
				<%  } %>
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