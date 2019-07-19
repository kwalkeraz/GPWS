<%
    PrinterUserProfileBean pupb2 = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
%>
<!-- MASTHEAD_BEGIN -->
<div id="ibm-masthead">
	<div id="ibm-mast-options">
		<ul>
			<li id="ibm-home"><a href="http://w3.ibm.com/">w3</a></li>
		</ul>
	</div>
	<div id="ibm-universal-nav">
		<p id="ibm-site-title">
			<em><%= messages.getString("title") %></em>
		</p>
		<ul id="ibm-menu-links">
			<li><a href="http://w3.ibm.com/sitemap/us/en/">Site map</a></li>
		</ul>

		<div id="ibm-search-module">
			<form id="ibm-search-form" action="http://w3.ibm.com/search/do/search" method="get">
			<p>
			<label for="q"><span class="ibm-access">Search</span></label>
			<input type="text" maxlength="100" value="" name="qt" id="q"/>
			<input type="hidden" value="17" name="v"/>
			<input value="en" type="hidden" name="langopt"/>
			<input value="all" type="hidden" name="la"/>
			<input type="submit" id="ibm-search" class="ibm-btn-search" value="Submit"/>
			</p>
			</form>
		</div>
		<!-- Sign in info -->
		<% if (pupb2.getValidSession()) { %>
		<div id="ibm-profile-links">
			<div id="ibm-portal-logout-link" class="ibm-profile-links-divider ibm-profile-links-divider" role="presentation">
				<%= messages.getString("hello")%> <a href="<%= keyops %>?next_page_id=2060"><%= pupb2.getUserFirstName() %> <%= pupb2.getUserLastName() %></a>
			</div>
			<a id="logoutuserlink" href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=251&msg=logout"><%= messages.getString("sign_out") %></a>
		</div>
		<% } %>
		<!-- End of sign in -->
	</div>
</div>
<!-- MASTHEAD_END -->