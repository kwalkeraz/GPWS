<?xml version="1.0"?><%@ page contentType="application/xml" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %><%

	Connection con = null;
	//Admin info
	PreparedStatement adminStmt = null;
	ResultSet adminRs = null;
	
	AppTools appTool = new AppTools();
	String sEmail = appTool.nullStringConverter(request.getParameter("email"));
	UserInfo bpLookup = new UserInfo(sEmail);
	ResourceBundle myResources = ResourceBundle.getBundle("tools.print.lib.AppTools");
	String sServer = myResources.getString("serverName");
	
	String sSQL = "";
	String sQuery = appTool.nullStringConverter(request.getParameter("query"));
	String sUserID = appTool.nullStringConverter(request.getParameter("userid"));
	String sLoginID = appTool.nullStringConverter(request.getParameter("loginid"));
	String sUser = appTool.nullStringConverter(request.getParameter("user"));
	String sAdmin = appTool.nullStringConverter(request.getParameter("admin"));
	String sType = appTool.nullStringConverter(request.getParameter("type"));
	boolean validSQL = true;
	boolean nameFound = true;
	String sLastName = "";
	String sFirstName = "";
	String fullname = "";
	String phone = "";
	String tieline= "";
	String email = "";
	String login = "";
	String pager = "";
	String isMgr = "";
	String backup = "";
	String group = "";
	String authorization = "";
	int iLength = 0; 
	int iComma = 0;
	
	boolean bSession = false;
	bSession = request.isRequestedSessionIdValid();
   	
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1 
	response.setHeader("Pragma","no-cache"); //HTTP 1.0 
	response.setHeader("Content-disposition","attachment; filename=UserAPI.xml");
	
	if (sQuery.equals("user")) { %>
<Users><%
			if (!sEmail.equals("")) { 
				if (bpLookup.employeeName().equals("not found")) {
					nameFound = false;
				} //name was found
				if (nameFound) {
					for(int j = 0; j < bpLookup.employeeName().length(); j++) {
						if (bpLookup.employeeName().substring(j, j + 1).equals(",")) {
							iComma = j;
						} //if
					} //for loop
	 				if (iComma != -1) {
	        			iLength = bpLookup.employeeName().length();
						sLastName = bpLookup.employeeName().substring( 0, iComma );
	        			sFirstName = bpLookup.employeeName().substring( iComma + 1, iLength);
	        		} //if
	        		fullname = bpLookup.employeeName();
	        		phone = bpLookup.empXphone();
	        		tieline = bpLookup.empTie();
	        		//email = sEmail;
	        		email = bpLookup.employeeEmail();
	        		//login = sEmail;
	        		login = bpLookup.employeeEmail();
	        		pager = bpLookup.empPager();
	        		isMgr = bpLookup.isMgr(); %>
	<User>
		<FullName><%= fullname %></FullName>
		<FirstName><%= sFirstName %></FirstName>
		<LastName><%= sLastName %></LastName>
		<EmailAddress><%= email %></EmailAddress>
		<LoginID><%= login %></LoginID>
		<Phone><%= phone %></Phone>
		<TieLine><%= tieline %></TieLine>
		<Pager><%= pager %></Pager>
		<isMgr><%= isMgr %></isMgr>
	</User>
	        	<%} //if employee was found
	        	else { %>
	        		<Error>Employee was not found.</Error>
	        	<% }
			} //Lookup user in BP
			else { %>
				<Error>Email address is missing or is invalid.</Error>
			<% } %>
<%	} else if (sQuery.equals("admin") && bSession == true) { %>
<Administrators><%
	if (!sUserID.equals("")) {
		sSQL = "SELECT * FROM GPWS.USER_VIEW WHERE USERID = " + sUserID + " ORDER BY AUTH_GROUP"; 
	} else if (!sLoginID.equals("")) {
		sSQL = "SELECT * FROM GPWS.USER_VIEW WHERE LOGINID = '" + sLoginID + "' ORDER BY AUTH_GROUP"; 
	} else if (!sType.equals("")) {
		if (sType.toUpperCase().equals("GPWS")) {
			sSQL = "SELECT * FROM GPWS.USER WHERE AUTH_GROUP = 'GPWS' ORDER BY LAST_NAME";
		} else if (sType.toUpperCase().equals("KEYOP")) {
			sSQL = "SELECT * FROM GPWS.USER WHERE AUTH_GROUP = 'Keyop' ORDER BY LAST_NAME";
		} else if (sType.toUpperCase().equals("COMMONPROCESS")) {
			sSQL = "SELECT * FROM GPWS.USER WHERE AUTH_GROUP = 'CommonProcess' ORDER BY LAST_NAME";
		} else {
			sSQL = "SELECT * FROM GPWS.USER ORDER BY LAST_NAME";
		}
	} else {
		sSQL = "SELECT * FROM GPWS.USER_VIEW ORDER BY LAST_NAME, AUTH_GROUP";
	} //is sUserID
	
	try {
		con = appTool.getConnection();
		adminStmt = con.prepareStatement(sSQL);
		adminRs = adminStmt.executeQuery();
		int userid = 0;
		int authtypeid = 0;
		int lastauthtypeid = 0;
		while(adminRs.next()) {
				sFirstName = appTool.xmlTextUpdater(adminRs.getString("FIRST_NAME"));
				sLastName = appTool.xmlTextUpdater(adminRs.getString("LAST_NAME"));
				userid = adminRs.getInt("USERID"); 
				email = appTool.xmlTextUpdater(adminRs.getString("EMAIL"));
				login = appTool.xmlTextUpdater(adminRs.getString("LOGINID"));
				pager = appTool.xmlTextUpdater(adminRs.getString("PAGER"));
				if (sType.equals("")) {
					authtypeid = adminRs.getInt("AUTH_TYPEID"); 
					group = appTool.xmlTextUpdater(adminRs.getString("AUTH_GROUP"));
					authorization = appTool.xmlTextUpdater(adminRs.getString("AUTH_NAME"));
				}
			%>
	<Administrator id="<%= userid %>">
		<FullName><%= sLastName %>, <%= sFirstName %></FullName>
		<FirstName><%= sFirstName %></FirstName>
		<LastName><%= sLastName %></LastName>
		<EmailAddress><%= email %></EmailAddress>
		<LoginID><%= login %></LoginID>
		<Pager><%= pager %></Pager>
		<% if (sType.equals("")) { %>
		<Authorization>
			<<%=group%> id="<%= authtypeid %>"><%= authorization %></<%=group%>>
		</Authorization>
		<% } %>
	</Administrator>
<%		} //while
	} catch (Exception e) {
		System.out.println("Error: " + e);
	} finally {
		if (adminRs != null)
			adminRs.close();
		if (adminStmt != null)
			adminStmt.close();
		if (con != null)
			con.close();
	} //try and catch
	} else { %>
<Error>Invalid parameters passed.</Error><%
		validSQL = false;
	} 
if (sQuery.equals("user")) { %>
</Users><%	
} else if (sQuery.equals("admin") && bSession == true) { %>
</Administrators> <%
} %>