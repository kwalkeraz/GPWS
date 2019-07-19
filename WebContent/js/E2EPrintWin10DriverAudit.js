/**
 * 
 */

var num_devices = [];
var newData = "";
var reqApp = angular.module('devApp', []);

reqApp.controller('devController', ['$scope', '$http', '$sce', '$filter', function($scope, $http, $sce, $filter) {
	$scope.initial = true;
	var host = "http://gpwstest01.cloud.dst.ibm.com/tools/print-prod/servlet/api.wss/";
	getGeo($http, $scope, host);

	$scope.avail="A";
	/*
	var config = {headers: {
		'Accept': 'application/json'
	}};
	
	$http.get(host  + 'geo', config)
	//$http.get('data/geos.json')
	.success(function(data) {
		//console.log("inside success in geoController");
		$scope.geos = data.value.Geography;
	});
	
	$scope.updateCountry = function() {
		//console.log("geo = " + $scope.geo.Name);
		if ($scope.geo != null) {
			$http.get(host + 'country/' + $scope.geo.Name, config)
			//$http.get('data/countries-NA.json')
			.success(function(data) {
				//console.log("inside updateCountry in geoController");
				$scope.countries = data.value.Country;
			});
		}
	};
	*/	

	$scope.$watch('geo', function(newVal) {
		$scope.countries = "";
		$scope.devices = "";
		$scope.initial = true;
		if (angular.isUndefined($scope.geo) || $scope.geo == null || $scope.geo == "") return;
		//console.log("Text selected is " + $scope.geo.Name + " with value " + $scope.geo.id);
		
		getCountry($http, $scope, host);
	});

	$scope.$watch('country', function(newVal) {
		if (angular.isUndefined($scope.country) || $scope.country == null || $scope.country == "") return;
		//udpateDevices($https, $scope, $sce, host);
		getDevices($http, $scope, $sce, host);
		//newData = createNewArray(num_devices);
		createCSVlink($scope.geo.Name+"_"+$scope.country.Name);
	});

	$scope.$watch('avail',function(newVal) {
		var temp_array = [];
		//console.log("Text selected " + $scope.devices.DriverName);
		//temp_array = $scope.devices;
		angular.forEach(num_devices, function(x) {
			//console.log("Device driver is " + x.DriverName + " and newVal is " + newVal);
			if (x.DriverName != "" && newVal == 'Y') {
				temp_array.push(x);
			} else if (x.DriverName == "" && newVal == 'N') {
				temp_array.push(x);
			} else if (newVal == 'A') {
				temp_array.push(x);
			}
		});
		$scope.devices = temp_array;
		newData = createNewArray($scope.devices);
		//console.log("The final array is " + temp_array);
	});

	$scope.getReadyDevices = function() {
		//console.log("data.length = " + $scope.devices.length);
		var count = 0;
		//for (var x = 0; x < $scope.devices.length; x++) {
		angular.forEach($scope.devices, function(x) {
			//if ($scope.devices[x].DriverName != "") {
			if( x.DriverName != "" ) {
				count++;
			}
		//} //for loop
		});
		return count;
	};
	$scope.displayReadiness = function(item) {
		if (item != "") {
			return $sce.trustAsHtml("<span class=\"ibm-check-link\"></span>");
		} else {
			return $sce.trustAsHtml("");
		}
	};

	/*
	$scope.updateDevices = function() {
		if ($scope.country != null) {
			$scope.devices = "";
			$scope.initial = false;
			$scope.loading = true;
			var config = {headers: {
				'Accept': 'application/json'
			}};
			var geoName = $scope.geo.Name;
			var countryName = $scope.country.Name;
			$http.get(host+'printer?geo=' + geoName + '&country=' + countryName + '&status=Completed&os=W1064&installable=Y', config).success(function(data) {
			//$http.get('data/devices.json', config).success(function(data) {
				//console.log("Inside controller");
				
				$scope.devices = data.value.Printer;
				$scope.getReadyDevices = function() {
					//console.log("data.length = " + $scope.devices.length);
					var count = 0;
					for (var x = 0; x < $scope.devices.length; x++) {
						if ($scope.devices[x].DriverName != "") {
							count++;
						}
					}
					return count;
				};
				$scope.displayReadiness = function(item) {
					if (item != "") {
						return $sce.trustAsHtml("<span class=\"ibm-check-link\"></span>");
					} else {
						return $sce.trustAsHtml("");
					}
				};
				$scope.loading = false;
			});
		}
	};
	*/

}]);

function getGeo($http, $scope, url) {
	var purl = url  + 'geo';
	$http.get(purl)
	.then(function(response) {
		$scope.geos = response.data.value.Geography;
	});
}

function getCountry($http, $scope, url) {
	var geo = $scope.geo.Name;
	var purl = url + 'country/' + $scope.geo.Name;
	if (angular.isUndefined(geo) && geo == null && geo == "" && geo == undefined) return;
	
	$http.get(purl)
	.then(function(response) {
		$scope.countries = response.data.value.Country;
	});
}

function getDevices($http, $scope, $sce, url) {
	if ($scope.country != null) {
		$scope.devices = "";
		$scope.initial = false;
		$scope.showFilters = true;
		$scope.loading = true;
		var geoName = $scope.geo.Name;
		var countryName = $scope.country.Name;
		$http.get(url+'printer?geo=' + geoName + '&country=' + countryName + '&status=Completed&os=W1064&installable=Y')
		.then(function(response) {
			$scope.devices = response.data.value.Printer;
			num_devices = $scope.devices;
			/**			
			$scope.getReadyDevices = function() {
				//console.log("data.length = " + $scope.devices.length);
				var count = 0;
				//for (var x = 0; x < $scope.devices.length; x++) {
				angular.forEach($scope.devices, function(x) {
					//if ($scope.devices[x].DriverName != "") {
					if( x.DriverName != "" ) {
						count++;
					}
				//} //for loop
				});
				return count;
			};
			$scope.displayReadiness = function(item) {
				if (item != "") {
					return $sce.trustAsHtml("<span class=\"ibm-check-link\"></span>");
				} else {
					return $sce.trustAsHtml("");
				}
			};
			**/
			$scope.loading = false;
			newData = createNewArray(num_devices);
		});
	}
}
