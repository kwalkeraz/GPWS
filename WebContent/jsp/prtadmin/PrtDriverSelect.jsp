<%
   TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
   TableQueryBhvrResultSet OSView_RS = OSView.getResults();
   TableQueryBhvr DriverView  = (TableQueryBhvr) request.getAttribute("DriverView");
   TableQueryBhvrResultSet DriverView_RS = DriverView.getResults();
   TableQueryBhvr Driver  = (TableQueryBhvr) request.getAttribute("Driver");
   TableQueryBhvrResultSet Driver_RS = Driver.getResults();
   AppTools tool = new AppTools(); 
   String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String osdriverid = tool.nullStringConverter(request.getParameter("osdriverid"));
	String drvid = tool.nullStringConverter(request.getParameter("driverid"));
	String osnm = tool.nullStringConverter(request.getParameter("osname"));
	String drnm = tool.nullStringConverter(request.getParameter("drivername"));
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view driver information"/>
	<meta name="Description" content="Global print website view a print driver information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_administration") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Form");
	
	function editDriver(driverid) {
		var params="&driverid=" + driverid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=326" + params;
	} //editDriver
	
	function os_editDriver(driverid,osid) {
		var params="&driverid=" + driverid + "&osid=" + osid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=324" + params;
	} //os_editDriver
	
	function os_addDriver(driverid,osid) {
		var params="&driverid=" + driverid + "&osid=" + osid;
		document.location.href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=320" + params;
	} //os_addDriver
	
	function setFormValues(msg,driverid){
		dojo.byId("driverid").value = driverid;
		dojo.byId('logaction').value = msg;
	} //setFormValues
	
	function callDelete(driverid, drivername) {
		var formName = dijit.byId('delDriverForm');
		var msg = "Driver " + drivername + " has been deleted";
		setFormValues(msg,driverid);
		var confirmDelete = confirm('<%= messages.getString("driver_delete_sure") %> ' + drivername + ' <%= messages.getString("driver_delete_sure_2") %>' + "?");
		if (confirmDelete) {
			formName.submit();
		} //if yesno
	};
	
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '326_Delete');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','driverid','');
        createPostForm('delForm','delDriverForm','delDriverForm','ibm-column-form','<%= prtgateway %>');
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
			<h1><%= messages.getString("driver_administration") %></h1>
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
			<p><%= messages.getString("driver_edit_information") %></p>
			<p><a class="ibm-maximize-link" href="javascript:void(0);">  </a><%= messages.getString("driver_add_os_information") %></p>
			<p><a class="ibm-signin-link" href="javascript:void(0);">  </a><%= messages.getString("driver_edit_os_information") %></p>
			<p><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=322"><%= messages.getString("driver_add_new") %></a></p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='delForm'>
				<div id='topageid'></div>
				<div id='logactionid'></div>

<% 	if (logaction != "") { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %><br />
			<% if (!drnm.equals("") || drnm != null) { %>
			<a href="#<%=drvid %>"><%= drnm %></a>
			<% } %>
		</p>
		<% if (!osdriverid.equals("") && osdriverid != null) {%>
			<p><a class='ibm-confirm-link' href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=3010&osdriverid=<%= osdriverid %>"><%= messages.getString("administer_options_file") %> - <%= drnm %>, <%= osnm %></a></p>
		<% } %>
	<% } %>
<% if (Driver_RS.getResultSetSize() > 0) { %>
<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="Display a list of all available printer drivers and the corresponding operating system they support">
	<caption><em><%= Driver_RS.getResultSetSize() %> <%= messages.getString("drivers_found") %></em></caption>
		<thead>
			<tr>
				<th scope="col" class="ibm-sort"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=321_DrvName"><span><%= messages.getString("driver_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
				<th scope="col" class="ibm-sort"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=321"><span><%= messages.getString("driver_model") %></span><span class="ibm-icon">&nbsp;</span></a></th>
				<% String headerosname = "";
					String headerosabbrname = "";
					int headerosid = 0;
					String[] osArray = new String[OSView_RS.getResultSetSize()];
					String[] osabbrArray = new String[OSView_RS.getResultSetSize()];
					int[] osidArray = new int[OSView_RS.getResultSetSize()];
					int x = 0;
					
					while(OSView_RS.next()) {
						headerosid =  OSView_RS.getInt("OSID");
						headerosname = OSView_RS.getString("OS_NAME");
						headerosabbrname = OSView_RS.getString("OS_ABBR"); 
						osArray[x] = headerosname;
						osabbrArray[x] = headerosabbrname;
						osidArray[x] = headerosid;
						x++;
				%>
				<th scope="col"><%= headerosname %></th>
				<% } //while %>
				<th scope="col"><%= messages.getString("driver_delete") %></th>
			</tr>
		</thead>
		<tbody>
		<% int driverid = 0;
		String drivername = "";
		String drivermodel = "";
		String osname = "";
		String osabbr = "";
		int osid = 0;
		
		while(Driver_RS.next()) {
			driverid = Driver_RS.getInt("DRIVERID");
			drivername = Driver_RS.getString("DRIVER_NAME");
			drivermodel = Driver_RS.getString("DRIVER_MODEL"); %>
			<tr>
		 		<td>
					<a name="<%=driverid %>"></a><%= drivername %>
				</td>
				<td>
					<a href="javascript:editDriver('<%=driverid%>');">
						<%= drivermodel %>
					</a>
				</td>
				
				<%  String sValue = "";
					for (int i=0; i < osidArray.length; i++) { 
						boolean found = false; 
						DriverView_RS.first();
						while(DriverView_RS.next()) {
							osname = DriverView_RS.getString("OS_NAME");
							osabbr = DriverView_RS.getString("OS_ABBR");
							osid = DriverView_RS.getInt("OSID");
							if (driverid == DriverView_RS.getInt("DRIVERID")) {
								if (osidArray[i] == osid) {
									found = true;
									break;
								} //if osidArray
							} //if driverid
						} // while DriverView
						if (found) {
							sValue = "<td>"+
										"<a class='ibm-signin-link' href=\"javascript:os_editDriver('"+ driverid+"','"+osidArray[i]+"')\">"+ messages.getString("edit")+osabbrArray[i] +"</a>"+
									"</td>";
						} else {
							sValue = "<td>"+
										"<a class='ibm-maximize-link' href=\"javascript:os_addDriver('"+ driverid+"','"+osidArray[i]+"')\">"+ messages.getString("add")+osabbrArray[i] +"</a>"+
									"</td>";
						} //if else	%>
					<%= sValue %>
				<%	} //for loop %>
			<td>
				<a id='delserver' class="ibm-delete-link" href="javascript:callDelete('<%=driverid%>','<%=drivername%>')" ><%= messages.getString("delete") %></a>
			</td>
		</tr>
		<% } //while Driver_RS %>
	</tbody>
</table>
<% } //end of check drivers %>
</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>