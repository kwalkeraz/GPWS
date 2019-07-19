var current_plugin_version = "41"; // This must only be numbers, no periods or other non-numeric characters.
var current_widget_version = "31"; // This must only be numbers, no periods or other non-numeric characters.
var min_IE_version = "6"; // The minimum IE version. This must be numbers only, no periods or other non-numeric characters.
var min_FF_version = "3"; // The minimum FF version. This must be numbers only, no periods or other non-numeric characters.
var install_url = "./servlet/printeruser.wss?to_page_id=30";
var win_plugin_url = "/tools/print/Win32Plugin.html";
var lx_plugin_url = "/tools/print/LinuxPlugin.html";
var lx_freegpws_url = "/tools/print/LinuxPlugin-FreeGpws.html";
var browser_url = "/tools/print/browsers.html";
var os_url = "/tools/print/SupportedOperatingSystems.html";
//var userAgentValue = navigator.userAgent.toLowerCase();
var OS,browser,bversion,osversion,total,thevalue;

var unsupported_os="You are using an unsupported Operating System";
var browser_backlevel="Your browser is too backlevel. Please install at least Internet Explorer 6+ or Firefox 3+";
var unsupported_browser="You are using a browser that is not supported by GPWS. It may or may not work properly.";
var unsupported_browser_64="Internet Explorer 64 bit is not supported. Please use the 32 bit version.";
var old_plugin_installed="The Global Print plug-in is not installed on your system or is an old version. In order to install printers, you must have the latest version installed. Click OK to get the plug-in now.";
var plugin_not_installed="The Global Print plug-in is not installed on your system. In order to install printers, you must have this plugin installed. Click OK to get the plug-in now.";
var error_check="There was an error checking your OS and browser. Try refreshing the page to see if that fixes the problem. If the problem persists, confirm that you are using a supported operating system and browser.";


function initialize() {

	OS = getOS();
	osversion = getOSVersion();
	browser = getBrowser();
	bversion = getBVersion();
	//bversion1 = bversion.charAt(0);
	bversion1 = parseInt(bversion.substring(0,bversion.indexOf('.',0)));
}

function executeOS() {
	if (osversion.indexOf("Windows 7") >= 0) {
		if (browser == "Firefox") {
			displayInstructs('Windows 7','FF');
		} else if (browser == "Internet Explorer") {
			if (bversion.indexOf('64 bit') >= 0) {
				displayInstructs('Windows 7','IE64');
			} else {
				displayInstructs('Windows 7','IE');
			}
		} else {
			displayInstructs('Windows 7','INVALID');
		}
	} else if (osversion.indexOf("Windows XP") >= 0) {
		if (browser == "Firefox") {
			displayInstructs('Windows XP','FF');
		} else if (browser == "Internet Explorer") {
			if (bversion1 < min_IE_version) {
				document.getElementById("instructions").innerHTML = "Your version of Internet Explorer is too old. Please upgrade to IE version 6 or later to install a printer.";
			} else {
				displayInstructs('Windows XP','IE');
			}
		} else {
			displayInstructs('Windows XP','INVALID');
		}
	} else if (osversion == "Ubuntu") {
		if (browser == "Firefox") {
			displayInstructs('OCDC','FF');
		}
	} else if (OS == "Mac") {
		displayInstructs("InvalidOS","Mac OS");
	} else if (OS == "UNIX") {
		displayInstructs("InvalidOS","Unix");
	} else if (OS == "Android") {
		displayInstructs("InvalidOS","Android");
	} else if (OS == "iOS") {
		displayInstructs("InvalidOS","iOS");
	} else if (OS == "RIM") {
		displayInstructs("InvalidOS","RIM");
	} else if (OS == "unknown") { 
		displayInstructs("unknown","");
	} else if ((browser == "Internet Explorer" && bversion1 < min_IE_version) || (browser == "Firefox" && bversion1 < min_FF_version)) { //reject below version IE6 and FF3

		document.getElementById("instructions").innerHTML = "IE v5 or less";

	} else if (browser == "Internet Explorer" && bversion.indexOf("64 bit") >= 0) { // IE 64 bit

		document.getElementById("instructions").innerHTML = "<h1>Instructions for Internet Explorer 64 bit</h1>";
		
		document.getElementById("instructions").appendChild = "<p>How to install a printer using IE 64 bit.</p>";

	} else if (browser == "Chrome") { //Reject Chrome

		displayInstructs("InvalidBrowser","Chrome");

	} else if (browser == "Safari") { //reject Safari

		displayInstructs("InvalidBrowser","Safari");

	} else if ((browser == "Netscape Navigator" || browser == "Firefox") && OS == 'Windows') { //Check Windows plugin in Firefox

		if (osversion.indexOf('7') >= 0) {
			// Windows 7
			displayInstructs('Windows 7','FF');
		} else if (osversion.indexOf('XP') >= 0) {
			// Windows XP
			displayInstructs('Windows XP','FF');
		}
		
	} else if ((browser == "Netscape Navigator" || browser == "Firefox") && OS == 'Linux') { // Check Linux plugin in Firefox

		displayInstructs("OCRH","FF");

	} else if ((browser == "Netscape Navigator" || browser == "Firefox") && OS == 'Ubuntu') { // Check Linux plugin in Firefox

		displayInstructs("OCDC","FF");
		
	} else if (browser == "Opera" && OS == 'Windows') { // Check Opera plugin in Windows
	
		displayInstructs("InvalidBrowser","Opera");
		
	} else {
		displayInstructs("unknown","");
	}
} //function executeOS

function displayInstructs(OpSys, Brows) {

	document.getElementById("instructions").innerHTML = "";

	if (OpSys == "Windows 7") {
		if (Brows == "IE") {
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Internet Explorer on Windows 7</h2>" +
			"<ol><li><p>Upon clicking the blue installation button, if the Global Print object is not installed, you will get a prompt to install it.<br /><br /><b>IE 7 and 8 users:</b> Click the prompt at the top of IE and select 'Install This Add-on for All Users on This Computer...'" + 
			"<img src='/tools/print/images/IE-object-install.jpg' /></li>" +
			"<b>IE 9 users:</b> Click the install button in the prompt at the bottom of IE." +
			"<img src='/tools/print/images/IE9-object-install.jpg' /></li>" +
			"<li><p>After installing the object, you will get a User Account Control (UAC) prompt asking if you would like to allow IBM Global Print plugin to make changes to your computer. Click 'Yes'. Note: Some users may have different UAC settings that will require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-GP-prompt.jpg' /></li>" +
			"<li><p>After accepting the UAC prompt, you will get another User Account Control (UAC) prompt asking if you would like to allow Rundll32 to make  changes to your computer. Click 'Yes'. Note: Some users may have different UAC settings that will require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' /></li>" +
			"<li><p>After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the Start button to begin the printer installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "IE64") {
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Internet Explorer 64 bit on Windows 7</h2>" +
			"<ol><li><p>Upon clicking the blue installation button, if the Global Print object is not installed, you will get a prompt to install it.<br /><br /><b>IE 7 and 8 users:</b>  Click the prompt and select 'Install This Add-on for All Users on This Computer...'</p>" + 
			"<img src='/tools/print/images/IE64-object-install.jpg' /></li>" +
			"<b>IE 9 users:</b> Click the install button in the prompt at the bottom of IE." +
			"<img src='/tools/print/images/IE9-64-object-install.jpg' /></li>" +
			"<li><p>After installing the object, you will get a User Account Control (UAC) prompt asking if you would like to allow IBM Global Print plugin 64 bit to make changes to your computer. Click 'Yes'. Note: Some users may have different UAC settings that will require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-GP64-prompt.jpg' /></li>" +
			"<li><p>After accepting the UAC prompt, you will get another User Account Control (UAC) prompt asking if you would like to allow Rundll32 to make changes to your computer. Click 'Yes'. Note: Some users may have different UAC settings that will require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' /></li>" +
			"<li><p>After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the Start button to begin the printer installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "FF") {
			// display Win7-FF
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Firefox on Windows 7</h2>" +
			"<ol><li><p>Upon clicking the blue installation button, you will get a User Account Control (UAC) prompt asking if you would like to allow Rundll32 to make changes to your computer. Click 'Yes'. Note: Some users may have different UAC settings that will require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' /></li>" +
			"<p><br /><li>After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the Start button to begin the printer installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<p><br /><li>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<p><br /><br />You are running either an unsupported or unknown browser.</p>";
		}
	} else if (OpSys == "Windows XP") {
		if (Brows == "IE") {
			// display WinXP-IE
			// Has been tested with IE 8.
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Internet Explorer on Windows XP</h2>" +
			"<ol><li><p>Upon clicking the blue installation button, if the Global Print object is not installed, you will get a prompt to install it. Click the 'Install' button on the prompt." + 
			"<img src='/tools/print/images/IE-XP-object-install.jpg' /></li>" +
			"<li><p>After clicking the install button, you will be presented with the Global Print plugin. Click the Start button to begin the printer installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "FF") {
			// display WinXP-FF
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Firefox on Windows XP</h2>" +
			"<ol><li><p>Upon clicking the blue installation button, you will be presented with the Global Print plugin. Click the Start button to begin the printer installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<p><br /><br />You are running either an unsupported or unknown browser. </p>";
		}
	} else if (OpSys == "OCRH") {
		// display OCRH
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client Red Hat Enterprise Linux</h2>" +
		"<p><br /><br />Open Client Red Hat is supported by the Open Client team. Please see their <a target='_blank' href='http://d02ntcl02.ibm.com/Content/View/1/3aae501d-7e4e-4dbd-9652-c3704c0416ac/open_client_linux_global_printing_guide_linux'>IT Help Central page</a> for instructions on how to install a printer on Red Hat.</p>";
		
	} else if (OpSys == "OCDC") {
		// display OCDC-FF
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client Debian Linux</h2>" +
		"<p><br /><br />Open Client Debian is supported by the Open Client team. Please see their <a target='_blank' href='http://d02ntcl02.ibm.com/Content/View/1/3aae501d-7e4e-4dbd-9652-c3704c0416ac/open_client_linux_global_printing_guide_linux'>IT Help Central page</a> for instructions on how to install a printer on Ubuntu.</p>";
		
	} else if (OpSys == "InvalidOS") {
		document.getElementById("instructions").innerHTML = "<p><br /><br />" + Brows + " is an unsupported operating system. Printer installs will not work for your system.</p>";
	} else if (OpSys == "InvalidBrowser") {
		document.getElementById("instructions").innerHTML = "<p><br /><br />" + Brows + " is an unsupported browser. Use a supported browser in order to install a printer.</p>";
	} else {
		document.getElementById("instructions").innerHTML = "<p><br /><br />We were unable to detect your operating system and therefore cannot provide instructions on how to install a printer.</p>";
	}
}