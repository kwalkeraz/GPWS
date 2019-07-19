<%
/*
This include file just builds the paths...
*/
%>
<%
    // first get the context root to append to all paths
   String contextRoot = request.getContextPath();
    // this is where we get information from PrinterData.properties files
   ParametersBhvr ad = (ParametersBhvr) request.getAttribute(PrinterConstants.PrinterData);
   String imgdir = contextRoot+ad.getData(PrinterConstants.IMAGEDIR);
   String jspdir = contextRoot+ad.getData(PrinterConstants.JSPDIR);
   String cssdir = contextRoot+ad.getData(PrinterConstants.CSSDIR);
   String plugindir = contextRoot+ad.getData(PrinterConstants.PLUGINDIR);
   String htmldir = contextRoot+ad.getData(PrinterConstants.HTMLDIR);
   String statichtmldir = contextRoot;
    // specifically for netscape JAR plugin files, to be installed from the local machine
    // after the installer runs and puts them in this path
   String newplugindir = "file:///c|/program files/support.com/vhd";
    //
   String gateway = contextRoot+ad.getData(PrinterConstants.GATEWAYSERVLET);
   String admin = contextRoot+ad.getData(PrinterConstants.ADMINSERVLET);
   String authenticate = contextRoot+ad.getData(PrinterConstants.AUTHENTICATESERVLET);
   String printeruser = contextRoot+ad.getData(PrinterConstants.PRINTERUSERSERVLET);
   String printeradmin = contextRoot+ad.getData(PrinterConstants.PRINTERADMINSERVLET);
   String prtgateway = contextRoot+ad.getData(PrinterConstants.PRTGATEWAYSERVLET);
   String commonprocess = contextRoot+ad.getData(PrinterConstants.COMMONPROCESSSERVLET);
   //String commonprocess = contextRoot+"/servlet/commonprocess.wss";
   String keyops = contextRoot+ad.getData(PrinterConstants.KEYOPSERVLET);
   String keyopsser = contextRoot+ad.getData(PrinterConstants.KEYOPSERVDIR);
   
   String greenCheckPath = "//w3.ibm.com/ui/v8/images/icon-system-status-ok.gif";
   String redXPath = "//w3.ibm.com/ui/v8/images/icon-system-status-na.gif";
   String alerticonPath = "//w3.ibm.com/ui/v8/images/icon-system-status-alert.gif";
   String asciconPath = "//w3.ibm.com/ui/v8/images/icon-link-sort-a-dark.gif";
   String desciconPath = "//w3.ibm.com/ui/v8/images/icon-link-sort-d-dark.gif";
   String erroriconPath = "//w3.ibm.com/ui/v8/images/icon-error.gif";
   String infoiconPath = "//w3.ibm.com/ui/v8/images/icon-link-popup.gif";
   String helpiconPath = "//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif";
   String downloadiconPath = "//w3.ibm.com/ui/v8/images/icon-link-download.gif";
   String uploadiconPath = "//w3.ibm.com/ui/v8/images/icon-link-upload.gif";
   String calendariconPath = "//w3.ibm.com/ui/v8/images/icon-select-date.gif";
  
   PrinterUserProfileBean pupb = (PrinterUserProfileBean) request.getAttribute(PrinterConstants.SESSIONKEY_USER_PROFILE_BEAN );
%>