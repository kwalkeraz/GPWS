//Create a dijit Input field
//@param
//	wLoc - The location of the input field

//This function creates the text area widget
//@param
//	wName - The name of the field
//	wClass - css class attribute to use
//	wValue - any default value that might be used
function createTextArea(wLoc,wName,wClass,wValue){
	new dijit.form.Textarea({
        name: wName,
        id: wName,
        value: wValue,
        'class': wClass,
        style: "width:200px; font-size:12px;"
    },
    wLoc);
 	return this;
} //createInput