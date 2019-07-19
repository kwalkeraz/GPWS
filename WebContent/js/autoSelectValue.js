//Auto select a value if a value has been provided for a certain widget
//@param dID - The ID of the dijit widget
//@param selectedValue - The value to be automatically selected
//
function autoSelectValue(dID,selectedValue) { 
 	var selectMenu = dijit.byId(dID);
 	//selectMenu.attr('value',selectedValue);
 	selectMenu.set('value',selectedValue);
 	//console.log("selected value is " + selectedValue);
 } //autoSelectValue

function autoSelectValuebyName(dID,selectedValue) { 
 	var selectMenu = dijit.byId(dID);
 	//selectMenu.attr('value',selectedValue);
 	selectMenu.set('displayedValue',selectedValue);
 	//console.log("selected value is " + selectedValue);
 } //autoSelectValue