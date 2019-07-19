	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print feedback results"/>
	<meta name="Description" content="Send feedback information about the GPWS webpage." />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("global_print_feedback") %></title>
	<%@ include file="metainfo2.jsp" %>
	<jsp:useBean id="SaveBean" scope="page"class="tools.print.printer.SaveData" />
	<%@ include file="GetCurrentDateTime.jsp" %>
	
<%
	TableQueryBhvr Feedback = (TableQueryBhvr) request.getAttribute("Feedback");
    TableQueryBhvrResultSet Feedback_RS = Feedback.getResults();
    
    AppTools tool = new AppTools();
    //This is the default email it will go to if no geo's or emails are found
    String defaultEmail = "allprtsp@us.ibm.com";
    String encodeType = "utf-8";
    String geo = tool.nullStringConverter(request.getParameter("geo"));
    String receiver = "";
    String ccreceiver = "";
    if (Feedback_RS.getResultSetSize() > 0 ) {
    	while (Feedback_RS.next()) {
    		geo = Feedback_RS.getString("CATEGORY_VALUE1");
    		receiver = tool.nullStringConverter(Feedback_RS.getString("CATEGORY_VALUE2"));
    	} //while
    } //if > 0 
    else {
    	receiver = defaultEmail;
    }
    if (receiver.equals("")) { receiver = defaultEmail; } //should be changed to whoever will get the email
   String name = tool.nullStringConverter(request.getParameter("userName"));
   name = new URLDecoder().decode((String)name.trim(),encodeType);
   String url = tool.nullStringConverter(request.getParameter("aboutpage"));
   url = new URLDecoder().decode((String)url.trim(),encodeType);
   String host = "";
   String output = "";
   //String section = "";
   //String comments = "";
   String subject = tool.nullStringConverter(request.getParameter("subject"));
   subject = new URLDecoder().decode((String)subject.trim(),encodeType);
   String mailtext = tool.nullStringConverter(request.getParameter("comments"));
   mailtext = new URLDecoder().decode((String)mailtext.trim(),encodeType);
   String sender = tool.nullStringConverter(request.getParameter("email"));
   sender = new URLDecoder().decode((String)sender.trim(),encodeType);
   subject = "GPWS feedback results: " + subject;
   SendMail mailTool = new SendMail();
   //don't want to use the word null, want to leave blank if possible
   if (mailtext == null) { mailtext = ""; }
   if (url == null) { url = ""; }
   if (name.equals("")) { name = "Anonymous"; }
   if (sender.equals("")) { sender = "Anonymous"; }
   if (geo.equals("0")) { geo = "All geographies"; }
   String body = "Name of sender: " + name +
   				   "\nEmail Address: " + sender +
   				   "\nGeo: " + geo +
   				   "\nURL: " + url +
   				   "\n" +
   				   "\nComments: " + mailtext;
   //boolean result = mailTool.sendMail(receiver, subject, body, sender, name);
   boolean result = mailTool.sendMail(receiver, subject, body);
%>

	<script type="text/javascript">
	function callCancel() {
		document.location.href="<%=statichtmldir%>/index.html"
	}
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
		<%@ include file="masthead.jsp" %>
		<%@ include file="../prtuser/WaitMsg.jsp"%>
		<div id="ibm-leadspace-head" class="ibm-alternate">
			<div id="ibm-leadspace-body">
				<ul id="ibm-navigation-trail">
				</ul>
				<h1><%= messages.getString("global_print_feedback") %></h1>
			</div>
		</div>
		<%@ include file="../prtadmin/nav.jsp" %>
	<div id="ibm-pcon">
		<!-- CONTENT_BEGIN -->
		<div id="ibm-content">
		<!-- CONTENT_BODY -->
		<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
			<p>
				<% if (result == true) { %>
					<%= messages.getString("feedback_thank_you") %>
				<% } else { %>
					<%= messages.getString("an_error_occurred") %>
				<% } %>
			</p>
			<p>
				<%= messages.getString("home_link") %> <a class="prtadmin-navlink" href="javascript:callCancel();"><%= messages.getString("home") %></a>
			</p>
		<!-- LEADSPACE_END -->
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>