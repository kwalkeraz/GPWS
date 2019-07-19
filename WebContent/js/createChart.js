/**
 * This function creates a Pie Chart using DojoX function
 * Please note that it requires the following for it to work:
 * 	 dojox.charting.Chart2D
 *	 dojox.charting.action2d.Tooltip
 *	 dojox.charting.action2d.MoveSlice
 *	 dojox.charting.themes.Claro
 * @param dID - the dojo ID where the chart will be created
 * 		  chartData - the array of data to be displayed
 * also note that getData() must exist as a separate function in order to generate the data needed to
 * create the charts
 */
function createPieChart(dID,chartData){
	var w = "650px";
	var h = "300px";
	var minValue = 0;
	var maxValue = 30000;
	var invalidMessage = "<p><a class=\"ibm-error-link\">Unable to create chart due to insufficient data</a></p>";
	try {
		var chart = new dojox.charting.Chart2D(dID);
		chart.setTheme(dojox.charting.themes.Claro);
		chart.addPlot("default", {
			type: "Pie",
			markers: true
		});
		chart.addAxis("x");
		chart.addAxis("y", { min: minValue, max: maxValue, vertical: true, fixLower: "major", fixUpper: "major" });
		chart.addSeries("Report",chartData);
		var tip = new dojox.charting.action2d.Tooltip(chart,"default");
		var mag = new dojox.charting.action2d.MoveSlice(chart,"default");
		chart.render();
		dojo.style(dID,{"width":w, "height":h});
	} catch (e) {
		console.log("Exception: " + e);
		dojo.byId(dID).innerHTML = invalidMessage;
	} //try and catch
} //createPieChart