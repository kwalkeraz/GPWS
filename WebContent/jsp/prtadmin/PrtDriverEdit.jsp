<%
    TableQueryBhvr DriverView  = (TableQueryBhvr) request.getAttribute("DriverView");
    TableQueryBhvrResultSet DriverView_RS = DriverView.getResults();
    TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
    TableQueryBhvrResultSet OSView_RS = OSView.getResults();
    AppTools tool = new AppTools();
    String osname = "";
    String osabbr = "";
    String drivername = "";
    String drivermodel = "";
    String version = "";
    String driver_package = "";
    String data_file = "";
    String driver_path = "";
    String config_file = "";
    String help_file = "";
    String monitor = "";
    String monitor_file = "";
    String proc = "";
    String proc_file = "";
    String prt_attributes = "";
    String file_list = "";
    String default_type = "";
    String changeini = "";
    int driverid = 0;    
    int osid = 0;
    int driverosid = 0;
    int origosid = 0;
    int os_driverid = 0;
    String origosname = "";
    while(DriverView_RS.next()) { 
			driverid = DriverView_RS.getInt("DRIVERID");
			driverosid = DriverView_RS.getInt("OSID");
			os_driverid = DriverView_RS.getInt("OS_DRIVERID");
			drivername = tool.nullStringConverter(DriverView_RS.getString("DRIVER_NAME")); 
			drivermodel = tool.nullStringConverter(DriverView_RS.getString("DRIVER_MODEL"));
			version = tool.nullStringConverter(DriverView_RS.getString("VERSION"));
			driver_package = tool.nullStringConverter(DriverView_RS.getString("PACKAGE"));
			data_file = tool.nullStringConverter(DriverView_RS.getString("DATA_FILE"));
			driver_path = tool.nullStringConverter(DriverView_RS.getString("DRIVER_PATH"));
			config_file = tool.nullStringConverter(DriverView_RS.getString("CONFIG_FILE"));
			help_file = tool.nullStringConverter(DriverView_RS.getString("HELP_FILE"));
			monitor = tool.nullStringConverter(DriverView_RS.getString("MONITOR"));
			monitor_file = tool.nullStringConverter(DriverView_RS.getString("MONITOR_FILE"));
			proc = tool.nullStringConverter(DriverView_RS.getString("PROC"));
			proc_file = tool.nullStringConverter(DriverView_RS.getString("PROC_FILE"));
			prt_attributes = tool.nullStringConverter(DriverView_RS.getString("PRT_ATTRIBUTES"));
			file_list = tool.nullStringConverter(DriverView_RS.getString("FILE_LIST"));
			default_type = tool.nullStringConverter(DriverView_RS.getString("DEFAULT_TYPE"));
			changeini = tool.nullStringConverter(DriverView_RS.getString("CHANGE_INI"));
	}
	
	while(OSView_RS.next()) { 
			osid = OSView_RS.getInt("OSID");
			osname = tool.nullStringConverter(OSView_RS.getString("OS_NAME"));
			if (osid == driverosid) {
				origosid = osid;
				origosname = osname;
			} //if they're the same
	}
%>
		<%@ include file="metainfo.jsp" %>
		<meta name="Keywords" content="Global Print edit os driver"/>
		<meta name="Description" content="Global print website edit os driver information page" />
		<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_edit_os_specific") %></title>
		<%@ include file="metainfo2.jsp" %>
				
		<!-- <script djConfig="parseOnLoad: true"></script> -->
		<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
		<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
		
		<script type="text/javascript">
		dojo.require("dojo.parser");
		 dojo.require("dijit.Tooltip");
		 dojo.require("dijit.form.Form");
		 dojo.require("dijit.form.ValidationTextBox");
		 dojo.require("dijit.form.Button");
		 dojo.require("dijit.form.TextBox");
		 
		 function editOSDriver(event) {
		 	var drivername = "<%= drivername %>";
		 	var drivermodel = "<%= drivermodel %>";
		 	var osname = "<%= origosname %>";
		 	var formName = getWidgetID('DrvEdit');
		 	var logaction = getID('logaction');
		 	var formValid = formName.validate();
		 	event.preventDefault();
		 	dojo.stopEvent(event);
		 	if (formValid) {
		 		var logvalue = "OS Driver information for driver model " + drivermodel + " and " + osname + " has been updated.";
		 		logaction.value = logvalue.substr(0,128);
				formName.submit();
			} else {
				return false;
			}
		 } //addOSDriver
		 
		 function callDelete() {
			var drivername = "<%= drivername %>";
		 	var drivermodel = "<%= drivermodel %>";
		 	var osname = "<%= origosname %>";
		 	var formName = getWidgetID('DrvEdit');
		 	var logaction = getID('logaction');
			YesNo = confirm('<%= messages.getString("driver_delete_sure") %> ' + drivername + ' - ' + osname + '?');
			if (YesNo == true) {
				getID("<%= BehaviorConstants.TOPAGE %>").value = "323_Drv";
				setValue('osid', '<%= origosid %>');
				setValue('driverid', '<%= driverid %>');
				setValue('osdriverid', '');
				logaction.value = "OS Driver information for driver " + drivername + ", driver model " + drivermodel + " and " + osname + " has been deleted";
				formName.submit();
			}
			return false;
		} //callDelete
		 
		 function cancelForm(){
		 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321";
		 } //cancelForm
		 	 
		dojo.ready(function() {
	     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '324_Drv');
	        createHiddenInput('logactionid','logaction','');
	        createHiddenInput('logactionid','osdriverid','<%= os_driverid %>');
	        createHiddenInput('logactionid','driverid','<%= driverid %>');
	        createHiddenInput('logactionid','osid','<%= origosid %>');
	        createHiddenInput('logactionid','drivername','<%= drivername %>');
	        createHiddenInput('logactionid','osname','<%= origosname %>');
	        createpTag();
	        createTextInput('versionloc','version','version','16',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_version,'<%= version %>');
	        createTextInput('datafileloc','datafile','datafile','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_datafile,'<%= data_file %>');
	        createTextInput('driverpathloc','driverpath','driverpath','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_path,'<%= driver_path %>');
	        createTextInput('configfileloc','configfile','configfile','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_configfile,'<%= config_file %>');
	        createTextInput('helpfileloc','helpfile','helpfile','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_helpfile,'<%= help_file %>');
	        createTextInput('driverpackageloc','driverpackage','driverpackage','255',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_package,'<%= driver_package %>');
	        createTextInput('filelistloc','filelist','filelist','1536',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_filelist,'<%= file_list %>');
	        createTextBox('monitorloc','monitor','monitor','64','','<%= monitor %>');
	        createTextBox('defaulttypeloc','defaulttype','defaulttype','16','','<%= default_type %>');
	        createTextBox('monitorfileloc','monitorfile','monitorfile','512','','<%= monitor_file%>');
	        createTextBox('processorloc','processor','processor','64','','<%= proc %>');
	        createTextBox('procfileloc','procfile','procfile','64','','<%= proc_file%>');
	        createTextBox('prtattributesloc','prtattributes','prtattributes','16','','<%= prt_attributes%>');
	        createTextBox('changeiniloc','changeini','changeini','16','','<%= changeini%>');
	        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_driver');
	 		createSpan('submit_add_button','ibm-sep');
		 	createInputButton('submit_add_button','ibm-submit','<%= messages.getString("delete") %>','ibm-btn-arrow-pri','delete_add_driver','callDelete()');
	 		createSpan('submit_add_button','ibm-sep');
		 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_driver','cancelForm()');
	     	createPostForm('editOSDriver','DrvEdit','DrvEdit','ibm-column-form','<%= prtgateway %>');
	     	dijit.byId('version').focus();
	     	var inputButton1 = getID("submit_add_driver");
	     	var submitButton = { 
	     					onClick: function(evt){
	     							editOSDriver(evt);
								} //function
							};
	     	dojo.connect(inputButton1, "onclick", submitButton.onClick);
	     	changeInputTagStyle("400px");
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321"><%= messages.getString("driver_administration") %></a></li>
			</ul>
			<h1><%= messages.getString("driver_edit_os_specific") %></h1>
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
				<li><%= messages.getString("driver_os_specific_delete") %></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=3010&osdriverid=<%= os_driverid %>"><%= messages.getString("administer_options_file") %></a></li>
			</ul> 
			<p>
				<%= messages.getString("required_info") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='editOSDriver'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass"><label for="os"><%= messages.getString("os") %>:</label> <%= origosname %></div>
				<div class="pClass"><label for="drvname"><%= messages.getString("driver_name") %>:</label> <%= drivername %></div>
				<div class="pClass"><label for="drvmodel"><%= messages.getString("driver_model") %>:</label> <%= drivermodel %></div>
				<div class="pClass">
				<label for='version'><%= messages.getString("version") %>:<span class='ibm-required'>*</span></label> 
				<span><div id='versionloc'></div></span>
				</div>
				<div class="pClass">
				<label for='datafile'><%= messages.getString("driver_data_file") %>:<span class='ibm-required'>*</span></label>
				<span><div id='datafileloc'></div></span>
				</div>
				<div class="pClass">
				<label for='driverpath'><%= messages.getString("driver_path") %>:<span class='ibm-required'>*</span></label>
				<span><div id='driverpathloc'></div></span>
				</div>
				<div class="pClass">
				<label for='configfile'><%= messages.getString("driver_configuration_file") %>:<span class='ibm-required'>*</span></label>
				<span><div id='configfileloc'></div></span>
				</div>
				<div class="pClass">
				<label for='helpfile'><%= messages.getString("driver_help_file") %>:<span class='ibm-required'>*</span></label>
				<span><div id='helpfileloc'></div></span>
				</div>
				<div class="pClass">
				<label for='driverpackage'><%= messages.getString("driver_package") %>:<span class='ibm-required'>*</span></label>
				<span><div id='driverpackageloc'></div></span>
				</div>
				<div class="pClass">
				<label for='filelist'><%= messages.getString("driver_file_list") %>:<span class='ibm-required'>*</span></label>
				<span><div id='filelistloc'></div></span>
				</div>
				<div class="pClass">
				<label for='monitor'><%= messages.getString("driver_monitor") %>:<span></span></label>
				<span><div id='monitorloc'></div></span>
				</div>
				<div class="pClass">
				<label for='defaulttype'><%= messages.getString("driver_default_type") %>:</label>
				<span><div id='defaulttypeloc'></div></span>
				</div>
				<div class="pClass">
				<label for='monitorfile'><%= messages.getString("driver_monitor_file") %>:</label>
				<span><div id='monitorfileloc'></div></span>
				</div>
				<div class="pClass">
				<label for='processor'><%= messages.getString("driver_printer_processor") %>:</label>
				<span><div id='processorloc'></div></span>
				</div>
				<div class="pClass">
				<label for='procfile'><%= messages.getString("driver_printer_proc_file") %>:</label>
				<span><div id='procfileloc'></div></span>
				</div>
				<div class="pClass">
				<label for='prtattributes'><%= messages.getString("driver_printer_attributes") %>:</label>
				<span><div id='prtattributesloc'></div></span>
				</div>				
				<div class="pClass">
				<label for='changeini'><%= messages.getString("driver_change_ini") %>:</label>
				<span><div id='changeiniloc'></div></span>
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
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>