//This file creates a dojo widget Button
//@param
//	wLoc - The location of the button (in the form of div id=xx)
//	wName - The name of the button
//	wValue - The value of the button
//  wClass - The button class
//	wID - The ID of the button
//  wClick - onClick action to take

//This function creates a Search button
function createSubmitButton(wLoc, wName, wValue, wClass, wID){
	dojo.create('input', {
		type: 'submit',
		value: wValue,
		className: wClass,
 		name: wName,
 		id: wID
	 },wLoc);
 } //createButton

function createInputButton(wLoc, wName, wValue, wClass, wID, wClick){
	dojo.create('input', {
		type: 'button',
		value: wValue,
		className: wClass,
 		name: wName,
 		id: wID,
 		onClick: wClick
	 },wLoc);
 } //createButton

// This function creates a Button type instead of a type=button
function createButtonType(wLoc, wName) {
	 new dijit.form.Button({
		 type: "submit"
     },
     wLoc);
}  //createButtonType

//This function creates a Button type instead of a type=button
function createResetButton(wLoc, wName, wValue, wClass, wID) {
	 new dijit.form.Button({
		 type: 'reset',
		 value: wValue,
		 className: wClass,
	 	 name: wName,
	 	 id: wID
     },wLoc);
}  //createButtonType

function createSpan(wLoc, wClass) {
	dojo.create('span', {
		innerHTML: '&nbsp;',
		className: wClass
	}, wLoc);
} //createSpan

function createP (wLoc, wClass, wHTML) {
	dojo.create('p', {
		className: wClass,
		innerHTML: wHTML
	}, wLoc);
} //createP