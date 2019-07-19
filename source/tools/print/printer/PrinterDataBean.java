/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.util.*;

 /**
   * Keeps printer information 
   *
   * @author VHD Team October 2001
   */
public class PrinterDataBean {

   private ArrayList prtList = new ArrayList(); 

    /** constructor */
   public PrinterDataBean() {
   }

	/** set and get methonds for Printer information */
   public void setPriterList( ArrayList al ) { this.prtList = al; }
   public ArrayList getPriterList() { return this.prtList; }
}