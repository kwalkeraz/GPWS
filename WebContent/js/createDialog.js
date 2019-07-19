//Create a dijit Dialog
//@param
//	wLoc - The location of the input field
//	wTitle - Title of the dialog box
//  wContent - The content to be displayed by the dialog widget
function createDialog(wLoc,wTitle,wContent){
	new dijit.Dialog({
		title: wTitle,
        content: wContent
 	},wLoc);
 	return this;
} //createInput