
<div id="ibm-content-nav" role="navigation">
<!--
	<div id="ibm-primary-tabs" class="ibm-large-labels">
	 	<ul class="ibm-tabs">
			<li id="GPHome"><a href="/tools/print/index.html"><%= messages.getString("GPWS_home") %></a></li>
			<li id="PrtInstall"><a href="/tools/print/PrinterInstall.html"><%= messages.getString("printer_install") %></a></li>
			<li id="UserInfo"><a href="/tools/print/UserInformation.html"><%= messages.getString("user_info") %></a></li>
			<li id="ServReq"><a href="/tools/print/ServiceRequests.html"><%= messages.getString("service_requests") %></a>
			<li id="GPAdmin"><a href="/tools/print/gpwsadmin.html"><%= messages.getString("GPWS_admin") %></a></li>
		</ul>
	
	</div>
 -->
	<div id="ibm-secondary-tabs">
		<ul class="ibm-tabs">
			<li id="GP"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250"><%= messages.getString("GPWS_administration") %></a></li>
			<li id="KO"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250_KO"><%= messages.getString("Keyop_administration") %></a></li>
			<li id="CP"><a href="<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=250_CP"><%= messages.getString("Common_process_administration") %></a></li>
		</ul>
	</div>				 
</div><!-- CONTENT_NAV_END -->

<script language="Javascript">
updateNav();

function updateNav() {
	var url = window.location.toString();
	
	if (url.indexOf("to_page_id=250_KO") >= 0) {
		dojo.byId("GPAdmin").className = "ibm-active";
		dojo.byId("KO").className = "ibm-active";
	} else if (url.indexOf("prtgateway.wss?to_page_id=250_CP") >= 0) {
		dojo.byId("GPAdmin").className = "ibm-active";
		dojo.byId("CP").className = "ibm-active";
	} else if (url.indexOf("prtgateway.wss") >= 0) {
		dojo.byId("GPAdmin").className = "ibm-active";
		dojo.byId("GP").className = "ibm-active";
	} else if (url.indexOf("keyops.wss") >=0) {
		dojo.byId("GPAdmin").className = "ibm-active";
		dojo.byId("KO").className = "ibm-active";
	} else if (url.indexOf("commonprocess.wss") >=0) {
		dojo.byId("GPAdmin").className = "ibm-active";
		dojo.byId("CP").className = "ibm-active";
	} else if (url.indexOf("printeradmin.wss") >=0) {
		dojo.byId("GPAdmin").className = "ibm-active";
		dojo.byId("ibm-secondary-tabs").style.display = "none";
	//} else if (url.indexOf("printeruser.wss?to_page_id=30")  >= 0 || url.indexOf("printeruser.wss?to_page_id=100") >= 0 || url.indexOf("printeruser.wss?to_page_id=110") >= 0 || url.indexOf("printeruser.wss?to_page_id=39") >= 0 ||url.indexOf("printeruser.wss?to_page_id=36") >= 0) {
	} else if (url.indexOf("printeruser.wss")) {
		dojo.byId("PrtInstall").className = "ibm-active";
		dojo.byId("ibm-secondary-tabs").style.display = "none";
	} else if (url.indexOf("printeruser.wss")) {
		dojo.byId("ibm-secondary-tabs").style.display = "none";
	} else {
		dojo.byId("GPHome").className = "ibm-active";
		dojo.byId("ibm-secondary-tabs").style.display = "none";
	}
}
</script>