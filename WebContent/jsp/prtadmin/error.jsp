<%@ include file="metainfo.jsp" %>
<% try { %>
<meta name="Description" content="Global print website administration page error message" />
<title><%= messages.getString("global_print_title")%> | <%= messages.getString("error_msg") %></title>
<%@ include file="metainfo2.jsp" %>
</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<h1><%= messages.getString("an_error_has_occurred") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
	<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
	
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
<%
	Exception e = (Exception)request.getAttribute(BehaviorConstants.ERRORSTATE);
	String error = "";
	String errorNum = "";
	String errorType = "";
	String errorMessage = "";
	String solution = "";
	if( e instanceof BehaviorException ) {
		BehaviorException e2 = (BehaviorException)e;
		Exception e3 = e2.getException();
		error = e3.toString();
		int sqlCode = error.indexOf("SQL");
		int sqlCode2 = error.indexOf("SQLCODE");

		if (sqlCode != -1 && error.substring(sqlCode + 3,sqlCode + 7).equals("0803") || (error.substring(sqlCode2 + 7,sqlCode2 + 14)).indexOf("803") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b> 803</p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("duplicate_row") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= messages.getString("duplicate_row_msg") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("duplicate_row_sol") %></p>
<%		} else if (sqlCode != -1 && error.substring(sqlCode + 3,sqlCode + 7).equals("0532") || (error.substring(sqlCode2 + 7,sqlCode2 + 14)).indexOf("532") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;532</p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("delete_restriction") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= messages.getString("delete_restriction_msg") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("delete_restriction_sol") %></p>
<%		} else if (sqlCode != -1 && error.substring(sqlCode + 3,sqlCode + 7).equals("0204") || error.substring(sqlCode + 3,sqlCode + 7).equals("0206") || (error.substring(sqlCode2 + 7,sqlCode2 + 14)).indexOf("204") != -1 || (error.substring(sqlCode2 + 7,sqlCode2 + 14)).indexOf("206") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;204</p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("sql_error") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= messages.getString("sql_error_msg") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("sql_error_sol") %></p>
<%		} else if (e2.toString().indexOf("Delete Restricted") != -1 || error.indexOf("A parent row cannot be deleted") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;532</p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("delete_restriction") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= messages.getString("delete_restriction_msg") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("delete_restriction_sol") %></p>
<%		} else if (e2.toString().indexOf("Duplicate Row") != -1 || error.indexOf("DuplicateKeyException") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;803</p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("duplicate_row") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= messages.getString("duplicate_row_msg") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("duplicate_row_sol") %></p>
<%		} else if (error.indexOf("SqlException") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;204</p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("sql_error") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= messages.getString("sql_error_msg") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("sql_error_sol") %></p>
<%		} else if (error.indexOf("deadlock or timeout") != -1) { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;<%= messages.getString("none") %></p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("deadlock_or_timeout") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= e2.toString() %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("deadlock_or_timeout_sol") %></p>
<%		} else { %>
			<p><b><%= messages.getString("error_number") %>:</b>&nbsp;<%= messages.getString("unknown") %></p>
			<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("unknown") %></p>
			<p><b><%= messages.getString("error_message") %>:</b>&nbsp;<%= e2.toString() %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b>&nbsp;<%= messages.getString("unknown_sol") %></p>
<%		} %>
<!--
<%= e %>
<% }
   if( e instanceof BehaviorException ) {
      BehaviorException e2 = (BehaviorException)e;
      Exception e3 = e2.getException();
	  if( e3 != null )
      e3.printStackTrace(new java.io.PrintWriter(out));
   }
%>
-->
<%
} catch( Exception e ) {
     Exception ex = (Exception)request.getAttribute(BehaviorConstants.ERRORSTATE);
     if (ex.getMessage().indexOf("Error in TableQueryBhvr.execute") != -1) {  %>
     		<p><b><%= messages.getString("error_number") %>:</b>&nbsp;U001</p>
     		<p><b><%= messages.getString("error_type") %>:</b>&nbsp;<%= messages.getString("invalid_parameter_passed") %></p>
			<p><b><%= messages.getString("error_message") %>:</b><%= messages.getString("invalid_paramater_message") %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b><%= messages.getString("unknown_sol") %></p>
<%	 } //if error is execute query
     else { %>
			<p><b><%= messages.getString("error_number") %>:</b><%= messages.getString("unknown") %></p>
     		<p><b><%= messages.getString("error_type") %>:</b><%= messages.getString("unknown") %></p>
			<p><b><%= messages.getString("error_message") %>:</b><%= e.toString() %></p>
			<p><b><%= messages.getString("what_to_do") %>:</b><%= messages.getString("unknown_sol") %></p>
<%	} //else different error message
} %>

				</div><!-- CONTENT_MAIN END-->
			</div><!-- CONTENT_BODY END-->
		</div><!-- END ibm-content -->
	</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>