	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print mass update results"/>
	<meta name="Description" content="Global print website mass update results" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("mass_update_result") %></title>
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
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=530"><%= messages.getString("upload_header") %></a></li>
			</ul>
			<h1><%= messages.getString("mass_update_result") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main" class="ibm-columns">
			<div class="ibm-col-1-1">
		<!-- LEADSPACE_BEGIN -->
		<jsp:useBean id="TheBean" scope="page" class="tools.print.printer.FileUploadBean" />
<%
//String sFileType = request.getParameter("filetype");
String sLocID = "location not found";
int iFTPID = 0;
String sql = null;
String sql2 = null;
StringBuffer sb = new StringBuffer();
StringBuffer sb2 = new StringBuffer();
PreparedStatement pstmt = null;
PreparedStatement pstmt2 = null;
int rsMain = 0;
Connection con = null;
String filename="";
boolean isDipp = false;
boolean isVPSX = false;
boolean isPrinter = false;
boolean isCopier = false;
boolean isFax = false;
boolean db2Error = false;
boolean geo = false;
boolean ftp = false;
boolean locCheck = false;
boolean deviceNameError = false;
boolean ftpCheck = false;
boolean printerDefTypeCheck = false;
boolean printerDefType = false;
boolean driverSetCheck = false;
boolean driverSet = false;
//boolean reqFieldCheck = false;
boolean reqFieldCheck = true;
boolean e2eCheck = true;
boolean bRCWarning = false;
boolean modelCheck = false;
boolean printerCheck = false;
boolean serverCheck = false;
boolean sapPrtCheck = false;
boolean bValidEnab = true;
boolean bEnabCheck = true;
int a = 0 ,b = 0,c = 0,d = 0,x = 0, y = 0,z = 0,j = 0,w = 1,linenum = 1,rowcount = 0,rowcounterror = 0,rowcountwarning = 0,lineignore = 0,numCols = 0;
String []errorrows = new String[1000];
String []errormsgs = new String[1000];
String []data = new String[1000];
String []p;
String []columns = new String[200];
String []warnings = new String[1000];
String sLineNum = "";
//Required Fields for printers. prtReqFields stores the fields, prtReqExists stores a boolean as to whether the user has supplied them in the file.
String []prtReqFields = {"GEO","COUNTRY","STATE","CITY","BUILDING_NAME","FLOOR_NAME","ROOM","DEVICE_NAME","MODEL","WEB_VISIBLE","INSTALLABLE","STATUS","FTP_SITE","PRINTER_DEF_TYPE","DRIVER_SET_NAME","LPNAME","DIPP","DEVICE_FUNCTION"};
boolean []prtReqExist = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};

//Required Fields for copiers and faxes. Last field is fax_number which is only required for a fax.
String []copfaxReqFields = {"GEO","COUNTRY","STATE","CITY","BUILDING_NAME","FLOOR_NAME","ROOM","DEVICE_NAME","MODEL","WEB_VISIBLE","STATUS","DEVICE_FUNCTION","FAX_NUMBER"};
boolean []copfaxReqExist = {false,false,false,false,false,false,false,false,false,false,false,false,false};

String Table;
String Action;
String newsql ="";
String newsql2= "";
String Path="";
String sFileType = "";

//Table = TheBean.getFieldValue("table");
AppTools appTool = new AppTools();
PrinterTools tool = new PrinterTools();
DateTime dateTime = new DateTime();
Timestamp lastmodified = dateTime.getSQLTimestamp();
String lastmodifiedby = pupb.getUserLoginID();

int maxDevFunc = 10;

try {
	TheBean.setSavePath();
	//TheBean.doUpload(request);
	Path = TheBean.getSavePath();
	//sFileType = TheBean.getFileType();
	sFileType = request.getParameter("filetype");
	//filename = Path + TheBean.getFilename();
	filename = Path + request.getParameter("file");
	System.out.println("filename with path is " + filename);
	//Table = TheBean.getFieldValue("table");
	Table = request.getParameter("table");
	//
	con = appTool.getConnection();
	con.setAutoCommit(true);
	///ServletInputStream in = null;
   	///in = request.getInputStream();
	BufferedReader in = new BufferedReader(new FileReader( filename) ) ;
	
	String s = "";
	int lineCount = 1;
	boolean colList = true;
	while( ( s = in.readLine()) != null ) {
		if (s != null && !s.substring(0,1).equals("#") && !s.substring(0,2).equals("\"#")) {
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
	
	    	
	if (sFileType != null && sFileType.equals("quotes") && data != null) {
		for (int dc = 0; dc < x; dc++) {
           data[dc] = data[dc].replaceAll("\"","");
		}
	}
	
	p = new String[250];
	if(Table.equals("DEVICE") || Table.equals("ENBLHEADER") || Table.equals("ENBLDETAIL") || Table.equals("SERVER")) {
		columns[0] = "linenumber";
		for(z = 0; z < data[0].length();z++) {
        	if(data[y].charAt(z) == ',') {
            	if (j == z) {
                	columns[w] = "";
                } else {
                    columns[w] = (data[0].substring(j,z)).toUpperCase().trim();
                }
                j = z + 1;
                w++;
            }
            columns[w] = (data[0].substring(j,data[0].length())).toUpperCase();
        }
	}
	numCols = w + 1;
	int deviceFunc = 0;
	String[] deviceFunctions = new String[maxDevFunc];
	//Action = TheBean.getFieldValue("action");
	Action = request.getParameter("action");
	for(y = 0;y < x;y++) {
		deviceFunc = 0;
		locCheck = false;
		ftpCheck = false;
		//printerDefType = true;
		//driverSet = true;
		e2eCheck = true;
		printerCheck = false;
		if(y == 0 && (Table.equals("DEVICE") || Table.equals("ENBLHEADER") || Table.equals("ENBLDETAIL") || Table.equals("SERVER"))) {
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
                    p[b] = data[y].substring(a,z).trim();
                }
                a = z + 1;
                b++;
            }
            p[b]=data[y].substring(a,data[y].length());
        }
					
		sb.delete(0, sb.length());
		sb2.delete(0, sb2.length());
	
		sLineNum = p[0];
		int reqPrtCount = 0;
		int reqCpyCount = 0;
		int reqFaxCount = 0;
		if(Table.equals("DEVICE") && Action.equals("INSERT")) {
			boolean devFunc = false;
			for (int req = 0; req < numCols; req++) {
				for (int req2 = 0; req2 < prtReqFields.length; req2++) {
					if (columns[req].equals(prtReqFields[req2])) {
						prtReqExist[req2] = true;
					}
				}
				for (int req2 = 0; req2 < copfaxReqFields.length; req2++) {
					if (columns[req].equals(copfaxReqFields[req2])) {
						copfaxReqExist[req2] = true;
					}
				}
				if (columns[req].equals("DEVICE_FUNCTION")) {
					devFunc = true;
				}
			}
		}
		if(Table.equals("ENBLHEADER") && Action.equals("INSERT")) {
			int reqCount = 0;
			for (int req = 0; req < numCols; req++) {
				if (columns[req].equals("NAME") || columns[req].equals("ENBLTYPE") || columns[req].equals("STATUS")) {
					reqCount++;
				}
			}
			if (reqCount >= 3) {
				reqFieldCheck = true;
			}
		}
		if(Table.equals("ENBLDETAIL") && Action.equals("INSERT")) {
			int reqCount = 0;
			for (int req = 0; req < numCols; req++) {
				if (columns[req].equals("NAME") || columns[req].equals("ENBLTYPE") || columns[req].equals("SEQ")) {
					reqCount++;
				}
			}
			if (reqCount >= 3) {
				reqFieldCheck = true;
			}
		}
		if(Table.equals("SERVER") && Action.equals("INSERT")) {
			int reqCount = 0;
			for (int req = 0; req < numCols; req++) {
				if (columns[req].equals("SERVER_NAME")) {
					reqCount++;
				}
			}
			if (reqCount >= 1) {
				reqFieldCheck = true;
			}
		}
		String sDeviceName = "";
		if(Table.equals("DEVICE")) {
			String sPrinterName = "";
			String sGeo = null;
			String sCountry = null;
			String sState = null;
			String sCity = null;
			String sBuilding = null;
			String sFloor = null;
			sLocID = "location not found";
			String sComm = null;
			String sSpooler = null;
			String sSuper = null;
			String sCommSpoolSuperID = "not found";
			String sSQLDeviceCols = "";
			if(Action.equals("INSERT")) {
				sSQLDeviceCols = "INSERT INTO GPWS.DEVICE (";
			} else {
				sSQLDeviceCols = "UPDATE GPWS.DEVICE SET (";
			}
			String sSQLDeviceData = "";
			for (int count = 1; count < numCols; count++) {
				if (columns[count].equals("PRINTER_DEF_TYPE") ) {
					printerDefTypeCheck = true;
					Statement stmtType = null;
					ResultSet rsType = null;
					boolean bChangeValue = false;
					if (p[count].toUpperCase().indexOf("VPSX") >= 0) {
						isVPSX = true;
					}
					try {
						stmtType = con.createStatement();
						rsType = stmtType.executeQuery("SELECT PRINTER_DEF_TYPEID FROM GPWS.PRINTER_DEF_TYPE WHERE CLIENT_DEF_TYPE = '" + p[count] + "'");
						//int iPrinterDefType = 0;
						while (rsType.next()) {							
							p[count] = rsType.getInt("PRINTER_DEF_TYPEID") + "";
							bChangeValue = true;
							printerDefType = true;
						}
						if (bChangeValue == false) {
							p[count] = "0";
							bRCWarning = true;
							if (Action.equals("INSERT_UPDATE")) {
								if (warnings[Integer.parseInt(p[0])] != null) {
		  							warnings[Integer.parseInt(p[0])] += "Printer Definition Type not found. ";
		  						} else {
		  							warnings[Integer.parseInt(p[0])] = p[0] + ": Printer Definition Type not found. ";
		  						}
		  					}
							//if (errormsgs[Integer.parseInt(p[0])] != null) {
	  						//	errormsgs[Integer.parseInt(p[0])] += "Invalid printer definition type value, changing to \"0\". ";
	  						//} else {
	  						//	errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid printer definition type value, changing to \"0\". ";
	  						//}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsType != null)
	  							rsType.close();
	  						if (stmtType != null)
	  							stmtType.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					if (bChangeValue == true) {
						sSQLDeviceCols += "PRINTER_DEF_TYPEID,";
						sSQLDeviceData += p[count] + ",";
					}
					
				} else if (columns[count].equals("DRIVER_SET_NAME") ) {
					driverSetCheck = true;
					Statement stmtType = null;
					ResultSet rsType = null;
					boolean bChangeValue = false;
					try {
						stmtType = con.createStatement();
						rsType = stmtType.executeQuery("SELECT DRIVER_SETID FROM GPWS.DRIVER_SET WHERE DRIVER_SET_NAME = '" + p[count] + "'");
						while (rsType.next()) {							
							p[count] = rsType.getInt("DRIVER_SETID") + "";
							bChangeValue = true;
							driverSet = true;
						}
						if (bChangeValue == false) {
							p[count] = "0";
							bRCWarning = true;
							if (Action.equals("INSERT_UPDATE")) {
								if (warnings[Integer.parseInt(p[0])] != null) {
		  							warnings[Integer.parseInt(p[0])] += "Driver Set not found. ";
		  						} else {
		  							warnings[Integer.parseInt(p[0])] = p[0] + ": Driver Set not found. ";
		  						}
		  					}
							//if (errormsgs[Integer.parseInt(p[0])] != null) {
	  						//	errormsgs[Integer.parseInt(p[0])] += "Invalid driver set value, changing to \"0\". ";
	  						//} else {
	  						//	errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid driver set value, changing to \"0\". ";
	  						//}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsType != null)
	  							rsType.close();
	  						if (stmtType != null)
	  							stmtType.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					if (bChangeValue == true) {
						sSQLDeviceCols += "DRIVER_SETID,";
						sSQLDeviceData += p[count] + ",";
					}
					
				} else if (columns[count].equals("SERVER") ) {
					
					Statement stmtServer = null;
					ResultSet rsServer = null;
					boolean bChangeValue = false;
					try {
						stmtServer = con.createStatement();
						rsServer = stmtServer.executeQuery("SELECT SERVERID FROM GPWS.SERVER WHERE SERVER_NAME = '" + p[count] + "'");
						bChangeValue = false;
						while (rsServer.next()) {							
							p[count] = rsServer.getInt("SERVERID") + "";
							bChangeValue = true;
						}
						if (bChangeValue == false) {
							p[count] = "0";
							bRCWarning = true;
							if (warnings[Integer.parseInt(p[0])] != null) {
	  							warnings[Integer.parseInt(p[0])] += "Server not found. ";
	  						} else {
	  							warnings[Integer.parseInt(p[0])] = p[0] + ": Server not found. ";
	  						}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsServer != null)
	  							rsServer.close();
	  						if (stmtServer != null)
	  							stmtServer.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					if (bChangeValue == true) {
						sSQLDeviceCols += "SERVERID,";
						sSQLDeviceData += p[count] + ",";
					}
					
				} else if (columns[count].equals("MODEL") ) {
					
					Statement stmtModel = null;
					ResultSet rsModel = null;
					boolean bChangeValue = false;
					try {
						stmtModel = con.createStatement();
						rsModel = stmtModel.executeQuery("SELECT MODELID FROM GPWS.MODEL WHERE MODEL = '" + p[count] + "'");
						bChangeValue = false;
						while (rsModel.next()) {							
							p[count] = rsModel.getInt("MODELID") + "";
							bChangeValue = true;
							modelCheck = true;
						}
						if (bChangeValue == false) {
							p[count] = "0";
							bRCWarning = true;
							//if (errormsgs[Integer.parseInt(p[0])] != null) {
	  						//	errormsgs[Integer.parseInt(p[0])] += "Model not found. ";
	  						//} else {
	  						//	errormsgs[Integer.parseInt(p[0])] = p[0] + ": Model not found. ";
	  						//}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsModel != null)
	  							rsModel.close();
	  						if (stmtModel != null)
	  							stmtModel.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					if (bChangeValue == true) {
						sSQLDeviceCols += "MODELID,";
						sSQLDeviceData += p[count] + ",";
					}
					
				} else if (columns[count].equals("STATUS")) {
					Statement stmtStatus = null;
					ResultSet rsStatus = null;
					try {
						stmtStatus = con.createStatement();
						rsStatus = stmtStatus.executeQuery("SELECT CATEGORY_VALUE1 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'DeviceStatus' AND (UPPER(CATEGORY_VALUE1) = '" + p[count].toUpperCase() + "' OR UPPER(CATEGORY_VALUE2) = '" + p[count].toUpperCase() + "')");
						String sCatValue = "";
						boolean bChangeValue = false;
						while (rsStatus.next()) {
							sCatValue = rsStatus.getString("CATEGORY_VALUE1");
							if (p[count].toUpperCase().equals(sCatValue.toUpperCase())) {
								p[count] = sCatValue;
								bChangeValue = true;
							} 
						}
						if (bChangeValue == false) {
							p[count] = "PENDING";
							bRCWarning = true;
							if (warnings[Integer.parseInt(p[0])] != null) {
	  							warnings[Integer.parseInt(p[0])] += "Invalid status value, changing to \"Pending\". ";
	  						} else {
	  							warnings[Integer.parseInt(p[0])] = p[0] + ": Invalid status value, changing to \"Pending\". ";
	  						}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						rsStatus.close();
	  						stmtStatus.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				} else if (columns[count].equals("CS") || columns[count].equals("VM") || columns[count].equals("MVS") || columns[count].equals("SAP") || columns[count].equals("WTS") || columns[count].equals("IMS")) {
					if (p[count].toUpperCase().equals("Y") || p[count].toUpperCase().equals("YES")) {
						p[count] = "Y";
					} else if (p[count].toUpperCase().equals("N") || p[count].toUpperCase().equals("NO")) {
						p[count] = "N";
					} else {
						p[count] = "-";
					}
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				} else if (columns[count].equals("FTP_SITE")) {
					ftpCheck = true;
					Statement stmtPrinterFTP = null;
					ResultSet rsPrinterFTP = null;
					try {
						stmtPrinterFTP = con.createStatement();
						rsPrinterFTP = stmtPrinterFTP.executeQuery("SELECT ftpid from gpws.ftp where ftp_site = '" + p[count] + "'");
		
						while (rsPrinterFTP.next()) {
							iFTPID = rsPrinterFTP.getInt("ftpid");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp ERROR: " + e);
	  				} finally {
	  					try {
	  						rsPrinterFTP.close();
	  						stmtPrinterFTP.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.1 ERROR: " + e);
	  					}
	  				}
	  				if (iFTPID != 0) {
	  					sSQLDeviceCols += "FTPID,";
	  					sSQLDeviceData += iFTPID + ",";
	  				}
	  			} else if(columns[count].equals("GEO") || columns[count].equals("COUNTRY") || columns[count].equals("STATE") || columns[count].equals("CITY") || columns[count].equals("BUILDING_NAME") || columns[count].equals("FLOOR_NAME")) {
	  				if (columns[count].equals("GEO")) {
	  					sGeo = p[count];
	  				} else if (columns[count].equals("COUNTRY")) {
	  					sCountry = p[count];
	  				} else if (columns[count].equals("STATE")) {
	  					sState = p[count];
	  				} else if (columns[count].equals("CITY")) {
	  					sCity = p[count];
	  				} else if (columns[count].equals("BUILDING_NAME")) {
	  					sBuilding = p[count];
	  				} else if (columns[count].equals("FLOOR_NAME")) {
	  					sFloor = p[count];
	  				}
	  				if (sGeo != null && sCountry != null && sState != null && sCity != null && sBuilding != null && sFloor != null) {
	  					Statement stmtPrinterLoc = null;
						ResultSet rsPrinterLoc = null;
	  					try {
							stmtPrinterLoc = con.createStatement();
							rsPrinterLoc = stmtPrinterLoc.executeQuery("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE BUILDING_NAME = '" + sBuilding + "' AND CITY = '" + sCity + "' AND STATE = '" + sState + "' AND COUNTRY = '" + sCountry + "' AND GEO = '" + sGeo + "' AND FLOOR_NAME = '" + sFloor + "'");
							while (rsPrinterLoc.next()) {
								sLocID = rsPrinterLoc.getInt("LOCID") + "";
							}
						} catch (Exception e) {
	  						System.out.println("GPWS error in ReceiveFiles.jsp.2 ERROR: " + e);
	  					} finally {
	  						try {
	  							if (rsPrinterLoc != null)
	  								rsPrinterLoc.close();
	  							if (stmtPrinterLoc != null)
	  								stmtPrinterLoc.close();
	  						} catch (Exception e){
		  						System.out.println("GPWS Error in ReceiveFiles.jsp.3 ERROR: " + e);
	  						}
	  					}
	  					if (!sLocID.equals("location not found")) {
	  						sSQLDeviceCols += "LOCID,";
	  						sSQLDeviceData += sLocID + ",";
	  					}
	  				}
	  				locCheck = true;
	  				
	  			} else if(columns[count].equals("COMM") || columns[count].equals("SPOOLER") || columns[count].equals("SUPERVISOR")) {
	  				if (columns[count].equals("COMM")) {
	  					sComm = p[count];
	  				} else if (columns[count].equals("SPOOLER")) {
	  					sSpooler = p[count];
	  				} else if (columns[count].equals("SUPERVISOR")) {
	  					sSuper = p[count];
	  				} 
	  				if (sComm != null && sSpooler != null && sSuper != null) {
	  					Statement stmtCommSpoolSuper = null;
						ResultSet rsCommSpoolSuper = null;
	  					try {
							stmtCommSpoolSuper = con.createStatement();
							rsCommSpoolSuper = stmtCommSpoolSuper.executeQuery("SELECT COMM_SPOOL_SUPERID FROM GPWS.COMM_SPOOLER_SUPERVISOR_VIEW WHERE COMM = '" + sComm + "' AND SPOOLER = '" + sSpooler + "' AND SUPERVISOR = '" + sSuper + "'");
							while (rsCommSpoolSuper.next()) {
								sCommSpoolSuperID = rsCommSpoolSuper.getInt("COMM_SPOOL_SUPERID") + "";
							}
						} catch (Exception e) {
	  						System.out.println("GPWS error in ReceiveFiles.jsp.2 ERROR: " + e);
	  					} finally {
	  						try {
	  							if (rsCommSpoolSuper != null)
	  								rsCommSpoolSuper.close();
	  							if (stmtCommSpoolSuper != null)
	  								stmtCommSpoolSuper.close();
	  						} catch (Exception e){
		  						System.out.println("GPWS Error in ReceiveFiles.jsp.3 ERROR: " + e);
	  						}
	  					}
	  					if (!sCommSpoolSuperID.equals("not found")) {
	  						sSQLDeviceCols += "COMM_SPOOL_SUPERID,";
	  						sSQLDeviceData += sCommSpoolSuperID + ",";
	  					} else {
	  						bRCWarning = true;
		  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
		  						warnings[Integer.parseInt(p[0])] += " Comm-spool-super combination not found. ";
		  					} else {
		  						warnings[Integer.parseInt(p[0])] = p[0] + ": Comm-spool-super combination not found. ";
		  					}
	  					}
	  				}
	  			} else if (columns[count].equals("DIPP")) {
	  				if (p[count].toUpperCase().equals("Y") || p[count].toUpperCase().equals("YES")) {
						p[count] = "Y";
						isDipp = true;
					} else {
						p[count] = "N";
					} 
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				} else if (columns[count].equals("IGS_ASSET") || columns[count].equals("IGS_DEVICE") || columns[count].equals("IGS_KEYOP") || columns[count].equals("DUPLEX") || columns[count].equals("PS") || columns[count].equals("PCL") || columns[count].equals("ASCII") || columns[count].equals("IPDS") || columns[count].equals("PPDS") || columns[count].equals("WEB_VISIBLE") || columns[count].equals("INSTALLABLE")) {
	  				if (p[count].toUpperCase().equals("Y") || p[count].toUpperCase().equals("YES")) {
						p[count] = "Y";
					} else {
						p[count] = "N";
					} 
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				} else if (columns[count].equals("E2E_CATEGORY")) {
					Statement stmtE2E = null;
					ResultSet rsE2E = null;
					boolean bE2E = false;
					try {
						stmtE2E = con.createStatement();
						rsE2E = stmtE2E.executeQuery("SELECT CATEGORY_VALUE1 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'E2ECategory' AND (CATEGORY_VALUE1 = '" + p[count] + "' OR CATEGORY_VALUE2 = '" + p[count] + "')");
		
						while (rsE2E.next()) {
							bE2E = true;
						}
						if (bE2E == false) {
							e2eCheck = false;
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsE2E != null)
	  							rsE2E.close();
	  						if (stmtE2E != null)
	  							stmtE2E.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
	  				if (e2eCheck == true) {
	  					sSQLDeviceCols += columns[count] + ",";
						sSQLDeviceData += "'" + p[count] + "',";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += " E2E Category field not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": E2E Category field not found";
	  					}
	  				}
	  			} else if (columns[count].equals("CONNECT_TYPE")) {
					Statement stmtConnect = null;
					ResultSet rsConnect = null;
					try {
						stmtConnect = con.createStatement();
						rsConnect = stmtConnect.executeQuery("SELECT CATEGORY_VALUE1 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'ConnectionType' AND (UPPER(CATEGORY_VALUE1) = '" + p[count].toUpperCase() + "' OR UPPER(CATEGORY_VALUE2) = '" + p[count].toUpperCase() + "')");
						String sCatValue = "";
						boolean bChangeValue = false;
						while (rsConnect.next()) {
							sCatValue = rsConnect.getString("CATEGORY_VALUE1");
							if (p[count].toUpperCase().equals(sCatValue.toUpperCase())) {
								p[count] = sCatValue;
								bChangeValue = true;
							} 
						}
						if (bChangeValue == false) {
							p[count] = "";
							bRCWarning = true;
							if (warnings[Integer.parseInt(p[0])] != null) {
	  							warnings[Integer.parseInt(p[0])] += "Invalid connect_type value. ";
	  						} else {
	  							warnings[Integer.parseInt(p[0])] = p[0] + ": Invalid connect_type value. ";
	  						}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						rsConnect.close();
	  						stmtConnect.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				} else if (columns[count].equals("ROOM_ACCESS")) {
					Statement stmtRoom = null;
					ResultSet rsRoom = null;
					try {
						stmtRoom = con.createStatement();
						rsRoom = stmtRoom.executeQuery("SELECT CATEGORY_VALUE1 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'RoomAccess' AND (UPPER(CATEGORY_VALUE1) = '" + p[count].toUpperCase() + "' OR UPPER(CATEGORY_VALUE2) = '" + p[count].toUpperCase() + "')");
						String sCatValue = "";
						boolean bChangeValue = false;
						while (rsRoom.next()) {
							sCatValue = rsRoom.getString("CATEGORY_VALUE1");
							if (p[count].toUpperCase().equals(sCatValue.toUpperCase())) {
								p[count] = sCatValue;
								bChangeValue = true;
							} 
						}
						if (bChangeValue == false) {
							p[count] = "";
							bRCWarning = true;
							if (warnings[Integer.parseInt(p[0])] != null) {
	  							warnings[Integer.parseInt(p[0])] += "Invalid room_access value. ";
	  						} else {
	  							warnings[Integer.parseInt(p[0])] = p[0] + ": Invalid room_access value. ";
	  						}
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.8 ERROR: " + e);
	  				} finally {
	  					try {
	  						rsRoom.close();
	  						stmtRoom.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.9 ERROR: " + e);
	  					}
	  				}
					
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				} else if (columns[count].equals("RESTRICT")) {
					p[count] = tool.EncryptString(p[count]);
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
	  			} else if (columns[count].equals("DEVICE_FUNCTION")) {
	  				deviceFunctions[deviceFunc] = p[count];
	  				deviceFunc++;
	  			} else if (columns[count].equals("OLD_DEVICE_NAME")) {
	  				sPrinterName = p[count];
	  			} else if (columns[count].equals("CREATED_BY") || columns[count].equals("CREATION_DATE") || columns[count].equals("MODIFIED_BY") || columns[count].equals("MODIFIED_DATE") || columns[count].equals("CREATED_BY") || columns[count].equals("CREATION_METHOD")) {
	  				// Don't let users update these fields. These are system managed fields.
				} else {
					if (columns[count].equals("DEVICE_NAME")) {
						sDeviceName = p[count];
					}
					sSQLDeviceCols += columns[count] + ",";
					sSQLDeviceData += "'" + p[count] + "',";
				}
			}
			if (Action.equals("INSERT_UPDATE")) {
				// Check to see if printer exists
				Statement stmtPrinter = null;
				ResultSet rsPrinter = null;
				String sSql = "";
				try {
					stmtPrinter = con.createStatement();
					if (sPrinterName != null && !sPrinterName.equals("")) {
						sSql = "SELECT DEVICEID FROM GPWS.DEVICE WHERE DEVICE_NAME = '" + sPrinterName + "' OR DEVICE_NAME = '" + sDeviceName + "'";
					} else {
						sSql = "SELECT DEVICEID FROM GPWS.DEVICE WHERE DEVICE_NAME = '" + sDeviceName + "'";
					}
					rsPrinter = stmtPrinter.executeQuery(sSql);
			
					while (rsPrinter.next()) {
						printerCheck = true;
					}
				} catch (Exception e) {
  					System.out.println("GPWS error in ReceiveFiles.jsp.10 ERROR: " + e);
  				} finally {
  					try {
  						if (rsPrinter != null)
  							rsPrinter.close();
  						if (stmtPrinter != null)
  							stmtPrinter.close();
  					} catch (Exception e){
	  					System.out.println("GPWS Error in ReceiveFiles.jsp.11 ERROR: " + e);
  					}
  				}
  			}
			sSQLDeviceCols = sSQLDeviceCols.substring(0,sSQLDeviceCols.length() - 1);
			if(Action.equals("INSERT")) {
				sSQLDeviceCols += ",CREATION_METHOD,CREATED_BY,CREATION_DATE) values (";
			} else {
				sSQLDeviceCols += ", MODIFIED_BY, MODIFIED_DATE) = (";
			}
			if (Action.equals("INSERT")) {
				sSQLDeviceData += "'Import','" + lastmodifiedby + "','" + lastmodified + "'";
			} else {
				sSQLDeviceData = sSQLDeviceData.substring(0,sSQLDeviceData.length() - 1) + ",'"+lastmodifiedby+"','"+lastmodified+"'";
			}
			sSQLDeviceData += ")";
			if(Action.equals("INSERT_UPDATE")) {
				if (sPrinterName == null || sPrinterName.equals("")) {
					sSQLDeviceData += " WHERE DEVICE_NAME = '" + sDeviceName + "'" ;
				} else {
					sSQLDeviceData += " WHERE DEVICE_NAME = '" + sPrinterName + "'" ;
				}
			}
			
			sb.append(sSQLDeviceCols + sSQLDeviceData);
			//sb2.append(sSQLPrtInfoCols + sSQLPrtInfoData);
			
			if(bRCWarning == true) {
				rowcountwarning++;
			}
		} else if(Table.equals("SERVER")) {
			String sServerName = "";
			String sSQLServCols = "";
			String sSQLServData = "";
			String sGeo = "";
			String sCountry = "";
			String sState = "";
			String sCity = "";
			String sBuilding = "";
			String sFloor = "";
			int iEnabID = 0;
			bValidEnab = true;
			columns[0] = "linenumber";
			if(Action.equals("INSERT")) {
				sSQLServCols = "INSERT INTO GPWS.SERVER (";
			} else {
				sSQLServCols = "UPDATE GPWS.SERVER SET (";
			}
			for (int count = 1; count < numCols; count++) {
				if (columns[count].equals("GEO")) {
					int iGeoID = 0;
					Statement stmtLoc = null;
					ResultSet rsLoc = null;
					boolean bEnab = false;
					sGeo = p[count];
					try {
						stmtLoc = con.createStatement();
						rsLoc = stmtLoc.executeQuery("SELECT GEOID FROM GPWS.GEO WHERE GEO = '" + p[count] + "'");
		
						while (rsLoc.next()) {
							iGeoID = rsLoc.getInt("GEOID");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsLoc != null)
	  							rsLoc.close();
	  						if (stmtLoc != null)
	  							stmtLoc.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (iGeoID != 0) {
	  					sSQLServCols += "GEOID,";
						sSQLServData += iGeoID + ",";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += ", Geography not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": Geography not found";
	  					}
	  				}
	  			} else if (columns[count].equals("COUNTRY")) {
					int iCountryID = 0;
					Statement stmtLoc = null;
					ResultSet rsLoc = null;
					boolean bEnab = false;
					sCountry = p[count];
					try {
						stmtLoc = con.createStatement();
						rsLoc = stmtLoc.executeQuery("SELECT COUNTRYID FROM GPWS.COUNTRY WHERE COUNTRY = '" + p[count] + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "')");
		
						while (rsLoc.next()) {
							iCountryID = rsLoc.getInt("COUNTRYID");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsLoc != null)
	  							rsLoc.close();
	  						if (stmtLoc != null)
	  							stmtLoc.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (iCountryID != 0) {
	  					sSQLServCols += "COUNTRYID,";
						sSQLServData += iCountryID + ",";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += ", Country not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": Country not found";
	  					}
	  				}
	  			} else if (columns[count].equals("STATE")) {
					int iStateID = 0;
					Statement stmtLoc = null;
					ResultSet rsLoc = null;
					boolean bEnab = false;
					sState = p[count];
					try {
						stmtLoc = con.createStatement();
						rsLoc = stmtLoc.executeQuery("SELECT STATEID FROM GPWS.STATE WHERE STATE = '" + p[count] + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE COUNTRY = '" + sCountry + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "'))");
		
						while (rsLoc.next()) {
							iStateID = rsLoc.getInt("STATEID");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsLoc != null)
	  							rsLoc.close();
	  						if (stmtLoc != null)
	  							stmtLoc.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (iStateID != 0) {
	  					sSQLServCols += "STATEID,";
						sSQLServData += iStateID + ",";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += ", State not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": State not found";
	  					}
	  				}
	  			} else if (columns[count].equals("CITY")) {
					int iCityID = 0;
					Statement stmtLoc = null;
					ResultSet rsLoc = null;
					boolean bEnab = false;
					sCity = p[count];
					try {
						stmtLoc = con.createStatement();
						rsLoc = stmtLoc.executeQuery("SELECT CITYID FROM GPWS.CITY WHERE CITY = '" + p[count] + "' AND STATEID = (SELECT STATEID FROM GPWS.STATE WHERE STATE = '" + sState + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE COUNTRY = '" + sCountry + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "')))");
		
						while (rsLoc.next()) {
							iCityID = rsLoc.getInt("CITYID");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsLoc != null)
	  							rsLoc.close();
	  						if (stmtLoc != null)
	  							stmtLoc.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (iCityID != 0) {
	  					sSQLServCols += "CITYID,";
						sSQLServData += iCityID + ",";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += ", City not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": City not found";
	  					}
	  				}
	  			} else if (columns[count].equals("BUILDING_NAME")) {
					int iBuildingID = 0;
					Statement stmtLoc = null;
					ResultSet rsLoc = null;
					boolean bEnab = false;
					sBuilding = p[count];
					try {
						stmtLoc = con.createStatement();
						rsLoc = stmtLoc.executeQuery("SELECT BUILDINGID FROM GPWS.BUILDING WHERE BUILDING_NAME = '" + p[count] + "' AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE CITY = '" + sCity + "' AND STATEID = (SELECT STATEID FROM GPWS.STATE WHERE STATE = '" + sState + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE COUNTRY = '" + sCountry + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "'))))");
		
						while (rsLoc.next()) {
							iBuildingID = rsLoc.getInt("BUILDINGID");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsLoc != null)
	  							rsLoc.close();
	  						if (stmtLoc != null)
	  							stmtLoc.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (iBuildingID != 0) {
	  					sSQLServCols += "BUILDINGID,";
						sSQLServData += iBuildingID + ",";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += ", Building not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": Building not found";
	  					}
	  				}
	  			} else if (columns[count].equals("FLOOR")) {
					int iLocID = 0;
					Statement stmtLoc = null;
					ResultSet rsLoc = null;
					boolean bEnab = false;
					sFloor = p[count];
					try {
						stmtLoc = con.createStatement();
						rsLoc = stmtLoc.executeQuery("SELECT LOCID FROM GPWS.LOCATION WHERE FLOOR_NAME = '" + p[count] + "' AND BUILDINGID = (SELECT BUILDINGID FROM GPWS.BUILDING WHERE BUILDING_NAME = '" + sBuilding + "' AND CITYID = (SELECT CITYID FROM GPWS.CITY WHERE CITY = '" + sCity + "' AND STATEID = (SELECT STATEID FROM GPWS.STATE WHERE STATE = '" + sState + "' AND COUNTRYID = (SELECT COUNTRYID FROM GPWS.COUNTRY WHERE COUNTRY = '" + sCountry + "' AND GEOID = (SELECT GEOID FROM GPWS.GEO WHERE GEO = '" + sGeo + "')))))");
		
						while (rsLoc.next()) {
							iLocID = rsLoc.getInt("LOCID");
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsLoc != null)
	  							rsLoc.close();
	  						if (stmtLoc != null)
	  							stmtLoc.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (iLocID != 0) {
	  					sSQLServCols += "LOCID,";
						sSQLServData += iLocID + ",";
	  				} else {
	  					bRCWarning = true;
	  					if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
	  						warnings[Integer.parseInt(p[0])] += ", Floor not found";
	  					} else {
	  						warnings[Integer.parseInt(p[0])] = p[0] + ": Floor not found";
	  					}
	  				}
	  			} else if (columns[count].equals("OLD_SERVER_NAME")) {
	  				sServerName = p[count];
	  				//System.out.println("server name = " + sServerName);
	  				//System.out.println("Action = " + Action);
	  				if (Action.equals("INSERT_UPDATE")) {
						// Check to see if server exists
						Statement stmtServer = null;
						ResultSet rsServer = null;
						//System.out.println("serverCheck = " + serverCheck);
						try {
							stmtServer = con.createStatement();
							rsServer = stmtServer.executeQuery("SELECT SERVERID FROM GPWS.SERVER WHERE SERVER_NAME = '" + sServerName + "'");
				
							while (rsServer.next()) {
								serverCheck = true;
							}
						} catch (Exception e) {
	  						System.out.println("GPWS error in ReceiveFiles.jsp.10 ERROR: " + e);
	  					} finally {
	  						try {
	  							if (rsServer != null)
	  								rsServer.close();
	  							if (stmtServer != null)
	  								stmtServer.close();
	  						} catch (Exception e){
		  						System.out.println("GPWS Error in ReceiveFiles.jsp.11 ERROR: " + e);
	  						}
	  					}
	  					//System.out.println("serverCheck = " + serverCheck);
	  				}
	  				//System.out.println("serverCheck2 = " + serverCheck);
	  			} else if (columns[count].equals("SERVER_NAME")) {
	  				sSQLServCols += columns[count] + ",";
					sSQLServData += "'" + p[count] + "',";
				} else {
					sSQLServCols += columns[count] + ",";
					sSQLServData += "'" + p[count] + "',";
				}
			}
  			sSQLServCols = sSQLServCols.substring(0,sSQLServCols.length() - 1);
			if(Action.equals("INSERT")) {
				sSQLServCols += ") values (";
			} else {
				sSQLServCols += ") = (";
			}
			sSQLServData = sSQLServData.substring(0,sSQLServData.length() - 1);
			sSQLServData += ")";
			if(Action.equals("INSERT_UPDATE")) {
				sSQLServData += " WHERE SERVER_NAME = '" + sServerName + "'";
			}
			
			if (Action.equals("INSERT_UPDATE")) {
				// Do nothing at this point
  			}
			
			sb.append(sSQLServCols + sSQLServData);
			
		} else if(Table.equals("ENBLHEADER")) {
			
			String sSQLEnabCols = "";
			String sSQLEnabData = "";
			int iEnabID = 0;
			bValidEnab = true;
			columns[0] = "linenumber";
			if(Action.equals("INSERT")) {
				sSQLEnabCols = "INSERT INTO ENBLHEADER (";
			} else {
				sSQLEnabCols = "UPDATE ENBLHEADER SET (";
			}
			for (int count = 1; count < numCols; count++) {
				if (columns[count].equals("ENBLHDRID")) {
					iEnabID = Integer.parseInt(p[count]);
				} else if (columns[count].equals("ENBLTYPE")) {
					Statement stmtEnabType = null;
					ResultSet rsEnabType = null;
					boolean bEnab = false;
					//boolean bEnabCheck = true;
					try {
						stmtEnabType = con.createStatement();
						rsEnabType = stmtEnabType.executeQuery("SELECT categoryvalue1 from category where category = 'EnblType' and (categoryvalue1 = '" + p[count] + "' or categoryvalue2 = '" + p[count] + "')");
		
						while (rsEnabType.next()) {
							bEnab = true;
						}
						if (bEnab == false) {
							bEnabCheck = false;
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsEnabType != null)
	  							rsEnabType.close();
	  						if (stmtEnabType != null)
	  							stmtEnabType.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (bEnabCheck == true) {
	  					sSQLEnabCols += columns[count] + ",";
						sSQLEnabData += "'" + p[count] + "',";
	  				} else {
	  					//bRCWarning = true;
	  					bValidEnab = false;
	  					if (errormsgs[Integer.parseInt(p[0])] != null && !errormsgs[Integer.parseInt(p[0])].equals("")) {
	  						errormsgs[Integer.parseInt(p[0])] += ", EnblType field not found";
	  					} else {
	  						errormsgs[Integer.parseInt(p[0])] = p[0] + ": EnblType field not found";
	  					}
	  				}
	  			} else if (columns[count].equals("STATUS")) {
					Statement stmtStatus = null;
					ResultSet rsStatus = null;
					boolean bSAP = false;
					boolean bSAPCheck = true;
					try {
						stmtStatus = con.createStatement();
						rsStatus = stmtStatus.executeQuery("SELECT categoryvalue1 from category where category = 'EnblStatus' and (categoryvalue1 = '" + p[count] + "' or categoryvalue2 = '" + p[count] + "')");
		
						while (rsStatus.next()) {
							bSAP = true;
						}
						if (bSAP == false) {
							bSAPCheck = false;
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S3 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsStatus != null)
	  							rsStatus.close();
	  						if (stmtStatus != null)
	  							stmtStatus.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S4 ERROR: " + e);
	  					}
	  				}
	  				if (bSAPCheck == true) {
	  					sSQLEnabCols += columns[count] + ",";
						sSQLEnabData += "'" + p[count] + "',";
	  				} else {
	  					//bRCWarning = true;
	  					//bValidSAP = false;
	  					if (errormsgs[Integer.parseInt(p[0])] != null && !errormsgs[Integer.parseInt(p[0])].equals("")) {
	  						errormsgs[Integer.parseInt(p[0])] += ", Status field not found";
	  					} else {
	  						errormsgs[Integer.parseInt(p[0])] = p[0] + ": Status field not found";
	  					}
	  				}
				} else {
					sSQLEnabCols += columns[count] + ",";
					sSQLEnabData += "'" + p[count] + "',";
				}
			}
  			sSQLEnabCols = sSQLEnabCols.substring(0,sSQLEnabCols.length() - 1);
			if(Action.equals("INSERT")) {
				sSQLEnabCols += ") values (";
			} else {
				sSQLEnabCols += ") = (";
			}
			sSQLEnabData = sSQLEnabData.substring(0,sSQLEnabData.length() - 1);
			sSQLEnabData += ")";
			if(Action.equals("INSERT_UPDATE")) {
				sSQLEnabData += " WHERE ENBLHDRID = " + iEnabID;
			}
			
			if (Action.equals("INSERT_UPDATE")) {
				// Do nothing at this point
  			}
			
			sb.append(sSQLEnabCols + sSQLEnabData);
			
		} else if(Table.equals("ENBLDETAIL")) {
			String sSQLEnabCols = "";
			String sSQLEnabData = "";
			int iEnabID = 0;
			bValidEnab = true;
			columns[0] = "linenumber";
			if(Action.equals("INSERT")) {
				sSQLEnabCols = "INSERT INTO ENBLDETAIL (";
			} else {
				sSQLEnabCols = "UPDATE ENBLDETAIL SET (";
			}
			for (int count = 1; count < numCols; count++) {
				if (columns[count].equals("ENBLDTLID")) {
					iEnabID = Integer.parseInt(p[count]);
				} else if (columns[count].equals("ENBLTYPE")) {
					Statement stmtEnabType = null;
					ResultSet rsEnabType = null;
					boolean bEnab = false;
					//boolean bEnabCheck = true;
					try {
						stmtEnabType = con.createStatement();
						rsEnabType = stmtEnabType.executeQuery("SELECT categoryvalue1 from category where category = 'EnblType' and (categoryvalue1 = '" + p[count] + "' or categoryvalue2 = '" + p[count] + "')");
		
						while (rsEnabType.next()) {
							bEnab = true;
						}
						if (bEnab == false) {
							bEnabCheck = false;
						}
					} catch (Exception e) {
	  					System.out.println("GPWS error in ReceiveFiles.jsp.S1 ERROR: " + e);
	  				} finally {
	  					try {
	  						if (rsEnabType != null)
	  							rsEnabType.close();
	  						if (stmtEnabType != null)
	  							stmtEnabType.close();
	  					} catch (Exception e){
		  					System.out.println("GPWS Error in ReceiveFiles.jsp.S2 ERROR: " + e);
	  					}
	  				}
	  				if (bEnabCheck == true) {
	  					sSQLEnabCols += columns[count] + ",";
						sSQLEnabData += "'" + p[count] + "',";
	  				} else {
	  					//bRCWarning = true;
	  					bValidEnab = false;
	  					if (errormsgs[Integer.parseInt(p[0])] != null && !errormsgs[Integer.parseInt(p[0])].equals("")) {
	  						errormsgs[Integer.parseInt(p[0])] += ", EnblType field not found";
	  					} else {
	  						errormsgs[Integer.parseInt(p[0])] = p[0] + ": EnblType field not found";
	  					}
	  				}
	  			} else if (columns[count].equals("SEQ")) {
	  				sSQLEnabCols += columns[count] + ",";
					sSQLEnabData += p[count] + ",";
				} else {
					sSQLEnabCols += columns[count] + ",";
					sSQLEnabData += "'" + p[count] + "',";
				}
			}
  			sSQLEnabCols = sSQLEnabCols.substring(0,sSQLEnabCols.length() - 1);
			if(Action.equals("INSERT")) {
				sSQLEnabCols += ") values (";
			} else {
				sSQLEnabCols += ") = (";
			}
			sSQLEnabData = sSQLEnabData.substring(0,sSQLEnabData.length() - 1);
			sSQLEnabData += ")";
			if(Action.equals("INSERT_UPDATE")) {
				sSQLEnabData += " WHERE ENBLDTLID = " + iEnabID;
			}
			
			if (Action.equals("INSERT_UPDATE")) {
				// Do nothing at this point
  			}
			
			sb.append(sSQLEnabCols + sSQLEnabData);
			//System.out.println("sb = " + sb);
		} // End table checks
		
		sql = sb.toString();
		//sql = sql.replace('"','\'');
	
		/*d = 0;
		for(c=0;c < sql.length();c++) {
			if(sql.charAt(c) == '\\') {
				newsql += sql.substring(d,c);
				y =  c +1;		
				c++;
			}
		}*/
		//newsql += sql.substring(y,sql.length());
		
		System.out.println("SQL = " + sql);
		pstmt = con.prepareStatement(sql);
		
		for (int g=0; g < maxDevFunc; g++) {
			if ( deviceFunctions[g] != null && !deviceFunctions[g].equals("null") && !deviceFunctions[g].equals("")) {
				if (deviceFunctions[g].equals("copy")) {
					isCopier = true;
					for (int req = 0; req < copfaxReqFields.length - 1; req++) {
						if (copfaxReqExist[req] == false) {
							reqFieldCheck = false;
							break;
						}
					}
				} else if (deviceFunctions[g].equals("fax")) {
					isFax = true;
					for (int req = 0; req < copfaxReqFields.length; req++) {
						if (copfaxReqExist[req] == false) {
							reqFieldCheck = false;
							break;
						}
					}
				} else 	if (deviceFunctions[g].equals("print")) {
					isPrinter = true;
					for (int req = 0; req < prtReqFields.length; req++) {
						if (prtReqExist[req] == false) {
							reqFieldCheck = false;
							break;
						}
					}
				}  
			} 
		}
		
		String sDeviceIs = "";
		if (Action.equals("INSERT") && Table.equals("DEVICE")) {
			if (isFax == true && isCopier == false && isPrinter == false) {
				sDeviceIs = "fax";
			} else if (isCopier == true && isPrinter == false) {
				sDeviceIs = "copy";
			} else if (isPrinter == true) {
				sDeviceIs = "print";
			}
							
			if (sDeviceIs.equals("print")) {
				if (sDeviceName == null || sDeviceName.length() < 6 || (isDipp == false && isVPSX == false && sDeviceName.charAt(5) != 'l')) {
					deviceNameError = true;
					if (errormsgs[Integer.parseInt(p[0])] != null) {
	  					errormsgs[Integer.parseInt(p[0])] += "Invalid device name. The 6th character must be an 'l' for printers. ";
	  				} else {
	  					errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid device name. The 6th character must be an 'l' for printers. ";
	  				}
				} else if (sDeviceName == null || sDeviceName.length() < 6 || (isDipp == false && isVPSX == true && sDeviceName.charAt(5) != 'v')) {
					deviceNameError = true;
					if (errormsgs[Integer.parseInt(p[0])] != null) {
	  					errormsgs[Integer.parseInt(p[0])] += "Invalid device name. The 6th character must be a 'v' for VPSX printers. ";
	  				} else {
	  					errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid device name. The 6th character must be a 'v' for VPSX printers. ";
	  				}
	  			} else if (sDeviceName == null || sDeviceName.length() < 6 || (isDipp == true && sDeviceName.charAt(5) != 'x')) {
					deviceNameError = true;
					if (errormsgs[Integer.parseInt(p[0])] != null) {
	  					errormsgs[Integer.parseInt(p[0])] += "Invalid device name. The 6th character must be an 'x' for dipp printers. ";
	  				} else {
	  					errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid device name. The 6th character must be an 'x' for dipp printers. ";
	  				}
	  			}
			} else if (sDeviceIs.equals("copy") && (sDeviceName == null || sDeviceName.length() < 6 || sDeviceName.charAt(5) != 'c')) {
				deviceNameError = true;
				if (errormsgs[Integer.parseInt(p[0])] != null) {
  					errormsgs[Integer.parseInt(p[0])] += "Invalid device name. The 6th character must be a 'c' for copiers. ";
  				} else {
  					errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid device name. The 6th character must be a 'c' for copiers. ";
  				}
			} else if (sDeviceIs.equals("fax") && (sDeviceName == null || sDeviceName.length() < 6 || sDeviceName.charAt(5) != 'f')) {
				deviceNameError = true;
				if (errormsgs[Integer.parseInt(p[0])] != null) {
  					errormsgs[Integer.parseInt(p[0])] += "Invalid device name. The 6th character must be an 'f' for faxes. ";
  				} else {
  					errormsgs[Integer.parseInt(p[0])] = p[0] + ": Invalid device name. The 6th character must be an 'f' for faxes. ";
  				}
			}
  		}		
		
		if(Action.equals("INSERT")) {
			if (Table.equals("DEVICE") && y > 0) {
				if (reqFieldCheck == false) {
					errormsgs[rowcounterror] = p[0] + ": You are missing the following required field(s): ";
					if (sDeviceIs.equals("copy")) {
						for (int req = 0; req < copfaxReqFields.length - 1; req++) {
							if (copfaxReqExist[req] == false) {
								errormsgs[rowcounterror] += copfaxReqFields[req] + ", ";
							}
						}
					} else if (sDeviceIs.equals("fax")) {
						for (int req = 0; req < copfaxReqFields.length; req++) {
							if (copfaxReqExist[req] == false) {
								errormsgs[rowcounterror] += copfaxReqFields[req] + ", ";
							}
						}
					} else {
						for (int req = 0; req < prtReqFields.length; req++) {
							if (prtReqExist[req] == false) {
								errormsgs[rowcounterror] += prtReqFields[req] + ", ";
							}
						}
					}
					rsMain = -1;
				} else if (locCheck == true && sLocID.equals("location not found")) {
					errormsgs[rowcounterror] = p[0] + ": Location not found. Check the location information and make sure it is correct.";
					rsMain = -1;
				} else if (deviceNameError == true) {
					rsMain = -1;
				} else if (isPrinter == true && ftpCheck == true && iFTPID == 0) {
					errormsgs[rowcounterror] = p[0] + ": FTP id not found. Check the ftp site name and make sure it is correct.";
					rsMain = -1;
				} else if (isPrinter == true && driverSet == false) {
					errormsgs[rowcounterror] = p[0] + ": Driver set not found. Please check the driver set name and make it is correct and exists in the system.";
					rsMain = -1;
				} else if (isPrinter == true && printerDefType == false) {
					errormsgs[rowcounterror] = p[0] + ": Printer definition type not found. Please check the printer definition type name and make sure it is correct and exists in the system.";
					rsMain = -1;
				} else if (modelCheck == false) {
					errormsgs[rowcounterror] = p[0] + ": Model not found. Please check the model name and make sure it is correct and exists in the system.";
					rsMain = -1;
				//} else if (e2eCheck == false) {
				//	errormsgs[rowcounterror] = p[0] + ": EndtoEnd value does not exist. Please change it to a valid value and try again.";
				//	rsMain = -1;
				} else {
					try {
						rsMain = pstmt.executeUpdate();
						//need to get new printer id now
						if (rsMain == 1) {
							Statement stmtDevice = null;
							ResultSet rsDevice = null;
							int iDeviceID = 0;
							try {
								stmtDevice = con.createStatement();
								rsDevice = stmtDevice.executeQuery("SELECT DEVICEID FROM GPWS.DEVICE WHERE DEVICE_NAME = '" + sDeviceName + "'");
					
								while (rsDevice.next()) {
									iDeviceID = rsDevice.getInt("DEVICEID");
								}
							} catch (Exception e) {
		  						System.out.println("GPWS error in ReceiveFiles.jsp.10 ERROR: " + e);
		  					} finally {
		  						try {
		  							if (rsDevice != null)
		  								rsDevice.close();
		  							if (stmtDevice != null)
		  								stmtDevice.close();
		  						} catch (Exception e){
			  						System.out.println("GPWS Error in ReceiveFiles.jsp.11 ERROR: " + e);
		  						}
		  					}
							for (int g=0; g < maxDevFunc; g++) {
								if ( deviceFunctions[g] == null || deviceFunctions[g].equals("null") || deviceFunctions[g].equals("")) {
									//do nothing
								} else if (tool.validDeviceFunction(tool.nullStringConverter(deviceFunctions[g])) != true) {
									bRCWarning = true;
		  							if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
		  								warnings[Integer.parseInt(p[0])] += " Device function (" + deviceFunctions[g] + ") invalid.";
		  							} else {
		  								warnings[Integer.parseInt(p[0])] = p[0] + ": Device function (" + deviceFunctions[g] + ") invalid.";
		  							}
								} else if (tool.DeviceFunctionExist(deviceFunctions[g], iDeviceID) == true) {
									bRCWarning = true;
		  							if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
		  								warnings[Integer.parseInt(p[0])] += " Device function (" + deviceFunctions[g] + ") already exists for device.";
		  							} else {
		  								warnings[Integer.parseInt(p[0])] = p[0] + ": Device function (" + deviceFunctions[g] + ") already exists for device.";
		  							}
								} else {
									if (iDeviceID != 0 && !deviceFunctions[g].equals("")) {
										sql2 = "INSERT INTO GPWS.DEVICE_FUNCTIONS (FUNCTION_NAME,DEVICEID) VALUES ('" + deviceFunctions[g] + "'," + iDeviceID + ")";
										pstmt2 = con.prepareStatement(sql2);
										pstmt2.executeUpdate();
									}
								}
							}
						} else {
							errormsgs[rowcounterror] = p[0] + ": Error inserting printer.";
						}
					} catch (Exception e) {
						System.out.println("ERROR in ReceiveFiles.jsp.Insert: " + e);
						appTool.logError("ReceiveFiles.jsp","GPWSAdmin",e);
						if (e.toString().indexOf("DuplicateKeyException") > 0) {
							errormsgs[rowcounterror] = p[0] + ": Device " + sDeviceName + " already exists.";
						}
					}
				}
			} else if (Table.equals("SERVER")) {
				if (reqFieldCheck == false) {
					errormsgs[rowcounterror] = p[0] + ": You are missing required field(s). Please check the required fields list and make sure you have included all of them.";
					rsMain = -1;
				} else {
					rsMain = pstmt.executeUpdate();
				}
			} else if (Table.equals("ENBLHEADER") || Table.equals("ENBLDETAIL")) {
				if (reqFieldCheck == false) {
					errormsgs[rowcounterror] = p[0] + ": You are missing required field(s). Please check the required fields list and make sure you have included all of them.";
					rsMain = -1;
				} else if (bEnabCheck == false) {
					//errormsgs[rowcounterror] = p[0] + ": Error(s) importing SAP value. Check the warnings section for the exact errors.";
					rsMain = -1;
				} else {
					rsMain = pstmt.executeUpdate();
				}
			} else {
				rsMain = pstmt.executeUpdate();
			}
			//pstmt.executeUpdate();
		} else if(Action.equals("INSERT_UPDATE")) {
			if (Table.equals("DEVICE") && y > 0) {
				if (printerCheck == false) {
					errormsgs[rowcounterror] = p[0] + ": The printer was not found in the database. Please make sure it exists and try again.";
					rsMain = -1;
				} else if (locCheck == true && sLocID.equals("location not found")) {
					errormsgs[rowcounterror] = p[0] + ": Location not found. Check the location information and make sure it is correct.";
					rsMain = -1;
				} else if (ftpCheck == true && iFTPID == 0) {
					errormsgs[rowcounterror] = p[0] + ": FTP id not found. Check the ftp site name and make sure it is correct.";
					rsMain = -1;
				} else if (driverSetCheck == true && driverSet == false) {
					errormsgs[rowcounterror] = p[0] + ": Driver set not found. Please check the driver set name and make it is correct and exists in the system.";
					rsMain = -1;
				} else if (printerDefTypeCheck == true && printerDefType == false) {
					errormsgs[rowcounterror] = p[0] + ": Printer definition type not found. Please check the printer definition type name and make sure it is correct and exists in the system.";
					rsMain = -1;
				} else {
					rsMain = pstmt.executeUpdate();
					
					//Update device functions
					Statement stmtDevice = null;
					ResultSet rsDevice = null;
					int iDeviceID = 0;
					try {
						stmtDevice = con.createStatement();
						rsDevice = stmtDevice.executeQuery("SELECT DEVICEID FROM GPWS.DEVICE WHERE DEVICE_NAME = '" + sDeviceName + "'");
			
						while (rsDevice.next()) {
							iDeviceID = rsDevice.getInt("DEVICEID");
						}
					} catch (Exception e) {
  						System.out.println("GPWS error in ReceiveFiles.jsp.10 ERROR: " + e);
  					} finally {
  						try {
  							if (rsDevice != null)
  								rsDevice.close();
  							if (stmtDevice != null)
  								stmtDevice.close();
  						} catch (Exception e){
	  						System.out.println("GPWS Error in ReceiveFiles.jsp.11 ERROR: " + e);
  						}
  					}

					for (int g=0; g < maxDevFunc; g++) {
						if ( deviceFunctions[g] == null || deviceFunctions[g].equals("null") || deviceFunctions[g].equals("")) {
							//do nothing
						} else if (tool.validDeviceFunction(tool.nullStringConverter(deviceFunctions[g])) != true) {
							bRCWarning = true;
  							if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
  								warnings[Integer.parseInt(p[0])] += " Device function (" + deviceFunctions[g] + ") invalid.";
  							} else {
  								warnings[Integer.parseInt(p[0])] = p[0] + ": Device function (" + deviceFunctions[g] + ") invalid.";
  							}
						} else if (tool.DeviceFunctionExist(deviceFunctions[g], iDeviceID) == true) {
							bRCWarning = true;
  							if (warnings[Integer.parseInt(p[0])] != null && !warnings[Integer.parseInt(p[0])].equals("")) {
  								warnings[Integer.parseInt(p[0])] += " Device function (" + deviceFunctions[g] + ") already exists for device.";
  							} else {
  								warnings[Integer.parseInt(p[0])] = p[0] + ": Device function (" + deviceFunctions[g] + ") already exists for device.";
  							}
						} else {
							if (iDeviceID != 0 && !deviceFunctions[g].equals("")) {
								sql2 = "INSERT INTO GPWS.DEVICE_FUNCTIONS (FUNCTION_NAME,DEVICEID) VALUES ('" + deviceFunctions[g] + "'," + iDeviceID + ")";
								pstmt2 = con.prepareStatement(sql2);
								pstmt2.executeUpdate();
							}
						}
					}
				}
			} else if (Table.equals("SERVER")) {
				if (serverCheck == false) {
					errormsgs[rowcounterror] = p[0] + ": The server was not found in the database. Please make sure it exists and try again.";
					rsMain = -1;
				} else {
					rsMain = pstmt.executeUpdate();
				}
			} else if (Table.equals("ENBLHEADER") || Table.equals("ENBLDETAIL")) {
				if (bEnabCheck == false) {
					//errormsgs[rowcounterror] = p[0] + ": Error(s) importing SAP value. Check the warnings section for the exact errors.";
					rsMain = -1;
				//} else if (sapPrtCheck == false) {
				//	errormsgs[rowcounterror] = p[0] + ": The sap printer was not found in the database. Please make sure it exists and try again.";
				//	rsMain = -1;
				} else {
					rsMain = pstmt.executeUpdate();
				}
			} else {
				rsMain = pstmt.executeUpdate();
			}
		//else if(Action.equals("REPLACE"))
		//rsMain = pstmt.executeQuery(sql);
		}
		//if( (rsMain == 0 && Action.equals("INSERT")) || (rsMain == 1 && Action.equals("INSERT_UPDATE"))) {
		if(rsMain == 1) {
			rowcount++;
		} else {
			rowcounterror++;
			errorrows[rowcounterror] = p[0] + "";
		}
		//rowcount++;
		linenum++;
	}
	if (Action.equals("INSERT_UPDATE")) { 
		if (rowcount == 1) { %>
			<br /><%= rowcount %> <%= messages.getString("row_successfully_updated") %>
<%		} else { %>
			<br /><%= rowcount %> <%= messages.getString("rows_successfully_updated") %>
<%		}
	} else if (Action.equals("INSERT")) {
		if (rowcount == 1) { %>
			<br /><%= rowcount %> <%= messages.getString("row_successfully_inserted") %>
<%		} else { %>
			<br /><%= rowcount %> <%= messages.getString("rows_successfully_inserted") %>
<%		}
	} else { %>
		<br /><%= rowcount %> <%= messages.getString("row_completed_successfully") %>
<%	} 
		if (rowcounterror == 1) { %>
			<br /><%= rowcounterror %> <%= messages.getString("row_was_unsuccessful") %>
<%		} else { %>
			<br /><%= rowcounterror %> <%= messages.getString("rows_were_unsuccessful") %>
<%		}
		if (lineignore == 1) { %>
			<br /><%= lineignore %> <%= messages.getString("row_was_ignored") %>
<%		} else { %>	
			<br /><%= lineignore %> <%= messages.getString("rows_were_ignored") %>
<%		}
		 if (rowcounterror > 0) { %>
				<br /><br /><b>Errors:<br /></b><%
			   for (int mc = 0; mc < errormsgs.length; mc++) {
					if(errormsgs[mc] != null) { %>
						<%= errormsgs[mc] %><br />
			<%		}
			   }
		   }

		 if (rowcountwarning > 0 || bRCWarning == true) { %>
				<br /><br /><b>Warnings:</b><br /><%
			   for (int mc = 0; mc < warnings.length; mc++) {
					if(warnings[mc] != null) { %>
						<%= warnings[mc] %><br />
			<%		}
			   }
		   }
	appTool.logUserAction(pupb.getUserLoginID(),"Mass database update executed","GPWSAdmin");
} catch (Exception e) {
	System.out.println("ERROR in ReceiveFiles.jsp: " + e);
	appTool.logError("ReceiveFiles.jsp","GPWSAdmin",e);
%>
	<br /><%= rowcount %> row(s) completed successfully.<br />
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
	if (pstmt != null)
		pstmt.close();
	if (con != null)
		con.close();
}
%>
		</div><!-- END col-1-1 div -->
	</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>