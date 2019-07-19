<%@page import="java.text.*" %>
<%
   TableQueryBhvr CPRoutingView  = (TableQueryBhvr) request.getAttribute("CPRouting");
   TableQueryBhvrResultSet CPRoutingView_RS = CPRoutingView.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   String reqnum = tool.nullStringConverter(request.getParameter("reqnum"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	String devicename = "";
	//int cpapprovalid = 0;
	String cpapprovalid = tool.nullStringConverter(request.getParameter("cpapprovalid"));
	String action = "";
	while (CPRoutingView_RS.next()) {
		///reqnum = CPRoutingView_RS.getString("REQ_NUM");
		devicename = CPRoutingView_RS.getString("DEVICE_NAME");
		//cpapprovalid = CPRoutingView_RS.getInt("CPAPPROVALID");
		action = CPRoutingView_RS.getString("ACTION");
	}
	int step = 0;
	String actiontype = "";
	String status = "";
	String assignee = "";
	String startdate = "";
	String completedate = "";
	String comments = "";
	String trstart = "";
	String rowspan = "";
	int cproutingid = 0;
	boolean bFlag = true;
	int iGray =0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print routing information"/>
	<meta name="Description" content="Global print website list current routing information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_admin_routing_info") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Tooltip");

	function callLoadTemplate(cpapprovalid) {
		var params ="&cpapprovalid=" + cpapprovalid;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7450" + params;
	}
	function callAdd(cpapprovalid,reqnum) {
		var params = "&cpapprovalid=" + cpapprovalid + "&reqnum=" + reqnum;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7400" + params;
	} //callAdd
	
	function callEdit(cproutingid) {
		var params ="&cproutingid=" +cproutingid;
		document.location.href="<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7430" + params;
	} //callEdit
	
	function callCancel() {
		document.location.href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=250"
	} //callCancel
	
	function setFormValues(msg,cproutingid){
		var topageid = "7440";
		dojo.byId("<%= BehaviorConstants.TOPAGE %>").value = topageid;
		dojo.byId("cproutingid").value = categoryid;
		dojo.byId('logaction').value = msg;
	} //setFormValues
	
	function callDelete(cproutingid,step,reqnum,cpapprovalid,action) {
		var msg = "Routing information for request " + reqnum + " - step " + step + " - " + action + " has been deleted";
		var confirmDelete = confirm('<%= messages.getString("cp_sure_delete_routing_info") %> ' + reqnum + ' - step ' + step + " - " + action + '?');
		if (confirmDelete) {
			dojo.byId('cpapprovalid').value = cpapprovalid;
			dojo.byId('step').value = step;
			dojo.byId('actiontype').value = action;
			dojo.byId('reqnum').value = reqnum;
			dojo.byId('cproutingid').value = cproutingid;
			dojo.byId('logaction').value = msg;
			dojo.byId('userid').value = "<%= session.getAttribute("userid") %>";
			dojo.byId('deleteForm').submit();
		} //if yesno
	} //callDelete
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','7440');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cproutingid','');
        createHiddenInput('logactionid','cpapprovalid','');
        createHiddenInput('logactionid','step','');
        createHiddenInput('logactionid','actiontype','');
        createHiddenInput('logactionid','reqnum','');
        createHiddenInput('logactionid','userid','');
        createPostForm('routingForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= commonprocess %>');
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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1805"><%= messages.getString("cp_workflow_process") %></a></li>
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1105&devicename=<%= devicename %>&cpapprovalid=<%= cpapprovalid %>&referer=<%= referer %>&reqnum=<%= reqnum %>"><%= messages.getStringArgs("cp_manage_device", new String[] {action.toLowerCase(), devicename}) %></a></li>
			</ul>
			<h1><%= messages.getString("cp_admin_routing_info") %></h1>
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
				<li><a href="javascript:callAdd('<%= cpapprovalid %>','<%= reqnum %>');"/><%= messages.getString("cp_add_routing_info") %></a></li>	
				<li><%= messages.getString("cp_edit_routing_link") %></li>
				<li><a href="javascript:callLoadTemplate('<%= cpapprovalid %>');"/><%= messages.getString("cp_load_routing_template") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='routingForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List of common process request routing information">
					<caption><em><%= messages.getString("device_request_number") %> <%= reqnum %></em></caption>
					<% if (CPRoutingView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("step") %></th>
							<th scope="col"><%= messages.getString("action_type") %></th>
							<th scope="col"><%= messages.getString("status") %></th>
							<th scope="col"><%= messages.getString("assignee") %></th>
							<th scope="col"><%= messages.getString("start_date") %></th>
							<th scope="col"><%= messages.getString("completed_date") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
						SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd MMM yyyy");
						java.util.Date dValid = null;
							CPRoutingView_RS.first();
							while(CPRoutingView_RS.next()) {
								step = CPRoutingView_RS.getInt("STEP");
								actiontype = tool.nullStringConverter(CPRoutingView_RS.getString("ACTION_TYPE"));
								status = tool.nullStringConverter(CPRoutingView_RS.getString("STATUS"));
								assignee = tool.nullStringConverter(CPRoutingView_RS.getString("ASSIGNEE"));
								startdate = tool.nullStringConverter(CPRoutingView_RS.getString("START_DATE"));
								completedate = tool.nullStringConverter(CPRoutingView_RS.getString("COMPLETED_DATE"));
								comments = tool.nullStringConverter(CPRoutingView_RS.getString("ROUTING_COMMENTS"));
								cproutingid = CPRoutingView_RS.getInt("CPROUTINGID");
								try {
									if (startdate != null && !startdate.equals("")) {
										try {
									    	dValid = dateFormat.parse(startdate);
									    	startdate = dateFormat2.format(dValid);
									    }
									    catch(ParseException e) {
								  			startdate = tool.nullStringConverter(CPRoutingView_RS.getString("START_DATE"));
									    }
							    	} else {
							    		startdate = "";
							    	}
						  		}
						  		catch(NullPointerException e) {
						  			startdate = "";
							    //Ignore any null pointer exceptions that may occur
							    //dValid is still null, so a start date won't be used
						  		}
						  		try {
						  			if (completedate != null && !completedate.equals("")) {
						  				try {
									    	dValid = dateFormat.parse(completedate);
									    	completedate = dateFormat2.format(dValid);
									    }
									    catch (ParseException e) {
									    	completedate = tool.nullStringConverter(CPRoutingView_RS.getString("COMPLETED_DATE"));
									    }
							    	} else {
							    		completedate = "";
							    	}
						  		}
						  		catch(NullPointerException e) {
						  			completedate = "";
							    //Ignore any null pointer exceptions that may occur
							    //dValid is still null, so a completedate won't be used
						  		}
						  		if (comments.equals("")) {
									rowspan = "<td>";
								} else {
									rowspan = "<td rowspan=2>";
								}
					 %>
						<tr>
							<%= rowspan %><a href="javascript:callEdit('<%= cproutingid %>');"/><%= step %></a></td>
							<td><%= actiontype %></td>
							<td><%= status %></td>
							<td><%= assignee %></td>
							<td><%= startdate %></td>
							<td><%= completedate %></td>
							<td>
								<a class="ibm-delete-link" href="javascript:callDelete('<%= cproutingid%>','<%= step %>','<%= reqnum %>','<%= cpapprovalid%>','<%= actiontype%>')"><%= messages.getString("delete") %></a>
							</td>
						</tr>
							<% if (!comments.equals("")) { %>
						<tr>
							<td align="right"><b><%= messages.getString("comments") %></b></td>
							<td colspan=5><%= comments %></td>
						</tr>
							<% } %>
							<% } %>
					</tbody>
					<% } else { %>
					<thead>
						<tr>
							<th scope="col"><a href="javascript:callAdd('<%= cpapprovalid %>','<%= reqnum %>');"/><%= messages.getString("cp_add_routing_info") %></a></th>
						</tr>
					</thead>
					<% } //else %>
				</table> 
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>