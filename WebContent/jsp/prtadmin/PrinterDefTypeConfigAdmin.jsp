<%	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	TableQueryBhvr PrinterDefTypeConfig  = (TableQueryBhvr) request.getAttribute("PrinterDefType");
	TableQueryBhvrResultSet PrinterDefTypeConfig_RS = PrinterDefTypeConfig.getResults();
	int printerdeftypeconfigid = 0;
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	String printerdeftypeid = tool.nullStringConverter(request.getParameter("printerdeftypeid"));
	String serverdeftype = tool.nullStringConverter(request.getParameter("serverdeftype"));
	String clientdeftype = tool.nullStringConverter(request.getParameter("clientdeftype"));
	String referer = tool.nullStringConverter(request.getParameter("referer"));
	Connection con = null;
	Statement stmtPrinterDefConfig = null;
	ResultSet ProtocolInfo_RS = null;
	int resultSize = 0;
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print printer definition type configuration"/>
	<meta name="Description" content="Global print website view administer printer definition type configuration" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_def_type_config_admin") %> </title>
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
	
<%	try {
		con = tool.getConnection();
		stmtPrinterDefConfig = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); %>
	
	<script language="Javascript">
		dojo.require("dojo.parser");
		dojo.require("dijit.form.Select");
		dojo.require("dijit.Tooltip");
		dojo.require("dijit.form.Form");
		dojo.require("dijit.Dialog");
		
		function onChangeCall(wName){
			return this;
		} //onChangeCall
		
		function loadPrintDefTypes(){
		<%	while (OSView_RS.next()) { %>
				createSelect('printerdeftypeid<%= OSView_RS.getString("OS_ABBR") %>', 'printerdeftypeid<%= OSView_RS.getString("OS_ABBR") %>', '<%= messages.getString("select_protocol") %>...', '0', 'printerdeftypeid<%= OSView_RS.getString("OS_ABBR") %>loc');
			<%  String sqlQuery = "";
				sqlQuery = "SELECT OS_PROTOCOLID, PROTOCOL_NAME, PROTOCOLID FROM GPWS.PROTOCOL_VIEW WHERE OSID = " + OSView_RS.getInt("OSID") + " ORDER BY PROTOCOL_NAME";
				ProtocolInfo_RS = stmtPrinterDefConfig.executeQuery(sqlQuery);
				while(ProtocolInfo_RS.next()) {
					int osprotocolid = 0;
					int protocolid = 0;
					String protocolname = "";
					osprotocolid = ProtocolInfo_RS.getInt("OS_PROTOCOLID");
					protocolname = ProtocolInfo_RS.getString("PROTOCOL_NAME");
					protocolid = ProtocolInfo_RS.getInt("PROTOCOLID");	%>
					var optionValue = "<%= osprotocolid %>";
				 	var optionName = "<%= protocolname %>";
				 	addOption('printerdeftypeid<%= OSView_RS.getString("OS_ABBR") %>',optionName,optionValue);
			<%  } //while ProtocolInfo_RS %>
		<%  } //while %>
		} //loadPrintDefTypes
		
		function loadAvailablePrinterDefTypes() {
		<%  PrinterDefTypeConfig_RS.first();
			if (PrinterDefTypeConfig_RS.getResultSetSize() > 0) {
				while( PrinterDefTypeConfig_RS.next() ) {
					printerdeftypeconfigid = PrinterDefTypeConfig_RS.getInt("PRINTER_DEF_TYPE_CONFIGID"); %>
					createHiddenInput('logactionid','printerdeftypeconfigid<%= PrinterDefTypeConfig_RS.getString("OS_ABBR") %>','<%= printerdeftypeconfigid %>','');
						var drivermenu = getWidgetID('printerdeftypeid<%= PrinterDefTypeConfig_RS.getString("OS_ABBR") %>');
						var OptSelect = "<%= PrinterDefTypeConfig_RS.getInt("OS_PROTOCOLID") %>";
						var OptFileName = "<%= PrinterDefTypeConfig_RS.getString("PROTOCOL_NAME") %>";
						if (OptSelect != 0) {
							autoSelectValue("printerdeftypeid"+"<%=PrinterDefTypeConfig_RS.getString("OS_ABBR")%>",OptSelect);
							drivermenu.addOption({value: '-1', label: '<%= messages.getString("remove_this_protocol") %>...' });
						} //if not 0
			<%	} //while DriverSerConfigView_RS
			} //if DriverSetConfigView_RS > 0 %>
		} //loadAvailableDriverSets
		
		function cancelForm(){
		 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=392";
		} //cancelForm
		
		function callSubmit(event){
		 	var formName = getWidgetID('PrinterDefType');
		 	if (event) { event.preventDefault(); dojo.stopEvent(event); }
		 	formName.submit();
		} //callSubmit
		
		dojo.ready(function() {
			 createpTag();
			 createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '397');
			 createHiddenInput('logactionid','logaction','');
			 createHiddenInput('logactionid','printerdeftypeconfigid','<%= printerdeftypeconfigid %>','');
			 createHiddenInput('logactionid','printerdeftypeid','<%= printerdeftypeid %>','');
			 createHiddenInput('logactionid','serverdeftype','<%= serverdeftype %>');
			 createHiddenInput('logactionid','clientdeftype','<%= clientdeftype %>');
			 createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_printerdef');
	 		 createSpan('submit_add_button','ibm-sep');
		 	 createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_printerdef','cancelForm()');
			 loadPrintDefTypes();
			 createPostForm('PrinterDef','PrinterDefType','PrinterDefType','ibm-column-form','<%= prtgateway %>');
			 changeSelectStyle('200px');
			<% if (!logaction.equals("")){ %>
	        	getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
	        <% } %>
		});
		
		dojo.addOnLoad(function() {
			loadAvailablePrinterDefTypes();
			dojo.connect(getID('PrinterDef'), 'onsubmit', function(event) {
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=392"><%= messages.getString("printer_def_type_admin") %></a></li>
			</ul>
			<h1><%= messages.getString("printer_def_type_config_admin") %></h1>
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
				<li><%= messages.getString("printer_def_type_config_add_info") %></li>
				<li><%= messages.getString("printer_def_type_config_delete_info") %></li>
			</ul>
			<br />
			<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='PrinterDef'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for="model"><%= messages.getString("server_definition") %>:</label>
					<%= serverdeftype %>
				</div>
				<div class="pClass">
					<label for="drvmodel"><%= messages.getString("client_definition") %>:</label>
					<%= clientdeftype %>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em><%= messages.getString("os") %></em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em><%= messages.getString("protocol") %></em>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<%	OSView_RS.first();
					while (OSView_RS.next()) {
				%>
					<div class="pClass">
						<label id="oslabel" for="os">
							<%= OSView_RS.getString("OS_NAME") %>:<span class="ibm-required">*</span>
						</label>
						<span id='printerdeftypeid<%= OSView_RS.getString("OS_ABBR") %>loc'></span>
					</div>
					<div id="pClass"></div>
				<% } //while OSView_RS %> 
				<div class="pClass">
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
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>
<%
	} catch (Exception e) {
			System.out.println("Error in DriverSetConfig.jsp ERROR: " + e);
	} finally {
		ProtocolInfo_RS.close();
		stmtPrinterDefConfig.close();
		con.close();
	}
%>