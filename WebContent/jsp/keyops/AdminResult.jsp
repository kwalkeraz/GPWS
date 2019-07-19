<% 
	keyopTools tool = new keyopTools();
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	
	int iKOCompanyID = pupb.getVendorID();
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin result"/>
<meta name="Description" content="This is the results page for several different admin actions." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_admin_results") %></title>
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
			<h1><%= messages.getString("keyop_admin_results") %></h1>
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
						
							String sCase = request.getParameter("submitvalue");
					System.out.println("sCase = " + sCase);
							AdminAdmin adminAdmin = new AdminAdmin();
							AdminKeyop adminKeyop = new AdminKeyop();
							
							if (sCase.equals("AddAdmin")) {
								int iReturnCode = adminAdmin.addAdminDB(request);
								String sName = request.getParameter("firstname") + " " + request.getParameter("lastname");
								if ( iReturnCode == 0 ) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3020&logaction=<%= messages.getStringArgs("admin_added_success_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_added_success_message", new String[]{sName}) %><br /><br />
					<%			} else if ( iReturnCode == 1) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3020&logaction=<%= messages.getStringArgs("admin_added_success_error_email", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_added_success_error_email", new String[]{sName}) %><br /><br />
					<%			} else if ( iReturnCode == 803) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3020&error=<%= messages.getStringArgs("duplicate_row_msg", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getString("duplicate_row_msg") %><br /><br />
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3020&error=<%= messages.getStringArgs("admin_added_error_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_added_error_message", new String[]{sName}) %>
					<%			} 
							} else if (sCase.equals("AddKeyop")) { 
								String sName = request.getParameter("firstname") + " " + request.getParameter("lastname");
								int iReturnCode = adminKeyop.addKeyopDB(request);
								if ( iReturnCode == 0 ) { 
									int iUserID = adminKeyop.getUserID((String)request.getParameter("loginid")); %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3013&userid=<%= iUserID %>&logaction=<%= messages.getStringArgs("keyop_added_success_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_added_success_message", new String[]{sName}) %><br /><br />
					<%			} else if ( iReturnCode == 1 ) {
									int iUserID = adminKeyop.getUserID((String)request.getParameter("loginid")); %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3013&userid=<%= iUserID %>&logaction=<%= messages.getStringArgs("keyop_added_success_error_email", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_added_success_error_email", new String[]{sName}) %>
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3010&error=<%= messages.getStringArgs("keyop_added_error_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getString("keyop_added_error_message") %>&nbsp;<%= sName %>
					<%			}
									
							} else if (sCase.equals("RemoveAdmin")) {
								int iUserid = Integer.parseInt(request.getParameter("userid"));
								String sUserName = tool.returnUserInfo(iUserid, "first_last_name");
								int iReturnCode = adminAdmin.removeAdminDB(request);
								if (iReturnCode == 0) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3022&logaction=<%= messages.getStringArgs("admin_deleted_success_message", new String[]{sUserName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_deleted_success_message", new String[]{sUserName}) %>
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3022&error=<%= messages.getStringArgs("admin_deleted_error_message", new String[]{sUserName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_deleted_error_message", new String[]{sUserName}) %>
					<%			}
									
							} else if (sCase.equals("RemoveKeyop")) {
								String sUserid = request.getParameter("userid");
								String sUsername = request.getParameter("username");
								int iReturnCode = adminKeyop.removeKeyopDB(sUserid);
								if ( iReturnCode == 0 ) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3012&logaction=<%= messages.getStringArgs("keyop_deleted_success_message", new String[]{sUsername}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_deleted_success_message", new String[]{sUsername}) %>
					<%			} else if (iReturnCode == 1) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3012&logaction=<%= messages.getStringArgs("keyop_deleted_open_tickets", new String[]{sUsername}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_deleted_open_tickets", new String[]{sUsername}) %>
					<%			} else if (iReturnCode == 2) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3012&logaction=<%= messages.getStringArgs("keyop_deleted_dberror_message", new String[]{sUsername}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_deleted_dberror_message", new String[]{sUsername}) %>
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3012&logaction=<%= messages.getStringArgs("keyop_deleted_error_message", new String[]{sUsername}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_deleted_error_message", new String[]{sUsername}) %>
					<%			}
							} else if (sCase.equals("EditKeyop")) {
								String sUserid = request.getParameter("userid");
								String sName = request.getParameter("firstname") + " " + request.getParameter("lastname");
								int iReturnCode = adminKeyop.editKeyopDB(request);
								if ( iReturnCode == 0 ) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3012&logaction=<%= messages.getStringArgs("keyop_updated_success_message", new String[]{sName}) %>";</script>
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3013&userid=<%= sUserid %>&logaction=<%= messages.getStringArgs("keyop_updated_error_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("keyop_updated_error_message", new String[]{sName}) %>
					<%			}
							} else if (sCase.equals("EditAdmin")) {
								String sName = request.getParameter("firstname") + " " + request.getParameter("lastname");
								int iReturnCode = adminAdmin.editAdminDB(request);
								if ( iReturnCode == 0 ) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3022&logaction=<%= messages.getStringArgs("admin_edited_success_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_edited_success_message", new String[]{sName}) %>
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3023&userid=<%=request.getParameter("userid")%>&logaction=<%= messages.getStringArgs("admin_edited_error_message", new String[]{sName}) %>";</script>
									<br /><br /><%= messages.getStringArgs("admin_edited_error_message", new String[]{sName}) %>
					<%			}
							} else if (sCase.equals("assignTicket")) {
								int iUserid = Integer.parseInt(request.getParameter("keyopuserid"));
								int iTicketNo = Integer.parseInt(request.getParameter("ticketno"));
								String sTicketNo = iTicketNo + "";
								int iReturnCode = adminKeyop.AssignTicket(iUserid, iTicketNo, pupb.getUserLoginID());
								String sName = tool.returnUserInfo(iUserid, "first_last_name");
								if ( iReturnCode == 0 ) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3095&ticketno=<%= sTicketNo %>&vendorid=<%= iKOCompanyID %>&logaction=<%= messages.getStringArgs("ticket_assign_success", new String[]{sName, sTicketNo}) %>";</script>
									<br /><br /><%= messages.getString("ticket_assign_success") %>&nbsp;<%= sTicketNo %>&nbsp;<%= sName %>.
					<%			} else if ( iReturnCode == 1 ) { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3095&ticketno=<%= sTicketNo %>&vendorid=<%= iKOCompanyID %>&logaction=<%= messages.getStringArgs("ticket_assign_success_pager_error", new String[]{sName, sTicketNo}) %>";</script>
									<br /><br /><%= messages.getString("ticket_assign_success_pager_error") %>
					<%			} else { %>
									<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3095&ticketno=<%= sTicketNo %>&vendorid=<%= iKOCompanyID %>&logaction=<%= messages.getString("ticket_assign_error") %>";</script>
									<br /><br /><%= messages.getString("ticket_assign_error") %>
					<%			}
							} else { %>
								<br /><br /><%= messages.getString("unknown_system_error") %>
					<%		}
					%>
					
					</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>