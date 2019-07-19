function createXMLHttpRequest() {
//Creates an XML Http request object based on which browser you are using
	var browser = navigator.appName;
	//var xmlhttp = window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
	xmlhttp = null;
	if (window.XMLHttpRequest){
        try {
            xmlhttp = new XMLHttpRequest();
        } catch (e) {
            xmlhttp = false;
        } //try xmlhttprequest
    } else if (window.createRequest){
        try {
            xmlhttp = new window.createRequest();
        } catch (e) {
            xmlhttp = false;
        } //try createRequest
    } else if (window.ActiveXObject){
        try {
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
                xmlhttp = false;
            } //try xmlhttp
        } //try Msxml2
    } //else if ActiveX
	
	return xmlhttp;
} //end createXMLHttpRequest