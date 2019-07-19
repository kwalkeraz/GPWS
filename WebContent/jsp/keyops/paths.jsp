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
%>