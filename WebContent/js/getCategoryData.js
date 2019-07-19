function getCategoryData(sValue) {
	var ElemValue = null;
 	dojo.xhrGet({
		url: "servlet/api.wss/category/name/" + sValue,
        handleAs: "json",
        headers: {
			'Accept': 'application/json'
		},
        preventCache: true,
  		sync: true,
        load: function(responseObject, ioArgs) {
        	//console.log("Category information for " + sValue + " is: ");
        	//console.log("object parsed is " + dojo.toJson(responseObject.value.Model, true));
        	//dojo.forEach(responseObject, function(element) {  //Use this if getting a json object without arrays
        	//dojo.forEach(responseObject.value.Category, function(element) {  //Use this if getting a json array from REST
            	//console.log("Device model is " + element.Name + " Confidential print is " + dojo.toJson(element.ConfidentialPrint, true) + " Strategic is " + dojo.toJson(element.Strategic, true)); 
        		/**
        		var categoryName = element.Category_Name;
                var categoryCode = element.Category_Code;
                var categoryValue1 = element.Category_Value1;
                var categoryValue2 = element.Category_Value2;
                var description = element.Description;
                console.log("Category name is " + categoryName + " and category code " + categoryCode + " and category value 1 " + categoryValue1 + " and category value 2 " + categoryValue2 + " with description " + description);
                **/
                ElemValue = responseObject.value.Category;
        	//});
		},
        error : function(response, ioArgs) {
			console.log("error getting category information: " + response);
			//getID('tbodyId').innerHTML = "<p><a class='ibm-error-link'></a>There was an error getting the data.  Reason: " + response;
		}
	});
 	return ElemValue;
}

function parseCategoryData2(sValue){
	var ElemValue = getCategoryData(sValue);
	dojo.forEach(ElemValue, function(element) {  //Use this if getting a json array from REST
	//for (var key in ElemValue) {
	//console.log("Device model is " + element.Name + " Confidential print is " + dojo.toJson(element.ConfidentialPrint, true) + " Strategic is " + dojo.toJson(element.Strategic, true)); 
		var categoryName = element.Category_Name;
        var categoryCode = element.Category_Code;
        var categoryValue1 = element.Category_Value1;
        var categoryValue2 = element.Category_Value2;
        var description = element.Description;
        console.log("Category name is " + categoryName + " and category code " + categoryCode + " and category value 1 " + categoryValue1 + " and category value 2 " + categoryValue2 + " with description " + description);
	});
	//};
}
