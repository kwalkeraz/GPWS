GEO,COUNTRY,STATE,CITY,BUILDING_NAME,FLOOR_NAME,ROOM,DEVICE_NAME,LPNAME,WEB_VISIBLE,INSTALLABLE,STATUS,FTP_SITE,PRINTER_DEF_TYPE,DRIVER_SET,MODEL,SERVER,SERVER_SDC,COMM,SPOOLER,SUPERVISOR,ROOM_ACCESS,ROOM_PHONE,LAN_DROP,CONNECT_TYPE,E2E_CATEGORY,CS,VM,SAP,WTS,SEPARATOR_PAGE,RESTRICT,REQUEST_NUMBER,IGS_ASSET,IGS_DEVICE,IGS_KEYOP,DUPLEX,NUMBER_TRAYS,BODY_TRAY,HEADER_TRAY,SERIAL_NUMBER,MAC_ADDRESS,COMMENT,DIPP,KO_NAME,KO_EMAIL,KO_COMPANY,KO_PAGER,KO_PHONE,FAX_NUMBER,BILL_DEPT,BILL_DIV,BILL_DETAIL,BILL_EMAIL,BILL_NAME,IP_DOMAIN,IP_SUBNET,IP_GATEWAY,IP_HOSTNAME,IP_ADDRESS,PORT,POOL_NAME,PS,PCL,ASCII,IPDS,PPDS,IPM_QUEUE_NAME,PS_DEST_NAME,AFP_DEST_NAME,CREATED_BY,CREATION_DATE,MODIFIED_BY,MODIFIED_DATE,INSTALL_DATE,DELETE_DATE,CREATION_METHOD,DEVICE_FUNCTION,DEVICE_FUNCTION,DEVICE_FUNCTION,DEVICE_FUNCTION<%@ page contentType="application/x-msexcel" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.printer.*,java.util.*,java.io.*,java.net.*" %>
<% TableQueryBhvr DeviceSearchList  = (TableQueryBhvr) request.getAttribute("DeviceSearchList");
   TableQueryBhvrResultSet DeviceSearchList_RS = DeviceSearchList.getResults();
   TableQueryBhvr DeviceFunctionsView = (TableQueryBhvr) request.getAttribute("DeviceFunctions");
   TableQueryBhvrResultSet DeviceFunctionsView_RS = DeviceFunctionsView.getResults();
   TableQueryBhvr DeviceStatus = (TableQueryBhvr) request.getAttribute("DeviceStatus");
   TableQueryBhvrResultSet DeviceStatus_RS = DeviceStatus.getResults();
   
   String lastDeviceName = "";  //last dev found
   PrinterTools appTool = new PrinterTools();
	String[] aFunctions = new String[DeviceFunctionsView_RS.getResultSetSize()];
	String[] aFunctions2 = new String[DeviceFunctionsView_RS.getResultSetSize()];
	int x = 0;
	while (DeviceFunctionsView_RS.next()) {
		aFunctions[x] = DeviceFunctionsView_RS.getString("CATEGORY_VALUE1");
		aFunctions2[x] = DeviceFunctionsView_RS.getString("CATEGORY_VALUE2");
		x++;
	}
	
	int deviceid = 0;
	int locIDValue = 0;
	String geo = "";
	String country = "";
	String state = "";
	String city = "";
	String building = "";
	String floor = "";
	String room = "";
	String roomaccess = "";
	String roomphone = "";
	String status = "";
	String model = "";
	String restrict = "";
	String webvisible = "";
	String installable = "";
	String driversetname = "";
	String ftpsite = "";
	String landrop = "";
	String connecttype = "";
	String ipdomain = "";
	String ipsubnet = "";
	String ipgateway = "";
	String iphostname = "";
	String ipaddress = "";
	String macaddress = "";
	String e2ecategory = "";
	String cs = "";
	String vm = "";
	String sap = "";
	String wts = "";
	String lpname = "";
	String port = "";
	String sdc = "";
	String server = "";
	String comm = "";
	String commport = "";
	String spooler = "";
	String spoolerport = "";
	String supervisor = "";
	String supervisorport = "";
	String clientdeftype = "";
	String serverdeftype = "";
	String separatorpage = "";
	String poolname = "";
	String ipmqueuename = "";
	String psdestname = "";
	String afpdestname = "";
	String ps = "";
	String pcl = "";
	String ascii = "";
	String ipds = "";
	String ppds = "";
	String reqnumber = "";
	String igsasset = "";
	String igsdevice = "";
	String igskeyop = "";
	String duplex = "";
	String numtray = "";
	String bodytray = "";
	String headertray = "";
	String serialnum = ""; 
	String comment = "";
	String dipp = "";
	String koname = "";
	String kophone = "";
	String koemail = "";
	String kocompany = "";
	String kopager = "";
	String faxnumber = "";
	String billdept = "";
	String billdiv = "";
	String billdetail = "";
	String billemail = "";
	String billname = "";
	String createdby = "";
	java.sql.Timestamp creationdate;
	String creationmethod = "";
	String modifiedby = "";
	java.sql.Timestamp modifieddate;
	String installdate = "";
	String deletedate = "";
	String devFunc = "";
	String deviceName = "";
	String devFuncName = "";
	lastDeviceName = "";
	int devFuncCounter = 0;
	int numDevices = 0;
	response.setHeader("Content-disposition","attachment; filename=Devices.csv");
		while (DeviceSearchList_RS.next()) {
			geo = appTool.nullStringConverter(DeviceSearchList_RS.getString("GEO"));
			country = appTool.nullStringConverter(DeviceSearchList_RS.getString("COUNTRY"));
			state = appTool.nullStringConverter(DeviceSearchList_RS.getString("STATE"));
			city = appTool.nullStringConverter(DeviceSearchList_RS.getString("CITY"));
			building = appTool.nullStringConverter(DeviceSearchList_RS.getString("BUILDING_NAME"));
			floor = appTool.nullStringConverter(DeviceSearchList_RS.getString("FLOOR_NAME").trim());
			room = appTool.nullStringConverter(DeviceSearchList_RS.getString("ROOM"));
			roomaccess = appTool.nullStringConverter(DeviceSearchList_RS.getString("ROOM_ACCESS"));			
			roomphone = appTool.nullStringConverter(DeviceSearchList_RS.getString("ROOM_PHONE"));			
			deviceName = appTool.nullStringConverter(DeviceSearchList_RS.getString("DEVICE_NAME"));						
			model = appTool.nullStringConverter(DeviceSearchList_RS.getString("MODEL"));
			devFunc = appTool.nullStringConverter(DeviceSearchList_RS.getString("FUNCTION_NAME"));
			status = appTool.nullStringConverter(DeviceSearchList_RS.getString("STATUS"));
			webvisible = appTool.nullStringConverter(DeviceSearchList_RS.getString("WEB_VISIBLE"));
			 installable = appTool.nullStringConverter(DeviceSearchList_RS.getString("INSTALLABLE"));
			 driversetname = appTool.nullStringConverter(DeviceSearchList_RS.getString("DRIVER_SET_NAME"));
			 ftpsite = appTool.nullStringConverter(DeviceSearchList_RS.getString("FTP_SITE"));
			 landrop = appTool.nullStringConverter(DeviceSearchList_RS.getString("LAN_DROP"));
			 connecttype = appTool.nullStringConverter(DeviceSearchList_RS.getString("CONNECT_TYPE"));
			 ipdomain = appTool.nullStringConverter(DeviceSearchList_RS.getString("IP_DOMAIN"));
			 ipsubnet = appTool.nullStringConverter(DeviceSearchList_RS.getString("IP_SUBNET"));
			 ipgateway = appTool.nullStringConverter(DeviceSearchList_RS.getString("IP_GATEWAY"));
			 iphostname = appTool.nullStringConverter(DeviceSearchList_RS.getString("IP_HOSTNAME"));
			 ipaddress = appTool.nullStringConverter(DeviceSearchList_RS.getString("IP_ADDRESS"));
			 macaddress = appTool.nullStringConverter(DeviceSearchList_RS.getString("MAC_ADDRESS"));
			 e2ecategory = appTool.nullStringConverter(DeviceSearchList_RS.getString("E2E_CATEGORY"));
			 cs = appTool.nullStringConverter(DeviceSearchList_RS.getString("CS"));
			 vm = appTool.nullStringConverter(DeviceSearchList_RS.getString("VM"));
			 sap = appTool.nullStringConverter(DeviceSearchList_RS.getString("SAP"));
			 wts = appTool.nullStringConverter(DeviceSearchList_RS.getString("WTS"));
			 lpname = appTool.nullStringConverter(DeviceSearchList_RS.getString("LPNAME"));
			 port = appTool.nullStringConverter(DeviceSearchList_RS.getString("PORT"));
			 sdc = appTool.nullStringConverter(DeviceSearchList_RS.getString("SERVER_SDC"));
			 server = appTool.nullStringConverter(DeviceSearchList_RS.getString("SERVER_NAME"));
			 comm = appTool.nullStringConverter(DeviceSearchList_RS.getString("COMM"));
			 commport = appTool.nullStringConverter(DeviceSearchList_RS.getString("COMM_PORT"));
			 spooler = appTool.nullStringConverter(DeviceSearchList_RS.getString("SPOOLER"));
			 spoolerport = appTool.nullStringConverter(DeviceSearchList_RS.getString("SPOOLER_PORT"));
			 supervisor = appTool.nullStringConverter(DeviceSearchList_RS.getString("SUPERVISOR"));
			 supervisorport = appTool.nullStringConverter(DeviceSearchList_RS.getString("SUPERVISOR_PORT"));
			 clientdeftype = appTool.nullStringConverter(DeviceSearchList_RS.getString("CLIENT_DEF_TYPE"));
			 serverdeftype = appTool.nullStringConverter(DeviceSearchList_RS.getString("SERVER_DEF_TYPE"));
			 separatorpage = appTool.nullStringConverter(DeviceSearchList_RS.getString("SEPARATOR_PAGE"));
			 poolname = appTool.nullStringConverter(DeviceSearchList_RS.getString("POOL_NAME"));
			 ipmqueuename = appTool.nullStringConverter(DeviceSearchList_RS.getString("IPM_QUEUE_NAME"));
			 psdestname = appTool.nullStringConverter(DeviceSearchList_RS.getString("PS_DEST_NAME"));
			 afpdestname = appTool.nullStringConverter(DeviceSearchList_RS.getString("AFP_DEST_NAME"));
			 ps = appTool.nullStringConverter(DeviceSearchList_RS.getString("PS"));
			 pcl = appTool.nullStringConverter(DeviceSearchList_RS.getString("PCL"));
			 ascii = appTool.nullStringConverter(DeviceSearchList_RS.getString("ASCII"));
			 ipds = appTool.nullStringConverter(DeviceSearchList_RS.getString("IPDS"));
			 ppds = appTool.nullStringConverter(DeviceSearchList_RS.getString("PPDS"));
			 reqnumber = appTool.nullStringConverter(DeviceSearchList_RS.getString("REQUEST_NUMBER"));
			 igsasset = appTool.nullStringConverter(DeviceSearchList_RS.getString("IGS_ASSET"));
			 igsdevice = appTool.nullStringConverter(DeviceSearchList_RS.getString("IGS_DEVICE"));
			 igskeyop = appTool.nullStringConverter(DeviceSearchList_RS.getString("IGS_KEYOP"));
			 duplex = appTool.nullStringConverter(DeviceSearchList_RS.getString("DUPLEX"));
			 numtray = appTool.nullStringConverter(DeviceSearchList_RS.getString("NUMBER_TRAYS"));
			 bodytray = appTool.nullStringConverter(DeviceSearchList_RS.getString("BODY_TRAY"));
			 headertray = appTool.nullStringConverter(DeviceSearchList_RS.getString("HEADER_TRAY"));
			 serialnum = appTool.nullStringConverter(DeviceSearchList_RS.getString("SERIAL_NUMBER")); 
			 comment = appTool.nullStringConverter(DeviceSearchList_RS.getString("COMMENT"));
			 dipp = appTool.nullStringConverter(DeviceSearchList_RS.getString("DIPP"));
			 koname = appTool.nullStringConverter(DeviceSearchList_RS.getString("KO_NAME"));
			 kophone = appTool.nullStringConverter(DeviceSearchList_RS.getString("KO_PHONE"));
			 koemail = appTool.nullStringConverter(DeviceSearchList_RS.getString("KO_EMAIL"));
			 kocompany = appTool.nullStringConverter(DeviceSearchList_RS.getString("KO_COMPANY"));
			 kopager = appTool.nullStringConverter(DeviceSearchList_RS.getString("KO_PAGER"));
			 faxnumber = appTool.nullStringConverter(DeviceSearchList_RS.getString("FAX_NUMBER"));
			 billdept = appTool.nullStringConverter(DeviceSearchList_RS.getString("BILL_DEPT"));
			 billdiv = appTool.nullStringConverter(DeviceSearchList_RS.getString("BILL_DIV"));
			 billdetail = appTool.nullStringConverter(DeviceSearchList_RS.getString("BILL_DETAIL"));
			 billemail = appTool.nullStringConverter(DeviceSearchList_RS.getString("BILL_EMAIL"));
			 billname = appTool.nullStringConverter(DeviceSearchList_RS.getString("BILL_NAME"));
			 createdby = appTool.nullStringConverter(DeviceSearchList_RS.getString("CREATED_BY"));
			 creationdate = DeviceSearchList_RS.getTimeStamp("CREATION_DATE");
			 creationmethod = appTool.nullStringConverter(DeviceSearchList_RS.getString("CREATION_METHOD"));
			 modifiedby = appTool.nullStringConverter(DeviceSearchList_RS.getString("MODIFIED_BY"));
			 modifieddate = DeviceSearchList_RS.getTimeStamp("MODIFIED_DATE");
			 installdate = appTool.nullStringConverter(DeviceSearchList_RS.getString("INSTALL_DATE"));
			DeviceStatus_RS.first();
			if (DeviceStatus_RS.getResultSetSize() > 0 ) {
				while(DeviceStatus_RS.next()) {
					if (status.equals(DeviceStatus_RS.getString("CATEGORY_CODE"))) {
						status = DeviceStatus_RS.getString("CATEGORY_VALUE1");
					} //if equal
				} //while
			} //if >0 
			
			if (lastDeviceName.equals("")) { %><%= geo %>,<%= country %>,<%= state %>,<%= city %>,<%= building %>,<%= floor %>,<%= room %>,<%= deviceName %>,<%= lpname %>,<%= webvisible %>,<%= installable %>,<%= status %>,<%= ftpsite %>,<%= clientdeftype %>,<%= driversetname %>,<%= model %>,<%= server %>,<%= sdc %>,<%= comm %>,<%= spooler %>,<%= supervisor %>,<%= roomaccess %>,<%= roomphone %>,<%= landrop %>,<%= connecttype %>,<%= e2ecategory %>,<%= cs %>,<%= vm %>,<%= sap %>,<%= wts %>,<%= separatorpage %>,<%= restrict %>,<%= reqnumber %>,<%= igsasset %>,<%= igsdevice %>,<%= igskeyop %>,<%= duplex %>,<%= numtray %>,<%= bodytray %>,<%= headertray %>,<%= serialnum %>,<%= macaddress %>,<%= comment.replace('"','\'') %>,<%= dipp %>,<%= koname %>,<%= koemail %>,<%= kocompany %>,<%= kopager %>,<%= kophone %>,<%= faxnumber %>,<%= billdept %>,<%= billdiv %>,<%= billdetail %>,<%= billemail %>,<%= billname %>,<%= ipdomain %>,<%= ipsubnet %>,<%= ipgateway %>,<%= iphostname %>,<%= ipaddress %>,<%= port %>,<%= poolname %>,<%= ps %>,<%= pcl %>,<%= ascii %>,<%= ipds %>,<%= ppds %>,<%= ipmqueuename %>,<%= psdestname %>,<%= afpdestname %>,<%= createdby %>,<%= creationdate %>,<%= appTool.nullStringConverter(modifiedby) %>,<%= modifieddate %>,<%= installdate %>,<%= deletedate %>,<%= creationmethod %>,<% lastDeviceName = deviceName; %><% } 
if (!deviceName.equals(lastDeviceName) && numDevices != 0) { %>
<% while(devFuncCounter < aFunctions.length) { devFuncCounter++; }  devFuncCounter = 0; %><%= geo %>,<%= country %>,<%= state %>,<%= city %>,<%= building %>,<%= floor %>,<%= room %>,<%= deviceName %>,<%= lpname %>,<%= webvisible %>,<%= installable %>,<%= status %>,<%= ftpsite %>,<%= clientdeftype %>,<%= driversetname %>,<%= model %>,<%= server %>,<%= sdc %>,<%= comm %>,<%= spooler %>,<%= supervisor %>,<%= roomaccess %>,<%= roomphone %>,<%= landrop %>,<%= connecttype %>,<%= e2ecategory %>,<%= cs %>,<%= vm %>,<%= sap %>,<%= wts %>,<%= separatorpage %>,<%= restrict %>,<%= reqnumber %>,<%= igsasset %>,<%= igsdevice %>,<%= igskeyop %>,<%= duplex %>,<%= numtray %>,<%= bodytray %>,<%= headertray %>,<%= serialnum %>,<%= macaddress %>,<%= comment.replace('"','\'') %>,<%= dipp %>,<%= koname %>,<%= koemail %>,<%= kocompany %>,<%= kopager %>,<%= kophone %>,<%= faxnumber %>,<%= billdept %>,<%= billdiv %>,<%= billdetail %>,<%= billemail %>,<%= billname %>,<%= ipdomain %>,<%= ipsubnet %>,<%= ipgateway %>,<%= iphostname %>,<%= ipaddress %>,<%= port %>,<%= poolname %>,<%= ps %>,<%= pcl %>,<%= ascii %>,<%= ipds %>,<%= ppds %>,<%= ipmqueuename %>,<%= psdestname %>,<%= afpdestname %>,<%= createdby %>,<%= creationdate %>,<%= appTool.nullStringConverter(modifiedby) %>,<%= modifieddate %>,<%= installdate %>,<%= deletedate %>,<%= creationmethod %>,<% lastDeviceName = deviceName; %><% while(devFuncCounter < aFunctions.length) { if (aFunctions[devFuncCounter] != null && aFunctions[devFuncCounter].equals(devFunc)) { %><%= devFunc %>,<% devFuncCounter++; break; } else { devFuncCounter++; } } //while loop %> <% } else { while(devFuncCounter < aFunctions.length) { if (aFunctions[devFuncCounter] != null && aFunctions[devFuncCounter].equals(devFunc)) { %><%= devFunc %>, <% devFuncCounter++; break; } else { devFuncCounter++; } } //while loop 
} //if deviceName is not equal
numDevices++;
} //while DeviceSearchList %>