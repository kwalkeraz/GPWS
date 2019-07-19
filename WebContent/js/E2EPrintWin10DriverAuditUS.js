/**
 * 
 */

var reqApp = angular.module('devApp', []);

reqApp.controller('devController', ['$scope', '$http', '$sce', function($scope, $http, $sce) {
	$scope.loading = true;
	//$http.get('http://gpwstest01.cloud.dst.ibm.com/tools/print/reports/E2EPrintWin10DataAudit.xml').success(function(data) {
	$http.get('http://gpwstest01.cloud.dst.ibm.com/tools/print/reports/E2EPrintWin10DataAudit.json').success(function(data) {
		//$scope.devices = convertJson(data);
		console.log("Inside controller");
		
		$scope.devices = data;
		$scope.getReadyDevices = function() {
			console.log("data.length = " + $scope.devices.length);
			var count = 0;
			for (var x = 0; x < $scope.devices.length; x++) {
				if ($scope.devices[x].Win10Ready == "true") {
					count++;
				}
			}
			return count;
		};
		$scope.displayReadiness = function(item) {
			if (item == "true") {
				return $sce.trustAsHtml("<span class=\"ibm-check-link\"></span>");
			} else {
				return $sce.trustAsHtml("");
			}
		};
		$scope.loading = false;
	});
}]);