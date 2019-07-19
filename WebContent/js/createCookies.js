/*
 *  This allows you to create,get and check for cookies using javascript
 */

	// Create a cookie based on the information provided
	// @params
	// cname - The name of the cookie
	// cvalue - The value of the cookie
	// exdays - The number of days before it expires (i.e. 7 days)
	function setCookie(cname, cvalue, exdays) {
	    var d = new Date();
	    d.setTime(d.getTime() + (exdays*24*60*60*1000));
	    var expires = "expires="+d.toUTCString();
	    document.cookie = cname + "=" + cvalue + "; " + expires;	    
	 }
	
	 //Get cookie information
	 //@param
	 // cname - The name of the cookie
	 // returns the value of that cookie if exists
	 function getCookie(cname) {
	    var name = cname + "=";
	    var ca = document.cookie.split(';');
	    for(var i=0; i<ca.length; i++) {
	        var c = ca[i];
	        while (c.charAt(0)==' ') c = c.substring(1);
	        //console.log("final value is " + c.substring(name.length, c.length));
	        if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
	    }
	    return "";
	 }
	
	 //Check to see if a cookie exists
	 //@param
	 //cname - The name of the cookie
	 //returns the name of the cookie
	 function checkCookie(cname) {
	    var name = getCookie(cname);
	    //if (name == "" || name == null) {
	    //	setCookie(cname, cvalue, 31449600);
	    //}
	    //check the cookie name, if it has a value, return it
	    return name;
	 }