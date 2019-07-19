<%  
	TableQueryBhvr Admins = (TableQueryBhvr) request.getAttribute("Admins");
    TableQueryBhvrResultSet Admins_RS = Admins.getResults();
    TableQueryBhvr AuthGroups = (TableQueryBhvr) request.getAttribute("AuthTypes");
    TableQueryBhvrResultSet AuthGroups_RS = AuthGroups.getResults();
    AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	int userid = 0;
	int lastuserid = 0;
	String firstname = "";
	String lastname = "";
	String fullname = "";
	String email = "";
	String loginid = "";
	String lastloginid = "";
	String pager = "";
	String sqlQuery = "";
	String group = tool.nullStringConverter(request.getParameter("group"));
	String orderby = tool.nullStringConverter(request.getParameter("orderby"));
	Connection con = null;
	PreparedStatement psUsers = null;
	ResultSet rsUsers = null;
	String[] AuthGroup = new String[AuthGroups_RS.getResultSetSize()];
	int x = 0;
	int iGray = 1;
	if (AuthGroups_RS.getResultSetSize() > 0 ) {
		while(AuthGroups_RS.next()) { 
			AuthGroup[x] = AuthGroups_RS.getString("AUTH_GROUP");
			x++;
		} //while AuthGroups
	} //if AuthGoups
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website administer GPWS administrators"/>
	<meta name="Description" content="Global print website administer GPWS administrators" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_gpws_admin") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function callEdit(selectedValue) {
		var params = "&userid=" + selectedValue;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=330"+params;
	 } //callEdit
	 
	 function setFormValues(msg,userid){
		var topageid = "334";
		setValue("<%= BehaviorConstants.TOPAGE %>",topageid);
		setValue('userid',userid);
		setValue('logaction',msg);
	} //setFormValues
	
	function callDelete(admin, userid) {
		var msg = "GPWS Administrator " + admin + " has been deleted";
		setFormValues(msg,userid);
		var confirmDelete = confirm('<%= messages.getString("admin_sure_delete") %> ' + admin + "?");
		if (confirmDelete) {
			//formName.submit();
			if (deleteFunction(msg,admin)) {
				//location.reload();
				AddParameter("logaction", msg);
			}
		} //if yesno
	};
	
	function deleteFunction(msg,admin){
		var submitted = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. GPWS Administrator " + admin +" may be currently assigned to an authentication</p>";
        			submitted = false;
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
                submitted = false;
            }
        };
        dojo.xhrPost(xhrArgs);
        return submitted;
	} //deleteFunction
	 
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','userid','');
 		createPostForm('AdminForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
		<%if (!logaction.equals("")){ %>
       		getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
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
			<h1 class="ibm-small"><%= messages.getString("administer_gpws_admin") %></h1>
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
			<ul class="ibm-bullet-list ibm-no-links">
				<li><%= messages.getString("administer_info") %></li>
				<li><%= messages.getString("admin_sort_name_info") %></li>
				<li><%= messages.getString("admin_sort_login_info") %></li>
				<li><%= messages.getString("admin_sort_auth_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=330&userid=0"><%= messages.getString("admin_add") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='AdminForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display current operating systems available">
					<caption><em><%= Admins_RS.getResultSetSize() %> <%= messages.getString("administrator_found") %></em></caption>
					<thead>
						<tr>
							<th scope="col" class="ibm-sort"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332&orderby=last_name"><span><%= messages.getString("name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<th scope="col" class="ibm-sort"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332&orderby=loginid"><span><%= messages.getString("login_id") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<th scope="col" class="ibm-sort"><span><%= messages.getString("vendor") %></span></th>
							<%	for (int i=0;i < AuthGroup.length; i++){ %>
									<th scope="col" class="ibm-sort"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=332&orderby=auth_group&group=<%= AuthGroup[i] %>"><span><%= AuthGroup[i] %> <%= messages.getString("authorization") %></span><span class="ibm-icon">&nbsp;</span></a></th>
							<%	} //for loop %>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<% 	try {
						con = tool.getConnection();
						if(orderby == null || orderby.equals("") || orderby.equals("last_name")) {
							orderby = "LAST_NAME, LOGINID, AUTH_GROUP";
							sqlQuery = "SELECT USERID, FIRST_NAME, LAST_NAME, LOGINID, EMAIL, PAGER, TIME_ZONE, OFFICE_STATUS, BACKUPID, VENDORID, VENDOR_NAME, PASSWORD, USER_AUTH_TYPEID, AUTH_NAME, AUTH_GROUP, DESCRIPTION FROM GPWS.USER_VIEW ORDER BY "+ orderby +"";
						}
						if (orderby.equals("loginid")) {
							orderby = "LOGINID, AUTH_GROUP";
							sqlQuery = "SELECT USERID, FIRST_NAME, LAST_NAME, LOGINID, EMAIL, PAGER, TIME_ZONE, OFFICE_STATUS, BACKUPID, VENDORID, VENDOR_NAME, PASSWORD, USER_AUTH_TYPEID, AUTH_NAME, AUTH_GROUP, DESCRIPTION FROM GPWS.USER_VIEW ORDER BY "+ orderby +"";
						}
						if (orderby.equals("auth_group")) {
							orderby = "AUTH_NAME, AUTH_GROUP, LAST_NAME, LOGINID";
							sqlQuery = "SELECT USERID, FIRST_NAME, LAST_NAME, LOGINID, EMAIL, PAGER, TIME_ZONE, OFFICE_STATUS, BACKUPID, VENDORID, VENDOR_NAME, PASSWORD, USER_AUTH_TYPEID, AUTH_NAME, AUTH_GROUP, DESCRIPTION FROM GPWS.USER_VIEW WHERE AUTH_GROUP = '"+group+"' ORDER BY "+ orderby +"";
						}
						psUsers = con.prepareStatement(sqlQuery);
					  	rsUsers = psUsers.executeQuery();
						int counter = 0;
						int t =0;
						while( rsUsers.next() ) {
							userid = rsUsers.getInt("USERID");
							firstname = rsUsers.getString("FIRST_NAME");
							lastname = rsUsers.getString("LAST_NAME");
							fullname = lastname + ", " + firstname;
							loginid = rsUsers.getString("LOGINID");
							email = rsUsers.getString("EMAIL");
							pager = rsUsers.getString("PAGER");				 
						%>
						<% if (lastuserid == 0 ) { %>
							<tr> 
								<th class="ibm-table-row" scope="row"><%= fullname %></th>
								<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= userid %>');"/><%= loginid %></a></th>
								<td><%= tool.nullStringConverter(rsUsers.getString("VENDOR_NAME")) %></td>
								<% 	while (counter < AuthGroup.length) {
										String userAuthGroup = rsUsers.getString("AUTH_GROUP");
										String userAuthfromArray = AuthGroup[counter];
										if (userAuthGroup == null) userAuthGroup = "";
										if (userAuthfromArray == null) userAuthfromArray = "";
										if (userAuthfromArray.equals(userAuthGroup) && !userAuthfromArray.equals("")) { %>
											<td><%= rsUsers.getString("AUTH_NAME") %></td>
										<% counter++;
											break;
										} else { %>
											<% if (lastuserid != userid && !userAuthfromArray.equals("")) { %>
													<td></td>
											<% } %>
										<% counter++;
										}
								   } //while AuthGroup 
							 lastuserid = userid;
							 lastloginid = loginid;
						  %>
						
						<% } else if (lastuserid != userid) { %>
								<% while (counter < AuthGroup.length) {
										if (AuthGroup[counter] != null) {%>
									<td></td>
								<% 		} //if not null
									counter++;
									} %>
								<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= lastloginid %>','<%= lastuserid %>')" ><%= messages.getString("delete") %></a></td>
							</tr>
							<% counter = 0; %>
							<tr>
								<th class="ibm-table-row" scope="row"><%= fullname %></th>
								<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= userid %>');"/><%= loginid %></a></th>
								<td><%= tool.nullStringConverter(rsUsers.getString("VENDOR_NAME")) %></td>
								<% 	lastuserid = userid;
									lastloginid = loginid;
									while (counter < AuthGroup.length) {
										String userAuthGroup = rsUsers.getString("AUTH_GROUP");
										String userAuthfromArray = AuthGroup[counter];
										if (userAuthGroup == null) userAuthGroup = "";
										if (userAuthfromArray == null) userAuthfromArray = "";
										if (userAuthfromArray.equals(userAuthGroup) && !userAuthfromArray.equals("")) { %>
												<td><%= rsUsers.getString("AUTH_NAME") %></td>
										<% 	counter++;
											break;
										} else { %>
										<% if (lastuserid == userid && !userAuthfromArray.equals("")) { %>
											<td></td>
										<% } 
										counter++; %>
								<% 		} 
									} // while AuthGroup  %>
							<% } else { //else IDs are equal %>		
								<% 	lastuserid = userid;
									lastloginid = loginid;
									while (counter < AuthGroup.length) {
										String userAuthGroup = rsUsers.getString("AUTH_GROUP");
										String userAuthfromArray = AuthGroup[counter];
										if (userAuthGroup == null) userAuthGroup = "";
										if (userAuthfromArray == null) userAuthfromArray = "";
										if (userAuthfromArray.equals(userAuthGroup) && !userAuthfromArray.equals("")) { %>
											<td><%= rsUsers.getString("AUTH_NAME") %></td>
										<% 	counter++;
											break;
										} else { %>
												<td></td>
										<%      counter++; %>
										<% } 
									}  //while counter 
									 %>
							<% } %>
						<% t++;
						}  //while rsUser %>
							<% while (counter < AuthGroup.length) {
									String userAuthfromArray = AuthGroup[counter];
									if (userAuthfromArray != null) { %>
									<td></td>
							<% 		}  //if not null
								counter++;
								} %>
							<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= lastloginid %>','<%= lastuserid %>')" ><%= messages.getString("delete") %></a></td>
						</tr>
					</tbody>
					<%	} catch (Exception e) {
							System.out.println("Error in UserView.jsp ERROR: " + e);
						} finally {
							rsUsers.close();
							psUsers.close();
							con.close();
						} //try&catch	%>
				</table> 
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>