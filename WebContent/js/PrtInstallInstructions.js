var min_IE_version = "6"; // The minimum IE version. This must be numbers only, no periods or other non-numeric characters.
var min_FF_version = "3"; // The minimum FF version. This must be numbers only, no periods or other non-numeric characters.
var win_plugin_url = "/tools/print/Win32Plugin.html";
var lx_plugin_url = "/tools/print/LinuxPlugin.html";
var lx_freegpws_url = "/tools/print/LinuxPlugin-FreeGpws.html";
var browser_url = "/tools/print/browsers.html";
var os_url = "/tools/print/SupportedOperatingSystems.html";
var ff_url = "/tools/print/FireFoxGPWS.html";
//var userAgentValue = navigator.userAgent.toLowerCase();
var OS,browser,bversion,osversion,total,thevalue;

var unsupported='You are running either an unsupported or unknown browser. Printers cannot be installed on your system. Please refer to the <a href="' + os_url + '">Supported Operating Systems</a> and <a href="' + browser_url + '">Supported Browsers</a> pages for details.';
var ie_backlevel="Your version of Internet Explorer is too old. Please upgrade to Internet Explorer version 6 or later to install a printer.";
var ff_backlevel="Your version of Firefox is too old. Please upgrade to FireFox version 3 or later to install a printer.";

var step_1="Go to the <a href='/tools/print/PrinterInstall.html' target='_blank'>installation page</a> on this site (besides using the link here, you can also use the <b>Install a printer</b> link on the Global Print home page or the link on the above tab navigator).";
var step_1_note="<p class='note'><b>Note:</b> You might be prompted to first install the Global Print plug-in.</p>";
var step_2="On the printer installation page, use either <b>By location</b> or <b>By name</b> get a list of printers matching your selection.";
var step_3="Find the printer you want to install in the list, and click the corresponding <b>Install</b> link beside the printer name in the list. <p class='note'><b>Note:</b> For information on the meaning of the columns and some of the terminology used in the list, please refer to the <a href='/tools/print/gloss.html'>Glossary</a>.</p>";

var click_blue_install_button="Once you have clicked on the <b>Install printer-name</b> link (e.g. <img src='/tools/print/images/install-button.jpg' alt='install link image'/> ), the install process will begin.";
var activate_plugin='<li><p>Firefox now requires you to activate the GPWS plugin before you can install a printer. To activate, look for the plugin icon at the bottom of this page (similar to the screenshot below) and click the "Activate IBM Global Print" link.</p><p><img src="/tools/print/images/activate-gpws1.jpg" alt="activate gpws plugin link"/></p></li><li><p>A window will appear near the URL bar. Click the "Allow and remember" button to enable the GPWS plugin to always install printers.</p><p><img src="/tools/print/images/activate-gpws2.jpg" alt="allow and remember gpws plugin"/></p></li>';
var uac_gpws="Click <b>Yes</b> in response to the User Account Control (UAC) window prompting you to allow the IBM Global Print v4.1 64 bit to make changes to your computer. Enter your password if prompted to do so.";
var uac_rundll="Click <b>Yes</b> in response to the User Account Control (UAC) window prompting you to allow the Windows Host Process (Rundll32) to make changes to your computer. Enter your password if prompted to do so.";
var win7_install="After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the <b>Start</b> button to begin the printer installation.";
var install_prob_note="<p class='note'><b>Note:</b> We recommend that you do not do anything else with your workstation until the installation is complete. The system will indicate the status of the installation as it progresses and when it completes. If you experience a problem with the printer installation, you should be redirected to the <a href='/tools/print/WebInstallErrors.html'>Problems with printer installation</a> page for troubleshooting suggestions.</p>";
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

function returnOS() {
	return OS;
}
function returnOSVersion() {
	return osversion;
}
function returnBrowser() {
	return browser;
}
function returnBVersion() {
	return bversion;
}
function returnBVersion1() {
	return bversion1;
}

function executeOS(type) {
	
	// Windows 10
	if (osversion.indexOf("Windows 10") >= 0) {
		if (browser == "Firefox") {
			if (bversion1 >= 52) {
				//redirect them
				self.location.href = ff_url;
			}
			if (bversion1 < min_FF_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ff_backlevel + "</p>";
			} else {
				displayInstructs('Windows 10','FF',type);
			}
		} else if (browser == "Internet Explorer") {
			if (bversion1 < min_IE_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ie_backlevel + "</p>";
			} else {
				if (bversion.indexOf('64 bit') >= 0) {
					displayInstructs('Windows 10','IE64',type);
				} else {
					displayInstructs('Windows 10','IE',type);
				}
			}
		} else if (browser == "Chrome" || browser == "Safari" || browser == "Opera") { //Reject Chrome, Safari and Opera

			displayInstructs("InvalidBrowser","",type);

		} else {
			displayInstructs('Windows 7','INVALID',type);
		}
	// WINDOWS 7
	} else if (osversion.indexOf("Windows 7") >= 0) {
		if (browser == "Firefox") {
			if (bversion1 >= 52) {
				//redirect them
				self.location.href = ff_url;
			}
			if (bversion1 < min_FF_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ff_backlevel + "</p>";
			} else {
				displayInstructs('Windows 7','FF',type);
			}
		} else if (browser == "Internet Explorer") {
			if (bversion1 < min_IE_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ie_backlevel + "</p>";
			} else {
				if (bversion.indexOf('64 bit') >= 0) {
					displayInstructs('Windows 7','IE64',type);
				} else {
					displayInstructs('Windows 7','IE',type);
				}
			}
		} else if (browser == "Chrome" || browser == "Safari" || browser == "Opera") { //Reject Chrome, Safari and Opera

			displayInstructs("InvalidBrowser","",type);

		} else {
			displayInstructs('Windows 7','INVALID',type);
		}
	// WINDOWS XP
	} else if (osversion.indexOf("Windows XP") >= 0) {

		if (browser == "Firefox") {
			if (bversion1 < min_FF_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ff_backlevel + "</p>";
			} else {
				displayInstructs('Windows XP','FF',type);
			}
		} else if (browser == "Internet Explorer") {
			if (bversion1 < min_IE_version) {
				document.getElementById("instructions").innerHTML = "<p>" + ie_backlevel + "</p>";
			} else {
				displayInstructs('Windows XP','IE',type);
			}
		} else if (browser == "Chrome" || browser == "Safari" || browser == "Opera") { //Reject Chrome, Safari and Opera

			displayInstructs("InvalidBrowser","",type);
		} else {
			displayInstructs('Windows XP','INVALID',type);
		}

	} else if (osversion == "Ubuntu") {

		if (browser == "Firefox") {
			if (bversion1 >= 52) {
				//redirect them
				self.location.href = ff_url;
			} else {
				displayInstructs('OCDC','FF',type);
			}
		}

	} else if (osversion == "Red Hat") {

		if (browser == "Firefox") {
			if (bversion1 >= 52) {
				//redirect them
				self.location.href = ff_url;
			} else {
				displayInstructs('OCRH','FF',type);
			}
		}

	} else if (OS == "Mac") {

		//displayInstructs("InvalidOS","Mac OS",type);
		displayInstructs("Mac","MPI",type);

	} else if (OS == "AIX") {

		displayInstructs("AIX","FF",type);

	} else if (OS == "Android") {

		displayInstructs("InvalidOS","Android",type);

	} else if (OS == "iOS") {

		displayInstructs("InvalidOS","iOS",type);

	} else if (OS == "RIM") {

		displayInstructs("InvalidOS","RIM",type);
		
	} else {
		displayInstructs("unknown","",type);
	}

} //function executeOS


function displayInstructs(OpSys, Brows,type) {

	document.getElementById("instructions").innerHTML = "";

	if (OpSys == "Windows 7" || OpSys == "Windows 8" || OpSys == "Windows 10") {
		var instructs = "";
		var objinstall = "/tools/print/images/IE-object-install.jpg";
		var obj9install = "/tools/print/images/IE9-object-install.jpg";
		var uacgp = "/tools/print/images/UAC-GP-prompt.jpg";
		var uac = "/tools/print/images/UAC-prompt.jpg";
		var gpdll1 = "/tools/print/images/GPdll1.jpg";
		var gpdll2 = "/tools/print/images/GPdll2.jpg";
		if (Brows == "IE" || Brows == "IE64") {
			if (Brows == "IE64") {
				gpdll1 = "/tools/print/images/GPdll1-64bit.jpg";
				gpdll2 = "/tools/print/images/GPdll2-64bit.jpg";
				objinstall = "/tools/print/images/IE64-object-install.jpg";
				obj9install = "/tools/print/images/IE9-64-object-install.jpg";
				uacgp = "/tools/print/images/UAC-GP64-prompt.jpg";
				uac = "/tools/print/images/UAC-prompt.jpg";
			}
			
			if (type == "all") {
				instructs = "<h2>Instructions for Internet Explorer on Windows 7</h2>" + "<ol><li><p>" + step_1 + "</p></li>" + "<li><p>" + step_2 + "</p></li>" + "<li><p>" + step_3 + "</p></li>";
			} else {
				instructs = "<h2>Instructions for Internet Explorer on Windows 7</h2><ol>";
			}

			document.getElementById("instructions").innerHTML = instructs +			
			"<li><p>" + click_blue_install_button + " If the Global Print object is not installed, you will get a prompt to install it.<br /><br /><b>IE 7 and 8 users:</b> Click on the  'click here' text and select 'Install This Add-on for All Users on This Computer...'</p>" + 
			"<br /><img src='" + objinstall + "' /><br /></li>" +
			"<p><b>IE 9 users:</b> To install the add-on, click the <b>Install</b> button at prompt at the bottom of IE.</p>" +
			"<br /><img src='" + obj9install + "' /><br /></li>" +
			"<li><p>" + uac_gpws + "</p>" + 
			"<br /><img src='" + uacgp + "' /><br /></li>" +
			"<li><p>" + uac_rundll + "</p>" + 
			"<br /><img src='" + uac + "' /><br /></li>" +
			"<li><p>" + win7_install + "</p>" + install_prob_note +  
			"<br /><img src='" + gpdll1 + "' /><br /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<br /><img src='" + gpdll2 + "' /></li></ol>";
		} else if (Brows == "FF") {
			// display Win7-FF
			if (type == "all") {
				instructs = "<h2>Instructions for Firefox on Windows 7</h2>" + "<ol><li><p>" + step_1 + "</p></li>" + "<li><p>" + step_2 + "</p></li>" + "<li><p>" + step_3 + "</p></li><li><p>" + click_blue_install_button + "</p></li>";
			} else {
				instructs = "<h2>Instructions for Firefox on Windows 7</h2><ol>";
			}
			var activate_instructs = "";
			if (bversion1 >= 52) {
				//redirect them
				self.location.href = ff_url;
			} else if (bversion1 >= 31) {
				activate_instructs = activate_plugin;
			}
			document.getElementById("instructions").innerHTML = instructs + activate_instructs + 
			"<li><p>" + uac_rundll + "</p>" + 
			"<br /><img src='/tools/print/images/UAC-prompt.jpg' /><br /></li>" +
			"<li><p>" + win7_install + "</p>" + install_prob_note +
			"<br /><img src='/tools/print/images/GPdll1.jpg' /><br /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<br /><img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<h2>Unknown System</h2>" +
			"<p><br /><br />" + unsupported + "</p>";
		}
	} else if (OpSys == "Windows XP") {
		if (Brows == "IE") {
			// display WinXP-IE
			// Has been tested with IE 8.
			if (type == "all") {
				instructs = "<h2>Instructions for Internet Explorer on Windows XP</h2>" + "<ol><li><p>" + step_1 + "</p></li>" + "<li><p>" + step_2 + "</p></li>" + "<li><p>" + step_3 + "</p></li>";
			} else {
				instructs = "<h2>Instructions for Internet Explorer on Windows XP</h2><ol>";
			}
			document.getElementById("instructions").innerHTML = instructs +
			//"<p>For Internet Explorer, the plug-in code you need to install printers should automatically be installed for you from this site. All you need to do is accept the security warning when prompted." +
			"<li><p>" + click_blue_install_button + " If the Global Print object is not installed, you will get a prompt to install it. Click on the 'click here' text and select 'Install This Add-on for All Users on This Computer...'</p>" +
			"<br /><img src='/tools/print/images/IE-object-install.jpg' /><br /></li>" +
			"<li><p>Click on <b>Install</b>, in response to the 'Internext Explorer - Security Warning', to install the IBM Global Print plug-in software.</p>" + 
			"<br /><img src='/tools/print/images/IE-XP-object-install.jpg' /><br /></li>" +
			"<li><p>The Global Print plugin window will appear. Click on <b>Start</b> to begin the printer installation.</p>" + install_prob_note +  
			"<br /><img src='/tools/print/images/GPdll1.jpg' /><br /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<br /><img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else if (Brows == "FF") {
			// display WinXP-FF
			if (type == "all") {
				instructs = "<h2>Instructions for Firefox on Windows XP</h2>" + "<ol><li><p>" + step_1 + "</p></li>" + "<li><p>" + step_2 + "</p></li>" + "<li><p>" + step_3 + "</p></li><li><p>" + click_blue_install_button + "</p></li>";
			} else {
				instructs = "<h2>Instructions for Firefox on Windows XP</h2><ol>";
			}
			var activate_instructs = "";
			if (bversion1 >= 31) {
				activate_instructs = activate_plugin;
			}
			document.getElementById("instructions").innerHTML = instructs + activate_instructs + 
			"<li><p>The Global Print plugin window will appear. Click on <b>Start</b> to begin the printer installation.</p>" + install_prob_note + 
			"<br /><img src='/tools/print/images/GPdll1.jpg' /><br /></li>" + 
			"<li><p>" + install_done + "</p>" +
			"<br /><img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<h2>Unknown System</h2>" +
			"<p><br /><br />" + unsupported + "</p>";
		}
	} else if (OpSys == "OCRH") {
		// display OCRH
		if (type == "all") {
			instructs = "<h3>Global Print instructions</h3><ol><li><p>" + step_1 + "</p></li>" + "<li><p>" + step_2 + "</p></li>" + "<li><p>" + step_3 + "</p></li><li><p>" + click_blue_install_button + "</p></li>";
		} else {
			instructs = "<h3>Global Print instructions</h3><ol>";
		}
		var activate_instructs = "";
		if (bversion1 >= 31) {
			activate_instructs = activate_plugin;
		}
 
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client Red Hat Enterprise Linux</h2>" +
		"<p><br /><br />Open Client Red Hat is supported by the Open Client team and the GPWS team. Please see the Open Client team's <a target='_blank' href='http://ibm.biz/BdxR6Q'>IT Help Central page</a> for instructions on how to install a printer on Red Hat using the IBM Global Printer Installer.<br /><br />" +
		instructs + activate_instructs + 
		"<li><p>The Global Print plugin window will appear. Click on <b>Start</b> to begin the printer installation.</p>" + install_prob_note + 
		"<br /><img src='/tools/print/images/GPdll1.jpg' /><br /></li>" + 
		"<li><p>" + install_done + "</p>" +
		"<br /><img src='/tools/print/images/GPdll2.jpg' /></li></ol>";
		
	} else if (OpSys == "OCDC") {
		// display OCDC-FF
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client Debian Linux</h2>" +
		"<p><br /><br />Open Client Debian is supported by the Open Client team. Please see their <a target='_blank' href='http://ibm.biz/BdxR6Q'>IT Help Central page</a> for instructions on how to install a printer on Ubuntu.</p>";
		
	} else if (OpSys == "OC") {
		// display OCDC-FF
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Open Client RedHat/Debian Linux</h2>" +
		"<p><br /><br />Open Client RedHat and Debian Linux are supported by the Open Client team. Please see their <a target='_blank' href='http://ibm.biz/BdxR6Q'>IT Help Central page</a> for instructions on how to install a printer on Linux.</p>";
	
	} else if (OpSys == "Mac") {
		// display Mac instructs
		document.getElementById("instructions").innerHTML = "<h2>Instructions for Mac OS X (versions 10.12, 10.11 and 10.10)</h2><br /><br />" +
		"<h3>Install the IBM Print Preferences Pane</h3><p><br />To install a printer on a Mac, you'll first need to install the IBM Print application that is available from the <a href='https://w3-01.ibm.com/helpcentral/Content/View/3ed2f150-dfdb-4f01-8147-8fb2506016dc/macibm_software_center'>Mac@IBM App Store</a>.  The IBM Print application is installed in System Preferences on your Mac. While the data that populates IBM Print is pulled from the GPWS, printers cannot be installed on Mac using GPWS install process." +
		"<ol><li><p>From your Mac, go to <strong>Launchpad&nbsp;&nbsp; </strong><br />&nbsp;&nbsp;&nbsp;<img alt='Launchpad icon' src='/tools/print/images/Launchpad.png' align='middle' style='height: 47px; width: 47px' /><br />and click on&nbsp;the&nbsp;<strong>Mac@IBM App Store</strong><br />&nbsp;&nbsp;&nbsp;<img alt='Mac at IBM software center' src='/tools/print/images/MacIBMAppStore.png' align='middle' style='height: 84px; width: 104px' /><br></p>" +
		"<p class='ibm-item-note'>Note: If you do not have the Mac@IBM App Store installed, you can <a target='_blank' href='https://w3-01.ibm.com/helpcentral/Content/View/3ed2f150-dfdb-4f01-8147-8fb2506016dc/macibm_software_center'>download it.</a>" +
		"<li><span><span>On the <strong>Software</strong> page click <strong>Install </strong>next to <strong>IBM Print</strong></span></span></li><br>" + 
		"<img alt='IBM Print Preferences Pane' src='/tools/print/images/IBMPrint.png' style='height: 112px; width: 244px' /></li><br>" + 
		"<li><span><span>Once the application is installed, the IBM Print box will disappear. You will find it now located under the <strong>Uninstallers</strong> category.</span></span><br><br>" + 
		"<li>Go to <b>System Preferences</b> &gt;<b>&nbsp;</b><b>IBM Print</b> and install an IBM printer using either&nbsp;options<br><br>" + 
		"<strong>&nbsp;&nbsp; Option 1:</strong>&nbsp; <a href='#name'>Install printer by name</a><br><br>" + 
		"<strong>&nbsp;&nbsp; Option 2:</strong>&nbsp; <a href='#location'>Install printer by location</a></li><br>" + 
		"<li>To view installed printers, click <strong>System Preferences </strong>-&gt;&nbsp;<strong>Printers &amp; Scanners</strong><br></li></ol>" +
		"<br /><br /><a name='name'></a><h3>Install printer by name</h3>" +
		"<ol><li>Click on <strong>By Name</strong>,&nbsp;enter a <strong>Printer Name </strong>and click <b>Search</b>.<br><br>" +
		"<img alt='Install printer by name 1' src='/tools/print/images/MacInstallByName-1.png' style='height: 371px; width: 460px' /></li><br>" +
		"<li><strong>Select a printer </strong>from the <strong>Available Printers </strong>list and click&nbsp;<b>Install</b>.<br><br>" +
		"<img alt='Install printer by name 2'src='/tools/print/images/MacInstallByName-2.png' style='height: 372px; width: 461px' /></li><br>" +
		"<li>The <strong>Status </strong>at the bottom will display &quot;<span style='color: #008a52'><strong>Printer &quot;xxxxxxxx&quot; was installed successfully</strong></span>&quot;<br><br>" +
		"<img alt='Install printer by name 3'src='/tools/print/images/MacInstallByName-3.png' style='height: 367px; width: 456px' /><br>&nbsp;</li></ol>" +
		"<br /><br /><a name='location'></a><h3>Install printer by location</h3>" +
		"<ol><li>Click on <strong>By Location</strong> and select the <strong>Geography</strong>, <strong>Country</strong>, <strong>Site</strong>, <strong>Building </strong>and <strong>Floor</strong> to find the printer nearest you to install.<br><br>" +
		"<img alt='Install printer by location 1' src='/tools/print/images/MacInstallByLoc-1.png' style='height: 367px; width: 461px' /></li>" +
		"<li><strong>Select a printer </strong>from the <strong>Available Printers </strong>list and click&nbsp;<b>Install</b>.<br><br>" +
		"<img alt='Install printer by location 2' src='/tools/print/images/MacInstallByLoc-2.png' style='height: 369px; width: 459px' /></li>" +
		"<li>The <strong>Status </strong>at the bottom will display &quot;<span style='color: #008a52'><strong>Printer &quot;xxxxxxxx&quot; was installed successfully</strong></span>&quot;<br><br>" +
		"<img alt='Install printer by location 3' src='/tools/print/images/MacInstallByLoc-3.png' style='height: 370px; width: 459px' /></li>" +
		"</ol>";
		
	} else if (OpSys == "AIX") {
		// display AIX instructions
		document.getElementById("instructions").innerHTML = "<h2>How to install printers manually in AIX (without using GPWS)</h2>" + 
		"<p>Since not all environments support automated printer installations from this web site, you may need to manually configure your workstation for printing from AIX. The <a href='/tools/print/PrintingfromAIX.html'>Printing from AIX page</a> provides information on how to install printers in other ways or on other operating systems</p>";

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
