package tools.print.api.fax;

import tools.print.api.fax.Faxes;
import tools.print.api.fax.ObjectFactory;

public class FaxFactory {
	public static Faxes FaxCreateList(ObjectFactory factory, String Geo, String Country, String State, String City, String Building, String Floor, String DeviceName,
			String Status, String Room, String RoomAccess, String LPName, String FaxNumber, String Model, String SerialNumber) {
		Faxes fax = factory.createFaxes();
		fax.setGeo(Geo);
		fax.setCountry(Country);
		fax.setState(State);
		fax.setCity(City);
		fax.setBuilding(Building);
		fax.setFloor(Floor);
		fax.setDeviceName(DeviceName);
		fax.setStatus(Status);
		fax.setRoom(Room);
		fax.setRoomAccess(RoomAccess);
		fax.setLPName(LPName);
		fax.setFaxNumber(FaxNumber);
		fax.setModel(Model);
		fax.setSerialNumber(SerialNumber);
		
		return fax;
	}
	
	public static Faxes FaxCreateList(ObjectFactory factory, String error) {
		Faxes fax = factory.createFaxes();
		fax.setError(error);
		
		return fax;
	}

}
