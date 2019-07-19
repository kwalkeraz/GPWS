package tools.print.api.scanner;

import tools.print.api.scanner.Scanners;
import tools.print.api.scanner.ObjectFactory;

public class ScannerFactory {
	public static Scanners ScannerCreateList(ObjectFactory factory, String Geo, String Country, String State, String City, String Building, String Floor, String DeviceName,
			String Status, String Room, String RoomAccess, String LPName, String Model, String SerialNumber) {
		Scanners scanners = factory.createScanners();
		scanners.setGeo(Geo);
		scanners.setCountry(Country);
		scanners.setState(State);
		scanners.setCity(City);
		scanners.setBuilding(Building);
		scanners.setFloor(Floor);
		scanners.setDeviceName(DeviceName);
		scanners.setStatus(Status);
		scanners.setRoom(Room);
		scanners.setRoomAccess(RoomAccess);
		scanners.setLPName(LPName);
		scanners.setModel(Model);
		scanners.setSerialNumber(SerialNumber);
		
		return scanners;
	}

}
