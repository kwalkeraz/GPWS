<%   
	// THIS IS WHERE WE LOAD ALL THE BEANS
   com.ibm.aurora.bhvr.TableQueryBhvr TicketInfoUserView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("TicketInfoUserView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet TicketInfoUserView_RS = TicketInfoUserView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr SuppliesView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("SuppliesView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet SuppliesView_RS = SuppliesView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsView_RS = PartsView.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsView2 = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsView2_RS = PartsView2.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsReplaced = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsReplaced");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsReplaced_RS = PartsReplaced.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PartsAdded = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PartsAdded");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PartsAdded_RS = PartsAdded.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr SuppliesReplaced = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("SuppliesReplaced");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet SuppliesReplaced_RS = SuppliesReplaced.getResults();
   
   com.ibm.aurora.bhvr.TableQueryBhvr PurchaseOrderView = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("PurchaseOrderView");
   com.ibm.aurora.bhvr.TableQueryBhvrResultSet PurchaseOrderView_RS = PurchaseOrderView.getResults();
   
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	
	int vendorid = pupb.getVendorID();
   
	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	int iTicketNo = 0;
	String sTicketNo = "";
	String sStatus = "";
	String sSuppliesReplaced = "";
	String sPartsReplaced = "";
	String sPartsAdded = "";
	String sPurchaseOrders = "";
	String sPurchaseOrderDates = "";
	String sBondReqNum = "";
		
	while(TicketInfoUserView_RS.next()) {
		iTicketNo = TicketInfoUserView_RS.getInt("KEYOP_REQUESTID");
		sStatus = appTool.nullStringConverter(TicketInfoUserView_RS.getString("REQ_STATUS"));
		sBondReqNum = appTool.nullStringConverter(TicketInfoUserView_RS.getString("BOND_REQ_NUM"));
	}
	
	sTicketNo = iTicketNo + "";
	
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, ticket update materials"/>
<meta name="Description" content="This page allows a keyop to update the materials and supplies for a ticket." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("update_parts_supplies") %></title>
<%@ include file="metainfo2.jsp") %>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.MultiSelect");
dojo.require("dijit.form.Button");

var onMO = false;

	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','2047');
		createHiddenInput('ticketno','ticketno','<%= iTicketNo %>','');
		createHiddenInput('submitvalue','submitvalue','','');
		createHiddenInput('logactionid','logaction','','');
		createHiddenInput('podate','podate','','');
		
		createHiddenInput('nextpageidPO','next_page_id','2047');
		createHiddenInput('ticketnoPO','ticketno','<%= iTicketNo %>','');
		createHiddenInput('submitvaluePO','submitvalue','addpo','');
		createHiddenInput('logactionidPO','logaction','','');
		
		
		createHiddenInput('nextpageidModPO','next_page_id','2047');
		createHiddenInput('ticketnoModPO','ticketno','<%= iTicketNo %>','');
		createHiddenInput('submitvalueModPO','submitvalue','modpo','');
		createHiddenInput('logactionidModPO','logaction','','');
		createHiddenInput('podateMOD','podate','','');
		createHiddenInput('poidMOD','poid','','poid');
		
		createHiddenInput('nextpageidDelPO','next_page_id','2049');
		createHiddenInput('ticketnoDelPO','ticketno','<%= iTicketNo %>','');
		createHiddenInput('logactionidDelPO','logaction','<%= messages.getString("purchase_order_delete_success") %>','');
		createHiddenInput('ponumberDelPO','ponumber','','ponumber');
		createHiddenInput('vendoridLoc','vendorid','','vendorid');
		
		createTextBox('bondreqnum','bondreqnum','bondreqnum','32','','<%= sBondReqNum %>');
		
		createMultiSelect('suppliesReplacedCurrent', 'suppliesReplacedCurrentloc', '3');
		createMultiSelect('suppliesReplaced', 'suppliesReplacedloc', '3');
		createMultiSelect('partsReplacedCurrent', 'partsReplacedCurrentloc', '3');
		createMultiSelect('partsReplaced', 'partsReplacedloc', '3');
		createMultiSelect('partsAddedCurrent', 'partsAddedCurrentloc', '3');
		createMultiSelect('partsAdded', 'partsAddedloc', '3');
		

		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','updateMaterials()');
		createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','cancelForm()');
		
		createInputButton('submit_po_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','addPO()');
		createSpan('submit_po_button','ibm-sep');
 		createInputButton('submit_po_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("poOverlay", this);');
 		
 		createInputButton('submit_modpo_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','modPO()');
		createSpan('submit_modpo_button','ibm-sep');
 		createInputButton('submit_modpo_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("poModOverlay", this);');
		
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		createPostForm('addPO','addPOForm','addPOForm','ibm-column-form','<%= keyops %>');
		createPostForm('modPO','modPOForm','modPOForm','ibm-column-form','<%= keyops %>');
		createPostForm('delPO','delPOForm','delPOForm','ibm-column-form','<%= keyops %>');
		
		loadValues();

		<% if (!logaction.equals("")){ %>
		dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
	});
	
	dojo.addOnLoad(function() {
		// Set constraints on date fields
		dojo.connect("onmouseover", function() {
			try {
				if (onMO == false) {
		         	dijit.byId('ponumberDate').constraints.max = new Date();
		         	dijit.byId('ponumberDateMOD').constraints.max = new Date();
		         	
		         	onMO = true;
				}
			} catch (e) {
				console.log("Error setting date constraints: " + e.message);
			}
		});
	})
	
	function loadValues() {
		<% while (SuppliesReplaced_RS.next()) { %>
				addMultiOption('suppliesReplacedCurrent','<%= SuppliesReplaced_RS.getString("SUPPLY_NAME") %>','<%= SuppliesReplaced_RS.getInt("KO_REQUEST_SUPPLYID") %>');
		<% } 
		
		while (SuppliesView_RS.next()) { %>
				addMultiOption('suppliesReplaced','<%= SuppliesView_RS.getString("SUPPLY_NAME") %>','<%= SuppliesView_RS.getString("SUPPLY_NAME") %>');
		<% } 
	
		while (PartsReplaced_RS.next()) { %>
				addMultiOption('partsReplacedCurrent','<%= PartsReplaced_RS.getString("PART_NAME") %>','<%= PartsReplaced_RS.getInt("KO_REQUEST_PARTSID") %>');
	 	<% }
	 	
	 	while (PartsView_RS.next()) { %>
	 			addMultiOption('partsReplaced','<%= PartsView_RS.getString("PART_NAME") %>','<%= PartsView_RS.getString("PART_NAME") %>');
		<% }
		
		while (PartsAdded_RS.next()) { %>
				addMultiOption('partsAddedCurrent','<%= PartsAdded_RS.getString("PART_NAME") %>','<%= PartsAdded_RS.getInt("KO_REQUEST_PARTSID") %>');
		<% }

		while (PartsView2_RS.next()) { %>
				addMultiOption('partsAdded','<%= PartsView2_RS.getString("PART_NAME") %>','<%= PartsView2_RS.getString("PART_NAME") %>');
		<% } %>
	}
	
	function showPOOverlay() {
		ibmweb.overlay.show('poOverlay', this);
	}
	
	function showModPOOverlay(poid, ponumber, podate) {
		dojo.byId("ponumberMOD").value = ponumber;
		dojo.byId("poid").value = poid;
		dojo.byId("ponumberDateMOD").value = podate.substring(0,10);
		dojo.byId("ponumberHourMOD").value = podate.substring(11,13);
		dojo.byId("ponumberMinMOD").value = podate.substring(14,16);
		ibmweb.overlay.show('poModOverlay', this);
	}

	function updateMaterials() {
		var status = '<%= sStatus %>';
		if(status == 'completed') {
			alert('<%= messages.getString("cannot_close_ticket") %>');
			return false;
		} else if (validatePartsSupplies() == false) {
			return false;
		} else {
			document.theForm.submitvalue.value = "updateMaterials";
			submitForm();
		}
	}
	
	function validatePartsSupplies() {
		if(document.theForm.partsReplaced.value == "Other" && (document.theForm.partsReplacedOther.value == null || document.theForm.partsReplacedOther.value == '')) {
			alert('<%= messages.getString("parts_replaced_fill_in_value") %>');
			return false;
		} else {
			return true;
		}
	}
	
	function hidePOFields() {
		document.getElementById("ponumdate").style.display = "none";
		document.getElementById("potext").style.display = "";
	}
	function showPOFields() {
		document.getElementById("ponumdate").style.display = "";
		document.getElementById("potext").style.display = "none";
	}
	
	function validatePO() {
		if(dojo.byId("ponumberDate") == null || dojo.byId("ponumberDate") == "") {
			alert('<%= messages.getString("required_info") %>');
		} else if(dojo.byId("ponumberHour") == null || dojo.byId("ponumberHour") == "") {
			alert('<%= messages.getString("required_info") %>');
		} else if(dojo.byId("ponumberMin") == null || dojo.byId("ponumberMin") == "") {
			alert('<%= messages.getString("required_info") %>');
        } else {
        	return true;
        }
    }
	
	function validateModPO() {
		if(dojo.byId("ponumberDateMOD") == null || dojo.byId("ponumberDateMOD") == "") {
			alert('<%= messages.getString("required_info") %>');
		} else if(dojo.byId("ponumberHourMOD") == null || dojo.byId("ponumberHourMOD") == "") {
			alert('<%= messages.getString("required_info") %>');
		} else if(dojo.byId("ponumberMinMOD") == null || dojo.byId("ponumberMinMOD") == "") {
			alert('<%= messages.getString("required_info") %>');
        } else {
        	return true;
        }
    }
	
	function addPO() {
		if(dojo.byId("ponumberHour").value.length == 1) {
			dojo.byId("ponumberHour").value = "0" + dojo.byId("ponumberHour").value;
		}
		if(dojo.byId("ponumberMin").value.length == 1) {
			dojo.byId("ponumberMin").value = "0" + dojo.byId("ponumberMin").value;
		}

		if (validatePO() == false) {
			return false;
		} else {
			var podatevalue = dojo.byId("ponumberDate").value + "-" + dojo.byId("ponumberHour").value + "." + dojo.byId("ponumberMin").value + ".00.00";
			document.addPOForm.podate.value = podatevalue;
			document.addPOForm.next_page_id.value = "2047";
			dojo.byId("addPOForm").submit();
			return true;
		}
	}
	
	function modPO() {
		if(dojo.byId("ponumberHourMOD").value.length == 1) {
			dojo.byId("ponumberHourMOD").value = "0" + dojo.byId("ponumberHourMOD").value;
		}
		if(dojo.byId("ponumberMinMOD").value.length == 1) {
			dojo.byId("ponumberMinMOD").value = "0" + dojo.byId("ponumberMinMOD").value;
		}
		if (validateModPO() == false) {
			return false;
		} else {
			var podatevalue = dojo.byId("ponumberDateMOD").value + "-" + dojo.byId("ponumberHourMOD").value + "." + dojo.byId("ponumberMinMOD").value + ".00.00";
			document.modPOForm.podate.value = podatevalue;
			document.modPOForm.next_page_id.value = "2047";
			dojo.byId("modPOForm").submit();
			return true;
		}
	}
	
	function deletePO(poid, poname) {
		var agree = confirm('<%= messages.getString("purchase_order_delete_check") %> ' + poname + '?');
		if (agree) {
			dojo.byId("next_page_id").value = "2049";
			dojo.byId("ponumber").value = poid;
			dojo.byId("logactionidDelPO").value = "<%= messages.getString("purchase_order_delete_success") %>";
			dojo.byId("vendorid").value = <%= vendorid %>;
			dojo.byId("delPOForm").submit();
		} else {
			return false;
		}
	}
	
	function cancelForm() {
		self.location.href = "<%= keyops %>?next_page_id=2017&ticketno=<%= iTicketNo %>";
	}
	
	function submitForm() {
		document.theForm.submit();
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
			<h1><%= messages.getString("update_parts_supplies_ticket") %>&nbsp;<%= iTicketNo %></h1>
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
					<div id="response"></div>
					<div id="Keyop">
						<div id='nextpageid'></div>
						<div id='logactionid'></div>
						<div id='submitvalue'></div>
						<div id='ticketno'></div>

						<h3><%= messages.getString("parts_and_supplies") %></h3>
						<p><%= messages.getString("parts_and_supplies_note") %><br /><br /></p>
						<table width="98%" class="ibm-data-table" cellpadding="0" border="0" summary="A list of parts and supplies that have been added and/or replaced in this request.">
							<thead>
							<tr>
								<th scope="col"><%= messages.getString("name") %></th>
								<th scope="col"><%= messages.getString("current_value") %></th>
								<th scope="col"><%= messages.getString("value_options") %></th>
								<th scope="col"><%= messages.getString("other_values") %></th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<th scope="row" class="ibm-table-row"><label for="suppliesreplaced"><%= messages.getString("supplies_replaced") %>:</label></th>
								<td>
									<div id="suppliesReplacedCurrentloc"></div>
								</td>
								<td>
									<div id="suppliesReplacedloc"></div>
								</td>
								<td><label for="othersupply"><%= messages.getString("if_other") %>:</label> <input type="text" name="suppliesReplacedOther" id="othersupply"/></td>
							</tr>
							<tr>
								<th scope="row" class="ibm-table-row"><label for="partsreplaced"><%= messages.getString("parts_replaced") %>:</label></th>
								<td>
									<div id="partsReplacedCurrentloc"></div>
								</td>
								<td>
									<div id="partsReplacedloc"></div>
								</td>
								<td><label for="otherpartreplaced"><%= messages.getString("if_other") %>:</label> <input type="text" name="partsReplacedOther" id="otherpartreplaced"/></td>
							</tr>
							<tr>
								<th scope="row" class="ibm-table-row"><label for="partsadded"><%= messages.getString("parts_added") %>:</label></th>
								<td>
									<div id="partsAddedCurrentloc"></div>
								</td>
								<td>
									<div id="partsAddedloc"></div>
								</td>
								<td><label for="otherpartordered"><%= messages.getString("if_other") %>:</label> <input type="text" name="partsAddedOther" id="otherpartordered"/></td>
							</tr>
							<tr class="gray">
								<th scope="row" class="ibm-table-row"><label for="bondreqnum"><%= messages.getString("bond_req_num") %>:</label></th>
								<td><div id="bondreqnum"></div></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</table>
						<br />
						<div class="ibm-buttons-row" align="right">
							<div id="submit_add_button"></div>
						</div>
					</div> <!-- END KEYOP FORM -->
					<h3><%= messages.getString("purchase_order") %></h3>
					<div id="delPO">
 						<div id='nextpageidDelPO'></div>
						<div id='ticketnoDelPO'></div>
 						<div id='logactionidDelPO'></div>
 						<div id='ponumberDelPO'></div>
 						<div id='vendoridLoc'></div>
						<table width="98%" class="ibm-data-table" cellpadding="0" border="0" summary="A list of purchase orders for this keyop request">
							<thead>
							<tr>
								<th scope="col"><%= messages.getString("po_number") %></th>
								<th scope="col"><%= messages.getString("po_date") %></th>
								<th scope="col"><%= messages.getString("delete") %></th>
							</tr>
							</thead>
							<tbody>
							<% int iGray2 = 0;
								while (PurchaseOrderView_RS.next()) {  %>
									<tr>
										<td><a href="javascript:showModPOOverlay('<%= PurchaseOrderView_RS.getInt("KO_REQUEST_PURCHASE_ORDERID") %>','<%= PurchaseOrderView_RS.getString("PURCHASE_ORDER_NUMBER") %>','<%= dateTime.convertTimeZoneFromUTC(PurchaseOrderView_RS.getTimeStamp("PURCHASE_ORDER_DATE") + "",pupb.getTimeZone()) %>')"><%= PurchaseOrderView_RS.getString("PURCHASE_ORDER_NUMBER") %></a></td>
										<td><%= dateTime.formatTime(dateTime.convertTimeZoneFromUTC(PurchaseOrderView_RS.getTimeStamp("PURCHASE_ORDER_DATE") + "",pupb.getTimeZone())) %></td>
										<td><a class="ibm-cancel-link" href="javascript:deletePO('<%= PurchaseOrderView_RS.getInt("KO_REQUEST_PURCHASE_ORDERID") %>','<%= PurchaseOrderView_RS.getString("PURCHASE_ORDER_NUMBER") %>')" ><%= messages.getString("delete") %></a></td>
									</tr>
							<% } %>
							</tbody>
						</table>
					</div>
					<p id="potext"><a href="javascript:showPOOverlay()"><%= messages.getString("add_new_purchase_order") %></a></p>
											
					<!-- PO OVERLAY STARTS HERE -->
					<div class="ibm-common-overlay" id="poOverlay">
						<div class="ibm-head">
							<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
						</div>
						<div class="ibm-body">
							<div class="ibm-main">
								<div class="ibm-title ibm-subtitle">
									<h1><%= messages.getString("add_new_purchase_order") %></h1>
								</div>
								<div class="ibm-container ibm-alternate ibm-buttons-last">
									<div class="ibm-container-body">
										<p class="ibm-overlay-intro"><%= messages.getString("required_info") %></p>
										<div id="addPO">	
											<div id='nextpageidPO'></div>
											<div id='logactionidPO'></div>
											<div id='submitvaluePO'></div>
											<div id='ticketnoPO'></div>
											<div id='podate'></div>

											<p>
 												<label for="ponumber"><%= messages.getString("po_number") %>:<span class='ibm-required isRequired'>*</span></label>
 												<span><input type="text" name="ponumber" id="ponumber" size="24" maxlength="32" /></span>
 											</p>
											<p>
												<label for="ponumberDate"><%= messages.getString("po_number") %>&nbsp;<%= messages.getString("date") %>:<span class='ibm-required isRequired'>*</span><span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
												<span><input type="text" class="ibm-date-picker" name="ponumberDate" id="ponumberDate" value="" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
											</p>
											<p>
												<span><input type="text" name="ponumberHour" id="ponumberHour" size="2" maxlength="2" value=""/>:<input type="text" name="ponumberMin" id="ponumberMin" size="2" maxlength="2" value=""/> (<%= messages.getString("hh_mm_24hour") %>)</span>
											</p>
											<div class="ibm-overlay-rule"><hr /></div>
											<div class="ibm-buttons-row" align="right">
												<div id="submit_po_button"></div>
											</div>
										</div> <!--  END addPO FORM -->
									</div>
								</div>
							</div>
						</div>
						<div class="ibm-footer"></div>
					</div>
					<!-- PO OVERLAY ENDS HERE -->
					
					<!-- MOD PO OVERLAY STARTS HERE -->
					<div class="ibm-common-overlay" id="poModOverlay">
						<div class="ibm-head">
							<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
						</div>
						<div class="ibm-body">
							<div class="ibm-main">
								<div class="ibm-title ibm-subtitle">
									<h1><%= messages.getString("modify_purchase_order") %></h1>
								</div>
								<div class="ibm-container ibm-alternate ibm-buttons-last">
									<div class="ibm-container-body">
										<p class="ibm-overlay-intro"><%= messages.getString("required_info") %></p>
										<div id="modPO">	
											<div id='nextpageidModPO'></div>
											<div id='logactionidModPO'></div>
											<div id='submitvalueModPO'></div>
											<div id='ticketnoModPO'></div>
											<div id='podateMOD'></div>
											<div id='poidMOD'></div>
											<p>
 												<label for="ponumber"><%= messages.getString("po_number") %>:<span class='ibm-required isRequired'>*</span></label>
 												<span><input type="text" name="ponumberMOD" id="ponumberMOD" size="24" maxlength="32" value=""/></span>
 											</p>
											<p>
												<label for="ponumberDateMOD"><%= messages.getString("po_number") %>&nbsp;<%= messages.getString("date") %>:<span class='ibm-required isRequired'>*</span><span class="ibm-access ibm-date-format">y-MM-dd</span></label> 
												<span><input type="text" class="ibm-date-picker" name="ponumberDateMOD" id="ponumberDateMOD" value="" /> (<%= messages.getString("yyyy-mm-dd") %>)</span>
											</p>
											<p>
												<span><input type="text" name="ponumberHourMOD" id="ponumberHourMOD" size="2" maxlength="2" value=""/>:<input type="text" name="ponumberMinMOD" id="ponumberMinMOD" size="2" maxlength="2" value=""/> (<%= messages.getString("hh_mm_24hour") %>)</span>
											</p>
											<div class="ibm-overlay-rule"><hr /></div>
											<div class="ibm-buttons-row" align="right">
												<div id="submit_modpo_button"></div>
											</div>
										</div> <!--  END addPO FORM -->
									</div>
								</div>
							</div>
						</div>
						<div class="ibm-footer"></div>
					</div>
					<!-- MOD PO OVERLAY ENDS HERE -->
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>