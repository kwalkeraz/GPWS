<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminPartsView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminPartsView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminPartsView_RS = AdminPartsView.getResults();
	
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
<meta name="keywords" content="Global Print, keyop, admin parts view"/>
<meta name="Description" content="<%= messages.getString("parts_page_desc") %>" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("admin_parts") %></title>
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
		createHiddenInput('part_id','partid','');
		createHiddenInput('part_idE','partidE','');
		createHiddenInput('vendoridloc','vendorid','<%= iKOCompanyID %>');
		createHiddenInput('vendoridE','vendoridE','');
		createHiddenInput('logactionid','logaction','');
		createHiddenInput('logactionidA','logaction','');
		createHiddenInput('logactionidE','logaction','');
		createTextInput('partnameadd','partnameadd','partnameadd','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','[^+*\\^`~\'\"\\{\\}\\[\\]!@#%\\\\&\\$|\\<\\>;=,?]*$','');
		createTextInput('partnameE','partnameE','partnameE','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','[^+*\\^`~\'\"\\{\\}\\[\\]!@#%\\\\&\\$|\\<\\>;=,?]*$','');
		<% if (isSuperUser == true) { %>
			createSelect('vendorA', 'vendorA', '<%= messages.getString("please_select_option") %>', '0', 'vendorAddloc');
			createSelect('vendorE', 'vendorE', '<%= messages.getString("please_select_option") %>', '0', 'vendorEditloc');
			loadVendorValues();
			changeSelectStyle('200px');
		<% } %>
		
		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callAdd()');
			createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("addPartOverlay", this);');
		createInputButton('submit_edit_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callEdit()');
			createSpan('submit_edit_button','ibm-sep');
		createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("editPartOverlay", this);');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		createPostForm('addPart', 'addPartForm', 'addPartForm', 'ibm-column-form', '<%= keyops %>');
		createPostForm('editPart', 'editPartForm', 'editPartForm', 'ibm-column-form', '<%= keyops %>');

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
	
	function callDelete(partid,partname) {
		var msg = "Part " + partname + " has been deleted";
		nextpage = "3075d";
		dojo.byId("next_page_id").value = nextpage;
		dojo.byId("partid").value = partid;
		dojo.byId("logaction").value = msg;
		var agree = confirm('<%= messages.getString("part_delete_check") %> ' + partname + '?');
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
		var partname = dojo.byId("partnameadd").value;
		var msg = "Part " + partname + " has been added";
		nextpage = "3075a";
		document.addPartForm.next_page_id.value = nextpage;
		document.addPartForm.logaction.value = msg;
		<% if (isSuperUser == true) { %>
			document.addPartForm.vendorid.value = document.addPartForm.vendorA.value;
		<% } %>
		validForm = dijit.byId("addPartForm").validate();
		if (validForm) {
			dojo.byId("addPartForm").submit();
		} else {
			return false;
		}
	}
	
	function showEdit(partid, partname, vendorid) {
		document.editPartForm.partidE.value = partid;
		document.editPartForm.partnameE.value = partname;
		<% if (isSuperUser == true) { %>
			autoSelectValue('vendorE',vendorid);
		<% } %>
		ibmweb.overlay.show('editPartOverlay', this);
		//return false;
	}
	
	function callEdit() {
		var partname = dojo.byId("partnameE").value;
		var msg = "Part " + partname + " has been edited";
		nextpage = "3075e";
		var vendorid = <%= iKOCompanyID %>;
		document.editPartForm.next_page_id.value = nextpage;
		document.editPartForm.logaction.value = msg;
		<% if (isSuperUser == true) { %>
			document.editPartForm.vendoridE.value = document.editPartForm.vendorE.value;
		<% } else { %>
			document.editPartForm.vendoridE.value = vendorid;
		<% } %>
		validForm = dijit.byId("editPartForm").validate();
		if (validForm) {
			dojo.byId("editPartForm").submit();
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
				<h1><%= messages.getString("admin_parts") %></h1>
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
							<li><%= messages.getString("edit_a_part") %></li>
							<li><%= messages.getString("delete_a_part") %></li>
							<li><a href="#addPartOverlay" onclick="ibmweb.overlay.show('addPartOverlay', this);"><%= messages.getString("add_a_part") %></a></li>
						</ul>
						<br />
						<div id="Keyop">
							<div id='nextpageid'></div>
							<div id="part_id"></div>
							<div id='logactionid'></div>
							<div id="response"></div>
							<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_keyop_parts") %>">
								<caption><em><%= messages.getString("all_parts") %></em></caption>
								<thead>
									<tr>
										<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("part_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
										<% if (isSuperUser == true) { %>
											<th scope="col"><%= messages.getString("vendor") %></th>
										<% } %>
										<th scope="col"><%= messages.getString("delete") %></th>
									</tr>
								</thead>
								<tbody>
							<%
								//keyopTools tool = new keyopTools();
								int numParts = 0;
								while (AdminPartsView_RS.next()) {
									if (AdminPartsView_RS.getInt("VENDORID") == iKOCompanyID || isSuperUser == true) { %>
									<tr>
										<td scope="row"><input type="hidden" name="partid<%= numParts %>" id="partid" value='<%= AdminPartsView_RS.getInt("PARTID") %>'/><a class="ibm-signin-link" href="javascript:showEdit('<%= AdminPartsView_RS.getInt("PARTID") %>','<%= tool.nullStringConverter(AdminPartsView_RS.getString("PART_NAME")) %>','<%= AdminPartsView_RS.getInt("VENDORID") %>')"><%= tool.nullStringConverter(AdminPartsView_RS.getString("PART_NAME")) %></a></td>
										<% if (isSuperUser == true) { %>
											<td><%= tool.nullStringConverter(AdminPartsView_RS.getString("VENDOR_NAME")) %></td>
										<% } %>
										<td><a class="ibm-cancel-link" href="javascript:callDelete('<%= AdminPartsView_RS.getInt("PARTID") %>','<%= tool.nullStringConverter(AdminPartsView_RS.getString("PART_NAME")) %>')" ><%= messages.getString("delete") %></a></td>
									</tr>
							<%		numParts++;
									}
								} %>
								</tbody>
							</table>
							<%	if (numParts == 0) { %>
									<p><%= messages.getString("no_parts_found") %></p>
							<%	} else { %>
									<p><%= numParts %> <%= messages.getString("parts_found") %>.</p>
							<%	}
							%>
						</div> <!--  theForm end-->
						
						<!-- ADD PART OVERLAY STARTS HERE -->
						<div class="ibm-common-overlay" id="addPartOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("add_part") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("enter_part_name") %>&nbsp;<%= messages.getString("required_info") %></p>
											
											<div id="addPart">
												<div id='nextpageidA'></div>
												<div id='logactionidA'></div>
												<div id='vendoridloc'></div>
												<div class="pClass"><label for="partnameadd"><%= messages.getString("part_name") %>:<span class="ibm-required">*</span></label><span><div id="partnameadd"></div></span></div>
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
						
<!-- 							<div class="ibm-footer"></div> -->
						</div>
						<!-- ADD PART OVERLAY ENDS HERE -->
						
						<!-- EDIT PART OVERLAY STARTS HERE -->
						<div class="ibm-common-overlay" id="editPartOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("edit_part") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("required_info") %></p>
											
											<div id="editPart">
												<div id='nextpageidE'></div>
												<div id='logactionidE'></div>
												<div id='part_idE'></div>
												<div id='vendoridE'></div>
												<div class="pClass"><label for="partnameE"><%= messages.getString("part_name") %>:<span class="ibm-required">*</span></label><span><div id="partnameE"></div></span></div>
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
						<!-- EDIT PART OVERLAY ENDS HERE -->
						
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>