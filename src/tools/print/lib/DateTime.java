/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.lib;

import java.io.IOException;
import java.io.*;
import java.util.*;
import java.sql.*;
import java.text.*;

/****************************************************************************************
 * DateTime																			
 * 																						
 * @author: Joe Comfort																	
 * Copyright IBM																		
 * 																						
 * This class contains several useful methods regarding dates and times. It contains
 * many ways of manipulating time and timestamps.						
 ****************************************************************************************/
public class DateTime {
			
	/********************************************************************************************
    * getTimeZoneCategory										       							*
    *											       											*
    * This method gets the TimeZone category from the database and returns which TimeZone       *
    * it should display																			*
    ********************************************************************************************/	
	public static String getTimeZoneCategory() {

		AppTools tool = new AppTools();
    	String sTimeZone = "";
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rset = null;
    	try {
    		con = tool.getConnection();
    		String sqlQuery="SELECT * FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'TimeZone' AND LOWER(CATEGORY_VALUE2)='display'";
    		pstmt = con.prepareStatement(sqlQuery);
    		rset = pstmt.executeQuery();
    		while (rset.next()) {
    			sTimeZone = rset.getString("CATEGORY_VALUE1");
    		}
    	} catch (Exception sqle) {
    		System.out.println("DateTime Error in DateTime.getTimeZoneCategory.1 ERROR: " + sqle);
    	} finally {
			try {
				if (rset != null)
					rset.close();
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("DateTime Error in DateTime.getTimeZoneCategory.2 ERROR: " + e);
			}
	  }
    	if (sTimeZone.equals("") || sTimeZone == null) {
    		sTimeZone = "America/New_York";
		}
    	
    	return sTimeZone;
	}  //getTimeZoneCategory method
	
	/********************************************************************************************
    * getServerTimeZoneCategory										       						
    * 											       											
    * This method gets the TimeZone category from the database and returns which Time Zone      
    * the Websphere server is set to. It will look for the Server value in Category value 2 of the
    * TimeZone category. If the server time zone and the display time zone are the same (thus
    * there is no Server value in Category value 2), it will default to the Display value. If
    * neither value is specified in Category, it will default to UTC.
    * 
    * ***This method has been updated to work with dynamically setting the server time zone***
    * 
    ********************************************************************************************/	
	public static String getServerTimeZoneCategory() {
		AppTools tool = new AppTools();
		String sTimeZone = "";
    	String sTimeZoneS = "";
    	String sTimeZoneD = "";
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rset = null;
    	try {
    		con = tool.getConnection();
    		String sqlQuery="SELECT * FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'TimeZone' AND (LOWER(CATEGORY_VALUE2)='server' OR LOWER(CATEGORY_VALUE2)='display')";
    		pstmt = con.prepareStatement(sqlQuery);
    		rset = pstmt.executeQuery();
    		while (rset.next()) {
    			if (rset.getString("CATEGORY_VALUE2").toLowerCase().equals("server")) { 
    				sTimeZoneS = rset.getString("CATEGORY_VALUE1");
    			} else if (rset.getString("CATEGORY_VALUE2").toLowerCase().equals("display")) {
    				sTimeZoneD = rset.getString("CATEGORY_VALUE1");
    			} 
    		}
    	} catch (Exception sqle) {
    		System.out.println("DateTime Error in DateTime.getServerTimeZoneCategory.1 ERROR: " + sqle);
    	} finally {
			try {
				if (rset != null)
					rset.close();
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (Exception e){
				System.out.println("DateTime Error in DateTime.getServerTimeZoneCategory.2 ERROR: " + e);
			}
	  }
    	if (sTimeZoneS != null && !sTimeZoneS.equals("")) {
    		sTimeZone = sTimeZoneS;
    	} else if (sTimeZoneD != null && !sTimeZoneD.equals("")) {
    		sTimeZone = sTimeZoneD;
    	} else if (sTimeZone == null || sTimeZone.equals("")  ) {
    		sTimeZone = "UTC";
		}
    	
    	return sTimeZone;
	}  //getServerTimeZoneCategory method
	
	/********************************************************************************************
    * getSQLTimestamp										       								
    *											       											
    * This method takes no arguments and returns a Timestamp. It will get the current date and
    * time and create a Timestamp in the UTC timezone.  It then returns this timestamp. It
    * creates the timestamp in the UTC time zone because all GPWS timestamps are stored in UTC
    * in the database.
    * 
    * ***This method has been updated to work with dynamically setting the server time zone***
    * 
    ********************************************************************************************/	
    public Timestamp getSQLTimestamp() throws Exception {
    	
    	Timestamp tsTimestampNew;
		
    	// Get the server time zone from the db
    	String sServerTimeZone = getServerTimeZoneCategory();
    	System.out.println("sServerTimeZone = " + sServerTimeZone);
		
    	// Create a calendar instance with server time zone
		TimeZone tz = TimeZone.getTimeZone(sServerTimeZone);
		Locale lc = new Locale("en", "US");
		Calendar rightNow = Calendar.getInstance(tz, lc);
		
		// Create a Timestamp based on the calendar. (This will automatically put it in the server time zone no matter what is set in the sServerTimeZone).
		Timestamp tsTimestamp = new Timestamp(rightNow.getTimeInMillis());
		
		// In case the server is not in UTC, convert it to UTC and back into a Timestamp
		
		if (!sServerTimeZone.equals("UTC")) {
			String sTimestamp = convertToTimeZone(tsTimestamp, "SERVER", "UTC");
			tsTimestampNew = stringToTimestamp(sTimestamp);
		} else {
			tsTimestampNew = tsTimestamp;
		}
		
		System.out.println("tsTimestampNew = " + tsTimestampNew.toString());
		
		return tsTimestampNew;
    }
    
    /********************************************************************************************
	* getServerTimestamp
	*
	* This method takes no arguments and returns a Timestamp. It will get the current date and
	* time and create a Timestamp in the server timezone.  It then returns this timestamp.
	* 
	* ***This method has been updated to work with dynamically setting the server time zone***
	* 
	********************************************************************************************/	
	public Timestamp getServerTimestamp() throws Exception {
			
		String sServerTimeZone = getServerTimeZoneCategory();
		
		TimeZone tz = TimeZone.getTimeZone(sServerTimeZone);
		Locale lc = new Locale("en", "US");
		Calendar rightNow = Calendar.getInstance(tz, lc);
		
		long lTimeInMillis = rightNow.getTime().getTime();
		Timestamp tsTimestamp = new Timestamp(lTimeInMillis);
		
		return tsTimestamp;
	}
	
	/********************************************************************************************
	* isValidTimeStamp
	********************************************************************************************/
	public boolean isValidTimeStamp( String sTimestamp )
		throws IOException {
    	boolean validTS = false;
    	
    	if ( sTimestamp.equals("") || sTimestamp == null) {
    		validTS = false;
    	//} else if (sTimestamp.length() > 20 && Character.isDigit(sTimestamp.charAt(0)) && Character.isDigit(sTimestamp.charAt(1)) && Character.isDigit(sTimestamp.charAt(2)) && Character.isDigit(sTimestamp.charAt(3)) && ((String)(sTimestamp.charAt(4)).equals("-")) && Character.isDigit(sTimestamp.charAt(5)) && Character.isDigit(sTimestamp.charAt(6)) && ((String)(sTimestamp.charAt(7)).equals("-")) && Character.isDigit(sTimestamp.charAt(8)) && Character.isDigit(sTimestamp.charAt(9)) && Character.isDigit(sTimestamp.charAt(11)) && Character.isDigit(sTimestamp.charAt(12)) && Character.isDigit(sTimestamp.charAt(14)) && Character.isDigit(sTimestamp.charAt(15)) && Character.isDigit(sTimestamp.charAt(17)) && Character.isDigit(sTimestamp.charAt(18))) {
		} else if (sTimestamp.length() >= 19 && Character.isDigit(sTimestamp.charAt(0)) && Character.isDigit(sTimestamp.charAt(1)) && Character.isDigit(sTimestamp.charAt(2)) && Character.isDigit(sTimestamp.charAt(3)) && Character.isDigit(sTimestamp.charAt(5)) && Character.isDigit(sTimestamp.charAt(6)) && Character.isDigit(sTimestamp.charAt(8)) && Character.isDigit(sTimestamp.charAt(9)) && Character.isDigit(sTimestamp.charAt(11)) && Character.isDigit(sTimestamp.charAt(12)) && Character.isDigit(sTimestamp.charAt(14)) && Character.isDigit(sTimestamp.charAt(15)) && Character.isDigit(sTimestamp.charAt(17)) && Character.isDigit(sTimestamp.charAt(18))) {
    		validTS = true;
    	}
    	
		return validTS;
	}
	
	/********************************************************************************************
	* timeStampToString
	********************************************************************************************/
	public String timeStampToString( Timestamp tTimestamp ) throws IOException {
    	
		String sTimestamp = tTimestamp + "";
		return sTimestamp;
	}
	
	/********************************************************************************************
	* convertToTimeZone
	*
	* This method takes a timestamp (tsTime) and the time zone of that timestamp (tzOld) and
	* will convert it to a new timestamp in the new time zone (tzNew). If you don't know the
	* time zone of the timestamp you are passing (this happens when using a server generated
	* time zone), you can pass the value SERVER in tzOld and it will look up the server time zone
	* for you.
	* 
	* ***This method has been updated to work with dynamically setting the server time zone***
	* 
	*********************************************************************************************/	
	public String convertToTimeZone(Timestamp tsTime, String tzOld, String tzNew) throws Exception {
		
		if (tsTime == null ) {
			return "invalid time";
		}
		if (tzOld != null && !tzOld.equals("") && tzOld.toUpperCase().equals("SERVER")) {
			tzOld = getServerTimeZoneCategory();
		} else if (tzOld != null && !tzOld.equals("") && tzOld.toUpperCase().equals("DISPLAY")) {
			tzOld = getTimeZoneCategory();
		}

		int iYear = getTimeStampValues(tsTime, "year");
		int iMonth = getTimeStampValues(tsTime, "month");
		int iDay = getTimeStampValues(tsTime, "day");
		int iHour = getTimeStampValues(tsTime, "hour");
		int iMinute = getTimeStampValues(tsTime, "minute");
		int iSecond = getTimeStampValues(tsTime, "second");
		
		Calendar cTime = Calendar.getInstance();
		cTime.clear();
		cTime.setTimeZone(TimeZone.getTimeZone(tzOld));
		cTime.set(iYear, iMonth - 1, iDay, iHour, iMinute, iSecond );
		
		DateFormat formatter = new SimpleDateFormat("yyyy'-'MM'-'dd'-'HH.mm.ss", Locale.US);
		TimeZone tz = TimeZone.getTimeZone(tzNew);
		formatter.setTimeZone(tz);
		
		String sOutput = formatter.format(cTime.getTime());
		return sOutput;
	}
	
	/********************************************************************************************
	* convertUTCtoTimeZone
	*
	* This method takes a timestamp that is in UTC time and converts it to the display time zone
	* that is set in the category table under TimeZone, category value 2 = Display.
	* 
	* ***This method has been updated to work with dynamically setting the server time zone***
	* 
	*********************************************************************************************/	
	public String convertUTCtoTimeZone(Timestamp tsUTCTime) throws Exception {
		
		if (tsUTCTime == null ) {
			return "invalid time";
		}
		String sNew = getTimeZoneCategory();

		int iYear = getTimeStampValues(tsUTCTime, "year");
		int iMonth = getTimeStampValues(tsUTCTime, "month");
		int iDay = getTimeStampValues(tsUTCTime, "day");
		int iHour = getTimeStampValues(tsUTCTime, "hour");
		int iMinute = getTimeStampValues(tsUTCTime, "minute");
		int iSecond = getTimeStampValues(tsUTCTime, "second");
		
		Calendar cUTCTime = Calendar.getInstance();
		cUTCTime.clear();
		cUTCTime.setTimeZone(TimeZone.getTimeZone("UTC"));
		cUTCTime.set(iYear, iMonth - 1, iDay, iHour, iMinute, iSecond );
		
		DateFormat formatter = new SimpleDateFormat("dd MMM yyyy hh:mm a zzz");
		TimeZone tz = TimeZone.getTimeZone(sNew);
		formatter.setTimeZone(tz);
		
		String sOutput = formatter.format(cUTCTime.getTime());
		return sOutput;
	}
	
	/********************************************************************************************
	* convertTimeZoneFromUTC
	*
	* This method converts a UTC timestamp to a timestamp in the specified time zone (sTZtime)
	*
	*********************************************************************************************/	
	public String convertTimeZoneFromUTC(String sUTCTime, String sTZtime) throws Exception {
		
		if (sUTCTime == null ) {
			return "invalid time";
		}

		int iYear = getTimeStampValues(sUTCTime, "year");
		int iMonth = getTimeStampValues(sUTCTime, "month");
		int iDay = getTimeStampValues(sUTCTime, "day");
		int iHour = getTimeStampValues(sUTCTime, "hour");
		int iMinute = getTimeStampValues(sUTCTime, "minute");
		int iSecond = getTimeStampValues(sUTCTime, "second");
		
		Calendar cUTCTime = Calendar.getInstance();
		cUTCTime.clear();
		cUTCTime.setTimeZone(TimeZone.getTimeZone("UTC"));
		cUTCTime.set(iYear, iMonth - 1, iDay, iHour, iMinute, iSecond );
		
		DateFormat formatter = new SimpleDateFormat("yyyy'-'MM'-'dd'-'HH.mm.ss", Locale.US);
		TimeZone tz = TimeZone.getTimeZone(sTZtime);
		formatter.setTimeZone(tz);
		
		String sOutput = formatter.format(cUTCTime.getTime()) + ".00";

		return sOutput;
	}
	
	/********************************************************************************************
	* convertTimeZonetoUTC
	*
	*********************************************************************************************/	
	public String convertTimeZonetoUTC(String sUTCTime, String sTZtime) throws Exception {
		
		if (sUTCTime == null || !isValidTimeStamp(sUTCTime)) {
			return "invalid time";
		}

		int iYear = getTimeStampValues(sUTCTime, "year");
		int iMonth = getTimeStampValues(sUTCTime, "month");
		int iDay = getTimeStampValues(sUTCTime, "day");
		int iHour = getTimeStampValues(sUTCTime, "hour");
		int iMinute = getTimeStampValues(sUTCTime, "minute");
		int iSecond = getTimeStampValues(sUTCTime, "second");
		
		Calendar cUTCTime = Calendar.getInstance();
		cUTCTime.clear();
		cUTCTime.setTimeZone(TimeZone.getTimeZone(sTZtime));
		cUTCTime.set(iYear, iMonth - 1, iDay, iHour, iMinute, iSecond);
		
		DateFormat formatter = new SimpleDateFormat("yyyy'-'MM'-'dd'-'HH.mm.ss", Locale.US);
		TimeZone tz = TimeZone.getTimeZone("UTC");
		formatter.setTimeZone(tz);
		
		String sOutput = formatter.format(cUTCTime.getTime()) + ".00";

		return sOutput;
	}
	
	/********************************************************************************************
	* getTimeStampValues
	*
	*********************************************************************************************/	
	public int getTimeStampValues(Timestamp tsTimestamp, String sValue) throws Exception {
	
		int iReturnValue = getTimeStampValues(timeStampToString(tsTimestamp), sValue);
		
		return iReturnValue;	
	}
	
	/********************************************************************************************
	* getTimeStampValues
	*
	*********************************************************************************************/	
	public int getTimeStampValues(String sTimestamp, String sValue) throws Exception {
	
		int iReturnValue = 0;
		int iYear, iMonth, iDay, iHour, iMinute, iSecond;
		
		if (sTimestamp != null && !sTimestamp.equals("") && isValidTimeStamp(sTimestamp)) {
			iYear = Integer.parseInt((sTimestamp).substring(0,4));
			iMonth = Integer.parseInt((sTimestamp).substring(5,7));
			iDay = Integer.parseInt((sTimestamp).substring(8,10));
			iHour = Integer.parseInt((sTimestamp).substring(11,13));
			iMinute = Integer.parseInt((sTimestamp).substring(14,16));
			iSecond = Integer.parseInt((sTimestamp).substring(17,19));
			
			if (sValue.equals("year")) {
				iReturnValue = iYear;
			} else if (sValue.equals("month")) {
				iReturnValue = iMonth;
			} else if (sValue.equals("day")) {
				iReturnValue = iDay;
			} else if (sValue.equals("hour")) {
				iReturnValue = iHour;
			} else if (sValue.equals("minute")) {
				iReturnValue = iMinute;
			} else if (sValue.equals("second")) {
				iReturnValue = iSecond;
			}
		}
		
		return iReturnValue;	
	}
	
	/********************************************************************************************
	* getStringTimeStampValues
	*
	* This is an old method that was changed to getTimeStampValues. getStringTimeStampValues will
	* remain in order to be backwards compatible with files that still call the old method.
	* 
	*********************************************************************************************/	
	public int getStringTimeStampValues(String sTimestamp, String sValue) throws Exception {
			
		return getTimeStampValues(sTimestamp, sValue);
		
	}
	
	/********************************************************************************************
	* stringToTimestamp
	* 
	* ***This method has been updated to work with dynamically setting the server time zone***
	* 
	********************************************************************************************/
	private Timestamp stringToTimestamp( String sTimestamp ) throws Exception {
    	
		int iYearNew = getTimeStampValues(sTimestamp, "year");
		int iMonthNew = getTimeStampValues(sTimestamp, "month");
		int iDayNew = getTimeStampValues(sTimestamp, "day");
		int iHourNew = getTimeStampValues(sTimestamp, "hour");
		int iMinuteNew = getTimeStampValues(sTimestamp, "minute");
		int iSecondNew = getTimeStampValues(sTimestamp, "second");
		
		//String sServerTimeZone = myResources.getString("serverTimeZone");
		String sServerTimeZone = getServerTimeZoneCategory();
		TimeZone tz = TimeZone.getTimeZone(sServerTimeZone);
		Locale lc = new Locale("en", "US");
		Calendar cCal = Calendar.getInstance(tz, lc);
		cCal.clear();
		cCal.set(iYearNew, iMonthNew - 1, iDayNew, iHourNew, iMinuteNew, iSecondNew );
		long lTimeInMillis = cCal.getTime().getTime();
		Timestamp tsTimestamp = new Timestamp(lTimeInMillis);
		
		return tsTimestamp;
	}
	
	/********************************************************************************************
	* formatTime
	*
	*This method will format a String version of a timestamp into a readable formatted version
	*********************************************************************************************/	
	public String formatTime(String sTimeStamp) throws Exception {
		
		if (sTimeStamp == null ) {
			return "invalid time";
		}
		
		int iYear = getStringTimeStampValues(sTimeStamp, "year");
		int iMonth = getStringTimeStampValues(sTimeStamp, "month");
		int iDay = getStringTimeStampValues(sTimeStamp, "day");
		int iHour = getStringTimeStampValues(sTimeStamp, "hour");
		int iMinute = getStringTimeStampValues(sTimeStamp, "minute");
		//int iSecond = getStringTimeStampValues(sTimeStamp, "second");

		String sTempMonth = "";
		if (iMonth == 1) {
			sTempMonth = "Jan";
		} else if (iMonth == 2) {
			sTempMonth = "Feb";
		} else if (iMonth == 3) {
			sTempMonth = "Mar";
		} else if (iMonth == 4) {
			sTempMonth = "Apr";
		} else if (iMonth == 5) {
			sTempMonth = "May";
		} else if (iMonth == 6) {
			sTempMonth = "Jun";
		} else if (iMonth == 7) {
			sTempMonth = "Jul";
		} else if (iMonth == 8) {
			sTempMonth = "Aug";
		} else if (iMonth == 9) {
			sTempMonth = "Sep";
		} else if (iMonth == 10) {
			sTempMonth = "Oct";
		} else if (iMonth == 11) {
			sTempMonth = "Nov";
		} else if (iMonth == 12) {
			sTempMonth = "Dec";
		}
		String sTempYear = iYear + "";
		String sTempDay = iDay + "";
		if (sTempDay.length() == 1) {
			sTempDay = ("0" + sTempDay);
		}
		String sTempHour = iHour + "";
		if (sTempHour.length() == 1) {
			sTempHour = ("0" + sTempHour);
		}
		String sTempMinute = iMinute + "";
		if (sTempMinute.length() == 1) {
			sTempMinute = ("0" + sTempMinute);
		}
		String sOutput = (sTempDay + " " + sTempMonth + " " + sTempYear + " " + sTempHour + ":" + sTempMinute);
		return sOutput;
	}
	
	/********************************************************************************************
	* formatTimeStamp
	*
	*********************************************************************************************/	
	public String formatTimeStamp(Timestamp tsTime) throws Exception {
		
		if (tsTime == null ) {
			return "invalid time";
		}
		String sNew = "MST";

		int iYear = getTimeStampValues(tsTime, "year");
		int iMonth = getTimeStampValues(tsTime, "month");
		int iDay = getTimeStampValues(tsTime, "day");
		int iHour = getTimeStampValues(tsTime, "hour");
		int iMinute = getTimeStampValues(tsTime, "minute");
		int iSecond = getTimeStampValues(tsTime, "second");

		int iTempYear = iYear;
		String sTempMonth = "";
		if (iMonth == 0) {
			sTempMonth = "Dec";
			iTempYear = iTempYear - 1;
		} else if (iMonth == 1) {
			sTempMonth = "Jan";
		} else if (iMonth == 2) {
			sTempMonth = "Feb";
		} else if (iMonth == 3) {
			sTempMonth = "Mar";
		} else if (iMonth == 4) {
			sTempMonth = "Apr";
		} else if (iMonth == 5) {
			sTempMonth = "May";
		} else if (iMonth == 6) {
			sTempMonth = "Jun";
		} else if (iMonth == 7) {
			sTempMonth = "Jul";
		} else if (iMonth == 8) {
			sTempMonth = "Aug";
		} else if (iMonth == 9) {
			sTempMonth = "Sep";
		} else if (iMonth == 10) {
			sTempMonth = "Oct";
		} else if (iMonth == 11) {
			sTempMonth = "Nov";
		} else if (iMonth == 12) {
			sTempMonth = "Dec";
		}
		String sTempYear = iTempYear + "";
		String sTempDay = iDay + "";
		if (sTempDay.length() == 1) {
			sTempDay = ("0" + sTempDay);
		}
		String sTempHour = iHour + "";
		if (sTempHour.length() == 1) {
			sTempHour = ("0" + sTempHour);
		}
		String sTempMinute = iMinute + "";
		if (sTempMinute.length() == 1) {
			sTempMinute = ("0" + sTempMinute);
		}
		String sOutput = (sTempDay + " " + sTempMonth + " " + sTempYear + " " + sTempHour + ":" + sTempMinute + " " + sNew);

		return sOutput;
	}
	
	/********************************************************************************************
	* addLeadingZero
	*
	* This method will add one leading zero to a date/time value if it is needed. This is used
	* in jsp files that require a leading zero.
	********************************************************************************************/	
	public String addLeadingZero(String s) throws Exception {
			
		if(s != null && s.length() == 1) {
			s = "0" + s;
		}
		
		return s;
	}
	
		
	/********************************************************************************************
	* getServerTimestampSQL
	*
	* This method takes no arguments and returns a Timestamp. It will get the current date and
	* time and create a Timestamp in the server timezone.  It then returns this timestamp in a
	* format suitable for SQL.
	********************************************************************************************/	
	public String getServerTimestampSQL() throws Exception {
			
		//String sServerTimeZone = myResources.getString("serverTimeZone");
		//int iTimeDiff = Integer.parseInt(myResources.getString("UTCTimeDiff"));
		String sServerTimeZone = getServerTimeZoneCategory();
		
		TimeZone tz = TimeZone.getTimeZone(sServerTimeZone);
		Locale lc = new Locale("en", "US");
		Calendar rightNow = Calendar.getInstance(tz, lc);
		
		long lTimeInMillis = rightNow.getTime().getTime();
		Timestamp tsTimestamp = new Timestamp(lTimeInMillis);
		
		String sTimestamp = tsTimestamp + "";
		
		int iYear = getStringTimeStampValues(sTimestamp, "year");
		int iMonth = (getStringTimeStampValues(sTimestamp, "month"));
		int iDay = getStringTimeStampValues(sTimestamp, "day");
		int iHour = getStringTimeStampValues(sTimestamp, "hour");
		int iMinute = getStringTimeStampValues(sTimestamp, "minute");
		int iSecond = getStringTimeStampValues(sTimestamp, "second");
		
		Calendar cUTCTime = Calendar.getInstance();
		cUTCTime.clear();
		cUTCTime.setTimeZone(TimeZone.getTimeZone(sServerTimeZone));
		cUTCTime.set(iYear, iMonth - 1, iDay, iHour, iMinute, iSecond );
		
		DateFormat formatter = new SimpleDateFormat("yyyy'-'MM'-'dd'-'HH.mm.ss", Locale.US);
		TimeZone tz2 = TimeZone.getTimeZone(sServerTimeZone);
		formatter.setTimeZone(tz2);
		
		String sOutput = formatter.format(cUTCTime.getTime()) + ".00";

		return sOutput;
	}

}