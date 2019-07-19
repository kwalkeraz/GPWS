/**
 * 
 */
var temp_Array = new Array();
var counter = 0;
function secureField(fieldArray){
	dojo.forEach(fieldArray, function(args){
		//console.log("args is " + args);
		temp_Array[counter] = getHiddenValue(args);
		//console.log("Value of this.temp_Array["+counter+"] is " + temp_Array[counter]);
		dojo.destroy(args);
		counter++;
	});
} //secureFields

function defaultValue(_init, newValue) {
	//console.log("_init is " + _init);
	var _temp = temp_Array[_init];
	//console.log("_temp is " + _temp);
	var _temp2 = "";
	if (_temp != newValue && g_pass_variable != newValue) {
		_temp2 = newValue;
	} else {
		_temp2 = _temp;
	}
	return _temp2;
}  //defaultValue