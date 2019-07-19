<%
	TableQueryBhvr PrinterDefType  = (TableQueryBhvr) request.getAttribute("PrinterDefType");
	TableQueryBhvrResultSet PrinterDefType_RS = PrinterDefType.getResults();
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	TableQueryBhvr PrinterDefTypeConfig  = (TableQueryBhvr) request.getAttribute("PrtDefTypeView");
	TableQueryBhvrResultSet PrinterDefTypeConfig_RS = PrinterDefTypeConfig.getResults();
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String[] osArray = new String[OSView_RS.getResultSetSize()];
	String serverdeftype = "";
	String clientdeftype = "";	
	int printerdeftypeid = 0;
	int x = 0;
	while (OSView_RS.next()) {  
		osArray[x] = OSView_RS.getString("OS_NAME"); 
		x++;
	}
	
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website select a printer definition type"/>
	<meta name="Description" content="Global print website administer a printer definition type" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_def_type_select") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.CheckBox");
	 
	function callEdit(printerdeftypeid) {
		var params = "&printerdeftypeid=" + printerdeftypeid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=393" + params;
	} //callEdit
	
	function callAdminPrinterDef(printerdeftypeid,serverdeftype,clientdeftype) {
		var params = "&printerdeftypeid=" + printerdeftypeid + "&serverdeftype=" + serverdeftype + "&clientdeftype=" + clientdeftype;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=396" + params;
	} //callAdminPrinterDef
	     
    function setFormValues(printerdeftypeid, msg){
		var topageid = "395";
		dojo.byId('topageid').value = topageid;
		dojo.byId('printerdeftypeid').value = printerdeftypeid;
		dojo.byId('logaction').value = msg;
	} //setFormValues
    
    function callDelete(printerdeftype,printerdeftypeid) {
    	dojo.byId("response").innerHTML = "";
		var msg = "Printer definition type " + printerdeftype + " has been deleted.";
		setFormValues(printerdeftypeid, msg);
		var confirmDelete = confirm('<%= messages.getString("sure_delete_printer_def_type") %> ' + printerdeftype + '?');
		if (confirmDelete) {
			if(deleteFunction(msg, printerdeftype)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //
		} //if yesno
	};
	
	function deleteFunction(msg,printerdeftype){
		var submitted = true;
		var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. Printer definition type " + printerdeftype + " may be currently assigned to a printer</p>";
        			submitted = false;
        		} else {
    				dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	submitted = false;
            	console.log(error);
                dojo.byId("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
            sync: syncValue,
        };
        dojo.xhrPost(xhrArgs);
        //console.log(submitted);
        return submitted;
	} //deleteFunction
    
	dojo.ready(function() {
     	createHiddenInput('topageidloc','<%= BehaviorConstants.TOPAGE %>','','topageid');
        createHiddenInput('logactionid','logaction','','logaction');
        createHiddenInput('logactionid','printerdeftypeid','','printerdeftypeid');
        createPostForm('delForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
        <% if (!logaction.equals("")){ %>
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
			<h1><%= messages.getString("printer_def_type_select") %></h1>
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
			<li><%= messages.getString("printer_def_type_edit_info") %></li>
			<li><%= messages.getString("printer_def_type_delete_info") %></li>
			<li><%= messages.getString("printer_def_type_admin_info") %></li>
			<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=390"><%= messages.getString("printer_def_type_add") %></a></li>
		</ul>
		<!-- LEADSPACE_END -->
			<div id='delForm'>
				<div id='topageidloc'></div>
				<div id='logactionid'></div>
				<div id='response'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all printer definition types">
					<caption><em></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("server_client_definition") %></th>
							<th scope="col"><%= messages.getString("printer_def_type_config") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
							<% for (int i=0; i < osArray.length; i++) { %>
								<th scope="col"><%= osArray[i] %></th>
							<% } //for loop %>
						</tr>
					</thead>
					<tbody>
						<%  	while(PrinterDefType_RS.next()) {
									serverdeftype = tool.nullStringConverter(PrinterDefType_RS.getString("SERVER_DEF_TYPE"));
									clientdeftype = tool.nullStringConverter(PrinterDefType_RS.getString("CLIENT_DEF_TYPE"));
									printerdeftypeid = PrinterDefType_RS.getInt("PRINTER_DEF_TYPEID"); %>
								<tr id='tr<%= printerdeftypeid %>'>
									<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%= printerdeftypeid %>');"/><%= serverdeftype %>/<%= clientdeftype %></a></th>
									<td><a href="javascript:callAdminPrinterDef('<%= printerdeftypeid %>','<%= serverdeftype %>','<%= clientdeftype %>'); "/><%= messages.getString("printer_def_type_config_admin") %></a></td>
									<td><a id='delprniterdeftype' class="ibm-delete-link" href="javascript:callDelete('<%= serverdeftype %>/<%= clientdeftype %>','<%= printerdeftypeid %>')" ><%= messages.getString("delete") %></a></td>
						<%			for (int i=0; i < osArray.length; i++) {
										String sValue = "";
										boolean found = false;
										PrinterDefTypeConfig_RS.first();
										while(PrinterDefTypeConfig_RS.next()) {
											if (printerdeftypeid == PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPEID")) {
												if (osArray[i].equals(tool.nullStringConverter(PrinterDefTypeConfig_RS.getString("OS_NAME")))) {
													found = true;
													break;
												} //if
											} //if
										} //while
										if (found) {
											sValue = "<td>"+
													PrinterDefTypeConfig_RS.getString("PROTOCOL_NAME") +
													"</td>";
										} else {
											sValue = "<td></td>";
										} // if else %>
										<%= sValue %>
						<%			} //for loop %>
								</tr>
						<%		} //while	%>
					</tbody>
				</table> 
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>