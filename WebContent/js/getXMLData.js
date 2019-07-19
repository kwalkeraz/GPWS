//This functions queries the XML data and then populates a Select options with the results
//@param urlValue - The URL of the XML document
//@tagName - The name of the root tag
//@dataTag - The name of the XML tag you are looking for (i.e <Name></Name>
//@selectedValue - If you need to automatically select a value in the options file, this needs to be passed
//@locavailable - If you only wish to show values that are Available, then this needs to be set to true (Location only)
//
function getXMLData(urlValue,tagName,dataTag,dID,selectedValue,locavailable){
 	dojo.xhrGet({
      	url : urlValue,
      	handleAs : "xml",
    	load : function(response, args) {
    		var tn = response.getElementsByTagName(tagName);
      		var dt = response.getElementsByTagName(dataTag);
      		var selectMenu = dijit.byId(dID);
      		for (var i = 0; i < tn.length; i++) {
      			var optionName = tn[i].firstChild.data;
      			var optionValue = tn[i].firstChild.data;
      			//Use the option below if you need to get a tag attribute (ie <Name id=""></Name>
      			//var optionID = dt[i].getAttribute("id");
      			if (locavailable) {
      				var locStatus = "";
      				try {
      					locStatus = response.getElementsByTagName("Status")[i].firstChild.data;
      				} catch (e) {
      					locStatus = "";
      				}
      				//console.log('locstatus for city ' + optionName + ' is ' + locStatus);
      				if (locStatus.toLowerCase() != "deleted" || locStatus == "") {
      					selectMenu.addOption({value: optionValue, label: optionName });
      				} //if not deleted
      			} else {
      				selectMenu.addOption({value: optionValue, label: optionName });
      			} //else
      		} //for loop
      		autoSelectValue(dID,selectedValue);
      	}, //load function
      	preventCache: true,
      	sync: false,
      	error : function(response, args) {
      		console.log("Error getting XML data: " + args.xhr.status);
      	} //error function
      });
 } //getXMLData