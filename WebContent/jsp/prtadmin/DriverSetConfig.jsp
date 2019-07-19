<%

	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	TableQueryBhvr DriverSetConfigView  = (TableQueryBhvr) request.getAttribute("DriverSetConfig");
	TableQueryBhvrResultSet DriverSetConfigView_RS = DriverSetConfigView.getResults();
	TableQueryBhvr ModelDriverSet  = (TableQueryBhvr) request.getAttribute("ModelDriverSet");
	TableQueryBhvrResultSet ModelDriverSet_RS = ModelDriverSet.getResults();
	TableQueryBhvr DriverSet  = (TableQueryBhvr) request.getAttribute("DriverSet");
	TableQueryBhvrResultSet DriverSet_RS = DriverSet.getResults();
	tools.print.prtadmin.DriverSetConfigUpdate driverset = new tools.print.prtadmin.DriverSetConfigUpdate();
	AppTools tool = new AppTools();

    String driversetid = tool.nullStringConverter(request.getParameter("driver_setid"));
    int iDriverSetID = Integer.parseInt(driversetid);
    String referer = tool.nullStringConverter(request.getParameter("referer"));
    int driversetconfigid = 0;
    String logaction = tool.nullStringConverter(request.getParameter("logaction"));
    //PrinterTools tool = new PrinterTools();
    Connection con = null;
	PreparedStatement psDriverSetConfig = null;
	ResultSet DriverSetConfig_RS = null;
	PreparedStatement psOptionsFile = null;
	ResultSet OptionsFileView_RS = null;
	PreparedStatement psOptionsFile2 = null;
	ResultSet OptionsFileView2_RS = null;
	int resultSize = 0;
	//String[] osabbrArray = new String[OSView_RS.getResultSetSize()];
	String driversetname = "";
	String[] drivermodels = new String[ModelDriverSet_RS.getResultSetSize()];
	String[] models = new String[ModelDriverSet_RS.getResultSetSize()];
	String lastmodel = "";
	String lastdrivermodel = "";
	int y = 0;
	if (ModelDriverSet_RS.getResultSetSize() > 0) {
		while (ModelDriverSet_RS.next()) {
			driversetname = ModelDriverSet_RS.getString("DRIVER_SET_NAME");
			models[y] = ModelDriverSet_RS.getString("MODEL");
			drivermodels[y] = ModelDriverSet_RS.getString("DRIVER_MODEL");
			y++;
		}  //while
	} //if
	
	if (DriverSet_RS.getResultSetSize() > 0) {
		while (DriverSet_RS.next()) {
			driversetname = DriverSet_RS.getString("DRIVER_SET_NAME");
		}  //while
	} //if
%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print driver set configuration"/>
	<meta name="Description" content="Global print website driver set configuration administration page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_set_config_admin") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>

<% try {
		con = tool.getConnection(); %>
		
		<script language="Javascript">
		dojo.require("dojo.parser");
		dojo.require("dijit.form.Select");
		dojo.require("dijit.Tooltip");
		dojo.require("dijit.form.Form");
		dojo.require("dijit.Dialog");
		dojo.require("dijit.ProgressBar");
		dojo.require("dijit.form.ValidationTextBox");
		
		function optionsfileInfo(osabbr,osid) {
			var wName = "optionsfile"+osabbr;
			resetMenu(wName);
			var driversetModel = getSelectValuebyName("driver"+osabbr);
		<%	String sqlQuery2 = "select driver.driver_name, driver.driver_model, driver.driverid, os.osid, os.os_name, options_file.options_fileid, options_file.name, options_file.os_driverid from gpws.driver driver, gpws.os_driver os_driver, gpws.os os, gpws.options_file options_file where options_file.os_driverid = os_driver.os_driverid and os_driver.driverid = driver.driverid and os_driver.osid = os.osid and options_file.os_driverid in (select os_driverid from gpws.os_driver where driverid in (select driverid from gpws.model_driver where modelid in (select modelid from gpws.model_driver_set where driver_setid = ?))) order by os.sequence_number, driver.driver_model";
			psOptionsFile = con.prepareStatement(sqlQuery2,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			psOptionsFile.setInt(1, Integer.parseInt(driversetid));
			OptionsFileView_RS = psOptionsFile.executeQuery(); %>
		<%	while (OptionsFileView_RS.next()) {
				int optionsfileid = 0;
				String optionsfilename = "";
				optionsfileid = OptionsFileView_RS.getInt("OPTIONS_FILEID");
				optionsfilename = tool.nullStringConverter(OptionsFileView_RS.getString("NAME")); %>
			<%  if (!optionsfilename.equals("")) { %>
					if (driversetModel == '<%= OptionsFileView_RS.getString("DRIVER_MODEL") %>' && osid == '<%= OptionsFileView_RS.getInt("OSID") %>') {
						var optionValue = "<%= optionsfileid %>";
						var optionName = "<%= optionsfilename %>";
						addOption(wName, optionName, optionValue);
					} //if they're equal
		<%		}  //if not empty %>
		<%	} //while OptionsFileView_RS %>
			loadAvailableOptionFiles(wName);
		} //optionsfileInfo
		
		function onChangeCall(wName){
			<%  OSView_RS.first();
		 		while (OSView_RS.next()) { %>
		 			if (wName == "driver<%= OSView_RS.getString("OS_ABBR") %>") {
		 				optionsfileInfo('<%= OSView_RS.getString("OS_ABBR") %>', '<%= OSView_RS.getInt("OSID") %>');
		 			} //if
			<% } //while OSView_RS %>
			//return this;
		} //onChangeCall
		
		function loadDriverSets() {
			<% OSView_RS.first();
			 	while (OSView_RS.next()) { 
			 		int counter = 0;
					int osdriverid = 0;
					int driverid = 0;
					String drivermodel = "";
					String sqlQuery = "SELECT OS_DRIVER.OS_DRIVERID, DRIVER.DRIVER_MODEL, DRIVER.DRIVERID FROM GPWS.OS_DRIVER OS_DRIVER, GPWS.DRIVER DRIVER WHERE OS_DRIVER.DRIVERID = DRIVER.DRIVERID AND OS_DRIVER.OSID = ? AND OS_DRIVER.DRIVERID IN (SELECT DRIVERID FROM GPWS.MODEL_DRIVER WHERE MODELID IN (SELECT MODELID FROM GPWS.MODEL_DRIVER_SET WHERE DRIVER_SETID = ?))";
			 	
			 		psDriverSetConfig = con.prepareStatement(sqlQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			  		psDriverSetConfig.setInt(1, OSView_RS.getInt("OSID"));
			  		psDriverSetConfig.setInt(2, Integer.parseInt(driversetid));
			  		DriverSetConfig_RS = psDriverSetConfig.executeQuery(); 	%>
			 	createSelect('driver<%= OSView_RS.getString("OS_ABBR") %>', 'driver<%= OSView_RS.getString("OS_ABBR") %>', '<%= messages.getString("select_driver") %>...', '0', 'driver<%= OSView_RS.getString("OS_ABBR") %>loc');
			 	createSelect('optionsfile<%= OSView_RS.getString("OS_ABBR") %>', 'optionsfile<%= OSView_RS.getString("OS_ABBR") %>', '<%= messages.getString("options_file_select") %>...', '0', 'optionsfile<%= OSView_RS.getString("OS_ABBR") %>loc');
			 	<% while( DriverSetConfig_RS.next() ) {
							osdriverid = DriverSetConfig_RS.getInt("OS_DRIVERID");
							drivermodel = DriverSetConfig_RS.getString("DRIVER_MODEL");
							driverid = DriverSetConfig_RS.getInt("DRIVERID");
							counter++; 	%>
					var optionValue = "<%= osdriverid %>";
				 	var optionName = "<%= drivermodel %>";
				 	addOption('driver<%= OSView_RS.getString("OS_ABBR") %>', optionName, optionValue);
				<%  } //while DriverSetConfig_RS %>
				<%  if (counter == 0) { 
						int iReturnCode[] = driverset.checkDriverSetConfigError(OSView_RS.getInt("OSID"), iDriverSetID);
						switch (iReturnCode[0]) {
	            			case 0:  System.out.println("Everything is configured correctly for the DriverSetConfig to work."); break;
							case 1:  %> 
							dojo.byId('driver<%= OSView_RS.getString("OS_ABBR") %>msg').innerHTML = '<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321"><%= messages.getString("driver_set_os_info_missing") %></a>'; 
							<% break;
				            case 2:  %> 
				            dojo.byId('driver<%= OSView_RS.getString("OS_ABBR") %>msg').innerHTML = '<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=370&model_id=<%= iReturnCode[1] %>&referer=850"><%= messages.getString("driver_set_model_driver_link_missing") %></a>' 
				            <% break;
				            case 3:  %> 
				            dojo.byId('driver<%= OSView_RS.getString("OS_ABBR") %>msg').innerHTML = '<a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=360&driverset_id=<%= iDriverSetID %>&referer=352"><%= messages.getString("driver_set_driver_not_mapped") %></a>' 
				            <% break;
				            case 4:  %> 
				            dojo.byId('driver<%= OSView_RS.getString("OS_ABBR") %>msg').innerHTML = '<%= messages.getString("an_error_occurred") %>.  <%= messages.getString("error_see_sysadmin") %>.';
				            <% break;
				            default: System.out.println("Everything is configured correctly for the DriverSetConfig to work.");break;
						} //switch
					} //if counter = 0 %>	
			 <% } //while OSView %>
		} //loadDriverSets
		
		function loadAvailableDriverSets() {
		<%  DriverSetConfigView_RS.first();
			if (DriverSetConfigView_RS.getResultSetSize() > 0) {
				while( DriverSetConfigView_RS.next() ) {
					driversetconfigid = DriverSetConfigView_RS.getInt("DRIVER_SET_CONFIGID"); %>
						var OptSelect = "<%= DriverSetConfigView_RS.getInt("OS_DRIVERID") %>";
						if (OptSelect != 0) {
							autoSelectValue("driver"+"<%=DriverSetConfigView_RS.getString("OS_ABBR")%>",OptSelect);
							createHiddenInput('logactionid','driversetconfigid<%= DriverSetConfigView_RS.getString("OS_ABBR") %>','<%=DriverSetConfigView_RS.getInt("DRIVER_SET_CONFIGID")%>');
							addOption('driver<%= DriverSetConfigView_RS.getString("OS_ABBR") %>', '<%= messages.getString("remove_this_driver") %>...', '-1');
						} //if not 0
			<%	} //while DriverSerConfigView_RS
			} //if DriverSetConfigView_RS > 0 %>
		} //loadAvailableDriverSets
		
		function loadAvailableOptionFiles(wName) {
		<%  DriverSetConfigView_RS.first();
			if (DriverSetConfigView_RS.getResultSetSize() > 0) {
				while( DriverSetConfigView_RS.next() ) { %>
					var OptFileID  = "<%= DriverSetConfigView_RS.getInt("OPTIONS_FILEID") %>";
					if (wName == "optionsfile"+"<%= DriverSetConfigView_RS.getString("OS_ABBR") %>" && OptFileID != 0) {
						autoSelectValue(wName,OptFileID);
					} //if not 0
			<%	} //while DriverSerConfigView_RS
			} //if DriverSetConfigView_RS > 0 %>
		} //loadAvailableOptionFiles
		
		function addDriverSet(event) {
			var formName = dijit.byId('DriverConfig');
		 	var driversetModel = "";
		 	var selectedValue = false; //select at least one value
		 	<%  OSView_RS.first();
		 		while (OSView_RS.next()) { %>
		 			driversetModel = getSelectValue("driver<%= OSView_RS.getString("OS_ABBR") %>");
		 			if (driversetModel != "0") {
		 				selectedValue = true;
		 				formName.submit();
		 			} //if
			<% } //while OSView_RS %>
		 	if (!selectedValue) {
		 		alert('<%= messages.getString("select_one_driverset") %>');
				return false;
			}
		 } //addOSDriver
		 
		 function cancelForm(){
		 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=352";
		 } //cancelForm
		
		dojo.ready(function() {
			 createpTag();
			 createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '381');
			 createHiddenInput('logactionid','logaction','');
			 createHiddenInput('logactionid','driversetconfigid','<%= driversetconfigid %>');
			 createHiddenInput('logactionid','driver_setid','<%= driversetid %>');
			 createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_driver_set','addDriverSet()');
	 		 createSpan('submit_add_button','ibm-sep');
		 	 createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_driver_set','cancelForm()');
			 loadDriverSets();
			 createPostForm('DriverSet','DriverConfig','DriverConfig','ibm-column-form','<%= prtgateway %>');
			 changeSelectStyle('180px');
			 <%if (!logaction.equals("")){ %>
	        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
	        <% } %>
		});
		
		dojo.addOnLoad(function() {
			loadAvailableDriverSets();
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=352"><%= messages.getString("driver_set_administer") %></a></li>
			</ul>
			<h1 class="ibm-small"><%= messages.getString("driver_set_config_admin") %></h1>
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
			<p>
				<%= messages.getString("required_info") %>
			</p>
			<ul class="ibm-bullet-list ibm-no-links">
				<li><%= messages.getString("driver_set_config_add_info") %></li>
				<li><%= messages.getString("driver_set_config_delete_info") %></li>
			</ul>
			<br />
			<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='DriverSet'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass"><label for="drvname"><%= messages.getString("driver_set_name") %>:</label> <%= driversetname %></div>
				<div class="pClass">
					<label for="model"><%= messages.getString("device_model") %>:</label>
					<% for (int i=0; i < models.length; i++) { %>
						<%= models[i] %>,
					<% } //for loop %>
				</div>
				<div class="pClass">
					<label for="drvmodel"><%= messages.getString("driver_model") %>:</label>
					<% for (int i=0; i < drivermodels.length; i++) { %>
						<%= drivermodels[i] %>,
					<% } //for loop %>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				
				<div class="ibm-columns">
					<div class="ibm-col-6-2">
						<h2><%= messages.getString("os") %></h2>
					</div>
					<div class="ibm-col-6-2">
						<h2><%= messages.getString("driver_model") %></h2>
					</div>
					<div class="ibm-col-6-2">
						<h2><%= messages.getString("options_file") %></h2>
					</div>
				</div>
					<div class="ibm-alternate-rule"><hr /></div>
				<%	OSView_RS.first();
					while (OSView_RS.next()) {
				%>
				<div class="ibm-columns">
					<div class="ibm-col-6-2">
						<label id="oslabel" for="os">
							<%= OSView_RS.getString("OS_NAME") %><span class="ibm-required">*</span>
						</label>
					</div>
					<div id="driver<%= OSView_RS.getString("OS_ABBR") %>msg">
						<div class="ibm-col-6-2">
							<span id='driver<%= OSView_RS.getString("OS_ABBR") %>loc'></span>
						</div>
						<div class="ibm-col-6-2">
							<span id='optionsfile<%= OSView_RS.getString("OS_ABBR") %>loc'></span>
						</div>
					</div>
				</div>
				
			<% } //while OSView_RS %> 
				<div class="ibm-columns">
					<div class="ibm-col-6-2"></div>
					<div class="ibm-col-6-2">
						<div class="pClass">
							<div class='ibm-buttons-row'>
								<div id='submit_add_button'></div>
							</div>
						</div>
					</div>
					<div class="ibm-col-6-2"></div>
				</div>
				
			</div><!--  End of form -->
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>
<%
	} catch (Exception e) {
			System.out.println("Error in DriverSetConfig.jsp ERROR: " + e);
	} finally {
		DriverSetConfig_RS.close();
		psDriverSetConfig.close();
		OptionsFileView_RS.close();
		psOptionsFile.close();
		con.close();
	}
%>