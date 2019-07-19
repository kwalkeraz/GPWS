/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

public class PrinterInstallBean {
   
   private int locID = 0; 
   private String geo = "";
   private String country = "";
   private String state = "";
   private String city = "";
   private String building = "";
   private String floor = "";
   private String room = "";
   private String CLSID = "";
   private String CLSID64BIT = "";
   private String pluginURL = "";
   private String pluginsPage = "";
   private String errorURL = "";
   private String successURL = "";
   private String pluginVer = "";
   private String widgetVer = "";
   private String ils = "";
   private String clientUserid = "";
   private String clientPassword = "";
   private String clientDumpDir = "";
   private String ftpSite = "";
   private String ftpPass = "";
   private String ftpUser = "";
   private String ftpHomeDir = "";
   private String prtName = "";
   private String prtModel = "";
   private String prtComment = "";
   private String prtLocation = "";
   private String prtSepFile = "";
   private String restrict = "";
   private String portDB = "";
   private String status = "";
   private String lpname = "";
   private String ipHostname = "";
   private String ipDomain = "";
   private String ipAddress = "";
   private String serverName = "";
   private String commPort = "";
   private String spoolerName = "";
   
   private int printerDefTypeID = 0;
   private String clientDefType = "";
   private int driverSetID = 0;
   private String driverSetName = "";
   
   public String[] protocolType = new String[10];
   public String[] protocolVersion = new String[10];
   public String[] protocolPackage = new String[10];
   
   public String[] osArray = new String[10];
   public int osNumber = 0;

   public String[] driverPackage = new String[10];
   public String[] driverVersion = new String[10];
   public String[] driverName = new String[10];
   public String[] dataFile = new String[10];
   public String[] driverPath = new String[10];
   public String[] configFile = new String[10];
   public String[] helpFile = new String[10];
   public String[] monitor = new String[10];
   public String[] monitorFile = new String[10];
   public String[] fileList = new String[10];
   public String[] defaultType = new String[10];
   public String[] proc = new String[10];
   public String[] procFile = new String[10];
   public String[] prtAttributes = new String[10];
   public String[] changeINI = new String[10];
   public String[] optionsFile = new String[10];
   public String[] hostPortConfig = new String[10];
   public String[] port = new String[10];
   public String[] host = new String[10];
   public String[] spooler = new String[10];

   /** constructor */
   public PrinterInstallBean() {
      // maybe some database calls here to query the user info
   }
   
   public void setLocid (int i) { this.locID = i; }
   public int getLocid () { return this.locID; }
   public void setGeo (String s) { this.geo = s; }
   public String getGeo () { return this.geo; }
   public void setCountry (String s) { this.country = s; }
   public String getCountry () { return this.country; }
   public void setState (String s) { this.state = s; }
   public String getState () { return this.state; }
   public void setCity (String s) { this.city = s; }
   public String getCity () { return this.city; }
   public void setBuilding (String s) { this.building = s; }
   public String getBuilding () { return this.building; }
   public void setFloor (String s) { this.floor = s; }
   public String getFloor () { return this.floor; }
   public void setRoom (String s) { this.room = s; }
   public String getRoom () { return this.room; }
   
   public void setCLSID (String s) { this.CLSID = s; }
   public String getCLSID () { return this.CLSID; }
   public void setCLSID64BIT (String s) { this.CLSID64BIT = s; }
   public String getCLSID64BIT () { return this.CLSID64BIT; }
   public void setPluginURL(String s) { this.pluginURL = s; }
   public String getPluginURL() { return this.pluginURL; }
   public void setPluginsPage(String s) { this.pluginsPage = s; }
   public String getPluginsPage() { return this.pluginsPage; }
   public void setErrorURL(String s) { this.errorURL = s; }
   public String getErrorURL() { return this.errorURL; }
   public void setSuccessURL(String s) { this.successURL = s; }
   public String getSuccessURL() { return this.successURL; }
   public void setPluginVer(String s) { this.pluginVer = s; }
   public String getPluginVer() { return this.pluginVer; }
   public void setWidgetVer(String s) { this.widgetVer = s; }
   public String getWidgetVer() { return this.widgetVer; }
   public void setILS(String s) { this.ils = s; }
   public String getILS() { return this.ils; }
   public void setClientUserid(String s) { this.clientUserid = s; }
   public String getClientUserid() { return this.clientUserid; }
   public void setClientPassword(String s) { this.clientPassword = s; }
   public String getClientPassword() { return this.clientPassword; }
   public void setClientDumpDir(String s) { this.clientDumpDir = s; }
   public String getClientDumpDir() { return this.clientDumpDir; }
   
   public void setFtpSite(String s) { this.ftpSite = s; }
   public String getFtpSite() { return this.ftpSite; }
   public void setFtpPass(String s) { this.ftpPass = s; }
   public String getFtpPass() { return this.ftpPass; }
   public void setFtpUser(String s) { this.ftpUser = s; }
   public String getFtpUser() { return this.ftpUser; }
   public void setFtpHomeDir(String s) { this.ftpHomeDir = s; }
   public String getFtpHomeDir() { return this.ftpHomeDir; }
   
   public void setPrtName(String s) { this.prtName = s; }
   public String getPrtName() { return this.prtName; }
   public void setPrtModel(String s) { this.prtModel = s; }
   public String getPrtModel() { return this.prtModel; }
   public void setPrtComment(String s) { this.prtComment = s; }
   public String getPrtComment() { return this.prtComment; }
   public void setPrtLocation(String s) { this.prtLocation = s; }
   public String getPrtLocation() { return this.prtLocation; }
   public void setPrtSepFile(String s) { this.prtSepFile = s; }
   public String getPrtSepFile() { return this.prtSepFile; }
   public void setRestrict(String s) { this.restrict = s; }
   public String getRestrict() { return this.restrict; }
   public void setPort(String s) { this.portDB = s; }
   public String getPort() { return this.portDB; }
   public void setStatus(String s) { this.status = s; }
   public String getStatus() { return this.status; }
   public void setLPName(String s) { this.lpname = s; }
   public String getLPName() { return this.lpname; }
   
   public void setIPHostname(String s) { this.ipHostname = s; }
   public String getIPHostname() { return this.ipHostname; }
   public void setIPDomain(String s) { this.ipDomain = s; }
   public String getIPDomain() { return this.ipDomain; }
   public void setIPAddress(String s) { this.ipAddress = s; }
   public String getIPAddress() { return this.ipAddress; }
   public void setServerName(String s) { this.serverName = s; }
   public String getServerName() { return this.serverName; }
   public void setCommPort(String s) { this.commPort = s; }
   public String getCommPort() { return this.commPort; }
   public void setSpoolerName(String s) { this.spoolerName = s; }
   public String getSpoolerName() { return this.spoolerName; }
   
   public void setPrinterDefTypeID(int i) { this.printerDefTypeID = i; }
   public int getPrinterDefTypeID() { return this.printerDefTypeID; }
   public void setClientDefType(String s) { this.clientDefType = s; }
   public String getClientDefType() { return this.clientDefType; }
   public void setDriverSetID(int i) { this.driverSetID = i; }
   public int getDriverSetID() { return this.driverSetID; }
   public void setDriverSetName(String s) { this.driverSetName = s; }
   public String getDriverSetName() { return this.driverSetName; }
   
   public void setOSNumber(int i) { this.osNumber = i; }
   public int getOSNumber() { return this.osNumber; }
   public void setOSArray(String[] s) { this.osArray = s; }
   public String[] getOSArray() { return this.osArray; }
   
}