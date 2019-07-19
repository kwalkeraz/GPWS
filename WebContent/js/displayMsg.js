function displaywaitMsg(fieldName) {
//Displays a wait message
//@param fieldName - ID tag of the field to display
	var position = "";
	var initpix = 100;
	if (navigator.appName == "Microsoft Internet Explorer") {
		position = (document.documentElement.scrollTop * 2);
		if (position == 0 || position <= initpix) {
			position = (position + initpix);
		}
	} else {
		position = (window.pageYOffset * 2);
		if (position == 0 || position <= initpix) {
			position = (position + initpix);
		}
			position = position + "px";
	}
	document.getElementById(fieldName).style.top = position;
	unhide_fields(fieldName);
} 