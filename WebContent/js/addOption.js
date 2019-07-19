//This file adds an option to a Select widget
//@param:
//	wName - The name of the option
//	wValue - The value of the option
//	wID - The ID of the select widget

function addOption(wID, wName, wValue){
	var selectMenu = dijit.byId(wID);
	var optionName = wName;
	var optionValue = wValue;
	selectMenu.addOption({value: optionValue, label: optionName });
} //addOption

function addMultiOption(wID, wName, wValue){
	var selectMenu = dijit.byId(wID);
	var optionName = wName;
	var optionValue = wValue;
	dojo.create('option',{value: optionValue,  innerHTML: optionName},selectMenu.domNode);
} //addMultiOption