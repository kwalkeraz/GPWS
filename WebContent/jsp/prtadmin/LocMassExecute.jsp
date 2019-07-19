<%@ page import = "java.sql.*,java.util.*,java.io.*,java.net.*,tools.print.keyops.*" %>

	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print mass update location results"/>
	<meta name="Description" content="Global print website location mass update results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("location_mass_update_results") %></title>
	<%@ include file="metainfo2.jsp" %>

	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=2600"><%= messages.getString("location_mass_update") %></a></li>
			</ul>
			<h1><%= messages.getString("location_mass_update_results") %></h1>
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
		<jsp:useBean id="TheBean" scope="page" class="tools.print.printer.FileUploadBean" />
<%
String sLocID = "location not found";
int iFTPID = 0;
String sql = null;
String sql2 = null;
PreparedStatement pstmtGeo = null;
PreparedStatement pstmtCountry = null;
PreparedStatement pstmtState = null;
PreparedStatement pstmtCity = null;
PreparedStatement pstmtBuilding = null;
PreparedStatement pstmtFloor = null;
int rsMain = 1;
Connection con = null;
String filename="";
boolean db2Error = false;
boolean geo = false;
boolean ftp = false;
boolean locCheck = false;
boolean ftpCheck = false;
boolean protoCheck = true;
boolean driverCheck = true;
boolean reqFieldCheck = false;
boolean e2eCheck = true;
boolean bRCWarning = true;
boolean printerCheck = false;
boolean bSQL1 = true;
boolean bSQL2 = true;
int a = 0 ,b = 0,c = 0,d = 0,x = 0, y = 0,z = 0,j = 0,w = 1,linenum = 1,rowcount = 0,rowcounterror = 0,rowcountwarning = 0,lineignore = 0,numCols = 0;
String []errorrows = new String[1000];
String []errormsgs = new String[1000];
String []data = new String[1000];
String []p;
String []columns = new String[200];
String []warnings = new String[1000];
String sLineNum = "";

String Table;
String Action;
String newsql ="";
String newsql2= "";
String Path="";
String sFileType = "";
TheBean.doUpload(request);
Path = TheBean.getSavePath();
sFileType = TheBean.getFileType();
filename = Path + TheBean.getFilename();
Table = TheBean.getFieldValue("table");
//keyopTools tool = new keyopTools();
AppTools appTool = new AppTools();
PrinterTools tool = new PrinterTools();
try {
	con = tool.getConnection();
	con.setAutoCommit(true);

	BufferedReader in = new BufferedReader(new FileReader( filename) ) ;
	
	String s = "";
	int lineCount = 1;
	boolean colList = true;
	while( ( s = in.readLine()) != null ) {
		if (!s.substring(0,1).equals("#") && !s.substring(0,2).equals("\"#")) {
			//data[x]=in.readLine();
			if (colList == false) {
				s = lineCount + "," + s;
			}
			colList = false;
			data[x] = s;
			x++;
			lineCount++;
		} else {
			lineignore++;
			lineCount++;
		}
	}
		in.close();
	    	
	if (sFileType.equals("quotes") && data != null) {
		for (int dc = 0; dc < x; dc++) {
           data[dc] = data[dc].replaceAll("\"","");
		}
	}
	
	p = new String[250];
	if(Table.equals("LOCATION")) {
		columns[0] = "linenumber";
		for(z = 0; z < data[0].length();z++) {
        	if(data[y].charAt(z) == ',') {
            	if (j == z) {
                	columns[w] = "";
                } else {
                    columns[w] = (data[0].substring(j,z)).toUpperCase();
                }
                j = z + 1;
                w++;
            }
            columns[w] = (data[0].substring(j,data[0].length())).toUpperCase();
        }
	}
	numCols = w + 1;
	int joe = 0;

	Action = TheBean.getFieldValue("action"); 
	for(y = 0;y < x;y++) {
		if(y == 0 && (Table.equals("LOCATION"))) {
			y++;
		}
		a = 0;	
		b = 0;
		//p[0] = (y + 1) + ""; // Stores the line number in the first array value
		for(z = 0; z < data[y].length();z++) {
        	if(data[y].charAt(z) == ',') {
            	if (a == z) {
                	p[b] = "";
                } else {
                    p[b] = data[y].substring(a,z);
                }
                a = z + 1;
                b++;
            }
            p[b]=data[y].substring(a,data[y].length());
        }
        int joe2 = 0;

		sLineNum = p[0];
		int iGeoID = 0;
		int iCountryID = 0;
		int iCityID = 0;
		int iLocID = 0;
		int iBuildingID = 0;
		int iTier = 0;
		String sGeoplex = "";
		String sSiteCode = "";
		String sWorkLocCode = "";
		String sCountryAbbr = "";
		String geoemailaddress = "";
		String geoccemailaddress = "";
		String citystatus = "";
		String buildingstatus = "";
		String floorstatus = "";
		if(Table.equals("LOCATION")) {
			String sGeo = null;
			String sCountry = null;			
			String sState = null;			
			String sCity = null;			
			String sBuilding = null;			
			String sFloor = null;
			//int iGeoID = 0;
			int iStateID = 0;
			//int iCityID = 0;
			//int iLocID = 0;
			boolean bGeo = false;
			boolean bCountry = false;
			boolean bState = false;
			boolean bCity = false;
			boolean bBuilding = false;
			boolean bFloor = false;
			String sSQLGeo = "";
			String sSQLCountry = "";
			String sSQLState = "";
			String sSQLCity = "";
			String sSQLBuilding = "";
			String sSQLFloor = "";
			if(Action.equals("INSERT")) {
				sSQLGeo = "INSERT INTO GPWS.GEO (GEO) values ('" + sGeo + "')";
				sSQLCountry = "INSERT INTO GPWS.COUNTRY (COUNTRY) values ('" + sCountry + "')";
				sSQLState = "INSERT INTO GPWS.STATE (STATE) values ('" + sState + "')";
				sSQLCity = "INSERT INTO GPWS.CITY (CITY) values ('" + sCity + "')";
				sSQLBuilding = "INSERT INTO GPWS.BUILDING (BUILDING_NAME) values ('" + sBuilding + "')";
				sSQLFloor = "INSERT INTO GPWS.LOCATION (FLOOR_NAME) values ('" + sFloor + "')";
			} else {
				sSQLGeo = "UPDATE GPWS.GEO (";
				sSQLCountry = "UPDATE GPWS.COUNTRY (";
				sSQLState = "UPDATE GPWS.STATE (";
				sSQLCity = "UPDATE GPWS.CITY (";
				sSQLBuilding = "UPDATE GPWS.BUILDING (";
				sSQLFloor = "UPDATE GPWS.LOCATION (";
			}
			Statement stmtLocCheck = null;
			ResultSet rsLocCheck = null;
			ResultSet rsLocCheck2 = null;
			ResultSet rsLocCheck3 = null;
			for (int count = 1; count < numCols; count++) {
				if (columns[count].equals("GEO")) {
	  				sGeo = p[count];
	  				try {
	  					stmtLocCheck = con.createStatement();
						rsLocCheck = stmtLocCheck.executeQuery("SELECT GEO, GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "'");
						while (rsLocCheck.next()) {
							bGeo = true;
							iGeoID = rsLocCheck.getInt("geoid");
						}
						if (bGeo == false) {
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT GEOID FROM GPWS.GEO ORDER BY GEOID");
							while (rsLocCheck2.next()) {
								iGeoID = rsLocCheck2.getInt("geoid");
							}
							iGeoID ++;
							System.out.println("INSERT INTO GPWS.GEO (GEO, GEOID) values ('" + sGeo + "', " + iGeoID + ")");
							sSQLGeo = "INSERT INTO GPWS.GEO (GEO, GEOID) values ('" + sGeo + "', " + iGeoID + ")";
							pstmtGeo = con.prepareStatement(sSQLGeo);
							rsMain = pstmtGeo.executeUpdate();
							rsLocCheck3 = stmtLocCheck.executeQuery("SELECT GEO, GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "'");
							while (rsLocCheck3.next()) {
								bGeo = true;
								iGeoID = rsLocCheck3.getInt("geoid");
							}
						}
					} catch (Exception e) {
						rsMain = 0;
	  					System.out.println("GPWS error in LocMassExecute.jsp.1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (bGeo == false) {
	  							rsLocCheck.close();
	  							rsLocCheck2.close();
	  						}
	  						stmtLocCheck.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS error in LocMassExecute.jsp.2 ERROR: " + e);
	  					}
	  				}
	  				System.out.println("GeoID = " + iGeoID);
	  			} else if (columns[count].equals("COUNTRY")) {
	  				sCountry = p[count];
	  				try {
	  					stmtLocCheck = con.createStatement();
						rsLocCheck = stmtLocCheck.executeQuery("SELECT country, countryid from gpws.country where country = '" + sCountry + "' and geoid = " + iGeoID);
						while (rsLocCheck.next()) {
							bCountry = true;
							iCountryID = rsLocCheck.getInt("countryid");
						}
						if (bCountry == false) {
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT countryid from gpws.country order by countryid");
							while (rsLocCheck2.next()) {
								iCountryID = rsLocCheck2.getInt("countryid");
							}
							iCountryID++;
							System.out.println("INSERT INTO GPWS.COUNTRY (COUNTRY, COUNTRYID, GEOID) values ('" + sCountry + "', " + iCountryID + ", " + iGeoID + ")");
							sSQLCountry = "INSERT INTO GPWS.COUNTRY (COUNTRY, COUNTRYID, GEOID) values ('" + sCountry + "', " + iCountryID + ", " + iGeoID + ")";
							pstmtCountry = con.prepareStatement(sSQLCountry);
							rsMain = pstmtCountry.executeUpdate();
							rsLocCheck3 = stmtLocCheck.executeQuery("SELECT country, countryid from gpws.country where country = '" + sCountry + "' and geoid = " + iGeoID);
							while (rsLocCheck3.next()) {
								bCountry = true;
								iCountryID = rsLocCheck3.getInt("countryid");
							}
						}
					} catch (Exception e) {
						rsMain = 0;
	  					System.out.println("GPWS error in LocMassExecute.jsp.3 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (bCountry == false) {
	  							rsLocCheck.close();
	  							rsLocCheck2.close();
	  						}
	  						stmtLocCheck.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in LocMassExecute.jsp.4 ERROR: " + e);
	  					}
	  				}
	  				System.out.println("CountryID = " + iCountryID);
	  			} else if (columns[count].equals("STATE")) {
	  				sState = p[count];
	  				try {
	  					stmtLocCheck = con.createStatement();
						rsLocCheck = stmtLocCheck.executeQuery("SELECT state, stateid from gpws.state where state = '" + sState + "' and countryid = " + iCountryID);
						while (rsLocCheck.next()) {
							bState = true;
							iStateID = rsLocCheck.getInt("stateid");
						}
						if (bState == false) {
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT stateid from gpws.state order by stateid");
							while (rsLocCheck2.next()) {
								iStateID = rsLocCheck2.getInt("stateid");
							}
							iStateID++;
							System.out.println("INSERT INTO GPWS.STATE (STATE, STATEID, COUNTRYID) values ('" + sState + "', " + iStateID + ", " + iCountryID + ")");
							sSQLState = "INSERT INTO GPWS.STATE (STATE, STATEID, COUNTRYID) values ('" + sState + "', " + iStateID + ", " + iCountryID + ")";
							pstmtState = con.prepareStatement(sSQLState);
							rsMain = pstmtState.executeUpdate();
							rsLocCheck3 = stmtLocCheck.executeQuery("SELECT state, stateid from gpws.state where state = '" + sState + "' and countryid = " + iCountryID);
							while (rsLocCheck3.next()) {
								bState = true;
								iStateID = rsLocCheck3.getInt("stateid");
							}
						}
					} catch (Exception e) {
						rsMain = 0;
	  					System.out.println("GPWS error in LocMassExecute.jsp.5 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (bState == false) {
	  							rsLocCheck.close();
	  							rsLocCheck2.close();
	  						}
	  						stmtLocCheck.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in LocMassExecute.jsp.6 ERROR: " + e);
	  					}
	  				}
	  				System.out.println("StateID = " + iStateID);
	  			} else if (columns[count].equals("CITY")) {
	  				sCity = p[count];
	  				try {
	  					stmtLocCheck = con.createStatement();
						rsLocCheck = stmtLocCheck.executeQuery("SELECT city, cityid from gpws.city where city = '" + sCity + "' and stateid = " + iStateID);
						while (rsLocCheck.next()) {
							bCity = true;
							iCityID = rsLocCheck.getInt("cityid");
						}
						if (bCity == false) {
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT cityid from gpws.city order by cityid");
							while (rsLocCheck2.next()) {
								iCityID = rsLocCheck2.getInt("cityid");
							}
							iCityID++;
							System.out.println("INSERT INTO GPWS.CITY (CITY, CITYID, STATEID) values ('" + sCity + "', " + iCityID + ", " + iStateID + ")");
							sSQLCity = "INSERT INTO GPWS.CITY (CITY, CITYID, STATEID) values ('" + sCity + "', " + iCityID + ", " + iStateID + ")";
							pstmtCity = con.prepareStatement(sSQLCity);
							rsMain = pstmtCity.executeUpdate();
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT city, cityid from gpws.city where city = '" + sCity + "' and stateid = " + iStateID);
							while (rsLocCheck2.next()) {
								bCity = true;
								iCityID = rsLocCheck2.getInt("cityid");
							}
						}
					} catch (Exception e) {
						rsMain = 0;
	  					System.out.println("GPWS error in LocMassExecute.jsp.7 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (bCity == false) {
	  							rsLocCheck.close();
	  							rsLocCheck2.close();
	  						}
	  						stmtLocCheck.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in LocMassExecute.jsp.8 ERROR: " + e);
	  					}
	  				}
	  				System.out.println("CityID = " + iCityID);
	  			} else if (columns[count].equals("BUILDING")) {
	  				sBuilding = p[count];
	  				try {
	  					stmtLocCheck = con.createStatement();
						rsLocCheck = stmtLocCheck.executeQuery("SELECT building_name, buildingid from gpws.building where building_name = '" + sBuilding + "' and cityid = " + iCityID);
						while (rsLocCheck.next()) {
							bBuilding = true;
							iBuildingID = rsLocCheck.getInt("buildingid");
						}
						if (bBuilding == false) {
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT buildingid from gpws.building order by buildingid");
							while (rsLocCheck2.next()) {
								iBuildingID = rsLocCheck2.getInt("buildingid");
							}
							iBuildingID++;
							System.out.println("INSERT INTO GPWS.BUILDING (BUILDING_NAME, BUILDINGID, CITYID, TIER, SITE_CODE, WORK_LOC_CODE) values ('" + sBuilding + "', " + iBuildingID + ", " + iCityID + ", '" + iTier + "', '" + sSiteCode + "', '" + sWorkLocCode + "')");
							sSQLBuilding = "INSERT INTO GPWS.BUILDING (BUILDING_NAME, BUILDINGID, CITYID, TIER, SITE_CODE, WORK_LOC_CODE) values ('" + sBuilding + "', " + iBuildingID + ", " + iCityID + ", '" + iTier + "', '" + sSiteCode + "', '" + sWorkLocCode + "')";
							pstmtBuilding = con.prepareStatement(sSQLBuilding);
							rsMain = pstmtBuilding.executeUpdate();
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT building_name, buildingid from gpws.building where building_name = '" + sBuilding + "' and cityid = " + iCityID);
							while (rsLocCheck2.next()) {
								bBuilding = true;
								iBuildingID = rsLocCheck2.getInt("buildingid");
							}
						}
					} catch (Exception e) {
						rsMain = 0;
	  					System.out.println("GPWS error in LocMassExecute.jsp.9 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (bBuilding == false) {
	  							rsLocCheck.close();
	  							rsLocCheck2.close();
	  						}
	  						stmtLocCheck.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS error in LocMassExecute.jsp.10 ERROR: " + e);
	  					}
	  				}
	  				System.out.println("BuildingID = " + iBuildingID);
	  			} else if (columns[count].equals("FLOOR")) {
	  				sFloor = p[count];
	  				try {
	  					stmtLocCheck = con.createStatement();
						rsLocCheck = stmtLocCheck.executeQuery("SELECT floor_name, locid from gpws.location where floor_name = '" + sFloor + "' and buildingid = " + iBuildingID);
						while (rsLocCheck.next()) {
							bFloor = true;
						}
						if (bFloor == false) {
							rsLocCheck2 = stmtLocCheck.executeQuery("SELECT locid from gpws.location order by locid");
							while (rsLocCheck2.next()) {
								iLocID = rsLocCheck2.getInt("locid");
							}
							iLocID++;
							System.out.println("INSERT INTO GPWS.LOCATION (FLOOR_NAME, LOCID, BUILDINGID) values ('" + sFloor + "', " + iLocID + ", " + iBuildingID + ")");
							sSQLFloor = "INSERT INTO GPWS.LOCATION (FLOOR_NAME, LOCID, BUILDINGID) values ('" + sFloor + "', " + iLocID + ", " + iBuildingID + ")";
							pstmtFloor = con.prepareStatement(sSQLFloor);
							rsMain = pstmtFloor.executeUpdate();
						}
					} catch (Exception e) {
						rsMain = 0;
	  					System.out.println("GPWS error in LocMassExecute.jsp.11 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (bFloor == false) {
	  							rsLocCheck.close();
	  							rsLocCheck2.close();
	  						}
	  						stmtLocCheck.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS error in LocMassExecute.jsp.12 ERROR: " + e);
	  					}
	  				}
	  				System.out.println("FloorID = " + iLocID);
	  			} else if (columns[count].equals("TIER")) {
	  				iTier = Integer.parseInt(p[count]);
	  			} else if (columns[count].equals("SDC")) {
	  				sGeoplex = p[count];
	  			} else if (columns[count].equals("SITE_CODE")) {
	  				sSiteCode = p[count];
	  			} else if (columns[count].equals("WORK_LOC_CODE")) {
	  			 	sWorkLocCode = p[count];
	  			} else if (columns[count].equals("COUNTRY_ABBR")) {
	  			 	sCountryAbbr = p[count];
	  			} else if (columns[count].equals("GEO_EMAIL_ADDRESS")) {
	  			 	geoemailaddress = p[count];
	  			} else if (columns[count].equals("GEO_CC_EMAIL_ADDRESS")) {
	  			 	geoccemailaddress = p[count];
	  			} else if (columns[count].equals("CITY_STATUS")) {
	  			 	citystatus = p[count];
	  			} else if (columns[count].equals("BUILDING_STATUS")) {
	  			 	buildingstatus = p[count];
	  			} else if (columns[count].equals("FLOOR_STATUS")) {
	  			 	floorstatus = p[count];
				} else {
					// invalid column
				}
				
			}
			
			if(bRCWarning == true) {
				rowcountwarning++;
			}
		}
				
			boolean bGP = false;
			boolean bSC = false;
			boolean bWLC = false;
			boolean bT = false;
			String sSQLBuilding2 = "UPDATE GPWS.building set ";
			if (sGeoplex != null && !sGeoplex.equals("")) {
				sSQLBuilding2 += "sdc = '" + sGeoplex + "'";
				bGP = true;
			}
			if (buildingstatus != null && !buildingstatus.equals("")) {
				if (bGP == true) {
					sSQLBuilding2 += ", building_status = '" + buildingstatus + "'";
				} else {
					sSQLBuilding2 += "building_status = '" + buildingstatus + "'";
				}
				bSC = true;
			}
			if (sSiteCode != null && !sSiteCode.equals("")) {
				if (bGP == true) {
					sSQLBuilding2 += ", site_code = '" + sSiteCode + "'";
				} else {
					sSQLBuilding2 += "site_code = '" + sSiteCode + "'";
				}
				bSC = true;
			}
			if (sWorkLocCode != null && !sWorkLocCode.equals("")) {
				if (bSC == true || bGP == true) {
					sSQLBuilding2 += ", work_loc_code = '" + sWorkLocCode + "'";
				} else {
					sSQLBuilding2 += "work_loc_code = '" + sWorkLocCode + "'";
				}
				bWLC = true;
			}
			if (iTier != 0) {
				if (bWLC == true || bSC == true || bGP == true) {
					sSQLBuilding2 += ", tier = '" + iTier + "'";
				} else {
					sSQLBuilding2 += "tier = '" + iTier + "'";
				}
				bT = true;
			}
			sSQLBuilding2 += " where buildingid = " + iBuildingID;
				
		if(Action.equals("INSERT")) {
			if (bWLC == true || bSC == true || bGP == true || bT == true) {
				pstmtBuilding = con.prepareStatement(sSQLBuilding2);
				pstmtBuilding.executeUpdate();
			}
			if (floorstatus != null && !floorstatus.equals("")) {
				pstmtFloor = con.prepareStatement("UPDATE gpws.location set floor_status = '" + floorstatus + "' where locid = " + iLocID);
				pstmtFloor.executeUpdate();
			}
			if(citystatus != null && !citystatus.equals("")) {
				pstmtCity = con.prepareStatement("UPDATE gpws.city set city_status = '" + citystatus + "' where cityid = " + iCityID);
				pstmtCity.executeUpdate();
			}
			if(sCountryAbbr != null && !sCountryAbbr.equals("")) {
				pstmtCountry = con.prepareStatement("UPDATE gpws.country set country_abbr = '" + sCountryAbbr + "' where countryid = " + iCountryID);
				pstmtCountry.executeUpdate();
			}
			if(geoemailaddress != null && !geoemailaddress.equals("")) {
				pstmtCountry = con.prepareStatement("UPDATE gpws.geo set email_address = '" + geoemailaddress + "', ccemail_address = '" + geoccemailaddress + "' where geoid = " + iGeoID);
				pstmtCountry.executeUpdate();
			}
		}  //if action equals insert
		
		if(rsMain == 1) {
			rowcount++;
		} else {
			rowcounterror++;
			errorrows[rowcounterror] = p[0] + "";
		}
		//rowcount++;
		linenum++;
	} //main for loop
	
	if (Action.equals("INSERT_UPDATE")) { 
		if (rowcount == 1) { %>
			<br /><%= messages.getStringArgs("row_successfully_inserted",new String[]{rowcount + ""}) %>
<%		} else { %>
			<br /><%= messages.getStringArgs("rows_successfully_inserted", new String[]{rowcount + ""}) %>
<%		}
	} else if (Action.equals("INSERT")) {
		if (rowcount == 1) { %>
			<br /><%= rowcount %> <%= messages.getStringArgs("row_successfully_inserted", new String[]{rowcount + ""})%>
<%		} else { %>
			<br /><%= rowcount %> <%= messages.getStringArgs("rows_successfully_inserted", new String[]{rowcount + ""})%>
<%		}
	} else { %>
		<br /><%= rowcount %> <%= messages.getStringArgs("row_completed_successfully", new String[]{rowcount + "" })%>
<%	} 
		if (rowcounterror == 1) { %>
			<br /><%= rowcounterror %> <%= messages.getStringArgs("row_was_unsuccessful", new String[]{rowcounterror + ""})%>
<%		} else { %>
			<br /><%= rowcounterror %> <%= messages.getStringArgs("rows_were_unsuccessful", new String[]{rowcounterror + ""})%>
<%		}
		if (lineignore == 1) { %>
			<br /><%= lineignore %> <%= messages.getStringArgs("row_was_ignored", new String[]{lineignore + ""})%>
<%		} else { %>	
			<br /><%= lineignore %> <%= messages.getStringArgs("rows_were_ignored", new String[]{ lineignore + ""})%>
<%		}
		 if (rowcounterror > 0) { %>
				<br /><br /><b><%= messages.getString("errors") %>:<br /></b><%
			   for (int mc = 0; mc < errormsgs.length; mc++) {
					if(errormsgs[mc] != null) { %>
						<%= errormsgs[mc] %><br />
			<%		}
			   }
		   }
		 if (rowcountwarning > 0) { %>
				<br /><br /><b><%= messages.getString("warnings") %>:</b><br /><%
			   for (int mc = 0; mc < warnings.length; mc++) {
					if(warnings[mc] != null) { %>
						<%= warnings[mc] %><br />
			<%		}
			   }
		   }
	appTool.logUserAction(pupb.getUserLoginID(),"Location mass database update executed","GPWSAdmin");
} catch (Exception e) {
	System.out.println("GPWS error in LocMassExecute.jsp.13 ERROR: " + e);
	appTool.logError("LocMassExecute.jsp","GPWSAdmin",e);
%>
	<br /><%= rowcount %> <%= messages.getStringArgs("row_completed_successfully", new String[]{rowcount + ""})%><br />
<%	if (locCheck == true && sLocID.equals("location not found")) { %>
		<br />The location code could not be determined. Please make sure the Geo, Country, State, City, building, and floor in your csv file are correct. Please note, the values are case sensitive.
<%	} else { 
		if (e != null) {
			String error = e.toString();
			if (error != null && error.indexOf("SQL0803") != -1) {	%>
				<br /><%= messages.getStringArgs("error_occurred_line", new String[]{sLineNum + ""})%>:&nbsp;<%= messages.getString("duplicate_row_msg") %>
<%			} else if (error != null && error.indexOf("java.io.FileNotFoundException") != -1) { %>
				<br /><%= messages.getStringArgs("error_reading_file", new String[]{filename}) %>:<br /><br /><%= e %>	
<%			} else if (error != null && error.indexOf("java.lang.NullPointerException") != -1) { %>
				<br /><%= messages.getStringArgs("error_reading_file", new String[] {filename}) %>:<br /><br /><%= e %>	

<%			} else { %>
				<br /><%= messages.getStringArgs("error_occurred_line", new String[]{sLineNum + ""})%>:<br /><br /><%= e %>
<%			}
		}
	}
} finally {
	//pstmt.close();
	con.close();
}
%>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>