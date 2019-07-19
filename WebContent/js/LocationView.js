<%
	int count = 0;
	while(LocationView_RS.next()) {
%>
	info[<%= count %>] = "<%= LocationView_RS.getString(1) %>" + "=" + "<%= LocationView_RS.getString(2) %>" + "=" + "<%= LocationView_RS.getString(3) %>" + "=" + "<%= LocationView_RS.getString(4) %>" + "=" + "<%= LocationView_RS.getString(5) %>" + "=" + "<%= LocationView_RS.getString(6) %>";
<%	count++;
	}
%>
