<%  
	//boolean windowOnLoad = false;
	//boolean redirect = false;
	TableQueryBhvr CPApproval  = (TableQueryBhvr) request.getAttribute("CPApproval");
    TableQueryBhvrResultSet CPApproval_RS = CPApproval.getResults();
    TableQueryBhvr DeviceFunction = (TableQueryBhvr) request.getAttribute("DeviceFunction");
    TableQueryBhvrResultSet DeviceFunction_RS = DeviceFunction.getResults();
    TableQueryBhvr NotifyList = (TableQueryBhvr) request.getAttribute("NotifyList");
    TableQueryBhvrResultSet NotifyList_RS = NotifyList.getResults();
    
    String logaction = "";
    String complete_date = "";
	java.util.Calendar cal = java.util.Calendar.getInstance();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
	complete_date = sdf.format(cal.getTime());
	//Request
	String actiontype = request.getParameter("actiontype");
	String status = request.getParameter("status");
	String schedflow = request.getParameter("schedflow");
	String startdate = request.getParameter("startdate");
	String comments = request.getParameter("comments");
	String assignee = request.getParameter("assignee");
	String notifylist = "";
	String assigneeTeam = "";
	String step = request.getParameter("step");
	String pageid = request.getParameter(BehaviorConstants.TOPAGE);
	//
    
	String cpapprovalid = request.getParameter("cpapprovalid");
	String devicename = "";
	String action = "";
	String reqnum = "";
	String devicetype = "";
	String city = "";
	String building = "";
	String floor = "";
	String room = "";
	String devicefunctions = "";
	String reqstatus = "";
	String reqname = "";
	String reqemail = "";
	String referer = request.getParameter("referer");
	while (CPApproval_RS.next()) {
		reqnum = CPApproval_RS.getString("REQ_NUM");
		devicename = CPApproval_RS.getString("DEVICE_NAME");
		action = CPApproval_RS.getString("ACTION");
		city = CPApproval_RS.getString("CITY");
		building = CPApproval_RS.getString("BUILDING");
		floor = CPApproval_RS.getString("FLOOR");
		room = CPApproval_RS.getString("ROOM");
		reqstatus = CPApproval_RS.getString("REQ_STATUS");
		reqname = CPApproval_RS.getString("REQ_NAME");
		reqemail = CPApproval_RS.getString("REQ_EMAIL");
	}
	
	while (DeviceFunction_RS.next()) {
		if (assignee.equals("")) {
			devicefunctions = DeviceFunction_RS.getString("FUNCTION_NAME") + ", ";
		} else {
			devicefunctions = devicefunctions + DeviceFunction_RS.getString("FUNCTION_NAME") + ",";
		}
	}  //while DeviceFunctions
	
	while (NotifyList_RS.next()) {
		assigneeTeam = NotifyList_RS.getString("CATEGORY_CODE");
		if (assigneeTeam.equals(assignee)) {
			notifylist = NotifyList_RS.getString("CATEGORY_VALUE1");
			break;
		} else {
			notifylist = assignee;
		} //if-else
	}  //while NofityList
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print routing steps results"/>
	<meta name="Description" content="Global Print routing template steps results page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_select_routing_template_results") %></title>
	<%@ include file="metainfo2.jsp" %>

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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>"><%= messages.getString("cp_admin_routing_info") %></a></li>
			</ul>
			<h1><%= messages.getString("cp_select_routing_template_results") %></h1>
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
<%
	tools.print.commonprocess.UpdateRoutingSteps tools = new tools.print.commonprocess.UpdateRoutingSteps();
	tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
	PrinterTools tool = new PrinterTools();
	SendMail mailTool = new SendMail();
    String sServerName = tool.getServerName();
	
	String sendto = "";
	String subject = "";
	String targetpage = "";
	String targettype = "";
	String params = "";
	String url = "";
	String mailtext = "";
	String header = "";
	String body = "";
	String footer = "";
	String notifystatus = "No steps were found that need to be completed. No notifications were sent.";
	subject = "GPWS Request "+reqnum+": "+action+" "+devicetype+" "+devicename+" at "+city+", "+building+", Floor "+floor+", Room "+room;
	//if ((notifylist == null) || (notifylist == "")) {
	//	sendto = assignee;
	//} else {
	//	sendto = notifylist;
	//}
	sendto = notifylist;
	targetpage = "1105";		
	params = "&devicename=" + devicename + "&cpapprovalid=" + cpapprovalid + "&referer=" + referer + "&reqnum=" + reqnum;
	url="http://" + sServerName + commonprocess + "?" + BehaviorConstants.TOPAGE + "=" + targettype + targetpage + params;
	
	//mailtext = "A GPWS request is ready for your action.";
	body = body+"\n\nRequest number: "+reqnum;
	body = body+"\nRequest type: "+action;
	body = body+"\nDevice function(s): "+devicefunctions;
	body = body+"\nName: "+devicename;
	body = body+"\nCity: "+city;
	body = body+"\nBuilding: "+building;
	body = body+"\nFloor: "+floor;
	body = body+"\nRoom: "+room;
	//footer info
	footer = footer+"\n\nStep: "+step;
	footer = footer+"\nAction type: "+actiontype;
	footer = footer+"\nStatus: "+status;
	footer = footer+"\nAssigned to: "+assignee;
	if ((startdate != null) && (startdate != "")) {
		footer = footer+"\nStart date: "+startdate;
	}
	if ((comments != null) && (comments != "")) {
		footer = footer+"\nComments: "+comments;
	}
	footer = footer+"\n\n"+url;
	footer = footer+"\n\nIf you have received this message by error please forward it to the GPWS team.";
	//
	int iReturnCode = 0;
	if (pageid.equals("7405")) {
		//Insert action
		iReturnCode = tools.insertSteps(request);
		if (iReturnCode == 0) { 
			logaction = "Routing steps " + step + " - " + actiontype + " has been added for request " + reqnum;
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "CommonProcess"); 
			//if request is completed or rejected and a new step comes in, change the status to PENDING
			if (reqstatus.toUpperCase().equals("COMPLETED") || reqstatus.toUpperCase().equals("REJECTED")) {
				tools.updateApproval(request,"PENDING","");
			}
			//if a request is in progress, email the team responsible for the step
			if (status.toUpperCase().equals("IN PROGRESS")) {
				header = "A GPWS request is ready for your action.";
				mailtext = header + body + footer;
				mailTool.sendMail(sendto, subject, mailtext); 
			} %>
			<p><%= logaction %></p>                                   
			<script type="text/javascript">self.location.href = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>&logaction=<%= logaction %>&status=<%= status%>"</script>
<%		} else { 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
			  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
			  <%= messages.getString("user_results_error") %><br /><br />
			  <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br /> 
			  <b><%= messages.getString("error_message") %></b>:<br />
			  <p><a class="ibm-error-link" href="#"></a><%= errorMessage %></p>
<%
			} 
		   	catch( Exception e ) {}
		} //else
	} //add routing step
	else if (pageid.equals("7435")) {
		//Insert action
		iReturnCode = tools.editSteps(request);
		if (iReturnCode == 0) { 
			logaction = "Routing step " + step + " - " + actiontype + " has been edited for request " + reqnum;
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "CommonProcess"); 
			//if request is completed or rejected and a new step comes in, change the status to PENDING
			if (reqstatus.toUpperCase().equals("COMPLETED") || reqstatus.toUpperCase().equals("REJECTED")) {
				tools.updateApproval(request,"PENDING","");
			}
			//if a request is in progress, email the team responsible for the step
			if (status.toUpperCase().equals("IN PROGRESS")) {
				header = "A GPWS request is ready for your action.";
				mailtext = header + body + footer;
				mailTool.sendMail(sendto, subject, mailtext); 
			} %>
			<p><%= logaction %></p>                                   
			<script type="text/javascript">self.location.href = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>&logaction=<%= logaction %>&status=<%= status%>"</script>
<%		} else { 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
			  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
			  <%= messages.getString("user_results_error") %><br /><br />
			  <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br /> 
			  <b><%= messages.getString("error_message") %></b>:<br />
			  <p><a class="ibm-error-link" href="#"></a><%= errorMessage %></p>
<%
			} 
		   	catch( Exception e ) {}
		} //else
	} //else if page is edit step
	else if (pageid.equals("7440")) {
		//delete action
		iReturnCode = tools.deleteSteps(request);
		if (iReturnCode == 0) { 
			logaction = "Routing step " + step + " - " + actiontype + " has been deleted for request " + reqnum;
			logtool.logUserAction(pupb.getUserLoginID(), logaction, "CommonProcess"); 
			//if request is PENDING, and there are no more steps to complete, then the request should be set to COMPLETED
			if (!tools.moreSteps(request) && !reqstatus.toUpperCase().equals("REJECTED")) {
				tools.updateApproval(request,"COMPLETED",complete_date);
				header = "GPWS request has been COMPLETED";
				footer = "\n\nIf you have received this message by error please forward it to the GPWS team.";
				mailtext = header + body + footer;
				mailTool.sendMail(reqemail, subject, mailtext); 
			} //more steps
			%>
			<p><%= logaction %></p>                                   
			<script type="text/javascript">self.location.href = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7420&cpapprovalid=<%= cpapprovalid %>&reqnum=<%= reqnum %>&logaction=<%= logaction %>&status=<%= status%>"</script>
<%		} else { 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
			  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
			  <%= messages.getString("user_results_error") %><br /><br />
			  <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br /> 
			  <b><%= messages.getString("error_message") %></b>:<br />
			  <p><a class="ibm-error-link" href="#"></a><%= errorMessage %></p>
<%
			} 
		   	catch( Exception e ) {}
		} //else
	} //else if page is delete step
%>
	</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>