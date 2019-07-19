<%   
	// THIS IS WHERE WE LOAD ALL THE BEANS
	com.ibm.aurora.bhvr.TableQueryBhvr TicketInfoUserView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketInfoUserView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketInfoUserView_RS = TicketInfoUserView.getResults();
   
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
   
	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	String sUserTimeZone = pupb.getTimeZone();
	int iTicketNo = 0;
	String sTicketNo = "";
	String sStatus = "";
	
	String sCustomerContacted = "";
	String sCustomerContactedYear = "";
	String sCustomerContactedMonth = "";
	String sCustomerContactedDay = "";
	String sCustomerContactedHour = "";
	String sCustomerContactedMinute = "";

	String sKeyopTimeStart = "";
	String sKeyopTimeStartYear = "";
	String sKeyopTimeStartMonth = "";
	String sKeyopTimeStartDay = "";
	String sKeyopTimeStartHour = "";
	String sKeyopTimeStartMinute = "";
	
	String sKeyopTimeFinish = "";
	String sKeyopTimeFinishYear = "";
	String sKeyopTimeFinishMonth = "";
	String sKeyopTimeFinishDay = "";
	String sKeyopTimeFinishHour = "";
	String sKeyopTimeFinishMinute = "";
	
	String sTimeSubmitted = "";
	int iTimeSubmittedYear = 0;
	int iTimeSubmittedMonth = 0;
	int iTimeSubmittedDay = 0;
	int iTimeSubmittedHour = 0;
	int iTimeSubmittedMinute = 0;
	
	String sTimeSubmittedYear = "";
	String sTimeSubmittedMonth = "";
	String sTimeSubmittedDay = "";
	String sTimeSubmittedHour = "";
	String sTimeSubmittedMinute = "";
	
	String sCurrentTime = dateTime.convertToTimeZone(dateTime.getServerTimestamp(), "SERVER", sUserTimeZone);
	
	//String sCurrentTime = dateTime.timeStampToString(dateTime.getServerTimestamp());
	int iCurrentTimeYear = dateTime.getStringTimeStampValues(sCurrentTime, "year");
	int iCurrentTimeMonth = dateTime.getStringTimeStampValues(sCurrentTime, "month");
	int iCurrentTimeDay = dateTime.getStringTimeStampValues(sCurrentTime, "day");
	int iCurrentTimeHour = dateTime.getStringTimeStampValues(sCurrentTime, "hour");
	int iCurrentTimeMinute = dateTime.getStringTimeStampValues(sCurrentTime, "minute");
	
	String sCurrentTimeYear = iCurrentTimeYear + "";
	String sCurrentTimeMonth = dateTime.addLeadingZero(iCurrentTimeMonth + "");
	String sCurrentTimeDay = dateTime.addLeadingZero(iCurrentTimeDay + "");
	String sCurrentTimeHour = dateTime.addLeadingZero(iCurrentTimeHour + "");
	String sCurrentTimeMinute = dateTime.addLeadingZero(iCurrentTimeMinute + "");
	
	int iTimesSetCode = 0;
	String sCEReferralNum = "";
	String sHDReferralNum = "";
	
	String sCERefNumDate = "";
	String sCERefNumDateYear = "";
	String sCERefNumDateMonth = "";
	String sCERefNumDateDay = "";
	String sCERefNumDateHour = "";
	String sCERefNumDateMinute = "";
	
	String sHDRefNumDate = "";
	String sHDRefNumDateYear = "";
	String sHDRefNumDateMonth = "";
	String sHDRefNumDateDay = "";
	String sHDRefNumDateHour = "";
	String sHDRefNumDateMinute = "";
	
	while(TicketInfoUserView_RS.next()) {
		iTicketNo = TicketInfoUserView_RS.getInt("KEYOP_REQUESTID");
		sStatus = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQ_STATUS"));
		sTimeSubmitted = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("TIME_SUBMITTED"));
		sCustomerContacted = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("CUSTOMER_CONTACTED"));
		sKeyopTimeStart = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_START"));
		sKeyopTimeFinish = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_FINISH"));
		sCEReferralNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CE_REFERRAL_NUM"));
		sHDReferralNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("HD_REFERRAL_NUM"));
		sCERefNumDate = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("CE_REFERRAL_DATE"));
		sHDRefNumDate = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("HD_REFERRAL_DATE"));
	}
	

	if (!sTimeSubmitted.equals("") && sTimeSubmitted != null && !sTimeSubmitted.equals("null")) {
		sTimeSubmitted = dateTime.convertTimeZoneFromUTC(sTimeSubmitted, sUserTimeZone);
		iTimeSubmittedYear = dateTime.getStringTimeStampValues(sTimeSubmitted, "year");
		iTimeSubmittedMonth = dateTime.getStringTimeStampValues(sTimeSubmitted, "month");
		iTimeSubmittedDay = dateTime.getStringTimeStampValues(sTimeSubmitted, "day");
		iTimeSubmittedHour = dateTime.getStringTimeStampValues(sTimeSubmitted, "hour");
		iTimeSubmittedMinute = dateTime.getStringTimeStampValues(sTimeSubmitted, "minute");
		
		sTimeSubmittedYear = iTimeSubmittedYear + "";
		sTimeSubmittedMonth = dateTime.addLeadingZero(iTimeSubmittedMonth + "");
		sTimeSubmittedDay = dateTime.addLeadingZero(iTimeSubmittedDay + "");
		sTimeSubmittedHour = dateTime.addLeadingZero(iTimeSubmittedHour + "");
		sTimeSubmittedMinute = dateTime.addLeadingZero(iTimeSubmittedMinute + "");
				
		sTimeSubmitted = dateTime.formatTime(sTimeSubmitted);
	}
	
	if (!sCustomerContacted.equals("") && sCustomerContacted != null && !sCustomerContacted.equals("null")) {
		sCustomerContacted = dateTime.convertTimeZoneFromUTC(sCustomerContacted, sUserTimeZone);
		sCustomerContactedYear = dateTime.getStringTimeStampValues(sCustomerContacted, "year") + "";
		sCustomerContactedMonth = dateTime.getStringTimeStampValues(sCustomerContacted, "month") + "";
		sCustomerContactedDay = dateTime.getStringTimeStampValues(sCustomerContacted, "day") + "";
		sCustomerContactedHour = dateTime.addLeadingZero(dateTime.getStringTimeStampValues(sCustomerContacted, "hour") + "");
		sCustomerContactedMinute = dateTime.addLeadingZero(dateTime.getStringTimeStampValues(sCustomerContacted, "minute") + "");
	} else {
		iTimesSetCode += 4;
		sCustomerContactedYear = iCurrentTimeYear + "";
		sCustomerContactedMonth = iCurrentTimeMonth + "";
	}
	if (!sKeyopTimeStart.equals("") && sKeyopTimeStart != null && !sKeyopTimeStart.equals("null")) {
		sKeyopTimeStart = dateTime.convertTimeZoneFromUTC(sKeyopTimeStart, sUserTimeZone);
		sKeyopTimeStartYear = dateTime.getStringTimeStampValues(sKeyopTimeStart, "year") + "";
		sKeyopTimeStartMonth = dateTime.getStringTimeStampValues(sKeyopTimeStart, "month") + "";
		sKeyopTimeStartDay = dateTime.getStringTimeStampValues(sKeyopTimeStart, "day") + "";
		sKeyopTimeStartHour = dateTime.getStringTimeStampValues(sKeyopTimeStart, "hour") + "";
		sKeyopTimeStartMinute = dateTime.getStringTimeStampValues(sKeyopTimeStart, "minute") + "";
	} else {
		iTimesSetCode += 2;
		sKeyopTimeStartYear = iCurrentTimeYear + "";
		sKeyopTimeStartMonth = iCurrentTimeMonth + "";
	}
	if (!sKeyopTimeFinish.equals("") && sKeyopTimeFinish != null && !sKeyopTimeFinish.equals("null")) {
		sKeyopTimeFinish = dateTime.convertTimeZoneFromUTC(sKeyopTimeFinish, sUserTimeZone);
		sKeyopTimeFinishYear = dateTime.getStringTimeStampValues(sKeyopTimeFinish, "year") + "";
		sKeyopTimeFinishMonth = dateTime.getStringTimeStampValues(sKeyopTimeFinish, "month") + "";
		sKeyopTimeFinishDay = dateTime.getStringTimeStampValues(sKeyopTimeFinish, "day") + "";
		sKeyopTimeFinishHour = dateTime.getStringTimeStampValues(sKeyopTimeFinish, "hour") + "";
		sKeyopTimeFinishMinute = dateTime.getStringTimeStampValues(sKeyopTimeFinish, "minute") + "";
	} else {
		iTimesSetCode += 1;
		sKeyopTimeFinishYear = iCurrentTimeYear + "";
		sKeyopTimeFinishMonth = iCurrentTimeMonth + "";
	}
	if (!sCERefNumDate.equals("") && sCERefNumDate != null && !sCERefNumDate.equals("null")) {
		sCERefNumDate = dateTime.convertTimeZoneFromUTC(sCERefNumDate, sUserTimeZone);
		sCERefNumDateYear = dateTime.getStringTimeStampValues(sCERefNumDate, "year") + "";
		sCERefNumDateMonth = dateTime.getStringTimeStampValues(sCERefNumDate, "month") + "";
		sCERefNumDateDay = dateTime.getStringTimeStampValues(sCERefNumDate, "day") + "";
		sCERefNumDateHour = dateTime.getStringTimeStampValues(sCERefNumDate, "hour") + "";
		sCERefNumDateMinute = dateTime.getStringTimeStampValues(sCERefNumDate, "minute") + "";
	} else {
		iTimesSetCode += 1;
		sCERefNumDateYear = iCurrentTimeYear + "";
		sCERefNumDateMonth = iCurrentTimeMonth + "";
	}
	if (!sHDRefNumDate.equals("") && sHDRefNumDate != null && !sHDRefNumDate.equals("null")) {
		sHDRefNumDate = dateTime.convertTimeZoneFromUTC(sHDRefNumDate, sUserTimeZone);

		sHDRefNumDateYear = dateTime.getStringTimeStampValues(sHDRefNumDate, "year") + "";
		sHDRefNumDateMonth = dateTime.getStringTimeStampValues(sHDRefNumDate, "month") + "";
		sHDRefNumDateDay = dateTime.getStringTimeStampValues(sHDRefNumDate, "day") + "";
		sHDRefNumDateHour = dateTime.getStringTimeStampValues(sHDRefNumDate, "hour") + "";
		sHDRefNumDateMinute = dateTime.getStringTimeStampValues(sHDRefNumDate, "minute") + "";
	} else {
		iTimesSetCode += 1;
		sHDRefNumDateYear = iCurrentTimeYear + "";
		sHDRefNumDateMonth = iCurrentTimeMonth + "";
	}
	
	sTicketNo = iTicketNo + "";	
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, ticket update times"/>
<meta name="Description" content="This page allows a keyop to update the times and referral numbers for a ticket." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("update_time_ref") %></title>
<%@ include file="metainfo2.jsp") %>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/formatDate.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createXHR.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/verifyReadyState.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.TimeTextBox");

var relation = "";
var dayOfWeek = "";
var sTS = "<%= sTimeSubmittedYear %>-<%= sTimeSubmittedMonth %>-<%= sTimeSubmittedDay %>-<%= sTimeSubmittedHour %>-<%= sTimeSubmittedMinute %>";
var sCT = "<%= sCurrentTimeYear %>-<%= sCurrentTimeMonth %>-<%= sCurrentTimeDay %>-<%= sCurrentTimeHour %>-<%= sCurrentTimeMinute %>";
var onMO = false;


	dojo.ready(function() {
 		createHiddenInput('nextpageid','next_page_id','2047');
 		createHiddenInput('ticketno','ticketno','<%= iTicketNo %>','');
 		createHiddenInput('submitvalue','submitvalue','','');
 		createHiddenInput('logactionid','logaction','');
		
		createpTag();
 		
 		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','updateTimes()');
		createSpan('submit_add_button','ibm-sep');
 		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
 		
 		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
 			
 		<% if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
 		<% } %>
 		
	});
	
	dojo.addOnLoad(function() {
		// Set constraints on date fields
		dojo.connect("onmouseover", function() {
			try {
					dijit.byId('cusContDate').constraints.min = new Date('<%= sTimeSubmittedYear %>-<%= sTimeSubmittedMonth %>-<%= sTimeSubmittedDay %>');
		         	dijit.byId('cusContDate').constraints.max = new Date();
		         
		         	dijit.byId('workStartDate').constraints.min = new Date('<%= sTimeSubmittedYear %>-<%= sTimeSubmittedMonth %>-<%= sTimeSubmittedDay %>');
		         	dijit.byId('workStartDate').constraints.max = new Date();
		         
		         	dijit.byId('workCompDate').constraints.min = new Date('<%= sTimeSubmittedYear %>-<%= sTimeSubmittedMonth %>-<%= sTimeSubmittedDay %>');
		         	dijit.byId('workCompDate').constraints.max = new Date();
		         
		         	dijit.byId('ceRefNumDate').constraints.max = new Date();
		         	dijit.byId('hdRefNumDate').constraints.max = new Date();
		         
		         	onMO = true;
			} catch (e) {
				console.log("Error setting date constraints: " + e.message);
			}
		});
		
		
		// Set weekend check on cusContDate
		dojo.connect(dijit.byId("cusContDate"),"onselect", function() {
			try {
				var day = checkDayOfWeek(dijit.byId('cusContDate').value);
				if (day == 0 || day == 6) {
					dojo.byId("ccResponse").innerHTML = '<p><a class="ibm-caution-link"></a><%= messages.getString("weekend_date_message") %><br /></p>';
				} else {
					dojo.byId("ccResponse").innerHTML = '';
				}
			} catch (e) {
				console.log("Error checking cusContDate day of week " + e.message);
			}
		});
		
		// Set weekend check on workStartDate
		dojo.connect(dijit.byId("workStartDate"),"onselect", function() {
			try {
				var day = checkDayOfWeek(dijit.byId('workStartDate').value);
				if (day == 0 || day == 6) {
					dojo.byId("wsResponse").innerHTML = '<p><a class="ibm-caution-link"></a><%= messages.getString("weekend_date_message") %><br /></p>';
				} else {
					dojo.byId("wsResponse").innerHTML = '';
				}
			} catch (e) {
				console.log("Error checking workStartDate day of week " + e.message);
			}
		});
		
		// Set weekend check on workCompDate
		dojo.connect(dijit.byId("workCompDate"),"onselect", function() {
			try {
				var day = checkDayOfWeek(dijit.byId('workCompDate').value);
				if (day == 0 || day == 6) {
					dojo.byId("wcResponse").innerHTML = '<p><a class="ibm-caution-link"></a><%= messages.getString("weekend_date_message") %><br /></p>';
				} else {
					dojo.byId("wcResponse").innerHTML = '';
				}
			} catch (e) {
				console.log("Error checking workCompDate day of week " + e.message);
			}
		});
	       
	});
	
	function checkDayOfWeek(calstring) {
		var caldate = new Date(calstring);
		return caldate.getDay();
	}
	
	function compareTime(date1, date2) {
		relation = "";
		dayOfWeek = "";
		var url = "<%= keyops %>?next_page_id=10000&date1=" + date1 + "&date2=" + date2 + "&" + Math.random();
		callXMLCheckDate(url);
		return true;
	}
	
	function callXMLCheckDate(baseUrl) {
		 	dojo.xhrGet({
			   	url :baseUrl,
			   	handleAs : "xml",
			 	load : function(response, args) {
			 		try {
				   		relation = response.getElementsByTagName("Relation")[0].firstChild.data;
			 		 	dayOfWeek = response.getElementsByTagName("DayOfWeek")[0].firstChild.data;
				   	} catch (e) {
						console.log("Exception in XML data load: " + e);
				   		relation = "";
			 		 	dayOfWeek = "";
				   	} //try and catch
			   	}, //load function
			   	preventCache: true,
			   	sync: true,
			   	error : function(response, args) {
			   		console.log("Error getting XML data: " + response + " " + args.xhr.status);
			   	} //error function
			});
	} //rcallXMLCheckDate
		
	function updateTimes() {
		dojo.byId("ccResponse").innerHTML = "";
		dojo.byId("wsResponse").innerHTML = "";
		dojo.byId("wcResponse").innerHTML = "";
		var status = '<%= sStatus %>';
		if(status == 'completed') {
			alert('<%= messages.getString("cannot_close_ticket") %>');
			return false;
 		} else if(validateCustContacted() == false) {
 			return false;
		} else if(validateTimeStarted() == false) {
			return false;
		} else if(validateTimeCompleted() == false) {
			return false;
		} else if(validateCEHD() == false) {
			return false;
		} else {
 			document.theForm.submitvalue.value = 'updateTimes';
			dojo.byId("theForm").submit();
		}
	}
		
	function validateCustContacted() {
		// Add leading 0's to cusCont hour and minute
		var ccHour = dojo.byId("cusContHour").value;

		if (ccHour.length == 1) {
			dojo.byId("cusContHour").value = "0" + ccHour;
			ccHour = "0" + ccHour;
		}

		var ccMin = dojo.byId("cusContMin").value;
		if (ccMin.length == 1) {
			dojo.byId("cusContMin").value = "0" + ccMin;
			ccMin = "0" + ccMin;
		}
		
		// Set up some custCont variable to pass to the XML method.		
		var sCC = dojo.byId("cusContDate").value + '-' + ccHour + "-" + ccMin;

		// Check to make sure the hour and minute fields contain valid values.
		if (dojo.byId("cusContHour").value.length != 0 && dojo.byId("cusContHour").value.length != 2 || dojo.byId("cusContHour").value > 24) {
			dojo.byId("ccResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("cust_cont_hour_check") %></p>';
			alert('<%= messages.getString("cust_cont_hour_check") %>');
        	dojo.byId("cusContHour").focus();
			return false;
        } else if (dojo.byId("cusContMin").value.length != 0 && dojo.byId("cusContMin").value.length != 2 || dojo.byId("cusContMin").value > 59) {
        	dojo.byId("ccResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("cust_cont_minute_check") %></p>';
			alert('<%= messages.getString("cust_cont_minute_check") %>');
	        dojo.byId("cusContMin").focus();
        	return false;
		} 
		
		// Check to make sure cusContDate is after the time submitted date/time.
		compareTime(sCC,sTS);
		if (relation == "before") {
			dojo.byId("ccResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("cust_cont_later_submit_date") %></p>';
 			alert('<%= messages.getString("cust_cont_later_submit_date") %>');
	        dojo.byId("cusContDate").focus();
        	return false;
		}
		if (dayOfWeek == "Saturday" || dayOfWeek == "Sunday") {
 				var yesno = confirm('<%= messages.getString("cust_cont_weekend") %>');
	        	if (yesno) {
	        		return true;
	        	} else {
	        		dojo.byId("cusContDate").focus();
	            	return false;
	        	}
		}
		
		// Check to make sure cusContDate is before the current date/time.
		compareTime(sCC,sCT);
		if (relation == "after") {
			alert('<%= messages.getString("cust_cont_earlier_current_time") %>');
	        dojo.byId("cusContDate").focus();
        	return false;
		} 
    }
    
	function validateTimeStarted() {
		
		// Add leading 0's to cusCont hour and minute
		var wsHour = dojo.byId("workStartHour").value;
		if (wsHour.length == 1) {
			dojo.byId("workStartHour").value = "0" + wsHour;
			wsHour = "0" + wsHour;
		}

		var wsMin = dojo.byId("workStartMin").value;
		if (wsMin.length == 1) {
			dojo.byId("workStartMin").value = "0" + wsMin;
			wsMin = "0" + wsMin;
		}
		
		// Set up some custCont variable to pass to the XML method.		
		var sWS = dojo.byId("workStartDate").value + '-' + wsHour + "-" + wsMin;

		// Check to make sure the hour and minute fields contain valid values.
		if (dojo.byId("workStartHour").value.length != 0 && dojo.byId("workStartHour").value.length != 2 || dojo.byId("workStartHour").value > 24) {
			dojo.byId("wsResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("began_work_hour_check") %></p>';
			alert('<%= messages.getString("began_work_hour_check") %>');
        	dojo.byId("workStartHour").focus();
			return false;
        } else if (dojo.byId("workStartMin").value.length != 0 && dojo.byId("workStartMin").value.length != 2 || dojo.byId("workStartMin").value > 59) {
        	dojo.byId("wsResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("began_work_minute_check") %></p>';
			alert('<%= messages.getString("began_work_minute_check") %>');
	        dojo.byId("workStartMin").focus();
        	return false;
		} 
		
		// Check to make sure workStartDate is after the time submitted date/time.
		compareTime(sWS,sTS);
		if (relation == "before") {
			dojo.byId("wsResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("began_work_later_submit_date") %></p>';
 			alert('<%= messages.getString("began_work_later_submit_date") %>');
	        dojo.byId("workStartDate").focus();
        	return false;
		}
		if (dayOfWeek == "Saturday" || dayOfWeek == "Sunday") {
 				var yesno = confirm('<%= messages.getString("began_work_weekend") %>');
	        	if (yesno) {
	        		return true;
	        	} else {
	        		dojo.byId("workStartDate").focus();
	            	return false;
	        	}
		}
		
		// Check to make sure cusContDate is before the current date/time.
		compareTime(sWS,sCT);
		if (relation == "after") {
			alert('<%= messages.getString("began_work_earlier_current_time") %>');
	        dojo.byId("workStartDate").focus();
        	return false;
		} 
    }
    
    function validateTimeCompleted() {
    	
    	// Add leading 0's to workComp hour and minute
		var wcHour = dojo.byId("workCompHour").value;

		if (wcHour.length == 1) {
			dojo.byId("workCompHour").value = "0" + wcHour;
			wcHour = "0" + wcHour;
		}

		var wcMin = dojo.byId("workCompMin").value;
		if (wcMin.length == 1) {
			dojo.byId("workCompMin").value = "0" + wcMin;
			wcMin = "0" + wcMin;
		}
		
		// Set up some workComp variable to pass to the XML method.		
		var sWC = dojo.byId("workCompDate").value + '-' + wcHour + "-" + wcMin;
		
		// Add leading 0's to workStart hour and minute
		var wsHour = dojo.byId("workStartHour").value;
		if (wsHour.length == 1) {
			dojo.byId("workStartHour").value = "0" + wsHour;
			wsHour = "0" + wsHour;
		}

		var wsMin = dojo.byId("workStartMin").value;
		if (wsMin.length == 1) {
			dojo.byId("workStartMin").value = "0" + wsMin;
			wsMin = "0" + wsMin;
		}
		
		var sWS = dojo.byId("workStartDate").value + '-' + wsHour + "-" + wsMin;

		// Check to make sure the hour and minute fields contain valid values.
		if (dojo.byId("workCompHour").value.length != 0 && dojo.byId("workCompHour").value.length != 2 || dojo.byId("workCompHour").value > 24) {
			dojo.byId("ccResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("complete_work_hour_check") %></p>';
			alert('<%= messages.getString("complete_work_hour_check") %>');
        	dojo.byId("workCompHour").focus();
			return false;
        } else if (dojo.byId("workCompMin").value.length != 0 && dojo.byId("workCompMin").value.length != 2 || dojo.byId("workCompMin").value > 59) {
        	dojo.byId("ccResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("complete_work_minute_check") %></p>';
			alert('<%= messages.getString("complete_work_minute_check") %>');
	        dojo.byId("workCompMin").focus();
        	return false;
		} 
		
		// Check to make sure workComp is after the time submitted date/time.
		compareTime(sWC,sTS);
		if (relation == "before") {
			dojo.byId("wcResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("complete_later_submit_date") %></p>';
 			alert('<%= messages.getString("complete_later_submit_date") %>');
	        dojo.byId("workCompDate").focus();
        	return false;
		}
		
		// Check to make sure workComp is after workStart date
		compareTime(sWC,sWS);
		if (relation == "before") {
			dojo.byId("wcResponse").innerHTML = '<p><a class="ibm-error-link"></a><%= messages.getString("complete_later_began_work") %></p>';
 			alert('<%= messages.getString("complete_later_began_work") %>');
	        dojo.byId("workCompDate").focus();
        	return false;
		}
		
		if (dayOfWeek == "Saturday" || dayOfWeek == "Sunday") {
 				var yesno = confirm('<%= messages.getString("complete_weekend") %>');
	        	if (yesno) {
	        		return true;
	        	} else {
	        		dojo.byId("workCompDate").focus();
	            	return false;
	        	}
		}
		
		// Check to make sure cusContDate is before the current date/time.
		compareTime(sWC,sCT);
		if (relation == "after") {
			alert('<%= messages.getString("complete_earlier_current_time") %>');
	        dojo.byId("workCompDate").focus();
        	return false;
		} 
    }
    
    function validateCEHD() {
		if (dojo.byId("ceRefNumHour").value.length == 1) {
			dojo.byId("ceRefNumHour").value = "0" + dojo.byId("ceRefNumHour").value;
		}
		if (dojo.byId("ceRefNumMin").value.length == 1) {
			dojo.byId("ceRefNumMin").value = "0" + dojo.byId("ceRefNumMin").value;
		}
		if (dojo.byId("hdRefNumHour").value.length == 1) {
			dojo.byId("hdRefNumHour").value = "0" + dojo.byId("hdRefNumHour").value;
		}
		if (dojo.byId("hdRefNumMin").value.length == 1) {
			dojo.byId("hdRefNumMin").value = "0" + dojo.byId("hdRefNumMin").value;
		}
	}
	    
    function cancelForm() {
		self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>";
	}
</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"><%= messages.getString("Keyop_Admin_Home") %></a></li>  
				<li><a href="<%= keyops %>?next_page_id=2017&amp;ticketno=<%= iTicketNo %>"> <%= messages.getString("ticket") %>: <%= sTicketNo %></a></li>
			</ul>
			<h1><%= messages.getString("update_time_ref_ticket") %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<div id="response"></div>

					<div id="Keyop">
						<div id='nextpageid'></div>
						<div id='logactionid'></div>
						<div id='submitvalue'></div>
						<div id='ticketno'></div>
				
						<p><%= messages.getStringArgs("all_times_displayed_info", new String[] {sUserTimeZone}) %>&nbsp;<%= messages.getString("all_times_displayed_info2") %><br /></p>
					
						<p>	<%= messages.getString("ticket_opened_at") %>: <%= sTimeSubmitted %><br />
							<%= messages.getString("current_server_time") %>: <%= dateTime.formatTime(sCurrentTime) %><br /><br />
							<%= messages.getString("in_between_times") %>
						</p>
						<p>
							<h3><%= messages.getString("times") %></h3>
						</p>
						<p>
							<label for="cusContDate"><%= messages.getString("customer_contacted") %>:<span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
							<span><input type="text" class="ibm-date-picker" name="cusContDate" id="cusContDate" value="<%= sCustomerContactedYear %>-<%= sCustomerContactedMonth %>-<%= sCustomerContactedDay %>" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
						</p>
						<p>
							<span><input type="text" name="cusContHour" id="cusContHour" size="2" maxlength="2" value="<%= sCustomerContactedHour %>"/>:<input type="text" name="cusContMin" id="cusContMin" size="2" maxlength="2" onchange='dojo.byId("cusContDate").constraints' value="<%= sCustomerContactedMinute %>" /> (<%= messages.getString("hh_mm_24hour") %>)</span>
							<div id="ccResponse"></div>
						</p>
						<p>
							<label for="workStartDate"><%= messages.getString("work_started") %>:<span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
							<span><input type="text" class="ibm-date-picker" name="workStartDate" id="workStartDate" value="<%= sKeyopTimeStartYear %>-<%= sKeyopTimeStartMonth %>-<%= sKeyopTimeStartDay %>" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
						</p>
						 
						<p>
							<span><input type="text" name="workStartHour" id="workStartHour" size="2" maxlength="2" value="<%= sKeyopTimeStartHour %>"/>:<input type="text" name="workStartMin" id="workStartMin" size="2" maxlength="2" value="<%= sKeyopTimeStartMinute %>"/> (<%= messages.getString("hh_mm_24hour") %>)</span>
							<div id="wsResponse"></div>
						</p>
					
						<p>
							<label for="workCompDate"><%= messages.getString("work_completed") %>:<span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
							<span><input type="text" class="ibm-date-picker" name="workCompDate" id="workCompDate" value="<%= sKeyopTimeFinishYear %>-<%= sKeyopTimeFinishMonth %>-<%= sKeyopTimeFinishDay %>" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
						</p>
						<p>
							<span><input type="text" name="workCompHour" id="workCompHour" size="2" maxlength="2" value="<%= sKeyopTimeFinishHour %>"/>:<input type="text" name="workCompMin" id="workCompMin" size="2" maxlength="2" value="<%= sKeyopTimeFinishMinute %>"/> (<%= messages.getString("hh_mm_24hour") %>)</span>
							<div id="wcResponse"></div>
						</p>
						<p>
							<br /><h3><%= messages.getString("referrals") %></h3>
						</p>
						<p>
							<label for="cerefnum"><%= messages.getString("ce_ref_num") %>:</label>
							<span><input type="text" name="cerefnum" id="cerefnum" value="<%= sCEReferralNum %>"></span>
						</p>
						<p>
							<span class="ibm-access ibm-date-format">y-MM-dd</span>
							<span><input type="text" class="ibm-date-picker" name="ceRefNumDate" id="ceRefNumDate" value="<%= sCERefNumDateYear %>-<%= sCERefNumDateMonth %>-<%= sCERefNumDateDay %>" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
						</p>
						<p>
							<span><input type="text" name="ceRefNumHour" id="ceRefNumHour" size="2" maxlength="2" value="<%= sCERefNumDateHour %>"/>:<input type="text" name="ceRefNumMin" id="ceRefNumMin" size="2" maxlength="2" value="<%= sCERefNumDateMinute %>"/> (<%= messages.getString("hh_mm_24hour") %>)</span>
						</p>
						<p>
							<label for="hdrefnum"><%= messages.getString("helpdesk_ref_num") %>:</label>
							<span><input type="text" name="hdrefnum" id="hdrefnum" value="<%= sHDReferralNum %>"></span>
						</p>
						<p>
							<span class="ibm-access ibm-date-format">y-MM-dd</span> 
							<span><input type="text" class="ibm-date-picker" name="hdRefNumDate" id="hdRefNumDate" value="<%= sHDRefNumDateYear %>-<%= sHDRefNumDateMonth %>-<%= sHDRefNumDateDay %>" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
						</p>
						<p>
							<span><input type="text" name="hdRefNumHour" id="hdRefNumHour" size="2" maxlength="2" value="<%= sHDRefNumDateHour %>"/>:<input type="text" name="hdRefNumMin" id="hdRefNumMin" size="2" maxlength="2" value="<%= sHDRefNumDateMinute %>"/> (<%= messages.getString("hh_mm_24hour") %>)</span>
						</p>
						<p>
							<div class="ibm-buttons-row" align="right">
								<div id="submit_add_button"></div>
							</div>
						</p>
					</div> <!--  END KEYOP FORM -->
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>
