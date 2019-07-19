<%
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));

%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website device model select"/>
	<meta name="Description" content="Global print website device model select page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_device_type") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function loadInitialInfo() {
	 	var tbody = getID('tbodyId');
	 	tbody.innerHTML = "";
	 	var spinner = '<span align="center"><%= messages.getString("please_wait") %> ... <p class="ibm-spinner-large"></p></span>';
	 	var tr = dojo.create("tr", {"id" : "trID"}, tbody);
	 	dojo.create("th", {
		                 innerHTML: spinner,
		                 'class': 'ibm-table-row',
		                 'scope': 'row',
		                 'colspan' : 6,
					 }, tr, 'first');
	 }
	 	 
	 function getData() {
	 	dojo.xhrGet({
<%-- 	        url: "<%= statichtmldir %>/servlet/api.wss/model", --%>
			url: "api.wss/model",
	        handleAs: "json",
	        headers: {
				'Accept': 'application/json'
			},
	        preventCache: true,
      		sync: false,
	        load: function(responseObject, ioArgs) {
	        	//console.log("object parsed is " + dojo.toJson(responseObject.value.Model, true));
	        	var x = 0; 
	        	getID('tbodyId').innerHTML = "";
	        	//dojo.forEach(responseObject, function(element) {  //Use this if getting a json object without arrays
	        	dojo.forEach(responseObject.value.Model, function(element) {  //Use this if getting a json array from REST
	            	//console.log("Device model is " + element.Name + " Confidential print is " + dojo.toJson(element.ConfidentialPrint, true) + " Strategic is " + dojo.toJson(element.Strategic, true)); 
	                var modelname = element.Name;
	                var modelid = element.id;
	                x = x + 1;
	                var tr = dojo.create("tr", {"id" : "tr" + modelid}, "tbodyId");
		            dojo.create("th", {
		                 innerHTML: '<a class="ibm-signin-link" href="javascript:callEdit(\''+modelid+'\');"/>' + modelname,
		                 'class': 'ibm-table-row',
		                 'scope': 'row'
		             }, tr, 'first');
		             dojo.create("td", {
		                 innerHTML: element.Strategic
		             }, tr, 'second');
		             dojo.create("td", {
		                 innerHTML: element.ConfidentialPrint
		             }, tr, 'third');
		             dojo.create("td", {
		                 innerHTML: element.Color
		             }, tr, 'third');
		             dojo.create("td", {
		                 innerHTML: element.NumLangDisplay
		             }, tr, 'fourth');
		             dojo.create("td", {
		                 innerHTML: '<a href="/tools/print/servlet/prtgateway.wss?to_page_id=370&model_id='+dojo.toJson(modelid, true)+'&referer=850">Build model driver</a>'
		             }, tr, 'fifth');
		             dojo.create("td", {
		                 innerHTML: '<a href="/tools/print/servlet/prtgateway.wss?to_page_id=360&model_id='+dojo.toJson(modelid, true)+'&referer=850">Build model driver set</a>'
		             }, tr, 'sixth');
		             dojo.create("td", {
		                 innerHTML: '<a id=\'delserver\' class="ibm-delete-link" href="javascript:callDelete('+ '\''+modelname+ '\''+', '+'\''+modelid+'\')" >Delete</a>'
		             }, tr, 'seventh');
			    });
				    if (x > 0) {
				    	getID('num_models').innerHTML = x + ' <%= messages.getString("device_model_found") %>';
				    } else {
				    	getID('tbodyId').innerHTML = "No device models found";
				    }
				},
	        error : function(response, ioArgs) {
				console.log("error " + response);
				getID('tbodyId').innerHTML = "<p><a class='ibm-error-link'></a>There was an error getting the data.  Reason: " + response;
			}
    	});
	 }
	 
	 function callEdit(selectedValue) {
		var params = "&modelid=" + selectedValue;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=851" + params;
	 } //callEdit
	 
	 function setFormValues(msg,modelid){
		var topageid = "852";
		setValue("<%= BehaviorConstants.TOPAGE %>", topageid);
		setValue('modelid',modelid);
		setValue('logaction',msg);
	} //setFormValues
	
	function callDelete(model, modelid) {
		//e.preventDefault();
		//console.log(this.id);
		var msg = "Device model " + model + " has been deleted";
		setFormValues(msg,modelid);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_model_type") %> ' + model + "?");
		if (confirmDelete) {
			if (deleteFunction(msg, model)) {
				//location.reload();
				//AddParameter("logaction", msg);
				loadInitialInfo();
				getData();
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,model){
		var submitted = true;
		var syncValue = false;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            sync:  syncValue,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Device model " + model +" may be currently assigned to a printer</p>";
        			submitted = false;
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    				submitted = true;
    			}
            },
            error: function(error, ioArgs) {
            	submitted = false;
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
        //console.log(xhrArgs);
        return submitted;
	} //deleteFunction
	 
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('modelidloc','modelid','');
        createPostForm('devicemodelForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
		loadInitialInfo();
        getData(); 
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
			</ul>
			<h1><%= messages.getString("administer_device_type") %></h1>
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
			<ul class="ibm-bullet-list ibm-no-links">
				<li><%= messages.getString("device_model_edit_info") %></li>
				<li><%= messages.getString("device_model_delete_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=800"><%= messages.getString("add_strategic_device_type") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='devicemodelForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='modelidloc'></div>
				<table id="tableId" border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available device models">
					<caption><em><span id="num_models"></span></em></caption>
					
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("device_model") %></th>
							<th scope="col"><%= messages.getString("strategic") %></th>
							<th scope="col"><%= messages.getString("confidential_print") %></th>
							<th scope="col"><%= messages.getString("Color") %></th>
							<th scope="col"><%= messages.getString("number_of_display_lang") %></th>
							<th scope="col"><%= messages.getString("model_driver") %></th>
							<th scope="col"><%= messages.getString("model_driver_set") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody id="tbodyId">
					</tbody>
					
				</table> 
				<div id="grid"></div>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>