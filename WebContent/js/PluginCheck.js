// These variables must be kept up to date with the latest version numbers
var current_plugin_version = "45"; // This must only be numbers, no periods or other non-numeric characters.
var current_widget_version = "41"; // This must only be numbers, no periods or other non-numeric characters.
var min_IE_version = "6"; // The minimum IE version. This must be numbers only, no periods or other non-numeric characters.
var min_FF_version = "3"; // The minimum FF version. This must be numbers only, no periods or other non-numeric characters.

var user_plugin_version = "";
var validPlugin = "false";

var install_url = "./servlet/printeruser.wss?to_page_id=30";
var win_plugin_url = "/tools/print/Win32Plugin.html";
var lx_plugin_url = "/tools/print/LinuxPlugin.html";
var lx_freegpws_url = "/tools/print/LinuxPlugin-FreeGpws.html";
var browser_url = "/tools/print/browsers.html";
var os_url = "/tools/print/SupportedOperatingSystems.html";
//var userAgentValue = navigator.userAgent.toLowerCase();
var OS,browser,bversion,osversion,total,thevalue;



var win_plugin_url = "/tools/print/Win32Plugin.html";
var lx_plugin_url = "/tools/print/LinuxPlugin.html";
var lx_freegpws_url = "/tools/print/LinuxPlugin-FreeGpws.html";
var browser_url = "/tools/print/browsers.html";
var os_url = "/tools/print/SupportedOperatingSystems.html";
//var userAgentValue = navigator.userAgent.toLowerCase();
var OS,browser,bversion,osversion,total,thevalue;


function checkPluginLevel() {
	
		navigator.plugins.refresh(false)
		mimetype=navigator.mimeTypes["application/x-cpsweb"]
		if (mimetype) {
		    plugin=mimetype.enabledPlugin
			if (plugin) {
				y = "";
		        //x = navigator.plugins["IBM CPSWEB"];
				plug42 = navigator.plugins["IBM Global Print"];
				plug41 = navigator.plugins["IBM GLOBAL PRINT"];

		        if (plug42 != null) {
		        	y = plug42.description;
		        } else if (plug41 != null) {
					y = plug41.description;
				}
		        if (y != null) {
					z = y.indexOf('.')
		        	if(y.charAt(z-1) + y.charAt(z+1) < current_plugin_version) {  // Check to see if user has old plugin
		        		validPlugin = "false";
			    	} else {
			    		//correct plugin installed
			    		validPlugin = "true";
			    	}
				} else {
					//plugin not installed
					validPlugin = "false";
				}
			} else {
		       		//plugin not installed
				validPlugin = "false";
			} // end if (plugin)
		} else {
			validPlugin = "false";
		} // end if (mimetype)
}
