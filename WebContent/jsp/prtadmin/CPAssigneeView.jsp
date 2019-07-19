<%
   TableQueryBhvr CPAssigneeView  = (TableQueryBhvr) request.getAttribute("CPAssignee");
   TableQueryBhvrResultSet CPAssigneeView_RS = CPAssigneeView.getResults();
   
	 AppTools tool = new AppTools();
	 String referer = tool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
	 String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	 String geo = tool.nullStringConverter(request.getParameter("geo"));
	String country = tool.nullStringConverter(request.getParameter("country"));
	String state = tool.nullStringConverter(request.getParameter("state"));
	String city = "";
	String building = "";
	String floor ="";
	int priority = 0;
	String analyst = "";	
	int cpanalystid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view all analysts"/>
	<meta name="Description" content="Global print website view all available cp analysts" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_analyst_admin") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Tooltip");
	  
	function callEdit(cpanalystid) {
		var params ="&cpanalystid=" + cpanalystid + "&referer=" + "<%= referer %>";
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=1050" + params;
	} //callEdit
	
	function setFormValues(msg,cpanalystid){
		var topageid = "1040";
		//dojo.byId("<%= BehaviorConstants.TOPAGE %>").value = topageid;
		setValue("<%= BehaviorConstants.TOPAGE %>",topageid);
		//dojo.byId("cpanalystid").value = cpanalystid;
		setValue("cpanalystid",cpanalystid);
		//dojo.byId('logaction').value = msg;
		setValue('logaction', msg);
	} //setFormValues
	
	function callDelete(analyst, cpanalystid) {
		var msg = "CP Analyst " + analyst + " has been deleted";
		setFormValues(msg,cpanalystid);
		var confirmDelete = confirm('<%= messages.getString("cp_analyst_sure_delete") %> ' + analyst + "?");
		if (confirmDelete) {
			if(deleteFunction(msg, analyst)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,analyst){
		var submitted = true;
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
            		submitted = false;
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. CP Analyst " + analyst +" may be currently assigned to a record</p>";
        		} else {
    				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
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
        createHiddenInput('logactionid','cpanalystid','');
        createPostForm('categoryForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
        
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1020"><%= messages.getString("cp_analyst_search") %></a></li>
			</ul>
			<h1><%= messages.getString("cp_analyst_admin") %></h1>
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
				<li><%= messages.getString("cp_analyst_edit_info") %></li>
				<li><%= messages.getString("cp_analyst_delete_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=1000"><%= messages.getString("cp_analyst_add") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='categoryForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all current CP analysts that are assigned to a specific location">
					<caption><em><%= CPAssigneeView_RS.getResultSetSize() %> <%= messages.getString("analyst_found") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("analyst") %></th>
							<th scope="col"><%= messages.getString("geography") %></th>
							<th scope="col"><%= messages.getString("country") %></th>
							<th scope="col"><%= messages.getString("state") %></th>
							<th scope="col"><%= messages.getString("city") %></th>
							<th scope="col"><%= messages.getString("building") %></th>
							<th scope="col"><%= messages.getString("floor") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						if (CPAssigneeView_RS.getResultSetSize() > 0 ) {
							while(CPAssigneeView_RS.next()) {
								geo = tool.nullStringConverter(CPAssigneeView_RS.getString("GEO"));
								country = tool.nullStringConverter(CPAssigneeView_RS.getString("COUNTRY"));
								state = tool.nullStringConverter(CPAssigneeView_RS.getString("STATE"));
								city = tool.nullStringConverter(CPAssigneeView_RS.getString("CITY"));
								building = tool.nullStringConverter(CPAssigneeView_RS.getString("BUILDING"));
								floor = tool.nullStringConverter(CPAssigneeView_RS.getString("FLOOR"));
								priority = CPAssigneeView_RS.getInt("CP_ANALYST_PRIORITY");
								analyst = tool.nullStringConverter(CPAssigneeView_RS.getString("CP_ANALYST"));
								cpanalystid = CPAssigneeView_RS.getInt("CPANALYSTID");	%>
						<tr>
							<th class="ibm-table-row" scope="row">
								<a class="ibm-signin-link" href="javascript:callEdit('<%= cpanalystid %>');"><%= analyst %></a>
							</th>
							<td><%= geo %></td>
							<td><%= country %></td>
							<td><%= state %></td>
							<td><%= city %></td>
							<td><%= building %></td>
							<td><%= floor %></td>
							<td><a class="ibm-delete-link" href="javascript:callDelete('<%= analyst %> for <%= geo %>, <%= country %>, <%= state %>, <%= city %>, <%= building %>, <%= floor %>','<%= cpanalystid %>')"><%= messages.getString("delete") %></a></td>
						</tr>
						<% } //while loop %>
					<% } //if there are records %>
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