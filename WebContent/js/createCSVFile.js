function createNewArray(items) {
 	var dataArray = [];
	angular.forEach(items, function(x) {
		//1 is available, 0 is not defined.
		var avail = (x.DriverName == "" ) ? "N" : "Y";
		var devName = x.DeviceName;
		var model = x.Model;
		var driverSetName = x.DriverSetName;
		var driverName = x.DriverName;
		dataArray.push({Win_10_Ready: avail, Device_name: devName, Model: model, Driver_set: driverSetName, Driver_name: driverName});
	});
	
 	return dataArray;
}

function createCSVlink(param){
 	var d = new Date();
 	var year = d.getFullYear();
 	var m = (d.getMonth()) + 1;
 	(m < 10) ? m = "0"+m : m;
 	var month = m;
 	var day = d.getDate();
 	var title = "Windows_10_Ready_Devices_" + param + "_" + year + month + day;
	//Check to see if it exists first
	var wID = dojo.byId('download');
	if(wID) { dojo.empty('download'); } 
 	dojo.create("a", { 
 		href: "javascript:JSONToCSVConvertor("+'\''+title+'\''+','+true+");", 
 		title: "csv", 
 		innerHTML: "Download to CSV file" + "<br /><br />"
 		}, 'download');
 }
