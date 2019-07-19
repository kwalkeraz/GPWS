/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;
import java.io.*;
import java.net.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.naming.*;
import javax.sql.*;
import tools.print.lib.*;


public class SaveData extends HttpServlet
{

	String name="";
	int locid;
	private static int cpApprovalID = 0;

	private static String sql = null;
	//private static StringBuffer sb = new StringBuffer();
	private static PreparedStatement pstmt;
	private static ResultSet rsMain;
	//private static ResultSet rs;
	private static Connection con;
	//private static int index=0;
	
	public int PrinterDefTypeID = 0;
	public String SDC = "";
	public int FTPID = 0;
	public int DriverSetID = 0;

	public String getSDC() {
		return SDC;
	}

	public void setSDC(String sDC) {
		this.SDC = sDC;
	}

	public int getPrinterDefTypeID() {
		return PrinterDefTypeID;
	}

	public void setPrinterDefTypeID(int printerDefTypeID) {
		this.PrinterDefTypeID = printerDefTypeID;
	}

	public int getFTPID() {
		return FTPID;
	}

	public void setFTPID(int fTPID) {
		this.FTPID = fTPID;
	}

	public int getDriverSetID() {
		return DriverSetID;
	}

	public void setDriverSetID(int driverSetID) {
		this.DriverSetID = driverSetID;
	}

	public void setPrtName(int locid,String prtname) {
        this.locid = locid;
        this.name = prtname.trim();
    }    

	public void setCopierName(int locid,String prtname) {
        this.locid = locid;
        this.name = prtname.trim();
    }
	public void setCPApprovalID(int id) {
		cpApprovalID = id;
	}
	public int getCPApprovalID () {
		return cpApprovalID;
	}

public int saveData(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

	int prtInsert;
	AppTools appTool = new AppTools();

	String status = appTool.nullStringConverter(request.getParameter("status"));
	String geo = appTool.nullStringConverter(request.getParameter("geo"));
	String country = appTool.nullStringConverter(request.getParameter("country"));	
	String room = appTool.nullStringConverter(request.getParameter("room"));

	String cs = appTool.nullStringConverter(request.getParameter("cs"));
	String vm = appTool.nullStringConverter(request.getParameter("vm"));
	String mvs = appTool.nullStringConverter(request.getParameter("mvs"));
	String sap = appTool.nullStringConverter(request.getParameter("sap"));
	String wts = appTool.nullStringConverter(request.getParameter("wts"));
	//String ims = appTool.nullStringConverter(request.getParameter("ims"));
	String reqnum = appTool.nullStringConverter(request.getParameter("reqnum"));
	String devicemodel = appTool.nullStringConverter(request.getParameter("devicemodel"));
	//String othermodel = appTool.nullStringConverter(request.getParameter("othermodel"));
	String IGSAssetMgnt = appTool.nullStringConverter(request.getParameter("IGSAssetMgnt"));
	String igsdevice = appTool.nullStringConverter(request.getParameter("igsdevice"));
	String Duplex = appTool.nullStringConverter(request.getParameter("duplex"));
	if (Duplex.equals("None")) Duplex = "";
	String numtrays = appTool.nullStringConverter(request.getParameter("numtrays"));
	String serialnum = appTool.nullStringConverter(request.getParameter("serialnum"));
	String macaddr = appTool.nullStringConverter(request.getParameter("macaddr"));
	String itcomment = appTool.nullStringConverter(request.getParameter("itcomment"));
	String dipp = appTool.nullStringConverter(request.getParameter("dipp"));
	if (dipp.equals("None")) dipp = "";
	//String endtoe = appTool.nullStringConverter(request.getParameter("endtoe"));
	String endtoe = "ECPrint";
	String roomaccess = appTool.nullStringConverter(request.getParameter("roomaccess"));
	String ContactName = appTool.nullStringConverter(request.getParameter("ContactName"));
	String ContactNoteID = appTool.nullStringConverter(request.getParameter("ContactNoteID"));
	String ContactTieLine = appTool.nullStringConverter(request.getParameter("ContactTieLine"));
	String roomphone = appTool.nullStringConverter(request.getParameter("roomphone"));
	String landrop = appTool.nullStringConverter(request.getParameter("landrop"));
	//String connecttype = appTool.nullStringConverter(request.getParameter("connecttype"));
	String connecttype = "10/100 MB Ethernet";
	String Tempdsvr = appTool.nullStringConverter(request.getParameter("Tempdsvr"));
	String Tempdqueue = appTool.nullStringConverter(request.getParameter("Tempdqueue"));
	String Tempdenbltype = appTool.nullStringConverter(request.getParameter("Tempdenbltype"));
	String koname = appTool.nullStringConverter(request.getParameter("koname"));
	String kophone = appTool.nullStringConverter(request.getParameter("kophone"));
	String koemail = appTool.nullStringConverter(request.getParameter("koemail"));
	String kopager = appTool.nullStringConverter(request.getParameter("kopager"));
	String kocompany = appTool.nullStringConverter(request.getParameter("kocompany"));
	String billdept = appTool.nullStringConverter(request.getParameter("billdept"));
	String billdiv = appTool.nullStringConverter(request.getParameter("billdiv"));
	//String groupoption = appTool.nullStringConverter(request.getParameter("groupoption"));
	String billdetail = appTool.nullStringConverter(request.getParameter("billdetail"));
	//String BillToEmpNum = appTool.nullStringConverter(request.getParameter("BillToEmpNum"));
	String billemail = appTool.nullStringConverter(request.getParameter("billemail"));
	String billname = appTool.nullStringConverter(request.getParameter("billname"));
	//String BillToTieLine = appTool.nullStringConverter(request.getParameter("BillToTieLine"));
	String ps = appTool.nullStringConverter(request.getParameter("ps"));
	String ipds = appTool.nullStringConverter(request.getParameter("ipds"));
	String pcl = appTool.nullStringConverter(request.getParameter("pcl"));
	String ascii = appTool.nullStringConverter(request.getParameter("ascii"));
	String ppds = appTool.nullStringConverter(request.getParameter("ppds"));
	//String sdc = appTool.nullStringConverter(request.getParameter("sdc"));
	String othermodel = appTool.nullStringConverter(request.getParameter("othermodel"));
	String[] devFuncs = getDeviceFunctions();
	getPrinterDefType(geo, country);
	getFTP();
	getDriverSet();
	int iReturnCode = -1;
	int iRC1 = 0;
	int iRC2 = 1;
	
	try {
		int modelid = 0;
		if (!devicemodel.equals("")) {
			modelid = Integer.parseInt(devicemodel); 
		}
 		con = appTool.getConnection();
		sql = "INSERT INTO GPWS.DEVICE (LOCID, ROOM, DEVICE_NAME, MODELID, ROOM_ACCESS, CS, VM, MVS, SAP, WTS, STATUS, REQUEST_NUMBER, IGS_ASSET, IGS_DEVICE, DUPLEX, NUMBER_TRAYS, SERIAL_NUMBER, MAC_ADDRESS, COMMENT, DIPP, E2E_CATEGORY, ROOM_PHONE, LAN_DROP, CONNECT_TYPE, KO_NAME, KO_PHONE, KO_EMAIL, KO_PAGER, KO_COMPANY, BILL_DEPT, BILL_DIV, BILL_DETAIL, BILL_EMAIL, BILL_NAME, PS, PCL, ASCII, IPDS, PPDS, SERVER_SDC, CREATED_BY, WEB_VISIBLE, INSTALLABLE, PRINTER_DEF_TYPEID, IGS_KEYOP, KO_COMPANYID, FTPID, DRIVER_SETID) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		pstmt = con.prepareStatement (sql);
		
		pstmt.setInt(1,locid);
		pstmt.setString(2,room);
		pstmt.setString(3,name);
		if (modelid == 0) {
			pstmt.setNull(4,java.sql.Types.INTEGER);
		} else {
			pstmt.setInt(4,modelid);
		}
		pstmt.setString(5,roomaccess);
		pstmt.setString(6,cs);
		pstmt.setString(7,vm);
		pstmt.setString(8,mvs);
		pstmt.setString(9,sap);
		pstmt.setString(10,wts);
		pstmt.setString(11,status);
		pstmt.setString(12,reqnum);
		pstmt.setString(13,IGSAssetMgnt);
		pstmt.setString(14,igsdevice);
		pstmt.setString(15,Duplex);
		pstmt.setString(16,numtrays);
		pstmt.setString(17,serialnum);
		pstmt.setString(18,macaddr);
		pstmt.setString(19,itcomment);
		pstmt.setString(20,dipp);
		pstmt.setString(21,endtoe);
		pstmt.setString(22,roomphone);
		pstmt.setString(23,landrop);
		pstmt.setString(24,connecttype);
		pstmt.setString(25,koname);
		pstmt.setString(26,kophone);
		pstmt.setString(27,koemail);
		pstmt.setString(28,kopager);
		pstmt.setString(29,kocompany);
		pstmt.setString(30,billdept);
		pstmt.setString(31,billdiv);
		pstmt.setString(32,billdetail);
		pstmt.setString(33,billemail);
		pstmt.setString(34,billname);
		pstmt.setString(35,ps);
		pstmt.setString(36,pcl);
		pstmt.setString(37,ascii);
		pstmt.setString(38,ipds);
		pstmt.setString(39,ppds);
		pstmt.setString(40,getSDC());
		pstmt.setString(41,"Workflow request");
		pstmt.setString(42,"N");
		pstmt.setString(43,"N");
		//Added default values of Printer_Def_TypeID, IGS_Keyop, KO_COMPANYID, FTPID, DRIVER_SETID for Print@IBM devices
		if (!othermodel.equals("") && igsdevice.equals("N")) {
			pstmt.setNull(44,java.sql.Types.INTEGER);
		} else {
			pstmt.setInt(44,getPrinterDefTypeID());
		}
		//System.out.println("The Printer Def Type iD is " + getPrinterDefTypeID());
		
		pstmt.setString(45,"Y");
		pstmt.setInt(46,3); //Default to Ricoh value
		pstmt.setInt(47,getFTPID());
		//System.out.println("The Driver Set iD is " + getDriverSetID());
		pstmt.setInt(48,getDriverSetID());
		iRC1 = pstmt.executeUpdate();
		con.commit();
		
	} catch (Exception e) {
		iRC1 = 0;
		try {
			appTool.logError("SaveData.saveData.1", "CommonProcess", e);
		} catch (Exception ex) {
			System.out.println("CommonProcess Error in SaveData.saveData.1 ERROR: " + ex);
		}
		System.out.println("CP error in SaveData.saveData.1 ERROR: " + e);
	}
	
	try {
		if (iRC1 == 1) {
			int iDeviceID = getDeviceID(name);
			if (devFuncs != null) {
				for (int j=0; j < devFuncs.length; j++) {
					String df = "";
					if(!appTool.nullStringConverter(request.getParameter(devFuncs[j] + "type")).equals("")) {
						df = appTool.nullStringConverter(request.getParameter(devFuncs[j] + "type"));
						sql = "INSERT INTO GPWS.DEVICE_FUNCTIONS (DEVICEID, FUNCTION_NAME) VALUES (?,?)";
						pstmt = con.prepareStatement (sql);
						pstmt.setInt(1,iDeviceID);
						pstmt.setString(2,df);
						pstmt.executeUpdate();
					}
				}
			}
		}
		
	} catch(Exception e){
		iRC2 = 0;
		try {
			appTool.logError("SaveData.saveData.1", "CommonProcess", e);
		} catch (Exception ex) {
			System.out.println("CommonProcess Error in SaveData.saveData.2 ERROR: " + ex);
		}
		System.out.println("CP error in SaveData.saveData.2 ERROR: " + e);

	} finally {
		try {
			if (pstmt != null)
				pstmt.close();
			if (con != null)
				con.close();
		} catch (Exception e) {
		}
	}
	
	if (iRC1 == 0) {
		iReturnCode = 2;
	} else if (iRC2 == 0) {
		iReturnCode = 1;
	} else {
		iReturnCode = 0;
	}
	
	return iReturnCode;

}


	public int saveReqData(String reqnum, String prtname) throws ServletException, IOException {

		int prtInsert;
		AppTools appTool = new AppTools();
		int iReturnCode = -1;
		int iRC1 = -1;
		int iRC2 = -1;
		try {
			con = appTool.getConnection();
	
			sql = "UPDATE GPWS.CP_APPROVAL SET DEVICE_NAME = ? WHERE REQ_NUM = ?";
			pstmt = con.prepareStatement (sql);
			pstmt.setString(1,prtname);
			pstmt.setString(2,reqnum);
	
			//System.out.println("CPApproval SQL Statement : " + sql);
			iRC1 = pstmt.executeUpdate();
			con.commit();
	
			System.out.println("Return Value from CPApproval Update : " + iRC1);
			
		} catch (Exception e) {
			iRC1 = 0;
			try {
				appTool.logError("SaveData.saveReqData.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.saveReqData.1 ERROR: " + ex);
			}
			System.out.println("GPWS error in SaveData.saveReqData.1 ERROR: " + e);
		}
		
		try {
			
			if (iRC1 == 1) {
				int id = 0;
				sql = "SELECT CPAPPROVALID FROM GPWS.CP_APPROVAL WHERE DEVICE_NAME = ? AND REQ_NUM = ?";
				pstmt = con.prepareStatement (sql);
				pstmt.setString(1,name);
				pstmt.setString(2,reqnum);
				rsMain = pstmt.executeQuery();
				while (rsMain.next()) {
					id = rsMain.getInt("CPAPPROVALID");
				}
				setCPApprovalID(id);
			}
			
		} catch(Exception e){
			iRC2 = 0;
			try {
				appTool.logError("SaveData.saveReqData.2", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.saveReqData.2 ERROR: " + ex);
			}
			System.out.println("GPWS error in SaveData.saveReqData.2 ERROR: " + e);
	
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				
			}
		}
	
		if (iRC1 == 0) {
			iReturnCode = 2;
		} else if (iRC2 == 0) {
			iReturnCode = 1;
		} else {
			iReturnCode = 0;
		}
		
		return iReturnCode;
	}

	
	public int createRoutingStep(String reqnum, String step, String actiontype, String status, String assignee, String startdate)
			  throws ServletException, IOException {

		int prtInsert;

		AppTools appTool = new AppTools();
		PreparedStatement pstmt2 = null;
		int iReturnCode = -1;
		int iRC = -1;
		String comments = "";
		
		try {

			con = appTool.getConnection();

			sql = "INSERT INTO GPWS.CP_ROUTING (CPAPPROVALID, STEP, ACTION_TYPE, STATUS, ASSIGNEE, START_DATE, COMMENTS) VALUES (?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1,getCPApprovalID());
			pstmt.setString(2,step);
			pstmt.setString(3,actiontype);
			pstmt.setString(4,status);
			pstmt.setString(5,assignee);
			pstmt.setString(6,startdate);
			pstmt.setString(7,comments);

			//System.out.println("CPRouting SQL Statement : " + sql);
			//pstmt = con.prepareStatement (sql);
			iRC = pstmt.executeUpdate();
			con.commit();

			System.out.println("Return Value from CPApproval Update : " + iRC);

		} catch (Exception e) {
			iRC = 0;
			try {
				appTool.logError("SaveData.createRoutingStep.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.createRoutingStep.1 ERROR: " + ex);
			}

			System.out.println("GPWS error in SaveData.createRoutingStep.1 ERROR: " + e);

		}

		if (iRC == 1) {
			iReturnCode = 0;
		} else if (iRC == 0) {
			iReturnCode = 1;
		}
		
		return iReturnCode;
	}
	
	
	public int updateRoutingStep(HttpServletRequest req, int cproutingid, String status, String startdate)
	  throws ServletException, IOException {

		AppTools tool = new AppTools();
		//Connection con = null;
		PreparedStatement psCPRouting = null;
		int sMessage = 0;
		
		try {
			con = tool.getConnection();
			String insertQuery = "UPDATE GPWS.CP_ROUTING SET STATUS = ?, START_DATE = ? WHERE CPROUTINGID = ?";
			psCPRouting = con.prepareStatement(insertQuery);
			psCPRouting.setString(1,status);
			psCPRouting.setString(2,startdate);
			psCPRouting.setInt(3,cproutingid);
			psCPRouting.executeUpdate();
			con.commit();
			sMessage = 0;
		
		} catch (SQLException e) {
			System.out.println("CommonProcess error in SaveData.class method updateRoutingStep ERROR: " + e);
			sMessage = 1;
			String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
			try {
					tool.logError("SaveData.updateRoutingStep.1", "CommonProcess", e);
				} catch (Exception ex) {
					System.out.println("CommonProcess Error in SaveData.updateRoutingStep.1 ERROR: " + ex);
				}
		} finally {
			try {
				if (psCPRouting != null)
					psCPRouting.close();
			} catch (Exception e){
				System.out.println("CommonProcess Error in SaveData.updateRoutingStep.2 ERROR: " + e);
			}
		}
		return sMessage;
	} //method updateRoutingSTep
	
	public int getDeviceID(String name) throws ServletException, IOException {

		AppTools tool = new AppTools();
		//Connection con = null;
		PreparedStatement psDevice = null;
		ResultSet rsDevice = null;
		int iDeviceID = 0;
		
		try {
			con = tool.getConnection();
			String sql = "SELECT DEVICEID FROM GPWS.DEVICE WHERE DEVICE_NAME = ?";
			psDevice = con.prepareStatement(sql);
			psDevice.setString(1,name);
			rsDevice = psDevice.executeQuery();
			
			while (rsDevice.next()) {
				iDeviceID = rsDevice.getInt("DEVICEID");
			}
		
		} catch (SQLException e) {
			System.out.println("CommonProcess error in SaveData.getDeviceID ERROR: " + e);
			try {
				tool.logError("SaveData.getDeviceID.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.getDeviceID.1 ERROR: " + ex);
			}
		} finally {
			try {
				if (rsDevice != null)
					rsDevice.close();
				if (psDevice != null)
					psDevice.close();
			} catch (Exception e){
				System.out.println("CommonProcess Error in SaveData.getDeviceID.2 ERROR: " + e);
			}
		}
		return iDeviceID;
	} //getDeviceID
	
	private void getPrinterDefType(String geo, String country) throws ServletException, IOException {

		AppTools tool = new AppTools();
		PreparedStatement psDevice = null;
		ResultSet rsDevice = null;
		
		String[] countryArray = {"United States", "Australia", "China", "Japan", "India"};
		boolean countryB = false;
		
		for(String ca : countryArray) {
			if (ca.equals(country)) countryB = true;
		}
		
		try {
			con = tool.getConnection();
			String sql = "";
			if (countryB) {
				sql = "SELECT B.PRINTER_DEF_TYPEID, SDC FROM GPWS.SERVER_VIEW A, GPWS.PRINTER_DEF_TYPE_CONFIG_VIEW B WHERE B.PROTOCOL_NAME = A.SDC AND A.GEO = ? " +
						"AND A.COUNTRY = ?";
				psDevice = con.prepareStatement(sql);
				psDevice.setString(1,geo);
				psDevice.setString(2,country);
			} else {
				sql = "SELECT B.PRINTER_DEF_TYPEID, SDC FROM GPWS.SERVER_VIEW A, GPWS.PRINTER_DEF_TYPE_CONFIG_VIEW B WHERE B.PROTOCOL_NAME = A.SDC AND A.GEO = ?";
				psDevice = con.prepareStatement(sql);
				psDevice.setString(1,geo);
			}
			rsDevice = psDevice.executeQuery();
			
			while (rsDevice.next()) {
				//printerDefTypeId = rsDevice.getInt("PRINTER_DEF_TYPEID");
				setPrinterDefTypeID(rsDevice.getInt("PRINTER_DEF_TYPEID"));
				setSDC(rsDevice.getString("SDC"));
			}
		
		} catch (SQLException e) {
			System.out.println("CommonProcess error in SaveData.getPrinterDefType ERROR: " + e);
			try {
				tool.logError("SaveData.getPrinterDefType.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.getPrinterDefType.1 ERROR: " + ex);
			}
		} finally {
			try {
				if (rsDevice != null)
					rsDevice.close();
				if (psDevice != null)
					psDevice.close();
			} catch (Exception e){
				System.out.println("CommonProcess Error in SaveData.getPrinterDefType.2 ERROR: " + e);
			}
		}
	} //getDeviceID
	
	private void getFTP() throws ServletException, IOException {

		AppTools tool = new AppTools();
		PreparedStatement psDevice = null;
		ResultSet rsDevice = null;
		
		try {
			con = tool.getConnection();
			String sql = "";
			sql = "SELECT FTPID FROM GPWS.FTP WHERE FTP_SITE = ?";
				psDevice = con.prepareStatement(sql);
				psDevice.setString(1,"http://bldgsa.ibm.com;http://tucgsa.ibm.com");

			rsDevice = psDevice.executeQuery();
			
			while (rsDevice.next()) {
				setFTPID(rsDevice.getInt("FTPID"));
			}
		
		} catch (SQLException e) {
			System.out.println("CommonProcess error in SaveData.getFTP ERROR: " + e);
			try {
				tool.logError("SaveData.getFTP.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.getFTP.1 ERROR: " + ex);
			}
		} finally {
			try {
				if (rsDevice != null)
					rsDevice.close();
				if (psDevice != null)
					psDevice.close();
			} catch (Exception e){
				System.out.println("CommonProcess Error in SaveData.getFTP.2 ERROR: " + e);
			}
		}
	} //getFTP
	
	private void getDriverSet() throws ServletException, IOException {

		AppTools tool = new AppTools();
		PreparedStatement psDevice = null;
		ResultSet rsDevice = null;
		
		try {
			con = tool.getConnection();
			String sql = "";
			sql = "SELECT DRIVER_SETID FROM GPWS.DRIVER_SET WHERE DRIVER_SET_NAME = ?";
				psDevice = con.prepareStatement(sql);
				psDevice.setString(1,"RICOH ECPrint Dummy");

			rsDevice = psDevice.executeQuery();
			
			while (rsDevice.next()) {
				setDriverSetID(rsDevice.getInt("DRIVER_SETID"));
			}
		
		} catch (SQLException e) {
			System.out.println("CommonProcess error in SaveData.getDriverSet ERROR: " + e);
			try {
				tool.logError("SaveData.getDriverSet.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.getDriverSet.1 ERROR: " + ex);
			}
		} finally {
			try {
				if (rsDevice != null)
					rsDevice.close();
				if (psDevice != null)
					psDevice.close();
			} catch (Exception e){
				System.out.println("CommonProcess Error in SaveData.getDriverSet.2 ERROR: " + e);
			}
		}
	} //getDriverSet
	
	public String[] getDeviceFunctions() throws ServletException, IOException {

		AppTools tool = new AppTools();
		//Connection con = null;
		PreparedStatement psDeviceFunctions = null;
		ResultSet rsDeviceFunctions = null;
		String [] devFunctions = new String[10] ;
		int x = 0; //counter
		
		try {
			con = tool.getConnection();
			String sql = "SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'DeviceFunction' ORDER BY CATEGORY_VALUE1";
			psDeviceFunctions = con.prepareStatement(sql);
			rsDeviceFunctions = psDeviceFunctions.executeQuery();
			
			while (rsDeviceFunctions.next()) {
				devFunctions[x] = rsDeviceFunctions.getString("CATEGORY_VALUE1");
				x++;
			}
		
		} catch (SQLException e) {
			System.out.println("CommonProcess error in SaveData.getDeviceFunctions ERROR: " + e);
			try {
				tool.logError("SaveData.getDeviceFunctions.1", "CommonProcess", e);
			} catch (Exception ex) {
				System.out.println("CommonProcess Error in SaveData.getDeviceFunctions.1 ERROR: " + ex);
			}
		} finally {
			try {
				if (rsDeviceFunctions != null)
					rsDeviceFunctions.close();
				if (psDeviceFunctions != null)
					psDeviceFunctions.close();
			} catch (Exception e){
				System.out.println("CommonProcess Error in SaveData.getDeviceFunctions.2 ERROR: " + e);
			}
		}
		return devFunctions;
	} //method updateRoutingSTep

}