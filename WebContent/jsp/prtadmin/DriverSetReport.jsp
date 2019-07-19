<%
   TableQueryBhvr QueryType  = (TableQueryBhvr) request.getAttribute("QueryType");
   TableQueryBhvrResultSet QueryType_RS = QueryType.getResults();   
   TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSet");
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
	String driversetname = "";
	int[] driversetidArray = new int[DriverSet_RS.getResultSetSize()];
	String[] driversetArray = new String[DriverSet_RS.getResultSetSize()];
	int y = 0;
	
	if (DriverSet_RS.getResultSetSize() > 0) {
		while (DriverSet_RS.next()) {
			model = DriverSet_RS.getString("MODEL");
			driversetname = DriverSet_RS.getString("DRIVER_SET_NAME");
			driversetidArray[y] = DriverSet_RS.getInt("DRIVER_SETID");
			driversetArray[y] = DriverSet_RS.getString("DRIVER_SET_NAME");
			y++;
		}  //while
	} //if
%>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print driver set report"/>
	<meta name="Description" content="Global print website driver set report page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_report") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/createDialog.js"></script>
	<script type="text/javascript" src="/tools/print/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	<script type="text/javascript" src="/tools/print/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="/tools/print/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="/tools/print/js/createSelect.js"></script>
	<script type="text/javascript" src="/tools/print/js/addOption.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
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
	 
	 function addModel(){
	 	var selectMenu = dijit.byId('modelid');
	 	<% while(QueryType_RS.next()) { 
			String modelVar = QueryType_RS.getString("MODEL");
			int modelidVar =  QueryType_RS.getInt("MODELID"); %>
			var optionName = "<%= modelVar %>";
			var optionValue = "<%= modelidVar %>";
			addOption(selectMenu,optionName,optionValue);
		<% } //while %>
	 } //addValues
	 
	 function callSubmit(event) {
		var formName = dojo.byId('DriverSetForm');
		if (event) { event.preventDefault(); dojo.stopEvent(event); }
		var model = getSelectValue('modelid');
		if (model == "0") {
			showReqMsg('<%= messages.getString("device_select_model") %>','modelid');
			return false;
		} else {
			formName.submit();
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
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '580');
        //createHiddenInput('logactionid','logaction','');
        createpTag();
        createSelect('modelid', 'modelid', '<%= messages.getString("device_select_model") %> ...', '0', 'model');
        addModel();
        autoSelectValue('modelid','<%= model_id %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("refresh_view") %>','ibm-btn-arrow-pri','submit_refresh');
     	createGetForm('DriverSet','DriverSetForm','DriverSetForm','ibm-column-form','<%= prtgateway %>');
     	changeSelectStyle('250px');
     	dijit.byId('modelid').focus();
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
					<label for='model'><%= messages.getString("model") %>:<span class='ibm-required'>*</span></label>
					<span><div id='model'></div></span>
				</div>
				<div class='ibm-overlay-rule'><hr /></div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='submit_add_button'></div>
					</span>
					</div>
				</div>
			</div>
			<div class='ibm-alternate-rule'><hr /></div>
			<% if (!request.getParameter("modelid").equals("0")) { %>
				<p><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=580_CSV&modelid=<%= model_id %>"><%= messages.getString("export_chart_csv") %></a></p>
				<% try {
						con = tool.getConnection(); 
				%>
				<div class="pClass">
					<%= messages.getString("model") %>: <%= model %>
				</div>
				<br />
				<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="<%= messages.getString("display_list_avail_driver_sets") %>">
					<caption><em><%= messages.getString("third_item_listed") %></em></caption>
					<thead>
						<tr>
							<th scope="col"><%= messages.getString("driver_set_name") %></th>
							<%	while (OSView_RS.next()) {	%>
							<th scope="col"><%= OSView_RS.getString("OS_NAME") %></th>
							<%  } //while OSView %>
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
							int counter = 0;
							int osdriverid = 0;
							int driverid = 0;
							String drivermodel = "";
							String optionsfile = "";
							String packageName = "";
							psDriverSetConfig.setInt(1, OSView_RS.getInt("OSID"));
						  	psDriverSetConfig.setInt(2, driversetidArray[i]);
						  	DriverSetConfig_RS = psDriverSetConfig.executeQuery();
					%>
							<td>
								<% 	
									while( DriverSetConfig_RS.next() ) {
										osdriverid = DriverSetConfig_RS.getInt("OS_DRIVERID");
										drivermodel = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_MODEL"));
										driverid = DriverSetConfig_RS.getInt("DRIVERID");
										optionsfile = tool.nullStringConverter(DriverSetConfig_RS.getString("OPTIONS_FILE_NAME"));
										dsname = tool.nullStringConverter(DriverSetConfig_RS.getString("DRIVER_SET_NAME"));
										packageName = tool.nullStringConverter(DriverSetConfig_RS.getString("PACKAGE")).replaceAll("/home/webuser/pub","");
										counter++; 
								%>
									<%= drivermodel %>
									<% if (optionsfile != null && !optionsfile.equals("")) { %>
										<i>(<%= optionsfile %>)</i>
									<% } else {	%>
										<i><%= messages.getString("none") %></i>
									<% } %>
									<%= packageName %>
								<%  } //while DriverSetConfig_RS %>
							</td> 
					<% 	}  //while OSView  %>
						<!-- Execute printer count query --> 
						<%
							stmt = null;
							rs = null;
							int printerCount = 0;
							try {
								String sqlQueryDSC = "SELECT COUNT(*) AS COUNT FROM GPWS.DEVICE_VIEW WHERE DRIVER_SET_NAME = ?";
								psDriverSetCount = con.prepareStatement(sqlQueryDSC,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
								psDriverSetCount.setString(1, dsname);
								DriverSetCount_RS = psDriverSetCount.executeQuery();
							
								while (DriverSetCount_RS.next()) {							
									printerCount = DriverSetCount_RS.getInt("COUNT");
								}
							} catch (Exception e) {
					  			System.out.println("GPWS error in DriverSetReport.jsp.1 ERROR: " + e);
					  		} finally {
					  			try {
					  				if (DriverSetCount_RS != null)
					  					DriverSetCount_RS.close();
					  				if (psDriverSetCount != null)
					  					psDriverSetCount.close();
					  			} catch (Exception e){
						  			System.out.println("GPWS Error in DriverSetReport.jsp.2 ERROR: " + e);
					  			}
					  		}
						%>
							<td><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=581&driverset=<%= dsname %>" target="newWindow" onclick="showPrinters('<%= dsname %>'); return false;"><%= printerCount %></a></td>
						</tr>
					<%	} // for loop %>
					</tbody>
				</table> 
				<%  } catch (Exception e) { System.out.println("Error in DriverSetHelp.jsp ERROR: " + e);
					} finally {
						if (DriverSetConfig_RS != null)
							DriverSetConfig_RS.close();
						if (psDriverSetConfig != null)
							psDriverSetConfig.close();
						if (con != null)
							con.close();
					} %>
			<% } else { %>
				<p>
					<%= messages.getString("please_select_device_model") %>
				</p>
			<% } %>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>