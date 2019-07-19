//These functions update the geographic locations for a form.  They use a dijit.form.Select widget and query
//the data from an XML document.
//Requirements: The select widgets must be specified with the following ID's:
// geo, country, state (if it's used), site, building, floor
// Example: <select id="geo"...></select>
//Also note that these functions call other functions, so the reference to those functions must also exist 

function updateGeo(selectedValue,deviceavailable) {
	if (dijit.byId("floor")) resetMenu('floor');
	if (dijit.byId("building")) resetMenu('building');
	if (dijit.byId("city")) resetMenu('city');
 	if (dijit.byId("state")) resetMenu('state');
 	resetMenu('country');
 	resetMenu('geo');
 	//var selectedValue = "North America";
 	var dID = "geo";
 	var params = "query=geography";
 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
 	var tagName = "Name";
 	var dataTag = "Geography";
 	getXMLData(url,tagName,dataTag,dID,selectedValue);
 } //end updateCountry
 
 function updateCountry(selectedValue,deviceavailable) {
	if (dijit.byId("floor")) resetMenu('floor');
	if (dijit.byId("building")) resetMenu('building');
	if (dijit.byId("city"))resetMenu('city');
 	if (dijit.byId("state")) resetMenu('state');
 	resetMenu('country');
 	//var selectedValue = "United States";
 	var dID = "country";
 	var geo = getSelectValue('geo');
 	var params = "query=country&geo=" + geo;
 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
 	var tagName = "Name";
 	var dataTag = "Country";
 	if (geo != "None" && geo != "0" && geo != "*") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue);
 	}
 } //end updateCountry
 
 function updateState(selectedValue,deviceavailable) {
	if (dijit.byId("floor")) resetMenu('floor');
	if (dijit.byId("building")) resetMenu('building');
	if (dijit.byId("city")) resetMenu('city');
 	resetMenu('state');
 	//var selectedValue = "AZ";
 	var dID = "state";
 	var geo = getSelectValue('geo');
 	var country = getSelectValue('country');
 	var params = "query=state&geo="+geo+"&country="+country;
 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
 	var tagName = "Name";
 	var dataTag = "State";
 	if (country != "None" && country != "0" && country != "*") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue);
 	}
 } //end updateCountry
 
 function updateCity(selectedValue,deviceavailable) {
	resetMenu('floor');
 	resetMenu('building');
 	resetMenu('city');
 	//var selectedValue = "Tucson";
 	var geo = getSelectValue('geo');
 	var country = getSelectValue('country');
 	var state = "";
 	var url = "";
 	var params = "";
 	if (dijit.byId("state")) {
 		state = getSelectValue('state');
 		params = "query=city&geo="+geo+"&country="+country+"&state="+state;
 		
 	} else {
 		state = country;
 		params = "query=city&geo="+geo+"&country="+country;
 	}
 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
	url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
 	var tagName = "Name";
 	var dataTag = "City";
 	var dID = "city";
 	if (state != "None" && state != "0" && state != "*") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue, false);
 	}
 } //end updateCity
 
 function updateBuilding(selectedValue,deviceavailable) {
	resetMenu('floor');
 	resetMenu('building');
 	//var selectedValue = "9032";
 	var geo = getSelectValue('geo');
 	var country = getSelectValue('country');
 	var site = getSelectValue('city');
 	var params = "query=building&geo="+geo+"&country="+country+"&city="+site;
 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
 	var tagName = "Name";
 	var dataTag = "Building";
 	var dID = "building";
 	if (site != "None" && site != "0" && site != "*") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue, false);
 	}
 } //end updateBuilding
 
 function updateFloor(selectedValue,deviceavailable) {
	resetMenu('floor');
 	//var selectedValue = "02";
 	var geo = getSelectValue('geo');
 	var country = getSelectValue('country');
 	var site = getSelectValue('city');
 	var building = getSelectValue('building');
 	var params = "query=floor&geo="+geo+"&country="+country+"&city="+site+"&building="+building;
 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
 	var tagName = "Name";
 	var dataTag = "Floor";
 	var dID = "floor";
 	if (building != "None" && building != "0" && building != "*") {
 		getXMLData(url,tagName,dataTag,dID,selectedValue, false);
 	}
 } //end updateBuilding