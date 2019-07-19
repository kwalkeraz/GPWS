/**
 * This function helps you create a Checkbox input form
 * @param wName - The name of the checkbox
 * @param wValue - The value of the checkbox
 * @param wLabel - The actual label to use in front of the checkbox
 * @param wCheck - Check to see if it's automatically selected
 * @param wLoc - The location of the checkbox
 * @param wID - The ID that will be assigned to the check box
 */

	function createCheckBox(wName, wValue, wLabel, wCheck, wLoc, wID){
	 	var cb = new dijit.form.CheckBox({
             name: wName,
             id: (wID) ? wID : wName,
             innerHTML: wName,
             value: wValue,
             checked: wCheck,
             onChange: function(){
    			onChangeCall(wName);
    		 } 
         });
         dojo.place(cb.domNode,dojo.byId(wLoc),"before");
         dojo.create('label',{'for':cb.name, innerHTML:wLabel},cb.domNode,"after");
	 } //createCheckBox
	
	
	//Similar to above, except this one puts the checkbox in a list format
	function createCheckBoxList(wName, wValue, wLabel, wCheck, wLoc, wID){
	 	var cb = new dijit.form.CheckBox({
             name: wName,
             id: (wID) ? wID : wName,
             innerHTML: wName,
             value: wValue,
             checked: wCheck,
             onChange: function(){
     			onChangeCall(wName);
     		 }
         });
         dojo.place(cb.domNode,dojo.byId(wLoc),"before");
         dojo.create("br",null,cb.domNode,"after");
         dojo.create('label',{'for':cb.name, innerHTML:wLabel},cb.domNode,"after");
	 } //createCheckBox
	
	//Check the value of a checkbox
	//@param wName - name of the widget to check
	//@param wValue - whether the widget will be checked/unchecked (value of true/false)
	function setChecked(wName, wValue) {
		var wn = dijit.byId(wName);
		if (wn) {
			wn.set('checked', wValue);
		} //if
	} //setChecked
	
	//Checkbox is checked
	//@param wName - name of the widget to check
	//@return - boolean value
	function isChecked(wName) {
		var wn = dijit.byId(wName);
		var isChk = wn.checked;
		return isChk;
	} //isChecked