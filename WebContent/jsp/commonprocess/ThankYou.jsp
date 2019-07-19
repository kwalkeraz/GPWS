	<%@page import="tools.print.commonprocess.*" %>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print device add thank you"/>
	<meta name="Description" content="Thank you for submitting your printer request page." />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_request_results") %></title>
	<%@ include file="metainfo2.jsp" %>
	<jsp:useBean id="SaveBean" scope="page"class="tools.print.printer.SaveData" />
	<%@ include file="GetCurrentDateTime.jsp" %>
	
<%
	TableQueryBhvr Loc  = (TableQueryBhvr) request.getAttribute("LocInfo");
	TableQueryBhvrResultSet Loc_RS = Loc.getResults();
	TableQueryBhvr DeviceType  = (TableQueryBhvr) request.getAttribute("DeviceType");
	TableQueryBhvrResultSet DeviceType_RS = DeviceType.getResults();
	TableQueryBhvr CPAssignee  = (TableQueryBhvr) request.getAttribute("CPAssignee");
	TableQueryBhvrResultSet CPAssignee_RS = CPAssignee.getResults();
	
    AppTools tool = new AppTools();
    UpdateRoutingSteps steptools = new UpdateRoutingSteps();
   	int locid = 0;
   	String sitecode = "";

   	while (Loc_RS.next()) {
		locid = Loc_RS.getInt("LOCID");
		sitecode = tool.nullStringConverter(Loc_RS.getString("SITE_CODE"));
	}
	
	String type = tool.nullStringConverter(request.getParameter("action"));
	String receiver	= "";
	String prtname = "";	
	String dipp = "";
	String mailtext = "";
	String subject = "GPWS Request: ";
    SendMail mailTool = new SendMail();
    String sender = tool.nullStringConverter(request.getParameter("email"));
    boolean result = false;
    String country = "";
    String countryabbr = "";
    String site = "";
    String building = "";
    String floor = "";
    String room = "";
    String geoplex = tool.nullStringConverter(request.getParameter("sdc"));
    String analyst  = "";
    String email = "";
    if (CPAssignee_RS.next()) {
		analyst = tool.nullStringConverter(CPAssignee_RS.getString("CP_ANALYST"));
		email = tool.nullStringConverter(CPAssignee_RS.getString("EMAIL"));
    }
	if (email.equals("")) {
		receiver = analyst;
	} else {
		receiver = email;
	}
	dipp = tool.nullStringConverter(request.getParameter("dipp"));	
	country = tool.nullStringConverter(request.getParameter("country"));
	countryabbr = tool.nullStringConverter(request.getParameter("countryabbr"));
	site = tool.nullStringConverter(request.getParameter("city"));
	building = tool.nullStringConverter(request.getParameter("building"));
	floor = tool.nullStringConverter(request.getParameter("floor"));
	room = tool.nullStringConverter(request.getParameter("room"));
	String devFunc = "";
	int iDevFunc = 0;
	while(DeviceType_RS.next()) {
		devFunc = tool.nullStringConverter(request.getParameter(DeviceType_RS.getString("CATEGORY_VALUE1")) + "type");
		if (devFunc.equals("print")) {
			iDevFunc = 3;
			break;
		} else if (devFunc.equals("copy")) {
			if (iDevFunc < 3) {
				iDevFunc = 2;
			}
		} else if (devFunc.equals("fax")) {
			if (iDevFunc < 2) {
				iDevFunc = 1;
			}
		}
	} //while
	
	if (iDevFunc == 3) {
		if (!dipp.equals("") && dipp.equals("Y")) {
			devFunc = "dipp";
		} else {
			devFunc = "print";
		}
	} else if (iDevFunc == 2) {
		devFunc = "copy";
	} else if (iDevFunc == 1) {
		devFunc = "fax";
	}
	int saveresult = -1;
	String output;
	String reqnum = tool.nullStringConverter(request.getParameter("reqnum"));
	String status = tool.nullStringConverter(request.getParameter("status"));
	String appErrors = "";

	if(type.equals("ADD")) {
		GetDeviceName.setParams(countryabbr.toLowerCase(),sitecode.toLowerCase(),devFunc);
		prtname = GetDeviceName.getName();
		if (prtname == null) {
			prtname = "";
		}
		SaveBean.setPrtName(locid,prtname);
		saveresult = SaveBean.saveData(request,response);
		if(saveresult == 1) {
			//output="Your request was submitted, however an error occurred during notification of this request. Your request number is " + reqnum + " and can be used to track your request";
			appErrors += " There was an error inserting the device functions for the new device.";
		} else if (saveresult == 2) {
			appErrors += " There was an error creating the device.";
		}
		
		saveresult = SaveBean.saveReqData(reqnum, prtname);
		if(saveresult == 2) {
			//output="Your request was submitted, however an error occurred during notification of this request. Your request number is " + reqnum + " and can be used to track your request";
			appErrors += " There was an error updating the cp_approval record.";
		}
	} else {
		prtname = request.getParameter("devicename");
		SaveBean.setCPApprovalID(Integer.parseInt((request.getAttribute("cpapprovalid").toString())));
	}
	
	saveresult = SaveBean.createRoutingStep(reqnum, "1", "Analyze", "IN PROGRESS", analyst, CurrentDate);
	
	if(saveresult == 1) {
		//output="Your request was submitted, however an error occurred during notification of this request. Your request number is " + reqnum + " and can be used to track your request";
		appErrors += " There was an error creating the routing step.";
	}
	//keyopTools keyTool = new keyopTools();
	PrinterTools tools = new PrinterTools();
	String sServerName = tools.getServerName();
	String url="http://" + sServerName + commonprocess + "?" + BehaviorConstants.TOPAGE + "=1105&reqnum=" + reqnum +"&referer=549&devicename=" + prtname + "&cpapprovalid=" + request.getAttribute("cpapprovalid");
	if(type.equals("DELETE")) {
		subject = subject + "Delete Device Request";
		mailtext = "A request to delete device " + prtname + " has been submitted for your review." + appErrors + " If you have received this message by error please forward it to the GPWS team. Here is a URL link to the request document:\n\n" + url;
		result = mailTool.sendMail(receiver, subject, mailtext);
		
	} else if(type.equals("CHANGE")) {
	   	subject = subject + "Change Device Request";
		mailtext = "A request to change device " + prtname + " has been submitted for your review." + appErrors + " If you have received this message by error please forward it to the GPWS team. Here is a URL link to the request document:\n\n" + url;
		result = mailTool.sendMail(receiver, subject, mailtext);
		
	} else if(type.equals("ADD")) {
		subject = subject + "Add device " + prtname + " at " + site + ", " + building + ", Floor " + floor + ", Room " + room;
		mailtext = "A request to add device " + prtname + " has been submitted for your review." + appErrors + " If you have received this message by error please forward it to the GPWS team. Here is a URL link to the request document:\n\n" + url;
		result = mailTool.sendMail(receiver, subject, mailtext);
	} //
	//mail the customer that their request is pending
		subject = "GPWS request " + reqnum + " has been submitted";
		url="http://" + sServerName + commonprocess + "?" + BehaviorConstants.TOPAGE + "=1003&reqnum=" + reqnum.toUpperCase() +"&cpapprovalid=" + request.getAttribute("cpapprovalid");
		mailtext = "Your request has been submitted for further review. If you have received this message by error please forward it to the GPWS team. The status of this request can be viewed here:\n\n" + url;
		mailTool.sendMail(sender, subject, mailtext);
	//end of user notification
	
	if (result == true) {
		//output="Your request has been submitted successfully and is awaiting review.<br /><br />The request number for tracking is: " + reqnum;
	} else {
		System.out.println("Failure 1");
		//output="Your request was submitted, however an error occurred during notification of this request. Your request number is " + reqnum + " and can be used to track your request";
	}
%>

	<script type="text/javascript">
	function callCancel() {
		parent.opener.window.focus();
		window.close();
	}
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead.jsp" %>
		<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<ul id="ibm-navigation-trail">
					<li><a href="<%= statichtmldir %>/ServiceRequests.html"><%= messages.getString("service_requests") %></a></li>
					<li><a href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("macdel_requests") %></a></li>
					<% if(type.equals("ADD")) { %>
						<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1010"><%= messages.getString("device_request_connection") %></a></li>
					<% } else { %>
						<li><a href="<%= commonprocess %>?to_page_id=1020"><%= messages.getString("device_modify_request") %></a></li>
					<% } %>
				</ul>
				<h1><%= messages.getString("device_request_results") %></h1>
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
				<%= messages.getString("request_submitted_success") %>
			</p>
			<p>
				<%= messages.getString("req_num_tracking") %> <a href="<%= commonprocess %>?to_page_id=1003&reqnum=<%= reqnum.toUpperCase() %>&cpapprovalid=<%= request.getAttribute("cpapprovalid") %>"><%= reqnum %></a>
			</p>
			<p>
				<%= messages.getString("home_link") %> <a class="prtadmin-navlink" href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("home") %></a>
			</p>
		<!-- LEADSPACE_END -->
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>