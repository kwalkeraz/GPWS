/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

 /**
   * Printer specific constants like GUI form and field names, page id's, and session objects.
   *
   * @author VHD Team May 2002
   */
public class PrinterConstants {
    // --------------------------------------------------------------------------------------
    // HTML fields and forms
    // --------------------------------------------------------------------------------------
    /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String CLASSIFIER_FORM = "ClassifierForm";
    /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String CLASSIFIER_ANSWER = "ClassifierAnswer";
   public final static String CLASSIFIER_PARENT = "ClassifierParent";
    /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String LOGIN_NAME = "name";
   public final static String OTHER_SITE_TO_INCLUDE = "website";
   public final static String COOKIE_SEARCH = "vhdsSearchArg";
   public final static String COOKIE_HISTORY = "vhdsHistory";
   public final static String SEARCH_QUERY = "query";
    // no longer in AppData, but still used between files
   public final static String SERVERNAME = "SERVERNAME";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String SEARCH_FORM = "SearchForm";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String SEARCH_NAME = "SearchName";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String GEO = "Geo";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String COUNTRY = "Country";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String STATE = "State";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String CITY = "City";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String BUILDING = "Building";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String FLOOR = "Floor";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String DHCPSTART = "DHCPStart";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String DHCPEND = "DHCPEnd";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String LOCID = "LocID";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOST95 = "host95";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTNT = "hostnt";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTWS = "hostws";
          /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTXP = "hostxp";
          /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTLX = "hostlx";


       /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTORIG95 = "hostorig95";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTORIGNT = "hostorignt";
       /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTORIGWS = "hostorigws";
          /** HTML form string - so we never have a typo between the jsp page and the processing page */
//   public final static String HOSTORIGXP = "hostorigxp";
/** HTML form string - so we never have a typo between the jsp page and the processing page*/
//      public final static String HOSTORIGLX = "hostoriglx";
  /** HTML form string - so we never have a typo between the jsp page and the processing page */
public final static String MESSAGE = "msg";
          /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String PRINTEREDITSUCCESS = "printereditsuccess";
          /** HTML form string - so we never have a typo between the jsp page and the processing page */
   public final static String PRINTERDELETESUCCESS = "printerdeletesuccess";


    // --------------------------------------------------------------------------------------
    // page ids
    // --------------------------------------------------------------------------------------
    /** this must match the page_n for the classifier properties file */
   public final static String PAGEID_SDC_INSTALL = "SDCInstall";
   public final static String PAGEID_SDC_UNINSTALL = "SDCUninstall";
   public final static String PAGEID_PLEASEWAIT = "pleasewait";
   public final static String PAGEID_PLEASEWAIT_ANI = "pleasewait_ani";
   public final static String PAGEID_PLEASEWAIT_TEXT = "pleasewait_text";
    // as we start to move to real names for the pages
   public final static String PAGE_AGENTCHECK = "agentcheck"; // check without loading any objects
   public final static String PAGE_AGENTCHECK2 = "agentcheck2"; // check version number in registry
   public final static String PAGE_CLASSIFIER = "triage";
   public final static String PAGE_ESEARCH = "search";
   public final static String PAGE_ESEARCHRESULTS = "searchresult";
   public final static String PAGE_GETHELP = "gethelp";
   public final static String PAGE_HOME = "home";
   public final static String PAGE_PCCONFIG = "pcconfig";
   public final static String PAGE_SELFHEAL = "selfheal";
   public final static String PAGE_SELFHEAL_BYAPP = "selfheal_byapp";
   public final static String PAGE_SELFHEAL_REPAIR = "selfheal_repair";
   public final static String PAGE_SURVEY = "survey";
   public final static String PAGE_SURVEY_SUBMITTED = "survey_submitted";
   public final static String PAGE_THANKYOU = "thankyou";
   public final static String PAGE_TICKETSUBMIT = "ticket";
   public final static String PAGE_TICKETSUBMITTED = "ticketnum";
   public final static String PAGE_INSTALL = "install";
   public final static String PAGE_PRESITE_CHECKS = "browserChecks";

   public final static String PAGEID_SFOASKACTION = "8";
   public final static String PAGEID_INSTALL = "9";   
   public final static String PAGEID_PRINTERINSTALL = "11";
   public final static String PAGEID_SHOWCLASSIFIER = "14";
   public final static String PAGEID_SHOWSUPPORTACTION = "15";
   public final static String PAGEID_SHOWLEAFNODE = "16";
   public final static String PAGEID_SORRY = "22";
   public final static String PAGEID_REDIRECT = "101";
   public final static String PAGEID_CLOSEWINDOW = "102";
   public final static String PAGEID_INCLUDE_OTHER_SITE = "103";

   public final static String PAGEID_ADMIN_LOGON = "200";
   public final static String PAGEID_ADMIN_x1 = "201"; // used in adminConstants
   public final static String PAGEID_ADMIN_x2 = "202"; // used in adminConstants
   public final static String PAGEID_ADMIN_x3 = "203"; // used in adminConstants
   public final static String PAGEID_ADMIN_x4 = "204"; // used in adminConstants
   public final static String PAGEID_ADMIN_x5 = "205"; // used in adminConstants
   public final static String PAGEID_ADMIN_x6 = "206"; // used in adminConstants
    // --------------------------------------------------------------------------------------
    // Session keys
    // --------------------------------------------------------------------------------------
    /** keys into the user's session object */
   public final static String SESSIONKEY_USER_PROFILE_BEAN = "PrinterUserProfileBean";
    // --------------------------------------------------------------------------------------
    // Property File Keys
    // --------------------------------------------------------------------------------------
   public final static String ApplicationData = "ApplicationData";

   public final static String HTMLDIR = "HTMLDIR";
   public final static String IMAGEDIR = "IMAGEDIR";
   public final static String PLUGINDIR = "PLUGINDIR";
   public final static String CSSDIR = "CSSDIR";
   public final static String JSPDIR = "JSPDIR";
   public final static String STATICHTMLDIR = "STATICHTMLDIR";

   public final static String GATEWAYSERVLET = "GATEWAYSERVLET";
   public final static String ADMINSERVLET = "ADMINSERVLET";
   public final static String AUTHENTICATESERVLET = "AUTHENTICATESERVLET";

   public final static String ESEARCH_SERVER = "ESEARCH_SERVER";
   public final static String ESEARCH_DIRECTORY = "ESEARCH_DIRECTORY";
   public final static String ESEARCH_DEFAULT_DB = "ESEARCH_DEFAULT_DB";
   public final static String SDC_TAC_SERVER = "SDC_TAC_SERVER";
   public final static String SDC_TAC_DIRECTORY = "SDC_TAC_DIRECTORY";
   public final static String SDC_TAC_PARM = "SDC_TAC_PARM";
   
	// Printer Property File Keys
   public final static String PrinterData = "PrinterData";
   public final static String PRINTERUSERSERVLET = "PRINTERUSERSERVLET";
   public final static String PRINTERADMINSERVLET = "PRINTERADMINSERVLET";
   public final static String PRTGATEWAYSERVLET = "PRTGATEWAYSERVLET";
   public final static String COMMONPROCESSSERVLET = "COMMONPROCESSSERVLET";
   public final static String KEYOPSERVLET = "KEYOPSERVLET";
   public final static String KEYOPSERVDIR = "KEYOPSERVDIR";

    // --------------------------------------------------------------------------------------
	// Printer Keys
    // --------------------------------------------------------------------------------------
	
	// YES or NO condition
   public final static String YES = "Y";
   public final static String NO = "N";

	// IP Validation Keys
   public final static String IPRANGE_STATUS = "IPRANGE_STATUS";
   public final static String IP_STATUS = "IP_STATUS";

    // Printer User Install Page Keys
   public final static String PRT_LOCID = "locid";
   public final static String PRT_ROOM = "room";
   public final static String PRT_NAME = "name";

	// Internal or External - Used to identify IBM or Client Super Users
   public final static String INTERNAL = "I";
   public final static String EXTERNAL = "E";
   
   public final static boolean isExternal = false;

	// PRT Admin User
   public final static int PRTADMIN_SUPERUSER = 99;

}
