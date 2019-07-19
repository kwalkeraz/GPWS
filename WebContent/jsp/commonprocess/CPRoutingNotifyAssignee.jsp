<%@page import="tools.print.lib.*, tools.print.commonprocess.*, java.text.*, java.util.*, tools.print.printer.*" %>
<%
	PrinterTools tool = new PrinterTools();
	UpdateRoutingSteps tools = new UpdateRoutingSteps();
	
	TableQueryBhvr CPApproval  = (TableQueryBhvr) request.getAttribute("CPApproval");
	TableQueryBhvrResultSet CPApproval_RS = CPApproval.getResults();
	TableQueryBhvr CPRouting  = (TableQueryBhvr) request.getAttribute("CPRouting");
	TableQueryBhvrResultSet CPRouting_RS = CPRouting.getResults();
	TableQueryBhvr DeviceFunction = (TableQueryBhvr) request.getAttribute("DeviceFunction");
    TableQueryBhvrResultSet DeviceFunction_RS = DeviceFunction.getResults();
   	
// Get basic request data
	String reqnum = "";
	String completedstep = "";
	String completedstepstatus = request.getParameter("status");
	String completeby = request.getParameter("completeby");
	String referer = request.getParameter("referer");
	String rejectcomments = request.getParameter("comments");
	int cpapprovalid = 0;
	String action = "";
	String complete_date = "";
	Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	complete_date = sdf.format(cal.getTime());
	
	String devicetype = "";
	String devicename = "";
	String city = "";
	String building = "";
	String floor = "";
	String room = "";
	String reqname = "";
	String reqemail = "";
	String reqstatus = "";
	String devicefunctions = "";
	String logaction = request.getParameter("logaction");;
	while (DeviceFunction_RS.next()) {
		if (devicefunctions.equals("")) {
			devicefunctions = DeviceFunction_RS.getString("FUNCTION_NAME") + ", ";
		} else {
			devicefunctions = devicefunctions + DeviceFunction_RS.getString("FUNCTION_NAME") + ",";
		}
	}  //while DeviceFunctions
	
	if (CPApproval_RS.next()) {
		reqnum = CPApproval_RS.getString("REQ_NUM");
		devicename = CPApproval_RS.getString("DEVICE_NAME");
		city = CPApproval_RS.getString("CITY");
		building = CPApproval_RS.getString("BUILDING");
		floor = CPApproval_RS.getString("FLOOR");
		room = CPApproval_RS.getString("ROOM");
		cpapprovalid = CPApproval_RS.getInt("CPAPPROVALID");
		action = CPApproval_RS.getString("ACTION");
		reqname = CPApproval_RS.getString("REQ_NAME");
		reqemail = CPApproval_RS.getString("REQ_EMAIL");
		reqstatus = CPApproval_RS.getString("REQ_STATUS");
	}
	
	int cproutingid=0;
	String assignee = "";
	String notifylist = "";
	int step = 0;
	String actiontype = "";
	String status = "";
	String schedflow = "";
	String startdate = "";
	String comments = "";
	String sendto = "";
	String subject = "";
	String targetpage = "";
	String targettype = "";
	String params = "";
	String url = "";
	String mailtext = "";
	String notifystatus = "No steps were found that need to be completed. No notifications were sent.";
	boolean moreSteps = false;

    SendMail mailTool = new SendMail();
    String sServerName = tool.getServerName();
    AppTools logtool = new AppTools();
    SaveData SaveBean = new SaveData();
    
    String header = "";
	String body = "";
	String footer = "";
	targetpage = "1105";
%>
	<%@ include file="GetCurrentDateTime.jsp" %>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print notify assignee"/>
	<meta name="Description" content="Global print website notify assignee of GPWS request" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("cp_routing_step_results") %></title>
	<%@ include file="metainfo2.jsp" %>

<%
    params = "&devicename=" + devicename + "&cpapprovalid=" + cpapprovalid + "&referer=" + referer + "&reqnum=" + reqnum;
	url="http://" + sServerName + commonprocess + "?" + BehaviorConstants.TOPAGE + "=" + targettype + targetpage + params;
	String urlreq = "http://" + sServerName + commonprocess + "?" + BehaviorConstants.TOPAGE + "=1003&reqnum=" + reqnum.toUpperCase() +"&cpapprovalid=" + cpapprovalid;
	//body info
	body = body+"\n\nRequest number: "+reqnum;
	body = body+"\nRequest type: "+action;
	body = body+"\nDevice function(s): "+devicefunctions;
	body = body+"\nName: "+devicename;
	body = body+"\nCity: "+city;
	body = body+"\nBuilding: "+building;
	body = body+"\nFloor: "+floor;
	body = body+"\nRoom: "+room;
	
    boolean result = false;
 
// If first open step is the same as the step that was just completed, do not notify.
// This condition is caught in the SQL.
// Loop through steps and send notifications.
	int loopcount = 0;
	int saveresult = 0;
	String output;
	
	//Check to see if the request is not REJECTED
	if (!completedstepstatus.toUpperCase().equals("REJECTED")) {
		while (CPRouting_RS.next()) {
			cproutingid = CPRouting_RS.getInt("CPROUTINGID");
			assignee = CPRouting_RS.getString("ASSIGNEE");
			notifylist = CPRouting_RS.getString("CATEGORY_VALUE1");
			step = CPRouting_RS.getInt("STEP"); 
			actiontype = CPRouting_RS.getString("ACTION_TYPE");
			status = CPRouting_RS.getString("STATUS");
			schedflow = CPRouting_RS.getString("SCHED_FLOW");
			comments = CPRouting_RS.getString("COMMENTS");
			startdate = CurrentDate;
			notifystatus = "Notifications were sent for the next step.";
			status = "IN PROGRESS";
			if (devicetype == null) { devicetype = ""; }
			if (comments == null) { comments = ""; }
			if (devicename == null) { devicename = ""; }
			if ((notifylist == null) || (notifylist == "")) {
				sendto = assignee;
			} else {
				sendto = notifylist;
			}
			if (tools.notifyCustomer(actiontype)) {
				subject = "GPWS Request "+reqnum+": "+action+" "+devicetype+" "+devicename+" - update";
				header = "Your request has been sent to " + assignee + " for the next step: " + actiontype;
				footer = "\n\nPlease allow up to 10 business days in order for this step to be completed.";
				footer = footer + "\n\n"+urlreq;
				mailtext = header + body + footer;
				mailTool.sendMail(reqemail, subject, mailtext);
			} //if notifyCustomer
			
			subject = "GPWS Request "+reqnum+": "+action+" "+devicetype+" "+devicename+" at "+city+", "+building+", Floor "+floor+", Room "+room;
			header = "A GPWS request is ready for your action.";
			//footer info
			footer = "\n\nStep: "+step;
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
			mailtext = header + body + footer;
			result = mailTool.sendMail(sendto, subject, mailtext);
			//result = true;
			moreSteps = true;
	
			if (result) {
				saveresult=SaveBean.updateRoutingStep(request, cproutingid, status, startdate);
			}
		}  //while
	} //if not rejected
	else if (completedstepstatus.toUpperCase().equals("REJECTED")) {
		subject = "GPWS Request "+reqnum+": "+action+" "+devicetype+" "+devicename+" at "+city+", "+building+", Floor "+floor+", Room "+room;
		header = "GPWS request has been " + completedstepstatus.toUpperCase();
		footer = "\nComments:"+rejectcomments;
		footer = footer+"\n\nIf you have received this message by error please forward it to the GPWS team.";
		footer = footer + "\n\n"+urlreq;
		mailtext = header + body + footer;
		sendto = completeby +";"+reqemail;
		mailTool.sendMail(sendto, subject, mailtext);
		saveresult = tools.updateApproval(request,"REJECTED",complete_date);
		moreSteps = false;
	} //else step was rejected
	
	if(saveresult > 0) {
		output="An error occured processing your request. Please resubmit. If the error persists please contact the helpdesk";
	} else {
		logtool.logUserAction(pupb.getUserLoginID(), logaction, "CommonProcess");
	}
%>
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
				<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=7460&cproutingid=<%= cproutingid %>"><%= messages.getString("cp_complete_routing_step") %></a></li>
			</ul>
			<h1><%= messages.getString("cp_routing_step_results") %></h1>
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
			<p>
				<%= logaction %>
				<br />
				<%= notifystatus %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='CPRouting'>
				<% if (!moreSteps && !completedstepstatus.toUpperCase().equals("REJECTED")) { 
					subject = "GPWS Request "+reqnum+": "+action+" "+devicetype+" "+devicename+" at "+city+", "+building+", Floor "+floor+", Room "+room;
					header = "GPWS request has been COMPLETED";
					footer = "\n\nIf you have received this message by error please forward it to the GPWS team.";
					footer = footer + "\n\n"+urlreq;
					mailtext = header + body + footer;
					sendto = completeby +";"+reqemail;
					saveresult = tools.updateApproval(request,"COMPLETED",complete_date);
					mailTool.sendMail(sendto, subject, mailtext);
				} //if there are no more steps available and the request is not rejected
				else if (moreSteps && reqstatus.toUpperCase().equals("NEW")) {
					saveresult = tools.updateApproval(request,"PENDING","");
				}
				
			   if (saveresult == 0) { %>
				<script type="text/javascript">self.location.href = "<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1105&devicename=<%= devicename %>&cpapprovalid=<%= cpapprovalid %>&referer=<%= referer %>&reqnum=<%= reqnum %>&logaction=<%= logaction %>"</script>
			<% } %>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>