<%   
	TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSetNoDeviceList");
	TableQueryBhvrResultSet DriverSet_RS = DriverSet.getResults();   
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults(); 
	AppTools tool = new AppTools();   
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String model_id = tool.nullStringConverter(request.getParameter("modelid"));
	String model = "";
	int modelid = 0;
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	PreparedStatement psDriverSetConfig = null;
	ResultSet DriverSetConfig_RS = null;
	PreparedStatement psOptionsFile = null;
	ResultSet OptionsFileView_RS = null;
	PreparedStatement psDriverSetCount = null;
	ResultSet DriverSetCount_RS = null;
	int resultSize = 0;
	int[] driversetidArray = new int[DriverSet_RS.getResultSetSize()];
	String[] driversetArray = new String[DriverSet_RS.getResultSetSize()];
	int[] driversetDevCountArray = new int[DriverSet_RS.getResultSetSize()];
	int[] osarray = new int[OSView_RS.getResultSetSize()];
	int osc = 0;
	for (int x=0; x < OSView_RS.getResultSetSize(); x++) {
		if (request.getParameter("OS_" + x) != null && Integer.parseInt(request.getParameter("OS_" + x)) > 0) {
			osarray[osc] = Integer.parseInt(request.getParameter("OS_" + x));
			osc++;
		}
	}
	
	int y = 0;
	if (DriverSet_RS.getResultSetSize() > 0) {
		while (DriverSet_RS.next()) {
			driversetidArray[y] = DriverSet_RS.getInt("DRIVER_SETID");
			driversetArray[y] = DriverSet_RS.getString("DRIVER_SET_NAME");
			driversetDevCountArray[y] = DriverSet_RS.getInt("COUNT");
			y++;
		}  //while
	} //if
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print driver set report"/>
	<meta name="Description" content="Global print website driver set report page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_report") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<%-- 	<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script> --%>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.CheckBox");
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = dojo.byId(tooltipID);
    	dijit.showTooltip(reqMsg, tooltip);
	 } //showReqMsg	 
	 
	 function cancelForm(){
		document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function onChangeCall(wName){
	 	return false;
	 } //onChangeCall
	 	 
	 function callSubmit(event) {
		var formName = dojo.byId('DriverSetForm');
		if (event) { event.preventDefault(); dojo.stopEvent(event); }
		var values = 0;
		var OSCount = <%= OSView_RS.getResultSetSize() %>;
		for (var x=0; x<OSCount; x++) {
			if (getSelectValue('OS_' + x) == false) {
				dojo.byId('OS_' + x).value = 0;
			} else {
				values++;
			}
		}
		if (values > 0 && values <= 3) {
			formName.submit();
		} else {
			alert("<%= messages.getString("select_up_to_os") %>");
			return false;
		}
	 } //callSubmit
	 
	 function showPrinters(driverSet) {
		onGo('<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=581&driverset=' + driverSet, 810, 1070);
	 } //showHelp
	 
	 function onGo(link,h,w) {
		var chasm = screen.availWidth;
		var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + ',scrollbars=yes,resizable=yes,status=yes';	
		args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		w = window.open(link,'_blank',args);
		return false;
	 }  //onGo
	 
	 function createCheckBox(wName, wValue, wLabel, wCheck, wLoc){
		 	var cb = new dijit.form.CheckBox({
	             name: wName,
	             id: wName,
	             innerHTML: wName,
	             value: wValue,
	             checked: wCheck,
	             onChange: function(){
	    			onChangeCall(wName);
	    		 }, 
	         });
	         dojo.place(cb.domNode,dojo.byId(wLoc),"before");
	         dojo.create('nbsp',{'for':cb.name, innerHTML:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'},cb.domNode,"before");
	         dojo.create('label',{'for':cb.name, innerHTML:wLabel},cb.domNode,"after");
		 } //createCheckBox
		 
	 function createCheckBoxList(wName, wValue, wLabel, wCheck, wLoc){
		 	var cb = new dijit.form.CheckBox({
	             name: wName,
	             id: wName,
	             innerHTML: wName,
	             value: wValue,
	             checked: wCheck,
	             onChange: function(){
	     			onChangeCall(wName);
	     		 },
	         });
	         dojo.place(cb.domNode,dojo.byId(wLoc),"before");
	         dojo.create('nbsp',{'for':cb.name, innerHTML:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'},cb.domNode,"before");
	         dojo.create("br",null,cb.domNode,"after");
	         dojo.create('label',{'for':cb.name, innerHTML:wLabel},cb.domNode,"after");
		 } //createCheckBox
	 
	 function createOSCheckBoxes() {
		 <% int x = 0;
		 	while (OSView_RS.next()) { 
				if (x == 1 || x == 3 || x == 5 || x == 7) { %>
					createCheckBoxList('OS_<%= x %>', '<%= OSView_RS.getInt("OSID") %>', '<%= tool.nullStringConverter(OSView_RS.getString("OS_NAME")) %>', '', 'oses');
		 	<%	} else { %>
					createCheckBox('OS_<%= x %>', '<%= OSView_RS.getInt("OSID") %>', '<%= tool.nullStringConverter(OSView_RS.getString("OS_NAME")) %>', '', 'oses');
		 	<%	} 
		 		x++;
		 	} %>
	 }
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '582');
        createHiddenInput('logactionid','logaction','');
        createpTag();
		createOSCheckBoxes();
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("refresh_view") %>','ibm-btn-arrow-pri','submit_refresh');
     	createGetForm('DriverSet','DriverSetForm','DriverSetForm','ibm-column-form','<%= prtgateway %>');
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(dojo.byId('DriverSetForm'), 'onsubmit', function(event) {
		 	callSubmit(event);
		 });
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=520"><%= messages.getString("tableselect_reports_admin") %></a></li>
			</ul>
			<h1><%= messages.getString("driver_set_report") %></h1>
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
			
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='DriverSet'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='oses'><%= messages.getString("operating_systems") %>:<span class='ibm-required'>*</span></label>
					<span class="ibm-input-group"><div id='oses'></div></span>
				</div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
						<div id='submit_add_button'></div>
					</div>
				</div>
			</div>
			<div class='ibm-alternate-rule'><hr /></div>
				<p><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=582_CSV"><%= messages.getString("export_csv") %></a></p>
				<% try {
					con = tool.getConnection(); 
				%>
				<br />
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("display_list_avail_driver_sets") %>">
					<caption><em><%= messages.getString("third_item_listed") %></em></caption>
					<thead>
						<tr>
							<th scope="col" class="ibm-sort"><%= messages.getString("driver_set_name") %></th>
							<%	OSView_RS.first();
								while (OSView_RS.next()) {	
								if (OSView_RS.getInt("OSID") == osarray[0] || OSView_RS.getInt("OSID") == osarray[1] || OSView_RS.getInt("OSID") == osarray[2]) { %>
							<th scope="col"><%= OSView_RS.getString("OS_NAME") %></th>
							<%  } } //while OSView %>
							<th scope="col"><%= messages.getString("number_of_devices") %></th>
						</tr>
					</thead>
					<tbody>
					<%	OSView_RS.first();
						String sqlQuery = "";
						sqlQuery = "SELECT DSCV.OS_DRIVERID, DSCV.DRIVER_MODEL, DSCV.DRIVERID, DSCV.DRIVER_SET_NAME, DSCV.OPTIONS_FILEID, DSCV.OPTIONS_FILE_NAME, DSCV.FUNCTIONS, OSD.PACKAGE FROM GPWS.DRIVER_SET_CONFIG_VIEW DSCV LEFT OUTER JOIN GPWS.OS_DRIVER OSD ON (DSCV.OS_DRIVERID = OSD.OS_DRIVERID) WHERE DSCV.OSID = ? AND DSCV.DRIVER_SETID = ?";
						psDriverSetConfig = con.prepareStatement(sqlQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
						  	
						for (int i=0; i < driversetidArray.length; i++) { %>
						<tr>
							<td>
								<%= driversetArray[i] %>
							</td>
					<%
						String dsname = "";
						OSView_RS.first();
						while (OSView_RS.next()) {
							if (OSView_RS.getInt("OSID") == osarray[0] || OSView_RS.getInt("OSID") == osarray[1] || OSView_RS.getInt("OSID") == osarray[2]) {
							int counter = 0;
							int osdriverid = 0;
							int driverid = 0;
							String drivermodel = "";
							String optionsfile = "";
							String packageName = "";
							psDriverSetConfig.setInt(1, OSView_RS.getInt("OSID"));
						  	psDriverSetConfig.setInt(2, driversetidArray[i]);
						  	DriverSetConfig_RS = psDriverSetConfig.executeQuery();
						  	
							if (DriverSetConfig_RS.next() == false) { %>
									<td bgcolor="#ffe14f">
									<% } else { %>
									<td>
									<% } %>
								<% 	DriverSetConfig_RS.beforeFirst();
									while( DriverSetConfig_RS.next() ) {
										osdriverid = DriverSetConfig_RS.getInt("OS_DRIVERID");
										drivermodel = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_MODEL"));
										driverid = DriverSetConfig_RS.getInt("DRIVERID");
										optionsfile = tool.nullStringConverter(DriverSetConfig_RS.getString("OPTIONS_FILE_NAME"));
										dsname = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_SET_NAME"));
										packageName = tool.nullStringConverter(DriverSetConfig_RS.getString("PACKAGE")).replaceAll("/home/webuser/pub","");

										counter++;
								%>
									
									<%= drivermodel %><br />
									<% if (optionsfile != null && !optionsfile.equals("")) { %>
										<i>(<%= optionsfile %>)</i>
									<% } else {	%>
										<i><%= messages.getString("none") %></i>
									<% } %>
									<br /><%= packageName %>
								<%  } //while DriverSetConfig_RS %>
							</td> 
					<% 	} } //while OSView %> 
						<%
							if (driversetDevCountArray[i] <= 0) { %>
								<td bgcolor="#ffe14f">
							<% } else { %>
								<td>
							<% } %><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=581&driverset=<%= driversetArray[i] %>" target="newWindow" onclick="showPrinters('<%= driversetArray[i] %>'); return false;"><%= driversetDevCountArray[i] %></a></td>
						</tr>
					<%	} // for loop %>
					</tbody>
				</table> 
				<%  } catch (Exception e) { 
						System.out.println("Error in DriverSetAuditReport.jsp ERROR: " + e);
					} finally {
						if (DriverSetConfig_RS != null)
							DriverSetConfig_RS.close();
						if (psDriverSetConfig != null)
							psDriverSetConfig.close();
						if (con != null)
							con.close();
					} %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>