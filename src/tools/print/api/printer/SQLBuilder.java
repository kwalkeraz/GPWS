package tools.print.api.printer;

/**
 * Constructs an SQL query string based on the parameters passed.  Should only be used in conjuction with the Printers REST servlet
 * @params
 *  devicenameValue - The name of the printer
 *  osValue - The operating system for the drivers
    geoValue - The geography location
	countryValue - Country location
	cityValue - City location
	buildingValue - Building location
	floorValue - Floor location
	ipValue - The IP address of the printer
	
 * @author Gerardo Nunez
 *
 */
public class SQLBuilder {
	//set the printer status
	private static String setStatus(String status) {
		String sqlString = "";
		if(!status.equals("")) {
			sqlString = "AND UPPER(STATUS) = '" + status.toUpperCase() + "'";
		}
		return sqlString;
	} //setStatus
	
	//Search by device name
	public static String byDeviceName(String devicenameValue, String osValue, String status) {
		String functionname = "PRINT";
		String sSQL = "";
		
	//	sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
	//			"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
	//			"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID " +
	//			"AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D " +
	//			"ON (B.OS_DRIVERID = D.OS_DRIVERID) WHERE E.DEVICEID = A.DEVICEID AND UPPER(A.DEVICE_NAME) LIKE '%" + devicenameValue.toUpperCase() + "%' AND " +
	//			"UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "'";
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID " +
				"AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D " +
				"ON (B.OS_DRIVERID = D.OS_DRIVERID) WHERE E.DEVICEID = A.DEVICEID AND UPPER(A.DEVICE_NAME) LIKE '%" + devicenameValue.toUpperCase() + "%' AND " +
				"UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "' AND UPPER(A.STATUS) = '" +status.toUpperCase() +"'";
		
		return sSQL;
	}
	
	//Search by device name
	public static String byDeviceNameOS(String devicenameValue, String osValue) {
		String functionname = "PRINT";
		String sSQL = "";
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID " +
				"AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D " +
				"ON (B.OS_DRIVERID = D.OS_DRIVERID) WHERE E.DEVICEID = A.DEVICEID AND UPPER(A.DEVICE_NAME) LIKE '%" + devicenameValue.toUpperCase() + "%' AND " +
				"UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "'";
		
	
		return sSQL;
	}
	
	//Search by IP Address
	public static String byIPAddress(String ipValue, String osValue) {
		String functionname = "PRINT";
		String sSQL = "";
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' " +
				"LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D ON (B.OS_DRIVERID = D.OS_DRIVERID) " +
				"WHERE E.DEVICEID = A.DEVICEID AND A.IP_ADDRESS LIKE '%" + ipValue + "%' AND UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "'";
		
		return sSQL;
	}
	
	//Search by Server name
	public static String byServerName(String serverName, String osValue) {
		String functionname = "PRINT";
		String sSQL = "";
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' " +
				"LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D ON (B.OS_DRIVERID = D.OS_DRIVERID) " +
				"WHERE E.DEVICEID = A.DEVICEID AND A.SERVER_NAME LIKE '%" + serverName + "%' AND UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "'";
		
		return sSQL;
	}
	
	//Search by City name
	public static String byCity(String osValue, String cityValue, String countryValue, String geoValue, String status) {
		String functionname = "PRINT";
		String sSQL = "";
		String sSQL2 = setStatus(status);
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' " +
				"LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D ON (B.OS_DRIVERID = D.OS_DRIVERID) " +
				"WHERE E.DEVICEID = A.DEVICEID AND UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "' AND UPPER(A.CITY) = '" + cityValue.toUpperCase() + "' " +
				"AND UPPER(A.COUNTRY) = '" + countryValue.toUpperCase() + "' AND UPPER(A.GEO) = '" + geoValue.toUpperCase() + "'" + sSQL2;
		
		return sSQL;
	}
	
	//Search by Building name
	public static String byBuilding(String osValue, String buildingValue, String cityValue, String countryValue, String geoValue, String status) {
		String functionname = "PRINT";
		String sSQL = "";
		String sSQL2 = setStatus(status);
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID " +
				"AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D " +
				"ON (B.OS_DRIVERID = D.OS_DRIVERID) WHERE E.DEVICEID = A.DEVICEID AND UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "' AND (UPPER(A.BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' " +
				"OR UPPER(A.BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' OR UPPER(A.BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') " +
				"AND UPPER(A.CITY) = '" + cityValue.toUpperCase() + "' AND UPPER(A.COUNTRY) = '" + countryValue.toUpperCase() + "' AND UPPER(A.GEO) = '" + geoValue.toUpperCase() + "'" +
				 sSQL2;
		
		return sSQL;
	}
	
	//Search by Floor name
	public static String byFloor(String osValue, String floorValue, String buildingValue, String cityValue, String countryValue, String geoValue, String status) {
		String functionname = "PRINT";
		String sSQL = "";
		String sSQL2 = setStatus(status);
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID " +
				"AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D " +
				"ON (B.OS_DRIVERID = D.OS_DRIVERID) WHERE E.DEVICEID = A.DEVICEID AND UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "' AND UPPER(A.FLOOR_NAME) = '" + floorValue.toUpperCase() + "' " +
				"AND (UPPER(A.BUILDING_NAME) = '" + buildingValue.toUpperCase() + "' OR UPPER(A.BUILDING_NAME) = '00" + buildingValue.toUpperCase() + "' " +
				"OR UPPER(A.BUILDING_NAME) = '0" + buildingValue.toUpperCase() + "') AND UPPER(A.CITY) = '" + cityValue.toUpperCase() + "' AND " +
				"UPPER(A.COUNTRY) = '" + countryValue.toUpperCase() + "' AND UPPER(A.GEO) = '" + geoValue.toUpperCase() + "'" + sSQL2;
		
		return sSQL;
	}
	
	//Search by device ID
	public static String byID(int deviceid, String osValue) {
		String functionname = "PRINT";
		String sSQL = "";
		
		sSQL = "SELECT A.*, C.FTP_PASS, C.FTP_USER, C.HOME_DIRECTORY, D.OS_ABBR, D.DRIVER_NAME, D.CHANGE_INI, D.MONITOR_FILE, D.CONFIG_FILE, D.VERSION, D.PROC, " +
				"D.PROC_FILE, D.DRIVER_PATH,D.PRT_ATTRIBUTES, D.HELP_FILE,  D.FILE_LIST, D.DATA_FILE, D.MONITOR, D.DEFAULT_TYPE, D.PACKAGE, D.CHANGE_INI, " +
				"B.OPTIONS_FILE_NAME FROM GPWS.DEVICE_FUNCTIONS E, GPWS.DEVICE_VIEW A LEFT OUTER JOIN GPWS.DRIVER_SET_CONFIG_VIEW B ON A.DRIVER_SETID = B.DRIVER_SETID AND UPPER(B.OS_ABBR) = '" + osValue.toUpperCase() + "' " +
				"LEFT OUTER JOIN GPWS.FTP C ON (A.FTP_SITE = C.FTP_SITE) LEFT OUTER JOIN GPWS.DRIVER_VIEW D ON (B.OS_DRIVERID = D.OS_DRIVERID) " +
				"WHERE E.DEVICEID = A.DEVICEID AND D.DRIVER_SETID = A.DRIVER_SETID AND A.DEVICEID =" + deviceid + " AND " +
				"UPPER(E.FUNCTION_NAME) = '" + functionname.toUpperCase() + "' AND UPPER(C.OS_ABBR) = '"  + osValue.toUpperCase() + "'";
		
		return sSQL;
	}
	
} // SQLBuilder
