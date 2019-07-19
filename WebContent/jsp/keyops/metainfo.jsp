<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.ibm.aurora.*,com.ibm.aurora.bhvr.*,tools.print.lib.*,tools.print.printer.*,tools.print.keyops.*,java.util.*,java.io.*,java.net.*,java.sql.*" %>
<%@ include file="paths.jsp" %>
<%
Locale currentLocale = request.getLocale();
GetTransTag messages = new GetTransTag();
messages.setLocale(currentLocale);
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="schema.DC" href="http://purl.org/DC/elements/1.0/"/>
<link rel="SHORTCUT ICON" href="http://w3.ibm.com/favicon.ico"/>
<meta name="DC.Publisher" content="IBM Corporation"/>
<meta name="DC.Rights" content="(c) Copyright IBM Corp. 2011"/>
<meta name="DC.Date" scheme="iso8601" content="2011-07-14"/>
<meta name="Source" content="v17 Template Generator, Template 17.02"/>
<meta name="Security" content="Public"/>
<meta name="IBM.Effective" scheme="W3CDTF" content="2011-05-01"/>
<meta name="DC.Subject" scheme="IBM_SubjectTaxonomy" content="IBM_SubjectTaxonomy"/>
<meta name="Owner" content="allprtsp@us.ibm.com"/>
<meta name="Feedback" content="allprtsp@us.ibm.com"/>
<meta name="DC.Language" scheme="rfc1766" content="en-US"/>
<meta name="IBM.Country" content="US"/>
<meta name="Robots" content="index,follow"/>
<meta name="DC.Type" scheme="IBM_ContentClassTaxonomy" content="IBM_ContentClassTaxonomy"/>
<script type="text/javascript" src="<%= statichtmldir %>/js/createMetaTag.js"></script>
