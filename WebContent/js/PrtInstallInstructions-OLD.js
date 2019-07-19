var min_IE_version = "6"; // The minimum IE version. This must be numbers only, no periods or other non-numeric characters.
var min_FF_version = "3"; // The minimum FF version. This must be numbers only, no periods or other non-numeric characters.
var win_plugin_url = "/tools/print/Win32Plugin.html";
var lx_plugin_url = "/tools/print/LinuxPlugin.html";
var lx_freegpws_url = "/tools/print/LinuxPlugin-FreeGpws.html";
var browser_url = "/tools/print/browsers.html";
var os_url = "/tools/print/SupportedOperatingSystems.html";
//var userAgentValue = navigator.userAgent.toLowerCase();
var OS,browser,bversion,osversion,total,thevalue;

var unsupported='You are running either an unsupported or unknown browser. Printers cannot be installed on your system. Please refer to the <a href="' + os_url + '">Supported Operating Systems</a> and <a href="' + browser_url + '">Supported Browsers</a> pages for details.';
var ie_backlevel="Your version of Internet Explorer is too old. Please upgrade to Internet Explorer version 6 or later to install a printer.";
var ff_backlevel="Your version of Firefox is too old. Please upgrade to FireFox version 3 or later to install a printer."

var click_blue_install_button="Once you have clicked on the blue <b>Install printer-name</b> button (e.g. <img src='/tools/print/images/install-button.jpg' /> ), the install process will begin.";
var uac_gpws="Click <b>Yes</b> in response to the User Account Control (UAC) window prompting you to allow the IBM Global Print v4.1 64 bit to make changes to your computer. Enter your password if prompted to do so.";
var uac_rundll="Click <b>Yes</b> in response to the User Account Control (UAC) window prompting you to allow the Windows Host Process (Rundll32) to make changes to your computer. Enter your password if prompted to do so.";
var win7_install="After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the <b>Start</b> button to begin the printer installation."
var install_prob_note="Note: If you experience a problem with the printer installation, you should be redirected to the <a href='WebInstallErrors.html'>Problems with printer installation</a> page for troubleshooting suggestions.";
var install_done="Once the installation is complete, a message will indicate that the printer was installed. Click on <b>Done</b> to exit.";

function initialize() {

	OS = getOS();
	osversion = getOSVersion();
	browser = getBrowser();
	bversion = getBVersion();
	//bversion1 = bversion.charAt(0);
	bversion1 = parseInt(bversion.substring(0,bversion.indexOf('.',0)));

	if (OS == "Linux" && osversion == "Linux") {
		osversion = "Red Hat";
	}
}

function executeOS() {
	
	// WINDOWS 7
	if (osversion.indexOf("Windows 7") >= 0) {
		if (browser == "Firefox") {
			if (bversion1 < min_FF_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ff_backlevel + "</p>";
			} else {
				displayInstructs('Windows 7','FF');
			}
		} else if (browser == "Internet Explorer") {
			if (bversion1 < min_IE_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ie_backlevel + "</p>";
			} else {
				if (bversion.indexOf('64 bit') >= 0) {
					displayInstructs('Windows 7','IE64');
				} else {
					displayInstructs('Windows 7','IE');
				}
			}
		} else if (browser == "Chrome" || browser == "Safari" || browser == "Opera") { //Reject Chrome, Safari and Opera

			displayInstructs("InvalidBrowser","");

		} else {
			displayInstructs('Windows 7','INVALID');
		}
	// WINDOWS XP
	} else if (osversion.indexOf("Windows XP") >= 0) {

		if (browser == "Firefox") {
			if (bversion1 < min_FF_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ff_backlevel + "</p>";
			} else {
				displayInstructs('Windows XP','FF');
			}
		} else if (browser == "Internet Explorer") {
			if (bversion1 < min_IE_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ie_backlevel + "</p>";
			} else {
				displayInstructs('Windows XP','IE');
			}
		} else if (browser == "Chrome" || browser == "Safari" || browser == "Opera") { //Reject Chrome, Safari and Opera

			displayInstructs("InvalidBrowser","");
		} else {
			displayInstructs('Windows XP','INVALID');
		}

	} else if (osversion == "Ubuntu") {

		if (browser == "Firefox") {
			displayInstructs('OCDC','FF');
		}

	} else if (osversion == "Red Hat") {

		if (browser == "Firefox") {
			displayInstructs('OCRH','FF');
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
		
	} else {
		displayInstructs("unknown","");
	}

} //function executeOS


function displayInstructs(OpSys, Brows) {

	document.getElementById("instructions").innerHTML = "";

	if (OpSys == "Windows 7") {
		if (Brows == "IE") {
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Internet Explorer on Windows 7</h2>" +
			"<ol><li><p>" + click_blue_install_button + " If the Global Print object is not installed, you will get a prompt to install it.<br /><br /><b>IE 7 and 8 users:</b> Click the prompt at the top of IE and select 'Install This Add-on for All Users on This Computer...'" + 
			"<img src='/tools/print/images/IE-object-install.jpg' /></li>" +
			"<b>IE 9 users:</b> Click the install button in the prompt at the bottom of IE." +
			"<img src='/tools/print/images/IE9-object-install.jpg' /></li>" +
			"<li><p>" + uac_gpws + "</p>" + 
			"<img src='/tools/print/images/UAC-GP-prompt.jpg' /></li>" +
			"<li><p>" + uac_rundll + "</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' /></li>" +
			"<li><p>" + win7_install + "<br />" + install_prob_note + "</p></p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "IE64") {
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Internet Explorer 64 bit on Windows 7</h2>" +
			"<ol><li><p>" + click_blue_install_button + " If the Global Print object is not installed, you will get a prompt to install it.<br /><br /><b>IE 7 and 8 users:</b>  Click the prompt and select 'Install This Add-on for All Users on This Computer...'</p>" + 
			"<img src='/tools/print/images/IE64-object-install.jpg' /></li>" +
			"<b>IE 9 users:</b> Click the install button in the prompt at the bottom of IE." +
			"<img src='/tools/print/images/IE9-64-object-install.jpg' /></li>" +
			"<li><p>" + uac_gpws + "</p>" + 
			"<img src='/tools/print/images/UAC-GP64-prompt.jpg' /></li>" +
			"<li><p>" + uac_rundll + "</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' /></li>" +
			"<li><p>" + win7_install + "</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "FF") {
			// display Win7-FF
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Firefox on Windows 7</h2>" +
			"<ol><li><p>" + click_blue_install_button + " " + uac_rundll + "</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' /></li>" +
			"<li><p>" + win7_install + "<br />" + install_prob_note + "</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<h2>Unknown System</h2>" +
			"<p><br /><br />" + unsupported + "</p>";
		}
	} else if (OpSys == "Windows XP") {
		if (Brows == "IE") {
			// display WinXP-IE
			// Has been tested with IE 8.
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Internet Explorer on Windows XP</h2>" +
			"<p>For Internet Explorer, the plug-in code you need to install printers should automatically be installed for you from this site. All you need to do is accept the security warning when prompted." +
			"<ol><li><p>" + click_blue_install_button + " If the Global Print object is not installed, the 'Internext Explorer - Security Warning' will appear. Click on <b>Install</b> to install the IBM Global Print plug-in software.</p>" + 
			"<img src='/tools/print/images/IE-XP-object-install.jpg' /></li>" +
			"<li><p>The Global Print plugin window will appear. Click on <b>Start</b> to begin the printer installation.<br />" + install_prob_note + "</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "FF") {
			// display WinXP-FF
			document.getElementById("instructions").innerHTML = "<h2>Instructions for Firefox on Windows XP</h2>" +
			"<ol><li><p>" + click_blue_install_button + " The Global Print plugin window will appear. Click on <b>Start</b> to begin the printer installation." + install_prob_note + "</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<h2>Unknown System</h2>" +
			"<p><br /><br />" + unsupported + "</p>";
		}
	} else if (OpSys == "OCRH") {
		// display OCRH
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client Red Hat Enterprise Linux</h2>" +
		"<p><br /><br />Open Client Red Hat is supported by the Open Client team. Please see their <a target='_blank' href='http://d02ntcl02.ibm.com/Content/View/1/3aae501d-7e4e-4dbd-9652-c3704c0416ac/open_client_linux_global_printing_guide_linux'>IT Help Central page</a> for instructions on how to install a printer on Red Hat.</p>";
		
	} else if (OpSys == "OCDC") {
		// display OCDC-FF
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client Debian Linux</h2>" +
		"<p><br /><br />Open Client Debian is supported by the Open Client team. Please see their <a target='_blank' href='http://d02ntcl02.ibm.com/Content/View/1/3aae501d-7e4e-4dbd-9652-c3704c0416ac/open_client_linux_global_printing_guide_linux'>IT Help Central page</a> for instructions on how to install a printer on Ubuntu.</p>";
		
	} else if (OpSys == "OC") {
		// display OCDC-FF
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client RedHat/Debian Linux</h2>" +
		"<p><br /><br />Open Client RedHat and Debian Linux are supported by the Open Client team. Please see their <a target='_blank' href='http://d02ntcl02.ibm.com/Content/View/1/3aae501d-7e4e-4dbd-9652-c3704c0416ac/open_client_linux_global_printing_guide_linux'>IT Help Central page</a> for instructions on how to install a printer on Ubuntu.</p>";

	} else if (OpSys == "AIX") {
		// display AIX instructions
		document.getElementById("instructions").innerHTML = "<h2>How to install printers manually in AIX (without using GPWS)</h2>" + 
		"Since not all environments support automated printer installations from this web site, you may need to manually configure your workstation for printing from AIX. The <a href='PrintingfromAIX.html'>Printing from AIX page</a> provides information on how to install printers in other ways or on other operating systems";

	} else if (OpSys == "InvalidOS") {
		
		document.getElementById("instructions").innerHTML = "<h2>Unsupported System</h2>" +
		"<p><br /><br />" + OS + " is an unsupported operating system. Printer installs will not work for your system. Please refer to the <a href='" + os_url + "'>Supported Operating Systems</a> page for details.</p>";

	} else if (OpSys == "InvalidBrowser") {

		document.getElementById("instructions").innerHTML = "<h2>Unsupported Browser</h2>" +
		"<p><br /><br />" + browser + " is an unsupported browser. Please refer to the <a href='" + browser_url + "'>Supported Browsers</a> page for details.</p>";

	} else {
		document.getElementById("instructions").innerHTML = "<h2>Unknown System</h2>" +
		"<p><br /><br />We were unable to detect your operating system and therefore cannot provide instructions on how to install a printer. Please refer to the <a href='" + os_url + "'>Supported Operating Systems</a> and <a href='" + browser_url + "'>Supported Browsers</a> pages for details.</p>";
	}

} // function displayInstructs