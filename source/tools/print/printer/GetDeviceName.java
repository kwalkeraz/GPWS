/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.sql.*;
import tools.print.lib.AppTools;


public class GetDeviceName {
	
	public static String country = "";
	public static String sitecode = "";
	public static String deviceFunc = "print";
	public static String LastUsedID = "";
	public static String id = "";	

	public static Connection con;
	public static PreparedStatement pstmt;
	public static ResultSet sqlrs;
	
	public static void setParams(){	}

	public static void setParams(String country,String sitecode) {
		
		AppTools tool = new AppTools();
		try { 
			con = tool.getConnection();
		
			country = country.trim();
			sitecode = sitecode.trim();

			LastUsedID = getLastUsedID(country+sitecode);
			
		} catch (Exception e) {
			System.out.println("GPWS error in GetDeviceName.setParams.2 ERROR: " + e);
		}
	   
	}
	
	public static void setParams(String countryVal,String sitecodeVal, String deviceFuncVal) {
		
		AppTools tool = new AppTools();
		try { 
			con = tool.getConnection();
		
			country = countryVal.trim();
			sitecode = sitecodeVal.trim();
			deviceFunc = deviceFuncVal.trim();

			LastUsedID = getLastUsedID(country+sitecode);
			
		} catch (Exception e) {
			System.out.println("GPWS error in GetDeviceName.setParams.3 ERROR: " + e);
		}
	   
	}


	public static String getName(String countryVal, String sitecodeVal){
		
		String rs="";
		int i,index=0;
		String devFuncLetter = "l";
		if (deviceFunc != null && deviceFunc.equals("copy")) {
			devFuncLetter = "c";
		} else if (deviceFunc != null && deviceFunc.equals("fax")) {
			devFuncLetter = "f";
		} else if (deviceFunc != null && deviceFunc.equals("dipp")) {
			devFuncLetter = "x";
		} else {
			devFuncLetter = "l";
		}
		
		do {
			rs=Getid();
			id = countryVal+sitecodeVal+devFuncLetter+rs;
	
			//id=id.toUpperCase();
			i = CheckId(id);	
			
			if(i != 0) {
				LastUsedID = rs;
			}
	
			index++;
			if(index > 1024) break;
		} while(i != 0);
	
		try {
			if (pstmt != null)
				pstmt.close();
			if (sqlrs != null)
				sqlrs.close();
			if (con != null)
				con.close();
		} catch( Exception e ) {	
				
		}
		
		return id;	
	}
	
	public static String getName(){
		
		String rs="";
		int i,index=0;
		String devFuncLetter = "l";
		if (deviceFunc != null && deviceFunc.equals("copy")) {
			devFuncLetter = "c";
		} else if (deviceFunc != null && deviceFunc.equals("fax")) {
			devFuncLetter = "f";
		} else if (deviceFunc != null && deviceFunc.equals("dipp")) {
			devFuncLetter = "x";
		} else {
			devFuncLetter = "l";
		}
		
		do {
			rs=Getid();
			id = country+sitecode+devFuncLetter+rs;
	
			//id=id.toUpperCase();
			i = CheckId(id);	
			
			if(i != 0) {
				LastUsedID = rs;
			}
	
			index++;
			if(index > 1024) break;
		} while(i != 0);
	
		try {
			if (pstmt != null)
				pstmt.close();
			if (sqlrs != null)
				sqlrs.close();
			if (con != null)
				con.close();
		} catch( Exception e ) {	
				
		}
		
		return id;	
	}

	public static String Getid() {
		String w1 = "";
		String w2 = "";
		String rs = "";
		int test = 0;
	
		w1 = LastUsedID.substring(0,1);
		w2 = LastUsedID.substring(1,2);
	
		if (w2.equals("z") || w2.equals("o")) {
			w2="2";
			if(w1.equals("z") || w1.equals("o")) {
				w1="2";
			} else {
				w1=NextChar(w1);
			}
		} else {
			w2=NextChar(w2);
		}
		
		rs=w1+w2;
	
		return rs;
	}


	public static String NextChar(String ch) {
		int pos;	
		String out;
		char c;
	
		String nums = "23456789abcdefghijklmnpqrstuvwxyz";
	
		pos = nums.indexOf(ch);
	
		if (pos < 0 ) out = "";
		if (pos > nums.length()) out = "";
		if (pos == nums.length()) out = "";
		c = nums.charAt(pos+1);
	
		out = String.valueOf(c);
		return out;
	}


	public static int CheckId(String prtname) {
	
		StringBuffer sb = new StringBuffer();
		String name = "";	
		int iRC = 0;
			
		try{

			String sql = "SELECT DEVICE_NAME FROM GPWS.DEVICE WHERE DEVICE_NAME = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1,prtname);
			
			sqlrs = pstmt.executeQuery();
	
			while(sqlrs.next()){
				name = sqlrs.getString(1);
				if(name.equals(prtname)) {
					iRC = 1;
				}
			}
			
		} catch( Exception e ) {
			System.out.println("GPWS error in GetDeviceName.CheckID ERROR: " + e);	
			iRC = 1;
		}
			
		return iRC;
	}


	public static String getLastUsedID(String prtname) {

		String LastUsedID = "00";
		prtname = prtname + "%";
		try{
	
			String sql = "SELECT LOWER(RIGHT(DEVICE_NAME,2))AS LASTUSEDID FROM GPWS.DEVICE WHERE DEVICE_NAME LIKE ? ORDER BY LASTUSEDID DESC";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1,prtname);
			sqlrs = pstmt.executeQuery();
	
			sqlrs.next();
			LastUsedID = sqlrs.getString("LASTUSEDID");
	
		} catch( Exception e ) {
			System.out.println("GPWS error in GetDeviceName.getLastUsedID ERROR: " + e);	
		}
		
		return LastUsedID;
	
	}
	
}