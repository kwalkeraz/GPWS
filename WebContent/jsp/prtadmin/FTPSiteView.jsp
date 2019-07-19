<%
	TableQueryBhvr ftpSites = (TableQueryBhvr) request.getAttribute("ftpSites");
	TableQueryBhvrResultSet ftpSites_RS = ftpSites.getResults();
	PrinterTools tool = new PrinterTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	int ftpsiteid = 0;
	String ftpsite = "";
	String homedir = "";
	String ftpuser = "";
	String ftpsdc = "";
	String emailaddr = "";
	int ftpsemiloc = 0;
	String preftpsite = "";
	String postftpsite = "";
	String finalftpsite = "";
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print download repository"/>
	<meta name="Description" content="Global print website administer download repository information" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("ftp_site_administration") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	 //dojo.require("dojo.style");
	 
	function callEdit(ftpid) {
		var params="&ftpid=" + ftpid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=344" + params;
	} //callEdit
	
	function setFormValues(msg,ftpid){
		var topageid = "343";
		dojo.byId("<%= BehaviorConstants.TOPAGE %>").value = topageid;
		dojo.byId("ftpid").value = ftpid;
		dojo.byId('logaction').value = msg;
	} //setFormValues
	
	function callDelete(ftpsite, ftpid) {
		var msg = "Download repository " + ftpsite + " has been deleted";
		setFormValues(msg,ftpid);
		var confirmDelete = confirm('<%= messages.getString("ftp_delete_yes_no") %> ' + ftpsite + "?");
		if (confirmDelete) {
			if(deleteFunction(msg, ftpsite)) {
				//location.reload();
				AddParameter("logaction", msg);
			} //if true
		} //if yesno
	};
	
	function deleteFunction(msg,ftpsite){
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
        			dojo.byId("response").innerHTML = errorMsg + " Delete Restriction. Download repository " + ftpsite +" may be currently assigned to a printer</p>";
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
        createHiddenInput('ftpidloc','ftpid','');
        createPostForm('ftpForm','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
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
			<h1 class="ibm-small"><%= messages.getString("ftp_site_administration") %></h1>
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
				<li><%= messages.getString("ftp_select_modify") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=344&ftpid=0"><%= messages.getString("ftp_add_new_site") %></a></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='ftpForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div id='ftpidloc'></div>
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all available download repository servers">
					<caption><em><%= ftpSites_RS.getResultSetSize() %> <%= messages.getString("server_found") %></em></caption>
					<% if (ftpSites_RS.getResultSetSize() > 0) { %>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("ftp_site") %></th>
							<th scope="col"><%= messages.getString("number_of_printers") %></th>
							<th scope="col"><%= messages.getString("home_dir") %></th>
							<th scope="col"><%= messages.getString("ftp_sdc") %></th>
							<th scope="col"><%= messages.getString("ftp_contactemail") %></th>
							<th scope="col"><%= messages.getString("delete") %></th>
						</tr>
					</thead>
					<tbody>
					<%
						while( ftpSites_RS.next() ) {
							ftpsiteid = ftpSites_RS.getInt("FTPID");
							ftpsite = ftpSites_RS.getString("FTP_SITE");
							homedir = tool.nullStringConverter(ftpSites_RS.getString("HOME_DIRECTORY"));
							ftpuser = ftpSites_RS.getString("FTP_USER");
							ftpsdc = ftpSites_RS.getString("FTP_GEO");
							emailaddr = ftpSites_RS.getString("FTP_CONTACT_EMAIL");
							
							if (ftpsite.indexOf(';') > 0) {
								ftpsemiloc = ftpsite.indexOf(';')+1;
								preftpsite = ftpsite.substring(0,ftpsemiloc);
								postftpsite = ftpsite.substring(preftpsite.length(),ftpsite.length());
								finalftpsite = preftpsite + " " + postftpsite;
							} else {
								finalftpsite = ftpsite;
							}
					 %>
						<tr id='tr<%= ftpsiteid %>'>
							<th class="ibm-table-row" scope="row"><a class="ibm-signin-link" href="javascript:callEdit('<%=ftpsiteid%>');"><%= finalftpsite %></a></th>
							<td>
								<%= tool.getNumFTPPrinters(ftpsiteid) %>
							</td>
							<td>
								<%= homedir %>
							</td>
							<td>
								<%= ftpsdc %>
							</td>
							<td>
								<%= emailaddr %>
							</td>
							<td><a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%=ftpsite%>', '<%=ftpsiteid%>')" ><%= messages.getString("delete") %></a></td>
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