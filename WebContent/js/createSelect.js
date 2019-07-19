//Create an dijit Select menu
//@param
//	wName - The name of the dijit
//	wID - The ID of the dijit
//	wLabel - The name of the first option of select menu
//	wValue - The value of the first option of the select menu
//	wLoc - The location of the dijit in the form of div id=xx

function createSelect(wName, wID, wLabel, wValue, wLoc){	
 	new dijit.form.Select({
	        name: wName,
	        id: wName,
	        'class': 'iform',
	        onChange: function(){
	        			 if(typeof window.onChangeCall == 'function') {
	        				 onChangeCall(wName);
	        			 }
	        			 if (getWidgetIDValue(wName) != 'None' && getWidgetIDValue(wName) != '0' && getWidgetIDValue(wName) != '' && getWidgetIDValue(wName) != null) {
        					 dojo.byId(wName).setAttribute('aria-invalid',false);
        				 } else {
        					 dojo.byId(wName).setAttribute('aria-invalid',true);
        				 }
	        		  }, 
	        onFocus: function(){
	        			dijit.hideTooltip(dojo.byId(wID));
	        		 },
	        maxHeight: 200,
	        required: true,
	        options:  [{
			            label: wLabel,
			            value: wValue
		              }]
	    },wLoc);
 		dojo.byId(wName).setAttribute('aria-required',true);
 		dojo.byId(wName).setAttribute('aria-invalid',true);
    return this;
} //creatSelect

function createMultiSelect(wName,wLoc,wSize){
	if (wSize == null || wSize == "") {
		wSize = 7;
	}
 	new dijit.form.MultiSelect({
        name: wName,
        id: wName,
        multiple: true,
        size: wSize,
        'class': 'iform'
    },wLoc);
	return this;
 } //createMultiSelect
