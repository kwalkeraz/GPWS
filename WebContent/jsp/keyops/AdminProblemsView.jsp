<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminProblemsView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminProblemsView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminProblemsView_RS = AdminProblemsView.getResults();

	AppTools apptool = new AppTools();
	String logaction = apptool.nullStringConverter(request.getParameter("logaction"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin problems view"/>
<meta name="Description" content="<%= messages.getString("problems_page_desc") %>" />
<title><%= messages.getString("global_print") %> | <%= messages.getString("admin_problems") %></title>
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
		createHiddenInput('problem_id','problemid','');
		createHiddenInput('problem_idE','problemidE','');
		createHiddenInput('logactionid','logaction','');
		createHiddenInput('logactionidA','logaction','');
		createHiddenInput('logactionidE','logaction','');
		createTextInput('problemnameadd','problemnameadd','problemnameadd','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');
		createTextInput('problemnameE','problemnameE','problemnameE','128',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _]*$','');

		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callAdd()');
			createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("addProblemOverlay", this);');
		createInputButton('submit_edit_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','callEdit()');
			createSpan('submit_edit_button','ibm-sep');
		createInputButton('submit_edit_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','ibmweb.overlay.hide("editProblemOverlay", this);');
		createPostForm('Keyop','theForm','theForm','ibm-column-form','<%= keyops %>');
		createPostForm('addProblem', 'addProblemForm', 'addProblemForm', 'ibm-column-form', '<%= keyops %>');
		createPostForm('editProblem', 'editProblemForm', 'editProblemForm', 'ibm-column-form', '<%= keyops %>');

		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } %>
	});
	
	function callDelete(problemid,problemname) {
		var msg = "Problem " + problemname + " has been deleted";
		nextpage = "3073d";
		dojo.byId("next_page_id").value = nextpage;
		dojo.byId("problemid").value = problemid;
		dojo.byId("logaction").value = msg;
		var agree = confirm('<%= messages.getString("problem_delete_check") %> ' + problemname + '?');
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
		var problemname = dojo.byId("problemnameadd").value;
		var msg = "Problem " + problemname + " has been added";
		nextpage = "3073a";
		document.addProblemForm.next_page_id.value = nextpage;
		document.addProblemForm.logaction.value = msg;
		validForm = dijit.byId("addProblemForm").validate();
		if (validForm) {
			dojo.byId("addProblemForm").submit();
		} else {
			return false;
		}
	}
	
	function showEdit(problemid, problemname) {
		document.editProblemForm.problemidE.value = problemid;
		document.editProblemForm.problemnameE.value = problemname;
		ibmweb.overlay.show('editProblemOverlay', this);
		//return false;
	}
	
	function callEdit() {
		var problemname = dojo.byId("problemnameE").value;
		var msg = "Problem " + problemname + " has been edited";
		nextpage = "3073e";
		document.editProblemForm.next_page_id.value = nextpage;
		document.editProblemForm.logaction.value = msg;
		validForm = dijit.byId("editProblemForm").validate();
		if (validForm) {
			dojo.byId("editProblemForm").submit();
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
				<h1><%= messages.getString("admin_problems") %></h1>
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
							<li><%= messages.getString("edit_a_problem") %></li>
							<li><%= messages.getString("delete_a_problem") %></li>
							<li><a href="#addProblemOverlay" onclick="ibmweb.overlay.show('addProblemOverlay', this);"><%= messages.getString("add_a_problem") %></a></li>
						</ul>
						<br />
						<div id="Keyop">
							<div id='nextpageid'></div>
							<div id="problem_id"></div>
							<div id='logactionid'></div>
							<div id="response"></div>
							<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="<%= messages.getString("list_of_keyop_problems") %>">
								<caption><em><%= messages.getString("all_problems") %></em></caption>
								<thead>
									<tr>
										<th scope="col" class="ibm-sort"><a href=""><span><%= messages.getString("problem_name") %></span><span class="ibm-icon">&nbsp;</span></a></th>
										<th scope="col"><%= messages.getString("delete") %></th>
									</tr>
								</thead>
								<tbody>
							<%
								keyopTools tool = new keyopTools();
								int numProblems = 0;
								while (AdminProblemsView_RS.next()) { %>
									<tr>
										<td scope="row"><input type="hidden" name="problemid<%= numProblems %>" id="problemid" value='<%= AdminProblemsView_RS.getInt("KEYOP_PROBLEMID") %>'/><a class="ibm-signin-link" href="javascript:showEdit('<%= AdminProblemsView_RS.getInt("KEYOP_PROBLEMID") %>','<%= tool.nullStringConverter(AdminProblemsView_RS.getString("PROBLEM_NAME")) %>')"><%= tool.nullStringConverter(AdminProblemsView_RS.getString("PROBLEM_NAME")) %></a></td>
										<td align="center">
											<a class="ibm-cancel-link" href="javascript:callDelete('<%= AdminProblemsView_RS.getInt("KEYOP_PROBLEMID") %>','<%= tool.nullStringConverter(AdminProblemsView_RS.getString("PROBLEM_NAME")) %>')" ><%= messages.getString("delete") %></a>
										</td>
									</tr>
							<%		numProblems++; 
								} %>
								</tbody>
							</table>
							<%	if (numProblems == 0) { %>
									<p><%= messages.getString("no_problems_found") %></p>
							<%	} else { %>
									<p><%= numProblems %> <%= messages.getString("problems_found") %>.</p>
							<%	}
							%>
						</div> <!--  theForm end-->
						
						<!-- ADD PROBLEM OVERAL STARTS HERE -->
						<div class="ibm-common-overlay" id="addProblemOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("add_problem") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("enter_problem_name") %>&nbsp;<%= messages.getString("required_info") %></p>
											
											<div id="addProblem">
												<div id='nextpageidA'></div>
												<div id='logactionidA'></div>
												<div class="pClass"><label for="problemnameadd"><%= messages.getString("problem_name") %>:<span class="ibm-required">*</span></label><span><div id="problemnameadd"></div></span></div>
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
						<!-- ADD PROBLEM OVERLAY ENDS HERE -->
						
						<!-- EDIT PROBLEM OVERAL STARTS HERE -->
						<div class="ibm-common-overlay" id="editProblemOverlay">
							<div class="ibm-head">
								<p><a class="ibm-common-overlay-close" href="#close"><%= messages.getString("close_x") %></a></p>
							</div>
							<div class="ibm-body">
								<div class="ibm-main">
									<div class="ibm-title ibm-subtitle">
										<h1><%= messages.getString("edit_problem") %></h1>
									</div>
									<div class="ibm-container ibm-alternate ibm-buttons-last">
										<div class="ibm-container-body">
											<p class="ibm-overlay-intro"><%= messages.getString("required_info") %></p>
											
											<div id="editProblem">
												<div id='nextpageidE'></div>
												<div id='logactionidE'></div>
												<div id='problem_idE'></div>
												<div class="pClass"><label for="problemnameE"><%= messages.getString("problem_name") %>:<span class="ibm-required">*</span></label><span><div id="problemnameE"></div></span></div>
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
						<!-- EDIT PROBLEM OVERLAY ENDS HERE -->
						
				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>