<%
	TableQueryBhvr MiscInfo  = (TableQueryBhvr) request.getAttribute("MiscInfo");
	TableQueryBhvrResultSet MiscInfo_RS = MiscInfo.getResults();
	AppTools appTool = new AppTools();
	MiscInfo_RS.next();
	String geo = appTool.nullStringConverter(MiscInfo_RS.getString("GEO"));
	String country = appTool.nullStringConverter(MiscInfo_RS.getString("COUNTRY"));
	String city = appTool.nullStringConverter(MiscInfo_RS.getString("CITY"));
	String building = appTool.nullStringConverter(MiscInfo_RS.getString("BUILDING_NAME"));
	String floor = appTool.nullStringConverter(MiscInfo_RS.getString("FLOOR_NAME"));
	String divVal = appTool.nullStringConverter(MiscInfo_RS.getString("BILL_DIV"));
	String SDC = appTool.nullStringConverter(MiscInfo_RS.getString("SERVER_SDC"));
	String devicename = appTool.nullStringConverter(MiscInfo_RS.getString("DEVICE_NAME"));
	String room = appTool.nullStringConverter(MiscInfo_RS.getString("ROOM"));
	String state = appTool.nullStringConverter(MiscInfo_RS.getString("STATE"));
	String csVal = appTool.nullStringConverter(MiscInfo_RS.getString("CS"));
	String vmVal = appTool.nullStringConverter(MiscInfo_RS.getString("VM"));
	String mvsVal = appTool.nullStringConverter(MiscInfo_RS.getString("MVS"));
	String sapVal = appTool.nullStringConverter(MiscInfo_RS.getString("SAP"));
	String wtsVal = appTool.nullStringConverter(MiscInfo_RS.getString("WTS"));
	
%>
<%@ include file="GetCurrentDateTime.jsp" %>
<%
	
	String reqnumVal = CurrentMonthLit + CurrentDay + CurrentYear + CurrentHour + CurrentMinute;
	String topageid = appTool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
	String searchName = appTool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	String referer = appTool.nullStringConverter(request.getParameter("referer"));
	
	String sReqDate = "";
	String sJust = "";
	
	sReqDate = appTool.nullStringConverter(request.getParameter("DtReqComp"));
	sJust = appTool.nullStringConverter(request.getParameter("Justification"));

	String laddress = "";
	InetAddress add = null;
	add = InetAddress.getLocalHost();
	laddress=add.getHostAddress();
	keyopTools tool = new keyopTools();
	String sServerName = tool.getServerName();
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print delete printer request"/>
	<meta name="Description" content="Global print website delete a printer request page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("device_delete_req") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLDatabyId.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/formatDate.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dijit.form.DateTextBox");
	 
	 function cancelForm(){
	 	document.location.href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1010";
	 } //cancelForm
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	dijit.showTooltip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function deleteDevice(event) {
	 	var formName = getWidgetID("DeviceForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var justification = getWidgetIDValue('justification').replace(/(\r\n|[\r\n])/g, " ").trim();
        //dijit.byId('justification').set('value',justification);
        setWidgetIDValue('justification',justification);
        var emailLookup = getWidgetID('emailLookup');
        var email = getID('email');
        email.value = emailLookup.get('value');
        if (email.value == ""){
        	alert('<%= messages.getString("email_address") %> <%= messages.getString("is_required") %>');
        	emailLookup.focus();
        	return false;
        }
        formValid = formName.validate();
        if (justification.length > 255) {
			alert("<%= messages.getStringArgs("limit_justification_field_size", new String[] {"255"}) %> " + justification.length);
			getWidgetID('justification').focus();
			return false;
		} else if (justification == "") {
			alert('<%= messages.getString("justification") %> <%= messages.getString("is_required") %>');
			getWidgetID('justification').focus();
			return false;
		}
		if (formValid){
			var datereq = document.getElementsByName('datereq')[0];
			datereq.value = formatDated2M2y4(datereq.value);
			//Get the date in seconds
		 	var d = new Date();
			var n = d.getSeconds();
			n = (n.toString().length == 1) ? '0' + n : n;
			var reqnum = '<%= reqnumVal%>' + n;
			setValue('reqnum', reqnum);
			formName.submit();
			return false;
		} else {
			return false;
		}
	 } //addDevice
	  
	 function showHelp(anchor) {
		onGo('<%= statichtmldir %>/HelpForm.html#' + anchor, 810, 1070);
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
	 
	 function rsgET(response, tagName) {
		var rt = response.getElementsByTagName(tagName)[0].firstChild.data;
		return rt;
	 } //rsgET
	 
	 function lookupEmail(){
	 	getID("response").innerHTML = "";
	 	found = false;
	 	//var email = dijit.byId('emailLookup').get('value');
	 	var email = getWidgetIDValue('emailLookup');
	 	var reqName = getWidgetID('requestername');
	 	var phone = getWidgetID('phone');
	 	//var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10015&query=user&email=" + email;
	 	var urlValue = "<%= statichtmldir %>/servlet/api.wss/user/email/" + email;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var emailAddr = "";
		   		try {
	   				emailAddr = rsgET(response, 'EmailAddress');
		   		} catch (e) {
		   			console.log('no email found' + e);
		   			getID("response").innerHTML = "<p><a class='ibm-error-link'></a>"+"<%= messages.getString("email_not_found") %>"+"<br /></p>";
		   		} //try and catch
	   			//console.log('optionName is ' + optionName);
	   			if (emailAddr != "") {
	   				try {
	   					var username = fixName(rsgET(response, 'FullName'));
	   					setWidgetIDValue(reqName, username);
	   					setWidgetIDValue(phone, rsgET(response, 'Phone'));
	   					getWidgetID('datereq').focus();
			   		} catch (e) {
			   			console.log("error setting values: " + e);
			   			//setWidgetIDValue(reqName, '');
	   					//setWidgetIDValue(phone, '');
	   					getWidgetID('emailLookup').focus();
			   		} //try and catch
	   			}
		   	}, //load function
		   	preventCache: true,
		   	sync: true,
		   	error : function(response, args) {
		   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
		   	} //error function
		});
		return found;
	 } //reqName
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '1300','<%= BehaviorConstants.TOPAGE %>');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','action','DELETE');
        createHiddenInput('logactionid','reqnum','');
        createHiddenInput('logactionid','geo','<%= geo %>');
        createHiddenInput('logactionid','country','<%= country %>');
        createHiddenInput('logactionid','state','<%= state %>');
        createHiddenInput('logactionid','city','<%= city %>');
        createHiddenInput('logactionid','building','<%= building %>');
        createHiddenInput('logactionid','floor','<%= floor %>');
        createHiddenInput('logactionid','room','<%= room %>');
        createHiddenInput('logactionid','status','NEW');
        createHiddenInput('logactionid','devicename','<%= devicename %>');
        createHiddenInput('logactionid','email','');
        createpTag();
        createTextInput('emailLookup','emailLookup','emailLookup','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[^]*$','');
        createTextInput('requestername','requestername','requestername','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_username_regexp,'');
        createTextInput('phone','phone','phone','32',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_phone_number_regexp,'');
        createInputButton('emp_lookup_button','ibm-cancel','<%= messages.getString("emp_lookup") %>','ibm-btn-cancel-sec','submit_email','lookupEmail()');
        createTextArea('justification', 'justification', '', '');
        
        createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_device');
        createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_device','cancelForm()');
     	createPostForm('Device','DeviceForm','DeviceForm','ibm-column-form','<%= commonprocess %>');
     	createGetForm('lookupEmail','lookupEmailForm','lookupEmailForm','ibm-column-form','#');
     	changeInputTagStyle("300px");
     	changeSelectStyle('300px');
     	changeCommentStyle('justification','300px');
     });
     
     dojo.addOnLoad(function() {
		 dojo.connect(getID('lookupEmailForm'), 'onsubmit', function(event) {
		 	lookupEmail(event);
		 });
		 dojo.connect(getID('DeviceForm'), 'onsubmit', function(event) {
		 	deleteDevice(event);
		 });
		 getWidgetID('emailLookup').focus();
	 });
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead.jsp" %>
		<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
					<ul id="ibm-navigation-trail">
						<li><a href="<%= statichtmldir %>/ServiceRequests.html"><%= messages.getString("service_requests") %></a></li>
						<li><a href="<%= statichtmldir %>/MACDel.html"><%= messages.getString("macdel_requests") %></a></li>
						<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1020"><%= messages.getString("device_modify_request") %></a></li>
						<% if (!searchName.equals("")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1025&<%=PrinterConstants.SEARCH_NAME %>=<%= searchName %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } else if (referer.equals("1023")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1023&geo=<%= geo %>&country=<%= country %>&city=<%= city %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } else if (referer.equals("1022")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1022&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } else if (referer.equals("1021")) { %>
							<li><a href="<%= commonprocess %>?<%= BehaviorConstants.TOPAGE %>=1021&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("modify_device_search_results") %></a></li>
						<% } %>
					</ul>
					<h1><%= messages.getString("device_delete_req") %></h1>
				</div>
			</div>
			<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
		<!-- CONTENT_BODY -->
		<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			<p>
				<%= messages.getString("required_info") %>. <%= messages.getString("use_help_icon") %> <a class="ibm-information-link"></a> <%= messages.getString("next_sections_get_help") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id="lookupEmail">
				<div id='copytopageid'></div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<a class="ibm-information-link" href="javascript:showHelp('requester');" ><%= messages.getString("requester_info") %></a>
					</em>
				</div>
				<div id='notfound'></div>
				<div class="pClass">
					<label for='emailLookup'><%= messages.getString("email_address") %>:<span class='ibm-required'>*</span></label>
					<span><div id='emailLookup'></div></span>
				</div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='emp_lookup_button'></div>
					</span>
					</div>
				</div>
			</div>
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='Device'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='requestername'><%= messages.getString("requester_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='requestername'></div></span>
				</div>
				<div class="pClass">
					<label for='phone'><%= messages.getString("phone_number") %>:<span class='ibm-required'>*</span></label>
					<span><div id='phone'></div></span>
				</div>
				<p>
					<label for="datereq"><%= messages.getString("requested_complete_date") %>:<span class="ibm-access ibm-date-format">dd/MM/yyyy</span></label> 
				 	<span><input type="text" class="ibm-date-picker" name="datereq" id="datereq" value="" /> (dd/mm/yyyy)</span>
				</p>
				<div class="pClass">
					<label for='justification'><%= messages.getString("justification_comments") %>:<span class='ibm-required'>*</span></label>
					<span><div id='justification'></div></span>
				</div>
				<div class="pClass">
					<em>
						<h2 class="ibm-rule"><%= messages.getString("device_info") %></h2>
					</em>
				</div>
				<div class="pClass">
					<label for='devicename'><%= messages.getString("device_name") %>:</label>
					<span><%= devicename %></span>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<%= messages.getString("device_location_info") %>
					</em>
				</div>
				<div class="pClass">
					<label id="geolabel" for="geo">
						<%= messages.getString("geography") %>: 
					</label>
					<span>
						<%= geo %>
					</span>
				</div>
				<div class="pClass">
					<label id="countrylabel" for="country">
						<%= messages.getString("country") %>: 
					</label>
					<span>
						<%= country %>
					</span>
				</div>
				<div class="pClass">
					<label id="sitelabel" for="site">
						<%= messages.getString("site") %>: 
					</label>
					<span>
						<%= city %>
					</span>
				</div>
				<div class="pClass">	
					<label id="buildinglabel" for="building">
						<%= messages.getString("building") %>:<span class='ibm-required'>*</span>
					</label>
					<span>
						<%= building %>
					</span>
				</div>
				<div class="pClass">
					<label id="floorlabel" for="floor">
						<%= messages.getString("floor") %>:<span class='ibm-required'>*</span>
					</label>
					<span>
						<%= floor %>
					</span>
				</div>
				<div class="pClass">
					<label for='room'><%= messages.getString("room") %>:<span class='ibm-required'>*</span></label>
					<span>
						<%= room %>
					</span>
				</div>
				<div class="ibm-alternate-rule"><hr /></div>
				<div class="pClass">
					<em>
						<%= messages.getString("enbl_type") %>
					</em>
				</div>
				<div class="pClass">
					<label for='model'><%= messages.getString("client_server") %>:</label>
					<span><%= csVal %></span>
				</div>
				<div class="pClass">
					<label for='model'><%= messages.getString("vm") %>:</label>
					<span><%= vmVal %></span>
				</div>
				<div class="pClass">
					<label for='model'><%= messages.getString("mvs") %>:</label>
					<span><%= mvsVal %></span>
				</div>
				<div class="pClass">
					<label for='model'><%= messages.getString("sap") %>:</label>
					<span><%= sapVal %></span>
				</div>
				<div class="pClass">
					<label for='model'><%= messages.getString("wts") %>:</label>
					<span><%= wtsVal %></span>
				</div>
				<!-- End of entries -->
				<div class='ibm-alternate-rule'><hr /></div>
				<div class='ibm-buttons-row' align="right">
					<div class="pClass">
					<div id='submit_add_button'></div>
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