<%
   //TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
   //TableQueryBhvrResultSet OSView_RS = OSView.getResults();
   TableQueryBhvr ProtocolView  = (TableQueryBhvr) request.getAttribute("PrtProtocolView");
   TableQueryBhvrResultSet ProtocolView_RS = ProtocolView.getResults();
   AppTools tool = new AppTools();
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   int protocolid = 0;
	String protocol = "";
	String protocol_type = "";
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website administer protocol"/>
	<meta name="Description" content="Global print website administer a protocol and an os specific protocol" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("protocol_administration") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 
	 function callEdit(selectedValue) {
		var params = "&protocolid=" + selectedValue;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=312" + params;
	 } //callEdit
	 
	 function os_editProtocol(protocolid) {
		var params="&protocolid=" + protocolid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=319" + params;
	 } //os_editProtocol
	 
	 function setFormValues(msg,protocolid){
		var topageid = "317";
		setValue("<%= BehaviorConstants.TOPAGE %>",topageid);
		setValue('protocolid',protocolid);
		setValue('logaction',msg);
	} //setFormValues
	
	function callDelete(protocol, protocolid) {
		//e.preventDefault();
		//console.log(this.id);
		var formName = getWidgetID('deleteForm');
		var msg = "Protocol " + protocol + " has been deleted";
		setFormValues(msg,protocolid);
		var confirmDelete = confirm('<%= messages.getString("protocol_delete_sure") %> ' + protocol + ' <%= messages.getString("protocol_delete_sure_2") %>?');
		if (confirmDelete) {
			if (deleteFunction(msg, protocol)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,protocol){
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
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
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Protocol " + protocol +" may be currently assigned to a printer type configuration</p>";
        			submitted = false;
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	submitted = false;
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
        //console.log(xhrArgs);
        return submitted;
	} //deleteFunction
	 
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('protocolidloc','protocolid','');
        createPostForm('protocolForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
			<h1><%= messages.getString("protocol_administration") %></h1>
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
				<li><%= messages.getString("protocol_edit_information") %></li>
				<li><%= messages.getString("protocol_modify_os_information") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=310"><%= messages.getString("protocol_add_new") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='protocolForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='protocolidloc'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available device models">
					<caption><em><%= ProtocolView_RS.getResultSetSize() %> <%= messages.getString("protocol_found") %></em></caption>
					<% if (ProtocolView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("protocol_name") %></th>
							<th scope="col"><%= messages.getString("protocol_type") %></th>
							<th scope="col"><%= messages.getString("os_info") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						while(ProtocolView_RS.next()) {
							protocolid = ProtocolView_RS.getInt("PROTOCOLID");
							protocol = ProtocolView_RS.getString("PROTOCOL_NAME");
							protocol_type = ProtocolView_RS.getString("PROTOCOL_TYPE");
					 %>
						<tr id='tr<%= protocolid %>'>
							<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= protocolid %>');"/><%= protocol %></a></th>
							<td><%= protocol_type %></td>
							<td><a href="javascript:os_editProtocol('<%=protocolid%>'); "/><%= messages.getString("protocol_view_modify_os_information") %></a></td>
							<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= protocol %>/<%= protocol_type %>','<%= protocolid %>')" ><%= messages.getString("delete") %></a></td>
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