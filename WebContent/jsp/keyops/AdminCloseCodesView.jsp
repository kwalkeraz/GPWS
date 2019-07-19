<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminCloseCodesView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminCloseCodesView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminCloseCodesView_RS = AdminCloseCodesView.getResults();

	AppTools apptool = new AppTools();
	String logaction = apptool.nullStringConverter(request.getParameter("logaction"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin close codes view"/>
<meta name="Description" content="<%= messages.getString("close_codes_page_desc") %>" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("admin_closecode") %></title>
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
dojo.require("dijit.form.Button");

	function submitForm() {
		dojo.byId("theForm").submit();
	}

	dojo.ready(function() {
		createHiddenInput('nextpageid','next_page_id','');
		createHiddenInput('nextpageidA','next_page_id','');
		createHiddenInput('nextpageidE','next_page_id','');
		createHiddenInput('closecode_id','closecodeid','');
		createHiddenInput('closecode_idE','closecodeidE','');
		createHiddenInput('logactionid','logaction','');
		createHiddenInput('logactionidA','logaction','');
		createHiddenInput('logactionidE','logaction','');
		createTextInput('closecodenameadd','closecodenameadd','closecodenameadd','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('closecodenameE','closecodenameE','closecodenameE','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');

		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callAdd()');
			createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("addCloseCodeOverlay", this);');
		createInputButton('submit_edit_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callEdit()');
			createSpan('submit_edit_button','ibm-sep');
		createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("editCloseCodeOverlay", this);');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		createPostForm('addCloseCode', 'addCloseCodeForm', 'addCloseCodeForm', 'ibm-column-form', '<%= keyops %>');
		createPostForm('editCloseCode', 'editCloseCodeForm', 'editCloseCodeForm', 'ibm-column-form', '<%= keyops %>');

		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
	});
	
	function callDelete(closecodeid,closecodename) {
		var msg = "CloseCode " + closecodename + " has been deleted";
		nextpage = "3077d";
		dojo.byId("next_page_id").value = nextpage;
		dojo.byId("closecodeid").value = closecodeid;
		dojo.byId("logaction").value = msg;
		var agree = confirm('<%= messages.getString("close_code_delete_check") %> ' + closecodename + '?');
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
		var closecodename = dojo.byId("closecodenameadd").value;
		var msg = "CloseCode " + closecodename + " has been added";
		nextpage = "3077a";
		document.addCloseCodeForm.next_page_id.value = nextpage;
		document.addCloseCodeForm.logaction.value = msg;
		validForm = dijit.byId("addCloseCodeForm").validate();
		if (validForm) {
			dojo.byId("addCloseCodeForm").submit();
		} else {
			return false;
		}
	}
	
	function showEdit(closecodeid, closecodename) {
		document.editCloseCodeForm.closecodeidE.value = closecodeid;
		document.editCloseCodeForm.closecodenameE.value = closecodename;
		ibmweb.overlay.show('editCloseCodeOverlay', this);
		//return false;
	}
	
	function callEdit() {
		var closecodename = dojo.byId("closecodenameE").value;
		var msg = "CloseCode " + closecodename + " has been edited";
		nextpage = "3077e";
		document.editCloseCodeForm.next_page_id.value = nextpage;
		document.editCloseCodeForm.logaction.value = msg;
		validForm = dijit.byId("editCloseCodeForm").validate();
		if (validForm) {
			dojo.byId("editCloseCodeForm").submit();
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
				<h1><%= messages.getString("admin_closecode") %></h1>
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
							<li><a href="#addCloseCodeOverlay" onclick="ibmweb.overlay.show('addCloseCodeOverlay', this);"><%= messages.getString("add_a_close_code") %></a></li>
						</ul>
						<br />
						<div id="Keyop">
							<div id='nextpageid'></div>
							<div id="closecode_id"></div>
							<div id='logactionid'></div>
							<div id="response"></div>
							<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_keyop_close_codes") %>">
								<caption><em><%= messages.getString("all_close_codes") %></em></caption>
								<thead>
									<tr>
										<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("close_code_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
										<th scope="col"><%= messages.getString("delete") %></th>
									</tr>
								</thead>
								<tbody>
							<%
								keyopTools tool = new keyopTools();
								int numCloseCodes = 0;
								while (AdminCloseCodesView_RS.next()) { %>
									<tr>
										<td scope="row"><input type="hidden" name="closecodeid<%= numCloseCodes %>" id="closecodeid" value='<%= AdminCloseCodesView_RS.getInt("CLOSE_CODEID") %>'/><a class="ibm-signin-link" href="javascript:showEdit('<%= AdminCloseCodesView_RS.getInt("CLOSE_CODEID") %>','<%= tool.nullStringConverter(AdminCloseCodesView_RS.getString("CLOSE_CODE_NAME")) %>')"><%= tool.nullStringConverter(AdminCloseCodesView_RS.getString("CLOSE_CODE_NAME")) %></a></td>
										<td align="center">
											<a class="ibm-cancel-link" href="javascript:callDelete('<%= AdminCloseCodesView_RS.getInt("CLOSE_CODEID") %>','<%= tool.nullStringConverter(AdminCloseCodesView_RS.getString("CLOSE_CODE_NAME")) %>')" ><%= messages.getString("delete") %></a>
										</td>
									</tr>
							<%		numCloseCodes++; 
								} %>
								</tbody>
							</table>
							<%	if (numCloseCodes == 0) { %>
									<p><%= messages.getString("no_close_codes_found") %></p>
							<%	} else { %>
									<p><%= numCloseCodes %> <%= messages.getString("close_codes_found") %>.</p>
							<%	}
							%>
						</div> <!--  theForm end-->
						
						<!-- ADD CLOSE_CODE OVERAL STARTS HERE -->
						<div class="ibm-common-overlay" id="addCloseCodeOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("add_a_close_code") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("enter_close_code_name") %>&nbsp;<%= messages.getString("required_info") %></p>
											
											<div id="addCloseCode">
												<div id='nextpageidA'></div>
												<div id='logactionidA'></div>
												<div class="pClass"><label for="closecodenameadd"><%= messages.getString("close_code_name") %>:<span class="ibm-required">*</span></label><span><div id="closecodenameadd"></div></span></div>
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
						<!-- ADD CLOSE_CODE OVERLAY ENDS HERE -->
						
						<!-- EDIT CLOSE_CODE OVERAL STARTS HERE -->
						<div class="ibm-common-overlay" id="editCloseCodeOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("edit_close_code") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("required_info") %></p>
											
											<div id="editCloseCode">
												<div id='nextpageidE'></div>
												<div id='logactionidE'></div>
												<div id='closecode_idE'></div>
												<div class="pClass"><label for="closecodenameE"><%= messages.getString("close_code_name") %>:<span class="ibm-required">*</span></label><span><div id="closecodenameE"></div></span></div>
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
						<!-- EDIT CLOSE_CODE OVERLAY ENDS HERE -->
						
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>