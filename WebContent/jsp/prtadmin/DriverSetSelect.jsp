<%
   TableQueryBhvr DriverSetView  = (TableQueryBhvr) request.getAttribute("DriverSetView");
   TableQueryBhvrResultSet DriverSetView_RS = DriverSetView.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   int driversetid = 0;
   String driversetname = "";
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website driver set select page"/>
	<meta name="Description" content="Global print website current available driver sets" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_administer") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function callEdit(selectedValue) {
		var params = "&driver_setid=" + selectedValue;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=353" + params;
	 } //callEdit
	 
	 function setFormValues(msg,driversetid){
		var topageid = "355";
		setValue("<%= BehaviorConstants.TOPAGE %>", topageid);
		setValue('driversetid', driversetid);
		setValue('logaction', msg);
	} //setFormValues
	
	function callDelete(driversetname, driversetid) {
		//e.preventDefault();
		//console.log(this.id);
		var formName = getWidgetID('deleteForm');
		var msg = "Driver set " + driversetname + " has been deleted";
		setFormValues(msg,driversetid);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_driver_set") %> ' + driversetname + "?");
		if (confirmDelete) {
			formName.submit();
		} //if yesno
	};
	
	function deleteFunction(msg,driversetname) {
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            sync: true,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. Driver set " + driversetname +" may be currently assigned to a printer</p>";
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
        //console.log(xhrArgs);
        //console.log("something worked");
	} //deleteFunction
	 
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('driversetidloc','driversetid','');
        createHiddenInput('logactionid','sdc','');
 		createPostForm('driversetForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
		<%if (!logaction.equals("")){ %>
        dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
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
			<h1><%= messages.getString("driver_set_administer") %></h1>
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
				<li><%= messages.getString("driver_set_edit_info") %></li>
				<li><%= messages.getString("driver_set_delete_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=350"><%= messages.getString("driver_set_add") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='driversetForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='driversetidloc'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available driver sets">
					<caption><em><%= DriverSetView_RS.getResultSetSize() %> <%= messages.getString("driver_set_found") %></em></caption>
					<% if (DriverSetView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("driver_set_name") %></th>
							<th scope="col"><%= messages.getString("driver_set_config") %></th>
							<th scope="col"><%= messages.getString("model_driver_set") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						while(DriverSetView_RS.next()) {
							driversetid = DriverSetView_RS.getInt("DRIVER_SETID");
							driversetname = tool.nullStringConverter(DriverSetView_RS.getString("DRIVER_SET_NAME"));
					 %>
						<tr id='tr<%= driversetid %>'>
							<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= driversetid %>');"/><%= driversetname %></a></th>
							<td><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=380&driver_setid=<%= driversetid %>&referer=<%= request.getParameter(BehaviorConstants.TOPAGE) %>"/><%= messages.getString("driver_set_config_admin") %></a></td>
							<td><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=360&driverset_id=<%= driversetid %>&referer=<%= request.getParameter(BehaviorConstants.TOPAGE) %>"/><%= messages.getString("model_driver_set_build") %></a></td>
							<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= driversetname %>','<%= driversetid %>')" ><%= messages.getString("delete") %></a></td>
						</tr>
					<% } //while loop %>
					</tbody>
					<% } //if there are records %>
				</table> 
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>