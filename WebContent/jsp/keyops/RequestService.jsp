	<%
	   TableQueryBhvr AdminProblemsView  = (TableQueryBhvr) request.getAttribute("AdminProblemsView");
	   TableQueryBhvrResultSet AdminProblemsView_RS = AdminProblemsView.getResults();
	   
	   TableQueryBhvr SupportedKeyopCountriesView  = (TableQueryBhvr) request.getAttribute("SupportedKeyopCountriesView");
	   TableQueryBhvrResultSet SupportedKeyopCountriesView_RS = SupportedKeyopCountriesView.getResults();
	   
	   String logaction = "";
	   if (request.getParameter("logaction") != null) {
		   logaction = request.getParameter("logaction");
	   }
	   
	   String devicemsg = "";
	   if (request.getParameter("devicemessage") != null) {
		   devicemsg = request.getParameter("devicemessage");
	   }
	   
	   String sEmailAddress = "";
	   		
		if (request.getParameter("email") != null) { 
			if (!request.getParameter("email").equals("not found")) {
				sEmailAddress = request.getParameter("email");
			} else {
				sEmailAddress = request.getParameter("email2");
			}
		}
		
		keyopTools tool = new keyopTools();
	%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print, keyop, request service"/>
	<meta name="Description" content="This page allows a user to request key operator service on a printer." />
	<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_request_form") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 dojo.require("dojox.validate.web");
	 
	 var validCountries = new Array();
	 var submitCount = 0;
	<%
		int x = 0;
		while (SupportedKeyopCountriesView_RS.next()) { %>
			validCountries[<%= x %>] = "<%= SupportedKeyopCountriesView_RS.getString("CATEGORY_VALUE1") %>";
	<%		x++;
		}
	%>
	 
	 function addProblems(dID){
		<%  int y = 0; //counter
			while(AdminProblemsView_RS.next()) { %>
				createCheckBoxList('Problem', '<%= AdminProblemsView_RS.getString("PROBLEM_NAME") %>', '<%= AdminProblemsView_RS.getString("PROBLEM_NAME") %>', false, dID, 'Problem<%= y %>');
   		<% 		y++;
   			} //while %>
	 } //addProblems
	 
	 function onChangeCall(wName){
		return this;
	 } //onChangeCall
	 
	 function cancelForm() {
		self.location.href = "<%= statichtmldir %>/USKeyOperatorServices.html";
	 } //cancelForm
	 
	 function validateFormEmployee() {
 	 	var email = getWidgetIDValue('email');
 	   	if (email == "") {
				dojo.byId("emailnotfound").innerHTML = '<a title="Error link" href="#" id="emailReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
				dojo.addClass("emaillabel","ibm-error");
	 		return false;
		} else {
			getUserInfo();
		}
     }//ValidateFormEmployee
   	
   	function DeviceSearchByLoc() {
		var link = '<%= keyops %>?next_page_id=2007';
		onGo(link,500,650);
	}//DeviceSearchByLoc
	
	function onGo(link,h,w) {
		var chasm = screen.availWidth;
		var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + ',scrollbars=yes,resizable=yes';	
		args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		w = window.open(link,'_blank',args);
		return false;
	}//onGo
	
	function rsgET(response, tagName) {
		var rt = response.getElementsByTagName(tagName)[0].firstChild.data;
		return rt;
	} //rsgET
		 
	 function getUserInfo(){
		dojo.removeClass("emailnotfound","ibm-error");
		getID("emailnotfound").innerHTML = '&nbsp;<%= messages.getString("looking_up_employee_please_wait") %>';
	 	found = false;
	 	var email = getWidgetIDValue('email');
	 	var reqName = getWidgetID('nameid');
	 	var phone = getWidgetID('phoneid');
	 	var tieline = getWidgetID('tieid');
	 	var tl = "";
	 	var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10015&query=user&email=" + email;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		var emailAddr = "";
		   		try {
	   				emailAddr = rsgET(response, 'EmailAddress');
		   		} catch (e) {
		   			console.log('no email found - ' + e);
		   			dojo.addClass("emailnotfound","ibm-error");
		   			getID("emailnotfound").innerHTML = "<a class='ibm-error-link'></a>"+"<%= messages.getString("email_not_found") %>"+"<br />";
		   		} //try and catch
	   			if (emailAddr != "") {
	   				try {
	   					var username = fixName(rsgET(response, 'FullName'));
	   					setWidgetIDValue(reqName, username);
	   					setWidgetIDValue(phone, rsgET(response, 'Phone'));
	   					try {
	   						tl = rsgET(response, 'TieLine');
	   						setWidgetIDValue(tieline, tl);
	   					} catch (e) {
	   						setWidgetIDValue(tieline, '');
	   					}
	   					clearMessages('emailnotfound','emaillabel');
	   					clearMessages('nameReq','namelabel');
	   					clearMessages('phoneReq','phonelabel');
	   				 	
			   		} catch (e) {
			   			console.log("error setting values: " + e);
			   			setWidgetIDValue(reqName, '');
	   					setWidgetIDValue(phone, '');
	   					getWidgetID('email').focus();
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
	 } //getUserInfo
	 
	function validateFormPrinter() {
		var devicename = getWidgetIDValue('devicename');
	   	if (devicename == "") {
	 		dojo.byId("devicemessage").innerHTML = '<a title="Error link" href="#" id="devicemessage" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %><br /><br />';
			dojo.addClass("devicelabel","ibm-error");
	 		return false;
		} else {
			getDeviceInfo();
		}
	} //validateFormPrinter
	 
	 function getDeviceInfo(){
		dojo.removeClass("devicemessage","ibm-error");
	 	getID("devicemessage").innerHTML = '&nbsp;<%= messages.getString("looking_up_device_please_wait") %><br /><br />';
	 	found = false;
	 	var devicename = getWidgetIDValue('devicename');
	 	var site = getWidgetID('site');
	 	var building = getWidgetID('building');
	 	var floor = getWidgetID('floor');
	 	var room = getWidgetID('room');
	 	var igskeyop = "";
	 	var devicevalue = "";
	 	var countryvalue = "";
	 	var sitevalue = "";
	 	var buildingvalue = "";
	 	var floorvalue = "";
	 	var roomvalue = "";
	 	var urlValue = "<%= printeruser %>?<%= BehaviorConstants.TOPAGE %>=10000&query=device&device=" + devicename;
		dojo.xhrGet({
		   	url : urlValue,
		   	handleAs : "xml",
		 	load : function(response, args) {
		 		try {
	   				devicevalue = rsgET(response, 'DeviceName');
	   				igskeyop = rsgET(response, 'IGSKeyop');
	   				floorvalue = rsgET(response, 'Floor');
	   				countryvalue = rsgET(response, 'Country');
	   				sitevalue = rsgET(response, 'City');
	   				buildingvalue = rsgET(response, 'Building');
	   				roomvalue = rsgET(response, 'Room');
	   				e2ecat = rsgET(response, 'E2ECategory');
		   		} catch (e) {
		   			console.log('no device found - ' + e);
		   			dojo.addClass("devicemessage","ibm-error");
		   			getID("devicemessage").innerHTML = "<a class='ibm-error-link'></a>"+ devicename + " <%= messages.getString("not_found_in_gpws") %>"+"<br /><br />";
		   		} //try and catch
	   			if (devicevalue == "") {
	   				dojo.addClass("devicemessage","ibm-error");
					getID("devicemessage").innerHTML = '<a class="ibm-error-link"></a>&nbsp;' + devicename + '&nbsp;<%= messages.getString("not_found_in_gpws") %><br /><br />';
	   			} else if (e2ecat == 'ECPrint') {
 	   				window.location = "<%= statichtmldir %>/VendorKeyopRequest.html?devicename=" + devicevalue;
				} else if (igskeyop.toUpperCase() == "N" || !isValidCountry(countryvalue)) {
					dojo.addClass("devicemessage","ibm-error");
					getID("devicemessage").innerHTML = '<a class="ibm-error-link"></a>&nbsp;' + devicevalue + '&nbsp;<%= messages.getString("not_supported") %><br /><br />';
				} else {
	   				try {
	   					setWidgetIDValue(floor, floorvalue);
	   					floor.set('readOnly',true);
	   					setWidgetIDValue(building, buildingvalue);
	   					building.set('readOnly',true);
	   					setWidgetIDValue(site, sitevalue);
	   					site.set('readOnly',true);
	   					setWidgetIDValue(room, roomvalue);
	   					room.set('readOnly',true);
	   					
	   					clearMessages('devicemessage','devicelabel');
	   					clearMessages('siteReq','sitelabel');
	   					clearMessages('bldReq','bldlabel');
	   				 	clearMessages('floorReq','floorlabel');
	   				 	clearMessages('roomReq','roomlabel');

	   					
			   		} catch (e) {
			   			console.log("error setting values: " + e);
			   			setWidgetIDValue(floor, '');
	   					setWidgetIDValue(building, '');
	   					setWidgetIDValue(site, '');
	   					setWidgetIDValue(room, '');
	   					countryvalue = "";
	   					getWidgetID('devicename').focus();
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
	 } //getDeviceInfo
	
	function isValidCountry(country) {
		for (var x=0; x < validCountries.length; x++) {
			if (validCountries[x] == country) {
				return true;
			}
		}
		return false;
	} //isValidCountry
	
	function isCBoxChecked() {
		var isChecked = false;
		<%	AdminProblemsView_RS.first();
			if (AdminProblemsView_RS.getResultSetSize() > 0 ) {
				int z = 0;
				while(AdminProblemsView_RS.next()) { %>
					if(getWidgetID('Problem<%= z %>').checked) {
						isChecked = true;
				 	}  //if checked
		<%			z++;
				} //while 
			}  //if%>
		if (isChecked) return true;
      	else return false;
	}//isCBoxChecked
	
	function validateCCEmail() {
		var email = getWidgetIDValue('ccemail');
		var curr = 0;
		var last = 0;

		for (i = 0; i < email.length; i++) {
			if(email.charAt(i) == (';') || email.charAt(i) == (',')) {
				if (email.substring(last,curr).length > 6 && email.substring(last,curr).indexOf('@') > 0) {
					if (!validateEmail(email.substring(last,curr).trim())) {
						break;
					}
				}
				last = curr + 1;
				curr++;
			} else if (i == (email.length-1)) {
				if (!validateEmail(email.substring(last,curr+1).trim())) {
					break;
				}
			} else {
				curr++;
			}
		}
		return true;
	}
	
	function validateEmail(email) {
		var isValid = dojox.validate.isEmailAddress(email);
		if (!isValid) {
			dojo.addClass("ccemailresp","ibm-error");
			dojo.byId("ccemailresp").innerHTML = '<a class="ibm-error-link"></a><%= messages.getString("invalid_email_list") %>';
			return false;
		} else {
			dojo.byId("ccemailresp").innerHTML = "";
			return true;	
		}
	}//validateCCEmail
	
	function validateAllFields() {
		var returnValue = true;
		
		if (!validateCCEmail()) {
			dojo.byId("ccemail").focus();
			returnValue = false;
     	}
		if (!isCBoxChecked()) {
			dojo.addClass("problabel","ibm-error");
			dojo.byId("probReq").innerHTML = '&nbsp;&nbsp;<a title="Error link" href="#" id="probReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			document.getElementById("probReq").focus();
			returnValue = false;
        }
		if (getWidgetID('room').validate() == false) {
			dojo.byId("roomReq").innerHTML = '<a title="Error link" href="#" id="roomReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("roomlabel","ibm-error");
			dojo.byId("room").focus();
			returnValue = false;
		}
		if (getWidgetID('floor').validate() == false) {
			dojo.byId("floorReq").innerHTML = '<a title="Error link" href="#" id="floorReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("floorlabel","ibm-error");
			dojo.byId("floor").focus();
			returnValue = false;
		}
		if (getWidgetID('building').validate() == false) {
			dojo.byId("bldReq").innerHTML = '<a title="Error link" href="#" id="bldReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("bldlabel","ibm-error");
			dojo.byId("building").focus();
			returnValue = false;
		}
		if (getWidgetID('site').validate() == false) {
			dojo.byId("siteReq").innerHTML = '<a title="Error link" href="#" id="siteReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("sitelabel","ibm-error");
			dojo.byId("site").focus();
			returnValue = false;
		}
		if (getWidgetID('devicename').validate() == false) {
			dojo.byId("devicemessage").innerHTML = '<a title="Error link" href="#" id="devicemessage" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %><br /><br />';
			dojo.addClass("devicelabel","ibm-error");
			dojo.byId("devicename").focus();
			returnValue = false;
		}
		if (getWidgetID('phoneid').validate() == false) {
			dojo.byId("phoneReq").innerHTML = '<a title="Error link" href="#" id="phoneReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("phonelabel","ibm-error");
			dojo.byId("phoneid").focus();
			returnValue = false;
		}
		if (getWidgetID('nameid').validate() == false) {
			dojo.byId("nameReq").innerHTML = '<a title="Error link" href="#" id="nameReq" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("namelabel","ibm-error");
			dojo.byId("nameid").focus();
			returnValue = false;
		}
		if (getWidgetID('email').validate() == false) {
			dojo.byId("emailnotfound").innerHTML = '<a title="Error link" href="#" id="emailnotfound" class="ibm-error-link"></a><%= messages.getString("this_is_required_field") %>';
			dojo.addClass("emaillabel","ibm-error");
			dojo.byId("email").focus();
			returnValue = false;
		}
		
		return returnValue;
	}
	
	function validateFormSubmit(event) {
	 	getID("errorMsg").innerHTML = "";
	 	var formName = getWidgetID('theForm');
	 	//var formValid = formName.validate();
	 	var wName = getWidgetIDValue('devicename');
	 	var logaction = getID('logaction');
	 	event.preventDefault();
	 	dojo.stopEvent(event);
	 	var isFormValid = validateAllFields();
 		if (isFormValid) {
			formName.submit();
		} else {
			return false;
		}
	 } //validateFormSubmit
	 
	 function showReqMsg(reqMsg, tooltipID){
		var tooltip = getID(tooltipID);
		showTTip(reqMsg, tooltip);
	 } //showReqMsg
	 
	 function clearMessages(reqID,reqLabel) {
		 if (reqID == 'devicemessage') {
		 	dojo.byId(reqID).innerHTML = "<br /><br />";
		 } else {
			 dojo.byId(reqID).innerHTML = "";
		 }
		 dojo.removeClass(reqLabel,"ibm-error");
	 }
	 
	 function fixDivAlignment() {
		 dojo.byId("email").style = "float: left";
		 dojo.byId("nameid").style = "float: left";
		 dojo.byId("phoneid").style = "float: left";
		 dojo.byId("devicename").style = "float: left";
		 dojo.byId("site").style = "float: left";
		 dojo.byId("building").style = "float: left";
		 dojo.byId("floor").style = "float: left";
		 dojo.byId("room").style = "float: left";
	 }
	 
	 function checkDevice() {
		 var devicename = getWidgetIDValue('devicename');
		 if (devicename != null && devicename != '') {
			 getDeviceInfo();
		 }
	 }
	 	 
	 dojo.ready(function() {
	 	createpTag();
	 	createHiddenInput('logactionid','logaction','');
     	createHiddenInput('nextpageid','next_page_id','2006');
     	createHiddenInput('submitvalue','submitvalue', 'submitform');
		createHiddenInput('prtstatus','prtstatus', '<% if(request.getAttribute("prtstatus") != null) { out.print(request.getAttribute("prtstatus")); } %>');
		createHiddenInput('numproblemchoices','printerproblems','<%= tool.getNumProbChoices() %>');
		createTextInput('email','email','email','50',true,'','','<%= messages.getString("field_problems") %>',g_email_regexp,'','width: 180px; float: left; display: inline-block;');
		createTextInput('nameid','nameid','nameid','50',true,'','','<%= messages.getString("field_problems") %>',g_username_regexp,'<% if(request.getParameter("nameid") != null) {out.print(tool.cleanName((String)request.getParameter("nameid")));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('phoneid','phoneid','phoneid','50',true,'','','<%= messages.getString("field_problems") %>',g_phone_number_regexp,'<% if(request.getParameter("phoneid") != null) {out.print(request.getParameter("phoneid"));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('tieid','tieid','tieid','50',false,'','','<%= messages.getString("field_problems") %>',g_tieline_regexp,'<% if(request.getParameter("tieid") != null) {out.print(request.getParameter("tieid"));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('devicename','devicename','devicename','50',true,'','','<%= messages.getString("field_problems") %>',g_device_regexp,'<% if(request.getParameter("devicename") != null) { if (!request.getParameter("devicename").equals("not found") && !request.getParameter("devicename").equals("not supported") ) {out.print(request.getParameter("devicename"));} else { out.print(request.getParameter("devicename2"));} } %>','width: 180px; float: left; display: inline-block;');
		createTextInput('site','site','site','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_city_regexp,'<% if(request.getParameter("site") != null) {out.print(request.getParameter("site"));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('building','building','building','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_building_regexp,'<% if(request.getParameter("building") != null) {out.print(request.getParameter("building"));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('floor','floor','floor','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_loc_floor_regexp,'<% if(request.getParameter("floor") != null) {out.print(request.getParameter("floor"));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('room','room','room','50',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_room_regexp,'<% if(request.getParameter("room") != null) {out.print(request.getParameter("room"));} %>','width: 180px; float: left; display: inline-block;');
		createTextInput('ccemail','ccemail','ccemail','64',false,'','','<%= messages.getString("field_problems") %>',g_emailList_regexp,'','width: 180px; float: left; display: inline-block;');
		createTextArea('description','description','description','<% if(request.getParameter("description") != null) {out.print(request.getParameter("description"));} %>');
		dojo.byId("description").maxLength = "512";
 		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		addProblems('problems');
		createInputButton('submit_employee_button','ibm-submit','<%= messages.getString("emp_lookup") %>','ibm-btn-arrow-sec','employee_lookup','validateFormEmployee()');
 		createInputButton('submit_device_button','ibm-submit','<%= messages.getString("device_lookup") %>','ibm-btn-arrow-sec','device_lookup','validateFormPrinter()');
 		createSubmitButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_request');
		createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
		
		fixDivAlignment();
		checkDevice();
     });
     
     dojo.addOnLoad(function() {
		// Add character counter on description field.
		dojo.connect(getID("description"),"onkeypress", function() {
			getID("descChars").innerHTML = "<p>"+ (512 - getID("description").value.length)+"&nbsp;<%= messages.getString("characters_left") %></p>";
		});
		dojo.connect(getID('theForm'), 'onsubmit', function(event) {
		 	validateFormSubmit(event);
		});
		dojo.connect(getID('email'), 'onchange', function(event) {
		 	clearMessages('emailnotfound','emaillabel');
		});
		dojo.connect(getID('nameid'), 'onchange', function(event) {
		 	clearMessages('nameReq','namelabel');
		});
		dojo.connect(getID('phoneid'), 'onchange', function(event) {
		 	clearMessages('phoneReq','phonelabel');
		});
		dojo.connect(getID('devicename'), 'onchange', function(event) {
		 	clearMessages('devicemessage','devicelabel');
		});
		dojo.connect(getID('site'), 'onchange', function(event) {
		 	clearMessages('siteReq','sitelabel');
		});
		dojo.connect(getID('building'), 'onchange', function(event) {
		 	clearMessages('bldReq','bldlabel');
		});
		dojo.connect(getID('floor'), 'onchange', function(event) {
		 	clearMessages('floorReq','floorlabel');
		});
		dojo.connect(getID('room'), 'onchange', function(event) {
		 	clearMessages('roomReq','roomlabel');
		});
		dojo.connect(getID('nameid'), 'onchange', function(event) {
		 	clearMessages('nameReq','namelabel');
		});
		dojo.connect(getID('Problem'), 'onchange', function(event) {
			if (isCBoxChecked() == true) {
		 		clearMessages('probReq','problabel');
			}
		});
		
		dojo.connect(getID('ccemail'), 'onchange', function(event) {
			if (!validateCCEmail()) {
		 		clearMessages('emailnotfound','emaillabel');
			}
		});
		
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
				<li><a href="<%= statichtmldir %>/USKeyOperatorServices.html"> <%= messages.getString("us_keyop_services") %></a></li>
			</ul>
			<h1><%= messages.getString("keyop_request_form") %></h1>
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
			<p><%= messages.getString("keyop_request_form_description") %>  <%= messages.getString("please_enter_all_required_fields") %></p>
			<p class="note"><b><%= messages.getString("note") %>:</b> <%= messages.getString("keyop_request_form_note") %></p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='Keyop'>
				<div id='logactionid'></div>
				<div id="nextpageid"></div>
				<div id="submitvalue"></div>
				<div id="prtstatus"></div>
				<div id="numproblemchoices"></div>
				
				<h2 class="ibm-rule"><%= messages.getString("user_info") %>:</h2>
				<div class="pClass">
					<label id="emaillabel" for="email"><%= messages.getString("email") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="email"></div><span class="ibm-error" id="emailnotfound"><br /><br /></span>
					</span>
				</div>
				<div class="pClass">
					<span><div id="submit_employee_button"></div></span>
				</div>
				<div class="pClass">
					<label id="namelabel" for="nameid"><%= messages.getString("name") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="nameid"></div>
						<span class="ibm-error" id="nameReq"></span>
					</span>
				</div>
				<div class="pClass">
					<label id="phonelabel" for="phoneid"><%= messages.getString("phone") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="phoneid"></div>
						<span class="ibm-error" id="phoneReq"></span>
					</span>
				</div>
				<div class="pClass">
					<label id="tielabel" for="tieid"><%= messages.getString("tieline") %>:</label>
					<span><div id="tieid"></div></span>
				</div>
				
				<h2 class="ibm-alternate-rule"><span class="sub-title"><%= messages.getString("device_info") %>:</span></h2>
				<div class="pClass">
					<label id="devicelabel" for="devicename"><%= messages.getString("device_name") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="devicename"></div>
						<span class="ibm-error" id="devicemessage"><br /><br /></span> 
						
						<a class="ibm-popup-link" href="javascript:DeviceSearchByLoc();"><%= messages.getString("dont_know_device_name") %></a>
					</span>
					
				</div>
				<div class="pClass">
					<span><div id="submit_device_button"></div></span>
				</div>
				<div class="pClass">
					<label id="sitelabel" for="site"><%= messages.getString("site") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="site"></div>
						<span class="ibm-error" id="siteReq"></span>
					</span>
				</div>
				<div class="pClass">
					<label id="bldlabel" for="building"><%= messages.getString("building") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="building"></div>
						<span class="ibm-error" id="bldReq"></span>
					</span>
				</div>
				<div class="pClass">
					<label id="floorlabel" for="floor"><%= messages.getString("floor") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="floor"></div>
						<span class="ibm-error" id="floorReq"></span>
					</span>
				</div>
				<div class="pClass">
					<label id="roomlabel" for="room"><%= messages.getString("room") %>:<span class="ibm-required">*</span></label>
					<span>
						<div id="room"></div>
						<span class="ibm-error" id="roomReq"></span>
					</span>
				</div>
				
				<h2 id="problabel" class="ibm-alternate-rule"><span class="sub-title"><%= messages.getString("device_problems") %>:</span><span class="ibm-required">*</span><span id="probReq"></span></h2>
				
				<div class="pClass">
					<span class="ibm-input-group"><div id='problems'></div></span>
				</div>
				
				<div class="pClass">
					<label for="ccemail"><%= messages.getString("additional_notify") %>:</label>
					<span>
						<div id="ccemail"></div>
						<div id="ccemailresp"></div>
					</span>
				</div>
				<div class="pClass">
					<label for='description'><%= messages.getString("description") %>:</label>
					<span><div id='description'></div></span>
					<span><div id="descChars">512&nbsp;<%= messages.getString("characters_left") %></div></span>
				</div>
				
				<div class='ibm-alternate-rule'><hr /></div>
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