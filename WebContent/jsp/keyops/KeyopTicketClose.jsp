<%   
	com.ibm.aurora.bhvr.TableQueryBhvr TicketInfoUserView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketInfoUserView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketInfoUserView_RS = TicketInfoUserView.getResults();
   
	com.ibm.aurora.bhvr.TableQueryBhvr CloseCodesView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("CloseCodesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet CloseCodesView_RS = CloseCodesView.getResults();
   
	DateTime dateTime = new DateTime();
	String sTicketNo = request.getParameter("ticketno");
	String sCustomerContacted = "none";
	String sKeyopTimeStart = "none";
	String sKeyopTimeFinish = "none";
		
	while(TicketInfoUserView_RS.next()) {
		sCustomerContacted = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("CUSTOMER_CONTACTED"));
		sKeyopTimeStart = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_START"));
		sKeyopTimeFinish = dateTime.timeStampToString(TicketInfoUserView_RS.getTimeStamp("KEYOP_TIME_FINISH"));
	}

	int iTimesSetCode = 0;
	if (sCustomerContacted.length() < 18) {
		iTimesSetCode += 4;
	}
	if (sKeyopTimeStart.length() < 18) {
		iTimesSetCode += 2;
	}
	if (sKeyopTimeFinish.length() <18) {
		iTimesSetCode += 1;
	}
   
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, ticket close"/>
<meta name="Description" content="This page allows a keyop to close a keyop ticket." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("resolve_and_close_ticket") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createTextArea.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");

	var FormName = "RefreshForm";
	var info = new Array();
	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','2047');
		createHiddenInput('submitvalue','submitvalue','');
		createHiddenInput('ticketno','ticketno','<%= sTicketNo %>');
 		createpTag();
		createSelect('closecodeid', 'closecodeid', '<%= messages.getString("please_select_close_code") %>', 'None', 'closecodeidloc');
		createTextArea('solution','solution','solution','');
		
 		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
 		
 		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','closeTicketCheck()');
		createSpan('submit_add_button','ibm-sep');
 		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
 		
 		addCloseCodes();
 		changeSelectStyle('225px');
	});
	
	function addCloseCodes() {
		<% while (CloseCodesView_RS.next()) { %>
			addOption('closecodeid','<%= CloseCodesView_RS.getString("CLOSE_CODE_NAME") %>','<%= CloseCodesView_RS.getInt("CLOSE_CODEID") %>');
		<% } %>
	}
	
	function closeTicketCheck() {
		if(!validateTimeFields()) {
			return false;
		} else if(!validateSolution()) {
			return false;
		} else {
			YesNo = confirm('<%= messages.getString("close_ticket_check") %>');
			if (YesNo == true) {
				document.theForm.submitvalue.value = "closeTicket";
				submitForm();
			} else {
				return false;
			}
		}
	}
    	
	function validateSolution() {
        if(document.theForm.solution.value=="") {
  	     	alert('<%= messages.getString("required_info") %>');
            document.theForm.solution.focus();
            return false;
        } else {
        	return true;
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
	
	function submitForm() {
		document.theForm.submit();
	}
	
	function cancelForm() {
		self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= sTicketNo %>";
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
				<li><a href="<%= prtgateway %>?to_page_id=250_KO"> <%= messages.getString("keyop_page") %></a></li>
				<li><a href="<%= keyops %>?next_page_id=2017&amp;ticketno=<%= sTicketNo %>"> <%= messages.getString("ticket_info") %><%= sTicketNo %></a></li>
			</ul>
			<h1><%= messages.getString("resolve_and_close") %> <%= sTicketNo %></h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<%@ include file="../prtadmin/nav.jsp" %>
	<!-- All the main body stuff goes here -->
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
				
					<div id="Keyop">
						<div id="nextpageid"></div>
						<div id="submitvalue"></div>
						<div id="ticketno"></div>
												
						<p><%= messages.getString("keyop_ticket_close_info") %></p><br /><br />
						
						<p>
							<label for="closecode"><%= messages.getString("close_code_singular") %>: </label>
							<span><div id="closecodeidloc"></div></span>
						</p>
						<p>
							<br /><label for="solution"><%= messages.getString("enter_solution") %>:</label><br />
								<span><div id="solution"></div></span>
							<div class="ibm-buttons-row" align="right">
								<div id="submit_add_button"></div>
							</div>
						</p>
					</div>

				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>