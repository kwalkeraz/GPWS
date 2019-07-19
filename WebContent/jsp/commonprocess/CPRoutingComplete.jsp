<%@page import="java.text.*" %>
<%	TableQueryBhvr CPRoutingView  = (TableQueryBhvr) request.getAttribute("CPRouting");
	TableQueryBhvrResultSet CPRoutingView_RS = CPRoutingView.getResults();
	AppTools tool = new AppTools();

	String cproutingid = tool.nullStringConverter(request.getParameter("cproutingid"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd MMM yyyy");
	java.util.Date dValid = null;
	CPRoutingView_RS.next();
	String reqnum = CPRoutingView_RS.getString("REQ_NUM");
	int step = CPRoutingView_RS.getInt("STEP");
	int cpapprovalid = CPRoutingView_RS.getInt("CPAPPROVALID");
	String actiontype = tool.nullStringConverter(CPRoutingView_RS.getString("ACTION_TYPE"));
	String action = tool.nullStringConverter(CPRoutingView_RS.getString("ACTION"));
	String status = tool.nullStringConverter(CPRoutingView_RS.getString("STATUS"));
	String assignee = tool.nullStringConverter(CPRoutingView_RS.getString("ASSIGNEE"));
	String schedflow = tool.nullStringConverter(CPRoutingView_RS.getString("SCHED_FLOW"));
	String startdate = tool.nullStringConverter(CPRoutingView_RS.getString("START_DATE"));
	try {
	    	dValid = dateFormat.parse(startdate);
	    	startdate = dateFormat2.format(dValid);
	  	}
	  	catch(NullPointerException e) {
	  		startdate = "";
	  	}
	String completedby = tool.nullStringConverter(CPRoutingView_RS.getString("COMPLETE_BY"));
	String completedate = tool.nullStringConverter(CPRoutingView_RS.getString("COMPLETED_DATE"));
	String devicename = tool.nullStringConverter(CPRoutingView_RS.getString("DEVICE_NAME"));
	String comments = tool.nullStringConverter(CPRoutingView_RS.getString("ROUTING_COMMENTS"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print routing complete page"/>
	<meta name="Description" content="Global print website cp routing completion page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_complete_routing_step") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.Button");
	 
	 function callCancel(){
	 	history.go(-1);
	 } //cancelForm
	 
	 function callComplete(completetype) {
		var step = "<%= step %>";
		var assignee = "<%= assignee %>"
		var reqnum = "<%= reqnum %>";
		var logactionid = dojo.byId('logaction');
        var logaction = "Routing step " + step + " for request " + reqnum + ", has been " + completetype.toUpperCase();
		logactionid.value = logaction;
		if (completetype == "Completed" || completetype == "Rejected") {
			if (assignee == "") {
				alert("<%= messages.getString("assign_team") %>");
				return false;
			} //if assignee is empty
		} //if
		if (completetype == "Rejected") {
			var validAns = false;
			while (validAns == false) {
				var rejectans = prompt("<%= messages.getString("please_enter_reject_reason") %>: ","");
				if ((rejectans == "")) {
					alert("<%= messages.getString("must_enter_reject_reason") %>");
					validAns = false;
				} else if (rejectans == null) {
					return false;
				} else {
					var origcomments = "";
					var comments = dojo.byId('comments');
					origcomments = comments.value;
					origcomments = origcomments + "\n\nRequest rejected by " + "<%= pupb.getUserLoginID() %>" + "\n" + rejectans;
					comments.value = origcomments;
					validAns = true;
				} //if
			}  //while
		} //if rejected
		dojo.byId('status').value = completetype.toUpperCase();
		dojo.byId('CPRoutingComplete').submit();
	 }  //callComplete
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '7465');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','cproutingid','<%= cproutingid %>');
        createHiddenInput('logactionid','cpapprovalid','<%= cpapprovalid %>');
        createHiddenInput('logactionid','devicename','<%= devicename %>');
        createHiddenInput('logactionid','step','<%= step %>');
        createHiddenInput('logactionid','assignee','<%= assignee %>');
        createHiddenInput('logactionid','actiontype','<%= actiontype %>');
        createHiddenInput('logactionid','completedate','<%= completedate %>');
        createHiddenInput('logactionid','comments','<%= comments %>');
        createHiddenInput('logactionid','status','');
        createpTag();
        createInputButton('submit_complete_button','ibm-submit','<%= messages.getString("cp_complete_step") %>','ibm-btn-arrow-pri','submit_step','callComplete(\'Completed\')');
 		//createSpan('submit_add_button','ibm-sep');
 		createInputButton('submit_reject_button','ibm-submit','<%= messages.getString("cp_reject_step") %>','ibm-btn-arrow-pri','reject_step','callComplete(\'Rejected\')');
	 	//createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_cancel_button','ibm-submit','<%= messages.getString("cp_cancel_step") %>','ibm-btn-arrow-pri','cancel_step','callComplete(\'Cancelled\')');
     	//createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_go_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_button','callCancel()');
     	createPostForm('CPRouting','CPRoutingComplete','CPRoutingComplete','ibm-column-form','<%= commonprocess %>');
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
			<h1><%= messages.getString("cp_complete_routing_step") %></h1>
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
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='CPRouting'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='reqnum'><%= messages.getString("device_request_number") %>:</label>
					<%= reqnum %>
				</div>
				<div class="pClass">
					<label for='step'><%= messages.getString("step") %>:</label>
					<a href="<%= commonprocess %>?to_page_id=7430&cproutingid=<%= cproutingid %>"><%= step %></a>
				</div>
				<div class="pClass">
					<label for='actiontype'><%= messages.getString("action_type") %>:</label>
					<%= actiontype %>
				</div>
				<div class="pClass">
					<label for='status'><%= messages.getString("status") %>:</label>
					<%= status %>
				</div>
				<div class="pClass">
					<label for='assignee'><%= messages.getString("assignee") %>:</label>
					<%= assignee %>
				</div>
				<div class="pClass">
					<label for='schedflow'><%= messages.getString("schedule_flow") %>:</label>
					<%= schedflow %>
				</div>
				<div class="pClass">
					<label for='startdate'><%= messages.getString("start_date") %>:</label>
					<%= startdate %>
				</div>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table">
				<thead>
					<tr>
						<th scope="col">
							<span>
								<div id='submit_complete_button'></div>
							</span>
						</th>
						<th scope="col">
							<span>
								<div id='submit_reject_button'></div>
							</span>
						</th>
						<th scope="col">
							<span>
								<div id='submit_cancel_button'></div>
							</span>
						</th>
						<th scope="col">
							<span>
								<div id='submit_go_button'></div>
							</span>
						</th>
					</tr>
				</thead>
			</table>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>