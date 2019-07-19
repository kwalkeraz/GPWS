/**
 * Hide and unhide fields.
 */

function hide_fields(idname) {
// Hides edit field until the user clicks on the link
	dojo.byId(idname).style.display = "none";
}  //function hide_fields
	
function unhide_fields(idname) {
// unhides edit field for edit purposes
	dojo.byId(idname).style.display = "";
}  //function unhide_fields