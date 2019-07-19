<%
	TableQueryBhvr PrinterDefType  = (TableQueryBhvr) request.getAttribute("PrinterDefType");
	TableQueryBhvrResultSet PrinterDefType_RS = PrinterDefType.getResults();
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
   
   String serverdeftype = "";
   String clientdeftype = "";
   int printerdeftypeid = 0;
   
   while (PrinterDefType_RS.next()) {
   		serverdeftype = PrinterDefType_RS.getString("SERVER_DEF_TYPE");
   		clientdeftype = PrinterDefType_RS.getString("CLIENT_DEF_TYPE");
   		printerdeftypeid = PrinterDefType_RS.getInt("PRINTER_DEF_TYPEID");
   } //while
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit printer definition type"/>
	<meta name="Description" content="Global print website edit a printer definition type page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("printer_def_type_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function addPrinterDefType() {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addPrinterDefTypeForm');
	 	var formValid = formName.validate();
	 	var serverdeftype = dijit.byId('serverdeftype').get('value');
	 	var clientdeftype = dijit.byId('clientdeftype').get('value');
	 	var logaction = dojo.byId('logaction');
	 		if (formValid) {
				logaction.value = "Printer definition type " + serverdeftype+"/"+clientdeftype + " has been updated";
				formName.submit();
			} else {
				return false;
			}
	 } //addServer
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '394');
        createHiddenInput('logactionid','logaction','','logaction');
        createHiddenInput('logactionid','printerdeftypeid','<%= printerdeftypeid %>','printerdeftypeid');
        createpTag();
        createTextInput('serverdeftypeloc','serverdeftype','serverdeftype','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= serverdeftype %>');
        createTextInput('clientdeftypeloc','clientdeftype','clientdeftype','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= clientdeftype %>');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_deftype','addPrinterDefType()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_deftype','cancelForm()');
     	createPostForm('addPrinterDefType','addPrinterDefTypeForm','addPrinterDefTypeForm','ibm-column-form','<%= prtgateway %>');
     	changeInputTagStyle('200px');
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('serverdeftype').focus();
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=392"><%= messages.getString("printer_def_type_select" ) %></a> </li>
			</ul>
			<h1><%= messages.getString("printer_def_type_edit") %></h1>
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
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='addPrinterDefType'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='serverdeftype'><%= messages.getString("server_definition") %>:<span class='ibm-required'>*</span></label>
					<span><div id='serverdeftypeloc'></div></span>
				</div>
				<div class="pClass">
					<label for='clientdeftype'><%= messages.getString("client_definition") %>:<span class='ibm-required'>*</span></label>
					<span><div id='clientdeftypeloc'></div></span>
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