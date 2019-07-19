<%
  	TableQueryBhvr ServerView  = (TableQueryBhvr) request.getAttribute("Server");
  	TableQueryBhvrResultSet ServerView_RS = ServerView.getResults();
  	TableQueryBhvr ServerProtocol  = (TableQueryBhvr) request.getAttribute("ServerProtocol");
	TableQueryBhvrResultSet ServerProtocol_RS = ServerProtocol.getResults();
  	boolean isExternal = PrinterConstants.isExternal;
  	AppTools tool = new AppTools();
  	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
  	String referer = tool.nullStringConverter(request.getParameter("to_page_id"));
  	String Svrsdc = tool.nullStringConverter(request.getParameter("sdc"));
	String ServerName = "";
	String ServerOS = "";
	String ServerSerial = "";
	String ServerModel = "";
	String hostportconfig = "";
	String room = "";
	int serverid = 0;
	int locid = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view print server"/>
	<meta name="Description" content="Global print website view a print server information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("server_select_edit_delete") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 //dojo.require("dojo.style");
	 
	function callEdit(locid,serverid) {
		var referer = "";
		<% if (request.getParameter("server") != null) { %>
			referer = "&referer=" + "<%= request.getParameter(BehaviorConstants.TOPAGE)%>" + "&server=<%= request.getParameter("server") %>";
		<% } else {%>
			referer = "&referer=" + "<%= request.getParameter(BehaviorConstants.TOPAGE)%>" + "&sdc=<%= request.getParameter("sdc") %>";
		<% } %>
		var params = "&locid="+locid+"&serverid=" + serverid + referer;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5030" + params;
	} //callEdit
	
	function callListDevices(serverid,servername) {
		var params = "";
		var referer = "";
		<% if (request.getParameter(BehaviorConstants.TOPAGE).equals("5021")) { %>
			var sdc = "<%= request.getParameter("sdc") %>";
			referer = "<%= request.getParameter(BehaviorConstants.TOPAGE)%>";
			params = "&sdc="+sdc+"&referer="+referer;
		<% } else if (request.getParameter(BehaviorConstants.TOPAGE).equals("5022")) {%>
			referer = "<%= request.getParameter(BehaviorConstants.TOPAGE)%>";
			params = "&referer="+referer;
		<% } %>
		params = "&serverid=" + serverid + "&servername=" + servername + params;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5050" + params;
	} //callListDevices
	
	function callSPURL(param,server,protocol) {
		var referer="<%=request.getParameter(BehaviorConstants.TOPAGE)%>";
		var sdc = "<%=request.getParameter("sdc")%>";
		params = "&serverprotocolid=" + param + "&server=" + server + "&protocol=" + protocol + "&referer=" + referer + "&sdc=" + sdc;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7405" + params;
	} //callSPURL
	
	function callSOURL(param,server,protocol) {
		var referer="<%=request.getParameter(BehaviorConstants.TOPAGE)%>";
		var sdc = "<%=request.getParameter("sdc")%>";
		params = "&serverid=" + param + "&server=" + server + "&protocol=" + protocol + "&referer=" + referer + "&sdc=" + sdc;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=5025" + params;
	} //callSOURL
	
	function setFormValues(msg,serverid){
		var topageid = "";
		var referer = "<%= request.getParameter(BehaviorConstants.TOPAGE) %>";
		if (referer == "5021") {
			topageid = "5046";
		} else {
			topageid = "5045";
		}
		setValue("<%= BehaviorConstants.TOPAGE %>",topageid);
		setValue('serverid',serverid);
		setValue('logaction',msg);
	} //setFormValues
	
	function callDelete(serverName, serverid) {
		//e.preventDefault();
		//console.log(this.id);
		var msg = "Server " + serverName + " has been deleted";
		setFormValues(msg,serverid);
		var confirmDelete = confirm('<%= messages.getString("server_delete_sure") %> ' + serverName + "?");
		if (confirmDelete) {
			//location.reload();
			deleteFunction(msg, serverName);
			AddParameter("logaction", msg);
		} //if yesno
	};
	
	function deleteFunction(msg,serverName){
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
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Server " + serverName +" may be currently assigned to a printer</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
        //console.log(xhrArgs);
        //console.log("something worked");
	} //deleteFunction
	
	dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('serveridloc','serverid','');
        createHiddenInput('logactionid','sdc','<%= Svrsdc %>');
 		createPostForm('serverForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5010"><%= messages.getString("server_select_location") %></a></li>
			</ul>
			<h1><%= messages.getString("server_select_edit_delete") %></h1>
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
				<li><%= messages.getString("server_edit_info") %></li>
				<li><%= messages.getString("server_delete_info") %></li>
				<li><%= messages.getString("server_process_info") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5000"><%= messages.getString("server_add") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='serverForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='serveridloc'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available print servers and the corresponding protocols they support">
					<caption><em><%= ServerView_RS.getResultSetSize() %> <%= messages.getString("server_found") %></em></caption>
					<% if (ServerView_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("server_name") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
							<th scope="col"><%= messages.getString("sdc") %></th>
							<th scope="col"><%= messages.getString("server_protocol_supported") %></th>
							<th scope="col"><%= messages.getString("server_list_devices") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						while(ServerView_RS.next()) {
							Svrsdc = tool.nullStringConverter(ServerView_RS.getString("SDC"));
							ServerName = tool.nullStringConverter(ServerView_RS.getString("SERVER_NAME"));
							ServerOS = tool.nullStringConverter(ServerView_RS.getString("SERVER_OS"));
							ServerSerial = tool.nullStringConverter(ServerView_RS.getString("SERVER_SERIAL"));
							ServerModel = tool.nullStringConverter(ServerView_RS.getString("SERVER_MODEL"));
							serverid = ServerView_RS.getInt("SERVERID");
							locid = ServerView_RS.getInt("LOCID");
							room = tool.nullStringConverter(ServerView_RS.getString("ROOM"));
					 %>
						<tr id='tr<%= serverid %>'>
							<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%=locid%>','<%= serverid %>');"><%=ServerName %></a></th>
							<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%= ServerName %>','<%= serverid %>')" ><%= messages.getString("delete") %></a></td>
							<td><%= Svrsdc %></td>
							<td>
								<% ServerProtocol_RS.first();
									if (ServerProtocol_RS.getResultSetSize() > 0 ) { 
									while(ServerProtocol_RS.next()) { 
										hostportconfig = tool.nullStringConverter(ServerProtocol_RS.getString("HOST_PORT_CONFIG"));
										if (ServerName.equals(ServerProtocol_RS.getString("SERVER_NAME"))) { 
											if (hostportconfig.equals("Server/Server Process")) {%>
												<a href="javascript:callSPURL('<%= ServerProtocol_RS.getInt("SERVER_PROTOCOLID") %>','<%= ServerProtocol_RS.getString("SERVER_NAME") %>','<%= ServerProtocol_RS.getString("PROTOCOL_NAME") %>'); "><%= ServerProtocol_RS.getString("PROTOCOL_NAME") %></a>,
								<% 			} else if (hostportconfig.equals("Server Only") && !(tool.nullStringConverter(ServerProtocol_RS.getString("PROTOCOL_TYPE"))).equalsIgnoreCase("Equitrac")) { %> 
												<a href="javascript:callSOURL('<%= ServerProtocol_RS.getInt("SERVERID") %>','<%= ServerProtocol_RS.getString("SERVER_NAME") %>','<%= ServerProtocol_RS.getString("PROTOCOL_NAME") %>'); "><%= ServerProtocol_RS.getString("PROTOCOL_NAME") %></a>,
								<%			} else { %>
												<%= ServerProtocol_RS.getString("PROTOCOL_NAME") %>,
								<%			} //if not server process		
										} //if servername
									}  //while serverprotocol %>
								<% }  //if >0 %>
							</td>
							<td><a href="javascript:callListDevices('<%= serverid %>','<%= ServerName %>');"><%= messages.getString("server_list_device_supported") %></a></td>
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