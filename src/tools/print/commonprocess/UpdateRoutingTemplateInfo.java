package tools.print.commonprocess;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import tools.print.lib.AppTools;

public class UpdateRoutingTemplateInfo {
	
	public int insertTemplateSteps(HttpServletRequest req) throws SQLException, IOException, ServletException {
		AppTools tool = new AppTools();
		Connection con = null;
		PreparedStatement psTemplateSteps = null;
		PreparedStatement psRoutingSteps = null;
		ResultSet TemplateSteps_RS = null;
		ResultSet RoutingSteps_RS = null;
		String cptemplateid = req.getParameter("cptemplateid");
		String cpapprovalid = req.getParameter("cpapprovalid");
		if (cpapprovalid.equals("") || cpapprovalid == null) {
			cpapprovalid="0";
		}
		//Get today's date in yyyy-MM-dd format
		//String todaydate = "";
		//Calendar cal = Calendar.getInstance();
	    //SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	    //todaydate = sdf.format(cal.getTime());
	    //System.out.println("Today's date is " + todaydate);
		//end of date
		
		int ReturnCode = 0;
		String tsQuery = "SELECT CP_TEMPLATE_STEPS_ID, STEP, ACTION_TYPE, STATUS, ASSIGNEE, SCHED_FLOW, COMMENTS, CP_TEMPLATE_ID FROM GPWS.CP_TEMPLATE_STEPS WHERE CP_TEMPLATE_ID = ? ORDER BY STEP";
		String rsQuery = "INSERT INTO GPWS.CP_ROUTING(STEP, ACTION_TYPE, STATUS, ASSIGNEE, SCHED_FLOW, COMMENTS, CPAPPROVALID) VALUES (?,?,?,?,?,?,?)";
		try {
			con = tool.getConnection();
		  	psTemplateSteps = con.prepareStatement(tsQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		  	psTemplateSteps.setInt(1,Integer.parseInt(cptemplateid));
		  	TemplateSteps_RS = psTemplateSteps.executeQuery();
			while (TemplateSteps_RS.next()) {
		  		String step = TemplateSteps_RS.getString("STEP");
		  		String actiontype = TemplateSteps_RS.getString("ACTION_TYPE");
		  		String status = TemplateSteps_RS.getString("STATUS");
		  		String assignee = TemplateSteps_RS.getString("ASSIGNEE");
		  		String schedflow = TemplateSteps_RS.getString("SCHED_FLOW");
		  		String comments = TemplateSteps_RS.getString("COMMENTS");
		  		if (!cpapprovalid.equals("0")) {
		  			psRoutingSteps = con.prepareStatement(rsQuery);
		  			psRoutingSteps.setString(1,step);
		  			psRoutingSteps.setString(2,actiontype);
		  			psRoutingSteps.setString(3,status);
		  			psRoutingSteps.setString(4,assignee);
		  			psRoutingSteps.setString(5,schedflow);
		  			//psRoutingSteps.setString(6,todaydate);
		  			psRoutingSteps.setString(6,comments);
		  			psRoutingSteps.setInt(7,Integer.parseInt(cpapprovalid));
		  			psRoutingSteps.executeUpdate();
			  		ReturnCode = 0;
		  		} //osdriverid not 0
		  	} //while OSView
		} catch (SQLException e){
			System.out.println("CommonProcess error in UpdateRoutingTemplateInfo.class method insertTemplateSteps ERROR1: " + e);
	  		ReturnCode = 1;
	  		String ERROR = Integer.toString(e.getErrorCode());
			String ERRORMESSAGE = e.getMessage();
			req.setAttribute("ERROR",ERROR);
			req.setAttribute("ERRORMESSAGE",ERRORMESSAGE);
	  		try {
	   			tool.logError("UpdateRoutingTemplateInfo.insertTemplateSteps.1", "CommonProcess", e);
	   		} catch (Exception ex) {
	   			System.out.println("CommonProcess Error in UpdateRoutingTemplateInfo.insertTemplateSteps.1 ERROR: " + ex);
	   		}
		} finally {
	  		try {
	  			if (TemplateSteps_RS != null)
	  				TemplateSteps_RS.close();
	  			if (RoutingSteps_RS != null)
	  				RoutingSteps_RS.close();
	  			if (psTemplateSteps != null)
	  				psTemplateSteps.close();
	  			if (psRoutingSteps != null)
	  				psRoutingSteps.close();
		  		if (con != null)
		  			con.close();
	  		} catch (Exception e){
		  		System.out.println("CommonProcess Error in UpdateRoutingTemplateInfo.insertTemplateSteps.2 ERROR: " + e);
	  		}
		} //finally
		
		return ReturnCode;
		
	}  //insert
}
