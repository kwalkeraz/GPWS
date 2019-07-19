<%
	//First, get any news feeds
	TableQueryBhvr NewsFeed = (TableQueryBhvr) request.getAttribute("NewsFeed");
	TableQueryBhvrResultSet NewsFeed_RS = NewsFeed.getResults();
	java.util.Date today = Calendar.getInstance().getTime();
	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("MM/dd/yyyy");
	String tday = formatter.format(today);
	java.util.Date todaysdate = formatter.parse(tday);
	String message = "";
	java.util.Date expdate = todaysdate;
	String newstitle = "";
	boolean expired = true;
	while (NewsFeed_RS.next()) {
		if (NewsFeed_RS.getString("CATEGORY_CODE").equals("Message")) {
	   		message = NewsFeed_RS.getString("CATEGORY_VALUE1");
	   	}
	   	if (NewsFeed_RS.getString("CATEGORY_CODE").equals("ExpirationDate")) {
	   		expdate = formatter.parse(NewsFeed_RS.getString("CATEGORY_VALUE1"));
	   	}
	   	if (NewsFeed_RS.getString("CATEGORY_CODE").equals("MessageTitle")) {
	   		newstitle = NewsFeed_RS.getString("CATEGORY_VALUE1");
	   	}
	} //
   
    // message has expired
	if (todaysdate.before(expdate)) {
		expired = false;
	}
	//end of news feed
%>
<% if (!expired && !message.equals("")) { %>
							<p></p>
	<!-- News feed -->
	<div id="NewsFeed" style="border: 1px solid #000; background-color: #ffe14f; display: block">
		<p><%= newstitle%></p>
		<p><%= message %></p>
		<p align="right"><a id="sign-in-out" href="javascript:hide_fields('NewsFeed');"><%= messages.getString("close") %></a></p>
	</div> <!-- END NewsFeed -->
	<p></p>
	<!-- End of news feed -->
<% } // %>