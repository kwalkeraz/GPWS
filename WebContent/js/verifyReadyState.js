function verifyReadyState(obj){ 
//Verifies that the server is accepting connections and is ready to respond
//@param obj - The XML http request object
// if readyState = 4, Server is ready to response
	if(obj.readyState == 4){ 
		//alert('Error in XMLHttpRequest -> ' + obj.status + ' ' + obj.statusText);
		// status = 200 is a valid response from the webserver
		if(obj.status == 200){                 
			return true; 
		} else { 
			alert("Problem retrieving XML data") 
			return false;
		} //if ready = 200             
	} //if ready = 4          
} //verifyReadyState