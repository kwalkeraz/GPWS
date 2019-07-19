/**
 * Creates a meta tag element for IE Compatibility issues.
 * To keep the latest IE compatibility, use edge value
 */

function createTag() {
	console.log("Creating meta tag for compatibility...");
	var scrptE = document.createElement("meta");
	scrptE.setAttribute("http-equiv", "X-UA-Compatible");
	scrptE.setAttribute("content", "IE=edge");
	var parent = document.getElementsByTagName("head")[0];
	var firstNode = parent.childNodes[0];
	parent.insertBefore(scrptE,(firstNode || null));
} //createTag

if ( window.addEventListener ) { 
	window.addEventListener( "load", createTag, false );
} else if ( window.attachEvent ) { 
	window.attachEvent( "onload", createTag );
} else if ( window.onLoad ) {
	window.onload = createTag;
}