<%

com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopView");
com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopView_RS = AdminKeyopView.getResults();

PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
int iVendorID = pupb.getVendorID();

String[] sAuthTypes = pupb.getAuthTypes();
boolean isKOSU = false;
for (int i = 0; i < sAuthTypes.length; i++) {
	if (sAuthTypes[i].startsWith("Keyop Superuser")) {
		isKOSU = true;
	}
}

%>

<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin ticket search"/>
<meta name="Description" content="This is the results page for when an admin updates, adds, or delets a system close code." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("admin_ticket_search_title") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/keyopLocationUpdate.js"></script>
<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Button");

	dojo.ready(function() {
		createpTag();
		createHiddenInput('nextpageid','next_page_id','2016a');
		createHiddenInput('submitvalue','submitvalue','');
		createTextInput('ticketstart','ticketstart','ticketstart','50',true,'','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('printer','printer','printer','50',true,'','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('reqname','reqname','reqname','50',true,'','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('keyopname','keyopname','keyopname','50',true,'','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('site','site','site','50',true,'','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('building','building','building','50',true,'','','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createSelect('keyopuserid', 'keyopuserid', 'Select keyop', '', 'keyopuseridloc');
 		
 		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
 		createInputButton('submit_search_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','SearchTicket()');
			createSpan('submit_search_button','ibm-sep');
		createInputButton('submit_search_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','CancelForm()');
		
		addKeyops();
		changeSelectStyle('225px');

	});
	
	function addKeyops() {
		<% while (AdminKeyopView_RS.next()) { 
			if (isKOSU == true) { %>
				addOption('keyopuserid','<%= AdminKeyopView_RS.getString("LAST_NAME") + ", " + AdminKeyopView_RS.getString("FIRST_NAME") %>','<%= AdminKeyopView_RS.getInt("USERID") %>');
		<%  } else { 
				if (iVendorID == AdminKeyopView_RS.getInt("VENDORID")) { %>
					addOption('keyopuserid','<%= AdminKeyopView_RS.getString("LAST_NAME") + ", " + AdminKeyopView_RS.getString("FIRST_NAME") %>','<%= AdminKeyopView_RS.getInt("USERID") %>');
		<%		}
			}
			}
		%>
	}
	
	function checkFields() {
		if ( (document.theForm.ticketstart.value == null || document.theForm.ticketstart.value == "") &&
			 (document.theForm.printer.value == null || document.theForm.printer.value == "") &&
			 (document.theForm.reqname.value == null || document.theForm.reqname.value == "") &&
			 (document.theForm.keyopname.value == null || document.theForm.keyopname.value == "") &&
			 (document.theForm.site.value == null || document.theForm.site.value == "") &&
			 (document.theForm.building.value == null || document.theForm.building.value == "")) {
			 return false;
		} else {
			return true;
		}
	}
	function CancelForm() {
		self.location.href = "<%= prtgateway %>?to_page_id=250_KO";
	}
	
	function SearchTicket() {
		if (checkFields == false) {
			alert('<%= messages.getString("must_enter_search_value") %>');
			return false;
		} else {
			document.theForm.submitvalue.value = "Search";
			document.theForm.submit();
		}
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
			<h1><%= messages.getString("admin_ticket_search_title") %></h1>
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
						<p><%= messages.getString("admin_ticket_search_desc") %>
						<div class="pClass">
							<label for="ticketstart"><%= messages.getString("ticket_number") %>:</label> 
							<span><div id="ticketstart"></div></span>
						</div>
						<div class="pClass">
							<label for="printer"><%= messages.getString("device_name") %>:</label> 
							<span><div id="printer"></div></span>
						</div>
						<div class="pClass">
							<label for="reqname"><%= messages.getString("admin_ticket_search_req_name") %>:</label> 
							<span><div id="reqname"></div></span>
						</div>
						<div class="pClass">
							<label for="keyopuserid"><%= messages.getString("admin_ticket_search_keyop_name") %>:</label> 
							<span><div id="keyopuseridloc"></div></span>
						</div>
						<div class="pClass">
							<label for="site"><%= messages.getString("site") %>:</label> 
							<span><div id="site"></div></span>
						</div>
						<div class="pClass">
							<label for="building"><%= messages.getString("building") %>:</label> 
							<span><div id="building"></div></span>
						</div>
						<div class="ibm-alternate-rule"><hr /></div>
						<div class="ibm-buttons-row" align="right">
							<div id="submit_search_button"></div>
						</div>
					</div><!-- END Keyop FORM -->
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>