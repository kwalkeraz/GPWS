/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import com.ibm.aurora.*;
 /**
   * Printer specific Bhvr Errors.
   *
   * @author VHD Team May 2002
   */

public class PrinterBhvrErrors {
   public static int BASE = BhvrErrors.BE_PROJECT_SPECIFIC;
   public static int MALFORMED_URL                     = BASE+1;
   public static int CANT_CONNECT_TO_SERVER            = BASE+2;
   public static int CANT_FIGURE_IF_LEAF               = BASE+3;
   public static int CANT_FIGURE_IF_LEAF_SQL           = BASE+4;
   public static int CANT_LOAD_DATA_NEXT_NODE          = BASE+5;
   public static int CANT_LOAD_DATA_NEXT_NODE_SQL      = BASE+6;
   public static int CANT_LOAD_DATA_ESEARCH_DBLIST     = BASE+7;
   public static int CANT_LOAD_DATA_ESEARCH_DBLIST_SQL = BASE+8;
   public static int CANT_FIGURE_IF_SA	               = BASE+9;
   public static int CANT_FIGURE_IF_SA_SQL	           = BASE+10;
   public static int CANT_FIGURE_IF_EMP_DATA           = BASE+11;
   public static int CANT_FIGURE_IF_EMP_DATA_SQL       = BASE+12;
   public static int ESEARCH_ERROR                     = BASE+13;
   public static int DBBACKUP_ERROR                    = BASE+14;
   public static int CANT_SET_USER_PROFILE_BEAN		   = BASE+15;   
   public static int SQL_DATABASE_ERROR				   = BASE+16;   
}
