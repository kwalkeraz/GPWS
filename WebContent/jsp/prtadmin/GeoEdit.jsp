<%
	TableQueryBhvr GeoTableView  = (TableQueryBhvr) request.getAttribute("GeoTableView");
	TableQueryBhvrResultSet GeoTableView_RS = GeoTableView.getResults();
	AppTools tool = new AppTools();
	String geo	= tool.nullStringConverter(request.getParameter("geo"));
	GeoTableView_RS.next();
	int GeoID	= GeoTableView_RS.getInt("GEOID");
	String geoabbr = tool.nullStringConverter(GeoTableView_RS.getString("GEO_ABBR"));
	String emailaddress	= tool.nullStringConverter(GeoTableView_RS.getString("EMAIL_ADDRESS"));
	String ccemailaddress = tool.nullStringConverter(GeoTableView_RS.getString("CCEMAIL_ADDRESS"));
	geo = tool.nullStringConverter(GeoTableView_RS.getString("GEO"));
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));	
%>	
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit geography"/>
	<meta name="Description" content="Global print website edit geography information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("geo_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/updateGeographyInfo.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.ProgressBar");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 var found = false;
	 
	 function reqName(wName){
	 	//console.log('wName is ' + wName);
	 	found = false;
	 	var tagName = 'Name';
	 	var dataTag = 'Geography';
	 	var currentID = '<%=GeoID%>';
	 	var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=geography";
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		 		var dt = response.getElementsByTagName(dataTag);
		   		for (var i = 0; i < tn.length; i++) {
		   			var optionName = tn[i].firstChild.data;
		   			var tagID = dt[i].getAttribute("id");
		   			//console.log('tagID is ' + tagID);
		   			if (optionName == wName && currentID != tagID) {
		   				found = true;
		   				break;
		   			}
		   		} //for loop
		   	}, //load function
		   	preventCache: true,
		   	sync: true,
		   	error : function(response, args) {
		   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
		   	} //error function
		});
		return found;
	 } //reqName
	 
	 function addGeo(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addGeoForm');
	 	var formValid = formName.validate();
	 	var geoName = dijit.byId('geo').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(geoName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "Geography " + geoName + " has been updated";
					formName.submit();
				} else {
					dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("location_already_exists") %>'+"</p>";
					dijit.byId('geo').focus();
					return false;
				}
			} //if
			else {
				return false;
			}
	 } //addGeo
	 
	 function cancelForm(){
	 	var geo = "<%= geo %>";
		var param = "&geo="+geo;
		document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=261_Select" + param;
	 } //cancelForm
	 
	 dojo.ready(function() {
	 	createpTag();
	 	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '166');
     	createHiddenInput('logactionid','geoid','<%= GeoID %>');
        createHiddenInput('logactionid','logaction','');
        createTextInput('geo','geo','geo','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_geo_regexp,'<%= geo %>');
        createTextInput('geoabbr','geoabbr','geoabbr','2',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','\\w{0,2}','<%= geoabbr%>');
        createTextInput('email','email','email','32',false,'','','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$','<%= emailaddress %>');
        createTextInput('ccemail','ccemail','ccemail','32',false,'','','<%= messages.getString("field_problems") %>','^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$','<%= ccemailaddress %>');
 		createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_geo');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_geo','cancelForm()');
     	createPostForm('addGeo','addGeoForm','addGeoForm','ibm-column-form','<%= prtgateway %>');
     	dijit.byId('geo').focus();
     	var inputButton1 = dojo.byId("submit_add_geo");
     	//var inputButton2 = dojo.byId("cancel_add_geo");
     	var submitButton = { 
     					onClick: function(evt){
     							addGeo(evt);
							} //function
						};
     	dojo.connect(inputButton1, "onclick", submitButton.onClick);
     	changeInputTagStyle("250px");
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
				<li><a href="javascript:void(0);" onClick="cancelForm();"><%= messages.getString("location_administration") %></a></li>
			</ul>
			<h1><%= messages.getString("geo_edit") %></h1>
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
			<div id='addGeo'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='geo'><%= messages.getString("geography") %>:<span class='ibm-required'>*</span></label>
					<span><div id='geo'></div></span>
				</div>
				<div class="pClass">
					<label for='abbr'><%= messages.getString("geo_abbr") %>:<span class='ibm-required'>*</span></label>
					<span><div id='geoabbr'></div></span>
				</div>
				<div class="pClass">
					<label for='email'><%= messages.getString("email_address") %>:</label>
					<span><div id='email'></div></span>
				</div>
				<div class="pClass">
					<label for='ccemail'><%= messages.getString("cc_email_address") %>:</label>
					<span><div id='ccemail'></div></span>
				</div>
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
<!-- </div> -->
<%@ include file="bottominfo.jsp" %>