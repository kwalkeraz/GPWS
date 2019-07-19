//These functions update the geographic locations for a form.  They use a dijit.form.Select widget and query
//the data from an XML document.
//Requirements: The select widgets must be specified with the following ID's:
// geo, country, state (if it's used), site, building, floor
// Example: <select id="geo"...></select>
//Also note that these functions call other functions, so the reference to those functions must also exist 

function updateGeo(selectedValue) {
 	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('city');
 	if (dijit.byId("state")) resetMenu('state');
 	resetMenu('country');
 	resetMenu('geo');
 	//var selectedValue = "North America";
 	var dID = "geo";
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=geography";
 	var tagName = "Name";
 	var dataTag = "Geography";
 	getXMLDataGeo(url,tagName,dataTag,dID,selectedValue);
 } //end updateCountry
 
 function updateCountry(selectedValue) {
	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('city');
 	if (dijit.byId("state")) resetMenu('state');
 	resetMenu('country');
 	//var selectedValue = "United States";
 	var dID = "country";
 	var geo = getSelectValue('geo');
 	if (!isNaN(geo)) geo = getSelectValuebyName('geo');
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=country&geo=" + geo;
 	var tagName = "Name";
 	var dataTag = "Country";
 	if (geo != "None" && geo != "0") {
 		getXMLDataGeo(url,tagName,dataTag,dID,selectedValue);
 	}
 } //end updateCountry
 
 function updateState(selectedValue) {
	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('city');
 	resetMenu('state');
 	//var selectedValue = "AZ";
 	var dID = "state";
 	var geo = getSelectValue('geo');
 	if (!isNaN(geo)) geo = getSelectValuebyName('geo');
 	var country = getSelectValue('country');
 	if (!isNaN(country)) country = getSelectValuebyName('country');
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=state&geo="+geo+"&country="+country;
 	var tagName = "Name";
 	var dataTag = "State";
 	if (country != "None" && country != "0") {
 		getXMLDataGeo(url,tagName,dataTag,dID,selectedValue);
 	}
 } //end updateCountry
 
 function updateCity(selectedValue) {
	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('city');
 	//var selectedValue = "Tucson";
 	var geo = getSelectValue('geo');
 	if (!isNaN(geo)) geo = getSelectValuebyName('geo');
 	var country = getSelectValue('country');
 	if (!isNaN(country)) country = getSelectValuebyName('country');
 	var state = "";
 	var url = "";
 	if (dijit.byId("state")) {
 		state = getSelectValue('state');
 		if (!isNaN(state)) state = getSelectValuebyName('state');
 		url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=city&geo="+geo+"&country="+country+"&state="+state;
 	} else {
 		url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=city&geo="+geo+"&country="+country;
 	}
 	var tagName = "Name";
 	var dataTag = "City";
 	var dID = "city";
 	if (country != "None" && country != "0") {
 		getXMLDataGeo(url,tagName,dataTag,dID,selectedValue,true);
 	}
 } //end updateCity
 
 function updateBuilding(selectedValue) {
	resetMenu('floor');
 	resetMenu('building');
 	//var selectedValue = "9032";
 	var geo = getSelectValue('geo');
 	if (!isNaN(geo)) geo = getSelectValuebyName('geo');
 	var country = getSelectValue('country');
 	if (!isNaN(country)) country = getSelectValuebyName('country');
 	var site = getSelectValue('city');
 	if (!isNaN(site)) site = getSelectValuebyName('city');
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=building&geo="+geo+"&country="+country+"&city="+site;
 	var tagName = "Name";
 	var dataTag = "Building";
 	var dID = "building";
 	if (site != "None" && site != "0") {
 		getXMLDataGeo(url,tagName,dataTag,dID,selectedValue,true);
 	}
 } //end updateBuilding
 
 function updateFloor(selectedValue) {
	resetMenu('floor');
 	//var selectedValue = "02";
 	var geo = getSelectValue('geo');
 	if (!isNaN(geo)) geo = getSelectValuebyName('geo');
 	var country = getSelectValue('country');
 	if (!isNaN(country)) country = getSelectValuebyName('country');
 	var site = getSelectValue('city');
 	if (!isNaN(site)) site = getSelectValuebyName('city');
 	var building = getSelectValue('building');
 	if (!isNaN(building)) building = getSelectValuebyName('building');
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&query=floor&geo="+geo+"&country="+country+"&city="+site+"&building="+building;
 	var tagName = "Name";
 	var dataTag = "Floor";
 	var dID = "floor";
 	if (building != "None" && building != "0") {
 		getXMLDataGeo(url,tagName,dataTag,dID,selectedValue,true);
 	}
 } //end updateFloor
 
//This functions queries the XML data and then populates a Select options with the results
//@param urlValue - The URL of the XML document
//@tagName - The name of the root tag
//@dataTag - The name of the XML tag you are looking for (i.e <Name></Name>
//@selectedValue - If you need to automatically select a value in the options file, this needs to be passed
//@locAvailable - To search for locations that are available only
 
function getXMLDataGeo(urlValue,tagName,dataTag,dID,selectedValue,locAvailable){
	var sValue = "";
	dojo.xhrGet({
     	url : urlValue,
     	handleAs : "xml",
   	load : function(response, args) {
   			var tn = response.getElementsByTagName(tagName);
     		var dt = response.getElementsByTagName(dataTag);
     		var selectMenu = dijit.byId(dID);
     		var optionName = "";
     		var optionValue = "0";
     		var locStatus = "";
     		for (var i = 0; i < tn.length; i++) {
     			optionName = tn[i].firstChild.data;
 				//optionValue = tn[i].firstChild.data;
      			//Use the option below if you need to get a tag attribute (ie <Name id=""></Name>
      			optionValue = dt[i].getAttribute("id");
     			try {
	      			locStatus = response.getElementsByTagName("Status")[i].firstChild.data;
     			} catch (e) {
     				console.log("Exception: " + e);
     				locStatus = "";
     			}
     			if (locAvailable) {
      				//console.log('locstatus for city ' + optionName + ' is ' + locStatus);
      				if (locStatus.toLowerCase() != "deleted" || locStatus == "") {
      					selectMenu.addOption({value: optionValue, label: optionName });
      				} //if not deleted
      			} else {
      				selectMenu.addOption({value: optionValue, label: optionName });
      			} //else
     			if (selectedValue == optionValue) {
     				sValue = optionValue;
     			}
     		} //for loop
     		//console.log("sValue to autoselect is: "+ sValue + " with ID: " + dID);
     		autoSelectValue(dID,sValue);
     	}, //load function
     	preventCache: true,
     	sync: false,
     	error : function(response, args) {
     		console.log("Error getting XML data: " + args.xhr.status);
     	} //error function
     });
} //getXMLDatabyId