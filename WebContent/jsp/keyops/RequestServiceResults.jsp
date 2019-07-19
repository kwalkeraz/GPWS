<%
	AppTools appTool = new AppTools();
	Cookie cEmail = new Cookie("EmailAddress",appTool.nullStringConverter(request.getParameter("email")));
	cEmail.setMaxAge(63072000);
	response.addCookie(cEmail);
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, request service results"/>
<meta name="Description" content="This page contains the results of the key operator request that was opened." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("request_service_results") %></title>
<%@ include file="metainfo2.jsp" %>

</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= statichtmldir %>/index.html"><%= messages.getString("global_print") %></a></li>
				<li><a href="<%= statichtmldir %>/USKeyOperatorServices.html"> <%= messages.getString("us_keyop_services") %></a></li>
				<li><a href="<%= keyops %>?next_page_id=2005"> <%= messages.getString("keyop_request_form") %></a></li>
			</ul>
			<h1><%= messages.getString("request_service_results") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
				
<% String sSubmitValue = request.getParameter("submitvalue");

	if (sSubmitValue.equals("employeelookup")) {
		String sEmail = request.getParameter("email");
		UserInfo bpLookup = new UserInfo(sEmail); 
		if (bpLookup.isValidEmployee() == false) { %>
        	<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2005&email=not%20found&email2=<%= sEmail %>&devicename=<%= request.getParameter("devicename")%>&devicename2=<%= request.getParameter("devicename")%>&site=<%= request.getParameter("site")%>&building=<%= request.getParameter("building")%>&floor=<%= request.getParameter("floor")%>&room=<%= request.getParameter("room")%>&description=<%= request.getParameter("description")%>";</script>
<%		} else { %>
			<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2005&email=<%= sEmail %>&name=<%= bpLookup.employeeName() %>&extphone=<%= bpLookup.empXphone() %>&tieline=<%= bpLookup.empTie() %>&devicename=<%= request.getParameter("devicename")%>&devicename2=<%= request.getParameter("devicename")%>&site=<%= request.getParameter("site")%>&building=<%= request.getParameter("building")%>&floor=<%= request.getParameter("floor")%>&room=<%= request.getParameter("room")%>&description=<%= request.getParameter("description")%>";</script>
<%		}
	} else if (sSubmitValue.equals("devicelookup")) {
		String sDevice = request.getParameter("devicename");
		RequestService reqService = new RequestService();
		reqService.DeviceLookup(sDevice);
		if (reqService.getIsValidDevice() == false || reqService.getIsSupportedDevice() == false) { %>
        	<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2005&devicename=<%= reqService.getDeviceName() %>&devicename2=<%= reqService.getDeviceName2() %>&email=<%= request.getParameter("email") %>&name=<%= request.getParameter("name") %>&extphone=<%= request.getParameter("extphone") %>&tieline=<%= request.getParameter("tieline") %>&description=<%= request.getParameter("description")%>";</script>
<%		} else { %>
			<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2005&email=<%= request.getParameter("email") %>&name=<%= request.getParameter("name") %>&extphone=<%= request.getParameter("extphone") %>&tieline=<%= request.getParameter("tieline") %>&devicename=<%= sDevice %>&devicename2=<%= reqService.getDeviceName2()%>&site=<%= reqService.getSite()%>&building=<%= reqService.getBuilding()%>&floor=<%= reqService.getFloor()%>&room=<%= reqService.getRoom()%>&description=<%= request.getParameter("description")%>";</script>
<%		}
	} else if (sSubmitValue.equals("submitform")) { 
		String sDevice = appTool.nullStringConverter(request.getParameter("devicename").toLowerCase());
		int[] iRC = new int[2];
		RequestService reqService = new RequestService();
		reqService.DeviceLookup(sDevice);
		if (reqService.getIsValidDevice() == false) { %>
        	<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2005&devicename=<%= reqService.getDeviceName() %>&devicename2=<%= reqService.getDeviceName2() %>&email=<%= request.getParameter("email") %>&nameid=<%= request.getParameter("nameid") %>&phoneid=<%= request.getParameter("phoneid") %>&tieid=<%= request.getParameter("tieid") %>&description=<%= request.getParameter("description")%>&logaction=<%= reqService.getDeviceName2() %> <%= messages.getString("not_found_in_gpws") %>&devicemessage=<%= reqService.getDeviceName2() %> <%= messages.getString("not_found_in_gpws") %>";</script>
<%		} else if (reqService.getIsSupportedDevice() == false) { %>
			<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2005&devicename=<%= reqService.getDeviceName() %>&devicename2=<%= reqService.getDeviceName2() %>&email=<%= request.getParameter("email") %>&nameid=<%= request.getParameter("nameid") %>&phoneid=<%= request.getParameter("phoneid") %>&tieid=<%= request.getParameter("tieid") %>&description=<%= request.getParameter("description")%>&logaction=<%= reqService.getDeviceName2() %> <%= messages.getString("not_supported") %>&devicemessage=<%= reqService.getDeviceName2() %> <%= messages.getString("not_supported") %>";</script>
<%		} else { 
			iRC = reqService.SubmitForm(request);
			if (iRC[0] == 0 || iRC[0] == 1 || iRC[0] == 3 || iRC[0] == 9) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2006a&devicename=<%= reqService.getDeviceName() %>&rc=<%= iRC[0] %>&rc2=<%= iRC[1] %>"</script>
<%			} else if (iRC[0] == 1) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2006a&devicename=<%= reqService.getDeviceName() %>&rc=1&rc2=<%= iRC[1] %>"</script>
<%			} else { %>
				<br /><br /><%= messages.getString("open_ticket_error") %><br />
				<br />
<%			}
		}
	} else { %>
		<br /><br /><%= messages.getString("open_ticket_fail") %><br /><br />
<%	}%>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>