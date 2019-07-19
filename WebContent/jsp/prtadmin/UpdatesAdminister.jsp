	<%@ include file="metainfo.jsp" %>
	<meta name="Keywords" content="Global Print website import printer data"/>
	<meta name="Description" content="Global print website import printer data information or download csv reports page" />
	<title><%= messages.getString("global_print_title") %> | <%= messages.getString("upload_header") %></title>
	<%@ include file="metainfo2.jsp" %>
	
	<script type="text/javascript">
	 
	 function cancelForm(){
	 	document.location.href="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=250";
	 } //cancelForm
	 
	 function callUpload() {
		var FileName = document.getElementById('file').value;
		if (FileName == '') {
			alert("<%= messages.getString("filename") %>");
			document.getElementById('file').focus();
			return false;
		} else {
			document.getElementById('massUpdateForm').submit();
		}
	} //callUpload
	 
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
			<h1><%= messages.getString("upload_header") %></h1>
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
				<%= messages.getString("required_info") %>.
			</p>
		<!-- LEADSPACE_END -->
			<div id='response'></div>
			<div id='errorMsg'></div>
			<form action="<%= prtgateway %>?<%= BehaviorConstants.TOPAGE %>=531a" name="massUpdateForm" id="massUpdateForm" class="ibm-column-form ibm-styled-form" enctype="multipart/form-data" method="post">
				<input type="hidden" name="upload" value="true" />
				<div id='logactionid'></div>
				<p>
					<label for='file'><%= messages.getString("filename") %>:<span class='ibm-required'>*</span></label>
					<span>
						<input name="file" id="file" size="40" type="file" value=""/>
					</span>
				</p>
				<p>
					<label for='filetype'><%= messages.getString("enter_file_type") %>:<span class='ibm-required'>*</span></label>
					<span style="width: 250px">
						<select name="filetype" id="filetype">
							<option value="noquotes" selected="selected"><%= messages.getString("microsoft_excel_no_quotes") %></option>
							<option value="quotes"><%= messages.getString("lotus_123_quotes") %></option>
						</select>
					</span>
				</p>
				<p>
					<label for='action'><%= messages.getString("type_of_update") %>:<span class='ibm-required'>*</span></label>
					<span style="width: 250px">
					<select name="action" id="action">
						<option value="INSERT" selected="selected">INSERT</option>
						<option value="INSERT_UPDATE">UPDATE</option>
					</select>
					<%= messages.getString("into") %> 
					<select name="table" id="table">
						<option value="DEVICE" selected="selected">DEVICE</option>
						<option value="SERVER">SERVER</option>
					</select>
					</span>
				</p>
				<div class='ibm-overlay-rule'><hr /></div>
				<div class="ibm-buttons-row">
					<p>
						<span>
							<input value="<%= messages.getString("analyze") %>" type="button" name="ibm-submit" class="ibm-btn-arrow-pri" onClick="javascript:callUpload();" />
							<span class="ibm-sep">&nbsp;</span>
							<input value="<%= messages.getString("cancel") %>" type="button" name="ibm-cancel" class="ibm-btn-cancel-sec" onClick="javascript:cancelForm();" />
						</span>
					</p>
				</div>
			</form>
			<div>
				<p>
					<span><%= messages.getString("example_files") %></span>
				</p>
				<ul>
					<li><a href="<%= statichtmldir %>/csv/printer_insert.csv">printer_insert.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/printer_update.csv">printer_update.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/copier_insert.csv">copier_insert.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/copier_update.csv">copier_update.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/fax_insert.csv">fax_insert.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/fax_update.csv">fax_update.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/server_insert.csv">server_insert.csv</a></li>
					<li><a href="<%= statichtmldir %>/csv/server_update.csv">server_update.csv</a></li>
				</ul>
			</div>
		</div>
		<!-- CONTENT_BODY_END -->
	</div>
</div>
<!-- CONTENT_END -->
</div><!-- END ibm-pcon -->
<%@ include file="bottominfo.jsp" %>