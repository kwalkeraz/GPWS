package tools.print.api.copier;

import tools.print.api.copier.Copiers;
import tools.print.api.copier.ObjectFactory;

public class CopierFactory {
	public static Copiers CopierCreateList(ObjectFactory factory, String Geo, String Country, String State, String City, String Building, String Floor, String DeviceName,
			String Status, String Room, String RoomAccess, String LPName, String Model, String SerialNumber) {
		Copiers copiers = factory.createCopiers();
		copiers.setGeo(Geo);
		copiers.setCountry(Country);
		copiers.setState(State);
		copiers.setCity(City);
		copiers.setBuilding(Building);
		copiers.setFloor(Floor);
		copiers.setDeviceName(DeviceName);
		copiers.setStatus(Status);
		copiers.setRoom(Room);
		copiers.setRoomAccess(RoomAccess);
		copiers.setLPName(LPName);
		copiers.setModel(Model);
		copiers.setSerialNumber(SerialNumber);
		
		return copiers;
	}

}
