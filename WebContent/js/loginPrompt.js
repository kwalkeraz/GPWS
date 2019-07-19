/**
 * 
 */

	function getCookie(w){
		var cName = "";
		var pCOOKIES = new Array();
		pCOOKIES = document.cookie.split('; ');
		for(var bb = 0; bb < pCOOKIES.length; bb++){
			var NmeVal  = new Array();
			NmeVal  = pCOOKIES[bb].split('=');
			if(NmeVal[0] == w){
				cName = unescape(NmeVal[1]);
			}
		}
		return cName;
	} //getCookie

	function login(event) {
	 	var formName = dijit.byId("addProcessForm");
        var formValid = false;
        if (event) { event.preventDefault(); dojo.stopEvent(event); }
        var wName = dijit.byId("UserId").get('value');
        var wPass = dijit.byId("Password").get('value');
        formValid = formName.validate();
   		var msg = "Login successful";
   		if (wPass == "") {
   			alert("Please enter your password");
   			dijit.byId("Password").focus();
   			return false;
   		}
		if (formValid) {
			if (submitForm('addProcessForm',msg)) {
				location.reload();
				//AddParameter("", "");
				//alert('done');
			}
		} else {
			return false;
		}
	} //addCategoryInfo
	
    function submitForm(form,msg){
    	var submitted = true;
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Invalid login") > -1) {
	   				dojo.byId("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'Invalid login. Either the email address or passsword you specified is incorrect or you do not have access to the GPWS Administration page. If you believe that you should have access to the GPWS Administration page, please contact the GPWS team'+"</p>";
	   				submitted = false;
	   			} else if (data.indexOf("Unknown") > -1) {
	   				dojo.byId("Msg").innerHTML = "<p><a class='ibm-error-link' href='#'></a>"+'There was an error in the request'+"</p>";
	   				submitted = false;
	   			} else {
	   				dojo.byId("Msg").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				//location.reload();
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           	submitted = false;
	           	console.log(error);
	               dojo.byId("Msg").innerHTML = genErrorMsg + ioArgs.xhr.status;
	           },
	        };
	     dojo.xhrPost(xhrArgs);
	     return submitted;
    } //submitForm
    
	function createLayout(overlayID){
	 	var content = ""+
 			"<div id='response'>"+
				"<div class='ibm-common-overlay' id="+overlayID+">"+
					"<div class='ibm-head'>"+
						"<p><a class='ibm-common-overlay-close' href='#close'>Close [x]</a></p>"+
					"</div>"+
					"<div class='ibm-body'>"+
						"<div class='ibm-main'>"+
						"<div class='ibm-title ibm-subtitle'>"+
							"<h1><div id='processTitle'></div></h1>"+
						"</div>"+
						"<div class='ibm-container ibm-alternate ibm-buttons-last'>"+
							"<div class='ibm-container-body'>"+
								"<p class='ibm-overlay-intro'>"+'Required fields are marked with an asterisk (<span class="ibm-required">*</span>) and must be entered'+".</p>"+
								"<div id='Msg'></div>"+
								"<div id='formLoc'>"+
									"<div id='topageiddiag'></div>"+
									"<div id='logactioniddiag'></div>"+
									"<div class='pClass'><label for='categorycode'>"+'Login ID'+":<span class='ibm-required'>*</span></label>"+
									"<span><div id='userid'></div></span></div>"+
									"<div class='pClass'><label for='categoryvalue1'>"+'Password'+":<span class='ibm-required'>*</span></label>"+
									"<span><div id='passwd'></div></span></div>"+
									"<div class='ibm-overlay-rule'><hr /></div>"+
									"<div class='ibm-buttons-row'>"+
									"<div id='submit_add_button' align='right'></div>"+
								"</div>"+
							"</div>"+
						"</div>"+
					"</div>"+
				"</div>"+
			"</div>"+
			"<div class='ibm-footer'></div>"+
			"</div>"+
			"</div>";
		return content;
	 } //createLayout
	 
	 function clearValues(){
	 	if (dojo.byId("Msg")) dojo.byId("Msg").innerHTML = "";
		dijit.byId('UserId').set('value', '');
		dijit.byId('Password').set('value', '');
	 } //clearValues
	 
	 function closeLoc(loc){
     	var pop = 'addprocess';
        clearValues();
		ibmweb.overlay.hide(pop,this);
     } //closeLoc
	 
	 function openDiag() {
        //locDiag.show();
        clearValues();
        var pop = 'addprocess';
        var title = '';
        var topageid = dojo.byId('topageidadd');
        title = 'Common process login page';
        topageid.value = '1804';
        dojo.byId("processTitle").innerHTML = title;
		ibmweb.overlay.show(pop,this);
		var userid = getCookie('EmailAddress');
		if (userid != "" || userid != null) {
			dijit.byId('UserId').set('value', userid);
			dijit.byId('Password').focus();
		} else {
			dijit.byId('UserId').focus();
		}
     } //openLoc
	 
	 var addInfo = function(){
 		var title = "Title";
 		var content = createLayout('addprocess');
 		createDialog(title,content,'processDiag');
 		createpTag();
 		createHiddenInput('topageiddiag','to_page_id','','topageidadd');
        createTextInput('userid','UserId','UserId','64',true,'Required fields are marked with an asterisk (<span class="ibm-required">*</span>) and must be entered','required','This field appears to have incorrect characters, it is not in the correct format or it is over its size limit','^[A-Za-z0-9 _.;@/-]*$','');
        createPasswordBox('passwd','Password','Password','256','','');
        createSubmitButton('submit_add_button','ibm-submit','Submit','ibm-btn-arrow-pri','submit_add_process');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','Cancel','ibm-btn-cancel-sec','cancel_add_process','closeLoc(\'add_of\')');
 		createPostForm('formLoc', 'addProcessForm','addProcessForm','ibm-column-form','/tools/print/servlet/commonprocess.wss');
	 }; //function
		 
	 dojo.addOnLoad(addInfo);  //addOnLoad
	 
	 dojo.addOnLoad(function() {
		 dojo.connect(dojo.byId('addProcessForm'), 'onsubmit', function(event) {
		 	login(event);
		 });
	 });