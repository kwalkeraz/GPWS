<%	
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print add OS"/>
	<meta name="Description" content="Global print website add OS information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("os_add") %></title>
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
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function addOS() {
	 	var formName = dijit.byId("OSForm");
        var formValid = false;
        var wName = dijit.byId("osname").get('value');
        var comments = dijit.byId('comments').get('value').trim();
        var logactionid = dojo.byId('logaction');
        var logaction = "OS " + wName + " has been added";
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
		if (formValid) {
			if (submitForm('OSForm',msg)) {
				//location.reload();
				AddParameter(logactionid.name, logactionid.value);
			}
		} else {
			return false;
		}
	}; //addOS
	 
	 function submitForm(form,msg){
	 	var submitted = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           sync: true,
               preventCache: true,
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				dojo.byId("errorMsg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'OS name already exists.  Please use different name.'+"</p>";
	   				submitted = false;
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
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '241');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','submitvalue','insert');
        createpTag();
        createTextInput('osname','osname','osname','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','');
        createTextInput('osabbr','osabbr','osabbr','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','');
        createTextArea('comments', 'comments', '', '');
        createTextInput('sequencenum','sequencenum','sequencenum','2',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9]*$','');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_os','addOS()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_os','cancelForm()');
     	createPostForm('OS','OSForm','OSForm','ibm-column-form','<%= prtgateway %>');
     	changeInputTagStyle("250px");
     	dojo.style("comments", {
          "width": "250px"
		});
		dojo.style("sequencenum", {
          "width": "14px"
		});
     	<%if (!logaction.equals("")){ %>
        	dojo.byId("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        dijit.byId('osname').focus();
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
			</ul>
			<h1><%= messages.getString("os_add") %></h1>
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
			<div id='OS'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass">
					<label for='osname'><%= messages.getString("os_name") %>:<span class='ibm-required'>*</span></label>
					<span><div id='osname'></div></span>
				</div>
				<div class="pClass">
					<label for='osabbr'><%= messages.getString("os_abbr") %>:<span class='ibm-required'>*</span></label>
					<span><div id='osabbr'></div></span>
				</div>
				<div class="pClass">
					<label for='comments'><%= messages.getString("comments") %>:</label>
					<span><div id='comments'></div></span>
				</div>
				<div class="pClass">
					<label for='sequencenum'><%= messages.getString("os_sequence_number") %>:<span class='ibm-required'>*</span></label>
					<span><div id='sequencenum'></div></span>
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