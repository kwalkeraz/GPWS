var userAgentValue = navigator.userAgent.toLowerCase();
var os,browser,bversion,osversion;

function getOS() {
	analyzeOS();
	return os;
}

function getOSVersion() {
	analyzeOS();
	return osversion;
}

function getBrowser() {
	analyzeBrowser();
	return browser;
}

function getBVersion() {
	analyzeBrowser();
	return bversion;
}

function analyzeBrowser() {

	if (checkOSBrowser("msie") >= 0) {
		browser = "Internet Explorer";
		bversion = getBrowserVersion('msie');
	} else if (checkOSBrowser('firefox') >= 0) {
		browser = "Firefox";
		bversion = getBrowserVersion('firefox');
	} else if (checkOSBrowser('chrome') >= 0) {
		browser = "Chrome";
		bversion = getBrowserVersion('chrome');
	} else if (checkOSBrowser('safari') >= 0) {
		browser = "Safari";
		bversion = getBrowserVersion('version');
	} else if (checkOSBrowser('opera') >= 0) {
		browser = "Opera";
		bversion = getBrowserVersion('opera');
	} else if (checkOSBrowser('konqueror') >= 0) {
		browser = "Konqueror";
		bversion = getBrowserVersion('konqueror');
	} else if (checkOSBrowser('omniweb') >= 0) {
		browser = "OmniWeb";
	} else if (checkOSBrowser('webtv') >= 0) {
		browser = "WebTV";
	} else if (checkOSBrowser('icab') >= 0) {
		browser = "iCab";
	} else if (!checkOSBrowser('compatible')) {
		browser = "Netscape Navigator";
		//bversion = detect.charAt(8);
		bversion = "";
	} else {
		browser = "unknown browser";
		bversion = "";
	}
	
	bit = userAgentValue.indexOf('win64');
	
	if (bit >= 0) {
		bversion += (" 64 bit");
	} else {
		bversion += (" 32 bit");
	}
}

function checkOSBrowser(osValue) {
	exist = userAgentValue.indexOf(osValue);
	return exist;
}

function getBrowserVersion(browserValue) {
	browserVer = "";
	place = userAgentValue.indexOf(browserValue);
	if (browserValue == 'msie') {
		browserVer = userAgentValue.substring(place + browserValue.length + 1,userAgentValue.indexOf(';',place));
		if (browserVer == '7.0' && userAgentValue.indexOf('trident') > 0) {
			browserVer = "8.0";
		}
	} else if (browserValue == 'konqueror') {
		browserVer = userAgentValue.substring(place + browserValue.length + 1,userAgentValue.indexOf(';',place));
	} else if (browserValue == 'firefox') {
		if (userAgentValue.indexOf(' ',place) > 0) {
			browserVer = userAgentValue.substring(place + browserValue.length + 1,userAgentValue.indexOf(' ',place));
		} else {
			browserVer = userAgentValue.substring(place + browserValue.length + 1,userAgentValue.length);
		}
	} else if (browserValue == 'chrome' || browserValue == 'opera' || browserValue == 'version') {
		browserVer = userAgentValue.substring(place + browserValue.length + 1,userAgentValue.indexOf(' ',place));
	} else {
		browserVer = userAgentValue.substring(place + browserValue.length + 1, place + (browserValue.length + 4));
	}

	return browserVer;
}

function analyzeOS() {
	if (checkOSBrowser('windows nt') > 0) {
		os = 'Windows';
		osversion = getWinVer();
	} else if (checkOSBrowser('linux') > 0) {
		os = "Linux";
		osversion = getLinVer();
		//osversion = "Linux";
	} else if (checkOSBrowser('macintosh') > 0) {
		os = "Mac";
		osversion = getMacVer();
	} else if (checkOSBrowser('x11') > 0) {
		os = "Unix";
		osversion = "unknown";
	} else if (checkOSBrowser('android') > 0) {
		os = "Android";
		osversion = "";
	} else if (checkOSBrowser('blackberry') > 0) {
		os = "RIM";
		osversion = "";
	} else if (checkOSBrowser('iphone') > 0 || checkOSBrowser('ipad') > 0 || checkOSBrowser('ipod') > 0) {
		os = "iOS";
		osversion = "";
	} else {
		os = "unknown";
		osversion = "unknown";
	}
}

function getWinVer() {
	spot = userAgentValue.indexOf('windows nt ');
	spotVer = userAgentValue.substring(spot + 11,spot + 14);
	if (spotVer == '6.2') {
		winver = 'Windows 8';

		bit = userAgentValue.indexOf('wow64');
		bit2 = userAgentValue.indexOf('win64');

		if (bit >= 0 || bit2 >= 0) {
			winver += ' 64 bit';
		} 

	} else if (spotVer == '6.1') {

		// Default to 64 bit unless browser is IE or FF4.x
                bit = userAgentValue.indexOf('wow64');
                bit2 = userAgentValue.indexOf('win64');
                bv = getBVersion();
                if (bv.indexOf('Internet Explorer') >= 0 || (bv.indexOf('Firefox') >= 0 && bv.indexOf(' 4') >=0) ) {
                        if (bit >= 0 || bit2 >= 0) {
                                winver = ' 64 bit';
                        }
                } else {
                        winver += ' 64 bit';
                }

	} else if (spotVer == '6.0') {
		winver = 'Windows Vista';
	} else if (spotVer == '5.2') {
		winver = 'Windows 2003';
	} else if (spotVer == '5.1') {
		winver = 'Windows XP';
	} else if (spotVer == '5.0') {
		winver = 'Windows 2000';
	} else if (spotVer == '4.0') {
		winver = 'Windows NT';
	} else if (spotVer == '98;') {
		winver = 'Windows 98';
	} else if (spotVer == '95;') {
		winver = 'Windows 95';
	} else if (spotVer == 'ce;') {
		winver = 'Windows CE';
	} else {
		winver = 'Windows ';
	}
	return winver;
}

function getLinVer() {
	linVer = "";
	//if (userAgentValue.indexOf('red hat') >= 0) {
	//	spot = userAgentValue.indexOf('red hat');
	//	linVer = "Red Hat " + userAgentValue.substring(spot + 8,userAgentValue.indexOf(' ',spot + 8));
	//} else if (userAgentValue.indexOf('fedora') >= 0) {
	//	spot = userAgentValue.indexOf('fedora');
	//	linVer = "Fedora " + userAgentValue.substring(spot + 7,userAgentValue.indexOf(' ',spot + 7));
	if (userAgentValue.indexOf('ubuntu') >= 0) {
		linVer = "Ubuntu";
	} else {
		linVer = "Linux";
	}
	return linVer;
}

function getMacVer() {
	if (userAgentValue.indexOf('os x') >= 0) {
		spot = userAgentValue.indexOf('os x');
		macVer = "OS X " + userAgentValue.substring(spot + 5,userAgentValue.indexOf(';',spot));
	} else {
		macVer = 'Mac';
	}
	return macVer;
}