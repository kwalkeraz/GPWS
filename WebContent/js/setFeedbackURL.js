/**
 * Replace the feedback URL for GPWS
 */

var URL = "/tools/print/Feedback.html";
if (dojo.isIE > 8 || dojo.isFF) {
	dojo.connect("onmouseover", function() {
		try {
			//dojo.query("a:contains(Feedback)")[0].href = URL;
			dojo.query("a[href*='feedback']")[0].href = URL;
		} catch (e) {
			//console.log("There was an error returning a value in setFeedbackURL.js: " + e.message);
		}
	});
} else {
	console.log("Setting feedback URL not supported in this browser");
}