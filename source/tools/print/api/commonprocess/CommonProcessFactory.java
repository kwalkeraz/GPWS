package tools.print.api.commonprocess;

import java.util.List;
import java.util.Map;

import tools.print.api.commonprocess.Request.RoutingSteps;
import tools.print.api.commonprocess.Request;
import tools.print.api.commonprocess.ObjectFactory;
import tools.print.rest.PrepareConnection;

public class CommonProcessFactory {
	public static Request RequestCreateList(ObjectFactory factory, int cpapprovalid, String requestNumber, String status, String action, String deviceName,
			String functions, String geo, String country, String city, String building, String floor, String room, String requesterName, String emailAddress,
			String phone, String requestedDate, String justification, String cs, String mvs, String vm, String sap, String wts, List<Map<String, Object>> routingSteps) {
		Request request = factory.createRequest();
		PrepareConnection pc = new PrepareConnection();
		
		request.setCPApprovalID(cpapprovalid);
		request.setRequestNumber(requestNumber);
		request.setStatus(status);
		request.setAction(action);
		request.setDeviceName(deviceName);
		request.setFunctions(functions);
		request.setGeography(geo);
		request.setCountry(country);
		request.setCity(city);
		request.setBuilding(building);
		request.setFloor(floor);
		request.setRoom(room);
		request.setRequesterName(requesterName);
		request.setEmailAddress(emailAddress);
		request.setPhone(phone);
		request.setRequestedCompletionDate(requestedDate);
		request.setJustification(justification);
		request.setCS(cs);
		request.setMVS(mvs);
		request.setVM(vm);
		request.setSAP(sap);
		request.setWTS(wts);
		for(Map<String, Object> y : routingSteps) {
			int cproutingid = 0;
			String templateName = "";
			String step = "";
			String actionType = "";
			String routStatus = "";
			String assignee = "";
			String completedby = "";
			String schedFlow = "";
			String schedDate = "";
			String completedDate = "";
			String comments = "";
			String startDate = "";
			String schedEndDate = "";
			cproutingid = pc.returnKeyValueInt(y, "CPROUTINGID");
			templateName = pc.returnKeyValue(y, "TEMPLATE_NAME");
			step = pc.returnKeyValue(y, "STEP");
			actionType = pc.returnKeyValue(y, "ACTION_TYPE");
			routStatus = pc.returnKeyValue(y, "STATUS");
			assignee = pc.returnKeyValue(y, "ASSIGNEE");
			completedby = pc.returnKeyValue(y, "COMPLETE_BY");
			schedFlow = pc.returnKeyValue(y, "SCHED_FLOW");
			schedDate = pc.returnKeyValue(y, "SCHED_DATE");
			completedDate = pc.returnKeyValue(y, "COMPLETED_DATE");
			comments = pc.returnKeyValue(y, "COMMENTS");
			startDate = pc.returnKeyValue(y, "START_DATE");
			schedEndDate = pc.returnKeyValue(y, "SCHED_END_DATE");
			request.getRoutingSteps().add(RoutingCreateList(factory, cproutingid, templateName, step, actionType, routStatus,assignee, completedby, schedFlow, schedDate, 
					completedDate, comments, startDate, schedEndDate));
		}
		
		return request;
	}
	
	public static RoutingSteps RoutingCreateList(ObjectFactory factory, int cproutingid, String templateName, String step, String actionType, String routStatus,
			String assignee, String completedby, String schedFlow, String schedDate, String completedDate, String comments, String startDate, String schedEndDate) {
		RoutingSteps rsteps = factory.createRequestRoutingSteps();
		
		rsteps.setCproutingid(cproutingid);
		rsteps.setTemplateName(templateName);
		rsteps.setStep(step);
		rsteps.setActionType(actionType);
		rsteps.setStepStatus(routStatus);
		rsteps.setAssignee(assignee);
		rsteps.setCompletedBy(completedby);
		rsteps.setScheduleFlow(schedFlow);
		rsteps.setScheduleDate(schedDate);
		rsteps.setCompletedDate(completedDate);
		rsteps.setComments(comments);
		rsteps.setStartDate(startDate);
		rsteps.setScheduleEndDate(schedEndDate);
		
		return rsteps;
	}

}
