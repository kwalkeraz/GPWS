<%
	com.ibm.aurora.bhvr.TableQueryBhvr TicketInfoUserView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketInfoUserView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketInfoUserView_RS = TicketInfoUserView.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr PartsReplaced = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsReplaced");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsReplaced_RS = PartsReplaced.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr PartsAdded = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsAdded");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsAdded_RS = PartsAdded.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr SuppliesReplaced = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("SuppliesReplaced");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet SuppliesReplaced_RS = SuppliesReplaced.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr HoldTimes = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("HoldTimes");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet HoldTimes_RS = HoldTimes.getResults();
	   
	com.ibm.aurora.bhvr.TableQueryBhvr TicketNotes = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketNotes");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketNotes_RS = TicketNotes.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr TicketProblems = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketProblems");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketProblems_RS = TicketProblems.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr PurchaseOrderView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PurchaseOrderView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet PurchaseOrderView_RS = PurchaseOrderView.getResults();
   
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	int iKOCompanyID = pupb.getVendorID();
   
	keyopTools tool = new keyopTools();
	AppTools appTool = new AppTools();
   
	DateTime dateTime = new DateTime();
	int numTickets = 0;
	int iTicketNo = 0;
	String sRequestedBy = "";
	String sTieLine = "";
	String sExtPhone = "";
	String sTimeSubmitted = "";
	String sPrinter = "";
	String sBuilding = "";
	String sFloor = "";
	String sRoom = "";
	String sKeyop = "";
	String sDescription = "";
	String sNotes = "";
	String sSolution = "";
	String sEmail = "";
	String sStatus = "";
	String sSite = "";
	String sCEReferralNum = "";
	String sHDReferralNum = "";
	String sCEReferralDate = "";
	String sHDReferralDate = "";
	String sCustContacted = "";
	String sKeyopTimeStart = "";
	String sKeyopTimeFinish = "";
	String sSuppliesReplaced = "";
	String sPartsReplaced = "";
	String sPartsAdded = "";
	//String sPurchaseOrders = "";
	String sPurchaseOrderDates = "";
	String sCloseCode = "";
	String sCCEmail = "";
	String sEndToEnd = "";
	String sTier = "";
	String sPSerNo = "";
	String sDeviceModel = "";
	String sBondReqNum = "";
	int iDevVendorID = 0;
	
	while(TicketInfoUserView_RS.next()) {
		iTicketNo = TicketInfoUserView_RS.getInt("KEYOP_REQUESTID");
		sRequestedBy = tool.getName(appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_NAME")));
		sTieLine = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_TIELINE"));
		sExtPhone = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_EXT_PHONE"));
		sTimeSubmitted = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("TIME_SUBMITTED"));
		sPrinter = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DEVICE_NAME"));
		sDeviceModel = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DEVICE_TYPE")); 
		sBuilding = appTool.nullStringConverter(TicketInfoUserView_RS.getString("BUILDING"));
		sFloor = appTool.nullStringConverter(TicketInfoUserView_RS.getString("FLOOR"));
		sRoom = appTool.nullStringConverter(TicketInfoUserView_RS.getString("ROOM"));
		sKeyop = appTool.nullStringConverter(TicketInfoUserView_RS.getString("KEYOP_NAME"));
		sDescription = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DESCRIPTION"));
		sSolution = appTool.nullStringConverter(TicketInfoUserView_RS.getString("SOLUTION"));
		sEmail = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQUESTOR_EMAIL"));
		sSite = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CITY"));
		sStatus = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQ_STATUS"));
		sCEReferralNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CE_REFERRAL_NUM"));
		sHDReferralNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("HD_REFERRAL_NUM"));
		sCEReferralDate = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("CE_REFERRAL_DATE"));
		sHDReferralDate = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("HD_REFERRAL_DATE"));
		sCustContacted = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("CUSTOMER_CONTACTED"));
		sKeyopTimeStart = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_START"));
		sKeyopTimeFinish = dateTime.convertUTCtoTimeZone(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_FINISH"));
		sBondReqNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("BOND_REQ_NUM"));
		sCCEmail = appTool.nullStringConverter(TicketInfoUserView_RS.getString("CC_EMAIL"));
		sEndToEnd = appTool.nullStringConverter(TicketInfoUserView_RS.getString("E2E_CATEGORY"));
		sTier = appTool.nullStringConverter(TicketInfoUserView_RS.getString("TIER"));
		sPSerNo = appTool.nullStringConverter(TicketInfoUserView_RS.getString("DEVICE_SERIAL"));
		iDevVendorID = TicketInfoUserView_RS.getInt("KO_COMPANYID");
		numTickets++;
	}
	
	if(sCustContacted.equals("invalid time")) {
		sCustContacted = "";
	}
	if(sKeyopTimeStart.equals("invalid time")) {
		sKeyopTimeStart = "";
	}
	if(sKeyopTimeFinish.equals("invalid time")) {
		sKeyopTimeFinish = "";
	}
	if(sCEReferralDate.equals("invalid time")) {
		sCEReferralDate = "";
	}
	if(sHDReferralDate.equals("invalid time")) {
		sHDReferralDate = "";
	}
	if(sHDReferralNum == null) {
		sHDReferralNum = "None";
	}
	
	int iTimesSetCode = 0;
	if (sCustContacted.length() < 18) {
		iTimesSetCode += 4;
	}
	if (sKeyopTimeStart.length() < 18) {
		iTimesSetCode += 2;
	}
	if (sKeyopTimeFinish.length() <18) {
		iTimesSetCode += 1;
	}
	
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, ticket info keyop"/>
<meta name="Description" content="This page allows a keyop to view keyop ticket information." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("ticket_information") %></title>
<%@ include file="metainfo2.jsp") %>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.Textarea");

	dojo.ready(function() {
		
		fixAlignment();
		
 		createHiddenInput('nextpageid','next_page_id','');
 		createHiddenInput('nextpageidA','next_page_id','','');
 		createHiddenInput('nextpageidTH','next_page_id','');
 		createHiddenInput('logactionid','logaction','');
 		createHiddenInput('logactionidA','logaction','','');
 		createHiddenInput('logactionidTH','logaction','','');
 		createHiddenInput('ticketno','ticketno','<%= iTicketNo %>','');
		createHiddenInput('ticketnoA','ticketno','<%= iTicketNo %>','');
		createHiddenInput('ticketnoTH','ticketno','<%= iTicketNo %>','');
		createHiddenInput('submitvalue','submitvalue','','');
		createHiddenInput('submitvalueA','submitvalue','','');
		createHiddenInput('submitvalueTH','submitvalue','','');
		createTextArea('noteid','notetextvalue','notetextvalue','');
		createTextArea('toholdid','holdtextvalue','holdtextvalue','');
		
		dojo.byId("notetextvalue").maxLength = "512";
		dojo.byId("holdtextvalue").maxLength = "512";
			
 		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','addNote()');
		createSpan('submit_add_button','ibm-sep');
 		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("addNoteOverlay", this);');
 		
 		createInputButton('submit_tohold_button','ibm-submit','<%= messages.getString("change_to_hold_status") %>','ibm-btn-arrow-pri','next()','toHold()');
		createSpan('submit_tohold_button','ibm-sep');
 		createInputButton('submit_tohold_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("toHoldOverlay", this);');
 		
 		<% if (sStatus.equals("new")) { %>
			createInputButton('submit_assign_button','ibm-submit','<%= messages.getString("assign_to_me") %>','ibm-btn-arrow-pri','next()','assignTicket()');
		<% } %>
		
 		<% if (sStatus.equals("HOLD")) { %>
 			createInputButton('submit_fromhold_button','ibm-submit','<%= messages.getString("change_from_hold_status") %>','ibm-btn-arrow-pri','next()','fromHold()');
 		<% } %>
 		
 		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
	 	createPostForm('addNote', 'addNoteForm', 'addNoteForm', 'ibm-column-form', '<%= keyops %>');
 		createPostForm('toHold', 'toHoldForm', 'toHoldForm', 'ibm-column-form', '<%= keyops %>');
	
 		<% if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
 		<% } %>
 		
	});
	
	dojo.addOnLoad(function() {
		// Set constraints on date fields
		dojo.connect(dojo.byId("notetextvalue"),"onkeypress", function() {
			dojo.byId("noteChars").innerHTML = "<p>"+ (512 - dojo.byId("notetextvalue").value.length)+" characters left</p>";
		});
			       
	});
	
	function showAddNote() {
		ibmweb.overlay.show('addNoteOverlay', this);
		
	}
	
	function showToHold() {
		ibmweb.overlay.show('toHoldOverlay', this);
	}
	
	function addNote() {
		document.addNoteForm.next_page_id.value = "2047";
		document.addNoteForm.logaction.value = "<%= messages.getString("note_add_success") %>";
		document.addNoteForm.submitvalue.value = "addNote";
		validForm = dijit.byId("addNoteForm").validate();
		if (validForm) {
			dojo.byId("addNoteForm").submit();
		} else {
			return false;
		}
	}
	
	function toHold() {
		document.toHoldForm.next_page_id.value = "2047";
		document.toHoldForm.logaction.value = "<%= messages.getString("change_to_hold_success") %>";
		document.toHoldForm.submitvalue.value = "toHold";
		validForm = true;
		if (validForm) {
			dojo.byId("toHoldForm").submit();
		} else {
			return false;
		}
	}
	
	function assignTicket() {
		document.theForm.next_page_id.value = "2047";
		document.theForm.logaction.value = "<%= messages.getString("assign_success") %>";
		document.theForm.submitvalue.value = "assignToMe";
		dojo.byId("theForm").submit();
	}
	
	function fromHold() {
		document.theForm.next_page_id.value = "2047";
		document.theForm.logaction.value = "<%= messages.getString("change_from_hold_success") %>";
		document.theForm.submitvalue.value = "fromHold";
		dojo.byId("theForm").submit();
	}
	
	function hideNoteFields() {
		document.getElementById("notetextarea").style.display = "none";
		document.getElementById("notebuttons").style.display = "none";
		document.getElementById("notetext").style.display = "";
	}
	function showNoteFields() {
		document.getElementById("notetextarea").style.display = "";
		document.getElementById("notebuttons").style.display = "";
		document.getElementById("notetext").style.display = "none";
	}
	
	function hideHoldFields() {
		document.getElementById("holdtextarea").style.display = "none";
		document.getElementById("toholdbuttons").style.display = "none";
		document.getElementById("holdtext").style.display = "";
	}
	function showHoldFields() {
		document.getElementById("holdtextarea").style.display = "";
		document.getElementById("toholdbuttons").style.display = "";
		document.getElementById("holdtext").style.display = "none";
	}
	
	function closeTicket() {
		if(validateTimeFields()) {
			self.location.href = "<%= keyops %>?next_page_id=2019&ticketno=<%= iTicketNo %>";	
		}		
	}
	
	function validateTimeFields() {
        if('<%= iTimesSetCode %>' == '1') {
  	     	alert('<%= messages.getString("work_completed_time_req") %>');
            return false;
        } else if ('<%= iTimesSetCode %>' == '2') {
        	alert('<%= messages.getString("work_started_time_req") %>');
            return false;
        } else if ('<%= iTimesSetCode %>' == '3') {
        	alert('<%= messages.getString("work_start_work_comp_req") %>');
            return false;
        } else if ('<%= iTimesSetCode %>' == '4') {
        	alert('<%= messages.getString("cust_contact_time_req") %>');
            return false;
        } else if ('<%= iTimesSetCode %>' == '5') {
        	alert('<%= messages.getString("cust_contact_work_comp_req") %>');
            return false;
        } else if ('<%= iTimesSetCode %>' == '6') {
        	alert('<%= messages.getString("cust_contact_work_start_req") %>');
            return false;
        } else if ('<%= iTimesSetCode %>' == '7') {
        	alert('<%= messages.getString("cust_contact_work_start_work_comp_req") %>');
            return false;
        } else {
        	return true;
        }
    }
		
	function closeTicketCheck() {
		if(!validateSolution("solution")) {
			return false;
		} else if(!validateCustContacted) {
			return false;
		} else if(!validateTimeCompleted) {
			return false;
		} else if(!validateTimeStarted) {
			return false;
		} else {
			document.theForm.submitvalue.value = "closeTicket";
			submitForm();
		}
	}
	
	function updateMaterials() {
		document.theForm.submitvalue.value = "updateMaterials";
		submitForm();
	}
	
	function submitForm() {
		document.theForm.submit();
	}
	
	function fixAlignment() {
		dojo.query(".leftcol").forEach(function(x){
			if (x.id == "timesrefs") {
				x.style = "float: left; width:300px";
			} else {
				x.style = "float: left; width:200px";
			}
		});
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
			</ul>
			<h1><%= messages.getString("ticket_information") %></h1>
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

<% if (request.getParameter("msg") != null && request.getParameter("msg").equals("timessuccess")) { %>
<br /><p class="green-med-dark"><%= messages.getString("times_ref_update_success") %></p>
<% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("partssuccess")) { %>
<br /><p class="green-med-dark"><%= messages.getString("parts_supplies_update_success") %></p>
<% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("holdonsuccess")) { %>
<br /><p class="green-med-dark"><%= messages.getString("change_to_hold_success") %></p>
<% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("holdoffsuccess")) { %>
<br /><p class="green-med-dark"><%= messages.getString("change_from_hold_success") %></p>
<% } else if (request.getParameter("msg") != null && request.getParameter("msg").equals("notesuccess")) { %>
<br /><p class="green-med-dark"><%= messages.getString("note_add_success") %></p>
<% } %>
<%

	Connection con = null;
	Statement stTicket = null;
	ResultSet rsTicket = null;
   try {
	if (sStatus.equals("completed")) {
		con = tool.getConnection();
		stTicket = con.createStatement();
		rsTicket = stTicket.executeQuery("SELECT CLOSE_CODE_NAME FROM GPWS.KEYOP_CLOSECODES WHERE CLOSE_CODEID = (SELECT CLOSE_CODEID FROM GPWS.KEYOP_REQUEST WHERE KEYOP_REQUESTID = " + iTicketNo + ")");
		while (rsTicket.next()) {
			sCloseCode = rsTicket.getString("CLOSE_CODE_NAME");
		}
	}
   } catch (Exception e) {
   		System.out.print("Keyop error in TicketInfoKeyop.jsp ERROR: " + e);
   		try {
	   		tool.logError("TicketInfoKeyop.jsp", e);
	   	} catch (Exception ex) {
	   		System.out.println("Keyop Error in TicketInfoKeyop.jsp ERROR: " + ex);
	   	}
   } finally {
   		if (rsTicket != null)
   			rsTicket.close();
   		if (stTicket != null)
   			stTicket.close();
   		if (con != null)
   			con.close();
   }
%>
<% if (numTickets == 1 && iKOCompanyID == iDevVendorID) { %>
	<div id="Keyop">
		<div id='nextpageid'></div>
		<div id='logactionid'></div>
		<div id='submitvalue'></div>
		<div id='ticketno'></div>
<%	if (sStatus.equals("in progress")) { %>
	<br />
	<div class="ibm-columns">
		<div class="ibm-col-6-3">
			<p>
				<a class="ibm-anchor-down-link" href="#notes"><%= messages.getString("key_operator") %>&nbsp;<%= messages.getString("notes") %></a><br />
				<a class="ibm-anchor-down-link" href="#timeref"><%= messages.getString("times_and_referrals") %></a>
			</p>
		</div>
		<div class="ibm-col-6-3">
			<p>
				<a class="ibm-anchor-down-link" href="#changestatus"><%= messages.getString("change_status") %></a><br />
				<a class="ibm-anchor-down-link" href="#partssupplies"><%= messages.getString("parts_and_supplies") %></a>
			</p>
		</div>
	</div>
	<% } else if (sStatus.equals("HOLD")) { %>
	<br />
	<div class="ibm-columns">
		<div class="ibm-col-6-3">
			<p>
				<a class="ibm-anchor-down-link" href="#notes"><%= messages.getString("key_operator") %>&nbsp;<%= messages.getString("notes") %></a><br />
				<a class="ibm-anchor-down-link" href="#changestatus"><%= messages.getString("change_status") %></a>
			</p>
		</div>
		<div class="ibm-col-6-3">
			<p>
				<a class="ibm-anchor-down-link" href="#partssupplies"><%= messages.getString("parts_and_supplies") %></a>
			</p>
		</div>
	</div>
	<% } else if (sStatus.equals("completed")) { %>
	<br />
	<div class="ibm-columns">
		<div class="ibm-col-6-2">
			<p>
				<a class="ibm-anchor-down-link" href="#notes"><%= messages.getString("key_operator") %>&nbsp;<%= messages.getString("notes") %></a><br />
				<a class="ibm-anchor-down-link" href="#holdtimes"><%= messages.getString("hold_times") %></a>
			</p>
		</div>
		<div class="ibm-col-6-2">
			<p>
				<a class="ibm-anchor-down-link" href="#timeref"><%= messages.getString("times_and_referrals") %></a><br />
				<a class="ibm-anchor-down-link" href="#resolution"><%= messages.getString("resolution") %></a>
			</p>
		</div>
		<div class="ibm-col-6-2">
			<p>
				<a class="ibm-anchor-down-link" href="#partssupplies"><%= messages.getString("parts_and_supplies") %></a>
			</p>
		</div>
	</div>
	<% } %>
					<div class="ibm-columns">
						<div class="ibm-col-1-1">
							<h2 class="ibm-rule-alternate"><%= messages.getString("ticket_information") %></h2><br />
							<div class="leftcol">	
								<strong><%= messages.getString("ticket_number") %>:</strong><br />
								<strong><%= messages.getString("status") %>:</strong><br />
								<strong><%= messages.getString("assigned_to") %>:</strong><br />
								<strong><%= messages.getString("time_opened") %>:</strong><br />
							</div>
							<div>
								<%= iTicketNo %><br />
								<%= sStatus %><br />
								<% if (sKeyop.equals("")) { %>
							   		<%= messages.getString("unassigned") %>
								<% } else { %>
							   		<%= sKeyop %>
								<% } %><br />
								<%= sTimeSubmitted %><br /><br />
							</div>
							<h2 class="ibm-rule-alternate"><strong><%= messages.getString("user_info") %></strong></h2><br />
							<div class="leftcol">
								<strong><%= messages.getString("name") %>:</strong><br />
								<strong><%= messages.getString("ext_phone") %>:</strong><br />
								<strong><%= messages.getString("tieline") %>:</strong><br />
								<strong><%= messages.getString("email") %>:</strong><br />
								<strong><%= messages.getString("additional_email") %>:</strong><br /><br />
							</div>
							<div>
								<%= sRequestedBy %><br />
								<%= sExtPhone %><br />
								<%= sTieLine %><br />
								<%= sEmail %><br />
								<%= sCCEmail %><br /><br />
							</div>

							<h2 class="ibm-rule-alternate"><%= messages.getString("device_info") %></h2>
							<div class="leftcol">
								<strong><%= messages.getString("device_name") %>:</strong><br />
								<strong><%= messages.getString("site") %>:</strong><br />
								<strong><%= messages.getString("building") %>:</strong><br />
								<strong><%= messages.getString("floor") %>:</strong><br />
								<strong><%= messages.getString("room") %>:</strong><br />
								<strong><%= messages.getString("device_model") %>:</strong><br />
								<strong><%= messages.getString("device_serial") %>:</strong><br />
								<strong><%= messages.getString("e2e_category") %>:</strong><br />
								<strong><%= messages.getString("tier") %>:</strong><br /><br />
							</div>
							<div>
								<%= sPrinter %><br />
								<%= sSite %><br />
								<%= sBuilding %><br />
								<%= sFloor %><br />
								<%= sRoom %><br />
								<%= sDeviceModel %><br />
								<%= sPSerNo %><br />
								<%= sEndToEnd %><br />
								<%= sTier %><br /><br />
							</div>
							
							<h2 class="ibm-rule-alternate"><%= messages.getString("device") %>&nbsp;<%= messages.getString("problems") %></h2><br />
							<ul>
							<% while (TicketProblems_RS.next()) { %>
									<li><%= TicketProblems_RS.getString("PROBLEM_NAME") %></li>
							<% } %>
							</ul><br />
							
							<h2 class="ibm-rule-alternate"><%= messages.getString("prob_desc_alt_contact") %></h2><br />
							<p>
							<%  if (sDescription.equals("")) { %>
									<%= messages.getString("none") %>
							<%	} else { %>
									<%= sDescription %>
							<%	} %>
							</p><br />
							
				<% if (sStatus.equals("new")) { %>
						<h2 class="ibm-rule-alternate"><%= messages.getString("Take_over_ownership_of_ticket") %></h2>
						<p><%= messages.getString("assign_ticket_desc") %></p>
						<div class="ibm-buttons-row" align="right">
								<div id="submit_assign_button"></div>
						</div>
				<% } else if (!sStatus.equals("new")) { %>
							<h2 class="ibm-rule-alternate"><%= messages.getString("key_operator") %>&nbsp;<%= messages.getString("notes") %></h2><br /><div id="notes"></div>
							<p>
							<%	while (TicketNotes_RS.next()) { %>
								<strong><%= dateTime.convertUTCtoTimeZone(TicketNotes_RS.getTimeStamp("DATE_TIME")) %>&nbsp;-&nbsp;
								<%= TicketNotes_RS.getString("ADDED_BY") %>:&nbsp;</strong>
								<%= TicketNotes_RS.getString("NOTE") %>
								<br />
							<% } 
								if (TicketNotes_RS.getResultSetSize() == 0) { %>
									<%= messages.getString("none") %>
							<%  } %>
							</p>
						<% if (!sStatus.equals("completed")) { %>
							<p>
								<a href="javascript:showAddNote()"><%= messages.getString("add_a_note") %></a><br />
								
							</p>
								<p id="notetextarea" style="display:none">
									<%= messages.getString("enter_note_to_add") %>:<br /><textarea name="notetextvalue" id="note" cols="50" rows="5"></textarea>
								</p>
								<p id="notebuttons" style="display:none">
										<span class="button-blue"><input type="button" name="Note" value="Add Note" onclick="javascript:AddNote()"/>&nbsp;&nbsp;<input type="button" name="Cancel" value="Cancel" onclick="javascript:hideNoteFields()"/></span><br />
								</p>
						<% }  %>
						
							<br />
						<% if (sStatus.equals("in progress")) { %>
							<h2 class="ibm-rule-alternate"><%= messages.getString("times_and_referrals") %> - <a href="<%= keyops %>?next_page_id=2022&amp;ticketno=<%= iTicketNo %>"><%= messages.getString("update") %></a></h2><div id="timeref"></div><br />
						<% } else { %>
							<div id="timeref"></div><h2 class="ibm-rule-alternate"><%= messages.getString("times_and_referrals") %></h2>
						<% } %>
							<div class="leftcol" id="timesrefs">
								<strong><%= messages.getString("customer_contacted") %>:</strong><br />
								<strong><%= messages.getString("work_started") %>:</strong><br />
								<strong><%= messages.getString("work_completed") %>:</strong><br />
								<strong><%= messages.getString("ce_referral_number_date") %>:</strong><br />
								<strong><%= messages.getString("helpdesk_referral_number_date") %>:</strong><br /><br />
							</div>
							<div>
								<%= sCustContacted %><br />
								<%= sKeyopTimeStart %><br />
								<%= sKeyopTimeFinish %><br />
								<%= sCEReferralNum %> - <%= sCEReferralDate %><br />
								<%= sHDReferralNum %> - <%= sHDReferralDate %><br /><br />
							</div>
							
						<% if (sStatus.equals("completed")) { %>
						
								<br />
								<h2 class="ibm-rule-alternate"><%= messages.getString("resolution") %></h2><div id="resolution"></div>
								<div class="leftcol">
									<strong><%= messages.getString("solution") %>:</strong><br />
									<strong><%= messages.getString("close_code_singular") %>:</strong><br /><br />
								</div>
								<div>
									<%= sSolution %><br />
									<%= sCloseCode %><br /><br />
								</div>
						<% } %>
							
							<% if (sStatus.equals("in progress") || sStatus.equals("HOLD")) { %>
								<br />
								<h2 class="ibm-rule-alternate"><%= messages.getString("change_status") %></h2><br /><div id="changestatus"></div>
							<% } %>
							<% if (sStatus.equals("in progress")) { %>
								<p id="holdtext">
									<ul><li><a href="javascript:showToHold()"><%= messages.getString("change_to_hold_status") %></a></li></ul>
									<ul><li><%= messages.getString("to_resolve_and_close") %> <a href="javascript:closeTicket()"><%= messages.getString("click_here_close") %></a></li></ul>
								</p>
							<% } else if (sStatus.equals("HOLD")) { %>
									<div class="ibm-buttons-row" align="left">
										<div id="submit_fromhold_button"></div>
									</div>
							<% } %>
							
							<br />
							<% if (sStatus.equals("in progress")) { %>
								<h2 class="ibm-rule-alternate"><%= messages.getString("parts_and_supplies") %> - <a href="<%= keyops %>?next_page_id=2018&amp;ticketno=<%= iTicketNo %>&amp;vendorid=<%= iDevVendorID %>"><%= messages.getString("update") %></a></h2><div id="partssupplies"></div><br />
							<% } else { %>
								<h2 class="ibm-rule-alternate"><%= messages.getString("parts_and_supplies") %></h2><div id="partssupplies"></div>
							<% } %>
							<div class="leftcol" id="parts">
								<strong><%= messages.getString("supplies_replaced") %>:</strong><br />
								<strong><%= messages.getString("parts_replaced") %>:</strong><br />
								<strong><%= messages.getString("parts_added") %>:</strong><br />
								<strong><%= messages.getString("bond_req_num") %>:</strong>
							</div>
							<div>
								<% while (SuppliesReplaced_RS.next()) { %>
									 <%= SuppliesReplaced_RS.getString("SUPPLY_NAME") %>,&nbsp;
								<% } %>
								<br />
								<% while (PartsReplaced_RS.next()) { %>
						 			<%= PartsReplaced_RS.getString("PART_NAME") %>,&nbsp;
								<% } %>
								<br />
								<% while (PartsAdded_RS.next()) { %>
						 			<%= PartsAdded_RS.getString("PART_NAME") %>,&nbsp;
								<% }%>
								<br />
								<% if (sBondReqNum == null) { %> 
									<%= messages.getString("none") %>
								<% } else { %> 
									<%= sBondReqNum %>
								<% } %>
							</div>
								<br /><br />
								<strong><%= messages.getString("purchase_order_number") %> - <%= messages.getString("purchase_order_date") %></strong><br />
								<% while (PurchaseOrderView_RS.next()) { %>
									<%= appTool.nullStringConverter(PurchaseOrderView_RS.getString("PURCHASE_ORDER_NUMBER")) %> - <%= dateTime.convertUTCtoTimeZone(PurchaseOrderView_RS.getTimeStamp("PURCHASE_ORDER_DATE")) %><br />
								<% } %>
								<% if (PurchaseOrderView_RS.getResultSetSize() < 1) { %>
									<%= messages.getString("none") %>
								<% } %>
<!-- 							</div> -->
							
							
							<% if (sStatus.equals("completed")) { 
								if (HoldTimes_RS.getResultSetSize() > 0) { %>
									<br />
									<h2 class="ibm-rule-alternate"><%= messages.getString("hold_times") %></h2><div id="holdtimes"></div>
									<p>
									<% while (HoldTimes_RS.next()) { %>
										<%= messages.getString("time_stop") %>:  <%= dateTime.convertUTCtoTimeZone(HoldTimes_RS.getTimeStamp("TIME_ON_HOLD")) %> - <%= messages.getString("time_start") %>: <%= dateTime.convertUTCtoTimeZone(HoldTimes_RS.getTimeStamp("TIME_OFF_HOLD")) %>
										<br />
									<% } %>
									</p>
							<% 	} 
							   } %>
				<% } // END Status != "new" %>
					</div>
				</div>
			</div>
			<!-- ADD Note OVERLAY STARTS HERE -->
						<div class="ibm-common-overlay" id="addNoteOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("add_note") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("enter_note_to_add") %>&nbsp;<%= messages.getString("required_info") %></p>
											<div id="addNote">								
												<div id='nextpageidA'></div>
												<div id='logactionidA'></div>
												<div id='submitvalueA'></div>
												<div id='ticketnoA'></div>
												<div class="pClass"><label for="noteid"><%= messages.getString("enter_note_to_add") %>:<span class="ibm-required">*</span></label><span><div id="noteid"></div></span></div>
												<span><div id="noteChars">512 <%= messages.getString("characters_left") %></div></span>
												<div class="ibm-overlay-rule"><hr /></div>
												<div class="ibm-buttons-row" align="right">
													<div id="submit_add_button"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						
							<div class="ibm-footer"></div>
						</div>
						<!-- ADD SUPPLY OVERLAY ENDS HERE -->
						
						<!-- ToHold OVERLAY STARTS HERE -->
						<div class="ibm-common-overlay" id="toHoldOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("change_to_hold_status") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("please_provide_hold_reason") %>&nbsp;<%= messages.getString("required_info") %></p>
											<div id="toHold">								
												<div id='nextpageidTH'></div>
												<div id='logactionidTH'></div>
												<div id='submitvalueTH'></div>
												<div id='ticketnoTH'></div>
												<div class="pClass"><label for="toholdid"><%= messages.getString("please_provide_hold_reason") %>:<span class="ibm-required">*</span></label><span><div id="toholdid"></div></span></div>
												<div class="ibm-overlay-rule"><hr /></div>
												<div class="ibm-buttons-row" align="right">
													<div id="submit_tohold_button"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						
							<div class="ibm-footer"></div>
						</div>
						<!-- ADD SUPPLY OVERLAY ENDS HERE -->
		<% } else { %>
			<p>
			<%= messages.getString("sorry_request") %> <%= request.getParameter("ticketno") %> <%= messages.getString("not_found") %>.
			</p>
		<% } %>	
					
					
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>