//Create a dijit Input field
//@param
//	wLoc - The location of the input field

//This function creates the Search input field
//@param
//	wName - The name of the field
//	promptMsg - The message that will be used to prompt when onFocus
//	invalidMsg - Invalid message when form is invalid
function createSearchInput(wLoc,wName,promptMsg,invalidMsg){
	new dijit.form.ValidationTextBox({
		 name: wName,
		 id: wName,
		 required: true,
		 maxLength: '32',
		 type: 'text',
		 className: 'search-query',
		 trim: true,
		 uppercase: true,
		 tooltipPosition: ["below"],
		 promptMessage: promptMsg,
		 invalidMessage: invalidMsg,
		 regExp: "\\w{3,32}"
 	},wLoc);
 	return this;
} //createInput

// This function creates hidden fields
//@param
//	wName - name of the widget
//	wValue - value of the widget
function createHiddenInput(wLoc,wName,wValue,wID){
	var tID = '';
	//var w = dojo.byId(wName);
	//if(w) { dojo.destroy(w); }
	if (typeof wID != "undefined") { tID = wID; } else { tID = wName; }
	dojo.create('input', {
		type: 'hidden',
		value: wValue,
		name: wName,
	 	id: tID
	 },wLoc);
} //createHiddenInput

function createTextInput(wLoc,wName,wID,maxLengthField,isRequired,promptMsg,wClass,invalidMsg,regexp,wValue){
	var w = dijit.byId(wID);
    if(w) { w.destroy(true); } 
	var vBox = new dijit.form.ValidationTextBox({
		 name: wName,
		 id: wID,
		 value: wValue,
		 required: isRequired,
		 maxLength: maxLengthField,
		 size: '40',
		 //style: 'width: 410px !important;',
		 type: 'text',
		 className: wClass,
		 trim: true,
		 tooltipPosition: ["below"],
		 promptMessage: promptMsg,
		 invalidMessage: invalidMsg,
		 regExp: regexp
 	},wLoc);
	return this;
} //createInput

function createTextBox(wLoc,wName,wID,maxLengthField,wClass,wValue){
	new dijit.form.TextBox({
		 name: wName,
		 id: wID,
		 value: wValue,
		 maxLength: maxLengthField,
		 size: '40',
		 //style: "width: 40em;",
		 type: 'text',
		 className: wClass,
		 trim: true
 	},wLoc);
 	return this;
} //createInput

function createPasswordBox(wLoc,wName,wID,maxLengthField,wClass,wValue){
	new dijit.form.TextBox({
		 name: wName,
		 id: wID,
		 value: wValue,
		 maxLength: maxLengthField,
		 size: '40',
		 //style: "width: 40em;",
		 type: 'password',
		 className: wClass,
		 trim: true
 	},wLoc);
 	return this;
} //createInput

function createFileInput(wLoc,wName){
	dojo.create('input', {
		type: 'file',
		name: wName,
	 	id: wName
	 },wLoc);
} //createHiddenInput

function getInputDijitValue(wID){
	var value = dijit.byId(wID).get('value');
	return value;
} //getInputDijitValue

function getHiddenValue(wID){
	var value = dojo.byId(wID).value;
	return value;
} //getInputDijitValue

//var imported = document.createElement('script');
//imported.src = '/tools/print/js/secureInfo.js';
//imported.type = 'text/javascript';
//document.head.appendChild(imported);
//or the dojo way
var jsSource = "/tools/print/js/secureInfo.js";
dojo.create("script",{ src: jsSource, type: "text/javascript"}, dojo.query("head")[0]);

