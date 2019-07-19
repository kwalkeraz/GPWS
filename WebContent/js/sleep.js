//This function performs a sleep routing if you wish to stop certain functions for a period of time
//@param sec - The number of seconds you which to pause
//
function sleep(sec) {
	var date = new Date();
	var curDate = null;
	while(curDate-date < (sec * 1000)) {
		curDate = new Date();
	} //while
 } //sleep