<%@ include file="metainfo.jsp" %>
<meta name="Keywords" content="Global Print device troubleshooter"/>
<meta name="Description" content="Global print device troubleshooter" />
<title><%= messages.getString("global_print_title") %> | Device TroubleShooter </title>
<%@ include file="metainfo2.jsp" %>

<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>

<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	
<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 //KW Added this function
	 dojo.addOnLoad(function() {
    	dojo.connect(getID('searchbyName in addonLoad'), 'onsubmit', function(event) {
			 	byName(event);
		 });
	 });
	 //KW End
	 
	 
	 //KW Added this function
	  function byName(event) {
	 	var formName = getWidgetID('searchbyName');
	 	var formValid = formName.validate();
	 	dojo.stopEvent(event);
	 	if (formValid) {
 			formName.submit();
		} //if
		else {
			return false;
		}
	 } //byName
	 
	 //KW end
	 
	 	 
	 dojo.ready(function() {
	 	
		createHiddenInput('nametopageid','<%= BehaviorConstants.TOPAGE %>', '621','nametopageid');
		createpTag();
		
		createTextInput('inputloc','device','device','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("search_invalid") %>','^[A-Za-z0-9%]{3,32}$');
	 		 	
	    createSubmitButton('search_button_name','ibm-submit','<%= messages.getString("search") %>','ibm-btn-arrow-pri','submit_search_name');
		createSpan('search_button_name','ibm-sep');
		createInputButton('search_button_name','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
					
		createGetForm('byname','searchbyName','searchbyName','ibm-column-form ibm-styled-form','<%= prtgateway %>');
							
	 });
	 
	 function cancelForm() {
		self.location.href = "<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 }
	 
</script>

</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp"%>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
			</ul>
			<h1>
				<%= messages.getString("device_troubleshooter") %>
			</h1>
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
			<p><%= messages.getString("device_troubleshooter_desc") %>&nbsp;<%= messages.getString("required_info") %>.<br /></p>
			<div id="byname">
				<div id='nametopageid'></div>
				<div class="pClass">
					<label for="text" id="text"><%= messages.getString("device") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="inputloc"></div>
					</span>
				</div>	
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='search_button_name'></div>
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