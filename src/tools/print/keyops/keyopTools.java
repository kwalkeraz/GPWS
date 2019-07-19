/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.keyops;

import java.io.IOException;
import javax.servlet.ServletException;

import java.net.*;
import java.io.*;
import java.util.*;
import java.sql.*;

import javax.mail.*;
import javax.mail.internet.*;
import javax.naming.*;
import swat.*;
import tools.print.lib.*;

/****************************************************************************************
 * KeyopTools																			*
 * 																						*
 * @author: Joe Comfort																	*
 * Copyright IBM																		*
 * 																						*
 * This class contains many useful methods that are used often throughout all of the	*
 * other servlets.  It's a means of writing code once and creating an instance of this	*
 * class whenever use of one of these common methods is needed.							*
 ****************************************************************************************/
public class keyopTools {
	
	private static ResourceBundle myResources = ResourceBundle.getBundle("tools.print.keyops.defaultKeyopTools");
	
	/**********************************************************************************************
    * getServerName																				  *
    * 																							  *
    * This method returns the name of the server												  *
    ***********************************************************************************************/
   public String getServerName()
   	throws IOException  {
   	 
		// Reads property file and gets the value of servername
		String sServerName = myResources.getString("serverName");
		
   	    return sServerName;
   }
   
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
	 	System.out.println("keyopTools.getConnection ERROR: " + e);
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
	 	System.out.println("keyopTools.getConnection ERROR: " + e);
     }
		return con;
   }
   
   /**********************************************************************************************
    * getWebAddress																				 *
    * 																							 *
    * This method returns the web address of the keyop website. i.e. the context root            *
    **********************************************************************************************/
   public String getWebAddress()
   		throws IOException  {
   	  	
		// Reads property file value for webaddress
		String sWebAddress = myResources.getString("webAddress");
 
        return sWebAddress;
   }
      
   /**********************************************************************************************
    * getNumKeyops																				 *
    * 																							 *
    * This method returns the maximum number of keyops.								             *
    **********************************************************************************************/
	public int getNumKeyops()
		throws IOException  {
	  	
		int iNumKeyops = Integer.parseInt(myResources.getString("maxNumKeyops"));
 	
		return iNumKeyops;
   }
   
   /**********************************************************************************************
    * getNumMonths																				 *
    * 																							 *
    * This method returns the maximum number of months of archived tickets.								             *
    **********************************************************************************************/
	public int getNumMonths()
		throws IOException  {
	 
		int iNumMonths = Integer.parseInt(myResources.getString("maxNumMonths"));
 	
		return iNumMonths;
   }
   
   /**********************************************************************************************
    * getEncryptPass																			 *
    * 																							 *
    * This method returns the db2 encryption password								             *
    **********************************************************************************************/
	public String getEncryptPass()
		throws IOException  {
	 
		AppTools appTool = new AppTools();
		//String sEncryptPass = myResources.getString("encryptPass");
		String sEncryptPass = appTool.getEncryptPW();
 	
		return sEncryptPass;
   }
   
   /**********************************************************************************************
    * getServletPathCR																			 *
    * 																							 *
    * This method returns the path of the servlets and includes the context root.	             *
    **********************************************************************************************/
	public String getServletPathCR()
		throws IOException  {
	 
		String sServletPathCR = myResources.getString("servletPathCR");
 	
		return sServletPathCR;
   }
   
   /**********************************************************************************************
    * getKeyopServletPath																		 *
    * 																							 *
    * This method returns the path of the main keyop servlet and includes context root		     *
    **********************************************************************************************/
	public String getKeyopServletPathCR()
		throws IOException  {
	 
		String sKeyopServletPathCR = myResources.getString("keyopServletPathCR");
 	
		return sKeyopServletPathCR;
   }
   
   /**********************************************************************************************
    * getServletPath																			 *
    * 																							 *
    * This method returns the path of the servlets									             *
    **********************************************************************************************/
	public String getServletPath()
		throws IOException  {
	 
		String sServletPath = myResources.getString("servletPath");
 	
		return sServletPath;
   }
   
   /**********************************************************************************************
    * getKeyopServletPath																		 *
    * 																							 *
    * This method returns the path of the main keyop servlet								     *
    **********************************************************************************************/
	public String getKeyopServletPath()
		throws IOException  {
	 
		String sKeyopServletPath = myResources.getString("keyopServletPath");
 	
		return sKeyopServletPath;
   }
   
   /**********************************************************************************************
    * getJspPathCR																				 *
    * 																							 *
    * This method returns the path of the main keyop servlet								     *
    **********************************************************************************************/
	public String getJspPathCR()
		throws IOException  {
	 
		String sjspPathCR = myResources.getString("jspPathCR");
 	
		return sjspPathCR;
   }
  
    
   /********************************************************************************************
    * getName										       										
    *											       											
    * This method takes a string, which is the name of a person from bluepages, and switches    
    * their first name and their last name. It returns the new string. It will take into account
    * contractors, vendors, and people with additional names to be called.
    ********************************************************************************************/	
    public String getName( String name ) {
 
        String sName = name;
        if (name != null && !name.equals("")) {
	        String sFirstName = "";
	        String sLastName = "";
	        int iLength;
	        int iComma = -1;
	        int iAsterisk = 0;
	        int iIndexAsterisk1 = -1;
	        int iIndexAsterisk2 = -1;
	        int iIndexParen1 = -1;
	        int iIndexParen2 = -1;
			for(int j = 0; j < name.length(); j++) {
				if (name.substring(j, j + 1).equals(",")) {
					iComma = j;
				}
			}
	 		if (!name.equals("not found") && iComma != -1) {
	        	iLength = name.length();
	 
				sLastName = name.substring( 0, iComma );
	        	sFirstName = name.substring( iComma + 1, iLength);
	        	for (int i=0; i < sFirstName.length(); i++) {
	        		if (sFirstName.substring(i, i + 1).equals("*")) {
	        			if (iAsterisk == 0) {
	        				iIndexAsterisk1 = i;
	        				iAsterisk = 1;
	        			} else {
	        				iIndexAsterisk2 = i;
	        			}
	        		} else if (sFirstName.substring(i, i + 1).equals("(")){
	        			iIndexParen1 = i;
	        		} else if (sFirstName.substring(i, i + 1).equals(")")){
						iIndexParen2 = i;
	        		}
	        	}
	        	
				if (iIndexParen1 != -1 && iIndexParen2 != -1){
	        		sFirstName = sFirstName.substring(iIndexParen1 + 1, iIndexParen2);
	        	} else if (iIndexAsterisk1 != -1 && iIndexAsterisk2 != -1) {
					sFirstName = sFirstName.substring(0, iIndexAsterisk1 - 1);
				}
	        	sName = sFirstName + " " + sLastName;
	        	
	 		}
        } else {
        	sName = "";
        }
        return sName;

    } // method getName
    
    /********************************************************************************************
     * getFirstName										       										
     *											       											
     * This method takes a string, which is the name of a person from bluepages, and switches    
     * their first name and their last name. It returns the new string. It will take into account
     * contractors, vendors, and people with additional names to be called.
     ********************************************************************************************/	
     public String getFirstName( String name ) {
  
         String sFirstName = "";
         int iLength;
         int iComma = -1;
         int iAsterisk = 0;
         int iIndexAsterisk1 = -1;
         int iIndexAsterisk2 = -1;
         int iIndexParen1 = -1;
         int iIndexParen2 = -1;
 		for(int j = 0; j < name.length(); j++) {
 			if (name.substring(j, j + 1).equals(",")) {
 				iComma = j;
 			}
 		}
  		if (!name.equals("not found") && iComma != -1) {
         	iLength = name.length();
  
         	sFirstName = name.substring( iComma + 2, iLength);
         	for (int i=0; i < sFirstName.length(); i++) {
         		if (sFirstName.substring(i, i + 1).equals("*")) {
         			if (iAsterisk == 0) {
         				iIndexAsterisk1 = i;
         				iAsterisk = 1;
         			} else {
         				iIndexAsterisk2 = i;
         			}
         		} else if (sFirstName.substring(i, i + 1).equals("(")){
         			iIndexParen1 = i;
         		} else if (sFirstName.substring(i, i + 1).equals(")")){
 					iIndexParen2 = i;
         		}
         	}

 			if (iIndexParen1 != -1 && iIndexParen2 != -1){
         		sFirstName = sFirstName.substring(iIndexParen1 + 1, iIndexParen2);
         	} else if (iIndexAsterisk1 != -1 && iIndexAsterisk2 != -1) {
 				sFirstName = sFirstName.substring(0, iIndexAsterisk1 - 1);
 			}
         	
  		}
  		sFirstName.trim();
  
         return sFirstName;

     } // method getFirstName
     
     /********************************************************************************************
      * getName										       										
      *											       											
      * This method takes a string, which is the name of a person from bluepages, and switches    
      * their first name and their last name. It returns the new string. It will take into account
      * contractors, vendors, and people with additional names to be called.
      ********************************************************************************************/	
      public String getLastName( String name ) {
   
      	  String sLastName = "";
          int iComma = -1;
          
	  	  for(int j = 0; j < name.length(); j++) {
	  	  	if (name.substring(j, j + 1).equals(",")) {
	  	  		iComma = j;
	  		}
	  	  }
	  	  
	  	  if (!name.equals("not found") && iComma != -1) {   
	  	  	sLastName = name.substring( 0, iComma );          	
	  	  }
	  	  sLastName.trim();
   
          return sLastName;

      } // method getLastName
    
	/********************************************************************************************
	* cleanName										       										
	*											       											
	* This method takes a string, which is the name of a person from bluepages, and removes    
	* contractor and vendor from their name.
	********************************************************************************************/	
	public String cleanName( String name ) {
 
		String sName = name;
		int iLength;
		int iAsterisk = 0;
		int iIndexAsterisk1 = -1;
		int iIndexAsterisk2 = -1;
		
		if (!name.equals("not found")) {
			iLength = name.length();
			sName = name.substring(0, iLength);
			for (int i=0; i < sName.length(); i++) {
				if (sName.substring(i, i + 1).equals("*")) {
					if (iAsterisk == 0) {
						iIndexAsterisk1 = i;
						iAsterisk = 1;
					} else {
						iIndexAsterisk2 = i;
					}
				}
			}
       	
			if (iIndexAsterisk1 != -1 && iIndexAsterisk2 != -1) {
				sName = sName.substring(0, iIndexAsterisk1 - 1);
			}
		}
		return sName;
	} // method cleanName
    
    
    /********************************************************************************************
    * returnInfo									       										*
    *											       											*
    * This method takes 3 strings, one is a persons Serial + CC, the second is a flag, and the  *
    * third is a company.  The possible flags are: name, tieline, and email. The possible		*
    * companies are ibm, hitachi, or other.  Based on which of those are passed, their info will*
    * be returned, from bluepages, redpages or another source.									*
    ********************************************************************************************/	
    public String returnInfo( String sCnum, String sFlag, String sUserType )
    	throws IOException {
    	
		String sInfoLookupType = "local";
		String sEmpName = "not found";
		String sTieLine = "not found";
		String sEmail = "not found";
		String sUserID = "not found";
		Connection con = null;
		Statement stmtInfo = null;
		ResultSet rsInfo = null;
		Statement stmtInfo2 = null;
		ResultSet rsInfo2 = null;
	  try {
		con = getConnection();
		
		if (sInfoLookupType.equals("blue") || sInfoLookupType.equals("red") ){
			
			UserInfoCC bpLookup = new UserInfoCC(sCnum);
			sEmpName = bpLookup.employeeName().trim();
			sTieLine = bpLookup.empTie().trim();
			sEmail = bpLookup.emailAddress().trim();
			sUserID = bpLookup.USERID().toLowerCase();

			
		} else if (sInfoLookupType.equals("local")) {
			rsInfo = null;
			stmtInfo = con.createStatement();
			if (sUserType.equals("keyop")) {
				rsInfo = stmtInfo.executeQuery("SELECT * from keyop where serialno = '" + sCnum + "'");
			} else if (sUserType.equals("admin")) {
				rsInfo = stmtInfo.executeQuery("SELECT * from admin where serialno = '" + sCnum + "'");
			} else if (sUserType.equals("user")) {
				rsInfo = stmtInfo.executeQuery("SELECT * from requests where requestedby = '" + sCnum + "'");
			} else {
				return "Fatal Error";
			}
			
			while (rsInfo.next()) {
				sEmpName = rsInfo.getString("name");
				sEmail = rsInfo.getString("email");
				if (sUserType.equals("user")) {
					sTieLine = rsInfo.getString("tieline");
				}
			}
		} else if (sInfoLookupType.equals("other")) {
			
			sEmpName = ("Not Available");
			sTieLine = ("Not Available");
			sEmail = ("Not Available");
			sUserID = ("Not Available");
			
		} else {
			
			sEmpName = ("ERROR");
			sTieLine = ("ERROR");
			sEmail = ("ERROR");
			sUserID = ("ERROR");
		}
		
		
		if (sEmpName.equals("not found") || sTieLine.equals("not found") || sEmail.equals("not found") || sUserID.equals("not found") ) {
			stmtInfo2 = con.createStatement();
			rsInfo2 = null;
			if (sUserType.equals("user")) {
				rsInfo2 = stmtInfo2.executeQuery("SELECT * from requests where requestedby = '" + sCnum + "'");
			} else if (sUserType.equals("keyop")) {
				rsInfo2 = stmtInfo2.executeQuery("SELCET * from keyop where serialno = '" + sCnum + "'");
			} else if (sUserType.equals("admin")) {
				rsInfo2 = stmtInfo2.executeQuery("SELCET * from admin where serialno = '" + sCnum + "'");
			}
			
			while (rsInfo2.next()) {
				if (sEmpName.equals("not found")) {
					sEmpName = rsInfo2.getString("Name");
				}
				
				if (sEmail.equals("not found")) {
					sEmail = rsInfo2.getString("Email");
				}
				
				if (sUserType.equals("user")) {
					if (sTieLine.equals("not found")) {
						sTieLine = rsInfo2.getString("TieLine");
					}
				} else {
					if (sUserID.equals("not found")) {
						sUserID = rsInfo2.getString("UserID");
					}
				}
			}
		}
	  } catch(Exception e) {
	  	System.out.println("keyopTools.returnInfo ERROR: " + e);
	  		try {
	   			logError("keyopTools.returnInfo","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.returnInfo.1 ERROR logging error: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsInfo != null)
	  				rsInfo.close();
	  			if (rsInfo2 != null)	
	  				rsInfo2.close();
	  			if (stmtInfo != null)	
	  				stmtInfo.close();
		  		if (stmtInfo2 != null)	
		  			stmtInfo2.close();
		  		if (con != null)	
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.returnInfo.2 ERROR closing DB stuff: " + e);
	  		}
	  }
				
		if (sFlag.equals("name")) {
			return sEmpName;
		} else if (sFlag.equals("tieline")) {
			return sTieLine;
		} else if (sFlag.equals("email")) {
			return sEmail;
		} else if (sFlag.equals("userid")) {
			return sUserID;
		} else {
			return "An error has occurred";
		}
	  
    }
    
    /********************************************************************************************
    * returnInfo										       									*
    *											       											*
    * This method takes 2 strings, one is a persons email address and the other is a flag.  The *
    * possible flags are: name, tieline, and email.  Based on which of those are passed,		*
    * their bluepages info for that will be returned.											*
    ********************************************************************************************/	
    public String returnInfo( String sSerial, String sFlag )
    	throws IOException {
    	
    	String sReturnValue = "not found";

    	if (sSerial != null) {
	        UserInfoCC bpLookup = new UserInfoCC(sSerial);
		
			if (sFlag.equals("name")) {
				sReturnValue = bpLookup.employeeName();
			} else if (sFlag.equals("tieline")) {
				sReturnValue = bpLookup.empTie();
			} else if (sFlag.equals("email")) {
				sReturnValue = bpLookup.emailAddress();
			} else if (sFlag.equals("extphone")) {
				sReturnValue = bpLookup.empXphone();
			} else {
				sReturnValue = "Invalid parameter";
			}
    	}
    	
    	return sReturnValue;
    }
    
    /********************************************************************************************
    * returnInfo2										       									*
    *											       											*
    * This method takes 2 strings, one is a persons email address and the other is a flag.  The *
    * possible flags are: name, tieline, and email.  Based on which of those are passed,		*
    * their bluepages info for that will be returned.											*
    ********************************************************************************************/	
    public String returnInfo2( String sEmail, String sFlag )
    	throws IOException {
    	
		UserInfo user = new UserInfo(sEmail);
		String sEmpName = user.employeeName();
		String sTieLine = user.empTie();
		String sCnum = user.empSerialCC();
		
		if (sFlag.equals("name")) {
			return sEmpName;
		} else if (sFlag.equals("tieline")) {
			return sTieLine;
		} else if (sFlag.equals("cnum")) {
			return sCnum;
		} else {
			return "An error has occurred";
		}
    }
    
    /********************************************************************************************
     * returnInfo										       									*
     *											       											*
     * This method takes 2 strings, one is a persons email address and the other is a flag.  The *
     * possible flags are: name, tieline, and email.  Based on which of those are passed,		*
     * their bluepages info for that will be returned.											*
     ********************************************************************************************/	
     public String returnInfo( int iUserid, String sFlag ) throws Exception {
     	
     	String sReturnValue = "not found";
     	Connection con = null;
     	Statement stmtUser = null;
     	ResultSet rsUser = null;
     	String sFirstName = "";
     	String sLastName = "";
     	String sEmail = "";
     	String sPager = "";
     	String sExtphone = "";
     	String sTieline = "";
     	
     	try {
     		con = getConnection();
     		stmtUser = con.createStatement();
     		rsUser = stmtUser.executeQuery("SELECT * FROM GPWS.USER WHERE USERID = " + iUserid);
     		
     		while (rsUser.next()) {
     			sLastName = rsUser.getString("LAST_NAME");
     			sFirstName = rsUser.getString("FIRST_NAME");
     			//sExtphone = rsUser.getString("EXT_PHONE");
     			//sTieline = rsUser.getString("TIELINE");
     			sPager = rsUser.getString("PAGER");
     			sEmail = rsUser.getString("EMAIL");
     		}
     		
     	} catch (Exception e) {
     		try {
	   			logError("keyopTools.returnInfo","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.returnInfo ERROR: " + ex);
	   		}
     	} finally {
     		if (rsUser != null)
     			rsUser.close();
     		if (stmtUser != null)
     			stmtUser.close();
     		if (con != null)
     			con.close();
     	}
 		
		if (sFlag.equals("name")) {
			sReturnValue = sLastName + ", " + sFirstName;
		} else if (sFlag.equals("fname")) {
			sReturnValue = sFirstName;
		} else if (sFlag.equals("lname")) {
			sReturnValue = sLastName;
		} else if (sFlag.equals("tieline")) {
			sReturnValue = sTieline;
		} else if (sFlag.equals("email")) {
			sReturnValue = sEmail;
		} else if (sFlag.equals("extphone")) {
			sReturnValue = sExtphone;
		} else if (sFlag.equals("pager")) {
			sReturnValue = sPager;
		} else {
			sReturnValue = "Invalid parameter";
		}
     	
     	return sReturnValue;
     }
    
    
    /********************************************************************************************
    * getTimestamp										       									*
    *											       											*
    * This method takes a string, which is the degree to which you want the timestamp. If you   *
    * pass it "year", it will return the year. If you pass it "month" it will return the year   *
    * and the month. If you pass it "day", it will return the year, month, and day. Valid 		*
    * parameters are "year", "month", "day", "hour", "minute", "millisecond".					*
    ********************************************************************************************/	
    public String getTimestamp( String sReturnType ) {
    	
        Calendar calendar = new GregorianCalendar();
		int iYear = calendar.get(Calendar.YEAR);
		int iMonth = (calendar.get(Calendar.MONTH) + 1);
		int iDay = calendar.get(Calendar.DAY_OF_MONTH);
		int iHour = calendar.get(Calendar.HOUR_OF_DAY);
		int iMinute = calendar.get(Calendar.MINUTE);
		int iSecond = calendar.get(Calendar.SECOND);
		int iMillisecond = calendar.get(Calendar.MILLISECOND);
		String sMonth, sDay, sHour, sMinute, sSecond, sMillisecond;
		
		
		String sYear = "" + iYear;
		if (iMonth < 10) {
			sMonth = "0" + iMonth;
		} else {
			sMonth = "" + iMonth;
		}
		if (iDay < 10) {
			sDay = "0" + iDay;
		} else {
			sDay = "" + iDay;
		}
		if (iHour < 10) {
			sHour = "0" + iHour;
		} else {
			sHour = "" + iHour;
		}
		if (iMinute < 10) {
			sMinute = "0" + iMinute;
		} else {
			sMinute = "" + iMinute;
		}
		if (iSecond < 10) {
			sSecond = "0" + iSecond;
		} else {
			sSecond = "" + iSecond;
		}
		if (iMillisecond < 10) {
			sMillisecond = "0" + iMillisecond;
		} else {
			sMillisecond = "" + iMillisecond;
		}
		
		if (sReturnType.equals("year")) {
			return sYear;
		} else if (sReturnType.equals("month")) {
			return (sYear + sMonth);
    	} else if (sReturnType.equals("day")) {
    		return (sYear + sMonth + sDay);
		} else if (sReturnType.equals("hour")) {
			return (sYear + sMonth + sDay + sHour);
		} else if (sReturnType.equals("minute")) {
			return (sYear + sMonth + sDay + sHour + sMinute);
		} else if (sReturnType.equals("second")) {
			return (sYear + sMonth + sDay + sHour + sMinute + sSecond);
		} else {
			return (sYear + sMonth + sDay + sHour + sMinute + sSecond + sMillisecond);
		}
    }
    
    /********************************************************************************************
     * isUser										       										*
     *											       											*
     * This method takes a string, the users email, and returns a boolean value of whether or	*
     * not the logged on user is an administrator or not based on whether or not the person		*
     * exists in the admin table of the database.												*
     ********************************************************************************************/	
     public boolean isUser( String sLoginid ) {
     	
     	boolean isUser = false;
     	Connection con = null;
     	Statement stmtUser = null;
     	ResultSet rsUser = null;
       try {
     	
     	con = getConnection();
     	stmtUser = con.createStatement();
     	rsUser = stmtUser.executeQuery("SELECT * FROM GPWS.USER WHERE LOGINID = '" + sLoginid + "'");
 		
 		while (rsUser.next()) {
 			isUser = true;
 		}
 		
 	  } catch (Exception e) {
 	  	System.out.println("keyopTools.isUser ERROR: " + e);
 	  	try {
 	   			logError("keyopTools.isUser","Keyop", e);
 	   		} catch (Exception ex) {
 	   			System.out.println("Keyop Error in keyopTools.isUser ERROR: " + ex);
 	   		}
       } finally {
 	  		try {
 	  			if (rsUser != null)
 	  				rsUser.close();
 		  		if (stmtUser != null)
 		  			stmtUser.close();
 		  		if (con != null)
 		  			con.close();
 	  		} catch (Exception e){
 		  		System.out.println("Keyop Error in keyopTools.isUser.2 ERROR: " + e);
 	  		}
 	  }
 		return isUser;
     }
     
    /********************************************************************************************
    * isAdmin										       										*
    *											       											*
    * This method takes a string, the users email, and returns a boolean value of whether or	*
    * not the logged on user is an administrator or not based on whether or not the person		*
    * exists in the admin table of the database.												*
    ********************************************************************************************/	
    public boolean isAdmin( String sEmail ) {
    	
    	boolean isAdmin = false;
    	Connection con = null;
    	Statement stmtAdmin = null;
    	ResultSet rsAdmin = null;
      try {
    	
    	con = getConnection();
    	stmtAdmin = con.createStatement();
		rsAdmin = stmtAdmin.executeQuery("SELECT * FROM GPWS.USER_VIEW WHERE LOGINID = '" + sEmail + "' AND (AUTH_NAME = 'Keyop Admin' OR AUTH_NAME = 'Keyop Superuser')");
		
		while (rsAdmin.next()) {
			isAdmin = true;
		}
		
	  } catch (Exception e) {
	  	System.out.println("keyopTools.isAdmin ERROR: " + e);
	  	try {
	   			logError("keyopTools.isAdmin","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.isAdmin ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsAdmin != null)
	  				rsAdmin.close();
		  		if (stmtAdmin != null)
		  			stmtAdmin.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.isAdmin.2 ERROR: " + e);
	  		}
	  }
		return isAdmin;
    }
    
    /********************************************************************************************
    * isKeyop										       										*
    *											       											*
    * This method takes a string, the users email, and returns a boolean value of whether or	*
    * not the logged on user is a keyop or not based on whether or not the person exists in the *
    * keyop table of the database.																*
    ********************************************************************************************/	
    public boolean isKeyop( String sEmail ) {
    	   
    	boolean isKeyop = false;	
    	Connection con = null;
    	Statement stmtKeyop = null;
    	ResultSet rsKeyop = null;
      try {
    	con = getConnection();
    	stmtKeyop = con.createStatement();
		rsKeyop = stmtKeyop.executeQuery("SELECT * FROM GPWS.USER_VIEW WHERE LOGINID = '" + sEmail + "' AND AUTH_NAME = 'Keyop'");
		
		while (rsKeyop.next()) {
			isKeyop = true;
		}
		
      } catch (Exception e) {
      	System.out.println("keyopTools.isKeyop ERROR: " + e);
      	try {
	   			logError("keyopTools.isKeyop","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.isKeyop ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsKeyop != null)
	  				rsKeyop.close();
	  			if (stmtKeyop != null)
		  			stmtKeyop.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.isKeyop.2 ERROR: " + e);
	  		}
	  }
      
	    return isKeyop;
    }
        
	/********************************************************************************************
	* sendMail										       										*
	*											       											*
	* This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
	* It will send an email with the information provided to it.								*
	********************************************************************************************/
	public boolean sendMail(String sTo, String sSubject, String sMessage, String sFromInternetAddress, String sFromName)
	throws IOException {
		
		boolean result = true;
		Connection con = null;
		Statement stmtKeyopMisc = null;
		ResultSet rsKeyopMisc = null;
					
		String sMessageToSend = ("********************************************************\n* THIS EMAIL WAS GENERATED BY A SERVICE REQUEST MACHINE *\n* PLEASE DO NOT REPLY TO THIS EMAIL                     *\n********************************************************\n\n");
		sMessageToSend = (sMessageToSend + sMessage);
		String sSmtpHost = myResources.getString("smtphost");
					
		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		
		try {
		     		
			message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
			message.addRecipient(Message.RecipientType.TO, 
			new InternetAddress(sTo));
			message.setSubject(sSubject);
			message.setText(sMessageToSend);
    		
			Transport.send(message);

		} catch (Exception mex) {
			result = false;
			System.out.println("Keyop Error in keyopTools.sendMail.1 ERROR: " + mex);
			try {
				logError("keyopTools.sendMail","Keyop", mex);
			} catch (Exception ex) {
				System.out.println("Keyop Error in keyopTools.sendMail.2 ERROR: " + ex);
			}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
		
			try {
		     		
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				message.addRecipient(Message.RecipientType.TO, 
				new InternetAddress(sTo));
				message.setSubject(sSubject);
				message.setText(sMessageToSend);
    			Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop Error in keyopTools.sendMail.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendMail","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendMail.4 ERROR: " + ex);
				}
			}
		}
		
		return result;
	}
    
    /********************************************************************************************
    * sendMail										       										*
    *											       											*
    * This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
    * It will send an email with the information provided to it.								*
    ********************************************************************************************/
    public boolean sendMail(String sTo, String sSubject, String sMessage)
	throws IOException {
		
		boolean result = true;
		String sFromInternetAddress = myResources.getString("fromInternetAddress");
		String sFromName = myResources.getString("fromName"); 
		String sSmtpHost = myResources.getString("smtphost");
		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		String aTo[] = new String[10];
		String sMessageToSend = ("********************************************************\n* THIS EMAIL WAS GENERATED BY A SERVICE REQUEST MACHINE *\n* PLEASE DO NOT REPLY TO THIS EMAIL                     *\n********************************************************\n\n");
		sMessageToSend = (sMessageToSend + sMessage);
		int j = 0;		
		try {
			
			int curr = 0;
			int last = 0;
			j = 0;
			for (int i = 0; i < sTo.length(); i++) {
				if(sTo.charAt(i) == (';')) {
					aTo[j] = sTo.substring(last,curr);
						j++;
					last = curr + 1;
					curr++;
				} else if (i == (sTo.length()-1)) {
					aTo[j] = sTo.substring(last,sTo.length());
					j++;
				} else {
					curr++;
				}
			}
			if (j==0) {
				aTo[j] = sTo;
			}
			InternetAddress[] aToArray = new InternetAddress[j];
			for (int x = 0; x < j; x++) {
				aToArray[x] = new InternetAddress(aTo[x]);
			}
						
    		message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
			message.setRecipients(Message.RecipientType.TO, aToArray);
    		message.setSubject(sSubject);
    		message.setText(sMessageToSend);
    		
    		Transport.send(message);

		} catch (Exception mex) {
	    	result = false;
	    	System.out.println("Keyop Error in keyopTools.sendMail.1 ERROR: " + mex);
	    	try {
	   			logError("keyopTools.sendMail.1","Keyop", mex);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.sendMail.2 ERROR: " + ex);
	   		}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
			InternetAddress[] aToArray = new InternetAddress[j];
			
			try {
				for (int x = 0; x < j; x++) {
					aToArray[x] = new InternetAddress(aTo[x]);
				}
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				message.setRecipients(Message.RecipientType.TO, aToArray);
				message.setSubject(sSubject);
				message.setText(sMessageToSend);
				Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop Error in keyopTools.sendMail.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendMail.2","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendMail.4 ERROR: " + ex);
				}
			}
		}
		return result;
	}
	
	/********************************************************************************************
    * sendMail										       										*
    *											       											*
    * This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
    * It will send an email with the information provided to it.								*
    ********************************************************************************************/
    public boolean sendMail(Object[] aTo, String sSubject, String sMessage)
	throws IOException {

		boolean result = true;
		String sFromInternetAddress = myResources.getString("fromInternetAddress");
		String sFromName = myResources.getString("fromName"); 
			
		String sMessageToSend = ("********************************************************\n* THIS NOTE WAS GENERATED BY A SERVICE REQUEST MACHINE *\n* PLEASE DO NOT REPLY TO THIS NOTE                     *\n********************************************************\n\n");
		sMessageToSend = (sMessageToSend + sMessage);
	
		String sSmtpHost = myResources.getString("smtphost");
		InternetAddress[] aToArray = new InternetAddress[aTo.length];
		try {
			for (int x = 0; x < aTo.length; x++) {
				aToArray[x] = new InternetAddress((String)aTo[x]);
			}
		} catch (Exception e) {
			System.out.println("keyopTools.sendMail ERROR0: " + e);
			try {
	   			logError("keyopTools.sendMail.1","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.sendMail.1 ERROR: " + ex);
	   		}
		}
		
			Properties props = new Properties();
    		props.put("mail.smtp.host", sSmtpHost);
    		Session session = Session.getDefaultInstance(props, null);
			MimeMessage message = new MimeMessage(session);
		
		try {
		     		
    		message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
    		message.setRecipients(Message.RecipientType.TO, aToArray);
    		message.setSubject(sSubject);
    		message.setText(sMessageToSend);
    		
    		Transport.send(message);

		} catch (Exception mex) {
	    	result = false;
	    	System.out.println("Keyop Error in keyopTools.sendMail.1 ERROR: " + mex);
	    	try {
	   			logError("keyopTools.sendMail.2","Keyop", mex);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.sendMail.2 ERROR: " + ex);
	   		}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
		
			try {
		     		
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				message.setRecipients(Message.RecipientType.TO, aToArray);
				message.setSubject(sSubject);
				message.setText(sMessageToSend);
    		
				Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop Error in keyopTools.sendMail.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendMail.2","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendMail.4 ERROR: " + ex);
				}
			}
		}
		
		return result;
	}
	
	/********************************************************************************************
    * sendMail										       										*
    *											       											*
    * This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
    * It will send an email with the information provided to it.								*
    ********************************************************************************************/
    public boolean sendMail(String sTo, String sCC, String sSubject, String sMessage)
	throws IOException {

		boolean result = true;
		String sFromInternetAddress = myResources.getString("fromInternetAddress");
		String sFromName = myResources.getString("fromName"); 
		
		String sMessageToSend = ("********************************************************\n* THIS EMAIL WAS GENERATED BY A SERVICE REQUEST MACHINE *\n* PLEASE DO NOT REPLY TO THIS EMAIL                     *\n********************************************************\n\n");
		sMessageToSend = (sMessageToSend + sMessage);
	
		String sSmtpHost = myResources.getString("smtphost");
		
		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		
		try {
		     		
    		message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
    		message.addRecipient(Message.RecipientType.TO, new InternetAddress(sTo));
    		message.addRecipient(Message.RecipientType.CC, new InternetAddress(sCC));
    		message.setSubject(sSubject);
    		message.setText(sMessageToSend);
    		
    		Transport.send(message);

		} catch (Exception mex) {
	    	result = false;
	    	System.out.println("Keyop Error in keyopTools.sendMail.1 ERROR: " + mex);
	    	try {
	   			logError("keyopTools.sendMail.1","Keyop", mex);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.sendMail.2 ERROR: " + ex);
	   		}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
		
			try {
		     		
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(sTo));
				message.addRecipient(Message.RecipientType.CC, new InternetAddress(sCC));
				message.setSubject(sSubject);
				message.setText(sMessageToSend);
    		
				Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop Error in keyopTools.sendMail.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendMail.2","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendMail.4 ERROR: " + ex);
				}
			}
		}
		
		return result;
	}
	
	/********************************************************************************************
    * sendPage										       										*
    *											       											*
    * This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
    * It will send an email with the information provided to it.								*
    ********************************************************************************************/
    public boolean sendPage(String sTo, String sSubject, String sMessage)
	throws IOException {

		boolean result = true;
		String sFromInternetAddress = myResources.getString("fromInternetAddress");
		String sFromName = myResources.getString("fromName"); 
		
		String sSmtpHost = myResources.getString("smtphost");
				
		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		
		try {
		     		
    		message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
    		message.addRecipient(Message.RecipientType.TO, 
      		new InternetAddress(sTo));
    		message.setSubject(sSubject);
    		message.setText(sMessage);
    		
    		Transport.send(message);

		} catch (Exception mex) {
	    	result = false;
	    	System.out.println("Keyop Error in keyopTools.sendPage ERROR: " + mex);
	    	try {
	   			logError("keyopTools.sendPage.1","Keyop", mex);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.sendPage.2 ERROR: " + ex);
	   		}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
						
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
		
			try {
		     		
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				message.addRecipient(Message.RecipientType.TO, 
				new InternetAddress(sTo));
				message.setSubject(sSubject);
				message.setText(sMessage);
    		
				Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop error in keyopTools.sendPage.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendPage.2","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendPage.4 ERROR: " + ex);
				}
			}
		}
		
		return result;
	}
	
	/********************************************************************************************
	* sendPage										       										*
	*											       											*
	* This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
	* It will send an email with the information provided to it.								*
	********************************************************************************************/
	public boolean sendPage(String sTo, String sMessage) throws IOException {

		boolean result = true;
		String sFromInternetAddress = myResources.getString("fromInternetAddress");
		String sFromName = myResources.getString("fromName"); 
		
		String sSmtpHost = myResources.getString("smtphost");
	
		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		
		try {
		     		
			message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
			message.addRecipient(Message.RecipientType.TO, 
			new InternetAddress(sTo));
			message.setText(sMessage);
    		
			Transport.send(message);

		} catch (Exception mex) {
			result = false;
			System.out.println("Keyop Error in keyopTools.sendPage.1 ERROR: " + mex);
			try {
				logError("keyopTools.sendPage.1","Keyop", mex);
			} catch (Exception ex) {
				System.out.println("Keyop Error in keyopTools.sendPage.2 ERROR: " + ex);
			}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
			try {
		     		
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				message.addRecipient(Message.RecipientType.TO, 
				new InternetAddress(sTo));
				message.setText(sMessage);
    		
				Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop Error in keyopTools.sendPage.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendPage.2","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendPage.4 ERROR: " + ex);
				}
			}
		}
		return result;
	}
	
	/********************************************************************************************
	* sendPage										       										*
	*											       											*
	* This method takes 3 strings (subject, message, and email recipient) and a PrintWriter.	*
	* It will send an email with the information provided to it.								*
	********************************************************************************************/
	public boolean sendPage(Object[] aTo, String sMessage)
	throws IOException {

		boolean result = true;
		String sFromInternetAddress = myResources.getString("fromInternetAddress");
		String sFromName = myResources.getString("fromName"); 
		
		String sSmtpHost = myResources.getString("smtphost");
				
		Properties props = new Properties();
		props.put("mail.smtp.host", sSmtpHost);
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage message = new MimeMessage(session);
		
		try {
		     		
			message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
			InternetAddress[] aToArray = new InternetAddress[aTo.length];
			for (int x = 0; x < aTo.length; x++) {
				aToArray[x] = new InternetAddress((String)aTo[x]);
			}
			message.setRecipients(Message.RecipientType.TO, aToArray);
			message.setText(sMessage);
			Transport.send(message);

		} catch (Exception mex) {
			result = false;
			System.out.println("Keyop Error in keyopTools.sendPage.1 ERROR: " + mex);
			try {
				logError("keyopTools.sendPage.1","Keyop", mex);
			} catch (Exception ex) {
				System.out.println("Keyop Error in keyopTools.sendPage.2 ERROR: " + ex);
			}
		}
		
		if (result == false) {
			
			String sSmtpHost2 = myResources.getString("smtphost2");
			props.put("mail.smtp.host", sSmtpHost2);
			session = Session.getDefaultInstance(props, null);
			message = new MimeMessage(session);
		
			try {
		     		
				message.setFrom(new InternetAddress(sFromInternetAddress, sFromName));
				InternetAddress[] aToArray = new InternetAddress[aTo.length];
				for (int x = 0; x < aTo.length; x++) {
					aToArray[x] = new InternetAddress((String)aTo[x]);
				}
				message.setRecipients(Message.RecipientType.TO, aToArray);
				message.setText(sMessage);
				Transport.send(message);

			} catch (Exception mex) {
				result = false;
				System.out.println("Keyop Error in keyopTools.sendPage.3 ERROR: " + mex);
				try {
					logError("keyopTools.sendPage.2","Keyop", mex);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.sendPage.4 ERROR: " + ex);
				}
			}
		}
		
		return result;
	}
	
	/********************************************************************************************
    * isValidKeyopID										       								*
    *											       											*
    * This method takes a string, the users userid, and returns a boolean value of whether or	*
    * not the logged on user is a keyop or not based on whether or not the person exists in the *
    * keyop table of the database.																*
    ********************************************************************************************/	
    public boolean isValidKeyopID( String sUserID ) {
    	   
    	boolean isValidID = false;	
    	Connection con = null;
    	Statement stmtKeyop = null;
    	ResultSet rsKeyop  = null;
    	
      try {
    	con = getConnection();
    	stmtKeyop = con.createStatement();
    	rsKeyop = stmtKeyop.executeQuery("SELECT * FROM GPWS.USER_VIEW WHERE LOGINID = '" + sUserID + "' AND AUTH_NAME = 'Keyop'");
		
		while (rsKeyop.next()) {
			isValidID = true;
		}
		
      } catch (Exception e) {
      		System.out.println("keyopTools.isValidKeyopID ERROR: " + e);
      		try {
	   			logError("keyopTools.isValidKeyopID","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.isValidKeyopID ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsKeyop != null)
	  				rsKeyop.close();
		  		if (stmtKeyop != null)	
		  			stmtKeyop.close();
		  		if (con != null)	
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.isValidKeyopID.2 ERROR: " + e);
	  		}
	  }
      
	    return isValidID;
    }
    
    /********************************************************************************************
     * isValidKeyopID										       								*
     *											       											*
     * This method takes a string, the users userid, and returns a boolean value of whether or	*
     * not the logged on user is a keyop super user based on whether or not the person has
     * that authority in user_view.																*
     ********************************************************************************************/	
     public boolean isValidKeyopSuperUser( String sUserID ) {
     	   
     	boolean isValidSU = false;	
     	Connection con = null;
     	Statement stmtKeyop = null;
     	ResultSet rsKeyop  = null;
     	
       try {
     	con = getConnection();
     	stmtKeyop = con.createStatement();
     	rsKeyop = stmtKeyop.executeQuery("SELECT AUTH_NAME FROM GPWS.USER_VIEW WHERE LOGINID = '" + sUserID + "' AND AUTH_NAME = 'Keyop Superuser'");
 		
 		while (rsKeyop.next()) {
 			isValidSU = true;
 		}
 		
       } catch (Exception e) {
       		System.out.println("keyopTools.isValidKeyopSuperUser ERROR: " + e);
       		try {
 	   			logError("keyopTools.isValidKeyopSuperUser","Keyop", e);
 	   		} catch (Exception ex) {
 	   			System.out.println("Keyop Error in keyopTools.isValidKeyopSuperUser ERROR: " + ex);
 	   		}
       } finally {
 	  		try {
 	  			if (rsKeyop != null)
 	  				rsKeyop.close();
 		  		if (stmtKeyop != null)	
 		  			stmtKeyop.close();
 		  		if (con != null)	
 		  			con.close();
 	  		} catch (Exception e){
 		  		System.out.println("Keyop Error in keyopTools.isValidKeyopSuperUser.2 ERROR: " + e);
 	  		}
 	  }
       
 	    return isValidSU;
     }
    
    /********************************************************************************************
    * isValidAdminID										       								*
    *											       											*
    * This method takes a string, the users userid, and returns a boolean value of whether or	*
    * not the logged on user is a valid admin or not based on whether or not the person's id	*
    * exists in the database.																	*
    ********************************************************************************************/	
    public boolean isValidAdminID( String sUserID ) {
    	   
    	boolean isValidID = false;	
    	Connection con = null;
    	Statement stmtAdmin = null;
    	ResultSet rsAdmin = null;
    	
      try {
    	con = getConnection();
    	stmtAdmin = con.createStatement();
		rsAdmin = stmtAdmin.executeQuery("SELECT loginid from gpws.user");
		
		while (rsAdmin.next()) {
			if (rsAdmin.getString("loginid").equals(sUserID)) {
				isValidID = true;
			}
		}
		
      } catch (Exception e) {
      		System.out.println("keyopTools.isValidAdminID ERROR: " + e);
      		try {
	   			logError("keyopTools.isValidAdminID","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.isValidAdminID ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsAdmin != null)
	  				rsAdmin.close();
		  		if (stmtAdmin != null)	
		  			stmtAdmin.close();
		  		if (con != null)	
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.isValidAdminID.2 ERROR: " + e);
	  		}
	  }
      
	    return isValidID;
    }
    
    /********************************************************************************************
     * createRandPass										       								*
     *											       											*
     * This method takes no arguments and returns a random password.								*
     ********************************************************************************************/	
     public int getDeviceVendorID(Connection con, String sDevice) throws SQLException {
    	 int vendorID = 0;
    	 
    	 Statement stmt = null;
    	 ResultSet rs = null;
    	 
     	
    	 try {
    		 	sDevice = nullStringConverter(sDevice);
    		 	
    	    	stmt = con.createStatement();
    			rs = stmt.executeQuery("SELECT KO_COMPANYID FROM GPWS.DEVICE WHERE LOWER(DEVICE_NAME) = '" + sDevice.toLowerCase() + "'");
    			
    			while (rs.next()) {
    				vendorID = rs.getInt("KO_COMPANYID");
    			}
    			
    	      } catch (Exception e) {
    	      		System.out.println("keyopTools.getDeviceVendorID ERROR: " + e);
    	      		try {
    		   			logError("keyopTools.getDeviceVendorID","Keyop", e);
    		   		} catch (Exception ex) {
    		   			System.out.println("Keyop Error in keyopTools.getDeviceVendorID ERROR: " + ex);
    		   		}
    	      } finally {
    		  		try {
    		  			if (rs != null)
    		  				rs.close();
    			  		if (stmt != null)	
    			  			stmt.close();
    		  		} catch (Exception e){
    			  		System.out.println("Keyop Error in keyopTools.getDeviceVendorID.2 ERROR: " + e);
    		  		}
    		  }
    	 
    	 return vendorID;
     }
    
    
    /********************************************************************************************
    * createRandPass										       								*
    *											       											*
    * This method takes no arguments and returns a random password.								*
    ********************************************************************************************/	
    public String createRandPass() {
    	
    	String sRandPass = "";
    	String sTimestamp = getTimestamp("millisecond");
    	sTimestamp = sTimestamp + "0";
    	
    	char[] characters0 = {'A','1','C','d','3','F','g','2','I','J'};
    	char[] characters1 = {'K','L','M','4','O','P','Q','R','S','T'};
    	char[] characters2 = {'U','V','8','X','Y','9','a','B','c','D'};
    	char[] characters3 = {'E','f','G','H','i','j','k','l','m','N'};
    	char[] characters4 = {'o','p','q','r','s','t','u','v','W','x'};
    	char[] characters5 = {'y','Z','0','1','2','3','4','5','6','7'};
    	char[] characters6 = {'8','9','A','B','c','D','E','f','G','H'};
    	char[] characters7 = {'I','j','K','L','M','n','O','7','Q','R'};
    	
        sRandPass = (sRandPass + characters0[Integer.parseInt(sTimestamp.substring(14,15))]);
        sRandPass = (sRandPass + characters1[Integer.parseInt(sTimestamp.substring(15,16))]);
        sRandPass = (sRandPass + characters2[Integer.parseInt(sTimestamp.substring(10,11))]);
        sRandPass = (sRandPass + characters3[Integer.parseInt(sTimestamp.substring(11,12))]);
        sRandPass = (sRandPass + characters4[Integer.parseInt(sTimestamp.substring(12,13))]);
        sRandPass = (sRandPass + characters5[Integer.parseInt(sTimestamp.substring(13,14))]);
        sRandPass = (sRandPass + characters6[Integer.parseInt(sTimestamp.substring(15,16))]);
        sRandPass = (sRandPass + characters7[Integer.parseInt(sTimestamp.substring(14,15))]);
            	
    	return sRandPass;
    }
    
    /********************************************************************************************
    * getNumProbChoices										       								*
    *											       											*
    * This method takes no arguments and returns the number of problem choices available for the*
    * user to submit on the requestService page.												*
    ********************************************************************************************/	
    public int getNumProbChoices() {
    	
    	int iNumProbChoices = 0;
    	Connection con = null;
    	Statement stmtProblems = null;
    	ResultSet rsProblems = null;
    	try {
    	con = getConnection();
    	stmtProblems = con.createStatement();
		rsProblems = stmtProblems.executeQuery("SELECT KEYOP_PROBLEMID FROM GPWS.KEYOP_PROBLEMS ORDER BY KEYOP_PROBLEMID");
		
		while (rsProblems.next()) {
			
			iNumProbChoices = Integer.parseInt(rsProblems.getString("KEYOP_PROBLEMID"));
		}
		
      } catch (Exception e) {
      		System.out.println("keyopTools.getNumProblemChoices ERROR: " + e);
      		try {
	   			logError("keyopTools.getNumProbChoices","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.getNumProbChoices ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsProblems != null)
	  				rsProblems.close();
		  		if (stmtProblems != null)	
		  			stmtProblems.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in AdminKeyop.addSiteDB.2 ERROR: " + e);
	  		}
	  }
      
      	return iNumProbChoices;
    }
    
    /********************************************************************************************
    * getProblemChoice										       								*
    *											       											*
    * This method takes no arguments and returns the number of problem choices available for the*
    * user to submit on the requestService page.												*
    ********************************************************************************************/	
    public String getProblemChoice(int probNumber) {
    	
    	String sProblemChoice = "";
    	Connection con = null;
    	Statement stmtProblems = null;
    	ResultSet rsProblems = null;
    	try {
    	con = getConnection();
    	stmtProblems = con.createStatement();
		rsProblems = stmtProblems.executeQuery("SELECT problemname from problems where problemid = " + probNumber);
		
		while (rsProblems.next()) {
			sProblemChoice = rsProblems.getString("problemname");
		}
		
      } catch (Exception e) {
      		System.out.println("keyopTools.getProblemChoice ERROR: " + e);
      		try {
	   			logError("keyopTools.getProblemChoice","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.getProblemChoice ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsProblems != null)
	  				rsProblems.close();
		  		if (stmtProblems != null)	
		  			stmtProblems.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.getProblemChoice.2 ERROR: " + e);
	  		}
	  }
      
      	return sProblemChoice;
    }
        
    /********************************************************************************************
    * getNewReqNumber										       									*
    *											       											*
    * This method will return a request number by grabbing the current # from the db and		*
    * increasing it by one. It then sets the db to the new number.								*					
    ********************************************************************************************/	
    public String getNewReqNumber() {
    	
    	String sReqNumber = "";
    	String sNewReqNumber = "";
    	int iNewReqNumber = 0;
    	boolean bReqNumberExist = false;
    	Connection con = null;
    	Statement stmtGetReqNum = null;
    	ResultSet rsGetReqNum = null;
    	Statement stmtSetReqNum = null;
    	
      try {
      	con = getConnection();
    	stmtGetReqNum = con.createStatement();
		rsGetReqNum = stmtGetReqNum.executeQuery("SELECT reqnumber from requestnum where reqname = 'keyop'");
		
		while (rsGetReqNum.next()) {
			sReqNumber = rsGetReqNum.getString("reqnumber");
			bReqNumberExist = true;
		}
		
		if (bReqNumberExist) {
			iNewReqNumber = (Integer.parseInt(sReqNumber) + 1);
			sNewReqNumber = "" + iNewReqNumber;
		
  		  	stmtSetReqNum = con.createStatement(); 
			stmtSetReqNum.executeUpdate("UPDATE requestnum set reqnumber = " + iNewReqNumber + " where reqname = 'keyop'"); 
		} else {
			sNewReqNumber = "1000";
			stmtSetReqNum = con.createStatement(); 
			stmtSetReqNum.executeUpdate("INSERT into requestnum (reqname, reqnumber) values ('keyop', 1000)"); 
		}
  		
      } catch (Exception e) {
      		System.out.println("keyopTools.getNewReqNumber ERROR: " + e);
      		try {
	   			logError("keyopTools.getNewReqNumber","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.getNewReqNumber ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsGetReqNum != null)
	  				rsGetReqNum.close();
		  		if (stmtGetReqNum != null)	
		  			stmtGetReqNum.close();
		  		if (stmtSetReqNum != null)
		  			stmtSetReqNum.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.getNewReqNumber.2 ERROR: " + e);
	  		}
	  }
      	return sNewReqNumber;
    }
    
    /********************************************************************************************
    * getNewReferenceNumber										       									*
    *											       											*
    * This method will return a request number by grabbing the current # from the db and		*
    * increasing it by one. It then sets the db to the new number.								*					
    ********************************************************************************************/	
    public String getNewReferenceNumber() {
    	
    	String sReferenceNumber = "";
    	String sNewReferenceNumber = "";
    	int iNewReferenceNumber = 0;
    	boolean bReqNumberExist = false;
    	Connection con = null;
    	Statement stmtGetReferenceNum = null;
    	ResultSet rsGetReferenceNum = null;
    	Statement stmtSetReferenceNum = null;
    	
      try {
      	
    	con = getConnection();
    	stmtGetReferenceNum = con.createStatement();
		rsGetReferenceNum = stmtGetReferenceNum.executeQuery("SELECT reqnumber from requestnum where reqname = 'holdtimes'");
		
		while (rsGetReferenceNum.next()) {
			sReferenceNumber = rsGetReferenceNum.getString("reqnumber");
			bReqNumberExist = true;
			
		}
		
		if (bReqNumberExist) {
			iNewReferenceNumber = (Integer.parseInt(sReferenceNumber) + 1);
			sNewReferenceNumber = "" + iNewReferenceNumber;
		
    		stmtSetReferenceNum = con.createStatement(); 
			stmtSetReferenceNum.executeUpdate("UPDATE requestnum set reqnumber = " + iNewReferenceNumber + " where reqname = 'holdtimes'"); 
		} else {
			sNewReferenceNumber = "1000";
			stmtSetReferenceNum = con.createStatement(); 
			stmtSetReferenceNum.executeUpdate("INSERT into requestnum (reqname, reqnumber) values ('holdtimes', 1000)"); 
		}
  		
      } catch (Exception e) {
      		System.out.println("keyopTools.getNewReferenceNumber ERROR: " + e);
      		try {
	   			logError("keyopTools.getNewReferenceNumber","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.getNewReferenceNumber ERROR: " + ex);
	   		}
      } finally {
	  		try {
	  			if (rsGetReferenceNum != null)
	  				rsGetReferenceNum.close();
		  		if (stmtGetReferenceNum != null)
		  			stmtGetReferenceNum.close();
		  		if (stmtSetReferenceNum != null)	
		  			stmtSetReferenceNum.close();
		  		if (con != null)	
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("Keyop Error in keyopTools.getNewReferenceNumber.2 ERROR: " + e);
	  		}
	  }
      	return sNewReferenceNumber;
    }
    
    /********************************************************************************************
    * bpAuthenticate										       							*
    *											       											*
    * Authenticates a user using IIP.
    *********************************************************************************************/	
    public int bpAuthenticate(String sUserid, String sPassword) {
    	
    	ReturnCode rc = null;
    	
      try {	
    	// do some checking here, and return either true or false.
    	String sServer = "ldap://bluepages.ibm.com";
		//String sServer = "ldap://d03dbx46e.boulder.ibm.com";
    	
    	rc = cwa.authenticate(sServer, sUserid, sPassword);
    	
      } catch (Exception e) {
      		System.out.print("Keyop error in keyopTools.bpAuthenticate ERROR " + e);
      		try {
	   			logError("keyopTools.bpAuthenticate","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.bpAuthenticate ERROR: " + ex);
	   		}
      }
		return(rc.getCode());
    	
    }
        
    /********************************************************************************************
    * getTimeDifference									       										*
    ********************************************************************************************/
	public String getTimeDifference( String sTimestamp1, String sTimestamp2  )
    	throws IOException {
    	
    	String diffTime;
    	if (sTimestamp1.length() != 12 || sTimestamp2.length() != 12 ) {
    		diffTime = "Invalid time format";
    	} else {
   			int time1year = Integer.parseInt(sTimestamp1.substring(0,4));
			int time1month = Integer.parseInt(sTimestamp1.substring(4,6));
			int time1day = Integer.parseInt(sTimestamp1.substring(6,8));
			int time1hour = Integer.parseInt(sTimestamp1.substring(8,10));
			int time1minute = Integer.parseInt(sTimestamp1.substring(10,12));

			int time2year = Integer.parseInt(sTimestamp2.substring(0,4));
			int time2month = Integer.parseInt(sTimestamp2.substring(4,6));
			int time2day = Integer.parseInt(sTimestamp2.substring(6,8));
			int time2hour = Integer.parseInt(sTimestamp2.substring(8,10));
			int time2minute = Integer.parseInt(sTimestamp2.substring(10,12));

			int diffYear = (time1year - time2year);
			int diffMonth = (time1month - time2month);
			int diffDay = (time1day - time2day);
			int diffHour = (time1hour - time2hour);
			int diffMinute =(time1minute - time2minute);
		
			if (diffMinute < 0) {
				diffMinute = (diffMinute + 60);
				diffHour = (diffHour - 1);
			}

			if (diffHour < 0) {
				diffHour = (diffHour + 24);
				diffDay = (diffDay - 1);
			}
		
			if (diffDay < 0) {
				if ( time1month == 1 || time1month == 2 || time1month == 4 || time1month == 6 || time1month == 8 || time1month == 9 || time1month == 11 ) {
					diffDay = (diffDay + 31);
				} else if ( time1month == 5 || time1month == 7 || time1month == 10 || time1month == 12 ) {
					diffDay = (diffDay + 30);
				} else {
					diffDay = (diffDay + 28);
				}
					diffMonth = (diffMonth - 1);
			}
		
			if (diffMonth < 0) {
				diffMonth = (diffMonth + 12);
				diffYear = (diffYear -1);
			}
		
			String sDiffYear = ("" + diffYear);
			if (sDiffYear.length() == 1) {
				sDiffYear = ("000" + sDiffYear);
			} else if (sDiffYear.length() == 2) {
				sDiffYear = ("00" + sDiffYear);
			} else if (sDiffYear.length() == 3) {
				sDiffYear = ("0" + sDiffYear);
			} else {
				// do nothing because if the year is length 4, you don't need to add any 0s
			}
		
			String sDiffMonth = ("" + diffMonth);
			if (sDiffMonth.length() == 1) {
				sDiffMonth = ("0" + sDiffMonth);
			}
		
			String sDiffDay = ("" + diffDay);
			if (sDiffDay.length() == 1) {
				sDiffDay = ("0" + sDiffDay);
			}
		
			String sDiffHour = ("" + diffHour);
			if (sDiffHour.length() == 1) {
				sDiffHour = ("0" + sDiffHour);
			}
		
			String sDiffMinute = ("" + diffMinute);
			if (sDiffMinute.length() == 1) {
				sDiffMinute = ("0" + sDiffMinute);
			}
	
			diffTime = (sDiffYear + sDiffMonth + sDiffDay + sDiffHour + sDiffMinute);
    	}
    	
		return diffTime;
	
    }
    
    /********************************************************************************************
    * timeDifferenceReadable
    ********************************************************************************************/
	public String timeDifferenceReadable( String sTimestamp )
    	throws IOException {
    	
    	String sTime;
    	if (sTimestamp.length() != 12 ) {
    		sTime = "Invalid time format";
    	} else {
    		int year = Integer.parseInt(sTimestamp.substring(0,4));
			int month = Integer.parseInt(sTimestamp.substring(4,6));
			int day = Integer.parseInt(sTimestamp.substring(6,8));
			int hour = Integer.parseInt(sTimestamp.substring(8,10));
			int minute = Integer.parseInt(sTimestamp.substring(10,12));
		
			sTime = ("" + year + " years, " + month + " months, " + day + " days, " + hour + " hours, " + minute + " minutes");
    	}
		return sTime;
    }
    
    /********************************************************************************************
    * timeStampConvert
    ********************************************************************************************/
	public String timeStampConvert( Timestamp tTimestamp )
    	throws IOException {
    	
    	String sTimestamp = tTimestamp + "";
		return sTimestamp;
    }
    
	/********************************************************************************************
    * logError
    * 
    * This will log an error to the ERROR_LOG table in the database
    ********************************************************************************************/
	public void logError( String sClassMethod, String sModule, Exception eError )
    	throws IOException {
    		
    		Connection con = null;
    		Statement stmtLogError = null;
    	try {
    		con = getConnection();
    		
    		stmtLogError = con.createStatement(); 
			stmtLogError.executeUpdate("INSERT INTO GPWS.ERROR_LOG (CLASS_METHOD, MODULE_NAME, ERROR) values ('" + sClassMethod + "', '" + sModule + "', '" + eError + "')"); 
					
    	} catch (Exception e) {
    		System.out.print("Error in keyopTools.logError ERROR: " + e);    		
    	} finally {
			try {
				if (stmtLogError != null)
					stmtLogError.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Error in keyopTools.logError.2 ERROR: " + e);
			}
  		}
    }
	
	/********************************************************************************************
    * logError
    * 
    * This will log an error to the ERROR_LOG table in the database
    ********************************************************************************************/
	public void logError( String sClassMethod, Exception eError )
    	throws IOException {
    		
    		Connection con = null;
    		Statement stmtLogError = null;
    	try {
    		con = getConnection();
    		
    		stmtLogError = con.createStatement(); 
			stmtLogError.executeUpdate("INSERT INTO GPWS.ERROR_LOG (CLASS_METHOD, ERROR) values ('" + sClassMethod + "', '" + eError + "')"); 
					
    	} catch (Exception e) {
    		System.out.print("Error in keyopTools.logError ERROR: " + e);    		
    	} finally {
			try {
				if (stmtLogError != null)
					stmtLogError.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Error in keyopTools.logError.2 ERROR: " + e);
			}
  		}
    }
    
    /********************************************************************************************
    * fixPagerNumber
    * 
    * This will remove the dashes from a pager number in bluepages
    ********************************************************************************************/
	public String fixPagerNumber( String sPagerNumber )
    	throws IOException {
    		
    		String sNewPagerNumber = "";
    	try {
    		if(sPagerNumber.length() == 14) {
    			// Create new String without the dashes
    			sNewPagerNumber = sPagerNumber.substring(2,5); // area code
    			sNewPagerNumber += sPagerNumber.substring(6,9); // first 3 digits
    			sNewPagerNumber += sPagerNumber.substring(10,14); // last 4 digits
    			
    		} else {
    			sNewPagerNumber = sPagerNumber;
    		}
		
    	} catch (Exception e) {
    		System.out.print("Keyop error in keyopTools.fixPagerNumber ERROR: " + e);
    		try {
	   			logError("keyopTools.fixPagerNumber","Keyop", e);
	   		} catch (Exception ex) {
	   			System.out.println("Keyop Error in keyopTools.fixPagerNumber ERROR: " + ex);
	   		}
    	}
    	
    	return sNewPagerNumber;
    }
    
	/********************************************************************************************
	* getSiteName
	* 
	* This takes a cityid and returns the city(site) name
	********************************************************************************************/
	public String getSiteName( int iCityID ) {
    
		Connection con = null;
		Statement stmtCity = null;
		ResultSet rsCity = null;
		String sCity = "None";

		  try {
	  	
			con = getConnection();

			stmtCity = con.createStatement();
			rsCity = stmtCity.executeQuery("SELECT CITY FROM GPWS.CITY WHERE CITYID = " + iCityID);
	
			while (rsCity.next()) {
				sCity = rsCity.getString("CITY");
			}
		  } catch (Exception e) {
				System.out.println("Keyop error in keyopTools.getSiteName.1 ERROR: " + e);
				try {
					logError("keyopTools.getSiteName","Keyop", e);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.fixPagerNumber.2 ERROR: " + ex);
				}
		  } finally {
				try {
					if (rsCity != null)
						rsCity.close();
					if (stmtCity != null)	
						stmtCity.close();
					if (con != null)
						con.close();
				} catch (Exception e){
					System.out.println("Keyop Error in keyopTools.getSiteName.3 ERROR: " + e);
				}
		  }
		return sCity;
	}
	
	/********************************************************************************************
	* getCountryName
	* 
	* This takes a cityid and returns the city(site) name
	********************************************************************************************/
	public String getCountryName( int iCountryID ) {
    
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sCountry = "None";

		  try {
	  	
			con = getConnection();

			stmt = con.createStatement();
			rs = stmt.executeQuery("SELECT COUNTRY FROM GPWS.COUNTRY WHERE COUNTRYID = " + iCountryID);
	
			while (rs.next()) {
				sCountry = rs.getString("COUNTRY");
			}
		  } catch (Exception e) {
				System.out.println("Keyop error in keyopTools.getCountryName.1 ERROR: " + e);
				try {
					logError("keyopTools.getCountryName","Keyop", e);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.fixPagerNumber.2 ERROR: " + ex);
				}
		  } finally {
				try {
					if (rs != null)
						rs.close();
					if (stmt != null)	
						stmt.close();
					if (con != null)
						con.close();
				} catch (Exception e){
					System.out.println("Keyop Error in keyopTools.getCountryName.3 ERROR: " + e);
				}
		  }
		return sCountry;
	}

	
	/********************************************************************************************
	* fixDBInputText
	* 
	* This will change ` to ', add an additional ' where ' is found, and add \ before ". 
	********************************************************************************************/
	public String fixDBInputText( String sInputText )
		throws IOException {
    		
			String sOutputText = "";
			String sTemp = "`'";
			char cTic = sTemp.charAt(0);
			char cSQuote = sTemp.charAt(1);
		try {
			if(sInputText != null) {
				sOutputText = sInputText.replace(cTic,cSQuote); // replace (`) with (')
				for (int x = 0; x < sOutputText.length(); x++) {
					if(sOutputText.substring(x, x + 1).equals("'")) {
						sOutputText = sOutputText.substring(0, x + 1) + "'" + sOutputText.substring(x + 1,sOutputText.length());
						x++;
					} else if(sOutputText.substring(x, x + 1).equals("\"")) {
						sOutputText = sOutputText.substring(0, x) + "\\" + sOutputText.substring(x,sOutputText.length());
						x++;
					}
				}
    		
			} else {
				sOutputText = sInputText;
			}
	
		} catch (Exception e) {
			System.out.print("Keyop error in keyopTools.fixDBInputText ERROR: " + e);
			try {
				logError("keyopTools.fixPagerNumber","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in keyopTools.fixDBInputText ERROR: " + ex);
			}
		}
		return sOutputText;
	}
	
	/********************************************************************************************
	* fixSerialPlus
	* 
	* This will change ` to ', add an additional ' where ' is found, and add \ before ". 
	********************************************************************************************/
	public String fixSerialPlus( String sSerial ) throws IOException {
    		
			String sOutputText = sSerial;
			int iPlus = -1;
			int i = 0;
		try {
			if(sSerial != null) {
				for (i=0; i < sSerial.length(); i++) {
					if (sSerial.substring(i, i + 1).equals("+")) {
						iPlus = i;
					}
				}
				if (iPlus != -1) {
					sOutputText = sSerial.substring(0,iPlus) + "%2B" + sSerial.substring(iPlus + 1,sSerial.length());
				}

			} else {
				sOutputText = sSerial;
			}
	
		} catch (Exception e) {
			System.out.print("Keyop error in keyopTools.fixSerialPlus ERROR: " + e);
			try {
				logError("keyopTools.fixSerialPlus","Keyop", e);
			} catch (Exception ex) {
				System.out.println("Keyop Error in keyopTools.fixSerialPlus ERROR: " + ex);
			}
		}
		return sOutputText;
	}
	
	/********************************************************************************************
	* returnUserInfo										       									*
	*											       											*
	* This method takes 2 strings, one is a persons email address and the other is a flag.  The *
	* possible flags are: name, tieline, and email.  Based on which of those are passed,		*
	* their bluepages info for that will be returned.											*
	********************************************************************************************/	
	public String returnUserInfo(int iUserid, String sFlag) throws Exception {
    	
		String sFirstName = "";
		String sLastName = "";
		String sEmail = "";
		String sLoginID = "";
		int iBackupID = 0;
		String sOfficeStatus = "";
		String sPager = "";
		String sReturnValue = "";
		Connection con = null;
		Statement stmtInfo = null;
		ResultSet rsInfo = null;
		try {
			con = getConnection();
			stmtInfo = con.createStatement();
			rsInfo = stmtInfo.executeQuery("SELECT * FROM GPWS.USER WHERE USERID = " + iUserid);
					
			while (rsInfo.next()) {
				sFirstName = rsInfo.getString("FIRST_NAME");
				sLastName = rsInfo.getString("LAST_NAME");
				sEmail = rsInfo.getString("EMAIL");
				sLoginID = rsInfo.getString("LOGINID");
				iBackupID = rsInfo.getInt("BACKUPID");
				sPager = rsInfo.getString("PAGER");
				sOfficeStatus = rsInfo.getString("OFFICE_STATUS");
			}
	
		} catch(Exception e) {
			System.out.println("keyopTools.returnKeyopInfo ERROR: " + e);
				try {
					logError("keyopTools.returnKeyopInfo","Keyop", e);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.returnKeyopInfo.1 ERROR logging error: " + ex);
				}
		} finally {
			try {
				if (rsInfo != null)
					rsInfo.close();
				if (stmtInfo != null)	
					stmtInfo.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("Keyop Error in keyopTools.returnKeyopInfo.2 ERROR closing DB stuff: " + e);
			}
		}
			
		if (sFlag.equals("last_first_name")) {
			sReturnValue = sLastName + ", " + sFirstName;
		} else if (sFlag.equals("first_last_name")) {
			sReturnValue = sFirstName + " " + sLastName;
		} else if (sFlag.equals("email")) {
			sReturnValue = sEmail;
		} else if (sFlag.equals("userid")) {
			sReturnValue = sLoginID;
		} else if (sFlag.equals("pager")) {
			sReturnValue = sPager;
		} else if (sFlag.equals("backup")) {
			sReturnValue = iBackupID + "";
		} else if (sFlag.equals("officestatus")) {
			sReturnValue = sOfficeStatus;
		} else {
			sReturnValue = "An error has occurred";
		}
		
		return sReturnValue;
	}
	
	/********************************************************************************************
	* returnDBInfo										       									*
	*											       											*
	* This method takes 2 strings, one is a persons email address and the other is a flag.  The *
	* possible flags are: name, tieline, and email.  Based on which of those are passed,		*
	* their bluepages info for that will be returned.											*
	********************************************************************************************/	
	public String returnKeyopInfo( int iUserid, String sFlag ) throws Exception {
    	
			String sEmpName = "";
			String sEmail = "";
			String sLoginID = "";
			int iBackupID = 0;
			String sOfficeStatus = "";
			String sPager = "";
			String sReturnValue = "";
			Connection con = null;
			Statement stmtInfo = null;
			ResultSet rsInfo = null;
		  try {
			con = getConnection();
			stmtInfo = con.createStatement();
			rsInfo = stmtInfo.executeQuery("SELECT * FROM GPWS.USER WHERE USERID = " + iUserid);
						
			while (rsInfo.next()) {
				sEmpName = rsInfo.getString("LAST_NAME") + ", " + rsInfo.getString("FIRST_NAME");
				sEmail = rsInfo.getString("EMAIL");
				sLoginID = rsInfo.getString("LOGINID");
				iBackupID = rsInfo.getInt("BACKUPID");
				sPager = rsInfo.getString("PAGER");
				sOfficeStatus = rsInfo.getString("OFFICE_STATUS");
			}
		
		  } catch(Exception e) {
			System.out.println("keyopTools.returnKeyopInfo ERROR: " + e);
				try {
					logError("keyopTools.returnKeyopInfo","Keyop", e);
				} catch (Exception ex) {
					System.out.println("Keyop Error in keyopTools.returnKeyopInfo.1 ERROR logging error: " + ex);
				}
		  } finally {
				try {
					if (rsInfo != null)
						rsInfo.close();
					if (stmtInfo != null)	
						stmtInfo.close();
					if (con != null)
						con.close();
				} catch (Exception e){
					System.out.println("Keyop Error in keyopTools.returnKeyopInfo.2 ERROR closing DB stuff: " + e);
				}
		  }
				
			if (sFlag.equals("name")) {
				sReturnValue = sEmpName;
			} else if (sFlag.equals("email")) {
				sReturnValue = sEmail;
			} else if (sFlag.equals("userid")) {
				sReturnValue = sLoginID;
			} else if (sFlag.equals("pager")) {
				sReturnValue = sPager;
			} else if (sFlag.equals("backup")) {
				sReturnValue = iBackupID + "";
			} else if (sFlag.equals("officestatus")) {
				sReturnValue = sOfficeStatus;
			} else {
				sReturnValue = "An error has occurred";
			}
			
		return sReturnValue;
	}
	
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
}