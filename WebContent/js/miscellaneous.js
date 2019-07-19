/**
 *  Use this file to include miscellanous javascript/dojo functions
 */

	//Check to see if a widget has the proper selected value, if not, return a tooltip message
	//@param valuetoCheck - Value to check (ie None, 0...)
	//@param wValue - The value of the widget
	function checkSelectValue(valuetoCheck){
		var returnValue = true;
		this.checkValue = valuetoCheck;
        this.checkField = function(wValue) {
			if (wValue == valuetoCheck) {
				returnValue = false;
			} //if
			return returnValue;
		}; //function
    };  
    
    function showSelectMsg(valuetoCheck, wValue, tooltipMsg, wID){
    	var chkValue = new checkSelectValue(valuetoCheck);
    	if (!chkValue.checkField(wValue)) {
			showReqMsg(tooltipMsg, getID(wID)); 
			return false;
		} else {
			return true;
		}
    } //showSelectMsg
	
	//Get the dojo ID 
	//@param wID - The dojo ID
	//@returns - Widget information
	function getID(wID) {
		var wi = dojo.byId(wID);
		if (wi) return wi;
	} //getID
	
	//Get the widget value
	//@param wID - The dojo ID
	//@returns - The value of the dojo
	function getIDValue(wID) {
		var wn = getID(wID);
		if (wn) {
			var wv = wn.value;
			return wv;
		}
	} //getIDValue
	
	//Set the dojo value
	//@param wID - The dojo ID
	//@param wValue - The value to set for dojo ID
	function setValue(wID, wValue) {
		var wi = getID(wID);
		if (wi) {
			wi.value = wValue;
		}
	} //setValue

	//Get the widget 
	//@param wID - The widget ID
	//@returns - Widget information
	function getWidgetID(wID) {
		var wi = dijit.byId(wID);
		if (wi) return wi;
	} //getID
	
	//Get the widget value
	//@param wID - The widget ID
	//@returns - The value of the widget
	function getWidgetIDValue(wID) {
		var wn = getWidgetID(wID);
		if (wn) {
			var wv = wn.get('value');
			return wv;
		}
	} //getIDValue
	
	//Set the widget value
	//@param wID - The widget ID
	//@param wValue - The value to set for the widget
	function setWidgetIDValue(wID, wValue) {
		var wi = getWidgetID(wID);
		if (wi) {
			wi.set('value', wValue);
		}
	} //setValue

	//This function changes the width of an input field to the specified pxSize
	//@param 
	//	pxSize - The size of the width in pixels (ie 400px)
	function changeInputTagStyle(pxSize){
		 dojo.query("input").forEach(function(x){
		 	//console.log(x);
		 })
		 .filter(".dijitInputInner")
		 .forEach(function(x){
		 	//console.log(x);
		 	dojo.style(x,"width",pxSize);
		 });
	 } //changeStyle
	
	function changeSelectStyle(pxSize){
		dojo.query("table").forEach(function(x){
		 	//console.log(x);
		 })
		 .filter(".dijitSelect")
		 .forEach(function(x){
		 	//console.log(x);
		 	dojo.style(x,"width",pxSize);
		 });
	 } //changeSelectStyle
	
	function changeCommentStyle(fieldName, pxSize){
		dojo.style(fieldName, {
	          "width": pxSize
		});		
	} //changeCommentStyle
	 
	//This functions creates a <p></p> tag to a given <div> or <span> tag
	//use the class="pClass" option so that this function knows what to query
	//@param
	//	pxSize - The size of the width in pixels (ie 400px), can be left empty
	 function createpTag(pxSize){
	 	dojo.query(".pClass").forEach(function(x){
     		var divContent = x.innerHTML;
     		(divContent == "" ? divContent = "<br />" : divContent);
	 		//console.log(divContent);
     		if (pxSize != null && pxSize != "" && (typeof(pxSize) !== undefined)) {
     			if (dojo.isIE < 9) {
	     			var wD = dojo.create("div", null, x, "replace");
	 				var wNode = dojo.create("p", null, wD, "last");
	 				dojo.style(wNode,"width",pxSize);
	     			dojo.place(divContent, wNode);
     			} else {
     				dojo.create("p", { style: { width: pxSize }, innerHTML: divContent }, x, "replace");
     			}
     		} else {
     			if (dojo.isIE < 9) {
     				try {
	     				var wD = dojo.create("div", null, x, "replace");
			 			var wNode = dojo.create("p", null, wD, "last");
			     		dojo.place(divContent, wNode);
     				} catch (e) {
     					console.log('Exception: ' + e);
     				}
     			} else {
     				dojo.create("p", { innerHTML: divContent }, x, "replace");
     			}
     		}
     	});
	 } //createpTag
	 
	 //This appends a new parameter to the current URL so that the page can be reloaded/opened with a new value
	 //@param
	 //	 a - the current URL 
	 //  b - the name of the parameter
	 //  c - the value of the parameter
	 function appendURLParameters(a, b, c) { 
    	if (b.trim() == "") { 
    		alert("The parameter name is empty."); 
    		return a; 
    	} 
    	if (c.trim() == "") { 
    		alert("The parameter value is empty."); 
    		return a; 
    	} 
    	if (a.indexOf("?") == -1) { 
    		return a + "?" + b + "=" + c; 
    	} 
    	var d = a.split("?"); 
    	if (d.length >= 2) { 
    		if (d[1].trim() == "") { 
    			return d[0] + "?" + b + "=" + c; 
    		} 
	    	var e = d[1].split(/[&;]/g); 
	    	for (var f = 0; f < e.length; f++) { 
	    		var g = e[f]; var h = g.split("="); 
	    		if (h.length >= 2) { 
	    			if (h[0] == b) {
		    			a = RemoveUrlParameter(a, b);
		   			} 
	    		} 
    		} //for loop 
    		return a + "&" + b + "=" + c; 
    	} //if d > 2 
    } //AddURLParam
    
	//This removes a parameter in the URL, if the parameter already exists
	 //@param
	 //	 a - the current URL 
	 //  b - the name of the parameter
    function RemoveUrlParameter(a, b) { 
		var c = ""; var d = false; var e = false; 
		if (a.indexOf("?") == -1) { 
			alert("The current URL has no parameters"); 
			return a; 
		} 
		var f = a.split("?"); 
		if (f.length >= 2) { 
			c = c + f[0] + "?"; 
			var g = f[1].split(/[&;]/g); 
			for (var h = 0; h < g.length; h++) { 
				var i = g[h]; var j = i.split("="); 
				if (j.length >= 2) { 
					if (j[0] != b) { 
						c = c + i + "&"; 
						d = true; 
					} else { 
						e = true; 
					} 
				} 
			} //for loop 
			if (e == false) { 
				alert("the paramater was not found"); 
				return a; 
			} 
			var k = c.split("?"); 
			if (k.length >= 2) { 
				if (k[1].trim() == "") { 
					return k[0]; 
				} 
			} 
			if (d == true) { 
				c = c.slice(0, c.length - 1); 
			} 
			return c; 
		} 
	} //function RemoveUrlParameter
    
    //Add a parameter to the URL and then refresh the page
    //@param
    //  paramName - the name of the parameter
    //  paramValue - the value of the parameter
    function AddParameter(paramName, paramValue) {
		var new_url = appendURLParameters(window.location.href, paramName, paramValue);
		window.location = encodeURI(new_url);
		return false;
    } //AddParameter
    
    //Add a parameter to the URL and then redirect the page to the given URL
    //@param
    //  URL - the url to redirect to
    //  paramName - the name of the parameter
    //  paramValue - the value of the parameter
    function AddParameterRedirect(URL, paramName, paramValue) {
		var new_url = appendURLParameters(URL, paramName, paramValue);
		window.location = encodeURI(new_url);
		return false;
    } //AddParameter
    
    function addDateBox(wName, wID, wLoc) {
    	new dijit.form.DateTextBox(
            {
                id: wID,
                name: wName,
                required: true,       
                promptMessage: "mm/dd/yy",
                invalidMessage: "Invalid date. Please use mm/dd/yy format.", 
                constraints: "{datePattern:'MM/dd/yy'}",
                className: "ibm-date-picker"
            }, wLoc
        );
    } //addDateBox
    
    //Hide/unhide dijit fields based on what is selected
    //@param
    //  fieldArray - You can pass an array of fields in this format [""]
    //  displayValue - empty for display, none for hide
    function displayFields(fieldArray,displayValue){
	 	//dojo.attr(fieldName, "style", {display: displayValue});
	 	dojo.forEach(fieldArray, function(args){
			//dojo.attr(args, "style", {display: displayValue});
	 		dojo.style(args,"display",displayValue);
		});
	 } //displayfields
    
    //Show tooltip message
    //@param
    //  label - The message to be shown
    //  tooltip - The ID to attach the message to
    function showTTip(label, tooltip){
	 	var ttposition = ['after', 'below'];
	 	dijit.showTooltip(label, tooltip, ttposition);
	 	if (getWidgetIDValue(tooltip.id) == 'None' || getWidgetIDValue(tooltip.id) == '0' || getWidgetIDValue(wName) == '' || getWidgetIDValue(wName) != null) {
	 		dojo.byId(tooltip.id).setAttribute('aria-invalid',true);
		}
	 } //showTTip
    
    //Create a tooltip message
    //@param
    //  label - The message to be shown
    //  tooltip - The ID to attach the message to
    function createToolTip(label, tooltip){
		var reqMsg = label;
		new dijit.Tooltip({
       			connectId: tooltip,
       			position: ["above","below"],
				id: tooltip + 1,
				label: reqMsg
			});
	 } //createToolTip
    
    
    //Removes extra information from user's name
    //@param
    //	fieldName - The name of the person
    function fixName(fieldName) {
    	var rmArray = nameAddOns;  //Note: this is passed as a global variable
    	dojo.forEach(rmArray, function(args){
    		fieldName = fieldName.replace(args, "");
    	});
    	return fieldName;
    } //fixName