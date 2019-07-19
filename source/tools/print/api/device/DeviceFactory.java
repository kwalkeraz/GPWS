package tools.print.api.device;

import tools.print.api.device.Device.DeviceFunctions;
import tools.print.api.device.ObjectFactory;

public class DeviceFactory {
	public static Device DeviceCreateList(ObjectFactory factory, int DeviceID, String Geo, String Country, String State, String City, String Building, String Floor, String DeviceName,
			String Status, String Room, String RoomAccess, String LPName, String WebVisible, String Installable, String Port, String Duplex, String Dipp, String FaxNumber, String IPDomain, 
			String IPSubnet, String IPGateway, String IPHostname, String IPAddress, String LanDrop, String Model, String E2ECategory, String DriverSetName, String ClientDefType, 
			String ServerName, String Comm, String CommPort, String Spooler, String SpoolerPort, String Supervisor, String SupervisorPort, String FTPSite, String ConfidentialPrint, 
			int KOCompanyID, String vendorName, String IGSKeyop, String IPDS, String SerialNumber, String OS, String Package, String Version, String DriverName, String DataFile, 
			String DriverPath, String ConfigFile, String HelpFile, String MonitorFile, String FileList, String DefaultType, String Proc, String ProcFile, String PrtAttributes, 
			String ChangeINI, String OptionsFileName, String installDate, String modifiedDate, String deleteDate, String functionArray) {
		
		Device device = factory.createDevice();
		device.setDeviceID(DeviceID);
		device.setGeo(Geo);
		device.setCountry(Country);
		device.setState(State);
		device.setCity(City);
		device.setBuilding(Building);
		device.setFloor(Floor);
		device.setDeviceName(DeviceName);
		device.setStatus(Status);
		device.setRoom(Room);
		device.setRoomAccess(RoomAccess);
		device.setLPName(LPName);
		device.setWebVisible(WebVisible);
		device.setInstallable(Installable);
		device.setPort(Port);
		device.setDuplex(Duplex);
		device.setDipp(Dipp);
		device.setFaxNumber(FaxNumber);
		device.setIPDomain(IPDomain);
		device.setIPSubnet(IPSubnet);
		device.setIPGateway(IPGateway);
		device.setIPHostname(IPHostname);
		device.setIPAddress(IPAddress);
		device.setLANDrop(LanDrop);
		device.setModel(Model);
		device.setE2ECategory(E2ECategory);
		device.setDriverSetName(DriverSetName);
		device.setClientDefType(ClientDefType);
		device.setServerName(ServerName);
		device.setComm(Comm);
		device.setCommPort(CommPort);
		device.setSpooler(Spooler);
		device.setSpoolerPort(SpoolerPort);
		device.setSupervisor(Supervisor);
		device.setSupervisorPort(SupervisorPort);
		device.setFTPSite(FTPSite);
		device.setConfidentialPrint(ConfidentialPrint);
		device.setKOCompanyID(KOCompanyID);
		device.setVendorName(vendorName);
		device.setIGSKeyop(IGSKeyop);
		device.setIPDS(IPDS);
		device.setSerialNumber(SerialNumber);
		device.setOS(OS);
		device.setPackage(Package);
		device.setVersion(Version);
		device.setDriverName(DriverName);
		device.setDataFile(DataFile);
		device.setDriverPath(DriverPath);
		device.setConfigFile(ConfigFile);
		device.setHelpFile(HelpFile);
		device.setMonitorFile(MonitorFile);
		device.setFileList(FileList);
		device.setDefaultType(DefaultType);
		device.setProc(Proc);
		device.setProcFile(ProcFile);
		device.setPrtAttributes(PrtAttributes);
		device.setChangeINI(ChangeINI);
		device.setOptionsFileName(OptionsFileName);
		device.setInstallDate(installDate);
		device.setModifiedDate(modifiedDate);
		device.setDeleteDate(deleteDate);
		device.getDeviceFunctions().add(DeviceFunctionCreateList(factory, DeviceID, functionArray));
		
		return device;
	}
	
	public static DeviceFunctions DeviceFunctionCreateList(ObjectFactory factory, int deviceid, String functionArray) {
		DeviceFunctions functions = factory.createDeviceDeviceFunctions();
		functions.setFunctions(functionArray);
		
		return functions;
	}

}
