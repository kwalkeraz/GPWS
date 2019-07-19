//This creates a dijit form
//@param
//	wLoc - The location of the form, in div id=xxx
//	wName - The name of the form
//	wID - The ID of the form
//	wClass - The css class of the form

function createGetForm(wLoc, wName, wID, wClass, wAction){
	var w = dijit.byId(wID);
    if(w) { w.destroy(true); } 
	new dijit.form.Form({
				 name: wName,
				 id: wID,
				 method: 'get',
				 action: wAction,
				 enctype: 'multipart/form-data',
				 'class': wClass
	 	},wLoc);
		dojo.byId(wID).setAttribute('role','form');
	 	return this;
} //createForm

function createPostForm(wLoc, wName, wID, wClass, wAction){
	var w = dijit.byId(wID);
    if(w) { w.destroy(true); } 
	new dijit.form.Form({
				 name: wName,
				 id: wID,
				 method: 'post',
				 action: wAction,
				 enctype: 'multipart/form-data',
				 role: 'form',
				 'class': wClass
	 	},wLoc);
		dojo.byId(wID).setAttribute('role','form');
	 	return this;
} //createForm