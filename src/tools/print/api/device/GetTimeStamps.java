package tools.print.api.device;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
* Constructs an timestamp string.  Should only be used in conjuction with the Devices REST servlet
* @params
*  
	
* @author Gerardo Nunez
*
*/

public class GetTimeStamps {
	public static String todaysDate() {
		//Return today's date in this format 2015-08-21
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		Date date =  new Date();
		String todaysDate = sdf.format(date).toString();
		//System.out.println("Today's time on my localhost is " + todaysDate );
		return todaysDate;
	}
}
