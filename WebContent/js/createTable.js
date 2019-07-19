/**
 * Creates a table to be shown with current printer informatino from GPWS.  
 * @param
 * - tableInfo : This is a json format variable that contains the following information
 * 		{tableLoc: "newTableId", - The Location of the table in the HTML file (i.e <div id="someID" />
 * 		tableID : "", - Unique ID to be assigned to the table
 * 		tbodyId: "tbodyId", - Unique ID to be assigned to the table body
 * 		captionID: "impressID" - Unique ID to be assigned to the caption
 * 		};
 * - Data - This is the data in json format that contains the data to be displayed
 * - value - This is the value if you're comparing a column value to an element inside Data
 * - deviceName - This is the original device name, if you're comparing a device name to an element inside Data
 */
function createTable(tableInfo, Data, value, deviceName) {
	//console.log("Data in here is "+ Data);
	//Sort the data first
	for (i in tableInfo.sortBy) {
		dataSort(Data, tableInfo.sortBy[i]);
	}
	
	if (dojo.byId(tableInfo.tableLoc)) {
		//create main table first
		var table = dojo.create("table", {
			id : tableInfo.tableID,
			border : "0",
			cellpadding : "0",
			cellspacing : "0",
			//'class' : "ibm-data-table",
			'class' : "ibm-data-table ibm-sortable-table ibm-alternating",
			summary : tableInfo.summary
		}, tableInfo.tableLoc);
		
		var caption = dojo.create("caption", { innerHTML : "" }, table);
		var em = dojo.create("em", {}, caption);
		var span = dojo.create("span", { 
			id: tableInfo.captionID,
			innerHTML : tableInfo.summary
		}, em);
		
		var thead = dojo.create("thead", {
			id: ""
		}, table);
		
		var tbody = dojo.create("tbody", {
			id: tableInfo.tbodyId
		}, table);
	
		//end of main table
		
		var tr1 = dojo.create("tr", {}, thead);
		
		var row = "";
        for (var index in Data[0]) {
            //row += index + ',';
        	row = index;
            var label = row;
			dojo.create("th", {
                 innerHTML: label,
                 //'class': 'ibm-table-row',
                 'scope': 'col'
             }, tr1);       
        }
        row = row.slice(0, -1);
        
		var y = 1;
		
		for (var i = 0; i < Data.length; i++) {
	        var row2 = "";
	        console.log("Device name is " + Data[i].Device_Name);
	        console.log("Device name passed is " + deviceName);
	        var Class = (function(){
        		var isClass = "";
			console.log("y is " + y);
        		if (isOdd(y)) { 
        			isClass = "";
        		} else if (deviceName != Data[i].Device_Name) { 
        			isClass = "ibm-alt-row";
        		} else {
				isClass = "ibm-alt-row";
			}
        		return isClass;
        	})();
	        var tr = dojo.create("tr", {
	        	'id' : "tr" + y,
	        	//'class' : (isOdd(y)) ? "" : "ibm-alt-row",
	        	'class' : Class,
	        	'bgcolor' : (deviceName == Data[i].Device_Name && Data[i].Device_Name != undefined) ? "#e0f1f7" : "",
	        	'scope': 'col'
	        }, tbody);
		 	y++;
	        for (var index in Data[i]) {
	            row2 = Data[i][index];
	            createTD(tr, row2, index, value);
	        }
	        row2.slice(0, row2.length - 1);
	    }
	} else {
		console.log("table ID was not specified for this page, not creating table data");
	}
} //createTable

function isOdd(num) { 
	return num % 2;
} //isOdd

function createTD(tr, dataElement, header, value) {
	dojo.create("td", {
		'class' : (tableInfo.sortColumn == header && value == dataElement) ? "ibm-sort-column" : "",
        innerHTML: dataElement
	}, tr);
}

function dataSort(data, sortBy) {
	//console.log("sortBy is " + sortBy);
	data.sort(function(a,b) {
	    var _A=a[sortBy].toLowerCase(), 
	        _B=b[sortBy].toLowerCase();

	    if (_A < _B) //sort string ascending
	      return -1; 
	    if (_A > _B)
	      return 1;
	    return 0; //default return value (no sorting)
	});
}