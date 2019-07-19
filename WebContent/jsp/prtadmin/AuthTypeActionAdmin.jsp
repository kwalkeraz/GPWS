<%
    TableQueryBhvr AuthTypesView  = (TableQueryBhvr) request.getAttribute("AuthTypesView");
    TableQueryBhvrResultSet AuthTypesView_RS = AuthTypesView.getResults();
    
    TableQueryBhvr AuthTypeActionsView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AuthTypeActionsView");
    TableQueryBhvrResultSet AuthTypeActionsView_RS = AuthTypeActionsView.getResults();
    
    TableQueryBhvr AuthGroupView  = (TableQueryBhvr) request.getAttribute("AuthGroupView");
    TableQueryBhvrResultSet AuthGroupView_RS = AuthGroupView.getResults();
    AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String sAuthGroup = tool.nullStringConverter(request.getParameter("authgroup"));
    String authTypeName = "";
	int authTypeID = 0;
	int[] authTypeidArray = new int[AuthTypesView_RS.getResultSetSize()];
	String[] authTypeArray = new String[AuthTypesView_RS.getResultSetSize()];
	int x = 0;
	int authActionid = 0;
	int authTypeid = 0;
	String authActionType = "";
	String lastAction = "";
	int lastActionid = 0;
	int osid = 0;
	int iGray = 0;
	int counter = 0;
	int numActions = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website auth type"/>
	<meta name="Description" content="Global print auth types view page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("authorization_type_admin") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.Select");
	
	function addAuthGroup(){
	 	var dID = "authgroup";
	 	<%
   		while(AuthGroupView_RS.next()) {
			String categoryvalue1 = tool.nullStringConverter(AuthGroupView_RS.getString("CATEGORY_VALUE1"));
			String categorycode = tool.nullStringConverter(AuthGroupView_RS.getString("CATEGORY_VALUE1")); %>
   			var optionName = "<%= categoryvalue1 %>";
   			var optionValue = "<%= categoryvalue1 %>";
   			addOption(dID,optionName,optionValue);
   		<% } %>
	 } //addAuthGroup
	 
	 function callRefresh(){
	 	var formName = dojo.byId('authGroupForm');
	 	var authGroup = getSelectValue('authgroup');
		if (authGroup == "All") {
			dojo.byId('<%= BehaviorConstants.TOPAGE %>').value = "3302";
		}
		formName.submit();
	 } //callRefresh
	 
	 function onChangeCall(){
	 	return false;
	 } //callOnChange
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','3302_AGFilter','<%= BehaviorConstants.TOPAGE %>');
        createSelect('authgroup', 'authgroup', '<%= messages.getString("all") %>', 'All', 'authgroup');
        addAuthGroup();
        autoSelectValue('authgroup','<%= sAuthGroup %>');
        createInputButton('view_group','ibm-cancel','<%= messages.getString("view") %>','ibm-btn-cancel-sec','view_group','callRefresh()');
        createGetForm('authGroupFilter','authGroupForm','authGroupForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
        changeSelectStyle('250px');
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
			</ul>
			<h1 class="ibm-small"><%= messages.getString("authorization_type_admin") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
		<ul>
			<li><!-- <a class="ibm-cancel-link"> -->&nbsp;&nbsp;&nbsp;&nbsp;-</a> <%= messages.getString("redx_auth_type") %></li>
			<li><a class='ibm-confirm-link'>-</a> <%= messages.getString("greencheck_auth_type") %></li>
			<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=3303"><%= messages.getString("add_auth_action") %></a></li>
			<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=3308"><%= messages.getString("add_auth_type") %></a></li>
		</ul>
		<p>
			<% if (sAuthGroup.equals("")) { %>
				<%= messages.getString("sorted_by_auth_group") %>: <b><%= messages.getString("all") %></b>
			<% } else { %>
				<%= messages.getString("sorted_by_auth_group") %>: <b><%= sAuthGroup %></b>
			<% } %>
		</p>
		
		<!-- LEADSPACE_END -->
				<div id='response'></div>
				<div id='errorMsg'></div>
				<div id='authGroupFilter'>
					<div id='topageid'></div>
					<div id='logactionid'></div>
					<div class="ibm-container-body ibm-two-column">
						<div class="ibm-column ibm-first">
							<label for='authgroup'><%= messages.getString("view_by_auth_group") %>:</label>
							<span>
								<div id='authgroup'></div>
							</span>
						</div>
						<div class="ibm-column ibm-second">
							<div class='ibm-buttons-row' align="right">
								<div class="pClass">
									<div id='view_group'></div>
								</div>
							</div>	
						</div>
					</div>
					<p></p>
					<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available authorization actions.  Each action displays which group is authorized to performed the specified action">
						<caption><em><%= AuthTypesView_RS.getResultSetSize() %> authorization type(s) found</em></caption>
						<thead>
							<tr>
								<th scope="col"><%= messages.getString("authorization_action") %></th>
								<% while(AuthTypesView_RS.next()) {
										authTypeName = AuthTypesView_RS.getString("AUTH_NAME");
										authTypeID = AuthTypesView_RS.getInt("AUTH_TYPEID");
										authTypeidArray[x] = authTypeID;
										authTypeArray[x] = authTypeName;
										x++; %>
								<th scope="row"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=3300&authtypeid=<%= authTypeID %>"><%= authTypeName %></a></th>
								<% } //while AuthTypesView%>
							</tr>
						</thead>
						<tbody>
							<%  while(AuthTypeActionsView_RS.next()) {
									authActionType = AuthTypeActionsView_RS.getString("ACTION_TYPE");
									authActionid = AuthTypeActionsView_RS.getInt("AUTH_ACTIONID");
									authTypeid = AuthTypeActionsView_RS.getInt("AUTH_TYPEID");%>
									<% if (lastAction.equals("")) { %>
							<tr>
								<td>
									<a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=3305&authactionid=<%= authActionid %>"><%= authActionType %></a>
								</td>
								<%  		lastAction = authActionType;
											lastActionid = authActionid; %>
							<%  	   } //if lastAction
							   			if (!authActionType.equals(lastAction) && numActions != 0) { 
									 		while(counter < authTypeidArray.length) { %>
								<td>
<!-- 									<a class="ibm-cancel-link"></a> -->
											<% 	counter++; %>
								</td>
										<% 	} //while counter %>
							</tr>
										<% counter = 0;  %>
							<tr>
								<td>
									<a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=3305&authactionid=<%= authActionid %>"><%= authActionType %></a>
								</td>
										<% lastAction = authActionType; 
									  	   lastActionid = authActionid; %>
										<%  while(counter < authTypeidArray.length) { %>
								<td>
										<%	  if (authTypeidArray[counter] != 0 && authTypeidArray[counter] == (authTypeid)) { %> 
										<a class='ibm-confirm-link'></a>
										<% 		counter++; 
									  			break; 
									  		  } else { %>
<!-- 										<a class="ibm-cancel-link"></a> -->
									<% 			counter++; 
									  		  }  %>
								</td>
										<% } //while counter %>
								<% 	} else {
										while(counter < authTypeidArray.length) { %>
								<td>
									<% 		if (authTypeidArray[counter] != 0 && authTypeidArray[counter] == (authTypeid)) { %> 
									<a class='ibm-confirm-link'></a>
										<%  	counter++; 
												break; 
											} else { %>
<!-- 									<a class="ibm-cancel-link"></a> -->
									<% 			counter++; 
											} //if else %>
								</td>
							<% 			} //while counter %>
						<% 			} //if else authType%>
					<% 				numActions++;
							} //while AuthTypesView
					 		while(counter < authTypeidArray.length) { %>
								<td>
<!-- 									<a class="ibm-cancel-link"></a> -->
								<% counter++; %>
								</td>
						<%  } //while os counter %>
							</tr>
						</tbody>
					</table> 
				</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>