<%
   TableQueryBhvr VendorView  = (TableQueryBhvr) request.getAttribute("VendorView");
   TableQueryBhvrResultSet VendorView_RS = VendorView.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   int vendorid = 0;
   String vendorname = "";
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website vendor select page"/>
	<meta name="Description" content="Global print website current available vendors" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("vendor_administer") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function callEdit(selectedValue) {
		var params = "&vendorid=" + selectedValue;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=453" + params;
	 } //callEdit
	 
	 function setFormValues(msg,vendorid){
		var topageid = "455";
		setValue("<%= BehaviorConstants.TOPAGE %>", topageid);
		setValue('vendorid', vendorid);
		setValue('logaction', msg);
	} //setFormValues
	
	function callDelete(vendorname, vendorid) {
		//e.preventDefault();
		//console.log(this.id);
		var formName = getWidgetID('deleteForm');
		var msg = "Vendor " + vendorname + " has been deleted";
		setFormValues(msg,vendorid);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_vendor") %> ' + vendorname + "?");
		if (confirmDelete) {
			formName.submit();
		} //if yesno
	};
	
	function deleteFunction(msg,vendorname) {
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            sync: true,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. Vendor " + vendorname +" may be currently assigned to a printer</p>";
        		} else {
    				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                dojo.byId("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue
        };
        dojo.xhrPost(xhrArgs);
        //console.log(xhrArgs);
        //console.log("something worked");
	} //deleteFunction
	 
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('vendoridloc','vendorid','');
        createHiddenInput('logactionid','sdc','');
 		createPostForm('vendorForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
			<h1><%= messages.getString("vendor_administer") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<div id='mainInfo' class="ibm-columns">
				<div class="ibm-col-1-1">
		<!-- LEADSPACE_BEGIN -->
			<ul class="ibm-bullet-list ibm-no-links">
				<li><%= messages.getString("vendor_edit_info") %></li>
				<li><%= messages.getString("vendor_delete_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=450"><%= messages.getString("vendor_add") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='vendorForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='vendoridloc'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available vendors">
					<caption><em><%= VendorView_RS.getResultSetSize() %> <%= messages.getString("vendor_found") %></em></caption>
					<% if (VendorView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("vendor_name") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						while(VendorView_RS.next()) {
							vendorid = VendorView_RS.getInt("VENDORID");
							vendorname = tool.nullStringConverter(VendorView_RS.getString("VENDOR_NAME"));
					 %>
						<tr id='tr<%= vendorid %>'>
							<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= vendorid %>');"/><%= vendorname %></a></th>
							<td><a id='delvendor' class="ibm-delete-link" href="javascript:callDelete('<%= vendorname %>','<%= vendorid %>')" ><%= messages.getString("delete") %></a></td>
						</tr>
					<% } //while loop %>
					</tbody>
					<% } //if there are records %>
				</table> 
			</div><!-- END VendorForm DIV -->
			</div><!-- END ibm-col-1-1 -->
			</div><!-- END ibm-columns -->
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>