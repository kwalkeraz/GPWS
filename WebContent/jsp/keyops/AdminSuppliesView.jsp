<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminSuppliesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminSuppliesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminSuppliesView_RS = AdminSuppliesView.getResults();
	
	TableQueryBhvr VendorView  = (TableQueryBhvr) request.getAttribute("VendorView");
	TableQueryBhvrResultSet VendorView_RS = VendorView.getResults();

	AppTools apptool = new AppTools();
	String logaction = apptool.nullStringConverter(request.getParameter("logaction"));
	
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	int iKOCompanyID = pupb.getVendorID();
	
	keyopTools tool = new keyopTools();
	boolean isSuperUser = tool.isValidKeyopSuperUser(pupb.getUserLoginID());
	
	int vendorid = 0;
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin supplies view"/>
<meta name="Description" content="<%= messages.getString("supplies_page_desc") %>" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("admin_supplies") %></title>
<%@ include file="metainfo2.jsp" %>
<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.Button");

	function submitForm() {
		dojo.byId("theForm").submit();
	}

	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','');
		createHiddenInput('nextpageidA','next_page_id','');
		createHiddenInput('nextpageidE','next_page_id','');
		createHiddenInput('supply_id','supplyid','');
		createHiddenInput('supply_idE','supplyidE','');
		createHiddenInput('vendoridloc','vendorid','<%= iKOCompanyID %>');
		createHiddenInput('vendoridE','vendoridE','');
		createHiddenInput('logactionid','logaction','');
		createHiddenInput('logactionidA','logaction','');
		createHiddenInput('logactionidE','logaction','');
		createTextInput('supplynameadd','supplynameadd','supplynameadd','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','[^+*\\^`~\'\"\\{\\}\\[\\]!@#%\\\\&\\$|\\<\\>;=,?]*$','');
		createTextInput('supplynameE','supplynameE','supplynameE','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','[^+*\\^`~\'\"\\{\\}\\[\\]!@#%\\\\&\\$|\\<\\>;=,?]*$','');
		<% if (isSuperUser == true) { %>
			createSelect('vendorA', 'vendorA', '<%= messages.getString("please_select_option") %>', '0', 'vendorAddloc');
			createSelect('vendorE', 'vendorE', '<%= messages.getString("please_select_option") %>', '0', 'vendorEditloc');
			loadVendorValues();
			changeSelectStyle('200px');
		<% } %>
	
		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callAdd()');
			createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("addSupplyOverlay", this);');
		createInputButton('submit_edit_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callEdit()');
			createSpan('submit_edit_button','ibm-sep');
		createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("editSupplyOverlay", this);');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		createPostForm('addSupply', 'addSupplyForm', 'addSupplyForm', 'ibm-column-form', '<%= keyops %>');
		createPostForm('editSupply', 'editSupplyForm', 'editSupplyForm', 'ibm-column-form', '<%= keyops %>');

		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
	});
	
	function loadVendorValues(){
	 	<%  while(VendorView_RS.next()) { %>
				var VendorID = "<%= VendorView_RS.getInt("VENDORID")%>";
				var VendorName = "<%= VendorView_RS.getString("VENDOR_NAME")%>";
				var vendorASelect = dijit.byId("vendorA");
				var vendorESelect = dijit.byId("vendorE");
				vendorASelect.addOption({value: VendorID, label: VendorName});
				vendorESelect.addOption({value: VendorID, label: VendorName});
		<% } //while VendorView	%>
	 } //loadVendorValues
	
	function callDelete(supplyid,supplyname) {
		var msg = "Supply " + supplyname + " has been deleted";
		nextpage = "3079d";
		dojo.byId("next_page_id").value = nextpage;
		dojo.byId("supplyid").value = supplyid;
		dojo.byId("logaction").value = msg;
		var agree = confirm('<%= messages.getString("supply_delete_check") %> ' + supplyname + '?');
		if (agree) {
			validForm = dijit.byId("theForm").validate();
			if (validForm) {
				submitForm();
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	
	function callAdd() {
		var supplyname = dojo.byId("supplynameadd").value;
		var msg = "Supply " + supplyname + " has been added";
		nextpage = "3079a";
		document.addSupplyForm.next_page_id.value = nextpage;
		document.addSupplyForm.logaction.value = msg;
		<% if (isSuperUser == true) { %>
			document.addSupplyForm.vendorid.value = document.addSupplyForm.vendorA.value;
		<% } %>
		validForm = dijit.byId("addSupplyForm").validate();
		if (validForm) {
			dojo.byId("addSupplyForm").submit();
		} else {
			return false;
		}
	}
	
	function showEdit(supplyid, supplyname, vendorid) {
		document.editSupplyForm.supplyidE.value = supplyid;
		document.editSupplyForm.supplynameE.value = supplyname;
		<% if (isSuperUser == true) { %>
			autoSelectValue('vendorE',vendorid);
		<% } %>
		ibmweb.overlay.show('editSupplyOverlay', this);
	}
	
	function callEdit() {
		var supplyname = dojo.byId("supplynameE").value;
		var msg = "Supply " + supplyname + " has been edited";
		nextpage = "3079e";
		document.editSupplyForm.next_page_id.value = nextpage;
		document.editSupplyForm.logaction.value = msg;
		<% if (isSuperUser == true) { %>
			document.editSupplyForm.vendoridE.value = document.editSupplyForm.vendorE.value;
		<% } else { %>
			document.editSupplyForm.vendoridE.value = vendorid;
		<% } %>
		validForm = dijit.byId("editSupplyForm").validate();
		if (validForm) {
			dojo.byId("editSupplyForm").submit();
		} else {
			return false;
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
				<h1><%= messages.getString("admin_supplies") %></h1>
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
						<ul class="ibm-bullet-list ibm-no-links">
							<li><%= messages.getString("edit_a_supply") %></li>
							<li><%= messages.getString("delete_a_supply") %></li>
							<li><a href="#addSupplyOverlay" onclick="ibmweb.overlay.show('addSupplyOverlay', this);"><%= messages.getString("add_a_supply") %></a></li>
						</ul>
						<br />
						<div id="Keyop">
							<div id='nextpageid'></div>
							<div id="supply_id"></div>
							<div id='logactionid'></div>
							<div id="response"></div>
							<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_keyop_supplies") %>">
								<caption><em><%= messages.getString("all_supplies") %></em></caption>
								<thead>
									<tr>
										<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("supply_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
										<% if (isSuperUser == true) { %>
											<th scope="col"><%= messages.getString("vendor") %></th>
										<% } %>
										<th scope="col"><%= messages.getString("delete") %></th>
									</tr>
								</thead>
								<tbody>
							<%
								int numSupplies = 0;
								while (AdminSuppliesView_RS.next()) { %>
									<tr>
										<td scope="row"><input type="hidden" name="supplyid<%= numSupplies %>" id="supplyid" value='<%= AdminSuppliesView_RS.getInt("SUPPLYID") %>'/><a class="ibm-signin-link" href="javascript:showEdit('<%= AdminSuppliesView_RS.getInt("SUPPLYID") %>','<%= tool.nullStringConverter(AdminSuppliesView_RS.getString("SUPPLY_NAME")) %>','<%= AdminSuppliesView_RS.getInt("VENDORID") %>')"><%= tool.nullStringConverter(AdminSuppliesView_RS.getString("SUPPLY_NAME")) %></a></td>
										<% if (isSuperUser == true) { %>
											<td><%= tool.nullStringConverter(AdminSuppliesView_RS.getString("VENDOR_NAME")) %></td>
										<% } %>
										<td><a class="ibm-cancel-link" href="javascript:callDelete('<%= AdminSuppliesView_RS.getInt("SUPPLYID") %>','<%= tool.nullStringConverter(AdminSuppliesView_RS.getString("SUPPLY_NAME")) %>')" ><%= messages.getString("delete") %></a></td>
									</tr>
							<%		numSupplies++; 
								} %>
								</tbody>
							</table>
							<%	if (numSupplies == 0) { %>
									<p><%= messages.getString("no_supplies_found") %></p>
							<%	} else { %>
									<p><%= numSupplies %> <%= messages.getString("supplies_found") %>.</p>
							<%	}
							%>
						</div> <!--  theForm end-->
						
						<!-- ADD SUPPLY OVERAL STARTS HERE -->
						<div class="ibm-common-overlay" id="addSupplyOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("add_supply") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("enter_supply_name") %>&nbsp;<%= messages.getString("required_info") %></p>
											
											<div id="addSupply">
												<div id='nextpageidA'></div>
												<div id='logactionidA'></div>
												<div id='vendoridloc'></div>
												<div class="pClass"><label for="supplynameadd"><%= messages.getString("supply_name") %>:<span class="ibm-required">*</span></label><span><div id="supplynameadd"></div></span></div>
												<% if (isSuperUser == true) { %>
													<br />
													<div class="pClass"><label for='vendor'><%= messages.getString("company") %>:<span class="ibm-required">*</span></label><span><div id='vendorAddloc'></div></span></div>
													<br />
												<% } %>
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
						
						<!-- EDIT SUPPLY OVERAL STARTS HERE -->
						<div class="ibm-common-overlay" id="editSupplyOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("edit_supply") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("required_info") %></p>
											
											<div id="editSupply">
												<div id='nextpageidE'></div>
												<div id='logactionidE'></div>
												<div id='supply_idE'></div>
												<div id='vendoridE'></div>
												<div class="pClass"><label for="supplynameE"><%= messages.getString("supply_name") %>:<span class="ibm-required">*</span></label><span><div id="supplynameE"></div></span></div>
												<% if (isSuperUser == true) { %>
													<br />
													<div class="pClass"><label for='vendor'><%= messages.getString("company") %>:<span class="ibm-required">*</span></label><span><div id='vendorEditloc'></div></span></div>
													<br />
												<% } %>
												<div class="ibm-overlay-rule"><hr /></div>
												<div class="ibm-buttons-row" align="right">
													<div id="submit_edit_button"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						
							<div class="ibm-footer"></div>
						</div>
						<!-- EDIT SUPPLY OVERLAY ENDS HERE -->
						
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>