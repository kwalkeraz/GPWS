<%
    String osname = "";
	String osabbr = "";
	String comments = "";
	int osid = 0;
	int sequencenum = 0;
	AppTools tool = new AppTools();
	String logaction = tool.nullStringConverter(request.getParameter("logaction"));
	TableQueryBhvr OSView  = (TableQueryBhvr) request.getAttribute("OSView");
	TableQueryBhvrResultSet OSView_RS = OSView.getResults();
	OSView_RS.next();
   			osname = tool.nullStringConverter(OSView_RS.getString("OS_NAME"));
			osabbr = tool.nullStringConverter(OSView_RS.getString("OS_ABBR"));
			comments = tool.nullStringConverter(OSView_RS.getString("COMMENT"));
			osid = OSView_RS.getInt("OSID");
			sequencenum = OSView_RS.getInt("SEQUENCE_NUMBER");
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print edit OS"/>
	<meta name="Description" content="Global print website edit OS information page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("os_edit") %></title>
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
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=242";
	 } //cancelForm
	 
	 function editOS() {
	 	var formName = dijit.byId("OSForm");
        var formValid = false;
        var wName = dijit.byId("osname").get('value');
        var comments = dijit.byId('comments').get('value').trim();
        var logactionid = dojo.byId('logaction');
        var logaction = "OS " + wName + " has been updated";
        logactionid.value = logaction;
        formValid = formName.validate();
   		var msg = logactionid.value;
		if (formValid) {
			if (submitForm('OSForm',msg)) {
				//AddParameter(logactionid.name, logactionid.value);
				document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=242&logaction=" + msg;
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
     	createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>', '244');
        createHiddenInput('logactionid','logaction','');
        createHiddenInput('logactionid','osid','<%= osid %>');
        createpTag();
        createTextInput('osname','osname','osname','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= osname %>');
        createTextInput('osabbr','osabbr','osabbr','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[A-Za-z0-9 _.;]*$','<%= osabbr %>');
        createTextArea('comments', 'comments', '', '<%= comments %>');
        createTextInput('sequencenum','sequencenum','sequencenum','2',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>','^[0-9]*$','<%= sequencenum %>');
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_edit_os','editOS()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_edit_os','cancelForm()');
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=242"><%= messages.getString("os_select") %></a></li>
			</ul>
			<h1><%= messages.getString("os_edit") %></h1>
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