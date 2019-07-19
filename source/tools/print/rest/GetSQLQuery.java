package tools.print.rest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import tools.print.lib.AppTools;

public class GetSQLQuery {
	public static String FaxSQLString() {
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		AppTools tool = new AppTools(); 
		String SQLQuery = "";
			
		try {	
			con = tool.getConnection();
			stmt = con.prepareStatement("SELECT CATEGORY_VALUE1, CATEGORY_VALUE2 FROM GPWS.CATEGORY_VIEW WHERE CATEGORY_NAME = ? ORDER BY CAST(CATEGORY_CODE AS INTEGER)");
			stmt.setString(1,"API-Fax");
			rs = stmt.executeQuery(); 
			int count = 0;
			SQLQuery = "SELECT ";
			while (rs.next()) {
				if (count == 0) {
					SQLQuery += "A." + tool.nullStringConverter(rs.getString("CATEGORY_VALUE1"));
					count++;
				} else {
					SQLQuery += ", A." + tool.nullStringConverter(rs.getString("CATEGORY_VALUE1"));
					count++;
				}
			}  //while 
			SQLQuery += ", A.DRIVER_SETID, B.FTP_PASS, B.FTP_USER FROM GPWS.DEVICE_FUNCTIONS_VIEW A LEFT OUTER JOIN GPWS.FTP B ON (A.FTP_SITE = B.FTP_SITE) WHERE A.DEVICE_NAME = ? AND UPPER(A.FUNCTION_NAME) = ? ORDER BY DEVICE_NAME";
				
		} catch(Exception e) {
			System.out.println("Error in AppTools.getLocID ERROR: " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
				System.out.println("Error in AppTools.getLocID ERROR: " + e);
				}
			}
  		return SQLQuery;
	}

}
