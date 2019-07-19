 function formatDatey4M2d2(dateString) {
	//convert to yyyy-MM-dd
	//dateString is a string variable
 	var dateFormat = "";
 	if (dateString != "" && dateString != null) {
	 	var dArr = dateString.split("/"); 
	 	dateFormat = dArr[2]+ "-" +dArr[1]+ "-" +dArr[0];
 	} //if
 	return dateFormat;
 } //formatDateyMd
 
 function formatDated2M2y4(date){
	//convert to dateformat dd/MM/yyyy
	//dateString is a date variable
 	var dateFormat = "";
 	if (date != "" && date != null) {
	 	var dateObj = dojo.date.stamp.fromISOString(date);
		dateFormat = dojo.date.locale.format(dateObj, {datePattern: "dd/MM/yyyy", selector: "date"});
 	} //if
	return dateFormat;
 } //formatDatedMy