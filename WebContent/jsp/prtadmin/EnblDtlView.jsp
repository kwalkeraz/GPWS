<%
    TableQueryBhvr EnblField  = (TableQueryBhvr) request.getAttribute("EnblField");
	TableQueryBhvrResultSet EnblField_RS = EnblField.getResults();
	TableQueryBhvr EnblHeader  = (TableQueryBhvr) request.getAttribute("EnblHeader");
	TableQueryBhvrResultSet EnblHeader_RS = EnblHeader.getResults();
	TableQueryBhvr EnblDetail = (TableQueryBhvr) request.getAttribute("EnblDetail");
	TableQueryBhvrResultSet EnblDetail_RS = EnblDetail.getResults();
	AppTools tool = new AppTools();
	String search = tool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));

	String enblheader = "";
	String enblheaderid = tool.nullStringConverter(request.getParameter("enblheaderid"));
	String enbltype = "";
	String deviceid = tool.nullStringConverter(request.getParameter("deviceid"));
	String enbltypeid = tool.nullStringConverter(request.getParameter("enbltypeid"));
	String geoURL = tool.nullStringConverter(request.getParameter("geo"));
	String countryURL = tool.nullStringConverter(request.getParameter("country"));
	String cityURL = tool.nullStringConverter(request.getParameter("city"));
	String buildingURL = tool.nullStringConverter(request.getParameter("building"));
	String floorURL = tool.nullStringConverter(request.getParameter("floor"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	String name = tool.nullStringConverter(request.getParameter("name"));
	String enblfieldname = "";
	String enblfieldvalue = "";
	int enbldetailid = 0;
	int enblfieldid = 0;
	while(EnblDetail_RS.next()) {
		enbltype = EnblDetail_RS.getString("ENBL_TYPE");
	}
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print enablement detail"/>
	<meta name="Description" content="Global print website maintain enablement detail information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("enbl_detail_admin") %> </title>
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
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.Select");
		 
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
										"<div class='pClass'><label for='field'>"+'<%= messages.getString("enbl_field") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='field'></div></span></div>"+
										"<div class='pClass'><label for='fieldvalue'>"+'<%= messages.getString("enbl_field_value") %>'+":<span class='ibm-required'>*</span></label>"+
										"<span><div id='fieldvalue'></div></span></div>"+
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
		autoSelectValue("field","None");
        //dijit.byId("fieldvalue").set("value", "");
        setWidgetIDValue('fieldvalue', '');
	 } //clearValues
	 
	 function loadField(){
	 	resetMenu('field');
	 	<%	while (EnblField_RS.next()) { %>
		 		var fieldname = "<%= tool.nullStringConverter(EnblField_RS.getString("ENBL_FIELD_NAME")) %>";
				var fieldid = "<%= EnblField_RS.getInt("ENBL_FIELDID") %>";
				var selectField = getWidgetID('field');
				//selectField.addOption({value: fieldid, label: fieldname });
				addOption(selectField, fieldname, fieldid);
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
        loadField();
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been added";
        title = '<%= messages.getString("enbl_detail_add") %>';
        topageid.value = '7235';
        logactionid.value = "Enablement detail for" + logaction;
        getID("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
     } //openLoc
     
     function editDiag(enbldetailid, enblfieldname, enblfieldvalue) {
        //locDiag.show();
        clearValues();
		var pop = 'addprocess';
        var title = '';
        var topageid = getID('topageidadd');
        var logactionid = getID('logactionidadd');
        var logaction = " {0} has been updated";
        title = '<%= messages.getString("enbl_detail_edit") %>';
        topageid.value = '7255';
        logactionid.value = "Enablement detail for" + logaction;
        createHiddenInput('logactioniddiag','enbldetailid',enbldetailid);
        loadField();
        autoSelectValue('field',enblfieldname);
        //dijit.byId("fieldvalue").set("value", enblfieldvalue);
        setWidgetIDValue('fieldvalue', enblfieldvalue);
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
        createHiddenInput('logactioniddiag','enblheaderid','<%= enblheaderid %>','enblheaderid');
        createSelect('field', 'field', '<%= messages.getString("enbl_select_field") %>...', 'None', 'field');
        createTextInput('fieldvalue','fieldvalue','fieldvalue','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','');
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
        var field = getSelectValue('field');
        var logactionid = getID('logactionidadd');
        var logaction = logactionid.value.replace("{0}", wName);
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
   		if (field == "0") {
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
    
    function setFormValues(enbldetailid, msg){
		var topageid = "7270";
		createHiddenInput('logactionid','enbldetailid',enbldetailid);
		setValue('topageiddel', topageid);
		setValue('logactioniddel', msg);
	} //setFormValues
    
    function callDelete(enbldetailid, enbltype) {
		var msg = "Enablement detail information for enablement type " + enbltype + " has been deleted";
		setFormValues(enbldetailid, msg);
		var confirmDelete = confirm('<%= messages.getString("enbl_detail_delete_info") %> ' + enbltype + "?");
		if (confirmDelete) {
			deleteFunction(msg, enbltype);
			//location.reload();
			AddParameter("logaction", msg);
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
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. Enablement type " + enbltype +" may be currently assigned to a device</p>";
        		} else {
    				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                dojo.byId("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue
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
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7210&name=<%= name %>&deviceid=<%= deviceid %>&referer=283&<%=PrinterConstants.SEARCH_NAME %>=<%= search %>"><%= messages.getString("enbl_admin") %></a></li>
				<% } else if (request.getParameter("referer").equals("432")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("device_edit_page") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7210&name=<%= name %>&deviceid=<%= deviceid %>&referer=432&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>"><%= messages.getString("enbl_admin") %></a></li>
				<% } else if (request.getParameter("referer").equals("431")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("device_edit_page") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7210&name=<%= name %>&deviceid=<%= deviceid %>&referer=431&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>"><%= messages.getString("enbl_admin") %></a></li>
				<% } else if (request.getParameter("referer").equals("430")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("device_edit_page") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7210&name=<%= name %>&deviceid=<%= deviceid %>&referer=430&geo=<%= geoURL %>&country=<%= countryURL %>&city=<%= cityURL %>&building=<%= buildingURL %>&floor=<%= floorURL %>"><%= messages.getString("enbl_admin") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("enbl_detail_admin") %></h1>
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
			<li><%= messages.getString("required_info") %></li>
		</ul>
		<p>
			<em>
				<%= messages.getString("device_name") %>: <%= name %>
			</em>
		</p>
		<p>
			<%= messages.getString("enbl_type") %>: <%= enbltype %>
		</p>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<div id='errorMsg'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List current enablement detail information">
					<caption><em><a class="ibm-maximize-link" href="javascript:void(0);" onClick="openDiag('add_of');"><%= messages.getString("enbl_detail_add") %></a></em></caption>
					<thead>
						<tr>
							<tr>
							<th scope="col"><%= messages.getString("enbl_field") %></th>
							<th scope="col"><%= messages.getString("enbl_field_value") %></th>
							<th scope="col"><%= messages.getString("update") %></th>
						</tr>
					</thead>
					<tbody>
				<%  if (EnblDetail_RS.getResultSetSize() > 0) { %>
					<%  EnblDetail_RS.first();
						while (EnblDetail_RS.next()) { 
							enblfieldid = EnblDetail_RS.getInt("ENBL_FIELDID");
							enblfieldvalue = tool.nullStringConverter(EnblDetail_RS.getString("ENBL_FIELD_VALUE"));
							enblfieldname = tool.nullStringConverter(EnblDetail_RS.getString("ENBL_FIELD_NAME"));
							enbltype = EnblDetail_RS.getString("ENBL_TYPE");
							enbldetailid = EnblDetail_RS.getInt("ENBL_DETAILID"); 
							if (!enblfieldvalue.equals("")) {%>
					<tr>
						<td><%= enblfieldname %></td> 
						<td><%= enblfieldvalue %></td> 
						<td>
							<a class="ibm-signin-link" href="javascript:void(0);" onClick="editDiag('<%= enbldetailid %>', '<%= enblfieldid %>', '<%= enblfieldvalue %>')"><%= messages.getString("edit") %></a>
							<a class="ibm-delete-link" href="javascript:void(0);" onClick="callDelete('<%= enbldetailid %>', '<%= enbltype %>')" ><%= messages.getString("delete") %></a>
						</td>
					</tr>
					<%		}
						} //while counter %>
				<%  } else { %>
						<tr>
							<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_enbl_detail_found") %></th>
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