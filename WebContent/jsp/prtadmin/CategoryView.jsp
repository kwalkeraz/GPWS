<%
   TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
   TableQueryBhvrResultSet CategoryView_RS = CategoryView.getResults();
   AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   String category = tool.nullStringConverter(request.getParameter("category"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print category view"/>
	<meta name="Description" content="Global print website list available categories" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("administer_category") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Tooltip");
	  
	function callEdit(categoryid,category) {
		var params ="&categoryid=" +categoryid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7004" + params;
	} //callEdit
	
	function callAddInfo(category,categoryid) {
		var params ="&category=" + category + "&categoryid=" +categoryid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7010" + params;
	} //callAddInfo
	
	function setFormValues(msg,categoryid){
		var topageid = "7040";
		dojo.byId("<%= BehaviorConstants.TOPAGE %>").value = topageid;
		dojo.byId("categoryid").value = categoryid;
		dojo.byId('logaction').value = msg;
	} //setFormValues
	
	function callDelete(category, categoryid) {
		var msg = "Category " + category + " has been deleted";
		setFormValues(msg,categoryid);
		var confirmDelete = confirm('<%= messages.getString("category_sure_delete") %> ' + category + "?" + ' <%= messages.getString("category_warning_delete_part1") %>');
		if (confirmDelete) {
			if(deleteFunction(msg, category)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,category){
		var submitted = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            sync: true,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
            		submitted = false;
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. Category " + category +" may be currently assigned to an item</p>";
        		} else {
    				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	submitted = false;
            	console.log(error);
                dojo.byId("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
        };
        dojo.xhrPost(xhrArgs);
        return submitted;
	} //deleteFunction
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','categoryid','');
        createPostForm('categoryForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
        <%  String descLabel = "";
        	while(CategoryView_RS.next()) { 
        		descLabel = tool.nullStringConverter(CategoryView_RS.getString("DESCRIPTION"));
        		if (!descLabel.equals("")) {
        %>
        		var description = '<%= descLabel %>';
        		new dijit.Tooltip({
		        			connectId: '<%= CategoryView_RS.getInt("CATEGORYID") %>Id',
		        			position: ["above","below"],
							id: '<%= CategoryView_RS.getInt("CATEGORYID") %>',
							label: description,
						});
		<% 		} //if
			} //while %>
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
			<h1><%= messages.getString("administer_category") %></h1>
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
				<li><%= messages.getString("category_edit_info") %></li>
				<li><%= messages.getString("category_delete_info") %></li>
				<li><%= messages.getString("category_admin_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7001"><%= messages.getString("add_new_category") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='categoryForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available categories">
					<caption><em><%= CategoryView_RS.getResultSetSize() %> <%= messages.getString("category_found") %></em></caption>
					<% if (CategoryView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("category_name") %></th>
							<th scope="col"><%= messages.getString("view_category_information") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						String categoryname = "";
						String description = "";
						int categoryid = 0;
						CategoryView_RS.first();
							while(CategoryView_RS.next()) {
								categoryid = CategoryView_RS.getInt("CATEGORYID");
								categoryname = tool.nullStringConverter(CategoryView_RS.getString("CATEGORY_NAME"));
								description = tool.nullStringConverter(CategoryView_RS.getString("DESCRIPTION"));
					 %>
						<tr id='tr<%= categoryid %>'>
							<th class="ibm-table-row" scope="row" id="<%= categoryid %>Id">
								<a class="ibm-signin-link" href="javascript:callEdit('<%=categoryid%>');"><%= categoryname %></a>
								<% if (!description.equals("")) { %>
									<a class="ibm-information-link" href="#"></a>
								<% } //if description is not empty %>
							</th>
							<td>
								<a href="javascript:callAddInfo('<%= categoryname %>','<%= categoryid %>')"><%= messages.getString("view_modify_category_information") %></a>
							</td>
							<td><a class="ibm-delete-link" href="javascript:callDelete('<%= categoryname %>','<%= categoryid%>')"><%= messages.getString("delete") %></a></td>
						</tr>
						<% } //while loop %>
					</tbody>
					<% } //if there are records %>
				</table> 
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>