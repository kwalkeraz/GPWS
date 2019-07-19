/**
 * Necessary functions for the ECPrint Install pages
 */

 function callDL(filePath, pkgname) {
	 var redirect = "http://bldgsa.ibm.com/projects/g/gpws_drivers/home/webuser/pub/protocols" + filePath;
	 var geo = getSelectValue('geo');
	 var country = getSelectValue('country');
	 if (country == 'None') {
		 country = "";
	 }
	 // Display Mac and Windows as "Mac OS X" and "Windows 7" and display RHEL and Ubuntu as "Red Hat Linux" and "Ubuntu Linux"
	 var osDisplay = "";
	 if (os == "Mac" || os == "Windows") {
		 osDisplay = os + " " + osversion;
	 } else {
		 osDisplay = osversion + " " + os;
	 }
	 
	 // Test URL
	 var sURL = "https://gpwstest01.cloud.dst.ibm.com/tools/print/servlet/printeruser.wss?to_page_id=37&name=" + pkgname + "&geo=" + encodeURIComponent(geo) + "&country=" + encodeURIComponent(country) + "&state=&city=&building=&floor=&os=" + encodeURIComponent(osDisplay) + "&browser=" + encodeURIComponent(browser) + " " + encodeURIComponent(bversion) + "&winwshost=&userip=&rc=0";
	 // Production URL
	 //var sURL = "https://w3.ibm.com/tools/print/servlet/printeruser.wss?to_page_id=37&name=" + pkgname + "&geo=" + geo + "&country=" + country + "&state=&city=&building=&floor=&os=" + osDisplay + "&browser=" + browser + " " + bversion + "&winwshost=&userip=&rc=0";
	 dojo.xhrPost({
		 url: sURL,
		 handleAs: "text",
	     load: function (response) {
	    	 console.log("Logged install successfully: " + response);
	     },
	     error : function(response, args) {
	   		console.log("Error logging install: " + response + " " + args.xhr.status);
	     }
 	});

	 location.href = redirect;
 }
 
 function onChangeCall(wName){
 	switch (wName) {
		case 'geo': hideInstallTable(); updateCountry(''); checkGeo(); break;

		case 'country': displayInstallTable(); break;
		
	} //switch
	return this;
 } //onChangeCall
 
 function checkGeo() {
	var geo = dijit.byId("geo").attr("value");
	 
	if (geo != null && geo != "None") {
		if (geo == 'North America' || geo == 'Latin America') {
			hideCountry();
			displayAmericas();
		} else if (geo == 'Europe Middle East and Africa') {
			hideCountry();
			displayEMEA();
		} else {
			showCountry();
			enableCountry();
		}
	}
 }
 
 function hideCountry() {
	 document.getElementById("countryDiv").style.display = "none";
 }
 
 function showCountry() {
	 document.getElementById("countryDiv").style.display = "";
 }
 
 function disableCountry() {
	 dijit.byId("country").set("disabled", true);
 }
 
 function enableCountry() {
	 dijit.byId("country").set("disabled", false);
 }

function displayInstallTable() {
	 var geo = dijit.byId("geo").attr("value");
	 var country = dijit.byId("country").attr("value");

	if (geo == 'Asia Pacific' && country != null && country != "None") {
		if (country == 'Japan') {
			hideServers();
			displayJapan();
		} else if (country == 'China') {
			hideServers();
			displayChina();
		} else if (country == 'India' || country == 'Sri Lanka') {
			hideServers();
			displayIndia();
		} else {
			hideServers();
			displayAP();
		}
		
	} 
}

function hideServers() {
	document.getElementById("USsrv").style.display = "none";
	document.getElementById("EMEAsrv").style.display = "none";
	document.getElementById("Japansrv").style.display = "none";
	document.getElementById("Chinasrv").style.display = "none";
	document.getElementById("Indiasrv").style.display = "none";
	document.getElementById("APsrv").style.display = "none";	
}
 
function hideInstallTable() {
	document.getElementById("InstallTable").style.display = "none";
	hideServers();
	document.getElementById("InstallInstructs").style.display = "none";
}

function displayAmericas() {
	document.getElementById("InstallTable").style.display = "";
	document.getElementById("USsrv").style.display = "";
	document.getElementById("InstallInstructs").style.display = "";
}

function displayEMEA() {
	document.getElementById("InstallTable").style.display = "";
	document.getElementById("EMEAsrv").style.display = "";
	document.getElementById("InstallInstructs").style.display = "";
}

function displayJapan() {
	document.getElementById("InstallTable").style.display = "";
	document.getElementById("Japansrv").style.display = "";
	document.getElementById("InstallInstructs").style.display = "";
}

function displayChina() {
	document.getElementById("InstallTable").style.display = "";
	document.getElementById("Chinasrv").style.display = "";
	document.getElementById("InstallInstructs").style.display = "";
}

function displayIndia() {
	document.getElementById("InstallTable").style.display = "";
	document.getElementById("Indiasrv").style.display = "";
	document.getElementById("InstallInstructs").style.display = "";
}

function displayAP() {
	document.getElementById("InstallTable").style.display = "";
	document.getElementById("APsrv").style.display = "";
	document.getElementById("InstallInstructs").style.display = "";
}