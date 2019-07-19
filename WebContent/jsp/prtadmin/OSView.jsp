<%
   TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
   TableQueryBhvrResultSet OSView_RS = OSView.getResults();
   AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website administer operating system"/>
	<meta name="Description" content="Global print web site administer an operating system" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("os_select") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function callEdit(selectedValue) {
		var params = "&osid=" + selectedValue;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=243" + params;
	 } //callEdit
	 
	 function setFormValues(msg,osid){
		var topageid = "245";
		dojo.byId("<%= BehaviorConstants.TOPAGE %>").value = topageid;
		dojo.byId("osid").value = osid;
		dojo.byId('logaction').value = msg;
	} //setFormValues
	
	function callDelete(osname, osid) {
		var formName = dijit.byId('deleteForm');
		var msg = "OS " + osname + " has been deleted";
		setFormValues(msg,osid);
		var confirmDelete = confirm('<%= messages.getString("os_delete_sure") %> ' + osname + "?");
		if (confirmDelete) {
			//formName.submit();
			if (deleteFunction(msg,osname)) {
				//location.reload();
				AddParameter("logaction", msg);
			}
		} //if yesno
	};
	
	function deleteFunction(msg,osname){
		var submitted = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            sync: true,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. OS name " + osname +" may be currently assigned to a driver/protocol</p>";
        			submitted = false;
        		} else {
    				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                dojo.byId("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
                submitted = false;
            },
        };
        dojo.xhrPost(xhrArgs);
        return submitted;
	} //deleteFunction
	 
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','osid','');
 		createPostForm('OSForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
			<h1><%= messages.getString("os_select") %></h1>
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
				<li><%= messages.getString("os_edit_info") %></li>
				<li><%= messages.getString("os_delete_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=240"><%= messages.getString("os_add") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='OSForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display current operating systems available">
					<caption><em><%= OSView_RS.getResultSetSize() %> <%= messages.getString("os_found") %></em></caption>
					<% if (OSView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("os_name") %></th>
							<th scope="col"><%= messages.getString("os_abbr") %></th>
							<th scope="col"><%= messages.getString("os_sequence_number") %></th>
							<th scope="col"><%= messages.getString("comments") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						String osname = "";
						String osabbr = "";	
						String comments = "";
						int osid = 0;
						int sequencenum = 0;
						while(OSView_RS.next()) {
							osname = tool.nullStringConverter(OSView_RS.getString("OS_NAME"));
							osabbr = tool.nullStringConverter(OSView_RS.getString("OS_ABBR"));
							comments = tool.nullStringConverter(OSView_RS.getString("COMMENT"));
							osid = OSView_RS.getInt("OSID");
							sequencenum = OSView_RS.getInt("SEQUENCE_NUMBER");
					 %>
						<tr id='tr<%= osid %>'>
							<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= osid %>');"/><%= osname %></a></th>
							<td><%= osabbr %></td>
							<td><%= sequencenum %></td>
							<td><%= comments %></td>
							<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= osname %>','<%= osid %>')" ><%= messages.getString("delete") %></a></td>
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