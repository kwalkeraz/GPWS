/*
 * Licensed Materials - Property of IBM
 * "Restricted Materials of IBM"
 * 5746-SM2
 * (c) Copyright IBM Corp. 2003, 2008 All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

package tools.print.prtadmin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import tools.print.lib.AppTools;

/**
 * @author ganunez
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ServerUpdate {
	/**
	 * Takes the server values to be added and adds it to the server table, then
	 * takes each value of the protocol and adds them to the server_protocol table
	 * 
	 * @param req
	 * @param protocolArray
	 * @return sMessage
	 * @throws SQLException
	 * @throws IOException
	 * @throws ServletException
	 */
	public int insertServer(HttpServletRequest req, String[] protocolArray) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		Connection con = null;
		//Statement stmtServer = null;
		PreparedStatement stmtServer = null;
		PreparedStatement stmtServerProto = null;
		ResultSet rsServer = null;		
		//Get the values
		int locid = 0;
		//Get the location information
		int geoid = 0;
		int countryid = 0;
		int stateid = 0;
		int cityid = 0;
		int buildingid = 0;
		String geo = req.getParameter("geo");
		if (!geo.equals("0")) {
			geoid = Integer.parseInt(req.getParameter("geo"));
		}
		String country = req.getParameter("country");
		if (!country.equals("0")) {
			countryid = Integer.parseInt(req.getParameter("country"));
		}
		String state = req.getParameter("state");
		if (!state.equals("0")) {
			stateid = Integer.parseInt(req.getParameter("state"));
		}
		String city = req.getParameter("city");
		if (!city.equals("0")) {
			cityid = Integer.parseInt(req.getParameter("city"));
		}
		String building = req.getParameter("building");
		if (!building.equals("0")) {
			buildingid = Integer.parseInt(req.getParameter("building"));
		}
		String floor = req.getParameter("floor");
		if (!floor.equals("0")) {
			locid = Integer.parseInt(req.getParameter("floor"));
		}
		String room = req.getParameter("room");
		if (room == null){
			room = "";
		}
		String contactEmail = req.getParameter("contactemail");
		if (contactEmail == null) {
			contactEmail = "";
		}
		String customer = req.getParameter("customer");
		if (customer == null){
			customer = "";
		}
		String comments = req.getParameter("comments");
		if (comments == null){
			comments = "";
		}
		//
		String sdc = req.getParameter("sdc");
		String servername = req.getParameter("servername");
		String serveros = req.getParameter("serveros");
		String serverserial = req.getParameter("serversn");
		String servermodel = req.getParameter("servermodel");
		String ipaddr = req.getParameter("ipaddress");
		int counter = 0;
		int[] protocolid = new int[protocolArray.length];
		String protocolvalue = "";
		while (counter < protocolArray.length) {
			protocolvalue = req.getParameter("protocol"+protocolArray[counter]);
			if (protocolvalue != null) {
				protocolid[counter] = Integer.parseInt(req.getParameter("protocol"+protocolArray[counter]));
			}
			counter++;
		}
		int sMessage = 0;
		boolean dbResult = true;
		
	  try {
	  	con = tool.getConnection();
	  	//stmtServer = con.prepareStatement("INSERT INTO GPWS.SERVER (SERVERID, GEOID, COUNTRYID, STATEID, CITYID, BUILDINGID, LOCID, ROOM, SDC, SERVER_NAME, SERVER_OS, SERVER_SERIAL, SERVER_MODEL, IP_ADDRESS, CUSTOMER, COMMENTS) VALUES (COALESCE((SELECT MAX(SERVERID)+1 FROM GPWS.SERVER),1),?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	  	stmtServer = con.prepareStatement("INSERT INTO GPWS.SERVER (GEOID, COUNTRYID, STATEID, CITYID, BUILDINGID, LOCID, ROOM, SDC, SERVER_NAME, SERVER_OS, SERVER_SERIAL, SERVER_MODEL, IP_ADDRESS, CONTACT_EMAIL, CUSTOMER, COMMENTS) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	  	if (geoid != 0) stmtServer.setInt(1,geoid); else stmtServer.setNull(1,Types.INTEGER);
	  	if (countryid != 0) stmtServer.setInt(2,countryid); else stmtServer.setNull(2,Types.INTEGER);
	  	if (stateid != 0) stmtServer.setInt(3,stateid); else stmtServer.setNull(3,Types.INTEGER);
	  	if (cityid != 0) stmtServer.setInt(4,cityid); else stmtServer.setNull(4,Types.INTEGER);
	  	if (buildingid != 0) stmtServer.setInt(5,buildingid); else stmtServer.setNull(5,Types.INTEGER);
	  	if (locid != 0) stmtServer.setInt(6,locid); else stmtServer.setNull(6,Types.INTEGER);
	  	stmtServer.setString(7,room);
	  	stmtServer.setString(8,sdc);
	  	stmtServer.setString(9,servername);
	  	stmtServer.setString(10,serveros);
	  	stmtServer.setString(11,serverserial);
	  	stmtServer.setString(12,servermodel);
	  	stmtServer.setString(13,ipaddr);
	  	stmtServer.setString(14,contactEmail);
	  	stmtServer.setString(15,customer);
	  	stmtServer.setString(16,comments);
	  	stmtServer.executeUpdate();
		sMessage = 0;
		
		if (sMessage == 0) {
			int serverid = 0;
			int i = 0;
			stmtServerProto = con.prepareStatement("SELECT SERVERID FROM GPWS.SERVER WHERE SERVER_NAME = ? AND SDC = ? AND IP_ADDRESS = ?");
//			System.out.println("SELECT SERVERID FROM GPWS.SERVER WHERE SERVER_NAME = "'+servername+'" AND SDC = ? AND IP_ADDRESS = ?");
			stmtServerProto.setString(1,servername);
			stmtServerProto.setString(2,sdc);
			stmtServerProto.setString(3,ipaddr);
			rsServer = stmtServerProto.executeQuery();
			while (rsServer.next()) {
				serverid = rsServer.getInt("SERVERID");
			} //while rsProtocols
			int protocol_id = 0;
			while (i < protocolid.length) {
				protocol_id = protocolid[i];
				if (protocol_id > 0) {
					stmtServer = con.prepareStatement("INSERT INTO GPWS.SERVER_PROTOCOL (SERVERID, PROTOCOLID) VALUES (?, ?)");
					//System.out.println("INSERT INTO GPWS.SERVER_PROTOCOL (SERVERID, PROTOCOLID) VALUES (" + serverid + ", " + protocolid[i] + ")");
					stmtServer.setInt(1,serverid);
					stmtServer.setInt(2,protocolid[i]);
					stmtServer.executeUpdate();
				}
				i++;
			}
		}
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in ServerUpdate.class method insertServer ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("ServerUpdate.insertServer.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in ServerUpdate.insertServer.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsServer != null)
	  				rsServer.close();
	  			if (stmtServer != null)
		  			stmtServer.close();
	  			if (stmtServerProto != null)
		  			stmtServerProto.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in ServerUpdate.insertServer.2 ERROR: " + e);
	  		}
	  }
	  	return sMessage;
	} //method insertUser
	
	public int updateServer(HttpServletRequest req, String[] protocolArray) throws SQLException, IOException, ServletException {
		
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement stmtServer = null;
		PreparedStatement stmtServer2 = null;
		ResultSet rsServer = null;  // get the Server_protocol values
		int locid = 0;
		//Get the location information
		int serverid = 0;
		String server_id = req.getParameter("serverid");
		if (server_id != null) {
			serverid = Integer.parseInt(server_id);
		}
		int geoid = 0;
		int countryid = 0;
		int stateid = 0;
		int cityid = 0;
		int buildingid = 0;
		int floorid = 0;
		
		String geo = req.getParameter("geo");
		if (!geo.equals("0")) {
			geoid = Integer.parseInt(req.getParameter("geo"));
		}
		String country = req.getParameter("country");
		if (!country.equals("0")) {
			countryid = Integer.parseInt(req.getParameter("country"));
		}
		String state = req.getParameter("state");
		if (!state.equals("0")) {
			stateid = Integer.parseInt(req.getParameter("state"));
		}
		String city = req.getParameter("city");
		if (!city.equals("0")) {
			cityid = Integer.parseInt(req.getParameter("city"));
		}
		String building = req.getParameter("building");
		if (!building.equals("0")) {
			buildingid = Integer.parseInt(req.getParameter("building"));
		}
		String floor = req.getParameter("floor");
		if (!floor.equals("0")) {
			locid = Integer.parseInt(req.getParameter("floor"));
		}
		String room = req.getParameter("room");
		if (room == null) {
			room = "";
		}
		String contactEmail = req.getParameter("contactemail");
		if (contactEmail == null) {
			contactEmail = "";
		}
		String customer = req.getParameter("customer");
		if (customer == null){
			customer = "";
		}
		String comments = req.getParameter("comments");
		if (comments == null){
			comments = "";
		}
		
		//
		String sdc = req.getParameter("sdc");
		String servername = req.getParameter("servername");
		String serveros = req.getParameter("serveros");
		String serverserial = req.getParameter("serversn");
		String servermodel = req.getParameter("servermodel");
		String ipaddr = req.getParameter("ipaddress");
		int counter = 0;
		int[] protocolidparams = new int[protocolArray.length]; //these are the values that have changed/added/or remained the same
		String protocolvalue = "";
		while (counter < protocolArray.length) {
			protocolvalue = req.getParameter("protocol"+protocolArray[counter]);
			if (protocolvalue != null) {
				protocolidparams[counter] = Integer.parseInt(req.getParameter("protocol"+protocolArray[counter]));
			}
			counter++;
		}
		int sMessage = 0;
		boolean dbResult = true;
		
	  try {
	  	con = tool.getConnection();
	  	stmtServer = con.prepareStatement("UPDATE GPWS.SERVER SET GEOID = ?, COUNTRYID = ?, STATEID = ?, CITYID = ?, BUILDINGID = ?, LOCID = ?, ROOM = ?, SDC = ?, SERVER_NAME = ?, SERVER_OS = ?, SERVER_SERIAL = ?, SERVER_MODEL = ?, IP_ADDRESS = ?, CONTACT_EMAIL = ?, CUSTOMER = ?, COMMENTS = ? WHERE SERVERID = ?");
	  	if (geoid != 0) stmtServer.setInt(1,geoid); else stmtServer.setNull(1,Types.INTEGER);
	  	if (countryid != 0) stmtServer.setInt(2,countryid); else stmtServer.setNull(2,Types.INTEGER);
	  	if (stateid != 0) stmtServer.setInt(3,stateid); else stmtServer.setNull(3,Types.INTEGER);
	  	if (cityid != 0) stmtServer.setInt(4,cityid); else stmtServer.setNull(4,Types.INTEGER);
	  	if (buildingid != 0) stmtServer.setInt(5,buildingid); else stmtServer.setNull(5,Types.INTEGER);
	  	if (locid != 0) stmtServer.setInt(6,locid); else stmtServer.setNull(6,Types.INTEGER);
	  	stmtServer.setString(7,room);
	  	stmtServer.setString(8,sdc);
	  	stmtServer.setString(9,servername);
	  	stmtServer.setString(10,serveros);
	  	stmtServer.setString(11,serverserial);
	  	stmtServer.setString(12,servermodel);
	  	stmtServer.setString(13,ipaddr);
	  	stmtServer.setString(14,contactEmail);
	  	stmtServer.setString(15,customer);
	  	stmtServer.setString(16,comments);
	  	stmtServer.setInt(17,serverid);
	  	stmtServer.executeUpdate();
		sMessage = 0;
		
		if (sMessage == 0) {
			stmtServer = con.prepareStatement("SELECT SERVER_PROTOCOLID, SERVERID, SERVER_NAME, PROTOCOLID, PROTOCOL_NAME FROM GPWS.SERVER_PROTOCOL_VIEW WHERE SERVERID = ? ORDER BY PROTOCOL_NAME",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			//System.out.println("SELECT SERVER_PROTOCOLID, SERVERID, SERVER_NAME, PROTOCOLID, PROTOCOL_NAME FROM GPWS.SERVER_PROTOCOL_VIEW WHERE SERVERID = "+serverid+" ORDER BY PROTOCOL_NAME");
			stmtServer.setInt(1,serverid);
			rsServer = stmtServer.executeQuery();
			int serverprotocolid = 0;
			int protocolid = 0;
			int serveridfromtable = 0;
			String servernamefromtable = "";
			String protonamefromtable = "";
			int i = 0;
//			 Loop to delete
			while(rsServer.next()) {
				serverprotocolid = rsServer.getInt("SERVER_PROTOCOLID");
				protocolid = rsServer.getInt("PROTOCOLID");
				serveridfromtable = rsServer.getInt("SERVERID");
				servernamefromtable = rsServer.getString("SERVER_NAME");
				protonamefromtable = rsServer.getString("PROTOCOL_NAME");
				if (req.getParameter("protocol"+protonamefromtable) == null) {
					stmtServer2 = con.prepareStatement("DELETE FROM GPWS.SERVER_PROTOCOL WHERE SERVERID = ? AND PROTOCOLID = ?");
					//System.out.println("DELETE FROM GPWS.SERVER_PROTOCOL WHERE SERVERID = " + serverid + " AND PROTOCOLID = " + protocolid + "");
					stmtServer2.setInt(1,serverid);
					stmtServer2.setInt(2,protocolid);
					stmtServer2.executeUpdate();
				} 
			} //if Message = 0
			
//			 Loop to insert
			for (int x=0; x < protocolidparams.length; x++) {
				boolean exist = false;
				rsServer.beforeFirst();
				while (rsServer.next()) {
					protocolid = rsServer.getInt("PROTOCOLID");
					if (protocolidparams[x] == protocolid) {
						//Values exist, don't do anything
						exist = true;
						break;
					} 
				} //end nested while
				if (exist == false && protocolidparams[x] != 0) {
					stmtServer2 = con.prepareStatement("INSERT INTO GPWS.SERVER_PROTOCOL (SERVERID, PROTOCOLID) VALUES (?, ?)");
					//System.out.println("INSERT INTO GPWS.SERVER_PROTOCOL (SERVERID, PROTOCOLID) VALUES (" + serverid + ", " + protocolidparams[x] + ")");
					stmtServer2.setInt(1,serverid);
					stmtServer2.setInt(2,protocolidparams[x]);
					stmtServer2.executeUpdate();					
				}
			} //end for loop
			
		} //if message=0
		
	  } catch (SQLException e) {
	  		System.out.println("GPWSAdmin error in ServerUpdate.class method updateServer ERROR1: " + e);
	  		dbResult = false;
	  		sMessage = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("ServerUpdate.updateServer.1", "GPWSAdmin", e);
	   		} catch (Exception ex) {
	   			System.out.println("GPWSAdmin Error in ServerUpdate.updateServer.1 ERROR: " + ex);
	   		}
	  } finally {
	  		try {
	  			if (rsServer != null)
	  				rsServer.close();
	  			if (stmtServer != null)
		  			stmtServer.close();
	  			if (stmtServer2 != null)
		  			stmtServer2.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("GPWSAdmin Error in ServerUpdate.updateServer.2 ERROR: " + e);
	  		}
	  }
	  	return sMessage;
	} //method updateServer
	
	/******************************************************************
	 * insertEquitracServer
	 * 
	 * Description: This method will link Equitrac servers to a VPSX server in the VPSX_Equitrac table
	 *  
	 * @param equitracServerIDs - This is the list of Equitrac Server IDs
	 * @param vpsxServerID - This is the VPSX server ID
	 * 
	 ******************************************************************/
	public static int insertEquitracServer(String[] equitracServerIDs, int vpsxServerID) throws ServletException, IOException {
		
		int rc = 0;
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement stmtServer = null;
		
		 try {
			  	con = tool.getConnection();
			  	for (int x=0; x < equitracServerIDs.length; x++) {
			  		stmtServer = con.prepareStatement("INSERT INTO GPWS.VPSX_EQUITRAC (EQUITRAC_SERVERID, VPSX_SERVERID) VALUES (?, ?)");
			  		stmtServer.setInt(1,Integer.parseInt(equitracServerIDs[x]));
			  		stmtServer.setInt(2,vpsxServerID);
			  		stmtServer.executeUpdate();
			  	}
		 } catch (SQLException e) {
		  		System.out.println("GPWSAdmin error in ServerUpdate.insertEquitracServer ERROR1: " + e);
		  		rc = 1;
		  		try {
		   			tool.logError("ServerUpdate.insertEquitracServer.1", "GPWSAdmin", e);
		   		} catch (Exception ex) {
		   			System.out.println("GPWSAdmin Error in ServerUpdate.insertEquitracServer.1 ERROR: " + ex);
		   		}
		  } finally {
		  		try {
		  			if (stmtServer != null)
			  			stmtServer.close();
			  		if (con != null)
			  			con.close();
		  		} catch (Exception e){
			  		System.out.println("GPWSAdmin Error in ServerUpdate.insertEquitracServer.2 ERROR: " + e);
		  		}
		  }
			  	
		
		return rc;
	}
	
	
	/******************************************************************
	 * insertCountries
	 * 
	 * Description: This method will add a country to a VPSX server.
	 * 
	 * @param sCountries - This is the list of countries to add. It is an array of Strings that contains the ID (which is an int)
	 * @param vpsxServerID - This is the VPSX server ID
	 *
	 ******************************************************************/
	public static int insertCountries(String[] sCountries, int vpsxServerID) throws ServletException, IOException {
		
		int rc = 0;
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement stmtServer = null;
		
		 try {
			  	con = tool.getConnection();
			  	for (int x=0; x < sCountries.length; x++) {
			  		stmtServer = con.prepareStatement("INSERT INTO GPWS.VPSX_COUNTRY (COUNTRYID, VPSX_SERVERID) VALUES (?, ?)");
			  		stmtServer.setInt(1,Integer.parseInt(sCountries[x]));
			  		stmtServer.setInt(2,vpsxServerID);
			  		stmtServer.executeUpdate();
			  	}
		 } catch (SQLException e) {
		  		System.out.println("GPWSAdmin error in ServerUpdate.insertCountries ERROR1: " + e);
		  		rc = 1;
		  		try {
		   			tool.logError("ServerUpdate.insertCountries.1", "GPWSAdmin", e);
		   		} catch (Exception ex) {
		   			System.out.println("GPWSAdmin Error in ServerUpdate.insertCountries.1 ERROR: " + ex);
		   		}
		  } finally {
		  		try {
		  			if (stmtServer != null)
			  			stmtServer.close();
			  		if (con != null)
			  			con.close();
		  		} catch (Exception e){
			  		System.out.println("GPWSAdmin Error in ServerUpdate.insertCountries.2 ERROR: " + e);
		  		}
		  }
			  	
		
		return rc;
	}
	
}  //class ServerUpdate
