//Get the value of a dijit widget by ID
//@param dID - the ID of the dijit widget
//
function getSelectValue(dID) {
 	//var selectValue = dijit.byId(dID).attr('value');
	var selectValue = "";
	try {
		selectValue = dijit.byId(dID).get("value");
		//selectValue = dijit.byId(dID).get("displayedValue");
	} catch (e) {
		console.log('id is ' + dID);
		console.log("There was an error returning a value in getSelectedValue.js: " + e.message);
		selectValue = "";
	}
 	//console.log("Selected value is " + selectValue);
 	return selectValue;
 } //getSelectValue

function getSelectValuebyName(dID) {
 	//var selectValue = dijit.byId(dID).attr('value');
	var selectValue = "";
	try {
		//selectValue = dijit.byId(dID).get("value");
		selectValue = dijit.byId(dID).get("displayedValue");
	} catch (e) {
		console.log('id is ' + dID);
		console.log("There was an error returning a value in getSelectedValue.js: " + e.message);
		selectValue = "";
	}
 	//console.log("Selected value is " + selectValue);
 	return selectValue;
 } //getSelectValue