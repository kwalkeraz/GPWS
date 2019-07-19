package tools.print.api.korequest;

import tools.print.api.korequest.KORequest.KOReqNotes;
//import tools.print.api.KORequest.KORequest.DeviceFunctions;
import tools.print.api.korequest.ObjectFactory;

public class KORequestFactory {

	public static KORequest KORequestCreateList(ObjectFactory factory, int koRequestID, String reqEmail, String reqName, String reqTieline, String reqExtPhone, String timeSubmitted, int deviceID, String deviceName, String deviceSerial, String deviceType, String tier, 
			String e2eCategory, String city, int cityid, String building, int buildingid, String floor, String room, String description, String ccEmail, String reqStatus, String solution, int keyopUserID, String keyopName, String timeFinished,
			String closedBy, String customerContacted, String keyopTimeStart, String keyopTimeFinish, String ceRefNum, String ceRefDate, String hdRefNum, String hdRefDate, String bondReqNum, int closeCodeID, String keyopFName, String keyopLName, int vendorID, int keyopCompanyID, 
			String keyopCompanyName, String notesArray) {
		KORequest korequest = factory.createKORequest();
		korequest.setKeyopRequestID(koRequestID);
		korequest.setRequestorEmail(reqEmail);
		korequest.setRequestorName(reqName);
		korequest.setRequestorTieline(reqTieline);
		korequest.setRequestorExtPhone(reqExtPhone);
		korequest.setTimeSubmitted(timeSubmitted);
		korequest.setDeviceID(deviceID);
		korequest.setDeviceName(deviceName);
		korequest.setDeviceSerial(deviceSerial);
		korequest.setDeviceType(deviceType);
		korequest.setTier(tier);
		korequest.setE2ECategory(e2eCategory);
		korequest.setCity(city);
		korequest.setCityID(cityid);
		korequest.setBuilding(building);
		korequest.setBuildingID(buildingid);
		korequest.setFloor(floor);
		korequest.setRoom(room);
		korequest.setDescription(description);
		korequest.setCCEmail(ccEmail);
		korequest.setReqStatus(reqStatus);
		korequest.setSolution(solution);
		korequest.setKeyopUserid(keyopUserID);
		korequest.setKeyopName(keyopName);
		korequest.setTimeFinished(timeFinished);
		korequest.setClosedBy(closedBy);
		korequest.setCustomerContacted(customerContacted);
		korequest.setKeyopTimeStart(keyopTimeStart);
		korequest.setKeyopTimeFinish(keyopTimeFinish);
		korequest.setCEReferralNum(ceRefNum);
		korequest.setCEReferralDate(ceRefDate);
		korequest.setHDReferralNum(hdRefNum);
		korequest.setHDReferralDate(hdRefDate);
		korequest.setBondReqNum(bondReqNum);
		korequest.setCloseCodeID(closeCodeID);
		korequest.setKeyopFirstName(keyopFName);
		korequest.setKeyopLastName(keyopLName);
		korequest.setVendorID(vendorID);
		korequest.setKeyopCompanyID(keyopCompanyID);
		korequest.setKeyopCompanyName(keyopCompanyName);
		korequest.getKOReqNotes().add(KeyopNotesCreateList(factory, koRequestID, notesArray));
				
		return korequest;
	}
	
	public static KOReqNotes KeyopNotesCreateList(ObjectFactory factory, int keyop_requestid, String functionArray) {
		KOReqNotes notes = factory.createKORequestsKOReqNotes();
		notes.setNotes(functionArray);
		
		return notes;
	}

}
