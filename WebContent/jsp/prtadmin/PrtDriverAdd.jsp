<%
	String version = "";
	String datafile = "";
	String driverpath = "";
	String configfile = "";
	String helpfile = "";
	String monitorname = "";
	String monfile = "";
	String environment = "";
	String defaultdatatype = "";
	String dependentfiles = "";
	String prtattributes = "";
	String prtprocessor = "";
	String prtprocfile = "";
	
	String osname = "";
	String drivername = "";
	String drivermodel = "";
	int driverid = 0;    
	int osid = 0;
	
	PrinterTools tool = new PrinterTools();
	
	//Load data from .dat file if user selected one
	if (request.getParameter("to_page_id").equals("320c")) {
		FileUploadBean upFile = new FileUploadBean();
		
		upFile.setSavePath(System.getProperty("java.io.tmpdir"));
		upFile.doUpload(request);
		
		String Path = upFile.getSavePath();
		String sFileType = upFile.getFileType();
		String filename = Path + upFile.getFilename();
		String Table = upFile.getFieldValue("table");
		
		int maxNumEntries = 15;
		int x = 0;
		String []data = new String[maxNumEntries];
		BufferedReader in = new BufferedReader(new FileReader( filename) ) ;
		
		String s = "";
		int lineCount = 1;
		
		while( ( s = in.readLine()) != null ) {
			if (x >= maxNumEntries) {
				break;
			} else if (s != null && !s.equals("") && s.length() > 2 && !s.substring(0,1).equals("#") && !s.substring(0,2).equals("\"#")) {
				data[x] = s;
				x++;
			} 
		}
		in.close();
		
		for(int y = 0;y < maxNumEntries;y++) {
			if (data[y] != null && !data[y].equals("")) {
				String value = data[y].substring(data[y].indexOf("=") + 1,data[y].length());
				if (data[y].indexOf("version") >= 0) {
					version = value;
				} else if (data[y].indexOf("datafile") >=0) {
					datafile = value;
				} else if (data[y].indexOf("driverpath") >=0) {
					driverpath = value;
				} else if (data[y].indexOf("configfile") >=0) {
					configfile = value;
				} else if (data[y].indexOf("helpfile") >=0) {
					helpfile = value;
				} else if (data[y].indexOf("monitorname") >=0) {
					monitorname = value;
				} else if (data[y].indexOf("monfile") >=0) {
					monfile = value;
				} else if (data[y].indexOf("environment") >=0) {
					environment = value;
				} else if (data[y].indexOf("defaultdatatype") >=0) {
					defaultdatatype = value;
				} else if (data[y].indexOf("DependentFiles") >=0) {
					dependentfiles = value;
				} else if (data[y].indexOf("prtattributes") >=0) {
					prtattributes = value;
				} else if (data[y].indexOf("prtprocessor") >=0) {
					prtprocessor = value;
				} else if (data[y].indexOf("prtprocfile") >=0) {
					prtprocfile = value;
				}
			}
		}
		if (upFile.getFieldValue("osid") != null && upFile.getFieldValue("driverid") != null) {
			osid = Integer.parseInt(upFile.getFieldValue("osid"));
			driverid = Integer.parseInt(upFile.getFieldValue("driverid"));
			
			String[] osinfo = tool.getOSInfo(osid);
			osname = osinfo[0];
			
			String[] drvinfo = tool.getDriverInfo(driverid);
			drivername = drvinfo[0];
			drivermodel = drvinfo[1];
		}

	} else { //end if // End .dat file section
	
	    TableQueryBhvr DriverView  = (TableQueryBhvr) request.getAttribute("DriverView");
	    TableQueryBhvrResultSet DriverView_RS = DriverView.getResults();
	    TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	    TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	    
	    
	    while(DriverView_RS.next()) { 
			driverid = DriverView_RS.getInt("DRIVERID");
			drivername = DriverView_RS.getString("DRIVER_NAME"); 
			drivermodel = DriverView_RS.getString("DRIVER_MODEL");
		}
		
		while(OSView_RS.next()) { 
			osid = OSView_RS.getInt("OSID");
			osname = OSView_RS.getString("OS_NAME"); 
		}
	}    
%>
		<%@ include file="metainfo.jsp" %>
		<meta name="Keywords" content="Global Print add os driver"/>
		<meta name="Description" content="Global print website add os driver information page" />
		<title><%= messages.getString("global_print_title") %> | <%= messages.getString("driver_add_os_specific") %></title>
		<%@ include file="metainfo2.jsp" %>

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
		 
		 function copyDat() {
				var formName = getID('loadValuesForm');
				var FileName = document.getElementById('file').value;
				if (FileName == '') {
					alert("<%= messages.getString("filename") %>");
					document.getElementById('file').focus();
					return false;
				} else {
					formName.submit();
				}
			 }
		 
		 function addOSDriver(event) {
		 	var drivername = "<%= drivername %>";
		 	var drivermodel = "<%= drivermodel %>";
		 	var osname = "<%= osname %>";
		 	var formName = getWidgetID('DrvAdd');
		 	var logaction = getID('logaction');
		 	var formValid = formName.validate();
		 	event.preventDefault();
		 	dojo.stopEvent(event);
		 	if (formValid) {
		 		var logvalue = "OS Driver information for driver model " + drivermodel + " and " + osname + " has been added.";
	 			logaction.value = logvalue.substr(0,128);
				formName.submit();
			} else {
				return false;
			}
		 } //addOSDriver
		 
		 function cancelForm(){
		 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=321";
		 } //cancelForm
		 	 
		dojo.ready(function() {
	     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '325_Drv');
	        createHiddenInput('logactionid','logaction','');
	        createHiddenInput('logactionid','driverid','<%= driverid %>');
	        createHiddenInput('logactionid','osid','<%= osid %>');
	        createHiddenInput('logactionid','drivername','<%= drivername %>');
	        createHiddenInput('logactionid','osname','<%= osname %>');
	        createHiddenInput('loadvaluesid','driverid','<%= driverid %>');
	        createHiddenInput('loadvaluesid','osid','<%= osid %>');
	        createpTag();
	        createTextInput('versionloc','version','version','16',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_version,'<%= version %>');
	        createTextInput('datafileloc','datafile','datafile','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_datafile,'<%= datafile %>');
	        createTextInput('driverpathloc','driverpath','driverpath','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_path,'<%= driverpath %>');
	        createTextInput('configfileloc','configfile','configfile','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_configfile,'<%= configfile %>');
	        createTextInput('helpfileloc','helpfile','helpfile','64',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_helpfile,'<%= helpfile %>');
	        createTextInput('driverpackageloc','driverpackage','driverpackage','255',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_package,'');
	        createTextInput('filelistloc','filelist','filelist','1536',true,'<%= messages.getString("required_info") %>','','<%= messages.getString("field_problems") %>',g_driver_filelist,'<%= dependentfiles %>');
	        createTextBox('monitorloc','monitor','monitor','64','','<%= monitorname %>');
	        createTextBox('defaulttypeloc','defaulttype','defaulttype','16','','<%= defaultdatatype %>');
	        createTextBox('monitorfileloc','monitorfile','monitorfile','512','','<%= monfile %>');
	        createTextBox('processorloc','processor','processor','64','','<%= prtprocessor %>');
	        createTextBox('procfileloc','procfile','procfile','64','','<%= prtprocfile %>');
	        createTextBox('prtattributesloc','prtattributes','prtattributes','16','','<%= prtattributes %>');
	        createTextBox('changeiniloc','changeini','changeini','16','','');
	        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_driver');
	 		createSpan('submit_add_button','ibm-sep');
		 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_driver','cancelForm()');
	     	createPostForm('addOSDriver','DrvAdd','DrvAdd','ibm-column-form','<%= prtgateway %>');
	     	dijit.byId('version').focus();
	     	var inputButton1 = dojo.byId("submit_add_driver");
	     	var submitButton = { 
   				onClick: function(evt){
   					addOSDriver(evt);
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
			<h1><%= messages.getString("driver_add_os_specific") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
			<p>
				<%= messages.getString("required_info") %>
			</p>
			<div class="ibm-alternate-rule"></div>
			<p><%= messages.getString("driver_add_from_dat_file") %></p>
			<form action="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=320c" name="loadValuesForm" id="loadValuesForm" class="ibm-column-form ibm-styled-form" enctype="multipart/form-data" method="post">
			<div id="loadvaluesid"></div>
			<p>
				<label for='file'><%= messages.getString("filename") %>:<span class='ibm-required'>*</span></label>
				<span>
					<input name="file" id="file" size="40" type="file" value=""/>
				</span>
			</p>
			<div class="ibm-buttons-row">
				<p>
					<span>
						<input value="<%= messages.getString("submit") %>" type="button" name="ibm-submit" class="ibm-btn-arrow-pri" onClick="javascript:copyDat();" />
					</span>
				</p>
			</div>
			</form>
			<div class="ibm-alternate-rule"></div>
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='addOSDriver'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass"><label for="os"><%= messages.getString("os") %>:</label> <%= osname %></div>
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