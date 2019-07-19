<%
	TableQueryBhvr EquitracServerByVPSX  = (TableQueryBhvr) request.getAttribute("EquitracServerByVPSX");
	TableQueryBhvrResultSet EquitracServerByVPSX_RS = EquitracServerByVPSX.getResults();
	
	TableQueryBhvr EquitracServers  = (TableQueryBhvr) request.getAttribute("EquitracServers");
	TableQueryBhvrResultSet EquitracServers_RS = EquitracServers.getResults();
	
	TableQueryBhvr VPSXCountries  = (TableQueryBhvr) request.getAttribute("VPSXCountriesView");
    TableQueryBhvrResultSet VPSXCountries_RS = VPSXCountries.getResults();

	AppTools appTool = new AppTools();
	String logaction = appTool.nullStringConverter(request.getParameter("logaction"));
	String server = request.getParameter("server");
	String sdc = request.getParameter("sdc");
	String protocol = request.getParameter("protocol");
	String serverid = request.getParameter("serverid");
%>
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print view equitrac servers"/>
	<meta name="Description" content="Global print website view equitrac servers" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("equitrac_server_view") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/addOption.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/globalVariables.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.form.MultiSelect");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 	
    function submitForm(form,msgLoc,msg){
    	var syncValue = true;
    	//if(dojo.isIE) syncValue = true;
    	var xhrArgs = {
	       	form:  form,
	           handleAs: "text",
	           load: function(data, ioArgs) {
	   			if (data.indexOf("Duplicate Row") > -1) {
	   				getID(msgLoc).innerHTML = '<p><a class="ibm-error-link" href="#"></a><%= messages.getString("server_already_exists") %></p>';
	   			} else if (data.indexOf("An error occurred and the country was not added.") > -1) {
	   				getID(msgLoc).innerHTML = '<p><a class="ibm-error-link" href="#"></a><%= messages.getString("error_adding_country_assignment") %></p>';
	   			} else if (data.indexOf("Unknown") > -1 || data.indexOf("An error occurred") > -1) {
	   				getID(msgLoc).innerHTML = '<p><a class="ibm-error-link" href="#"></a><%= messages.getString("error_in_request") %></p>';
	   			} else {
	   				getID(msgLoc).innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
	   				AddParameter("logaction", msg);
	   			};
	           },
	           sync: syncValue,
	           error: function(error, ioArgs) {
	           	console.log(error);
	               getID(msgLoc).innerHTML = genErrorMsg + ioArgs.xhr.status;
	           }
	        };
	     dojo.xhrPost(xhrArgs);
    } //submitForm
    
    function callDeleteServer(serverid, servername) {
		var msg = servername + '<%= messages.getString("has_been_deleted") %> <%= server %>';
		document.deleteServerForm.logactionDS.value = msg;
		document.deleteServerForm.eqserveridDS.value = serverid;
		var confirmDelete = confirm('<%= messages.getString("sure_delete_dce_server") %> ' + servername + '?');
		if (confirmDelete) {
			deleteFunction("deleteServerForm", msg, servername);
		} //if yesno
	};
	
	function deleteFunction(formname, msg,procname){
		var errorMsg = '<p><a class="ibm-error-link"></a><%= messages.getString("error_during_delete") %>: ';
		var syncValue = true;
		var xhrArgs = {
        	form:  formname,
            handleAs: "text",
            load: function(data, ioArgs) {
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + ' <%= messages.getString("delete_restriction_occurred") %></p>';
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    				AddParameter("logaction", msg);
    			}
            },
            sync: syncValue,
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            }
        };
        dojo.xhrPost(xhrArgs);
	} //deleteFunction

	function callDeleteCountry(countryid, country, servername) {
		var msg = country + '<%= messages.getString("has_been_deleted") %>' + servername;
		document.deleteCountryForm.logactionDC.value = msg;
		document.deleteCountryForm.countryidDC.value = countryid;
		var confirmDelete = confirm('<%= messages.getString("sure_delete_country") %> ' + country + '?');
		if (confirmDelete) {
			deleteFunction("deleteCountryForm", msg, country);
		} //if yesno
	};
	
	function showAddServer(serverid, servername) {				
		ibmweb.overlay.show('addServerOverlay', this);
	}
	
	function callAddServer() {
		document.addServerForm.logaction.value = '<%= messages.getString("equitrac_servers_added_successfully") %> <%= server %>.';
		submitForm(dojo.byId("addServerForm"),"msgAddS",document.addServerForm.logaction.value);
	}
	
	function closeAddServerOverlay(){
     	var pop = 'addServerOverlay';
        getID("msgAddS").innerHTML = "";
     	ibmweb.overlay.hide(pop,this);
     } //closeLoc
     
     function showAddCountry(serverid, servername) {
 		ibmweb.overlay.show('addCountryOverlay', this);
 	}
     function callAddCountry() {
 		document.addCountryForm.logaction.value = '<%= messages.getString("countries_added_successfully") %> <%= server %>.';
 		submitForm(dojo.byId("addCountryForm"),"msgAddC",document.addCountryForm.logaction.value);
 	}
 	
 	function closeAddCountryOverlay(){
      	var pop = 'addCountryOverlay';
        getID("msgAddC").innerHTML = "";
      	ibmweb.overlay.hide(pop,this);
      } //closeLoc
     
     function addValues(){
 	 	var selectServers = dijit.byId('servers');
 	 	<% while (EquitracServers_RS.next()) { %>
			    addMultiOption(selectServers, "<%= EquitracServers_RS.getString("SERVER_NAME") %>", "<%= EquitracServers_RS.getInt("SERVERID")%>");
 	 	<% } %>
 	 	
 	 	updateGeo();
 	 } //addValues
 	 
 	function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry(); break;
		} //switch
		return this;
	 } //onChangeCall
	 
	 function resetMenu(dID){
	 	var selectMenu = dijit.byId(dID);
	 	dojo.query("option", selectMenu.domNode).forEach(function(n){
		    n.remove();
		});
	 } //resetMenu
	 
	 function updateGeo(selectedValue,deviceavailable) {
	 	resetMenu('country');
	 	resetMenu('geo');
	 	var dID = "geo";
	 	var params = "query=geography";
	 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
	 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
	 	var tagName = "Name";
	 	var dataTag = "Geography";
	 	getXMLData(url,tagName,dataTag,dID,selectedValue);
	 } //end updateGeo
		 
	 function updateCountry(selectedValue,deviceavailable) {
	 	resetMenu('country');
	 	var dID = "country";
	 	var geo = getSelectValue('geo');
	 	var params = "query=country&geo=" + geo;
	 	params = (deviceavailable != "" && deviceavailable != undefined) ? params + "&deviceavailable="+deviceavailable: params;
	 	var url = "/tools/print/servlet/printeruser.wss?to_page_id=10000&" + params;
	 	var tagName = "Name";
	 	var dataTag = "Country";
	 	if (geo != "None" && geo != "0" && geo != "*") {
	 		getXMLDataMS(url,tagName,dataTag,dID,selectedValue);
	 	}
	 } //end updateCountry
	 
	 function getXMLDataMS(urlValue,tagName,dataTag,dID,selectedValue,locavailable){
	 	dojo.xhrGet({
	      	url : urlValue,
	      	handleAs : "xml",
	    	load : function(response, args) {
	    		var tn = response.getElementsByTagName(tagName);
	      		var dt = response.getElementsByTagName(dataTag);
	      		var selectMenu = dijit.byId(dID);

	      		for (var i = 0; i < tn.length; i++) {
	      			var optionName = tn[i].firstChild.data;
	      			//var optionValue = tn[i].firstChild.data;
	      			//Use the option below if you need to get a tag attribute (ie <Name id=""></Name>
	      			var optionID = dt[i].getAttribute("id");
	      			if (locavailable) {
	      				var locStatus = "";
	      				try {
	      					locStatus = response.getElementsByTagName("Status")[i].firstChild.data;
	      				} catch (e) {
	      					locStatus = "";
	      				}
	      				if (locStatus.toLowerCase() != "deleted" || locStatus == "") {
	      					addMultiOption(selectMenu, optionName, optionID);
	      				} //if not deleted
	      			} else {
	      				addMultiOption(selectMenu, optionName, optionID);
	      			} //else
	      		} //for loop
	      	}, //load function
	      	preventCache: true,
	      	sync: false,
	      	error : function(response, args) {
	      		console.log("Error getting XML data: " + args.xhr.status);
	      	} //error function
	      });
	 } //getXMLData
    
	dojo.ready(function() {
		createHiddenInput('topageidAS','<%= BehaviorConstants.TOPAGE %>','5026','topageidAS');
        createHiddenInput('logactionAS','logaction','','logactionAS');
        createHiddenInput('serveridAS','serverid','<%= serverid %>','serveridAS');
        
		createHiddenInput('topageidAC','<%= BehaviorConstants.TOPAGE %>','5027','topageidAC');
        createHiddenInput('logactionAC','logaction','','logactionAC');
        createHiddenInput('serveridAC','serverid','<%= serverid %>','serveridAC');
        
     	createHiddenInput('topageidDS','<%= BehaviorConstants.TOPAGE %>','5028','topageidDS');
        createHiddenInput('logactionDS','logaction','','logactionDS');
        createHiddenInput('eqserveridDS','eqserverid','','eqserveridDS');
        createHiddenInput('serveridDS','serverid','<%= serverid %>','serveridDS');
        
        createHiddenInput('topageidDC','<%= BehaviorConstants.TOPAGE %>','5029','topageidDC');
        createHiddenInput('logactionDC','logaction','','logactionDC');
        createHiddenInput('countryidDC','countryid','','countryidDC');
        createHiddenInput('serveridDC','serverid','<%= serverid %>','serveridDC');
        
        createTextInput('servernameadd','servername','servername','64',true,'<%= messages.getString("required_info") %>','required','<%= messages.getString("field_problems") %>',g_server_name,'');
        createMultiSelect('servers', 'serversloc','4');
        
        createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
        createMultiSelect('country', 'countryloc','4');
        
        createInputButton('submit_add_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_add_process','callAddServer()');
 		createSpan('submit_add_button','ibm-sep');
	 	createInputButton('submit_add_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_add_process','closeAddServerOverlay()');
	 	
	 	createInputButton('submit_add2_button','ibm-submit','<%= messages.getString("submit") %>','ibm-btn-arrow-pri','submit_edit_process','callAddCountry()');
 		createSpan('submit_add2_button','ibm-sep');
	 	createInputButton('submit_add2_button','ibm-cancel','<%= messages.getString("cancel") %>','ibm-btn-cancel-sec','cancel_edit_process','closeAddCountryOverlay()');
	 	
	 	createPostForm('addServerFormLoc', 'addServerForm','addServerForm','ibm-column-form','<%= prtgateway %>');
 		createPostForm('addCountryFormLoc', 'addCountryForm','addCountryForm','ibm-column-form','<%= prtgateway %>');
 		createPostForm('deleteServerFormLoc','deleteServerForm','deleteServerForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		createPostForm('deleteCountryFormLoc','deleteCountryForm','deleteCountryForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
 		
 		addValues();
	});

    </script>
	
	</head>
	<body id="ibm-com">
	<div id="ibm-top" class="ibm-landing-page">
	<%@ include file="mastheadSecure.jsp" %>
	<%@ include file="../prtuser/WaitMsg.jsp"%>
	<div id="ibm-leadspace-head" class="ibm-alternate">
		<div id="ibm-leadspace-body">
			<ul id="ibm-navigation-trail">
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250"><%= messages.getString("gpws_admin_home") %></a></li>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5010"><%= messages.getString("server_select_location") %></a></li>
				<% if (request.getParameter("referer").equals("5021")) {%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5021&sdc=<%= request.getParameter("sdc") %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } else if (request.getParameter("referer").equals("5022")){%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5022&server=<%= server.toUpperCase() %>"><%= messages.getString("server_select_edit_delete") %></a></li>
				<% } else {%>
				<li><a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=7400"><%= messages.getString("select_server_protocol_process") %></a></li>
				<% } %>
			</ul>
			<h1><%= messages.getString("equitrac_server_view") %></h1>
		</div>
	</div>
	<%@ include file="nav.jsp" %>
<div id="ibm-pcon">
	<!-- CONTENT_BEGIN -->
	<div id="ibm-content">
<!-- CONTENT_BODY -->
	<div id="ibm-content-body">
		<div id="ibm-content-main">
		<!-- LEADSPACE_BEGIN -->
		<p><%= messages.getStringArgs("equitrac_server_info", new String[]{server}) %><br /></p>
		<% if (!logaction.equals("")) { %>
		<p><a class='ibm-confirm-link'></a><%= logaction %></p>
		<% } %>
		<div id='response'></div>
		<p><%= messages.getString("vpsx_server_name") %>: <a href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=5022&servername=<%= server.toUpperCase() %>"><%= server %></a>
		<br /><%= messages.getString("protocol_name") %>: <%= protocol %></p>
		<!-- LEADSPACE_END -->
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
					<div id='deleteServerFormLoc'>
						<div id='topageidDS'></div>
						<div id='logactionDS'></div>
						<div id='eqserveridDS'></div>
						<div id='serveridDS'></div>
						<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all Equitrac servers">
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("equitrac_servers") %>&nbsp;&nbsp;-&nbsp;&nbsp;<a class="ibm-signin-link" href="javascript:void(0);" onClick="showAddServer();"><%= messages.getString("add") %></a></th>
									<th scope="col"><%= messages.getString("delete") %></th>
								</tr>
							</thead>
							<tbody>
								<% if (EquitracServerByVPSX_RS.getResultSetSize() > 0 ) { %> 
									<% while(EquitracServerByVPSX_RS.next()) { %>
								<tr>
									<th class="ibm-table-row" scope="row"><%= EquitracServerByVPSX_RS.getString("SERVER_NAME") %></th>
									<td>
										<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDeleteServer('<%= EquitracServerByVPSX_RS.getInt("EQUITRAC_SERVERID") %>', '<%= EquitracServerByVPSX_RS.getString("SERVER_NAME") %>')" ><%= messages.getString("delete") %></a>
									</td>
								</tr>
									<% } //while %>
								<% } else { %>
								<tr>
									<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_servers_found") %></th>
								</tr>
								<% } %>
							</tbody>
							
						</table>
					</div>
				</div>
				<div class="ibm-col-6-3">
					<div id='deleteCountryFormLoc'>
						<div id='topageidDC'></div>
						<div id='logactionDC'></div>
						<div id='countryidDC'></div>
						<div id='serveridDC'></div>
						<table border="0" cellpadding="0" cellspacing="0" class="ibm-data-table" summary="List all countries associated with this VPSX server">
							<thead>
								<tr>
									<th scope="col"><%= messages.getString("countries_supported") %>&nbsp;&nbsp;-&nbsp;&nbsp;<a class="ibm-signin-link" href="javascript:void(0);" onClick="showAddCountry();"><%= messages.getString("add") %></a></th>
									<th scope="col"><%= messages.getString("delete") %></th>
								</tr>
							</thead>
							<tbody>
								<% if (VPSXCountries_RS.getResultSetSize() > 0 ) { %> 
									<% while(VPSXCountries_RS.next()) { %>
								<tr>
									<th class="ibm-table-row" scope="row"><%= VPSXCountries_RS.getString("COUNTRY") %></th>
									<td>
										<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);" onClick="callDeleteCountry('<%= VPSXCountries_RS.getInt("COUNTRYID") %>','<%= VPSXCountries_RS.getString("COUNTRY") %>', '<%= VPSXCountries_RS.getString("SERVER_NAME") %>')" ><%= messages.getString("delete") %></a>
									</td>
								</tr>
									<% } //while %>
								<% } else { %>
								<tr>
									<th class="ibm-table-row" scope="row" colspan="3"><%= messages.getString("no_countries_found") %></th>
								</tr>
								<% } %>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!--  Add server overlay starts here -->
			<div id="response">
				<div class="ibm-common-overlay" id="addServerOverlay">
					<div class="ibm-head">
						<p><a class="ibm-common-overlay-close" href="#close">Close [x]</a></p>
					</div>
					<div class="ibm-body">
						<div class="ibm-main">
							<div class="ibm-title ibm-subtitle">
								<h1><%= messages.getString("add_equitrac_server") %></h1>
							</div>
						<div class="ibm-container ibm-alternate ibm-buttons-last">
							<div class="ibm-container-body">
								<p class="ibm-overlay-intro"><%= messages.getString("required_info") %>.</p>
								<div id="msgAddS"></div>
									<div id="addServerFormLoc">
										<div id="topageidAS"></div>
										<div id="logactionAS"></div>
										<div id="serveridAS"></div>
										<div class="pClass"><label for="servername"><%= messages.getString("server_name") %>:<span class="ibm-required">*</span></label>
											<span><div id="serversloc"></div></span>
										</div>
										<div class="ibm-overlay-rule"><hr /></div>
										<div class="ibm-buttons-row">
											<div id="submit_add_button" align="right"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
			<!--  Add server overlay ends here -->
			
			<!--  Add country overlay starts here -->
			<div id="response">
				<div class="ibm-common-overlay" id="addCountryOverlay">
					<div class="ibm-head">
						<p><a class="ibm-common-overlay-close" href="#close">Close [x]</a></p>
					</div>
					<div class="ibm-body">
						<div class="ibm-main">
							<div class="ibm-title ibm-subtitle">
								<h1><%= messages.getString("country_add") %></h1>
							</div>
						<div class="ibm-container ibm-alternate ibm-buttons-last">
							<div class="ibm-container-body">
								<p class="ibm-overlay-intro"><%= messages.getString("required_info") %>.</p>
								<div id="msgAddC"></div>
									<div id="addCountryFormLoc">
										<div id="topageidAC"></div>
										<div id="logactionAC"></div>
										<div id="serveridAC"></div>
										<div class="pClass">
											<label id="geolabel" for="geo">
												<%= messages.getString("geography") %>:<span class='ibm-required'>*</span>
											</label>
											<span>
												<div id='geoloc'></div>
												<div id='geoID' connectId="geo" align="right"></div>
											</span>
										</div>
										<p></p>
										<div class="pClass">
											<label id="countrylabel" for="country">
												<%= messages.getString("country") %>:<span class='ibm-required'>*</span>
											</label><br />
											<span>
												<div id='countryloc'></div>
												<div id='countryID' connectId="country" align="right"></div>
											</span>
										</div>
										<div class="ibm-overlay-rule"><hr /></div>
										<div class="ibm-buttons-row">
											<div id="submit_add2_button" align="right"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="ibm-footer"></div>
				</div>
			</div>
			<!--  Add country overlay ends here -->
			
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>