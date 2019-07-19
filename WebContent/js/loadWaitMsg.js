function loadWaitMsg(interval) {
	
	if (interval == 0 || interval == null) interval = 10;
	var timer = 0;
	//dijit.byId("waitMsg").show();
	ibmweb.overlay.show('overlay-1',this);
	/**
	var myDijit = new dijit.ProgressBar({
		id : "pb",
        style:"width:300px",
        indeterminate:true
	}, "pb");
	if (dojo.byId("waitMsg")) {
    dojo.byId("waitMsg").appendChild(myDijit.domNode);
	    //var progressInterval = setInterval(function() {
    	setInterval(function() {
	        timer = timer + interval;
	        var pb1 = dijit.byId("pb");
	        pb1.update({indeterminate:true});
	        if(timer > 100) {
	        	//dijit.byId("waitMsg").hide();
	        	ibmweb.overlay.hide('overlay-1',this);
	        } //if
	    }, 500);
	} //if dojo
	**/
	if (dojo.byId("waitMsg")) {
		setInterval(function() {
			timer = timer + interval;
			dojo.byId("waitMsg").innerHTML = "<img src='//w3.ibm.com/jct03001pt/odw/CentennialTheme/themes/html/CentennialTheme//css/images/loading.gif' alt='Please wait...' style='text-align: center' align='middle'/>";
			if(timer > 100) {
	        	//dijit.byId("waitMsg").hide();
	        	ibmweb.overlay.hide('overlay-1',this);
	        } //if
	    }, 500);
	}
} //show