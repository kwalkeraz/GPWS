<%
    AppTools tool = new AppTools();
    Cookie cGeo = new Cookie("globalPrintGeo",tool.nullStringConverter(request.getParameter("geo")));
	Cookie cCountry = new Cookie("globalPrintCountry",tool.nullStringConverter(request.getParameter("country")));
	Cookie cSite = new Cookie("globalPrintSite",tool.nullStringConverter(request.getParameter("city")));
	Cookie cBuilding = new Cookie("globalPrintBuilding",tool.nullStringConverter(request.getParameter("building")));
	Cookie cFloor = new Cookie("globalPrintFloor",tool.nullStringConverter(request.getParameter("floor")));
	cGeo.setMaxAge(31449600);
	cCountry.setMaxAge(31449600);
	cSite.setMaxAge(31449600);
	cBuilding.setMaxAge(31449600);
	cFloor.setMaxAge(31449600);
	response.addCookie(cGeo);
	response.addCookie(cCountry);
	response.addCookie(cSite);
	response.addCookie(cBuilding);
	response.addCookie(cFloor);
	
	String browser = tool.nullStringConverter(request.getParameter("browser"));
	//New way
	PrinterTools appTool = new PrinterTools();
	Connection con = null;
	PreparedStatement PrtViewCitySearchAll = null;
	ResultSet PrtViewCitySearchAll_RS = null;
	
	String os = tool.nullStringConverter(request.getParameter("os"));
	os = os.replaceAll("%20"," ");
	os = os.replaceAll("%2520"," ");
	String osshort = os.replaceAll("Windows","Win");
	
	String geo = tool.nullStringConverter(request.getParameter("geo"));
	String country = tool.nullStringConverter(request.getParameter("country"));
	String city = tool.nullStringConverter(request.getParameter("city"));
	String building = tool.nullStringConverter(request.getParameter("building"));
	String floor = tool.nullStringConverter(request.getParameter("floor"));
	String room = tool.nullStringConverter(request.getParameter("room"));
	String orderby = tool.nullStringConverter(request.getParameter("orderby"));
	String searchname = tool.nullStringConverter(request.getParameter("SearchName"));
	int locIDValue = 0;
	int deviceid = 0;
	String geoValue = "";
	String countryValue = "";
	String cityValue = "";
	String buildingValue = "";
	String floorValue = "";
	String roomValue = "";
	String nameValue = "";
	String alias = "";
	String type = "";		
	String access = "";
	String cs = "";
	String vm = "";
	String mvs = "";
	String sap = "";
	String wts = "";
	String ims = "";
	String webvis = "";
	String webinst = "";
	String prtdeftype = "";
	boolean bFlag = true;
	String preQuery = "";
	String referer = request.getParameter(BehaviorConstants.TOPAGE);
	//System.out.println("referer is " + referer);
	if (referer.equals("39")) {
		preQuery = "SELECT LOCID, GEO, COUNTRY, CITY, BUILDING_NAME, FLOOR_NAME AS FLOOR_NAME,ROOM, ROOM_ACCESS, DEVICE_NAME, DEVICEID, MODEL,CS,VM,MVS,SAP,WTS,WEB_VISIBLE,INSTALLABLE,CLIENT_DEF_TYPE FROM GPWS.DEVICE_VIEW DEVICE_VIEW WHERE UPPER(CITY) LIKE ? OR UPPER(BUILDING_NAME) LIKE ? OR UPPER(DEVICE_NAME) LIKE ? AND UPPER(WEB_VISIBLE) = 'Y' AND UPPER(STATUS) != 'DELETED' AND UPPER(STATUS) = 'COMPLETED' AND DEVICE_VIEW.DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS_VIEW WHERE FUNCTION_NAME = 'print')";
	} else if (referer.equals("100")) {
		preQuery = "SELECT LOCID, GEO, COUNTRY, CITY, BUILDING_NAME, FLOOR_NAME AS FLOOR_NAME, ROOM, ROOM_ACCESS, DEVICE_NAME, DEVICEID, MODEL,CS,VM,MVS,SAP,WTS,WEB_VISIBLE,INSTALLABLE,CLIENT_DEF_TYPE FROM GPWS.DEVICE_VIEW DEVICE_VIEW WHERE GEO = ? AND COUNTRY= ? AND CITY= ? AND BUILDING_NAME =? AND UPPER(WEB_VISIBLE) = 'Y' AND UPPER(STATUS) != 'DELETED' AND UPPER(STATUS) = 'COMPLETED' AND DEVICE_VIEW.DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS_VIEW WHERE FUNCTION_NAME = 'print')";
	} else {
		preQuery = "SELECT LOCID, GEO, COUNTRY, CITY, BUILDING_NAME, FLOOR_NAME AS FLOOR_NAME,ROOM, ROOM_ACCESS, DEVICE_NAME, DEVICEID, MODEL,CS,VM,MVS,SAP,WTS,WEB_VISIBLE,INSTALLABLE, CLIENT_DEF_TYPE FROM GPWS.DEVICE_VIEW DEVICE_VIEW WHERE GEO = ? AND COUNTRY= ? AND CITY= ? AND BUILDING_NAME =? AND FLOOR_NAME = ? AND UPPER(WEB_VISIBLE) = 'Y' AND UPPER(STATUS) != 'DELETED' AND UPPER(STATUS) = 'COMPLETED' AND DEVICE_VIEW.DEVICEID IN (SELECT DEVICEID FROM GPWS.DEVICE_FUNCTIONS_VIEW WHERE FUNCTION_NAME = 'print')";
	}
	String sqlQuery = "";
	int ResultSetSize = 0;	
	
	//Get IP Address
	String ipaddress = request.getHeader("x-forwarded-for"); 
	if (ipaddress == null || ipaddress.length() == 0 || "unknown".equalsIgnoreCase(ipaddress)) {  
        ipaddress = request.getHeader("Proxy-Client-IP");  
    }  
    if (ipaddress == null || ipaddress.length() == 0 || "unknown".equalsIgnoreCase(ipaddress)) {  
        ipaddress = request.getHeader("WL-Proxy-Client-IP");  
    }  
    if (ipaddress == null || ipaddress.length() == 0 || "unknown".equalsIgnoreCase(ipaddress)) {  
        ipaddress = request.getHeader("HTTP_CLIENT_IP");  
    }  
    if (ipaddress == null || ipaddress.length() == 0 || "unknown".equalsIgnoreCase(ipaddress)) {  
        ipaddress = request.getHeader("HTTP_X_FORWARDED_FOR");  
    }  
    if (ipaddress == null || ipaddress.length() == 0 || "unknown".equalsIgnoreCase(ipaddress)) {  
        ipaddress = request.getRemoteAddr();  
    }  
	//System.out.println("Finally, the ip address is " + ipaddress);   
	//end of IP
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print printer search" />
	<meta name="Description" content="Global print website printer search results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("listsearch_search_info") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 
	 function showHelp() {
		onGo('<%= statichtmldir %>/PrinterInstallHelp.html', 550, 550);
	 } //showHelp
	 
	 function openBrowseDevice(deviceid,devicename) {
		var referer = "620";
		var x="1200";
		var y="860";
		var params = "&deviceid=" + deviceid + "&referer="+referer+"&searchvalue=%25"+devicename.toUpperCase()+"%25&SearchName="+devicename;
		var uRL = "<%= printeruser %>?<%=  BehaviorConstants.TOPAGE %>=55"+params;
		onGo(uRL, x, y);
	 } //openBrowseDevice
	 
	 function onGo(link,h,w) {
		//var chasm = screen.availWidth;
		//var mount = screen.availHeight;
		var args = 'height='+h+',width='+w;
		args = args + ',scrollbars=yes,resizable=yes,status=yes';	
		//args = args + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5);	
		w = window.open(link,'_blank',args);
		return false;
	 }  //onGo
	 
	 function callInstall(locid,geo,country,city,building,floor,room,name) {
	 	var ipStr = "<%= ipaddress %>";
		var params = "&type=" + name + "&<%= PrinterConstants.PRT_LOCID %>="+locid+"&geo="+geo+"&country="+country+ "&city="+city+"&building="+building+"&floor="+floor+"&<%= PrinterConstants.PRT_NAME %>="+name+"&<%= PrinterConstants.PRT_ROOM %>="+room+"&userip="+ipStr+"&os=<%= os%>&browser=<%= browser %>";
		var uRL = "<%= printeruser %>?<%=  BehaviorConstants.TOPAGE %>=35"+params;
		self.location.href = uRL;
	 } //callInstall
	 
	 function showInstallLink(wID,displayValue) {
	 	displayFields([wID],displayValue);
	 } //showFaxInfo
	
	</script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="masthead.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= printeruser %>?<%=  BehaviorConstants.TOPAGE %>=30&os=<%= os %>&browser=<%= browser %>"><%= messages.getString("printer_install_nav") %></a></li>
			</ul>
			<h1><%= messages.getString("listsearch_search_info") %></h1>
		</div>
	</div>
	<%@ include file="../prtadmin/nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main" class="ibm-columns">
			<div class="ibm-col-1-1">
		<!-- LEADSPACE_BEGIN -->
			<ul>
				<li><%= messages.getString("install_printer_button") %></li>
				<li><%= messages.getString("view_additional_information") %></li>
			</ul>
			<p align="right"><a href="javascript:showHelp();"><%= messages.getString("where_is_install_button") %></a></p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='Form'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
					<%
						try {
							con = tool.getConnection();
							if(orderby == null || orderby.equals("")) {
								orderby = "BUILDING_NAME, FLOOR_NAME, ROOM, DEVICE_NAME";
								sqlQuery = preQuery + " ORDER BY " + orderby;
							}
							if (orderby.equals("floor_name")) {
								orderby = "FLOOR_NAME, BUILDING_NAME, ROOM, DEVICE_NAME";
								sqlQuery = preQuery + " ORDER BY " + orderby;
							}
							if (orderby.equals("room")) {
								orderby = "ROOM, BUILDING_NAME, FLOOR_NAME, DEVICE_NAME";
								sqlQuery = preQuery + " ORDER BY " + orderby;
							}
							if(orderby.equals("room_access")) {
								orderby = "ROOM_ACCESS, BUILDING_NAME, FLOOR_NAME, ROOM, DEVICE_NAME";
								sqlQuery = preQuery + " ORDER BY " + orderby;
							}
							if(orderby.equals("device_name")) {
								orderby = "DEVICE_NAME, BUILDING_NAME, FLOOR_NAME, ROOM";
								sqlQuery = preQuery + " ORDER BY " + orderby;
							}
							if(orderby.equals("device_type")) {
								orderby = "MODEL, BUILDING_NAME, FLOOR_NAME, ROOM, DEVICE_NAME";
								sqlQuery = preQuery + " ORDER BY " + orderby;
							}
							//System.out.println("SQL Query is: " + sqlQuery);
							PrtViewCitySearchAll = con.prepareStatement(sqlQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
							if (referer.equals("39")) {
								PrtViewCitySearchAll.setString(1,"%"+searchname+"%");
								PrtViewCitySearchAll.setString(2,"%"+searchname+"%");
								PrtViewCitySearchAll.setString(3,"%"+searchname+"%");
							} else {
								PrtViewCitySearchAll.setString(1,geo);
								PrtViewCitySearchAll.setString(2,country);
								PrtViewCitySearchAll.setString(3,city);
								PrtViewCitySearchAll.setString(4,building);
								if (referer.equals("110")) {
									PrtViewCitySearchAll.setString(5,floor);
								}
							}
							PrtViewCitySearchAll_RS = PrtViewCitySearchAll.executeQuery();
						    
						    while(PrtViewCitySearchAll_RS.next()) {
								ResultSetSize++;
							} //while
							//System.out.println("ResultSetSize is " + ResultSetSize);
					%>
					<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="Display search results for devices">
						<% if (referer.equals("39")) {%>
						<caption><em><%= ResultSetSize %> <%= messages.getString("printers_found") %></em></caption>
						<% } else { %>
						<caption><em><%= ResultSetSize %> <%= messages.getString("printers_found") %> <%= messages.getString("for") %> <%= country %>, <%= city %>, <%= building %> <% if (request.getParameter(BehaviorConstants.TOPAGE).equals("110")) { %>, <%= floor %> <% } %></em></caption>
						<% } %>
						<% if (ResultSetSize > 0) { %>
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("building") %></th>
									<th scope="col" class="ibm-sort">
										<a href="#sort"> <span><%= messages.getString("floor") %></span> <span class="ibm-icon">&nbsp;</span></a>
									</th> 
									<th scope="col" class="ibm-sort">
										<a href="#sort"> <span><%= messages.getString("room") %></span> <span class="ibm-icon">&nbsp;</span></a>
									</th>
									<th scope="col" class="ibm-sort">
										<a href="#sort"> <span><%= messages.getString("room_access") %></span> <span class="ibm-icon">&nbsp;</span></a>
									</th>
									<th scope="col" class="ibm-sort">
										<a href="#sort"> <span><%= messages.getString("printer_name") %></span> <span class="ibm-icon">&nbsp;</span></a>
									</th>
									<th scope="col" class="ibm-sort">
										<a href="#sort"> <span><%= messages.getString("printer_type") %></span> <span class="ibm-icon">&nbsp;</span></a>
									</th>
									<th scope="col"><%= messages.getString("install_printer") %></th>
									<th scope="col"><%= messages.getString("cs") %></th>
									<th scope="col"><%= messages.getString("vm") %></th>
									<th scope="col"><%= messages.getString("mvs") %></th>
									<th scope="col"><%= messages.getString("sap") %></th>
									<th scope="col"><%= messages.getString("wts") %></th>
								</tr>
							</thead>
						<tbody>
							<% 	boolean validOS = false;
								PrtViewCitySearchAll_RS.beforeFirst();
								int count = 0;
								while(PrtViewCitySearchAll_RS.next()) {
									count++;
									locIDValue = PrtViewCitySearchAll_RS.getInt("LOCID");
									deviceid = PrtViewCitySearchAll_RS.getInt("DEVICEID");
									geoValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("GEO"));
									countryValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("COUNTRY"));
									cityValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("CITY"));
									buildingValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("BUILDING_NAME"));
									floorValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("FLOOR_NAME").trim());
									roomValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("ROOM"));
									access = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("ROOM_ACCESS"));			
									nameValue = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("DEVICE_NAME"));						
									type = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("MODEL"));
									cs = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("CS"));
									vm = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("VM"));
									mvs = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("MVS"));
									sap = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("SAP"));
									wts = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("WTS"));
									webvis = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("WEB_VISIBLE"));
									webinst = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("INSTALLABLE"));
									prtdeftype = tool.nullStringConverter(PrtViewCitySearchAll_RS.getString("CLIENT_DEF_TYPE")); 
									validOS = appTool.checkOSInstallConfig(nameValue, os);
								%> 
								<tr>
									<th scope="row" class="ibm-table-row"><%= buildingValue %></th>
									<td><%= floorValue %></td>
									<td><%= roomValue %></td>
									<td><%= access %></td>
									<td><a href="javascript:openBrowseDevice('<%= deviceid %>','<%= nameValue %>');"><%= nameValue %></a></td>
									<td><%= type %></td>
									<td>
									<% 
									if (webinst.equalsIgnoreCase("Y")) { 
										// Verify that the printer has a valid OS config. If os is null, give the user the install link since we couldn't figure out their OS.
										if (os == null || os.equals("") || os.equals("null") || validOS) {%>
											<div id="installtrue_<%= count %>">
												<a class="ibm-download-link" href="javascript:callInstall('<%= locIDValue %>','<%= geoValue %>','<%= countryValue %>','<%= cityValue %>','<%= buildingValue %>','<%= floorValue %>','<%= roomValue %>','<%= nameValue %>')"><%= messages.getString("install") %> <%= nameValue %></a>
											</div>
									<% 	} else { %>
											<div id="installtrue_<%= count %>" style="display: none">
												<a class="ibm-download-link" href="javascript:callInstall('<%= locIDValue %>','<%= geoValue %>','<%= countryValue %>','<%= cityValue %>','<%= buildingValue %>','<%= floorValue %>','<%= roomValue %>','<%= nameValue %>')"><%= messages.getString("install") %> <%= nameValue %></a>
											</div>
											<div id="installfalse_<%= count %>">
												<%= messages.getString("printer_not_available_for_OS") %><br /><a href="javascript:displayFields(['installfalse_<%= count %>'],'none');displayFields(['installtrue_<%= count %>'],'');"><%= messages.getString("not") %> <%= osshort %>?</a>
											</div>
									<%	}
									} else if (webinst.equalsIgnoreCase("N") && prtdeftype.toUpperCase().indexOf("VPSX") >= 0) { %>
										<a href="<%= statichtmldir %>/ECPrint_Install.html"><%= messages.getString("install_ecprint_software") %></a>
								<%	} else { %>
										<%= messages.getString("not_installable") %>
								<%  } %>
									</td>
									<% if (cs.equals("Y") || cs.equals("y")) { %>
									<td><%= prtdeftype %></td>
									<% } else { %>
									<td><%= cs %></td>
									<% } %>
									<td><%= vm %></td>
									<td><%= mvs %></td>
									<td><%= sap %></td>
									<td><%= wts %></td>
								</tr>				
							<%  } //while %>
						</tbody>
					<% } //if ResultSetSize %>
					</table>
				<%  
					} catch (SQLException e) {
						System.out.println("Error in NewPrtViewSearchAll.jsp ERROR: " + e); %>
						<h1><%= messages.getString("an_error_has_occurred") %></h1><br />
						<b><%= messages.getString("error_code") %></b>: <%= e.getErrorCode() %><br />  
				    	<b><%= messages.getString("error_message") %></b>:<br />
						<p class="alert-stop"><%= e.getLocalizedMessage() %></p>
						<br />
						<p>
							<b><%= messages.getString("what_to_do") %>:</b>
							<br /><%= messages.getString("unknown_sol") %>
						</p>
				<%	}
					 finally {
					 	if (PrtViewCitySearchAll_RS != null)
							PrtViewCitySearchAll_RS.close();
						if (PrtViewCitySearchAll != null)
							PrtViewCitySearchAll.close();
						if (con != null)
							con.close();
					} %>
			</div> <!-- END form div -->
		</div> <!-- END ibm-col-4-3 -->		
		</div><!-- END ibm-content-main -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>