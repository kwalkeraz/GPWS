<%  
	TableQueryBhvr DeviceName = (TableQueryBhvr) request.getAttribute("DeviceName");
    TableQueryBhvrResultSet DeviceName_RS = DeviceName.getResults();
	tools.print.prtadmin.DeviceUpdate tool = new tools.print.prtadmin.DeviceUpdate(); 
	tools.print.lib.AppTools logtool = new tools.print.lib.AppTools();
	
	String action = logtool.nullStringConverter(request.getParameter("submitvalue"));
	String logaction = logtool.nullStringConverter(request.getParameter("logaction"));
	String usertype = "GPWSAdmin";
	String geo = logtool.nullStringConverter(request.getParameter("geo"));
	String country = logtool.nullStringConverter(request.getParameter("country"));
	String city = logtool.nullStringConverter(request.getParameter("city"));
	String building = logtool.nullStringConverter(request.getParameter("building"));
	String floor = logtool.nullStringConverter(request.getParameter("floor"));
	String referer = logtool.nullStringConverter(request.getParameter("referer"));
	String searchName = logtool.nullStringConverter(request.getParameter(PrinterConstants.SEARCH_NAME));
	String devicename = logtool.nullStringConverter(request.getParameter("devicename"));
	String deviceid = logtool.nullStringConverter(request.getParameter("deviceid"));
	String topageid = logtool.nullStringConverter(request.getParameter(BehaviorConstants.TOPAGE));
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print admin device"/>
	<meta name="Description" content="Global print website administer a device results" />
	<title><%= messages.getString("title") %> | <%= messages.getString("device_administer_results") %></title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
			<% if (referer.equals("280") || referer.equals("292")) { %>
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=280"><%= messages.getString("device_add_page") %></a></li>
			<% } else { %>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=281"><%= messages.getString("device_search") %></a></li>
				<% if (referer.equals("282")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=282&<%=PrinterConstants.SEARCH_NAME %>=<%= searchName %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=<%= referer %>&<%=PrinterConstants.SEARCH_NAME %>=<%= searchName %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("432")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=432&geo=<%= geo %>&country=<%= country %>&city=<%= city %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("431")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=431&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } else if (referer.equals("430")) { %>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=430&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%=building %>&floor=<%= floor %>"><%= messages.getString("device_administer") %></a></li>
					<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=283&deviceid=<%= deviceid %>&referer=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("device_edit_page") %></a></li>
				<% } %>
			<% } %>
			</ul>
		<h1><%= messages.getString("device_administer_results") %></h1>
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
		<!-- LEADSPACE_END -->
<%
	if (action.equals("insert")) {	
	
		//Check to see if the loginid already exists, if so, return the user with an error
			String param = "";
			if (DeviceName_RS.getResultSetSize() > 0) { 
				Enumeration e = request.getParameterNames();
				while (e.hasMoreElements()) {
					String name = (String)e.nextElement();
					String value = logtool.nullStringConverter(request.getParameter(name));
					if (!name.equals("restrict")) {
						param = param + "&"+name+"="+value;
					} //if not password
				}
				param = param + "&nameexists=true";
		%>
				<script type="text/javascript">self.location.href = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=280<%= param %>"</script>
		<%	}
		
		int iReturnCode = tool.insertDevice(request);
		if (iReturnCode == 0) {
		logtool.logUserAction(pupb.getUserLoginID(), logaction, usertype);
		String sDeviceid = (String)request.getAttribute("deviceid");
%>
			<p><a class='ibm-confirm-link'></a><%= logaction %></p>
			<ul>
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7120&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=280&<%= PrinterConstants.SEARCH_NAME %>=<%= devicename %>"><%= messages.getString("device_note_administer") %></a></li>
				<% if (!logtool.nullStringConverter(request.getParameter("printtype")).equals("")) { %>
					<% if (!searchName.equals("")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= topageid %>&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } else if (referer.equals("432")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } else if (referer.equals("431")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= topageid %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } else if (referer.equals("430")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= geo %>&country=<%=country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } %>
				<% } //if it's a printer %>
			</ul>
<%	
		} else { 
%>
			<%= messages.getString("device_results_error") %><br /><br />
			<% 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR");
		   	  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
		      <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
		    <% if( theErrorID.equals("-803") ) { %>
			    <b><%= messages.getString("error_message") %></b>:<br />
			    <p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[] {logtool.nullStringConverter(request.getParameter("devicename"))}) %></p>
		  	<% } else {%>
		  		<b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
		  	<% } %>
		   <%}
		   catch( Exception e ) {
		  		System.out.println("Adding device " + devicename + " failed with error " + e);
		   }
		 	%>
<% 		}
	 } else {  //it's a device update
	 	int iReturnCode = tool.updateDevice(request);
		if (iReturnCode == 0) {
		logtool.logUserAction(pupb.getUserLoginID(), logaction, usertype);
		String sDeviceid = logtool.nullStringConverter(request.getParameter("deviceid"));
%>
			<p><a class='ibm-confirm-link'></a><%= logaction %></p>
			<ul>
				<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7120&deviceid=<%= sDeviceid %>&name=<%=request.getParameter("devicename") %>&referer=<%= referer %>&<%= PrinterConstants.SEARCH_NAME %>=<%=request.getParameter("devicename")%>"><%= messages.getString("device_note_administer") %></a></li>
				<% if (!logtool.nullStringConverter(request.getParameter("printtype")).equals("")) { %>
					<% if (!searchName.equals("")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= referer %>&<%= PrinterConstants.SEARCH_NAME %>=<%= searchName %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } else if (referer.equals("432")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } else if (referer.equals("431")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= referer %>&geo=<%= geo %>&country=<%= country %>&city=<%= city %>&building=<%= building %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } else if (referer.equals("430")) {%>
						<li><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210&deviceid=<%= sDeviceid %>&name=<%= devicename %>&referer=<%= referer %>&geo=<%= geo %>&country=<%=country %>&city=<%= city %>&building=<%= building %>&floor=<%= floor %>"><%= messages.getString("enbl_admin") %></a></li>
					<% } %>
				<% } //if it's a printer %>
			</ul>
<%	
		} else { 
%>
			<%= messages.getString("device_results_error") %><br /><br />
			<% 
		   try {
		   	  String theErrorID = (String)request.getAttribute("ERROR"); 
			  String errorMessage = (String)request.getAttribute("ERRORMESSAGE"); %>
		    <b><%= messages.getString("error_code") %></b>: <%= theErrorID %><br />  
		    <%  if( theErrorID.equals("-803") ) { %>
			    <b><%= messages.getString("error_message") %></b>:<br />
			   	<p><a class='ibm-error-link' href='#'></a><%= messages.getStringArgs("error_name_exists", new String[] {logtool.nullStringConverter(request.getParameter("devicename"))}) %></p>
		    <% } else {%>
		  		<b><%= messages.getString("error_message") %></b>:<br />
			    <p><a class='ibm-error-link' href='#'></a><%= errorMessage %></p>
		  	<% } %>
		  <% } catch( Exception e ) {
		  		System.out.println("The update failed for device " + devicename + " with error " + e);
		     } //try and catch
	 	}
	}
%>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>