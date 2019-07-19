/**
 * 
 */

var reqApp = angular.module('devApp', []);

//reqApp.filter('name', function() {
//	return function(name) {
//		return name + "JOE";
//	};
//});

//reqApp.filter('orderObjectBy', function() {
//	return function(input, attribute) {
//		if (!angular.isObject(input)) return input;
//		
//		var array = [];
//		for(var objectKey in input)
//	}
//})

reqApp.controller('devController', ['$scope', '$http', '$sce', function($scope, $http, $sce) {
	$scope.initial = true;
	
//	$("select").each(function() {
//		console.log("[Angular] updating width: " + this);
//		this.style.width = "220px";
//	});
	
	var config = {headers: {
		'Accept': 'application/json'
	}};
	
	$http.get('http://gpwstest01.cloud.dst.ibm.com/tools/print-prod/servlet/api.wss/geo', config)
	//$http.get('data/geos.json')
	.success(function(data) {
		//console.log("inside success in geoController");
		$scope.geos = data.value.Geography;
	});
	
	$scope.updateCountry = function() {
		//console.log("geo = " + $scope.geo.Name);
		if ($scope.geo != null) {
			$http.get('http://gpwstest01.cloud.dst.ibm.com/tools/print-prod/servlet/api.wss/country/' + $scope.geo.Name, config)
			//$http.get('data/countries-NA.json')
			.success(function(data) {
				//console.log("inside updateCountry in geoController");
				$scope.countries = data.value.Country;
			});
		}
	};
	
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
			$http.get('http://gpwstest01.cloud.dst.ibm.com/tools/print-prod/servlet/api.wss/printer?geo=' + geoName + '&country=' + countryName + '&status=Completed&os=W1064&installable=Y', config).success(function(data) {
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

}]);