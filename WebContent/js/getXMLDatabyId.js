//This functions queries the XML data and then populates a Select options with the results
//@param urlValue - The URL of the XML document
//@tagName - The name of the root tag
//@dataTag - The name of the XML tag you are looking for (i.e <Name></Name>
//@selectedValue - If you need to automatically select a value in the options file, this needs to be passed
//
function getXMLDatabyId(urlValue,tagName,dataTag,dID,selectedValue,syncValue){
	var sValue = "";
 	dojo.xhrGet({
      	url : urlValue,
      	handleAs : "xml",
    	load : function(response, args) {
    		var tn = response.getElementsByTagName(tagName);
      		var dt = response.getElementsByTagName(dataTag);
      		var selectMenu = dijit.byId(dID);
      		var optionName = "";
      		var optionValue = "0";
      		for (var i = 0; i < tn.length; i++) {
      			try {
		   			optionName = tn[i].firstChild.data;
      				//optionValue = tn[i].firstChild.data;
	      			//Use the option below if you need to get a tag attribute (ie <Name id=""></Name>
	      			optionValue = dt[i].getAttribute("id");
      			} catch (e) {
      				console.log("Exception: " + e);
      				optionName = "";
      				optionValue = "0";
      			}
      			selectMenu.addOption({value: optionValue, label: optionName });
      			if (selectedValue == optionValue) {
      				sValue = optionValue;
      			}
      		} //for loop
      		//console.log("sValue to autoselect is: "+ sValue + " with ID: " + dID);
      		autoSelectValue(dID,sValue);
      	}, //load function
      	preventCache: true,
      	sync: (syncValue) ? syncValue : 'false',
      	error : function(response, args) {
      		console.log("Error getting XML data: " + args.xhr.status);
      	} //error function
      });
 } //getXMLDatabyId

// This is similar to above, except here we request for specific attributes
function getXMLDatabyIdSpecific(urlValue,tagName,dataTag,dID,selectedValue){
	var sValue = "";
 	dojo.xhrGet({
      	url : urlValue,
      	handleAs : "xml",
    	load : function(response, args) {
    		var tn = response.getElementsByTagName(tagName);
      		var dt = response.getElementsByTagName(dataTag);
      		var selectMenu = dijit.byId(dID);
      		var optionName = "";
      		var optionValue = "0";
      		for (var i = 0; i < tn.length; i++) {
      			try {
		   			optionName = dt[i].firstChild.data;
      				//optionValue = tn[i].firstChild.data;
	      			//Use the option below if you need to get a tag attribute (ie <Name id=""></Name>
	      			optionValue = dt[i].getAttribute("id");
      			} catch (e) {
      				console.log("Exception: " + e);
      				optionName = "";
      				optionValue = "0";
      			}
      			selectMenu.addOption({value: optionValue, label: optionName });
      			if (selectedValue == optionValue) {
      				sValue = optionValue;
      			}
      		} //for loop
      		//console.log("sValue to autoselect is: "+ sValue + " with ID: " + dID);
      		autoSelectValue(dID,sValue);
      	}, //load function
      	preventCache: true,
      	sync: true,
      	error : function(response, args) {
      		console.log("Error getting XML data: " + args.xhr.status);
      	} //error function
      });
 } //getXMLDatabyIdSpecific