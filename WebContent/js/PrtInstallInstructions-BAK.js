

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
			displayInstructs('Windows XP','IE');
		} else {
			displayInstructs('Windows XP','INVALID');
		}
	} else if (OS == "Mac") {
		displayInstructs("INVALID","Mac OS");
	} else if (OS == "UNIX") {
		displayInstructs("INVALID","Unix");
	} else if (OS == "Android") {
		displayInstructs("INVALID","Android");
	} else if (OS == "iOS") {
		displayInstructs("INVALID","iOS");
	} else if (OS == "RIM") {
		displayInstructs("INVALID","RIM");
	} else if (OS == "unknown") { 
		displayInstructs("unknown","");
	} else if ((browser == "Internet Explorer" && bversion1 < min_IE_version) || (browser == "Firefox" && bversion1 < min_FF_version)) { //reject below version IE6 and FF3

		document.getElementById("instructions").innerHTML = "IE v5 or less";

	} else if (browser == "Internet Explorer" && bversion.indexOf("64 bit") >= 0) { // IE 64 bit

		document.getElementById("instructions").innerHTML = "<h1>Instructions for Internet Explorer 64 bit</h1>";
		
		document.getElementById("instructions").appendChild = "<p>How to install a printer using IE 64 bit.</p>";

	} else if (browser == "Chrome" || browser == "Safari") { //reject Chrome, Safari

		document.getElementById("instructions").innerHTML = "Chrome/Safari";

	} else if (browser == "Internet Explorer") {

		document.getElementById("instructions").innerHTML = "<p>IE: " + unsupported_os + "</p>";

	} else if ((browser == "Netscape Navigator" || browser == "Firefox") && OS == 'Windows') { //Check Windows plugin in Firefox

		if (osversion.indexOf('7') >= 0) {
			// Windows 7
			displayInstructs('Windows 7','FF');
		} else if (osversion.indexOf('XP') >= 0) {
			// Windows XP
			displayInstructs('Windows XP','FF');
		}
		
	} else if ((browser == "Netscape Navigator" || browser == "Firefox") && OS == 'Linux') { // Check Linux plugin in Firefox

		document.getElementById("instructions").innerHTML = "<p>Linux & Firefox: " + unsupported_os + "</p>";
		
	} else if (browser == "Opera" && OS == 'Windows') { // Check Opera plugin in Windows
	
		document.getElementById("instructions").innerHTML = "<p>Opera: " + unsupported_os + "</p>";
		
	} else {
		displayInstructs("unknown","");
	}
} //function executeOS

function displayInstructs(OpSys, Brows) {

	document.getElementById("instructions").innerHTML = "";

	if (OpSys == "Windows 7") {
		if (Brows == "IE") {
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Internet Explorer on Windows 7</h1>" +
			"<p>1) Upon clicking the blue installation button, if the Global Print object is not installed, you will get a prompt to install it.</p>" + 
			"<img src='/tools/print/images/IE-object-install.jpg' />" +
			"<p>2) After clicking the install button, you will get a User Account Control (UAC) prompt asking if you would like to allow IBM Global Print plugin to make changes to your computer. Enter your password and click 'Yes'. Note: Some users may have different UAC settings that will not require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-GP-prompt.jpg' />" +
			"<p>3) After accepting the UAC prompt, you will get another User Account Control (UAC) prompt asking if you would like to allow Rundll32 to make  changes to your computer. Enter your password and click 'Yes'. Note: Some users may have different UAC settings that will not require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' />" +
			"<p>4) After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the Start button to begin the installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' />" + 
			"<p>5) Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' />";
		} else if (Brows == "IE64") {
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Internet Explorer 64 bit on Windows 7</h1>" +
			"<p>1) Upon clicking the blue installation button, if the Global Print object is not installed, you will get a prompt to install it.</p>" + 
			"<img src='/tools/print/images/object-install.jpg' />" +
			"<p>2) After clicking the install button, you will get a User Account Control (UAC) prompt asking if you would like to allow IBM Global Print plugin 64 bit to make changes to your computer. Enter your password and click 'Yes'. Note: Some users may have different UAC settings that will not require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-GP-prompt.jpg' />" +
			"<p>3) After accepting the UAC prompt, you will get another User Account Control (UAC) prompt asking if you would like to allow Rundll32 to make changes to your computer. Enter your password and click 'Yes'. Note: Some users may have different UAC settings that will not require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' />" +
			"<p>4) After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the Start button to begin the installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' />" + 
			"<p>5) Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' />";
		} else if (Brows == "FF") {
			// display Win7-FF
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Firefox on Windows 7</h1>" +
			"<p>1) Upon clicking the blue installation button, you will get a User Account Control (UAC) prompt asking if you would like to allow Rundll32 to make changes to your computer. Enter your password and click 'Yes'. Note: Some users may have different UAC settings that will not require you to enter a password.</p>" + 
			"<img src='/tools/print/images/UAC-prompt.jpg' />" +
			"<p>2) After accepting the UAC prompt, you will be presented with the Global Print plugin. Click the Start button to begin the installation.</p>" + 
			"<img src='/tools/print/images/GPdll.jpg' />" + 
			"<p>3) Once the installation is complete, you will be presented with a 'Done' button. Click the 'Done' button to exit.</p>" +
			"<img src='/tools/print/images/GPdll2.jpg' />";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<p><br /><br />You are running either an unsupported or unknown browser. Please select a supported operating system and browser from the list above to view printer installation instructions.</p>";
		}
	} else if (OpSys == "Windows XP") {
		if (Brows == "IE") {
			// display WinXP-IE
			// display WinXP-FF
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Internet Explorer on Windows XP</h1>" +
			"<p>How to install a printer using IE.</p>" + 
			"<img src='images/UAC-prompt.jpg' />";
		} else if (Brows == "FF") {
			// display WinXP-FF
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Firefox on Windows XP</h1>" +
			"<p>How to install a printer using FireFox.</p>" + 
			"<img src='images/UAC-prompt.jpg' />";
		} else {
			// Browser unknown or unsupported
			document.getElementById("instructions").innerHTML = "<p><br /><br />You are running either an unsupported or unknown browser. Please select a supported operating system and browser from the list above to view printer installation instructions.</p>";
		}
	} else if (OpSys == "OCRH") {
		if (Brows == "FF") {
			// display OCRH-FF
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Firefox on Open Client Red Hat</h1>" +
			"<p><br /><br />Open Client Red Hat is supported by the Open Client team. Please see their wiki for instructions on how to install a printer on Red Hat.</p>";
		} else {
			// display unknown
			document.getElementById("instructions").innerHTML = "<p><br /><br />You are running either an unsupported or unknown browser. Please select a supported operating system and browser from the list above to view printer installation instructions.</p>";
		}
	} else if (OpSys == "OCDC") {
		if (Brows == "FF") {
			// display OCDC-FF
			document.getElementById("instructions").innerHTML = "<h1>Instructions for Firefox on Open Client Debian</h1>" +
			"<p><br /><br />Open Client Debian is supported by the Open Client team. Please see their wiki for instructions on how to install a printer on Ubuntu. </p>";
		} else {
			// display unknown
			document.getElementById("instructions").innerHTML = "<p><br /><br />You are running either an unsupported or unknown browser. Please select a supported operating system and browser from the list above to view printer installation instructions.</p>";
		}
	} else if (OpSys == "INVALID") {
		document.getElementById("instructions").innerHTML = "<p><br /><br />" + Brows + " is an unsupported operating system. Please select a supported operating system from the list above to view printer installation instructions.</p>";
	} else {
		document.getElementById("instructions").innerHTML = "<p><br /><br />We were unable to detect your operating system. Please select a supported operating system from the list above to view printer installation instructions.</p>";
	}
}