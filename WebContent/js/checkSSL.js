/**
 * 
 */

function checkSSL() {
    // check for SSL
    var securePort = "https";
    var currentURL=location.href.substring(0,5);
    if (currentURL.toLowerCase() != securePort) {
        currentURL = location.href.substring(4,location.href.lastIndexOf(''));
        var targetURL = securePort + currentURL;
        window.location = targetURL;
    }
} //checkSSL 