<%
	com.ibm.aurora.bhvr.TableQueryBhvr AdminKeyopBldgView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminKeyopBldgView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminKeyopBldgView_RS = AdminKeyopBldgView.getResults();

	com.ibm.aurora.bhvr.TableQueryBhvr AdminBldgView  = (com.ibm.aurora.bhvr.TableQueryBhvr) request.getAttribute("AdminBldgView");
	com.ibm.aurora.bhvr.TableQueryBhvrResultSet AdminBldgView_RS = AdminBldgView.getResults();

	AppTools appTool = new AppTools();
	keyopTools tool = new keyopTools();
	int iUserID = 0;
	if (request.getParameter("userid") != null) {
		iUserID = Integer.parseInt(request.getParameter("userid"));
	}

	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String sError = appTool.nullStringConverter(request.getParameter("error"));
%>
<%@ include file="metainfo.jsp" %>
<meta name="keywords" content="Global Print, keyop, admin edit keyop buildings"/>
<meta name="Description" content="This page allows and admin to edit a keyop's sites." />
<title><%= messages.getString("global_print") %> | <%= messages.getString("keyop_admin_page") %> - <%= messages.getString("edit") %><%= messages.getString("keyop") %><%= messages.getString("sites") %></title>
<%@ include file="metainfo2.jsp" %>

<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/createCheckBox.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
<script type="text/javascript" src="<%= statichtmldir %>/js/keyopLocationUpdate.js"></script>

<script type="text/javascript">
dojo.require("dojo.parser");
dojo.require("dijit.Tooltip");
dojo.require("dijit.form.Select");
dojo.require("dijit.form.MultiSelect");
dojo.require("dijit.form.Textarea");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.form.Button");
	var info = new Array();
	
	dojo.ready(function() {
		createHiddenInput('nextpageidloc','next_page_id','3016');
 		createHiddenInput('submitvalueloc','submitvalue', 'edit');
 		createHiddenInput('useridloc','userid', '<%= request.getParameter("userid") %>');
 		createHiddenInput('cityidloc','cityid', '<%= request.getParameter("cityid") %>');
 		createpTag();
		createCheckBox('entiresite', 'Y', '', <%= request.getParameter("entiresite") %>, 'entiresiteloc');
		createMultiSelect('buildings','buildingsloc');
		createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','next()','submitExec()');
			createSpan('submit_add_button','ibm-sep');
		createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_login','window.close()');
		createPostForm('EditForm','EditBldg','EditBldg','ibm-column-form','<%= keyops %>');

		<%if (!logaction.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
		<% } 
		if (!sError.equals("")){ %>
			dojo.byId("response").innerHTML = "<p><a class='ibm-error-link'></a><%= sError %><br /></p>";
		<% } %>

		addBuildings();
		selectBuildings();
		changeSelectStyle('225px');
	});

	function addBuildings() {
		<% while (AdminBldgView_RS.next()) { %>
				addMultiOption('buildings','<%= AdminBldgView_RS.getString("BUILDING_NAME") %>','<%= AdminBldgView_RS.getInt("BUILDINGID") %>');
		<%	} %>
	}
	
	function selectBuildings() {
		<% while (AdminKeyopBldgView_RS.next()) { %>
				autoSelectValue('buildings','<%= AdminBldgView_RS.getInt("BUILDINGID") %>');
		<%	} %>
	}
	
	function onChangeCall(wName) {
		if (wName == 'countryid') {
			dojo.empty("availsites");
			updateMultiSite(info,'countryid','availsites','','');
		} else {
			return false;
		}
	}  //onChangeCall

	function refreshView() {
		document.RefreshForm.submit();
	}
	
	function submitExec() {
		if (!document.EditBldg.entiresite.checked) {
   			if (dojo.byId("buildings").value == null) {
   				alert("<%= messages.getString("select_building") %>");
   			} else {
   				dojo.byId("EditBldg").submit();
   			}
		} else {
			dojo.byId("EditBldg").submit();
		}
	}	
</script>
</head>
<body id="ibm-com">
<div id="ibm-top" class="ibm-popup">
	<%@ include file="mastheadPopup.jsp" %>
	<!-- LEADSPACE_BEGIN -->
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("edit") %> <%= messages.getString("keyop") %> <%= messages.getString("sites") %> </h1>
		</div> <!--  Leadspace-body -->
	</div> <!--  Leadspace-head -->
	<!-- LEADSPACE_END -->
	<!-- All the main body stuff goes here -->
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
			<!-- CONTENT_BODY -->
			<div id="ibm-content-body">
				<div id="ibm-content-main">
					<div id="DelSiteForm">
						<div id="response"></div>
							<div id="EditForm">
								<div id='nextpageidloc'></div>
								<div id='submitvalueloc'></div>
								<div id="useridloc"></div>							
								<div id="cityidloc"></div>
								<div class="pClass">
									<label for="checkbuilding"><%= messages.getString("all_buildings") %></label>
									<span><div id="entiresiteloc"></div></span>
								</div>
								<div class="pClass">
									<label for="buildings"><%= messages.getString("buildings") %>:</label>
									<span><div id="buildingsloc"></div></span>
								</div>
								<div class="ibm-overlay-rule"><hr /></div>
								<div class="ibm-buttons-row" align="right">
									<div id="submit_add_button"></div>
								</div>
							</div>
						</div>
					</div><!-- CONTENT_MAIN END -->
				</div><!-- CONTENT_BODY END -->
			</div><!-- END ibm-content -->
		</div>
	</div>
</body>
</html>