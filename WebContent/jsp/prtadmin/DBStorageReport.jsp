<%@ page import="java.text.DecimalFormat,java.text.NumberFormat" %>
<%	
	TableQueryBhvr DBStorageView  = (TableQueryBhvr) request.getAttribute("DBStorageView");
	TableQueryBhvrResultSet DBStorageView_RS = DBStorageView.getResults();
	
	AppTools tool = new AppTools();
	
	int iTableSize = 0;
	int iTotalSize = 0;
	int iTotalSizeMB = 0;
	int iTotCount = 0;
	String sTableName = "";
	
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	NumberFormat number = NumberFormat.getNumberInstance();
	number = new DecimalFormat("###,##0");
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global print website database storage report"/>
	<meta name="Description" content="Global print website database storage report" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("database_storage_report") %> </title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=520"><%= messages.getString("tableselect_reports_admin") %></a></li>
			</ul>
			<h1><%= messages.getString("database_storage_report") %></h1>
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
			<ul class="ibm-bullet-list ibm-no-links">
				<li><%= messages.getString("database_storage_report_info") %></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>		
			<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all table storage">
				<caption><em><%= DBStorageView_RS.getResultSetSize() %> <%= messages.getString("tables_found") %></em></caption>
				<% if (DBStorageView_RS.getResultSetSize() > 0) { %>
				<thead>
					<tr>
						<th scope="col"><%= messages.getString("table_name") %></th>
						<th scope="col"><%= messages.getString("number_of_rows") %></th>
						<th scope="col"><%= messages.getString("size_in_kb") %></th>
						<th scope="col"><%= messages.getString("size_in_mb") %></th>
					</tr>
				</thead>
				<tbody>
				<%
					try {
						con = tool.getConnection();
						while(DBStorageView_RS.next()) {
							iTableSize = DBStorageView_RS.getInt("TOTAL_P_SIZE");
							sTableName = DBStorageView_RS.getString("TABNAME");
							iTotalSize += iTableSize;
							int iCount = 0;							
							stmt = con.createStatement();
							rs = stmt.executeQuery("select count(*) as count from gpws." + sTableName);
							while (rs.next()) {
								iCount = rs.getInt("count");
							}
							iTotCount += iCount;
				 %>
						<tr id='tr<%= sTableName %>'>
							<th class="ibm-table-row" scope="row"><%= sTableName %></th>
							<td><%= number.format(iCount) %></td>
							<td><%= number.format(iTableSize) %></td>
							<td><%= iTableSize / 1024 %></td>
						</tr>
					<% } //while loop
					} catch (Exception e) {
						tool.logError("DBStorageReport.jsp", "GPWSAdmin", e);%>
						<tr><td colspan="4"><%= messages.getString("unknown_system_error_text") %>
				<%	} finally {
						if (rs != null)
							rs.close();
						if (stmt != null)
							stmt.close();
						if (con != null)
							con.close();
					} %>
					<tr id='trTOTAL'>
						<th class="ibm-table-row" scope="row"><b>TOTAL</b></th>
						<td><b><%= number.format(iTotCount) %></b></td>
						<td><b><%= number.format(iTotalSize) %> KB</b></td>
						<td><b><%= iTotalSize / 1024 %> MB</b></td>
					</tr>
				</tbody>
				<% } //if there are records %>
			</table> 
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>