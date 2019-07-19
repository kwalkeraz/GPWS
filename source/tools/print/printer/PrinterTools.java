/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.net.*;
import java.util.*;
import java.sql.*;

import javax.naming.*;
import javax.sql.*;
import tools.print.printer.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.naming.*;
import tools.print.lib.*;


/****************************************************************************************
 * PrinterTools																			*
 * 																						*
 * @author: Joe Comfort																	*
 * Copyright IBM																		*
 * 																						*
 * This class contains many useful methods that are used often throughout all of the	*
 * other servlets.  It's a means of writing code once and creating an instance of this	*
 * class whenever use of one of these common methods is needed.							*
 ****************************************************************************************/
public class PrinterTools {
	
	AppTools appTool = new AppTools();
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.printer.PrinterTools");
	
	/**********************************************************************************************
    * getServerName																				  *
    * 																							  *
    * This method returns the name of the server												  *
    ***********************************************************************************************/
   public String getServerName() throws IOException, ServletException  {
   	 
		// Reads property file and gets the value of servername
		//String sServerName = myResources.getString("serverName");
	   String sServerName = "";
		   
		//enter new code here
		Connection con = null;		
		PreparedStatement psServerName = null;
		ResultSet rsServerName = null;
		String rsQuery = "SELECT * FROM GPWS.CATEGORY_VIEW WHERE UPPER(CATEGORY_NAME) = 'SERVER_NAME'";

		try {
			con = getConnection();
			psServerName = con.prepareStatement(rsQuery);
			rsServerName = psServerName.executeQuery();
			while (rsServerName.next()) {
				sServerName = rsServerName.getString("CATEGORY_VALUE1");
			} //while results
			if (sServerName.equals("") || sServerName == null) {
				sServerName = myResources.getString("serverName");
			}
		} catch (SQLException e){
			System.out.println("PrinterTools method: getServerName ERROR: " + e);
		} finally {
	  		try {
	  			if (rsServerName != null) rsServerName.close();
	  			if (psServerName != null) psServerName.close();
	  			if (con != null) con.close();
	  		} catch (Exception e){
		  		System.out.println("PrinterTools method: getServerName ERROR2: " + e);
	  		}
		} //finally
		
   	    return sServerName;
   } //end of getServerName
   
   /**********************************************************************************************
    * getConnection																				  *
    * 																							  *
    * This method creates a connection to the specified database and returns that connection.     *
    ***********************************************************************************************/
   public Connection getConnection()
   		throws ServletException, IOException {
   			
   		Connection con = null;
		// Reads database values in property file
		String sDSJNDIname = myResources.getString("DSJNDIname");
   		
	 try {
		InitialContext ic = new InitialContext();
     	javax.sql.DataSource ds = (javax.sql.DataSource)ic.lookup(sDSJNDIname);
    	con = ds.getConnection();
    	con.setAutoCommit (true);
	 } catch (Exception e) {
	 	System.out.println("PrinterTools method: getConnection ERROR: " + e);
     }
		return con;
   }
   
   /**********************************************************************************************
    * getConnection																				  *
    * 																							  *
    * This method creates a connection to the specified database and returns that connection.     *
    ***********************************************************************************************/
   public Connection getConnection(String sDBname)
   		throws ServletException, IOException {
   			
   		Connection con = null;
		
		// Reads database values in property file
		String sDSJNDIname = myResources.getString("DSJNDIname");
   		
	 try {
		InitialContext ic = new InitialContext();
     	javax.sql.DataSource ds = (javax.sql.DataSource)ic.lookup(sDSJNDIname);
    	con = ds.getConnection();
		con.setAutoCommit (true);
	 } catch (Exception e) {
	 	System.out.println("PrinterTools method: getConnection ERROR: " + e);
     }
		return con;
   }
   
   /**********************************************************************************************
    * getEncryptPass																			 *
    * 																							 *
    * This method returns the db2 encryption password								             *
    **********************************************************************************************/
	public String getEncryptPass()
		throws IOException  {
	 
		String sEncryptPass = myResources.getString("encryptPass");
		//String sEncryptPass = appTool.getEncryptPW();
		if (sEncryptPass != null && !sEncryptPass.equals("")) {
			sEncryptPass = DecryptString(sEncryptPass);
		}
 	
		return sEncryptPass;
   }
   
   /**********************************************************************************************
	* EncryptString
	* 
	* This method returns an encrypted version of the passed string
	**********************************************************************************************/
	public String EncryptString(String sValue) throws IOException  {
	 
		String sEncryptValue = "";
		Random rand = new Random();
		int iRandom1 = rand.nextInt(26);
		int iRandom2 = rand.nextInt(26);
		int iRandom3 = rand.nextInt(26);
		int iRandom4 = rand.nextInt(26);
		char[] cAlphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
		char[] cDigits = {'0','1','2','3','4','5','6','7','8','9'};
		if (sValue.equals("") || sValue == null) {
			return sEncryptValue;
		} else {
		
			try {
				sEncryptValue += cAlphabet[iRandom1];
				sEncryptValue += cAlphabet[iRandom2];
				char tempChar;
				for (int x = 0; x < sValue.length(); x++) {
					tempChar = sValue.charAt(x);
					if (java.lang.Character.isLetter(tempChar)) {
						for (int y = 0; y < 26; y++) {
							if ((tempChar + "").toLowerCase().equals(cAlphabet[y] + "")) {
								if (y > 20) {
									if (y == 21) {
										if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
											sEncryptValue += (cAlphabet[0] + "").toUpperCase();
										} else {
											sEncryptValue += cAlphabet[0];
										}
									} else if (y == 22) {
										if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
											sEncryptValue += (cAlphabet[1] + "").toUpperCase();
										} else {
											sEncryptValue += cAlphabet[1];
										}
									} else if ( y == 23) {
										if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
											sEncryptValue += (cAlphabet[2] + "").toUpperCase();
										} else {
											sEncryptValue += cAlphabet[2];
										}
									} else if ( y == 24) {
										if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
											sEncryptValue += (cAlphabet[3] + "").toUpperCase();
										} else {
											sEncryptValue += cAlphabet[3];
										}
									} else if ( y == 25) {
										if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
											sEncryptValue += (cAlphabet[4] + "").toUpperCase();
										} else {
											sEncryptValue += cAlphabet[4];
										}
									}
								} else {
									if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
										sEncryptValue += (cAlphabet[y + 5] + "").toUpperCase();
									} else {
										sEncryptValue += cAlphabet[y + 5];
									}
								}
								break;
							} else {
								if (y == 25) {
									sEncryptValue += tempChar;
								}
							}
						}
					} else if (java.lang.Character.isDigit(tempChar)) {
						for (int z = 0; z < 10; z++) {
							if (tempChar == cDigits[z]) {
								if (z > 7) {
									if (z == 8) {
										sEncryptValue += cDigits[0];
									} else if (z == 9) {
										sEncryptValue += cDigits[1];
									}
								} else {
									sEncryptValue += cDigits[z + 2];
								}
								break;
							} else {
								if (z == 9) {
									sEncryptValue += tempChar;
								}
							}
						}
					} else {
						sEncryptValue += tempChar;
					} 
				}
				sEncryptValue += cAlphabet[iRandom3];
				sEncryptValue += cAlphabet[iRandom4];
				
			} catch (Exception mex) {
				System.out.println("ERROR in PrinterTools.EncryptString: " + mex);
			}
	  	return sEncryptValue;
		} //else sValue is not empty
	} //method EncryptString
	
	/**********************************************************************************************
	* DecryptString
	* 
	* This method returns an encrypted version of the passed string
	**********************************************************************************************/
	public String DecryptString(String sEncryptValue) throws IOException  {
	 
		String sValue = "";
		char[] cAlphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
		char[] cDigits = {'0','1','2','3','4','5','6','7','8','9'};
		if (sEncryptValue.equals("") || sEncryptValue == null) {
			return sValue;
		} else {
			
		try {

			sEncryptValue = sEncryptValue.substring(2,(sEncryptValue.length()-2));
			char tempChar;
			for (int x = 0; x < sEncryptValue.length(); x++) {
				tempChar = sEncryptValue.charAt(x);
				if (java.lang.Character.isLetter(tempChar)) {
					for (int y = 0; y < 26; y++) {
						if ((tempChar + "").toLowerCase().equals(cAlphabet[y] + "")) {
							if (y < 5) {
								if (y == 4) {
									if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
										sValue += (cAlphabet[25] + "").toUpperCase();
									} else {
										sValue += cAlphabet[25];
									}
								} else if (y == 3) {
									if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
										sValue += (cAlphabet[24] + "").toUpperCase();
									} else {
										sValue += cAlphabet[24];
									}
								} else if ( y == 2) {
									if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
										sValue += (cAlphabet[23] + "").toUpperCase();
									} else {
										sValue += cAlphabet[23];
									}
								} else if ( y == 1) {
									if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
										sValue += (cAlphabet[22] + "").toUpperCase();
									} else {
										sValue += cAlphabet[22];
									}
								} else if ( y == 0) {
									if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
										sValue += (cAlphabet[21] + "").toUpperCase();
									} else {
										sValue += cAlphabet[21];
									}
								}
							} else {
								if (java.lang.Character.isLetter(tempChar) && java.lang.Character.isUpperCase(tempChar)) {
									sValue += (cAlphabet[y - 5] + "").toUpperCase();
								} else {
									sValue += cAlphabet[y - 5];
								}
							}
							break;
						} else {
							if (y == 25) {
								sValue += tempChar;
							}
						}
					}
				} else if (java.lang.Character.isDigit(tempChar)) {
					for (int z = 0; z < 10; z++) {
						if (tempChar == cDigits[z]) {
							if (z < 2) {
								if (z == 1) {
									sValue += cDigits[9];
								} else if (z == 0) {
									sValue += cDigits[8];
								}
							} else {
								sValue += cDigits[z - 2];
							}
							break;
						} else {
							if (z == 9) {
								sValue += tempChar;
							}
						}
					}
				} else {
					sValue += tempChar;
				} 
			}
		
		} catch (Exception mex) {
			System.out.println("ERROR in PrinterTools.DecryptString: " + mex);
		}
 		return sValue;
		} //else sValue is not empty
	} //method DecryptString
	
	/****************************************************************************************
	* UpdatePassword - Updates the password for misc table
	*****************************************************************************************/
	public int UpdatePassword(HttpServletRequest req) throws IOException, SQLException, ServletException {
		
		String clsid = req.getParameter("clsid");
		String clsid64bit = req.getParameter("clsid64bit");
		String pluginurl = req.getParameter("pluginurl");
		String pluginspage = req.getParameter("pluginspage");
		String successurl = req.getParameter("successurl");
		String errorurl = req.getParameter("errorurl");
		String authmethod= req.getParameter("authmethod");
		String encryptpassword = req.getParameter("encryptpasswd");
		String pluginver = req.getParameter("pluginver");
		String widgetver = req.getParameter("widgetver");
		String ils = req.getParameter("ils");
		int settingid = Integer.parseInt(req.getParameter("settingid"));
		String clientuserid = req.getParameter("clientuserid");
		String clientpassword = req.getParameter("clientpasswd");
		if (clientpassword == null) {
			clientpassword = "";
		}
		String clientdumpdir = req.getParameter("clientdumpdir");
		Connection con = null;
		PreparedStatement stmtPass = null;
		int iReturnCode = -1;
		encryptpassword = EncryptString(encryptpassword);
		clientpassword = EncryptString(clientpassword);
		try {	
	  		con = getConnection();
			int setPW = -1;
			//System.out.println("UPDATE MISC SET CLSID = '"+clsid+"', PLUGINURL = '"+pluginurl+"' , PLUGINSPAGE = '"+pluginspage+"', SUCCESSURL = '"+successurl+"', ERRORURL = '"+errorurl+"' , PLUGINVER = '"+pluginver+"', CLIENT_USER_ID = '"+clientuserid+"', CLIENT_PASSWORD = '"+clientpassword+"', CLIENT_DUMP_DIR = '"+clientdumpdir+"' WHERE APP_SETTINGSID = "+settingid+"");
			stmtPass = con.prepareStatement("UPDATE GPWS.APP_SETTINGS SET CLSID = ?, CLSID_64BIT = ?, PLUGIN_URL = ?, PLUGINS_PAGE = ?, SUCCESS_URL = ?, ERROR_URL = ?, PLUGIN_VERSION = ?, WIDGET_VERSION = ?, AUTH_METHOD = ?, ENCRYPT_PASSWORD = ?, ILS = ?, CLIENT_USER_ID = ?, CLIENT_PASSWORD = ?, CLIENT_DUMP_DIR = ? WHERE APP_SETTINGSID = ?");
			stmtPass.setString(1,clsid);
			stmtPass.setString(2,clsid64bit);
			stmtPass.setString(3,pluginurl);
			stmtPass.setString(4,pluginspage);
			stmtPass.setString(5,successurl);
			stmtPass.setString(6,errorurl);
			stmtPass.setString(7,pluginver);
			stmtPass.setString(8,widgetver);
			stmtPass.setString(9,authmethod.toLowerCase());
			stmtPass.setString(10,encryptpassword);
			stmtPass.setString(11,ils);
			stmtPass.setString(12,clientuserid);
			stmtPass.setString(13,clientpassword);
			stmtPass.setString(14,clientdumpdir);
			stmtPass.setInt(15,settingid);
			setPW = stmtPass.executeUpdate();
			
			if (setPW == 1) {
				iReturnCode = 0;
			} else {
				iReturnCode = 2;
			}
		
		} catch(SQLException e) {
			System.out.println("GPWSAdmin error.1 in PrinterTool.UpdatePassword ERROR: " + e);
			String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
		} finally {
			try {
				if (stmtPass != null)
					stmtPass.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("GPWSAdmin error.2 in PrinterTool.UpdatePassword ERROR: " + e);
			}
		}
	  
		return iReturnCode;
		
	} // end UpdatePassword
	
	/****************************************************************************************
	* InsertFTPPassword - Updates the password for ftp table																*
	*****************************************************************************************/
	public int InsertFTPPassword(HttpServletRequest req) throws IOException, SQLException, ServletException, Exception {
	
		HttpSession session = req.getSession(false);
		String ftpsite = req.getParameter("ftpsite");
		String ftpuser = req.getParameter("ftpuser");
		String ftppass = req.getParameter("ftppass");
		String ftpgeo = req.getParameter("sdc");
		String homedir = req.getParameter("homedir");
		String ftpcontactemail = req.getParameter("ftpcontactemail");
		Connection con = null;
		Statement stmtPass = null;
		int iReturnCode = -1;
		ftppass = EncryptString(ftppass);
		//System.out.println("Values are: " + ftpsite + " " + ftpuser + " " + ftppass + " " + ftpgeo + " " + ftpcontactemail);
		try {	
			con = getConnection();
			// update db
			stmtPass = con.createStatement();
			int setPW = -1;
			setPW = stmtPass.executeUpdate("INSERT INTO GPWS.FTP (FTPID, FTP_SITE, FTP_USER, FTP_PASS, FTP_GEO, FTP_CONTACT_EMAIL, HOME_DIRECTORY) VALUES (COALESCE( (SELECT MAX(FTPID)+1 FROM GPWS.FTP),1),'"+ftpsite+"','"+ftpuser+"','"+ftppass+"','"+ftpgeo+"','"+ftpcontactemail+"','"+homedir+"')");
			if (setPW == 1) {
				iReturnCode = 0;
			} else {
				iReturnCode = 2;
			}
	
		} catch(SQLException e) {
			System.out.println("PrinterTool error in PrinterTool.InsertFTPPassword ERROR: " + e + ". Error code is: " + e.getErrorCode());
			String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			appTool.logError("PrinterTool.InsertFTPPassword","GPWSAdmin",e.getMessage());
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
		} finally {
			try {
				if (stmtPass != null)
					stmtPass.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("PrinterTool error in PrinterTool.insertFTPPassword ERROR: " + e);
			}
		}
  
		return iReturnCode;
	
	} // end InsertFTPPassword
	
	/****************************************************************************************
	* UpdateFTPPassword - Updates the password for ftp table																*
	*****************************************************************************************/
	public int UpdateFTPPassword(HttpServletRequest req) throws IOException, SQLException, ServletException, Exception {

		HttpSession session = req.getSession(false);
		int ftpid = Integer.parseInt(req.getParameter("ftpid"));
		String ftpsite = req.getParameter("ftpsite");
		String ftpuser = req.getParameter("ftpuser");
		String ftppass = req.getParameter("ftppass");
		String ftpgeo = req.getParameter("sdc");
		String ftpcontactemail = req.getParameter("ftpcontactemail");
		String homedir = req.getParameter("homedir");
		Connection con = null;
		PreparedStatement stmtPass = null;
		int iReturnCode = -1;
		//System.out.println("Client password is: " + clientpassword);
		ftppass = EncryptString(ftppass);
		//System.out.println("New encrypted password is: " + clientpassword);
		try {	

			con = getConnection();
			// update db
			int setPW = -1;
			stmtPass = con.prepareStatement("UPDATE GPWS.FTP SET FTP_SITE = ?, FTP_USER = ?, FTP_PASS = ?, FTP_GEO = ?, FTP_CONTACT_EMAIL = ?, HOME_DIRECTORY = ? WHERE FTPID = ?");
			stmtPass.setString(1,ftpsite);
			stmtPass.setString(2,ftpuser);
			stmtPass.setString(3,ftppass);
			stmtPass.setString(4,ftpgeo);
			stmtPass.setString(5,ftpcontactemail);
			stmtPass.setString(6,homedir);
			stmtPass.setInt(7,ftpid);
			setPW = stmtPass.executeUpdate();
			if (setPW == 1) {
				iReturnCode = 0;
			} else {
				iReturnCode = 2;
			}

		} catch(SQLException e) {
			System.out.println("PrinterTool error in PrinterTool.UpdateFTPPassword ERROR: " + e + ". Error code is: " + e.getErrorCode());
			String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			appTool.logError("PrinterTool.UpdateFTPPassword","GPWSAdmin",e.getMessage());
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
		} finally {
			try {
				if (stmtPass != null)
					stmtPass.close();
				if (con != null)
					con.close();
		} catch (Exception e) {
				System.out.println("PrinterTool error in PrinterTool.UpdatePassword ERROR: " + e);
				}
		}
  
		return iReturnCode;
	
		} // end UpdateFTPPassword
		
	/****************************************************************************************
	* InsertFTPPassword - Updates the password for ftp table																*
	*****************************************************************************************/
	public int InsertPrinterPassword(HttpServletRequest req) throws IOException, SQLException {

		HttpSession session = req.getSession(false);
		int locid = 0;
		String geo = req.getParameter("geo");
		String country = req.getParameter("country");
		String city = req.getParameter("city");;
		String building = req.getParameter("building");
		String floor = req.getParameter("floor");
		String room = req.getParameter("room");
		String name = req.getParameter("name");
		String type = req.getParameter("type");
		String access = req.getParameter("access");
		String cs = req.getParameter("cs");
		String vm = req.getParameter("vm");
		String mvs = req.getParameter("mvs");
		String sap = req.getParameter("sap");
		String wts = req.getParameter("wts");
		String ims = req.getParameter("ims");
		String protocol95 = req.getParameter("protocol95");
		String protocolnt = req.getParameter("protocolnt");
		String protocolws = req.getParameter("protocolws");
		String protocolxp = req.getParameter("protocolxp");
		String protocollx = req.getParameter("protocollx");
		String drvkey95 = req.getParameter("drvkey95");
		String drvkeynt = req.getParameter("drvkeynt");
		String drvkeyws = req.getParameter("drvkeyws");
		String drvkeyxp = req.getParameter("drvkeyxp");
		String drvkeylx = req.getParameter("drvkeylx");
		String port95 = req.getParameter("port95");
		String portnt = req.getParameter("portnt");
		String portws = req.getParameter("portws");
		String portxp = req.getParameter("portxp");
		String portlx = req.getParameter("portlx");
		String host95 = req.getParameter("host95");
		String hostnt = req.getParameter("hostnt");
		String hostws = req.getParameter("hostws");
		String hostxp = req.getParameter("hostxp");
		String hostlx = req.getParameter("hostlx");
		String spooler95 = req.getParameter("spooler95");
		String spoolernt = req.getParameter("spoolernt");
		String spoolerws = req.getParameter("spoolerws");
		String spoolerxp = req.getParameter("spoolerxp");
		String spoolerlx = req.getParameter("spoolerlx");
		String lpname95 = req.getParameter("lpname95");
		String lpnament = req.getParameter("lpnament");
		String lpnamews = req.getParameter("lpnamews");
		String lpnamexp = req.getParameter("lpnamexp");
		String lpnamelx = req.getParameter("lpnamelx");
		String changeini95 = req.getParameter("changeini95");
		String changeinint = req.getParameter("changeinint");
		String changeiniws = req.getParameter("changeiniws");
		String changeinixp = req.getParameter("changeinixp");
		String changeinilx = req.getParameter("changeinilx");
		String optionsfile95 = req.getParameter("optionsfile95");
		String optionsfilent = req.getParameter("optionsfilent");
		String optionsfilews = req.getParameter("optionsfilews");
		String optionsfilexp = req.getParameter("optionsfilexp");
		String optionsfilelx = req.getParameter("optionsfilelx");
		String restrict = req.getParameter("restrict");
		String sepfile = req.getParameter("sepfile");
		int ftpid = Integer.parseInt(req.getParameter("ftpid"));
		String status = req.getParameter("status");
		
		Connection con = null;
		Statement stmtPass = null;
		//Statement stmt = null;
		Statement stmtPrtInfo = null;
		//ResultSet rs = null;
		int iReturnCode = -1;
		//System.out.println("Client password is: " + clientpassword);
		restrict = EncryptString(restrict);
		//System.out.println("New encrypted password is: " + clientpassword);
		try {	

			con = getConnection();

			// update db
			stmtPass = con.createStatement();
			stmtPrtInfo = con.createStatement();
			int setPW = -1;
			
			locid = getLocID(req);
			
			if (ftpid <= 0) { //ftpid is empty, do not update FTP field
				setPW = stmtPass.executeUpdate("INSERT INTO PRINTER (LOCID, ROOM, NAME, TYPE,ACCESS,CS, VM,MVS,SAP,WTS,IMS,PROTOCOLKEY95, PROTOCOLKEYNT, PROTOCOLKEYWS, PROTOCOLKEYXP, PROTOCOLKEYLX, DRVKEY95, DRVKEYNT, DRVKEYWS, DRVKEYXP, DRVKEYLX, PORT95, PORTNT, PORTWS, PORTXP, PORTLX, HOST95, HOSTNT, HOSTWS, HOSTXP, HOSTLX, SPOOLER95, SPOOLERNT, SPOOLERWS, SPOOLERXP, SPOOLERLX, LPNAME95, LPNAMENT, LPNAMEWS, LPNAMEXP, LPNAMELX, OPTIONSFILE95, OPTIONSFILENT, OPTIONSFILEWS, OPTIONSFILEXP, OPTIONSFILELX, CHANGEINI95, CHANGEININT, CHANGEINIWS, CHANGEINIXP, CHANGEINILX, RESTRICT, SEPFILE, STATUS) VALUES ("+locid+", '"+room+"', '"+name+"', '"+type+"', '"+access+"', '"+cs+"', '"+vm+"', '"+mvs+"', '"+sap+"', '"+wts+"', '"+ims+"', '"+protocol95+"', '"+protocolnt+"', '"+protocolws+"', '"+protocolxp+"', '"+protocollx+"', '"+drvkey95+"', '"+drvkeynt+"', '"+drvkeyws+"', '"+drvkeyxp+"', '"+drvkeylx+"', '"+port95+"', '"+portnt+"', '"+portws+"', '"+portxp+"', '"+portlx+"', '"+host95+"', '"+hostnt+"', '"+hostws+"', '"+hostxp+"', '"+hostlx+"', '"+spooler95+"', '"+spoolernt+"', '"+spoolerws+"', '"+spoolerxp+"', '"+spoolerlx+"', '"+lpname95+"', '"+lpnament+"', '"+lpnamews+"', '"+lpnamexp+"', '"+lpnamelx+"', '"+optionsfile95+"', '"+optionsfilent+"', '"+optionsfilews+"', '"+optionsfilexp+"', '"+optionsfilelx+"', '"+changeini95+"', '"+changeinint+"', '"+changeiniws+"', '"+changeinixp+"', '"+changeinilx+"', '"+restrict+"', '"+sepfile+"', '"+status+"')");
				System.out.println("setPW = " + setPW);
			} else {
				setPW = stmtPass.executeUpdate("INSERT INTO PRINTER (LOCID, ROOM, NAME, TYPE,ACCESS,CS, VM,MVS,SAP,WTS,IMS,PROTOCOLKEY95, PROTOCOLKEYNT, PROTOCOLKEYWS, PROTOCOLKEYXP, PROTOCOLKEYLX, DRVKEY95, DRVKEYNT, DRVKEYWS, DRVKEYXP, DRVKEYLX, PORT95, PORTNT, PORTWS, PORTXP, PORTLX, HOST95, HOSTNT, HOSTWS, HOSTXP, HOSTLX, SPOOLER95, SPOOLERNT, SPOOLERWS, SPOOLERXP, SPOOLERLX, LPNAME95, LPNAMENT, LPNAMEWS, LPNAMEXP, LPNAMELX, OPTIONSFILE95, OPTIONSFILENT, OPTIONSFILEWS, OPTIONSFILEXP, OPTIONSFILELX, CHANGEINI95, CHANGEININT, CHANGEINIWS, CHANGEINIXP, CHANGEINILX, RESTRICT, SEPFILE, FTPID, STATUS) VALUES ("+locid+", '"+room+"', '"+name+"', '"+type+"', '"+access+"', '"+cs+"', '"+vm+"', '"+mvs+"', '"+sap+"', '"+wts+"', '"+ims+"', '"+protocol95+"', '"+protocolnt+"', '"+protocolws+"', '"+protocolxp+"', '"+protocollx+"', '"+drvkey95+"', '"+drvkeynt+"', '"+drvkeyws+"', '"+drvkeyxp+"', '"+drvkeylx+"', '"+port95+"', '"+portnt+"', '"+portws+"', '"+portxp+"', '"+portlx+"', '"+host95+"', '"+hostnt+"', '"+hostws+"', '"+hostxp+"', '"+hostlx+"', '"+spooler95+"', '"+spoolernt+"', '"+spoolerws+"', '"+spoolerxp+"', '"+spoolerlx+"', '"+lpname95+"', '"+lpnament+"', '"+lpnamews+"', '"+lpnamexp+"', '"+lpnamelx+"', '"+optionsfile95+"', '"+optionsfilent+"', '"+optionsfilews+"', '"+optionsfilexp+"', '"+optionsfilelx+"', '"+changeini95+"', '"+changeinint+"', '"+changeiniws+"', '"+changeinixp+"', '"+changeinilx+"', '"+restrict+"', '"+sepfile+"', "+ftpid+", '"+status+"')");
				System.out.println("setPW = " + setPW);
			}
			if (setPW == 1) {
				iReturnCode = 0;
			} else {
				iReturnCode = 2;
			}

			if (iReturnCode == 0) {
				stmtPrtInfo.executeUpdate("INSERT INTO PRTINFO (PRTNAME) VALUES ('"+name+"')");
			}

		} catch(Exception e) {
			System.out.println("PrinterTool error in PrinterTool.InsertPrinterPassword ERROR: " + e);
		} finally {
			try {
				if (stmtPrtInfo != null)
					stmtPrtInfo.close();
				if (stmtPass != null)
					stmtPass.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("PrinterTool error in PrinterTool.UpdatePassword ERROR: " + e);
				}
			}
  
			return iReturnCode;
	
		} // end InsertPrinterPassword
		
	/****************************************************************************************
	* UpdateFTPPassword - Updates the password for ftp table																*
	*****************************************************************************************/
	public int UpdatePrinterPassword(HttpServletRequest req) throws Exception, IOException, SQLException {

		HttpSession session = req.getSession(false);
		int locid = 0;
		String geo = req.getParameter("geo");
		String country = req.getParameter("country");
		String city = req.getParameter("city");;
		String building = req.getParameter("building");
		String floor = req.getParameter("floor");
		String room = req.getParameter("room");
		String name = req.getParameter("name");
		String type = req.getParameter("type");
		String access = req.getParameter("access");
		String cs = req.getParameter("cs");
		String vm = req.getParameter("vm");
		String mvs = req.getParameter("mvs");
		String sap = req.getParameter("sap");
		String wts = req.getParameter("wts");
		String ims = req.getParameter("ims");
		String protocol95 = req.getParameter("protocol95");
		String protocolnt = req.getParameter("protocolnt");
		String protocolws = req.getParameter("protocolws");
		String protocolxp = req.getParameter("protocolxp");
		String protocollx = req.getParameter("protocollx");
		String drvkey95 = req.getParameter("drvkey95");
		String drvkeynt = req.getParameter("drvkeynt");
		String drvkeyws = req.getParameter("drvkeyws");
		String drvkeyxp = req.getParameter("drvkeyxp");
		String drvkeylx = req.getParameter("drvkeylx");
		String port95 = req.getParameter("port95");
		String portnt = req.getParameter("portnt");
		String portws = req.getParameter("portws");
		String portxp = req.getParameter("portxp");
		String portlx = req.getParameter("portlx");
		String host95 = req.getParameter("host95");
		String hostnt = req.getParameter("hostnt");
		String hostws = req.getParameter("hostws");
		String hostxp = req.getParameter("hostxp");
		String hostlx = req.getParameter("hostlx");
		String spooler95 = req.getParameter("spooler95");
		String spoolernt = req.getParameter("spoolernt");
		String spoolerws = req.getParameter("spoolerws");
		String spoolerxp = req.getParameter("spoolerxp");
		String spoolerlx = req.getParameter("spoolerlx");
		String lpname95 = req.getParameter("lpname95");
		String lpnament = req.getParameter("lpnament");
		String lpnamews = req.getParameter("lpnamews");
		String lpnamexp = req.getParameter("lpnamexp");
		String lpnamelx = req.getParameter("lpnamelx");
		String changeini95 = req.getParameter("changeini95");
		String changeinint = req.getParameter("changeinint");
		String changeiniws = req.getParameter("changeiniws");
		String changeinixp = req.getParameter("changeinixp");
		String changeinilx = req.getParameter("changeinilx");
		String optionsfile95 = req.getParameter("optionsfile95");
		String optionsfilent = req.getParameter("optionsfilent");
		String optionsfilews = req.getParameter("optionsfilews");
		String optionsfilexp = req.getParameter("optionsfilexp");
		String optionsfilelx = req.getParameter("optionsfilelx");
		String origname = req.getParameter("origname");
		int origlocid = Integer.parseInt(req.getParameter("origlocid"));
		String origroom = req.getParameter("origroom");
		String restrict = req.getParameter("restrict");
		String sepfile = req.getParameter("sepfile");
		int ftpid = Integer.parseInt(req.getParameter("ftpid"));
		String status = req.getParameter("status");
		//String stimestamp = req.getParameter("datetime");
		DateTime dateTime = new DateTime();
		Timestamp tsTimestamp = dateTime.getServerTimestamp();
	
		Connection con = null;
		Statement stmtPass = null;
		//Statement stmt = null;
		//ResultSet rs = null;
		int iReturnCode = -1;
		//System.out.println("Client password is: " + clientpassword);
		restrict = EncryptString(restrict);
		//System.out.println("New encrypted password is: " + clientpassword);
		try {	

			con = getConnection();

			// update db
			stmtPass = con.createStatement();
			int setPW = -1;

			locid = getLocID(req);
			if (ftpid <= 0) { //ftpid is empty, do not update FTP field
				setPW = stmtPass.executeUpdate("UPDATE PRINTER SET LOCID = "+locid+", ROOM = '"+room+"', NAME = '"+name+"', TYPE = '"+type+"', ACCESS =  '"+access+"', CS = '"+cs+"', VM = '"+vm+"',MVS = '"+mvs+"', SAP = '"+sap+"', WTS = '"+wts+"', IMS = '"+ims+"', PROTOCOLKEY95 = '"+protocol95+"', PROTOCOLKEYNT = '"+protocolnt+"', PROTOCOLKEYWS = '"+protocolws+"', PROTOCOLKEYXP = '"+protocolxp+"', PROTOCOLKEYLX = '"+protocollx+"',DRVKEY95 = '"+drvkey95+"', DRVKEYNT = '"+drvkeynt+"', DRVKEYWS = '"+drvkeyws+"', DRVKEYXP = '"+drvkeyxp+"',DRVKEYLX = '"+drvkeylx+"',PORT95 = '"+port95+"',PORTNT = '"+portnt+"', PORTWS = '"+portws+"', PORTXP = '"+portxp+"', PORTLX='"+portlx+"',HOST95 = '"+host95+"', HOSTNT = '"+hostnt+"', HOSTWS = '"+hostws+"', HOSTXP = '"+hostxp+"', HOSTLX = '"+hostlx+"', SPOOLER95 = '"+spooler95+"', SPOOLERNT = '"+spoolernt+"', SPOOLERWS = '"+spoolerws+"', SPOOLERXP = '"+spoolerxp+"',SPOOLERLX = '"+spoolerlx+"', LPNAME95 = '"+lpname95+"', LPNAMENT = '"+lpnament+"', LPNAMEWS = '"+lpnamews+"', LPNAMEXP = '"+lpnamexp+"',LPNAMELX = '"+lpnamelx+"', OPTIONSFILE95 = '"+optionsfile95+"', OPTIONSFILENT = '"+optionsfilent+"', OPTIONSFILEWS = '"+optionsfilews+"', OPTIONSFILEXP = '"+optionsfilexp+"', OPTIONSFILELX = '"+optionsfilelx+"',CHANGEINI95 = '"+changeini95+"', CHANGEININT = '"+changeinint+"', CHANGEINIWS = '"+changeiniws+"', CHANGEINIXP = '"+changeinixp+"', CHANGEINILX = '"+changeinilx+"',RESTRICT = '"+restrict+"', SEPFILE = '"+sepfile+"', STATUS = '"+status+"', DATETIME = '"+tsTimestamp+"' WHERE NAME = '"+origname+"'");
				System.out.println("setPW = " + setPW);
			} else {
				setPW = stmtPass.executeUpdate("UPDATE PRINTER SET LOCID = "+locid+", ROOM = '"+room+"', NAME = '"+name+"', TYPE = '"+type+"', ACCESS =  '"+access+"', CS = '"+cs+"', VM = '"+vm+"',MVS = '"+mvs+"', SAP = '"+sap+"', WTS = '"+wts+"', IMS = '"+ims+"', PROTOCOLKEY95 = '"+protocol95+"', PROTOCOLKEYNT = '"+protocolnt+"', PROTOCOLKEYWS = '"+protocolws+"', PROTOCOLKEYXP = '"+protocolxp+"', PROTOCOLKEYLX = '"+protocollx+"',DRVKEY95 = '"+drvkey95+"', DRVKEYNT = '"+drvkeynt+"', DRVKEYWS = '"+drvkeyws+"', DRVKEYXP = '"+drvkeyxp+"',DRVKEYLX = '"+drvkeylx+"',PORT95 = '"+port95+"',PORTNT = '"+portnt+"', PORTWS = '"+portws+"', PORTXP = '"+portxp+"', PORTLX='"+portlx+"',HOST95 = '"+host95+"', HOSTNT = '"+hostnt+"', HOSTWS = '"+hostws+"', HOSTXP = '"+hostxp+"', HOSTLX = '"+hostlx+"', SPOOLER95 = '"+spooler95+"', SPOOLERNT = '"+spoolernt+"', SPOOLERWS = '"+spoolerws+"', SPOOLERXP = '"+spoolerxp+"',SPOOLERLX = '"+spoolerlx+"', LPNAME95 = '"+lpname95+"', LPNAMENT = '"+lpnament+"', LPNAMEWS = '"+lpnamews+"', LPNAMEXP = '"+lpnamexp+"',LPNAMELX = '"+lpnamelx+"', OPTIONSFILE95 = '"+optionsfile95+"', OPTIONSFILENT = '"+optionsfilent+"', OPTIONSFILEWS = '"+optionsfilews+"', OPTIONSFILEXP = '"+optionsfilexp+"', OPTIONSFILELX = '"+optionsfilelx+"',CHANGEINI95 = '"+changeini95+"', CHANGEININT = '"+changeinint+"', CHANGEINIWS = '"+changeiniws+"', CHANGEINIXP = '"+changeinixp+"', CHANGEINILX = '"+changeinilx+"',RESTRICT = '"+restrict+"', SEPFILE = '"+sepfile+"', FTPID = "+ftpid+", STATUS = '"+status+"', DATETIME = '"+tsTimestamp+"' WHERE NAME = '"+origname+"'");
				System.out.println("setPW = " + setPW);
			} //else ftpid is not empty
			if (setPW == 1) {
				iReturnCode = 0;
			} else {
				iReturnCode = 2;
			}

		} catch(Exception e) {
			System.out.println("PrinterTool error in PrinterTool.UpdatePrinterPassword ERROR: " + e);
		} finally {
			try {
				if (stmtPass != null)
					stmtPass.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("PrinterTool error in PrinterTool.UpdatePrinterPassword ERROR: " + e);
					}
				}
  
				return iReturnCode;
	
			} // end UpdateFTPPassword
			
	/********************************************************************************************
	* sendMail										       										*
	*											       											*
	* This method takes 6 strings (receiver, cc, subject, body, sender, name) and a PrintWriter.	*
	* It will send an email with the information provided to it.								*
	********************************************************************************************/
			
	public boolean sendMail(String sTo, String sCC, String sSubject, String sMessage, String sSender, String sName)
		throws IOException {

		boolean result = true;
	
		Properties defaultProps = new Properties();
		String sSmtpHost = (String) myResources.getString("smtphost");
		//String sFromInternetAddress = (String) myResources.getString("frominternetaddress");
		String sFromInternetAddress = sSender;
		//String sFromName = (String) myResources.getString("fromname");
		String sFromName = sName;
	
		String sMessageToSend = ("********************************************************\n* THIS NOTE WAS GENERATED BY A SERVICE REQUEST MACHINE *\n* PLEASE DO NOT REPLY TO THIS NOTE                     *\n********************************************************\n\n");
		//ResourceBundle sPropertyFilePath =
			//ResourceBundle.getBundle("tools.print.printer.PrinterTools");

		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		sMessage = (sMessageToSend + sMessage);

		try {

			message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
			message.addRecipient(Message.RecipientType.TO,
				new InternetAddress(sTo));
			message.addRecipient(Message.RecipientType.CC,
				new InternetAddress(sCC));
			message.setSubject(sSubject);
			message.setText(sMessage);

			Transport.send(message);

		} catch (Exception e) {
			result = false;
			System.out.println("Error in method PrinterTools.sendMail: " + e);
		}

		return result;
	}  //end of method sendMail
	
	/********************************************************************************************
	* sendMail										       										*
	*											       											*
	* This method takes 5 strings (receiver, subject, body, sender, name) and a PrintWriter.	*
	* It will send an email with the information provided to it.								*
	********************************************************************************************/
		
	public boolean sendMail(String sTo, String sSubject, String sMessage, String sSender, String sName)
		throws IOException {

		boolean result = true;

		Properties defaultProps = new Properties();
		String sSmtpHost = (String) myResources.getString("smtphost");
		//String sFromInternetAddress = (String) myResources.getString("frominternetaddress");
		String sFromInternetAddress = sSender;
		//String sFromName = (String) myResources.getString("fromname");
		String sFromName = sName;

		String sMessageToSend = ("********************************************************\n* THIS NOTE WAS GENERATED BY A SERVICE REQUEST MACHINE *\n* PLEASE DO NOT REPLY TO THIS NOTE                     *\n********************************************************\n\n");
		//ResourceBundle sPropertyFilePath =
			//ResourceBundle.getBundle("tools.print.printer.PrinterTools");

		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		sMessage = (sMessageToSend + sMessage);

		try {

			message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
			message.addRecipient(Message.RecipientType.TO,
				new InternetAddress(sTo));
			message.setSubject(sSubject);
			message.setText(sMessage);

			Transport.send(message);

		} catch (Exception e) {
			result = false;
			System.out.println("Error in method PrinterTools.sendMail: " + e);
		}

		return result;
	}
	
	/****************************************************************************************
	* getLocID - gets the locid of the location																*
	*****************************************************************************************/
	public int getLocID(HttpServletRequest req) throws IOException, SQLException {

		HttpSession session = req.getSession(false);
		int locid = 0;
		String geo = req.getParameter("geo");
		String country = req.getParameter("country");
		String city = req.getParameter("city");;
		String building = req.getParameter("building");
		String floor = req.getParameter("floor");
					
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		int iReturnCode = -1;
			
		try {	
			con = getConnection();
			stmt = con.prepareStatement("SELECT LOCID FROM GPWS.LOCATION_VIEW WHERE FLOOR_NAME = ? AND BUILDING_NAME = ? AND CITY = ? AND COUNTRY = ? AND GEO = ?");
			stmt.setString(1,floor);
			stmt.setString(2,building);
			stmt.setString(3,city);
			stmt.setString(4,country);
			stmt.setString(5,geo);
			rs = stmt.executeQuery();
			
			while (rs.next()) {
				locid = Integer.parseInt(rs.getString("locid"));
			}  //while available
				
		} catch(Exception e) {
			System.out.println("PrinterTool error in PrinterTool.getLocID ERROR: " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("PrinterTool error in PrinterTool.getLocID ERROR: " + e);
				}
			}
  		return locid;
	
	} // end InsertPrinterPassword
	
	/********************************************************************************************
	* nullStringConverter
	* 
	* This will convert any null value to an empty string. Strings with a value are not affected
	********************************************************************************************/
	public String nullStringConverter( String s )
		throws IOException {
		
			String sNewString = "";
			if(s != null) {
				sNewString = s;
			}
	
		return sNewString;
	}
	
	/********************************************************************************************
	* validDeviceFunction
	* 
	********************************************************************************************/
	public boolean validDeviceFunction(String sFunc) throws IOException {
		
		boolean bResult = false;
		Connection con = null;
		PreparedStatement stmtFunc = null;
		ResultSet rsFunc = null;
		AppTools appTool = new AppTools();
		
		try {
			sFunc = nullStringConverter(sFunc);
			con = appTool.getConnection();
			stmtFunc = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'DeviceFunction'");
			rsFunc = stmtFunc.executeQuery();
			
			while (rsFunc.next()) {
				if (nullStringConverter(rsFunc.getString("CATEGORY_VALUE1")).equals(sFunc)) {
					bResult = true;
				} else if (nullStringConverter(rsFunc.getString("CATEGORY_VALUE2")).equals(sFunc)) {
					bResult = true;
				}
			}
		} catch (Exception e) {
			System.out.println("Error in PrinterTools.validDeviceFunction ERROR: " + e);
		} finally {
			try {
				if (rsFunc != null)
					rsFunc.close();
				if (stmtFunc != null)
					stmtFunc.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("Error in PrinterTools.validDeviceFunction.2 ERROR: " + e);
			}
		}
			
		return bResult;
	}
	
	/********************************************************************************************
	* isECPrintDevice
	* 
	********************************************************************************************/
	public boolean isECPrintDevice(String sDevice) throws IOException {
		boolean isECPrint = false;
		
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			sDevice = nullStringConverter(sDevice);
			con = appTool.getConnection();
			stmt = con.prepareStatement("SELECT CLIENT_DEF_TYPE, SERVER_DEF_TYPE FROM GPWS.DEVICE_VIEW WHERE DEVICE_NAME = '" + sDevice + "'");
			rs = stmt.executeQuery();
			
			while (rs.next()) {
				if (nullStringConverter(rs.getString("SERVER_DEF_TYPE")).equalsIgnoreCase("VPSX")) {
					isECPrint = true;
				} else if (nullStringConverter(rs.getString("CLIENT_DEF_TYPE")).toUpperCase().indexOf("VPSX") >= 0) {
					isECPrint = true;
				}
			}
		} catch (Exception e) {
			System.out.println("Error in PrinterTools.isECPrintDevice ERROR: " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("Error in PrinterTools.isECPrintDevice.2 ERROR: " + e);
			}
		}
		
		return isECPrint;
	}
	
	/********************************************************************************************
	* validDeviceFunction
	* 
	********************************************************************************************/
	public boolean DeviceFunctionExist(String sFunc, int iDeviceID) throws IOException {
		
		boolean bResult = false;
		Connection con = null;
		PreparedStatement stmtFunc = null;
		ResultSet rsFunc = null;
		AppTools appTool = new AppTools();
		
		try {
			con = appTool.getConnection();

			stmtFunc = con.prepareStatement("SELECT FUNCTION_NAME FROM GPWS.DEVICE_FUNCTIONS WHERE DEVICEID = ?");
			stmtFunc.setInt(1,iDeviceID);
			rsFunc = stmtFunc.executeQuery();
			
			while (rsFunc.next()) {
				if (rsFunc.getString("FUNCTION_NAME").equals(sFunc)) {
					bResult = true;
				}
			}
		} catch (Exception e) {
			System.out.println("Error in PrinterTools.DeviceFunctionExist ERROR: " + e);
		} finally {
			try {
				if (rsFunc != null)
					rsFunc.close();
				if (stmtFunc != null)
					stmtFunc.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("Error in PrinterTools.DeviceFunctionExist.2 ERROR: " + e);
			}
		}
		return bResult;
	}
	
	/**********************************************************************************************
    * getDeviceLocation									
    * 													
    * This method returns the location fields of a device
    ***********************************************************************************************/
    public String[] getDeviceLocation(String sDevice) throws IOException, ServletException  {

    	String[] sLoc = new String[6];
    	
    	if (sDevice != null && sDevice != "") {
    		sDevice = sDevice.toUpperCase();
    	}
		   
		Connection con = null;		
		PreparedStatement psDevice = null;
		ResultSet rsDevice = null;
		String rsQuery = "SELECT GEO, COUNTRY, STATE, CITY, BUILDING_NAME, FLOOR_NAME FROM GPWS.DEVICE_VIEW WHERE UPPER(DEVICE_NAME) = '" + sDevice + "'";

		try {
			con = getConnection();
			psDevice = con.prepareStatement(rsQuery);
			rsDevice = psDevice.executeQuery();
			while (rsDevice.next()) {
				sLoc[0] = nullStringConverter(rsDevice.getString("GEO"));
				sLoc[1] = nullStringConverter(rsDevice.getString("COUNTRY"));
				sLoc[2] = nullStringConverter(rsDevice.getString("STATE"));
				sLoc[3] = nullStringConverter(rsDevice.getString("CITY"));
				sLoc[4] = nullStringConverter(rsDevice.getString("BUILDING_NAME"));
				sLoc[5] = nullStringConverter(rsDevice.getString("FLOOR_NAME"));
			} //while results
			
		} catch (SQLException e){
			System.out.println("PrinterTools.getDeviceLocation ERROR: " + e);
		} finally {
	  		try {
	  			if (rsDevice != null) rsDevice.close();
	  			if (psDevice != null) psDevice.close();
	  			if (con != null) con.close();
	  		} catch (Exception e){
		  		System.out.println("PrinterTools.getDeviceLocation ERROR2: " + e);
	  		}
		} //finally
		
   	    return sLoc;
   } //end of getServerName
    
    /**********************************************************************************************
     * checkOSInstallConfig									
     * 													
     * This method returns the location fields of a device
     ***********************************************************************************************/
     public boolean checkOSInstallConfig(String sDevice, String sOS) throws IOException, ServletException, SQLException {

    	Connection con = null;
     	boolean osInstallConfigExist = false;
     	boolean prtDefType = false;
     	boolean driverSet = false;
     	String sProtocol = "";
     	
     	if (sDevice != null && sDevice != "") {
     		sDevice = sDevice.toUpperCase();
     	}
 		   
 		PreparedStatement psPDefType = null;
 		ResultSet rsPDefType = null;
 		
 		String sQuery = "Select protocol_name from gpws.printer_def_type_config_view where os_name = '" + sOS + "' and printer_def_typeid = (Select printer_def_typeid from gpws.device where UPPER(device_name) = '" + sDevice + "')";

 		try {
 			con = getConnection();
 			
 			try {
	 			psPDefType = con.prepareStatement(sQuery);
	 			rsPDefType = psPDefType.executeQuery();
	 			while (rsPDefType.next()) {
	 				sProtocol = rsPDefType.getString("protocol_name");
	 				prtDefType = true;
	 			} //while results
	 			
	 		} catch (SQLException e){
	 			System.out.println("PrinterTools.checkOSInstallConfig ERROR: " + e);
	 		} finally {
	 	  		try {
	 	  			if (rsPDefType != null) rsPDefType.close();
	 	  			if (psPDefType != null) psPDefType.close();
	 	  		} catch (Exception e){
	 		  		System.out.println("PrinterTools.checkOSInstallConfig ERROR2: " + e);
	 	  		}
	 		} //finally
 		
	 		if (sProtocol.equals("DIPP") || sProtocol.equals("IBMDIPP") || sProtocol.equals("IPM") || sProtocol.equals("TCPIP")) {
		 		PreparedStatement psDrvSet = null;
		 		ResultSet rsDrvSet = null;
		 		
		 		String sQuery2 = "Select driver_set_name from gpws.driver_set_config_view where os_name = '" + sOS + "' and driver_setid = (Select driver_setid from gpws.device where UPPER(device_name) = '" + sDevice + "')";
		 		  
		 		try {
		 			psDrvSet = con.prepareStatement(sQuery2);
		 			rsDrvSet = psDrvSet.executeQuery();
		 			while (rsDrvSet.next()) {
		 				driverSet = true;
		 			} //while results
		 			
		 		} catch (SQLException e){
		 			System.out.println("PrinterTools.checkOSInstallConfig ERROR: " + e);
		 		} finally {
		 	  		try {
		 	  			if (rsDrvSet != null) rsDrvSet.close();
		 	  			if (psDrvSet != null) psDrvSet.close();
		 	  			con.close();
		 	  		} catch (Exception e){
		 		  		System.out.println("PrinterTools.checkOSInstallConfig ERROR2: " + e);
		 	  		}
		 		} //finally
	 		} else {
	 			driverSet = true;
	 		}
	 		
	 		if (driverSet == true && prtDefType == true) {
	 			osInstallConfigExist = true;
	 		} else {
	 			osInstallConfigExist = false;
	 		}
	 	
 		} catch (Exception e) {
 			System.out.println("Error getting connection in PrinterTools.checkOSInstallConfig ERROR: " + e);
 		} finally {
 			if (con != null);
 				con.close();
 		}
 		
    	return osInstallConfigExist;
    } //end of getServerName
     
     /**********************************************************************************************
      * getNumFTPPrinters									
      * 													
      * This method returns the number of printers for a given ftp server
      ***********************************************************************************************/
      public int getNumFTPPrinters(int ftpID) throws IOException, ServletException {

      	int numDevices = 0;

      	Connection con = null;
  		PreparedStatement ps = null;
  		ResultSet rs = null;
  		
  		String sQuery = "Select count(*) as count from gpws.device where ftpid = " + ftpID;

  		try {
  			con = getConnection();
  			ps = con.prepareStatement(sQuery);
  			rs = ps.executeQuery();
  			while (rs.next()) {
  				numDevices = rs.getInt("COUNT");
  			} //while results
  			
  		} catch (SQLException e){
  			System.out.println("PrinterTools.getNumFTPPrinters ERROR: " + e);
  		} finally {
  	  		try {
  	  			if (rs != null) rs.close();
  	  			if (ps != null) ps.close();
  	  			if (con != null) con.close();
  	  		} catch (Exception e){
  		  		System.out.println("PrinterTools.getNumFTPPrinters ERROR2: " + e);
  	  		}
  		} //finally
  		 		
     	return numDevices;
     	
     } //end of getNumFTPPrinters
      
      /**********************************************************************************************
       * getOSInfo									
       * 													
       * This method returns information regarding a specific OS
       ***********************************************************************************************/
       public String[] getOSInfo(int osID) throws IOException, ServletException {

       	String[] osInfo = new String[3];

       	Connection con = null;
   		PreparedStatement ps = null;
   		ResultSet rs = null;
   		
   		String sQuery = "Select os_name, os_abbr, comment from gpws.os where osid = " + osID;

   		try {
   			con = getConnection();
   			ps = con.prepareStatement(sQuery);
   			rs = ps.executeQuery();
   			while (rs.next()) {
   				osInfo[0] = rs.getString("OS_NAME");
   				osInfo[1] = rs.getString("OS_ABBR");
   				osInfo[2] = rs.getString("COMMENT");
   			} //while results
   			
   		} catch (SQLException e){
   			System.out.println("PrinterTools.getOSInfo ERROR: " + e);
   		} finally {
   	  		try {
   	  			if (rs != null) rs.close();
   	  			if (ps != null) ps.close();
   	  			if (con != null) con.close();
   	  		} catch (Exception e){
   		  		System.out.println("PrinterTools.getOSInfo ERROR2: " + e);
   	  		}
   		} //finally
   		 		
      	return osInfo;
      	
      } //end of getOSInfo
       
       /**********************************************************************************************
        * getDriverInfo									
        * 													
        * This method returns information regarding a specific driver
        ***********************************************************************************************/
        public String[] getDriverInfo(int driverID) throws IOException, ServletException {

        	String[] drvInfo = new String[3];

        	Connection con = null;
    		PreparedStatement ps = null;
    		ResultSet rs = null;
    		
    		String sQuery = "Select driver_name, driver_model from gpws.driver where driverid = " + driverID;

    		try {
    			con = getConnection();
    			ps = con.prepareStatement(sQuery);
    			rs = ps.executeQuery();
    			while (rs.next()) {
    				drvInfo[0] = rs.getString("driver_name");
    				drvInfo[1] = rs.getString("driver_model");
    			} //while results
    			
    		} catch (SQLException e){
    			System.out.println("PrinterTools.getDriverInfo ERROR: " + e);
    		} finally {
    	  		try {
    	  			if (rs != null) rs.close();
    	  			if (ps != null) ps.close();
    	  			if (con != null) con.close();
    	  		} catch (Exception e){
    		  		System.out.println("PrinterTools.getDriverInfo ERROR2: " + e);
    	  		}
    		} //finally
    		 		
       	return drvInfo;
       	
       } //end of getDriverInfo
      
      /**********************************************************************************************
      * stripLeadingZeros									
      * 													
      * This method strips off 1 and/or 2 leading zeros on a string.
      ***********************************************************************************************/
      public String stripLeadingZeros(String textWord) throws Exception {
  		
      	String sNewTextWord = "";

   		try {
   			
   			if (textWord != null && !textWord.equals("") && textWord.length() > 0) {
   				if (textWord.length() == 2) {
   					if (textWord.charAt(0) == '0') {
   						sNewTextWord = textWord.substring(1,2);
   					} else {
   						sNewTextWord = textWord;
   					}
   				} else if (textWord.length() >= 3) {
   					if (textWord.charAt(0) == '0') {
   						if (textWord.charAt(1) == '0') {
   							sNewTextWord = textWord.substring(2,textWord.length());
   						} else {
   							sNewTextWord = textWord.substring(1,textWord.length());
   						}
   					} else {
   						sNewTextWord = textWord;
   					}
   				} else {
   					sNewTextWord = textWord;
   				}
   			} 
   			
   		} catch (Exception e){
   			System.out.println("PrinterTools.stripLeadingZeros ERROR: " + e);
   		}
   		 		
      	return sNewTextWord;
      	
      } //end of stripLeadingZeros

} // main class