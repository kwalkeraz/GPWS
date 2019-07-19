//This function resets a select menu back to it's original form
//@param dID - This is the dijit ID for the select menu
function resetMenu(dID){
	//console.log("id is " + dID);
 	var selectMenu = dijit.byId(dID);
 	var optionValue = selectMenu.options[0].value;
 	var optionName = selectMenu.options[0].label;
 	selectMenu.removeOption(dijit.byId(dID).getOptions());
 	selectMenu.addOption({value: optionValue, label: optionName });
 	//selectMenu.attr('value',optionValue);
 	selectMenu.set(optionValue,optionName);
 } //resetMenu