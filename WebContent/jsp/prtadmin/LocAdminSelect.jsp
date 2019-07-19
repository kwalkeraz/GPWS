	<%
		AppTools appT = new AppTools();
   		String geo = appT.nullStringConverter(request.getParameter("geo"));
   		String country = appT.nullStringConverter(request.getParameter("country"));
   		String state = appT.nullStringConverter(request.getParameter("state"));
   		String city = appT.nullStringConverter(request.getParameter("city"));
   		String building = appT.nullStringConverter(request.getParameter("building"));
   		String floor = appT.nullStringConverter(request.getParameter("floor"));
   		String logaction = appT.nullStringConverter(request.getParameter("logaction"));
	%>
	
	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print location administration"/>
	<meta name="Description" content="Global print website location administration page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("location_administration") %> </title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript" src="<%= statichtmldir %>/js/resetMenu.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getXMLData.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/getSelectedValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/autoSelectValue.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/updateGeographyInfoNoStatus.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createButton.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createSelect.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createInput.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createForm.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/createDialog.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/loadWaitMsg.js"></script>
	<script type="text/javascript" src="<%= statichtmldir %>/js/miscellaneous.js"></script>
	
	<script type="text/javascript">
	 dojo.require("dojo.parser");
	 dojo.require("dijit.form.Select");
	 dojo.require("dijit.Tooltip");
	 dojo.require("dijit.form.Form");
	 dojo.require("dijit.Dialog");
	 dojo.require("dijit.ProgressBar");
	 dojo.require("dijit.form.ValidationTextBox");
	 dojo.require("dijit.form.Button");
	 
	 function sendToPage(url){
	 	document.location.href=url;
	 } //sendToPage
	 
	 function showReqMsg(reqMsg, tooltipID){
	 	var tooltip = getID(tooltipID);
    	showTTip(reqMsg, tooltip);
	 } //editLoc
	 
	 function callModify(type) {
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	var state = getSelectValue('state');
	 	var site = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	var url = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=";
	 	var params = "";
		
		if (type == "geo") {
			if (geo == "None") {
				showReqMsg('<%= messages.getString("please_select_geo") %>',type);
				return false;
			}
			else {
				params = "161&geo="+geo;
				sendToPage(url + params); 
			} 
		} //if type
		if (type == "country") {
			if (country == "None") {
				showReqMsg('<%= messages.getString("please_select_country") %>',type);
				return false;
			}
			else {
				params = "171&geo="+geo+"&country="+country;
				sendToPage(url + params);
			} 
		}
		if (type == "state") {
			if (state == "None") {
				showReqMsg('<%= messages.getString("please_select_state") %>',type);
				return false;
			}
			else {
				params = "181&geo="+geo+"&country="+country+"&state="+state;
				sendToPage(url + params);
			} 
		}
		if (type == "city") {
			if (site == "None") {
				showReqMsg('<%= messages.getString("please_select_city" ) %>',type);
				return false;
			}
			else {
				params = "191&geo="+geo+"&country="+country+"&state="+state+"&city="+site;
				sendToPage(url + params);
			}
		}
		if (type == "building") {
			if (building == "None") {
				showReqMsg('<%= messages.getString("please_select_building") %>',type);
				return false;
			}
			else {
				params = "201&geo="+geo+"&country="+country+"&state="+state+"&city="+site+"&building="+building;
				sendToPage(url + params);
			} 
		}
		if (type == "floor") {
			if (floor == "None") {
				showReqMsg('<%= messages.getString("please_select_floor") %>',type);
				return false;
			}
			else {
				params = "211&geo="+geo+"&country="+country+"&state="+state+"&city="+site+"&building="+building+"&floor="+floor;
				sendToPage(url + params);
			} //else
		}
	} //callModify
	
	
	 function callAdd(type) {
	 	var geo = getSelectValue('geo');
	 	var country = getSelectValue('country');
	 	var state = getSelectValue('state');
	 	var site = getSelectValue('city');
	 	var building = getSelectValue('building');
	 	var floor = getSelectValue('floor');
	 	var url = "<%= prtgateway %>?<%=  BehaviorConstants.TOPAGE %>=";
	 	var params = "";
		
		if (type == "geo") {
				params = "400";
				sendToPage(url + params); 
		} //if type
		if (type == "country") {
			if (geo == "None") {
				showReqMsg('<%= messages.getString("please_select_geo") %>','geo');
				return false;
			}
			else {
				params = "401&geo="+geo;
				sendToPage(url + params); 
			} 
		}
		if (type == "state") {
			if (country == "None") {
				showReqMsg('<%= messages.getString("please_select_country") %>','country');
				return false;
			}
			else {
				params = "402&geo="+geo+"&country="+country;
				sendToPage(url + params); 
			} 
		}
		if (type == "city") {
			if (state == "None") {
				showReqMsg('<%= messages.getString("please_select_state") %>','state');
				return false;
			}
			else {
				params = "403&geo="+geo+"&country="+country+"&state="+state;
				sendToPage(url + params);
			}
		}
		if (type == "building") {
			if (site == "None") {
				showReqMsg('<%= messages.getString("please_select_city") %>','city');
				return false;
			}
			else {
				params = "404&geo="+geo+"&country="+country+"&state="+state+"&city="+site;
				sendToPage(url + params);
			} 
		}
		if (type == "floor") {
			if (building == "None") {
				showReqMsg('<%= messages.getString("please_select_building") %>','building');
				return false;
			}
			else {
				params = "416&geo="+geo+"&country="+country+"&state="+state+"&city="+site+"&building="+building+"&floor="+floor;
				sendToPage(url + params);
			}
		}
	} //callAdd
	
	function setFormValues(topageid,msg){
		getID("<%= BehaviorConstants.TOPAGE %>").value = topageid;
		getID('logaction').value = msg;
	} //setFormValues
	
	var delFunction = function(e) {
		e.preventDefault();
		//console.log(this.id);
		var msg = "";
		if (e.target.id == 'delgeo') {
			var wName = getSelectValue('geo');
			msg = "Geography " + wName + " has been deleted";
			setFormValues('167',msg);
			if (wName == "None") {
				showReqMsg('<%= messages.getString("please_select_geo") %>','geo');
				return false;
			} else {
				var confirmDelete = confirm('<%= messages.getString("geo_sure_delete") %> ' + wName + ' <%= messages.getString("location_sure_delete_info") %>?');
				if (confirmDelete) {
					deleteFunction(msg, wName);
					updateGeo();
				} //if yesno
			} //else
		}
		if (e.target.id == 'delcountry') {
			var wName = getSelectValue('country');
			msg = "Country " + wName + " has been deleted";
			setFormValues('177',msg);
			if (wName == "None") {
				showReqMsg('<%= messages.getString("please_select_country") %>','country');
				return false;
			} else {
				var confirmDelete = confirm('<%= messages.getString("country_sure_delete") %>' + wName + ' <%= messages.getString("location_sure_delete_info") %>?');
				if (confirmDelete) {
					deleteFunction(msg, wName);
					updateCountry();
				} //if yesno
			} //else
		}
		if (e.target.id == 'delstate') {
			var wName = getSelectValue('state');
			msg = "State " + wName + " has been deleted";
			setFormValues('187',msg);
			if (wName == "None") {
				showReqMsg('<%= messages.getString("please_select_state") %>','state');
				return false;
			} else {
				var confirmDelete = confirm('<%= messages.getString("state_sure_delete") %> ' + wName + ' <%= messages.getString("location_sure_delete_info") %>?');
				if (confirmDelete) {
					deleteFunction(msg, wName);
					updateState();
				} //if yesno
			} //else
		}
		if (e.target.id == 'delcity') {
			var wName = getSelectValue('city');
			msg = "City " + wName + " has been deleted";
			setFormValues('197',msg);
			if (wName == "None") {
				showReqMsg('<%= messages.getString("please_select_site") %>','city');
				return false;
			} else {
				var confirmDelete = confirm('<%= messages.getString("city_sure_delete") %> ' + wName + ' <%= messages.getString("location_sure_delete_info") %>?');
				if (confirmDelete) {
					deleteFunction(msg, wName);
					updateCity();
				} //if yesno
			} //else
		}
		if (e.target.id == 'delbuilding') {
			var wName = getSelectValue('building');
			msg = "Building " + wName + " has been deleted";
			setFormValues('202',msg);
			if (wName == "None") {
				showReqMsg('<%= messages.getString("please_select_building") %>','building');
				return false;
			} else {
				var confirmDelete = confirm('<%= messages.getString("building_sure_delete") %>' + wName + ' <%= messages.getString("location_sure_delete_info") %>?');
				if (confirmDelete) {
					deleteFunction(msg, wName);
					updateBuilding();
				} //if yesno
			} //else
		}
		if (e.target.id == 'delfloor') {
			var wName = getSelectValue('floor');
			msg = "Floor " + wName + " has been deleted";
			setFormValues('212',msg);
			if (wName == "None") {
				showReqMsg('<%= messages.getString("please_select_floor") %>','floor');
				return false;
			} else {
				var confirmDelete = confirm('<%= messages.getString("floor_sure_delete") %> ' + wName + ' <%= messages.getString("location_sure_delete_info") %>?');
				if (confirmDelete) {
					deleteFunction(msg, wName);
					updateFloor();
				} else {
					return false;
				}
			}
		}
	}; //delFunction
	
	function deleteFunction(msg,loc){
		var errorMsg = "<p><a class='ibm-error-link'></a>There was an error during delete: ";
		var xhrArgs = {
        	form:  "deleteForm",
            handleAs: "text",
            sync: true,
            preventCache: true,
            load: function(data, ioArgs) {
            	//console.log(ioArgs);
            	if (data.indexOf("Delete Restriction") > -1) {
        			getID("response").innerHTML = errorMsg + " Delete Restriction. Data exists in current location " + loc +"</p>";
        		} else {
    				getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+ msg +"</p>";
    			}
            },
            error: function(error, ioArgs) {
            	console.log(error);
                getID("response").innerHTML = errorMsg + error + " " + ioArgs.xhr.status +"</p>";
            },
        };
        dojo.xhrPost(xhrArgs);
        //console.log(xhrArgs);
        //console.log("something worked");
	} //deleteFunction
	
	function openLoc(loc){
	 	switch (loc) {
			case 'geo_add': callAdd('geo'); break;
			case 'country_add': callAdd('country'); break;
			case 'state_add': callAdd('state'); break;
			case 'site_add': callAdd('city'); break;
			case 'building_add': callAdd('building'); break;
			case 'floor_add': callAdd('floor'); break;
			case 'geo_edit': callModify('geo'); break;
			case 'country_edit': callModify('country'); break;
			case 'state_edit': callModify('state'); break;
			case 'site_edit': callModify('city'); break;
			case 'building_edit': callModify('building'); break;
			case 'floor_edit': callModify('floor'); break;
		} //switch
	 }
	 
	 function onChangeCall(wName){
	 	switch (wName) {
			case 'geo': updateCountry("<%= country %>"); break;
			case 'country': (dojo.byId('state')) ? updateState("<%= state %>") : updateCity("<%= city %>"); break;
			case 'state': updateCity("<%= city %>"); break;
			case 'city': updateBuilding("<%= building %>"); break;
			case 'building': updateFloor("<%= floor %>"); break;
		} //switch
		return this;
	 } //onChangeCall
    	 
	 dojo.ready(function() {
	 	createpTag();
     	createSelect('geo', 'geo', '<%= messages.getString("select_geo") %>...', 'None', 'geoloc');
     	createSelect('country', 'country', '<%= messages.getString("select_country") %>...', 'None', 'countryloc');
      	createSelect('state', 'state', '<%= messages.getString("select_state") %>...', 'None', 'stateloc');
      	createSelect('city', 'city', '<%= messages.getString("select_site") %>...', 'None', 'cityloc');
      	createSelect('building', 'building', '<%= messages.getString("select_building") %>...', 'None', 'buildingloc');
 		createSelect('floor', 'floor', '<%= messages.getString("select_floor") %>...', 'None', 'floorloc');    
 		createHiddenInput('topageid','<%= BehaviorConstants.TOPAGE %>','');
        createHiddenInput('logactionid','logaction','');
 		createPostForm('addFloor','deleteForm','deleteForm','ibm-column-form ibm-styled-form','<%= prtgateway %>');
		updateGeo("<%= geo %>");
        getID('geo').focus();
        changeSelectStyle('280px');
        <%if (!logaction.equals("")){ %>
        getID("response").innerHTML = "<p><a class='ibm-confirm-link'></a>"+"<%= logaction %>"+"<br /></p>";
        <% } %>
        var idArray = new Array("delgeo","delcountry","delstate","delcity","delbuilding","delfloor");
		for (var i=0; i < idArray.length; i++) {
			dojo.connect(getID(idArray[i]), "onclick", delFunction);
		} //for loop
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
			</ul>
			<h1><%= messages.getString("location_administration") %></h1>
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
			<p>
				<%= messages.getString("required_info") %>
			</p>
			<ul class="ibm-bullet-list ibm-no-links">
				<li><%= messages.getString("location_add_info") %></li>
				<li><%= messages.getString("location_edit_info") %></li>
				<li><%= messages.getString("location_delete_info") %></li>
			</ul>
			<br />
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='addFloor'>
				<div id='topageid'></div>
				<div id='logactionid'></div>
				<div class="pClass" style="width: 65%">
					<label id="geolabel" for="geo">
						<%= messages.getString("geography") %>:<span class="ibm-required">*</span>
					</label>
					<span>
						<div id='geoloc'></div>
						<div id='geoID' connectId="geo" align="right"></div>
						<a class="ibm-maximize-link" href="javascript:void(0);" onClick="openLoc('geo_add')"><%= messages.getString("add") %></a>
						<a class="ibm-signin-link" href="javascript:void(0);" onClick="openLoc('geo_edit')"><%= messages.getString("edit") %></a>
						<a id='delgeo' class="ibm-delete-link" href="javascript:void(0);"><%= messages.getString("delete") %></a>
					</span>
				</div>
				<div class="pClass"></div>
				<div class="pClass" style="width: 65%">
					<label id="countrylabel" for="country">
						<%= messages.getString("country") %>:<span class="ibm-required">*</span>
					</label>
					<span>
						<div id='countryloc'></div>
						<div id='countryID' connectId="country" align="right"></div>
						<a class="ibm-maximize-link" href="javascript:void(0);" onClick="openLoc('country_add')"><%= messages.getString("add") %></a>
						<a class="ibm-signin-link" href="javascript:void(0);" onClick="openLoc('country_edit')"><%= messages.getString("edit") %></a>
						<a id='delcountry' class="ibm-delete-link" href="javascript:void(0);" ><%= messages.getString("delete") %></a>
					</span>
				</div>
				<div class="pClass"></div>
				<div class="pClass" style="width: 65%"> 
					<label id="statelabel" for="state">
						<%= messages.getString("state") %>:
						<span class="ibm-required">*</span>
					</label>
					<span>
						<div id='stateloc'></div>
						<div id='stateID' connectId="state" align="right"></div>
						<a class="ibm-maximize-link" href="javascript:void(0);" onClick="openLoc('state_add')"><%= messages.getString("add") %></a>
						<a class="ibm-signin-link" href="javascript:void(0);" onClick="openLoc('state_edit')"><%= messages.getString("edit") %></a>
						<a id='delstate' class="ibm-delete-link" href="javascript:void(0);" ><%= messages.getString("delete") %></a>
					</span>
				</div>
				<div class="pClass"></div>
				<div class="pClass" style="width: 65%">
					<label id="sitelabel" for="site">
						<%= messages.getString("site") %>:<span class="ibm-required">*</span>
					</label>
					<span>
						<div id='cityloc'></div>
						<div id='siteID' connectId="site" align="right"></div>
						<a class="ibm-maximize-link" href="javascript:void(0);" onClick="openLoc('site_add')"><%= messages.getString("add") %></a>
						<a class="ibm-signin-link" href="javascript:void(0);" onClick="openLoc('site_edit')"><%= messages.getString("edit") %></a>
						<a id='delcity' class="ibm-delete-link" href="javascript:void(0);" ><%= messages.getString("delete") %></a>
					</span>
				</div>
				<div class="pClass"></div>
				<div class="pClass" style="width: 65%">	
					<label id="buildinglabel" for="building">
						<%= messages.getString("building") %>:<span class="ibm-required">*</span>
					</label>
					<span>
					<div id='buildingloc'></div>
						<div id='buildingID' connectId="building" align="right"></div>
						<a class="ibm-maximize-link" href="javascript:void(0);" onClick="openLoc('building_add')"><%= messages.getString("add") %></a>
						<a class="ibm-signin-link" href="javascript:void(0);" onClick="openLoc('building_edit')"><%= messages.getString("edit") %></a>
						<a id='delbuilding' class="ibm-delete-link" href="javascript:void(0);" ><%= messages.getString("delete") %></a>
					</span>
				</div>
				<div class="pClass"></div>
				<div class="pClass" style="width: 65%">
					<label id="floorlabel" for="floor">
						<%= messages.getString("floor") %>:<span class="ibm-required">*</span>
					</label>
					<span>
						<div id='floorloc'></div>
						<div id='floorID' connectId="floor" align="right"></div>
						<a class="ibm-maximize-link" href="javascript:void(0);" onClick="openLoc('floor_add')"><%= messages.getString("add") %></a>
						<a class="ibm-signin-link" href="javascript:void(0);" onClick="openLoc('floor_edit')"><%= messages.getString("edit") %></a>
						<a id='delfloor' class="ibm-delete-link" href="javascript:void(0);" ><%= messages.getString("delete") %></a>
					</span>
				</div>
				<div class="pClass"></div>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>