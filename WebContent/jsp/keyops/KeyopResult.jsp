<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, result"/>
<meta name="Description" content="This page displays the results of several differnt keyop actions." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_results") %></title>
<%@ include file="metainfo2.jsp" %>
</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead.jsp" %>
		<!-- LEADSPACE_BEGIN -->
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<ul id="ibm-navigation-trail">
					<li><a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("Keyop_Admin_Home") %></a></li>
				</ul>
				<h1><%= messages.getString("keyop_results") %></h1>
			</div> <!--  Leadspace-body -->
		</div> <!--  Leadspace-head -->
		<!-- LEADSPACE_END -->
		<%@ include file="../prtadmin/nav.jsp" %>
		<!-- All the main body stuff goes here -->
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">

<%
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	int iKOCompanyID = pupb.getVendorID();
	
		String sCase = request.getParameter("submitvalue");
		int iTicketNo = Integer.parseInt(request.getParameter("ticketno"));
		String sTicketNo = iTicketNo + "";
		String logaction = request.getParameter("logaction");
		
		if (sCase.equals("addNote")) {
			KeyopTicket keyop = new KeyopTicket();
			String sSolution = request.getParameter("notetextvalue");
			int iReturnCode = keyop.AddNote(iTicketNo, sSolution, pupb.getUserLoginID(), request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>&logaction=<%= logaction %>";</script>
<%			} else if ( iReturnCode == 1 ) { %>
				<br /><br /><%= messages.getStringArgs("update_notify_success_cc_fail", new String[] {sTicketNo}) %><br /><br />
				<a href="<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %> <%= iTicketNo %></a>
				<br />
<%			} else if ( iReturnCode == 2 ) { %>
				<br /><br /><%= messages.getStringArgs("update_success_notify_fail", new String[] {sTicketNo}) %><br /><br />
				<a href="<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %> <%= iTicketNo %></a>
				<br />
<%			} else { %>
				<br /><br /><%= messages.getString("update_database_error") %><br /><br />
				<a href="<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %> <%= iTicketNo %></a>
				<br />
<%			} 
		} else if (sCase.equals("assignToMe")) { 
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.AssignTo(pupb.getUserID(), pupb.getUserLoginID(), iTicketNo, request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>&logaction=<%= logaction %>";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("assign_error") %>
				<br />
<%			}
				
		} else if (sCase.equals("closeTicket")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.CloseTicket(pupb.getUserLoginID(), request);
			
			if ( iReturnCode == 0 ) { %>
				<br /><br /><%= messages.getStringArgs("close_notify_success", new String[] {sTicketNo}) %>&nbsp;<a href="<%=keyops %>?next_page_id=2017&amp;ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %></a><br /><br />
				<br />
<%			} else if ( iReturnCode == 1 ) { %>
				<br /><br /><%= messages.getStringArgs("close_notify_success_cc_fail", new String[] {sTicketNo}) %>&nbsp;<a href="<%=keyops %>?next_page_id=2017&amp;ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %></a><br /><br />
				<br />
<%			} else if ( iReturnCode == 2 ) { %>
				<br /><br /><%= messages.getStringArgs("close_success_notify_fail", new String[] {sTicketNo}) %>&nbsp;<a href="<%=keyops %>?next_page_id=2017&amp;ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %></a><br /><br />
				<br />
<%			} else if ( iReturnCode == 4 ) { %>
				<br /><br /><%= messages.getString("ticket_already_closed") %><a href="<%=keyops %>?next_page_id=2017&amp;ticketno=<%= iTicketNo %>"><%= messages.getString("view_ticket") %></a><br /><br />
				<br />
<%			} else { %>
				<br /><br /><%= messages.getString("close_database_error") %>
				<br />
<%			} 
			
		} else if (sCase.equals("updateTimes")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.UpdateTimes(request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>&logaction=<%= messages.getString("times_ref_update_success") %>";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("update_ticket_fail") %>
				<br />
<%			} 
		} else if (sCase.equals("updateMaterials")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.UpdateMaterials(pupb.getUserLoginID(), request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>&logaction=Successfully updated parts and supplies";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("update_ticket_fail") %>
				<br />
<%			}
		} else if (sCase.equals("toHold")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.ChangeToHoldStatus(pupb.getUserID(), pupb.getUserLoginID(), request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>&logaction=<%= logaction %>";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("change_to_hold_fail") %>
				<br />
<%			}
		} else if (sCase.equals("fromHold")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.ChangeFromHoldStatus(pupb.getUserID(), pupb.getUserLoginID(), request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>&logaction=<%= logaction %>";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("update_ticket_fail") %>
				<br />
<%			}
		} else if (sCase.equals("addpo")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.AddPO(pupb.getUserLoginID(), request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2018&ticketno=<%= iTicketNo %>&vendorid=<%= iKOCompanyID %>&logaction=<%= messages.getString("purchase_order_add_success") %>";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("update_ticket_fail") %>
				<br />
<%			}
		} else if (sCase.equals("modpo")) {
			KeyopTicket keyop = new KeyopTicket();
			int iReturnCode = keyop.EditPO(pupb.getUserLoginID(), request);
			if ( iReturnCode == 0 ) { %>
				<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=2018&ticketno=<%= iTicketNo %>&vendorid=<%= iKOCompanyID %>&logaction=<%= messages.getString("purchase_order_edit_success") %>";</script>
<%			} else { %>
				<br /><br /><%= messages.getString("update_ticket_fail") %>
				<br />
<%			}
		} else { %>
			<br /><br /><%= messages.getString("unknown_system_error") %>
			<br />
<%		}
%>
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>