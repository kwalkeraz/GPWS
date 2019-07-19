<?xml version="1.0" encoding="UTF-8" ?><%@ page contentType="application/xml" %><%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %><%
	
 	AppTools appTool = new AppTools();
	DateTime dateTime = new DateTime();
	
	PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
	String sTZ = pupb.getTimeZone();

	String sDate1 = appTool.nullStringConverter(request.getParameter("date1"));
	String sDate2 = appTool.nullStringConverter(request.getParameter("date2"));
	
	boolean validDate1 = false;
	boolean validDate2 = false;
	
	int iYear1 = 0;
	int iMonth1 = 0;
	int iDay1 = 0;
	int iHour1 = 0;
	int iMinute1 = 0;
	int iDayOfWeek1 = 0;
	String sDayOfWeek1 = "";
	String sRelation1 = "";
	long lNumDaysDiff1 = 0;
	
	int iYear2 = 0;
	int iMonth2 = 0;
	int iDay2 = 0;
	int iHour2 = 0;
	int iMinute2 = 0;
	int iDayOfWeek2 = 0;
	String sDayOfWeek2 = "";
	String sRelation2 = "";
	long lNumDaysDiff2 = 0;
	
try {
	
	if (sDate1 != null && sDate1.length() == 16) {
		validDate1 = true;
		sDate1 += "-00";
		
		iYear1 = dateTime.getStringTimeStampValues(sDate1, "year");
		iMonth1 = dateTime.getStringTimeStampValues(sDate1, "month");
		iDay1 = dateTime.getStringTimeStampValues(sDate1, "day");
		iHour1 = dateTime.getStringTimeStampValues(sDate1, "hour");
		iMinute1 = dateTime.getStringTimeStampValues(sDate1, "minute");
		
		// Set day of week for date1
		Calendar dt1 = Calendar.getInstance();
		dt1.clear();
		
		if (sTZ == null || sTZ == "") {
			dt1.setTimeZone(TimeZone.getTimeZone("GMT"));
		} else {
			dt1.setTimeZone(TimeZone.getTimeZone(sTZ));
		}
		dt1.set(iYear1, iMonth1 - 1, iDay1, iHour1, iMinute1, 0);
		
		iDayOfWeek1 = dt1.get(Calendar.DAY_OF_WEEK);
		
		if (iDayOfWeek1 > 0 ) {
			
		}
		switch (iDayOfWeek1) {
			case 1: sDayOfWeek1 = "Sunday";
					break;
			case 2: sDayOfWeek1 = "Monday";
					break;
			case 3: sDayOfWeek1 = "Tuesday";
					break;
			case 4: sDayOfWeek1 = "Wednesday";
					break;
			case 5: sDayOfWeek1 = "Thursday";
					break;
			case 6: sDayOfWeek1 = "Friday";
					break;
			case 7: sDayOfWeek1 = "Saturday";
					break;
		}
		
		if (sDate2 != null && sDate2.length() == 16) {
	
			validDate2 = true;
			sDate2 += "-00";
			iYear2 = dateTime.getStringTimeStampValues(sDate2, "year");
			iMonth2 = dateTime.getStringTimeStampValues(sDate2, "month");
			iDay2 = dateTime.getStringTimeStampValues(sDate2, "day");
			iHour2 = dateTime.getStringTimeStampValues(sDate2, "hour");
			iMinute2 = dateTime.getStringTimeStampValues(sDate2, "minute");
			
			//Set Day of week for date2
			Calendar dt2 = Calendar.getInstance();
			dt2.clear();
			
			if (sTZ == null || sTZ == "") {
				dt2.setTimeZone(TimeZone.getTimeZone("GMT"));
			} else {
				dt2.setTimeZone(TimeZone.getTimeZone(sTZ));
			}
			dt2.set(iYear2, iMonth2 - 1, iDay2, iHour2, iMinute2, 0);
			
			iDayOfWeek2 = dt2.get(Calendar.DAY_OF_WEEK);
			
			if (iDayOfWeek2 > 0 ) {
				
			}
			switch (iDayOfWeek2) {
				case 1: sDayOfWeek2 = "Sunday";
						break;
				case 2: sDayOfWeek2 = "Monday";
						break;
				case 3: sDayOfWeek2 = "Tuesday";
						break;
				case 4: sDayOfWeek2 = "Wednesday";
						break;
				case 5: sDayOfWeek2 = "Thursday";
						break;
				case 6: sDayOfWeek2 = "Friday";
						break;
				case 7: sDayOfWeek2 = "Saturday";
						break;
			}
			
			// Set Relation for both
			if (dt1.getTimeInMillis() > dt2.getTimeInMillis()) {
				sRelation1 = "after";
				sRelation2 = "before";
			} else if (dt1.getTimeInMillis() < dt2.getTimeInMillis()) {
				sRelation1 = "before";
				sRelation2 = "after";
			} else {
				sRelation1 = "equal";
				sRelation2 = "equal";
			}
			
			// Set number of days difference for both
			dt1.set(Calendar.HOUR, 8);
			dt1.set(Calendar.MINUTE, 0);
			dt1.set(Calendar.MILLISECOND, 0);
			dt2.set(Calendar.HOUR, 8);
			dt2.set(Calendar.MINUTE, 0);
			dt2.set(Calendar.MILLISECOND, 0);
			lNumDaysDiff1 = (dt2.getTimeInMillis() - dt1.getTimeInMillis()) / (1000 * 60 * 60 * 24);
			lNumDaysDiff2 = (dt1.getTimeInMillis() - dt2.getTimeInMillis()) / (1000 * 60 * 60 * 24);
		}
	}

} catch (Exception e) {
	System.out.println("Error: " + e); %>
	<Error>Error: <%= e %></Error><%
}
%>
<Dates>
<% if (validDate1 == true ) { %>
<Date1>
	<Year><%= iYear1 %></Year>
	<Month><%= iMonth1 %></Month>
	<Day><%= iDay1 %></Day>
	<Hour><%= iHour1 %></Hour>
	<Minute><%= iMinute1 %></Minute>
	<DayOfWeek><%= sDayOfWeek1 %></DayOfWeek>
	<Relation><%= sRelation1 %></Relation>
	<NumDaysDifference><%= lNumDaysDiff1 %></NumDaysDifference>
</Date1>
<% } 
if (validDate2 == true ) { %> 
<Date2>
	<Year><%= iYear2 %></Year>
	<Month><%= iMonth2 %></Month>
	<Day><%= iDay2 %></Day>
	<Hour><%= iHour2 %></Hour>
	<Minute><%= iMinute2 %></Minute>
	<DayOfWeek><%= sDayOfWeek2 %></DayOfWeek>
	<Relation><%= sRelation2 %></Relation>
	<NumDaysDifference><%= lNumDaysDiff2 %></NumDaysDifference>
</Date2>
<% } 

if (validDate1 == false && validDate2 == false) { %>
	<Error>Invalid date</Error>
<% } %>
</Dates>