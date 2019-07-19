//Hide-Unhides a field based on the ID
//@param idname - The ID of the field
function hide_fields(idname) {
// Hides edit field until the user clicks on the link
	document.getElementById(idname).style.display = "none";
	//document.getElementById(idname).style.visibility='hidden';
}  //function hide_fields
	
function unhide_fields(idname) {
// unhides edit field for edit purposes
	document.getElementById(idname).style.display = "";
	//document.getElementById(idname).style.visibility='visible';
}  //function unhide_fields