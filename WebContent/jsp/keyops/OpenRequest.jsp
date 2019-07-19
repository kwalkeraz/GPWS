<%@page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %>
<%@ page language="java" buffer="10kb" isThreadSafe="true" autoFlush="true" %>
<%
	int rc = -1;
	int reqNum = 0;
	int[] iRC = new int[2];
	RequestService reqService = new RequestService();
	if (request.getParameter("devicename") == null || request.getParameter("email") == null || request.getParameter("Problem") == null) {
		rc = 3;
	} else {
		reqService.DeviceLookup(request.getParameter("devicename"));
	}
	
	if (rc != 3 && reqService.getIsValidDevice() == false) {
		rc = 4;
	} else if (rc != 3 && reqService.getIsSupportedDevice() == false) { 
		rc = 5;
	} 
	if (rc < 1) {
		iRC = reqService.SubmitForm(request);
		rc = iRC[0];
		reqNum = iRC[1];
	}
%>
rc=<%= rc %><br />
reqNum=<%= reqNum %>