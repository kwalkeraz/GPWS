package tools.print.commonprocess;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import tools.print.lib.AppTools;

public class UpdateRoutingSteps {
	public int insertSteps(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		int ReturnCode = 0;
		
		PreparedStatement psRoutingSteps = null;
		String rsQuery = "INSERT INTO GPWS.CP_ROUTING(STEP, ACTION_TYPE, STATUS, ASSIGNEE, SCHED_FLOW, START_DATE, COMMENTS, CPAPPROVALID) VALUES (?,?,?,?,?,?,?,?)";
		String cpapprovalid = req.getParameter("cpapprovalid");
		String step = req.getParameter("step");
  		String actiontype = req.getParameter("actiontype");
  		String status = req.getParameter("status");
  		String assignee = req.getParameter("assignee");
  		String schedflow = req.getParameter("schedflow");
  		String startdate = req.getParameter("startdate");
  		String comments = req.getParameter("comments");
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		
		try {
			con = tool.getConnection();
			if (!cpapprovalid.equals("0")) {
				psRoutingSteps = con.prepareStatement(rsQuery);
	  			psRoutingSteps.setInt(1,Integer.parseInt(step));
	  			psRoutingSteps.setString(2,actiontype);
	  			psRoutingSteps.setString(3,status);
	  			psRoutingSteps.setString(4,assignee);
	  			psRoutingSteps.setString(5,schedflow);
	  			psRoutingSteps.setString(6,startdate);
	  			psRoutingSteps.setString(7,comments);
	  			psRoutingSteps.setInt(8,Integer.parseInt(cpapprovalid));
	  			psRoutingSteps.executeUpdate();
		  		ReturnCode = 0;
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method insertSteps ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.insertSteps.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.insertSteps.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psRoutingSteps);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.insertSteps.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
	} //method insertStep
	
	//edit routing steps method
	public int editSteps(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		int ReturnCode = 0;
		
		PreparedStatement psRoutingSteps = null;
		String rsQuery = "UPDATE GPWS.CP_ROUTING SET STEP = ?,  ACTION_TYPE = ?,  STATUS = ? , ASSIGNEE = ? , SCHED_FLOW = ? , START_DATE = ?, COMPLETED_DATE = ?, COMMENTS = ? WHERE CPROUTINGID = ?";
		String cproutingid = req.getParameter("cproutingid");
		String step = req.getParameter("step");
  		String actiontype = req.getParameter("actiontype");
  		String status = req.getParameter("status");
  		String assignee = req.getParameter("assignee");
  		String schedflow = req.getParameter("schedflow");
  		String startdate = req.getParameter("startdate");
  		String completedate = req.getParameter("completedate");
  		String comments = req.getParameter("comments");
		if (cproutingid.equals("") || cproutingid == null) {
			cproutingid="0";
		}
		
		try {
			con = tool.getConnection();
			if (!cproutingid.equals("0")) {
				psRoutingSteps = con.prepareStatement(rsQuery);
	  			psRoutingSteps.setInt(1,Integer.parseInt(step));
	  			psRoutingSteps.setString(2,actiontype);
	  			psRoutingSteps.setString(3,status);
	  			psRoutingSteps.setString(4,assignee);
	  			psRoutingSteps.setString(5,schedflow);
	  			psRoutingSteps.setString(6,startdate);
	  			psRoutingSteps.setString(7,completedate);
	  			psRoutingSteps.setString(8,comments);
	  			psRoutingSteps.setInt(9,Integer.parseInt(cproutingid));
	  			psRoutingSteps.executeUpdate();
		  		ReturnCode = 0;
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method editSteps ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.editSteps.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.editSteps.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psRoutingSteps);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.editSteps.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
	} //method editStep
	
//	edit routing steps method
	public int deleteSteps(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		int ReturnCode = 0;
		
		PreparedStatement psRoutingSteps = null;
		String rsQuery = "DELETE FROM GPWS.CP_ROUTING WHERE CPROUTINGID = ?";
		String cproutingid = req.getParameter("cproutingid");
		if (cproutingid.equals("") || cproutingid == null) {
			cproutingid="0";
		}
		
		try {
			con = tool.getConnection();
			if (!cproutingid.equals("0")) {
				psRoutingSteps = con.prepareStatement(rsQuery);
	  			psRoutingSteps.setInt(1,Integer.parseInt(cproutingid));
	  			psRoutingSteps.executeUpdate();
		  		ReturnCode = 0;
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method deleteSteps ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.deleteSteps.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.deleteSteps.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psRoutingSteps);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.deleteSteps.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
	} //method deleteStep
	
	//Update the Approval record if the status is COMPLETED or REJECTED
	public int updateApproval(HttpServletRequest req, String reqstatus, String completedate) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		int ReturnCode = 0;
		
		PreparedStatement psApproval = null;
		String rsQuery = "UPDATE GPWS.CP_APPROVAL SET REQ_STATUS = ?, COMPLETE_DATE = ? WHERE CPAPPROVALID = ?";
		String cpapprovalid = req.getParameter("cpapprovalid");
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		try {
			con = tool.getConnection();
			if (!cpapprovalid.equals("0")) {
				psApproval = con.prepareStatement(rsQuery);
				psApproval.setString(1,reqstatus);
				psApproval.setString(2,completedate);
				psApproval.setInt(3,Integer.parseInt(cpapprovalid));
				psApproval.executeUpdate();
		  		ReturnCode = 0;
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method updateApproval ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.updateApproval.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.updateApproval.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psApproval);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.updateApproval.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
	} //end of updateApproval
	
//	find the next step that will need to be worked on
	public void findNextStep(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		
		PreparedStatement psSteps = null;
		ResultSet Steps_RS = null;
		String rsQuery = "SELECT * FROM GPWS.CP_ROUTING AS CP_ROUTING LEFT OUTER JOIN GPWS.CATEGORY_VIEW AS CATEGORY_VIEW ON (CP_ROUTING.ASSIGNEE = CATEGORY_VIEW.CATEGORY_CODE) AND (CATEGORY_VIEW.CATEGORY_NAME = 'NotifyList') WHERE CP_ROUTING.CPAPPROVALID = ? AND CP_ROUTING.STEP != ? AND CP_ROUTING.STATUS != 'COMPLETED' AND CP_ROUTING.STATUS != 'REJECTED' AND CP_ROUTING.STATUS != 'CANCELLED' " +
			"AND CP_ROUTING.STEP = (SELECT MIN(STEP) AS STEP FROM GPWS.CP_ROUTING WHERE CPAPPROVALID = ? AND STATUS != 'COMPLETED' AND STATUS != 'REJECTED' AND STATUS != 'CANCELLED')";

		String cpapprovalid = req.getParameter("cpapprovalid");
		String step2 = req.getParameter("step");
		int cproutingid = 0;
		int step = 0;
		String assignee = "";
		String notifylist = "";
		String actiontype = "";
		String status = "";
		String schedflow = "";
		String comments = "";
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		try {
			con = tool.getConnection();
			if (!cpapprovalid.equals("0")) {
				psSteps = con.prepareStatement(rsQuery);
				psSteps.setInt(1,Integer.parseInt(cpapprovalid));
				psSteps.setString(2,step2);
				psSteps.setInt(3,Integer.parseInt(cpapprovalid));
				Steps_RS = psSteps.executeQuery();
				while (Steps_RS.next()) {
					step = Steps_RS.getInt("STEP");
					cproutingid = Steps_RS.getInt("CPROUTINGID");
					assignee = Steps_RS.getString("ASSIGNEE");
					if (assignee == null) assignee = "";
					notifylist = Steps_RS.getString("CATEGORY_VALUE1");
					if (notifylist == null) notifylist = "";
					actiontype = Steps_RS.getString("ACTION_TYPE");
					if (actiontype == null) actiontype = "";
					status = Steps_RS.getString("STATUS");
					if (status == null) status = "";
					schedflow = Steps_RS.getString("SCHED_FLOW");
					if (schedflow == null) schedflow = "";
					comments = Steps_RS.getString("COMMENTS");
					if (comments == null) comments = "";
				} //while Steps_RS
				req.setAttribute("STEP",Integer.toString(step));
				req.setAttribute("CPROUTINGID",Integer.toString(cproutingid));
				req.setAttribute("ASSIGNEE",assignee);
				req.setAttribute("NOTIFYLIST",notifylist);
				req.setAttribute("ACTIONTYPE",actiontype);
				req.setAttribute("STATUS",status);
				req.setAttribute("SCHEDFLOW",schedflow);
				req.setAttribute("COMMENTS",comments);
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method findNextStep ERROR1: " + e);
	  		//ReturnCode = false;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.updateApproval.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.findNextStep.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psSteps);
	  			closeRS(Steps_RS);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.findNextStep.2 ERROR: " + e);
	  		}
		} //finally
		
		//return ReturnCode;
		//return attr;
	} //end of findNextStep
	
//	find out if there are more steps available that are IN PROGRESS or NEW
	public boolean moreSteps(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		boolean ReturnCode = false;
		
		PreparedStatement psSteps = null;
		ResultSet Steps_RS = null;
		String rsQuery = "SELECT * FROM GPWS.CP_ROUTING AS CP_ROUTING LEFT OUTER JOIN GPWS.CATEGORY_VIEW AS CATEGORY_VIEW ON (CP_ROUTING.ASSIGNEE = CATEGORY_VIEW.CATEGORY_CODE) " +
			"AND (CATEGORY_VIEW.CATEGORY_NAME = 'NotifyList') WHERE CP_ROUTING.CPAPPROVALID = ? AND CP_ROUTING.STATUS != 'COMPLETED' AND CP_ROUTING.STATUS != 'REJECTED' AND CP_ROUTING.STATUS != 'CANCELLED'";

		String cpapprovalid = req.getParameter("cpapprovalid");
		int counter = 0; //increment to see if there are any records
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		try {
			con = tool.getConnection();
			if (!cpapprovalid.equals("0")) {
				psSteps = con.prepareStatement(rsQuery);
				psSteps.setInt(1,Integer.parseInt(cpapprovalid));
				Steps_RS = psSteps.executeQuery();
				while (Steps_RS.next()) {
					counter++;
				} //while results
				if (counter > 0) {
					ReturnCode = true;
				}
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method moreSteps ERROR1: " + e);
	  		ReturnCode = false;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.moreSteps.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.moreSteps.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psSteps);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.moreSteps.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
	} //end of moreSteps
	
	public boolean notifyCustomer(String actiontype) throws SQLException, IOException, ServletException { 
		boolean ReturnCode = false;
		//New db connection
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psActionType = null;
		ResultSet rsActionType = null;
		String notify = "";
		// 
		try {
			String sqlQuery = "SELECT * FROM GPWS.CATEGORY_VIEW WHERE UPPER(CATEGORY_NAME) = 'CPROUTINGACTIONTYPE' AND CATEGORY_VALUE1 = ? ORDER BY CATEGORY_NAME, CATEGORY_CODE, CATEGORY_VALUE1, CATEGORY_VALUE2";
			con = tool.getConnection();
			psActionType = con.prepareStatement(sqlQuery);
			psActionType.setString(1,actiontype);
	  		rsActionType = psActionType.executeQuery();
	  		while(rsActionType.next()) {
	  			notify = rsActionType.getString("CATEGORY_VALUE2");
				//System.out.println("notify is " + notify);
				if (notify.toUpperCase().equals("EMAILCUSTOMER=TRUE")) {
					ReturnCode = true;
				} //if
			} //while rsActionType
		} catch (SQLException e) {
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method notifyCustomer ERROR1: " + e);
	  		ReturnCode = false;
	  		try {
	   			tool.logError("UpdateRoutingSteps.notifyCustomer.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.notifyCustomer.1 ERROR: " + ex);
	   		}
		} finally {
			closeRS(rsActionType);
			closePS(psActionType);
			closeConn(con);
		} //finally try and catch
		return ReturnCode;
	} //end of notifyCustomer
	
	public Integer nextStep(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		int nextS = 0;
		String sStep = "";
		
		PreparedStatement psSteps = null;
		ResultSet Steps_RS = null;
		String rsQuery = "SELECT MAX(STEP) AS STEP FROM GPWS.CP_ROUTING WHERE CPAPPROVALID = ? ";

		String cpapprovalid = req.getParameter("cpapprovalid");
		int counter = 0; //increment to see if there are any records
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		try {
			con = tool.getConnection();
			if (!cpapprovalid.equals("0")) {
				psSteps = con.prepareStatement(rsQuery);
				psSteps.setInt(1,Integer.parseInt(cpapprovalid));
				Steps_RS = psSteps.executeQuery();
				while (Steps_RS.next()) {
					sStep = tool.nullStringConverter(Steps_RS.getString("STEP"));
				} //while results
	  		} //cpapprovalid not 0
			if (sStep.equals("")) sStep = "0";
			nextS = Integer.parseInt(sStep);
			nextS = nextS + 1;
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method nextStep ERROR1: " + e);
	  		nextS = 0;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.nextStep.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.nextStep.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psSteps);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.nextStep.2 ERROR: " + e);
	  		}
		} //finally
		
		return nextS;
	} //end of moreSteps
	
	public Boolean stepInProgress(HttpServletRequest req) throws SQLException, IOException, ServletException { 
		AppTools tool = new AppTools();
		Connection con = null;
		boolean inProgress = false;
		
		PreparedStatement psSteps = null;
		ResultSet Steps_RS = null;
		String rsQuery = "SELECT STEP, STATUS FROM GPWS.CP_ROUTING WHERE CPAPPROVALID = ? ";

		String cpapprovalid = req.getParameter("cpapprovalid");
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		try {
			con = tool.getConnection();
			if (!cpapprovalid.equals("0")) {
				psSteps = con.prepareStatement(rsQuery);
				psSteps.setInt(1,Integer.parseInt(cpapprovalid));
				Steps_RS = psSteps.executeQuery();
				while (Steps_RS.next()) {
					String stepstatus = tool.nullStringConverter(Steps_RS.getString("STATUS")).toUpperCase();
					if (stepstatus.equals("IN PROGRESS")) {
						inProgress = true;
					}
					if (inProgress) break;
				} //while results
	  		} //cpapprovalid not 0
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingSteps.class method nextStep ERROR1: " + e);
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingSteps.nextStep.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingSteps.nextStep.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			closePS(psSteps);
	  			closeConn(con);
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingSteps.nextStep.2 ERROR: " + e);
	  		}
		} //finally
		
		return inProgress;
	} //end of inProgress
	
	private static void closePS(PreparedStatement ps) throws SQLException {
		if (ps != null) {
			ps.close();
		} //if
	} //closePS
	
	private static void closeRS(ResultSet rs) throws SQLException {
		if (rs != null) {
			rs.close();
		} //if
	} //closeRS
	
	private static void closeConn(Connection conn) throws SQLException {
		if (conn != null) {
			conn.close();
		} //if
	} //closePS
	
} //class UpdateRoutingSteps
