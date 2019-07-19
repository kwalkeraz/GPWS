function onGo(link) {
	document.location.href=link;
	return false;
}
function callModifyRequest(cpapprovalid,reqtype) {
	if (reqtype.toUpperCase() == "CHANGE") {
		var params ="&cpapprovalid=" + cpapprovalid;
		var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=1601"+params;
	} else {
		var params ="&cpapprovalid=" + cpapprovalid;
		var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=1600"+params;
	}
	onGo(uRL);
}
function callModifyRouting(cpapprovalid,reqnum) {
	var params ="&cpapprovalid=" + cpapprovalid + "&reqnum=" + reqnum;
	var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7420"+params;
	//onGo(uRL);
	document.location.href=uRL;
}
function callReassignRoutingStep(cproutingid) {
	var params ="&cproutingid=" + cproutingid;
	var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7470"+params;
	onGo(uRL);
}
function callModifyRoutingStep(cproutingid) {
	var params ="&cproutingid=" + cproutingid;
	var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7430"+params;
	onGo(uRL);
}
function callEditCPNotes(cpnotesid) {
	var params ="&cpnotesid=" + cpnotesid;
	var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7130"+params;
	onGo(uRL);
}
function callAddCPNotes(cproutingid) {
	var params ="&cproutingid=" + cproutingid;
	var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7100"+params;
	onGo(uRL);
}
function callCompleteRoutingStep(cproutingid) {
	var params ="&cproutingid=" + cproutingid;
	var uRL = "<%= commonprocess %>?<%=  BehaviorConstants.TOPAGE %>=7460"+params;
	onGo(uRL);
}
function callBrowsePrinter(Prtname) {
	var params ="&name=" + Prtname;
	var uRL = "<%= printeruser %>?<%=  BehaviorConstants.TOPAGE %>=55"+params;
	onGo(uRL);
}
function callModifyPrinter(Prtname, locid) {
	var params ="&name=" + Prtname + "&locid=" + locid;
	var uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=283"+params;
	onGo(uRL);
}
function callModifyPrinterMisc(Prtname) {
	var params ="&SearchName=" + Prtname;
	var uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=2110"+params;
	onGo(uRL);
}
function callModifyPrinterEnablements(Prtname) {
	var params ="&name=" + Prtname;
	var uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=7210"+params;
	onGo(uRL);
}
function callBrowseDevice(Prtname) {
	var params ="&name=" + Prtname;
	var uRL = "<%= printeruser %>?<%=  BehaviorConstants.TOPAGE %>=65"+params;
	onGo(uRL);
}
function callModifyDevice(Prtname, geo, country, city, building, floor) {
	var params ="&name=" + Prtname;
	params = params + "&geo=" + geo + "&country=" + country + "&city=" + city + "&building=" + building + "&floor=" + floor
	var uRL = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=961"+params;
	onGo(uRL);
}