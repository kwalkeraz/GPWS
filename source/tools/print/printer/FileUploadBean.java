/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.printer;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Locale;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tools.print.lib.GetTransTag;

public class FileUploadBean {

	private String savePath, filepath, filename, contentType, filetype;
	private Dictionary fields;

	public String getFilename() {
		System.out.println("filename in getFilename() is " + filename);
		return filename;
	}

	public String getFilepath() {
		return filepath;
	}


	public String getSavePath() {
		return this.savePath;
	}
  
	public String getFileType() {
		return this.filetype;
	}

	public void setSavePath(String savePath) {
		this.savePath = savePath;
	}

	public String getContentType() {
		return contentType;
	}

	public String getFieldValue(String fieldName) {
		if (fields == null || fieldName == null)
			return null;
		return (String) fields.get(fieldName);
	}

	private void setFilename(String s) {
		if (s==null)
			return;
	
		int pos = s.indexOf("filename=\"");
		if (pos != -1) {
			filepath = s.substring(pos+10, s.length()-1);
			// Windows browsers include the full path on the client
			// But Linux/Unix and Mac browsers only send the filename
			// test if this is from a Windows browser
			pos = filepath.lastIndexOf("\\");
			if (pos != -1)
				filename = filepath.substring(pos + 1);
			else
				filename = filepath;
		}
		System.out.println("filename is " + filename);
	}
	
	private void setContentType(String s) {
		if (s==null)
			return;

		int pos = s.indexOf(": ");
		if (pos != -1)
			contentType = s.substring(pos+2, s.length());
	}

	public void setSavePath() throws IOException {
		//get the operating system is running on
		String os = System.getProperty("os.name");
		String tempdir = System.getProperty("java.io.tmpdir");
		if (os.toLowerCase().indexOf("win") > -1 ){
			setSavePath(tempdir);
		} else if (os.toLowerCase().indexOf("aix") > -1){
			setSavePath("/tmp/");
		} else if (os.toLowerCase().indexOf("linux") > -1) {
			setSavePath("/tmp/");
		} else {
			System.out.println("Operating system " + os  + " is not supported by this program");
		}
	}
	// end of operating system
	
	public void doUpload(HttpServletRequest request) throws IOException {
		ServletInputStream in = null;
	  	//get the operating system is running on
	  	String os = System.getProperty("os.name");
	  	String tempdir = System.getProperty("java.io.tmpdir");
	  	if (os.toLowerCase().indexOf("win") > -1 ){
			setSavePath(tempdir);
		} else if (os.toLowerCase().indexOf("aix") > -1){
		 	setSavePath("/tmp/");
		} else if (os.toLowerCase().indexOf("linux") > -1) {
		 	setSavePath("/tmp/");
		} else {
		 	System.out.println("Operating system " + os  + " is not supported by this program");
		}
	  	// end of operating system
		//setSavePath("/tmp/");
		
	  	try {
	  		in = request.getInputStream();
	    	int max_length_of_data = request.getContentLength();  
	    	byte[] line = new byte[128];
	    	//byte[] line = new byte[max_length_of_data];
	    	int i = in.readLine(line, 0, 128);
	    	//int i = in.readLine(line, 0, max_length_of_data);
	    	// get the request

	    	if (i < 3)
	    		return;
	    	int boundaryLength = i - 2;
	
	    	String boundary = new String(line, 0, boundaryLength); //-2 discards the newline character
	    	fields = new Hashtable();

		    while (i != -1) {
		    	String newLine = new String(line, 0, i);
		    	if (newLine.startsWith("Content-Disposition: form-data; name=\"")) {
		    		if (newLine.indexOf("filename=\"") != -1) {
		    			System.out.println(line);
		    			setFilename(new String(line, 0, i-2));
		    			if (filename==null)
		    				return;
		    			//this is the file content
		    			i = in.readLine(line, 0, 128);
		    			setContentType(new String(line, 0, i-2));
		    			i = in.readLine(line, 0, 128);
		    			// blank line
		    			i = in.readLine(line, 0, 128);
		    			newLine = new String(line, 0, i);
	
		    			PrintWriter pw = null;
		    			try {
		    				pw = new PrintWriter(new BufferedWriter(new FileWriter((savePath==null? "" : savePath) + filename)));
		    				while (i != -1 && !newLine.startsWith(boundary)) {
					            // the problem is the last line of the file content
					            // contains the new line character.
					            // So, we need to check if the current line is
					            // the last line.
		    					i = in.readLine(line, 0, 128);
		    					if ((i==boundaryLength+2 || i==boundaryLength+4) // + 4 is eof
		    					&& (new String(line, 0, i).startsWith(boundary)))
		    						pw.print(newLine.substring(0, newLine.length()-2));
		    					else
		    						pw.print(newLine);
		    					newLine = new String(line, 0, i);
	
		    				}
		    			} catch (Exception e) {
		    			} finally { 
		    				pw.close();
		    			}
		    		} else {
		    			//this is a field
		    			// get the field name
		    			int pos = newLine.indexOf("name=\"");
		    			String fieldName = newLine.substring(pos+6, newLine.length()-3);
		    			//System.out.println("fieldName:" + fieldName);
		    			// blank line
		    			i = in.readLine(line, 0, 128);
				        i = in.readLine(line, 0, 128);
				        newLine = new String(line, 0, i);
				        StringBuffer fieldValue = new StringBuffer(128);
				        while (i != -1 && !newLine.startsWith(boundary)) {
				        	// The last line of the field
				        	// contains the new line character.
				        	// So, we need to check if the current line is
				        	// the last line.
				        	i = in.readLine(line, 0, 128);
				        	if ((i==boundaryLength+2 || i==boundaryLength+4) // + 4 is eof
				        	&& (new String(line, 0, i).startsWith(boundary)))
				        		fieldValue.append(newLine.substring(0, newLine.length()-2));
				        	else
				        		fieldValue.append(newLine);
				        	newLine = new String(line, 0, i);
				        }
				        fields.put(fieldName, fieldValue.toString());
	
				        //if(fieldName.equals("path"))
				        if(fieldName.equals("filetype")) {
				        	//this.savePath=fieldValue.toString();	     
				        	this.filetype=fieldValue.toString();
				        	//System.out.println("save path set");
				        }
		    		}
		    	}
		    	i = in.readLine(line, 0, 128);
	
		    } // end while
	    } catch (Exception e) {
	  		System.out.println("Error in FileUploadBean.doUpload: " + e);
		} finally { 
			in.close();
		}
	}
	
	public String[] getDeviceInfo(Connection con, String[] columns, int numCols, String sDeviceName) throws Exception {
		
		String deviceInfo[] = new String[numCols];
		
		PreparedStatement psDevice = null;
		ResultSet rsDevice = null;
		String sColumns = "";
		for (int x = 1; x < numCols; x++) {
			// Check for non-device_view columns that are program specific.
			if (columns[x] != null && !columns[x].equals("") && columns[x].equals("SERVER")) {
				columns[x] = "SERVER_NAME";
			} else if (columns[x] != null && !columns[x].equals("") && columns[x].equals("OLD_DEVICE_NAME")) {
				columns[x] = "DEVICE_NAME";
			} else if (columns[x] != null && !columns[x].equals("") && columns[x].equals("DRIVER_SET")) {
				columns[x] = "DRIVER_SET_NAME";
			} else if (columns[x] != null && !columns[x].equals("") && columns[x].equals("PRINTER_DEF_TYPE")) {
				columns[x] = "CLIENT_DEF_TYPE";
			}
			// Account for first/non-first columns to properly add commas to query
			if (x == 1 && columns[x] != null && !columns[x].equals("")) {
				if (!columns[x].equals("DEVICE_FUNCTION")) {
					sColumns += columns[x];
				}
			} else if (columns[x] != null && !columns[x].equals("")){
				if (!columns[x].equals("DEVICE_FUNCTION")) {
					sColumns += ", " + columns[x];
				}
			}
		}
		String rsQuery = "SELECT " + sColumns + " FROM GPWS.DEVICE_VIEW WHERE DEVICE_NAME = ?";
				
		try {
			deviceInfo[0] = "Old Value";
			psDevice = con.prepareStatement(rsQuery);
			psDevice.setString(1,sDeviceName);
			rsDevice = psDevice.executeQuery();
			while (rsDevice.next()) {
				for (int x = 1; x < numCols; x++) {
					//if (columns[x] != null && columns[x].toUpperCase().indexOf("DATE") > 0) {
					if(columns[x] != null && (columns[x].toUpperCase().equals("MODIFIED_DATE") || columns[x].toUpperCase().equals("CREATION_DATE"))) {
						deviceInfo[x] = rsDevice.getTimestamp(columns[x]) + "";
					} else if (columns[x] != null && columns[x].equals("DEVICE_FUNCTION")) {
						deviceInfo[x] = "cannot retrieve device function";
					} else {
						deviceInfo[x] = rsDevice.getString(columns[x]);
					}
				}
			} //while results
		} catch (SQLException e){
			deviceInfo[1] = "Could not query db";
			System.out.println("FileUploadBean.getDeviceInfo ERROR: " + e);
		} finally {
	  		try {
	  			if (rsDevice != null) rsDevice.close();
	  			if (psDevice != null) psDevice.close();
	  		} catch (Exception e){
		  		System.out.println("PFileUploadBean.getDeviceInfo ERROR2: " + e);
	  		}
		} //finally
		
		return deviceInfo;
	}
	
	public int getNumMassUpdates(Connection con) throws Exception {
		
		int numMassUpdates = 100;
		PreparedStatement psUpdate = null;
		ResultSet rsUpdate = null;
		
		String rsQuery = "SELECT CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = 'MassUpdate' and CATEGORY_VALUE1 = 'MaxNumEntries'";

		try {
			psUpdate = con.prepareStatement(rsQuery);
			rsUpdate = psUpdate.executeQuery();
			while (rsUpdate.next()) {
				numMassUpdates = Integer.parseInt(rsUpdate.getString("CATEGORY_VALUE2"));
			} //while results
		} catch (SQLException e){
			System.out.println("FileUploadBean.getNumMassUpdates ERROR: " + e);
		} finally {
	  		try {
	  			if (rsUpdate != null) rsUpdate.close();
	  			if (psUpdate != null) psUpdate.close();
	  		} catch (Exception e){
		  		System.out.println("PFileUploadBean.getNumMassUpdates ERROR2: " + e);
	  		}
		} //finally
		
		return numMassUpdates;

	}
}