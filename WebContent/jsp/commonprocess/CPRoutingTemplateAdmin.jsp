<%
   TableQueryBhvr CPRoutingTemplateView  = (TableQueryBhvr) request.getAttribute("CPRoutingTemplate");
   TableQueryBhvrResultSet CPRoutingTemplateView_RS = CPRoutingTemplateView.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   
    String reqnum = "";
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	int cpapprovalid = 0;
	String devicename = "";
	String action = "";
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print administer routing template"/>
	<meta name="Description" content="Global print website administer a routing template page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_administer_routing_template") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Tooltip");
	  
	function callEdit(templateid) {
		var params ="&cptemplateid=" + templateid;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7483" + params;
	} //callEdit
	
	function callAddInfo(templateid) {
		var params ="&cptemplateid=" + templateid;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7490" + params;
	} //callAddInfo
	
	function setFormValues(msg,templateid){
		var topageid = "7485";
		setValue("<%= BehaviorConstants.TOPAGE %>",topageid);
		setValue('cptemplateid',templateid);
		setValue('logaction',msg);
	} //setFormValues
	
	function callDelete(template, templateid) {
		var msg = "Routing template " + template + " has been deleted";
		setFormValues(msg,templateid);
		var confirmDelete = confirm('<%= messages.getString("cp_sure_delete_routing_template") %> ' + template + "?");
		if (confirmDelete) {
			if(deleteFunction(msg, template)) {
				//location.reload();
				//AddParameter("logaction", msg);
				window.location ="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7480&logaction=" + msg;
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,template){
		var submitted = true;
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
            		submitted = false;
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Routing template " + template +" may be currently in use</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	submitted = false;
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
        return submitted;
	} //deleteFunction
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cptemplateid','');
        createPostForm('templateForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= commonprocess %>');
		<%if (!logaction.equals("")) { %>
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
			<h1><%= messages.getString("cp_administer_routing_template") %></h1>
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
			<ul class="ibm-bullet-list ibm-no-links">
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7481"><%= messages.getString("cp_add_routing_template_info") %></a></li>
				<li><%= messages.getString("cp_edit_routing_template_info") %></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='templateForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List of common process routing templates">
					<caption><em><%= CPRoutingTemplateView_RS.getResultSetSize() %> <%= messages.getString("cp_routing_templates_found") %></em></caption>
					<% if (CPRoutingTemplateView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("template_name") %></th>
							<th scope="col"><%= messages.getString("request_type") %></th>
							<th scope="col"><%= messages.getString("cp_view_routing_steps") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						String templatename = "";
						String requesttype = "";
						int templateid = 0;
						CPRoutingTemplateView_RS.first();
							while(CPRoutingTemplateView_RS.next()) {
								templateid = CPRoutingTemplateView_RS.getInt("CP_TEMPLATE_ID");
								requesttype = tool.nullStringConverter(CPRoutingTemplateView_RS.getString("REQUEST_TYPE"));
								templatename = tool.nullStringConverter(CPRoutingTemplateView_RS.getString("TEMPLATE_NAME"));
					 %>
						<tr>
							<th class="ibm-table-row" scope="row" id="<%= templateid %>Id">
								<a class="ibm-signin-link" href="javascript:callEdit('<%=templateid%>');"><%= templatename %></a>
							</th>
							<td>
								<%= requesttype %>
							</td>
							<td>
								<a href="javascript:callAddInfo('<%= templateid %>')"><%= messages.getString("cp_admin_routing_steps_info") %></a>
							</td>
							<td><a class="ibm-delete-link" href="javascript:callDelete('<%= templatename %>','<%= templateid %>')"><%= messages.getString("delete") %></a></td>
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