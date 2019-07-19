<%
//	This routine retrieves the current date and time from the system.
//
//	Outputs are Strings containing the current values in the following formats:
//		CurrentDateTime - 01 Jan 2006 01:01
//		CurrentDate - 01 Jan 2006
//		CurrentTime - 01:01
//		CurrentYear - 2006
//		CurrentMonth - 01
//		CurrentMonthLit - Jan
//		CurrentDay - 01
//		CurrentHour - 01
//		CurrentMinute - 01
//		CurrentSecond - 01
//
//	The following integer values are also available:
//		YearVal
//		MonthVal
//		DayVal
//		HourVal
//		MinuteVal
//		SecondVal

	DateTime dateTime = new DateTime();
	Timestamp rightNow = dateTime.getSQLTimestamp();

	int YearVal = dateTime.getTimeStampValues(rightNow, "year");
	int MonthVal = dateTime.getTimeStampValues(rightNow, "month");
	int DayVal = dateTime.getTimeStampValues(rightNow, "day");
	int HourVal = dateTime.getTimeStampValues(rightNow, "hour");
	int MinuteVal = dateTime.getTimeStampValues(rightNow, "minute");
	int SecondVal = dateTime.getTimeStampValues(rightNow, "second"); 

	String CurrentYear = String.valueOf(YearVal);
	String CurrentMonth = String.valueOf(MonthVal);
	if (MonthVal <= 9) { CurrentMonth = "0" + CurrentMonth; }
	String CurrentDay = String.valueOf(DayVal);
	if (DayVal <= 9) { CurrentDay = "0" + CurrentDay; }
	String CurrentHour = String.valueOf(HourVal);
	if (HourVal <= 9) { CurrentHour = "0" + CurrentHour; }
	String CurrentMinute = String.valueOf(MinuteVal);
	if (MinuteVal <= 9) { CurrentMinute = "0" + CurrentMinute; }
	String CurrentSecond = String.valueOf(SecondVal);
	if (SecondVal <= 9) { CurrentSecond = "0" + CurrentSecond; }

	String CurrentMonthLit = "";
	if (MonthVal == 1) { CurrentMonthLit = "Jan"; }
	else if (MonthVal == 2) { CurrentMonthLit = "Feb"; }
	else if (MonthVal == 3) { CurrentMonthLit = "Mar"; }
	else if (MonthVal == 4) { CurrentMonthLit = "Apr"; }
	else if (MonthVal == 5) { CurrentMonthLit = "May"; }
	else if (MonthVal == 6) { CurrentMonthLit = "Jun"; }
	else if (MonthVal == 7) { CurrentMonthLit = "Jul"; }
	else if (MonthVal == 8) { CurrentMonthLit = "Aug"; }
	else if (MonthVal == 9) { CurrentMonthLit = "Sep"; }
	else if (MonthVal == 10) { CurrentMonthLit = "Oct"; }
	else if (MonthVal == 11) { CurrentMonthLit = "Nov"; }
	else if (MonthVal == 12) { CurrentMonthLit = "Dec"; }
	
	//String CurrentDate = CurrentDay + " " + CurrentMonthLit + " " + CurrentYear;
	String CurrentDate = CurrentDay + "/" + CurrentMonth + "/" + CurrentYear;
	String CurrentTime = CurrentHour + ":" + CurrentMinute;
	String CurrentDateTime = CurrentDate + " " + CurrentTime; 
%>