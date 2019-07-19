<%
	TableQueryBhvr CountryTableView  = (TableQueryBhvr) request.getAttribute("CountryTableView");
	TableQueryBhvrResultSet CountryTableView_RS = CountryTableView.getResults();
	AppTools tool = new AppTools();
	String geo = tool.nullStringConverter(request.getParameter("geo"));
  	String country = tool.nullStringConverter(request.getParameter("country"));
  	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
  	int GeoID = 0;
  	int CountryID = 0;
  	String countryabbr = "";
	CountryTableView_RS.next();
		GeoID	= CountryTableView_RS.getInt("GEOID");
    	CountryID	= CountryTableView_RS.getInt("COUNTRYID");
    	countryabbr	= tool.nullStringConverter(CountryTableView_RS.getString("COUNTRY_ABBR"));
    	country = tool.nullStringConverter(CountryTableView_RS.getString("COUNTRY"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit country"/>
	<meta name="Description" content="Global print website edit country information" />
	<title><%= messages.getString("title") %> | <%= messages.getString("country_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 var found = false;
	 
	 function reqName(wName){
	 	//console.log('wName is ' + wName);
	 	found = false;
	 	var tagName = 'Name';
	 	var dataTag = 'Geography';
	 	var currentID = '<%=CountryID%>';
	 	var geo = "<%= geo %>";
	 	var urlValue = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=country&geo=" + geo;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var tn = response.getElementsByTagName(tagName);
		 		var dt = response.getElementsByTagName(dataTag);
		   		for (var i = 0; i < tn.length; i++) {
		   			var optionName = tn[i].firstChild.data;
		   			var tagID = dt[i].getAttribute("id");
		   			//console.log('optionName is ' + optionName);
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
	 
	 function addCountry(event) {
	 	dojo.byId("errorMsg").innerHTML = "";
	 	var formName = dijit.byId('addCountryForm');
	 	var formValid = formName.validate();
	 	var wName = dijit.byId('country').get('value');
	 	var logaction = dojo.byId('logaction');
	 	reqName(wName);
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 		if (formValid) {
	 			if (!found) {
		 			logaction.value = "Country " + wName + " has been updated";
					formName.submit();
				} else {
					dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'<%= messages.getString("location_already_exists") %>'+"</p>";
					dijit.byId('country').focus();
					return false;
				}
			} //if
			else {
				return false;
			}
	 } //addGeo
	 
	 function cancelForm(){
		var geo = "<%= geo %>";
		var country = "<%= country %>";
	 	var param = "&geo=" + geo + "&country=" + country;
		document.location.href="/tools/print/servlet/prtgateway.wss?to_page_id=261_Select" + param;
	 } //cancelForm
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '176');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','geoid','<%=GeoID%>');
        createHiddenInput('logactionid','geo','<%=geo%>');
        createHiddenInput('logactionid','countryid','<%=CountryID%>');
        createpTag();
        createTextInput('country','country','country','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_country_regexp,'<%= country %>');
        createTextInput('countryabbr','countryabbr','countryabbr','2',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','\\w{0,2}','<%= countryabbr %>');
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_geo');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_geo','cancelForm()');
     	createPostForm('addCountry','addCountryForm','addCountryForm','ibm-column-form','<%= prtgateway %>');
     	dijit.byId('country').focus();
     	var inputButton1 = dojo.byId("submit_add_geo");
     	//var inputButton2 = dojo.byId("cancel_add_geo");
     	var submitButton = { 
     					onClick: function(evt){
     							addCountry(evt);
							} //function
						};
     	dojo.connect(inputButton1, "onclick", submitButton.onClick);
     	//dojo.connect(inputButton2, "onclick", cancelButton.onClick);
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
			<h1><%= messages.getString("country_edit") %></h1>
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
			<div id='addCountry'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='country'><%= messages.getString("country") %>:<span class='ibm-required'>*</span></label>
					<span><div id='country'></div></span>
				</div>
				<div class="pClass">
					<label for='countryabbr'><%= messages.getString("country_abbreviation") %>:<span class='ibm-required'>*</span></label>
					<span><div id='countryabbr'></div></span>
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