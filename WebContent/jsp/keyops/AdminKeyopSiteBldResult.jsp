<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin keyop site building"/>
<meta name="Description" content="This is the results page for when an admin adds a keyop to a particular site or building." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_site_building_result") %></title>
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
					<li><a href="<%= keyops %>?next_page_id=3012"> <%= messages.getString("view_keyops") %></a></li>  
					<li><a href="<%= keyops %>?next_page_id=3013&userid=<%= request.getParameter("userid") %>"> <%= messages.getString("edit_keyop") %></a></li>
			</ul>
			<h1><%= messages.getString("keyop_site_building_result") %></h1>
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
				<%	String sCase = request.getParameter("submitvalue");
					AdminKeyop adminKeyop = new AdminKeyop();
					
					if (sCase.equals("add")) {
						String sUserid = request.getParameter("userid");
						int iRC = adminKeyop.addSiteDB(request);
						if ( iRC == 0 ) { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&logaction=<%= messages.getString("keyop_site_add_success") %>";</script>
			<%			} else if ( iRC == 1) { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("keyop_site_add_error") %>";</script>
			<%			} else if ( iRC == 2) { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("keyop_site_add_error") %>";</script>
			<%			} else { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("an_error_occurred") %>";</script>
			<%			} 
					} else if (sCase.equals("remove")) { 
						String sUserid = request.getParameter("userid");
						int iRC = adminKeyop.removeSiteDB(request);
						if ( iRC == 0 ) { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&logaction=<%= messages.getString("keyop_site_del_success") %>";</script>
			<%			} else if ( iRC == 1 ) { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("keyop_site_del_error") %>";</script>
			<%			} else { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("an_error_occurred") %>";</script>
			<%			}
							
					} else if (sCase.equals("edit")) {
						String sUserid = request.getParameter("userid");
						int iRC = adminKeyop.editSiteBuildings(request);
						if ( iRC == 0 ) { %>
							<script type="text/javascript">window.close();</script>
							<script type="text/javascript">window.opener.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&logaction=<%= messages.getString("keyop_site_edit_success") %>";</script>
			<%			} else { %>
							<script type="text/javascript">window.opener.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("keyop_site_edit_error") %>";</script>
			<%			}
					} else if (sCase.equals("Done")) { %>
							<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3012";</script>
			<%		} else { 
						String sUserid = request.getParameter("userid");%>
						<script type="text/javascript">self.location.href = "<%= keyops %>?next_page_id=3015&userid=<%= sUserid %>&error=<%= messages.getString("unknown_system_error") %>";</script>
			<%		}
			%>
					</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>