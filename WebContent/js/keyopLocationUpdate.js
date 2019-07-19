//These functions update the geographic locations for a keyop form.  They use a dijit.form.Select widget and query
//the data from an XML document.
//Requirements: The select widgets must be specified with the following ID's:
// geo, country, state (if it's used), site, building, floor
// Example: <select id="geo"...></select>
//Also note that these functions call other functions, so the reference to those functions must also exist 

function updateSite(info, countryid, cityid, defaultStatus, allSites) {
	selectedcountry = dijit.byId(countryid).value;
	var site = dijit.byId(cityid);
 	site.removeOption(site.getOptions()); 
 	
 	var currentsite="", currentsiteid="", lastsite = "";
 	var currentcountry=""; 
	var sitepos = 0;
	var start=0,start2=0;
	var end = 0, rend = 0, cend = 0;
	addOption('cityid',allSites,'0');
	while (sitepos < info.length) {
		start = info[sitepos].indexOf("=",0)+1;
		end = info[sitepos].indexOf("=",start);
		rend = info[sitepos].indexOf("=",0);
		currentcountry = info[sitepos].substring(0,rend);
		currentsite = info[sitepos].substring(start,end);
		currentsiteid = info[sitepos].substring(end + 1,info[sitepos].length);
		if (currentcountry == selectedcountry) {
			if (currentsite != lastsite) {
				addOption(cityid,currentsite,currentsiteid);
				lastsite = currentsite;
			}
		}
		sitepos++; 
	}
	site.selectedIndex=0;
	}

function updateMultiSite(info, countryid, cityid, defaultStatus, allSites) {
	selectedcountry = dijit.byId(countryid).value;
	var site = dijit.byId(cityid);
 	site.reset(); 
 	var currentsite="", currentsiteid="", lastsite = "";
 	var currentcountry=""; 
	var sitepos = 0;
	var start=0,start2=0;
	var end = 0, rend = 0, cend = 0;
	addMultiOption(cityid,allSites,'0');
	while (sitepos < info.length) {
		start = info[sitepos].indexOf("=",0)+1;
		end = info[sitepos].indexOf("=",start);
		rend = info[sitepos].indexOf("=",0);
		currentcountry = info[sitepos].substring(0,rend);
		currentsite = info[sitepos].substring(start,end);
		currentsiteid = info[sitepos].substring(end + 1,info[sitepos].length);
		if (currentcountry == selectedcountry) {
			if (currentsite != lastsite) {
				addMultiOption(cityid,currentsite,currentsiteid);
				lastsite = currentsite;
			}
		}
		sitepos++; 
	}
	site.selectedIndex=0;
	}

 function updateCountry(selectedValue) {
 	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('site');
 	if (dijit.byId("state")) resetMenu('state');
 	resetMenu('country');
 	var dID = "country";
 	var geo = getSelectValue('geo');
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=country&geo=" + geo;
 	var tagName = "Name";
 	var dataTag = "Country";
 	if (dijit.byId("geo").get('value') != "None") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue);
 	}
 } //end updateCountry

 function updateCity(selectedValue) {
 	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('site');
 	var geo = getSelectValue('geo');
 	var country = getSelectValue('country');
 	var state = "";
 	var url = "";
 	if (dijit.byId("state")) {
 		state = getSelectValue('state');
 		url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=city&geo="+geo+"&country="+country+"&state="+state;
 	} else {
 		url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=city&geo="+geo+"&country="+country;
 	}
 	var tagName = "Name";
 	var dataTag = "City";
 	var dID = "site";
 	if (dijit.byId("country").get('value') != "None") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue);
 	}
 } //end updateCity
 
