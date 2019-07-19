/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import com.ibm.aurora.*;
import java.sql.*;
import java.util.*;
import javax.servlet.http.*;
import tools.print.lib.AppTools;

 /**
   * This behavior will take in search name and gets all Locations matching the search fields.
   *
   * @author IBM VHD Team June 2002
   */
public class PrinterInstallData implements Behavior {

   private String bName = null;
   public ArrayList arrList = new ArrayList(10);
   public PrinterInstallBean pib = new PrinterInstallBean();
   protected int arrCount = 0;

    /**
      * The constructor will initialize the specifics of the Behavior.
      * It will be called ONCE from the constructor of the BehaviorInfo, in order to configure the
      * databaseTable instance variable.  After that, the other constructor will be called to simply
      * get a pointer to this data.
      *
      * @param resourceBundle a reference to the resource bundle for this specific behavior.
      * The bundle should contain a database table name and information about matching the columns
      * to the html fields.
      * @param specificBehavior a string that defines the specific behavior name that can be used
      *  for errors
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public PrinterInstallData( PropertyResourceBundle resourceBundle, String specificBehavior ) throws BehaviorException {
      setBehaviorName( specificBehavior );
   }

    /**
      * Constructor used for 'per call' instances.  This saves time by using a reference to the same
      * databaseTable definition that we already configured in previous instances of this same behavior.
      * This constructor will be used in the getInstance() method of the BehaviorInfo class when
      * the behavior is configured as 'per call'.
      * @exception BehaviorException if the parameters are invalid or ill defined
      */
   public PrinterInstallData( Behavior b ) throws BehaviorException {
		try {
			PrinterInstallData pid = (PrinterInstallData) b;
			this.bName = pid.bName;
		}
		catch( ClassCastException cce ) {
			throw new BehaviorException("Invalid cast to a PrinterInstallData object",BhvrErrors.INVALID_CAST,cce);
		}
   }

    /**
      * Get search value
	  * Perform search
	  * Add the result arraylist to request object
      */
   public void execute( HttpServletRequest req, HttpServletResponse res, Connection con )
      throws BehaviorException, SQLException {
	  boolean doGetPrinterData = true;
	  //int locid = Integer.parseInt(req.getParameter(PrinterConstants.PRT_LOCID).trim());
	  //if( locid <= 0 ) doGetPrinterData = false;
	 // String room = (req.getParameter(PrinterConstants.PRT_ROOM));
	 // if( room == null || room.equals("") || room.equals("null") ) doGetPrinterData = false;
	  String name = (req.getParameter(PrinterConstants.PRT_NAME));
	  if( name == null || name.equals("") || name.equals("null") ) doGetPrinterData = false;
	  if (doGetPrinterData) {
	  	getPrinterData(name, con);
	  }
	  else {
		  System.out.println ("PrinterInstallData: at least one value is bad");
	  }
	  System.out.println("PrinterInstallData: searchList compeleted.");
	  
	  
   }

    /**
      * Queries the ip range table to get all locations
      * @return the location id of remote host
      */
   
	protected final String strStrip( String str ) {
		if( str == null || str.equals("") || str.equals("null") ) return "";
		else return str;
	}
	/**
      * Performs Search on city, state and printer names
      */  
   
   protected final void getPrinterData( String name, Connection con ) throws BehaviorException, SQLException {

   	  System.out.println("PrinterInstallData: Inside getPrinterData Method");
   	  AppTools appTool = new AppTools();
   	  PreparedStatement stmtOS = null;
	  ResultSet rsOS = null;
	  String sqlOS = "SELECT OSID, OS_NAME, OS_ABBR, COMMENT FROM GPWS.OS ORDER BY OSID";
	  String[] osArray = new String[10];
	  
	  try {
	  	stmtOS = con.prepareStatement(sqlOS);
	    rsOS = stmtOS.executeQuery();
	  	System.out.println("Prepared Statement Executed : " + sqlOS);
	  	int z = 0;
	  	while (rsOS.next()) {
	  		osArray[z] = appTool.nullStringConverter(rsOS.getString("OS_ABBR"));
	  		z++;
	  	}
	  	pib.setOSArray(osArray);
	  	pib.setOSNumber(z);
	  	
	  } catch (Exception e) {
	  		System.out.println("Error in PrinterInstallData.getPrinterData.1 ERROR: " + e);
	  } finally {
	  		if (rsOS != null)
	  			rsOS.close();
	  		if (stmtOS != null)
	  			stmtOS.close();
	  }
  
	  PreparedStatement stmtDevice = null;
	  ResultSet rsDevice = null;
	  
	  try {
	  	stmtDevice = con.prepareStatement("SELECT A.LOCID, A.GEO, A.COUNTRY, A.STATE, A.CITY, A.BUILDING_NAME, A.FLOOR_NAME, A.ROOM, A.DEVICE_NAME, A.MODEL, A.RESTRICT, A.SEPARATOR_PAGE, A.COMMENT, A.STATUS, A.LPNAME, A.PORT, A.COMM_PORT, A.SPOOLER, A.PRINTER_DEF_TYPEID, A.CLIENT_DEF_TYPE, A.DRIVER_SETID, A.DRIVER_SET_NAME, A.IP_HOSTNAME, A.IP_DOMAIN, A.IP_ADDRESS, A.SERVER_NAME, A.FTP_SITE, B.FTP_PASS, B.FTP_USER, B.HOME_DIRECTORY, C.CLSID, C.CLSID_64BIT, C.PLUGIN_URL, C.PLUGINS_PAGE, C.ERROR_URL, C.SUCCESS_URL, C.PLUGIN_VERSION, C.WIDGET_VERSION, C.ILS, C.CLIENT_USER_ID, C.CLIENT_PASSWORD, C.CLIENT_DUMP_DIR FROM GPWS.APP_SETTINGS C, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE A.DEVICE_NAME = ?");
	  	stmtDevice.setString(1,name);
	    rsDevice = stmtDevice.executeQuery();
	  	int count = 0;
	  	while (rsDevice.next() && count < 1) {
	  		pib.setLocid(rsDevice.getInt("LOCID"));
	  		pib.setGeo(appTool.nullStringConverter(rsDevice.getString("GEO")));
	  		pib.setCountry(appTool.nullStringConverter(rsDevice.getString("COUNTRY")));
	  		pib.setState(appTool.nullStringConverter(rsDevice.getString("STATE")));
	  		pib.setCity(appTool.nullStringConverter(rsDevice.getString("CITY")));
	  		pib.setBuilding(appTool.nullStringConverter(rsDevice.getString("BUILDING_NAME")));
	  		pib.setFloor(appTool.nullStringConverter(rsDevice.getString("FLOOR_NAME")));
	  		pib.setRoom(appTool.nullStringConverter(rsDevice.getString("ROOM")));
	  		
	  		pib.setCLSID(appTool.nullStringConverter(rsDevice.getString("CLSID")));
	  		pib.setCLSID64BIT(appTool.nullStringConverter(rsDevice.getString("CLSID_64BIT")));
	  		pib.setPluginURL(appTool.nullStringConverter(rsDevice.getString("PLUGIN_URL")));
	  		pib.setPluginsPage(appTool.nullStringConverter(rsDevice.getString("PLUGINS_PAGE")));
	  		pib.setErrorURL(appTool.nullStringConverter(rsDevice.getString("ERROR_URL")));
	  		pib.setSuccessURL(appTool.nullStringConverter(rsDevice.getString("SUCCESS_URL")));
	  		pib.setPluginVer(appTool.nullStringConverter(rsDevice.getString("PLUGIN_VERSION")));
	  		pib.setWidgetVer(appTool.nullStringConverter(rsDevice.getString("WIDGET_VERSION")));
	  		pib.setILS(appTool.nullStringConverter(rsDevice.getString("ILS")));
	  		pib.setClientUserid(appTool.nullStringConverter(rsDevice.getString("CLIENT_USER_ID")));
	  		pib.setClientPassword(appTool.nullStringConverter(rsDevice.getString("CLIENT_PASSWORD")));
	  		pib.setClientDumpDir(appTool.nullStringConverter(rsDevice.getString("CLIENT_DUMP_DIR")));
	  		
	  		pib.setFtpSite(appTool.nullStringConverter(rsDevice.getString("FTP_SITE")));
	  		pib.setFtpPass(appTool.nullStringConverter(rsDevice.getString("FTP_PASS")));
	  		pib.setFtpUser(appTool.nullStringConverter(rsDevice.getString("FTP_USER")));
	  		pib.setFtpHomeDir(appTool.nullStringConverter(rsDevice.getString("HOME_DIRECTORY")));
	  		
	  		pib.setPrtName(appTool.nullStringConverter(rsDevice.getString("DEVICE_NAME")));
	  		pib.setPrtModel(appTool.nullStringConverter(rsDevice.getString("MODEL")));
	  		//pib.setPrtComment(appTool.nullStringConverter(rsDevice.getString("COMMENT")));
	  		pib.setPrtComment("");
	  		pib.setPrtLocation(appTool.nullStringConverter(rsDevice.getString("BUILDING_NAME")));
	  		pib.setPrtSepFile(appTool.nullStringConverter(rsDevice.getString("SEPARATOR_PAGE")));
	  		pib.setRestrict(appTool.nullStringConverter(rsDevice.getString("RESTRICT")));
	  		pib.setPort(appTool.nullStringConverter(rsDevice.getString("PORT")));
	  		pib.setStatus(appTool.nullStringConverter(rsDevice.getString("STATUS")));
	  		pib.setLPName(appTool.nullStringConverter(rsDevice.getString("LPNAME")));
	  		
	  		pib.setIPHostname(appTool.nullStringConverter(rsDevice.getString("IP_HOSTNAME")));
	  		pib.setIPDomain(appTool.nullStringConverter(rsDevice.getString("IP_DOMAIN")));
	  		pib.setIPAddress(appTool.nullStringConverter(rsDevice.getString("IP_ADDRESS")));
	  		pib.setServerName(appTool.nullStringConverter(rsDevice.getString("SERVER_NAME")));
	  		
	  		pib.setPrinterDefTypeID(rsDevice.getInt("PRINTER_DEF_TYPEID"));
	  		pib.setClientDefType(appTool.nullStringConverter(rsDevice.getString("CLIENT_DEF_TYPE")));
	  		pib.setDriverSetID(rsDevice.getInt("DRIVER_SETID"));
	  		pib.setDriverSetName(appTool.nullStringConverter(rsDevice.getString("DRIVER_SET_NAME")));
	  		pib.setCommPort(appTool.nullStringConverter(rsDevice.getString("COMM_PORT")));
	  		pib.setSpoolerName(appTool.nullStringConverter(rsDevice.getString("SPOOLER")));
	  	
	  		count+=1;
	  	}
	  } catch (Exception e) {
	  		System.out.println("Error in PrinterInstallData.getPrinterData.2 ERROR: " + e);
	  } finally {
	  		if (rsDevice != null)
	  			rsDevice.close();
	  		if (stmtDevice != null)
	  			stmtDevice.close();
	  }
	  
	  PreparedStatement stmtDriver = null;
	  ResultSet rsDriver = null;
	  
	  try {
	  	//stmtDriver = con.prepareStatement("SELECT A.OS_ABBR, A.DRIVER_NAME, A.CHANGE_INI, A.MONITOR_FILE, A.CONFIG_FILE, A.VERSION, A.PROC, A.PROC_FILE, A.DRIVER_PATH, A.PRT_ATTRIBUTES, A.HELP_FILE, A.FILE_LIST, A.DATA_FILE, A.MONITOR, A.DEFAULT_TYPE, A.PACKAGE, A.CHANGE_INI, B.NAME AS OPTIONS_FILE_NAME FROM GPWS.DRIVER_VIEW A LEFT OUTER JOIN GPWS.OPTIONS_FILE B ON (A.OS_DRIVERID = B.OS_DRIVERID) WHERE A.OS_DRIVERID IN (SELECT OS_DRIVERID FROM GPWS.DRIVER_SET_CONFIG WHERE DRIVER_SETID = ?) ORDER BY OSID");
	  	stmtDriver = con.prepareStatement("SELECT A.OS_ABBR, A.DRIVER_NAME, A.CHANGE_INI, A.MONITOR_FILE, A.CONFIG_FILE, A.VERSION, A.PROC, A.PROC_FILE, A.DRIVER_PATH, A.PRT_ATTRIBUTES, A.HELP_FILE, A.FILE_LIST, A.DATA_FILE, A.MONITOR, A.DEFAULT_TYPE, A.PACKAGE, A.CHANGE_INI, B.OPTIONS_FILE_NAME FROM GPWS.DRIVER_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON (A.OS_DRIVERID = B.OS_DRIVERID) WHERE B.DRIVER_SETID = ? ORDER BY A.OSID");
	  	stmtDriver.setInt(1,pib.getDriverSetID());
	    rsDriver = stmtDriver.executeQuery();
	  	int x = 0;
	  	while (rsDriver.next()) {
	  		while (!osArray[x].equals(rsDriver.getString("OS_ABBR")) && x <= pib.getOSNumber()) {
	  			pib.driverPackage[x] = "";
	  			pib.driverVersion[x] = "";
	  			pib.driverName[x] = "";
	  			pib.dataFile[x] = "";
	  			pib.driverPath[x] = "";
	  			pib.configFile[x] = "";
	  			pib.helpFile[x] = "";
	  			pib.monitor[x] = "";
	  			pib.fileList[x] = "";
	  			pib.defaultType[x] = "";
	  			pib.proc[x] = "";
	  			pib.procFile[x] = "";
	  			pib.prtAttributes[x] = "";
	  			pib.changeINI[x] = "";
	  			pib.optionsFile[x] = "";
	  			x++;
	  		}
	  		pib.driverPackage[x] = appTool.nullStringConverter(rsDriver.getString("PACKAGE"));
	  		pib.driverVersion[x] = appTool.nullStringConverter(rsDriver.getString("VERSION"));
  			pib.driverName[x] = appTool.nullStringConverter(rsDriver.getString("DRIVER_NAME"));
  			pib.dataFile[x] = appTool.nullStringConverter(rsDriver.getString("DATA_FILE"));
  			pib.driverPath[x] = appTool.nullStringConverter(rsDriver.getString("DRIVER_PATH"));
  			pib.configFile[x] = appTool.nullStringConverter(rsDriver.getString("CONFIG_FILE"));
  			pib.helpFile[x] = appTool.nullStringConverter(rsDriver.getString("HELP_FILE"));
  			pib.monitor[x] = appTool.nullStringConverter(rsDriver.getString("MONITOR"));
  			pib.monitorFile[x] = appTool.nullStringConverter(rsDriver.getString("MONITOR_FILE"));
  			pib.fileList[x] = appTool.nullStringConverter(rsDriver.getString("FILE_LIST"));
  			pib.defaultType[x] = appTool.nullStringConverter(rsDriver.getString("DEFAULT_TYPE"));
  			pib.proc[x] = appTool.nullStringConverter(rsDriver.getString("PROC"));
  			pib.procFile[x] = appTool.nullStringConverter(rsDriver.getString("PROC_FILE"));
  			pib.prtAttributes[x] = appTool.nullStringConverter(rsDriver.getString("PRT_ATTRIBUTES"));
  			pib.changeINI[x] = appTool.nullStringConverter(rsDriver.getString("CHANGE_INI"));
  			pib.optionsFile[x] = appTool.nullStringConverter(rsDriver.getString("OPTIONS_FILE_NAME"));
  			x++;
	  	}
	  	
	  } catch (Exception e) {
	  		System.out.println("Error in PrinterInstallData.getPrinterData.3 ERROR: " + e);
	  } finally {
	  		if (rsDriver != null)
	  			rsDriver.close();
	  		if (stmtDriver != null)
	  			stmtDriver.close();
	  }
	  
	  PreparedStatement stmtProtocol = null;
	  ResultSet rsProtocol = null;
	  
	  try {
	  	stmtProtocol = con.prepareStatement("SELECT A.OS_ABBR, A.PROTOCOL_NAME, A.PROTOCOL_TYPE, A.PROTOCOL_VERSION, A.PROTOCOL_PACKAGE, A.HOST_PORT_CONFIG FROM GPWS.PROTOCOL_VIEW A WHERE OS_PROTOCOLID IN (SELECT OS_PROTOCOLID FROM GPWS.PRINTER_DEF_TYPE_CONFIG WHERE PRINTER_DEF_TYPEID = ?) ORDER BY OSID");
	  	stmtProtocol.setInt(1,pib.getPrinterDefTypeID());
	  	rsProtocol = stmtProtocol.executeQuery();
	  	int x = 0;
	  	while (rsProtocol.next()) {
	  		while (!osArray[x].equals(rsProtocol.getString("OS_ABBR")) && x <= pib.getOSNumber()) {
	  			pib.protocolType[x] = "";
	  			pib.protocolVersion[x] = "";
	  			pib.protocolPackage[x] = "";
	  			pib.hostPortConfig[x] = "";
	  			x++;
	  		}
	  		pib.protocolType[x] = appTool.nullStringConverter(rsProtocol.getString("PROTOCOL_TYPE"));
	  		pib.protocolVersion[x] = appTool.nullStringConverter(rsProtocol.getString("PROTOCOL_VERSION"));
	  		pib.protocolPackage[x] = appTool.nullStringConverter(rsProtocol.getString("PROTOCOL_PACKAGE"));
	  		pib.hostPortConfig[x] = appTool.nullStringConverter(rsProtocol.getString("HOST_PORT_CONFIG"));
	  		x++;
	  	}
	  	
	  } catch (Exception e) {
	  		System.out.println("Error in PrinterInstallData.getPrinterData.4 ERROR: " + e);
	  } finally {
	  		if (rsProtocol != null)
	  			rsProtocol.close();
	  		if (stmtProtocol != null)
	  			stmtProtocol.close();
	  }
	  
	  try {
		  for (int x = 0; x < pib.osArray.length; x++) {
		  	if (pib.hostPortConfig[x] != null && pib.hostPortConfig[x].equals("Hostname/Port")) {
		  		pib.port[x] = pib.getPort();
		  		pib.spooler[x] = "";
		  		if (pib.getIPAddress() != null && appTool.isValidIPAddress(pib.getIPAddress()) ) {
		  			pib.host[x] = pib.getIPAddress();
		  		} else {
		  			pib.host[x] = pib.getIPHostname() + "." + pib.getIPDomain();
		  		}
		  	} else if (pib.hostPortConfig[x] != null && pib.hostPortConfig[x].equals("IP Address/Port")){
		  		pib.port[x] = pib.getPort();
		  		pib.host[x] = pib.getIPAddress();
		  		pib.spooler[x] = "";
		  	} else if (pib.hostPortConfig[x] != null && pib.hostPortConfig[x].equals("Server/Port")) {
		  		pib.port[x] = pib.getPort();
		  		pib.host[x] = pib.getServerName();
		  		pib.spooler[x] = "";
		  	} else if (pib.hostPortConfig[x] != null && pib.hostPortConfig[x].equals("Server/Server Process")) {
		  		pib.host[x] = pib.getServerName();
		  		pib.port[x] = pib.getCommPort();
		  		pib.spooler[x] = pib.getSpoolerName();
		  	} else if (pib.hostPortConfig[x] != null && pib.hostPortConfig[x].equals("Server Only")) {
		  		pib.host[x] = pib.getServerName();
		  		pib.port[x] = pib.getPort();
		  		pib.spooler[x] = "";
		  	} else {
		  		pib.port[x] = pib.getPort();
		  		pib.host[x] = pib.getIPHostname() + "." + pib.getIPDomain();
		  		pib.spooler[x] = "";
		  	}
		  } 
	  } catch (Exception e) {
	  		System.out.println("Error in PrinterInstallData.getPrinterData.5 ERROR: " + e);
	  }
   }
   
   private final void setBehaviorName( String s ) { this.bName = s; }
   public final String getBehaviorName() { return bName; }

}