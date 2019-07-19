/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print;

import com.ibm.aurora.*;
import java.io.*;
import java.net.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;


 /**
   * VHD Printer Admin Main servlet that all printer admin website access will pass through
   * 
   * @author VHD Team September 2001
   */
public class PrtGatewayServlet extends AuroraServlet {
   public PrtGatewayServlet() {
       // define the specifics of our package name
      setPackageName("tools.print.prtadmin");
   }
}
