<%	
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	TableQueryBhvr CategoryView  = (TableQueryBhvr) request.getAttribute("Category");
	TableQueryBhvrResultSet Category_RS = CategoryView.getResults();
	String category = "";
	String description = "";
	int categoryid = 0;
	
	while(Category_RS.next()) {
		category = tool.nullStringConverter(Category_RS.getString("CATEGORY_NAME"));
		description = tool.nullStringConverter(Category_RS.getString("DESCRIPTION"));
		categoryid = Category_RS.getInt("CATEGORYID");
	} //
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print category edit"/>
	<meta name="Description" content="Global print website edit a category page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("category_edit") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="/tools/print/js/createButton.js"></script>
	<script type="text/javascript" src="/tools/print/js/createSelect.js"></script>
	<script type="text/javascript" src="/tools/print/js/createInput.js"></script>
	<script type="text/javascript" src="/tools/print/js/createTextArea.js"></script>
	<script type="text/javascript" src="/tools/print/js/createForm.js"></script>
	<script type="text/javascript" src="/tools/print/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.Textarea");
	 dojo.require("dijit.form.CheckBox");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7002";
	 } //cancelForm
	 
	 function addCategory() {
	 	var formName = dijit.byId("CategoryForm");
        var formValid = false;
        var wName = dijit.byId("category").get('value');
        var description = dijit.byId('description').get('value').replace(/(\r\n|[\r\n])/g, "").trim();
        dijit.byId('description').set('value',description);
        var logactionid = dojo.byId('logaction');
        var logaction = "Category " + wName + " has been updated";
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
		if (formValid) {
			if (submitForm('CategoryForm',msg)) {
				//location.reload();
				AddParameterRedirect("<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7002", logactionid.name, logactionid.value);
			}
		} else {
			return false;
		}
	}; //addCategory
	 
	 function submitForm(form,msg){
	 	var submitted = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           sync: true,
               preventCache: true,
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Category name already exists.  Please use different name.'+"</p>";
	   				submitted = false;
	   				dijit.byId('category').focus();
	   			} else if (data.indexOf("Unknown") > -1) {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'There was an error in the request'+"</p>";
	   				submitted = false;
	   			} else {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				//location.reload();
	   			};
	           },
	           error: function(error, ioArgs) {
	           	console.log(error);
	               dojo.byId("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           },
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
	 } //submitForm
	 
	 dojo.ready(function() {
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '7006');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','categoryid','<%= categoryid %>');
        createpTag();
        createTextInput('category','category','category','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;,()\/-]*$','<%= category %>');
        createTextArea('description', 'description', '', '<%= description %>');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_category','addCategory()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_category','cancelForm()');
     	createPostForm('Category','CategoryForm','CategoryForm','ibm-column-form','<%= prtgateway %>');
     	changeInputTagStyle("250px");
     	dojo.style("description", {
          "width": "250px"
		});
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('category').focus();
     });
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7002"><%= messages.getString("administer_category") %></a></li>
			</ul>
			<h1><%= messages.getString("category_edit") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			<p>
				<%= messages.getString("required_info") %>
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<div id='Category'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='category'><%= messages.getString("category_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='category'></div></span>
				</div>
				<div class="pClass">
					<label for='description'><%= messages.getString("description") %>:</label>
					<span><div id='description'></div></span>
				</div>
				<div class='ibm-overlay-rule'><hr /></div>
				<div class='ibm-buttons-row'>
					<div class="pClass">
					<span>
					<div id='submit_add_button'></div>
					</span>
					</div>
				</div>
			</div>
			
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>