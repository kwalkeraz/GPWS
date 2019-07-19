/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.lib;
/******************************************************************************************
 * Displays the employee information of a person or persons
 * specified by employee serial number with country code.
 *
 * Syntax:  UserInfo - emailAddress passed as a parameter
 *
 * Example:  UserInfo(empSerialCC)
 * 
 * @author: Originally obtained from the BluePages API package (bpjt120.jar)
 * Modified:  by Gerardo Nunez for IBM Global Services on 01/04
 * 				to work with all bluePages Fields.
 * Modified:  by Joe Comfort for IBM Global Services on 05/04
 * 				added isValidEmployee method.
 ******************************************************************************************/

import java.util.*;
import com.ibm.bluepages.*;

// Initialize all the Employee fields provided by the BluePages API
// Please note that this class can be called by another class as long as
// the parameter that you are looking for is specified
// i.e.  employeeName = UserInfo.employeeName(){}
// **NOTE** Anytime that you add or delete a field in the BluePages API that you
// are looking for or wish to remove, you will need to add/remove its own method as well
// Please look below for the correct structure
public class UserInfoCC {
	String employeeName = "not found";  //Employee Name
	String emailAddress = "not found";  //Employee Email Address
	String empSerial = "not found";  //Employee serial number
	String empSerialCC = "not found";  //Employee serial number with country code (CC)
	String empDept = "not found";  //Employee Department
	String empDiv = "not found";  //Employee Division
	String NotesID = "not found";  //Employee Lotus notes ID
	String USERID = "not found";  //Employee userid assigned
	String empBld = "not found";  //Employee Building/Office/Floor location
	String empOffice = "not found";  //Employee Building/Office/Floor location
	String empFloor = "not found";  //Employee Office/Floor location
	String empCC = "not found";  //Employee Country Code
	String empCountry = "not found";  //Employee Country (i.e. USA)
	String empMgrSerial = "not found";  //Employee's Manager Serial number
	String empMgrSerialCC = "not found";  //Employee's Manager Serial number with CC
	String empTie = "not found";  //Employee's Tie line
	String empXphone = "not found";  //Employee's external phone number
	String empPager = "not found";  //Employee's Pager number
	String empPagerID = "not found";   //Employee's Pager ID Number
	boolean isValidEmployee = false;

	public UserInfoCC(String empSerialCC) {

		BPResults results; // Results of BluePages method
		int i; // Loop counter
		Hashtable row; // One row of the results
		
		/*
		* Make sure the name isn't null, as this would match every
		* person in the database.
		*/
		//System.out.println("This is the serial number passed: __" + empSerialCC + "__");
		if (empSerialCC.equals("")) {
			System.out.println("Error: Email Adress is null.");
			return;
		} // end of if statement

		/*
		 * Call the method to fetch the data.
		 */
		results = BluePages.getPersonByCnum(empSerialCC);

		/*
		 * Make sure the method didn't fail unexpectedly.
		 */
		if (!results.succeeded()) {
			System.out.println("Error: " + results.getStatusMsg());
			return;
		} // end of if statement

		/*
		 * Display information found for each matching
		 * person.
		 */

		if (results.rows() == 0)
			System.out.println("No matches found.");
		else {
			isValidEmployee = true;
			for (i = 0; i < results.rows(); i++) {
				row = results.getRow(i);
				employeeName = (String) row.get("NAME");
				empSerial = (String) row.get("EMPNUM");
				emailAddress = (String) row.get("INTERNET");
				empSerialCC = (String) row.get("CNUM");
				empDept = (String) row.get("DEPT");
				empDiv = (String) row.get("DIV");
				NotesID = (String) row.get("NOTESID");
				USERID = (String) row.get("USERID");
				empBld = (String) row.get("BLDG");
				empOffice = (String) row.get("OFFICE");
				empFloor = (String) row.get("FLOOR");
				empCC = (String) row.get("EMPCC");
				empCountry = (String) row.get("COUNTRY");
				empMgrSerial = (String) row.get("MGRNUM");
				empMgrSerialCC = (String) row.get("MNUM");
				empTie = (String) row.get("TIE");
				empXphone = (String) row.get("XPHONE");
				empPager = (String) row.get("PAGER");
				empPagerID = (String) row.get("PAGERID");
			} // end of for loop
		} // end of else

	} //end of UserInfo method
	
	public boolean isValidEmployee() {
		return isValidEmployee;
	}

	// Each employee field requires it's own method
	public String employeeName() {
		return employeeName;
	} //end of employeeName
	
	public String emailAddress() {
		return emailAddress;
	} //end of emailAddress

	public String empSerial() {
		return empSerial;
	} //end of empSerial
	
	public String empSerialCC() {
		return empSerialCC;
	} //end of empSerialCC
	
	public String empDept() {
		return empDept;
	} //end of empDept
	
	public String empDiv() {
		return empDiv;
	} //end of empDiv
	
	public String NotesID() {
		return NotesID;
	} //end of NotesID
	
	public String USERID() {
		return USERID;
	} //end of USERID
	
	public String empBld() {
		return empBld;
	} //end of empBld
	
	public String empOffice() {
		return empOffice;
	} //end of empOffice
	
	public String empFloor() {
		return empFloor;
	} //end of empFloor
	
	public String empCC() {
		return empCC;
	} //end of empCC
	
	public String empCountry() {
		return empCountry;
	} //end of empCountry
	
	public String empMgrSerial() {
		return empMgrSerial;
	} //end of empMgrSerial() 
	
	public String empMgrSerialCC() {
		return empMgrSerialCC;
	} //end of empMgrSerialCC
	
	public String empTie() {
		return empTie;
	} //end of empTie()
	
	public String empXphone() {
		return empXphone;
	} //end of empXphone()
	
	public String empPager() {
		return empPager;
	} //end of empMgrSerial()
	
	public String empPagerID() {
		return empPagerID;
	} //end of empMgrSerial()
	
} // end of class