package tools.print.api.printer;

import tools.print.api.printer.Printers;
import tools.print.api.printer.ObjectFactory;

public class PrinterFactory {
	public static Printers PrinterCreateList(ObjectFactory factory, String Geo, String Country, String State, String City, String Building, String Floor, String DeviceName,
			String Status, String Room, String RoomAccess, String LPName, String Port, String Duplex, String Dipp, String FaxNumber, String IPDomain, String IPSubnet, 
			String IPGateway, String IPHostname, String IPAddress, String LANDrop, String Model, String DriverSetName, String ClientDefType, String ServerName, String Comm, 
			String CommPort, String Spooler, String SpoolerPort, String Supervisor, String SupervisorPort, String FTPSite, String homeDirectory, String ConfidentialPrint, 
			String IGSKeyop, String IPDS, String SerialNumber,String WebVisible, String Installable, String CountryAbbr, String E2ECategory, String CS, String VM, String MVS,
			String SAP, String WTS, String ServerSDC, String InstallDate, String ModifiedDate, String DeleteDate, int KOCompanyID, String VendorName, String OS, String protocolPackage,
			String protocolVersion, String Package, String Version, String DriverName, String DataFile, String DriverPath, String ConfigFile, String HelpFile, 
			String MonitorFile, String FileList, String DefaultType, String Proc, String ProcFile, String PrtAttributes, String ChangeINI, String OptionsFileName) {
		Printers printers = factory.createPrinters();
		printers.setGeo(Geo);
		printers.setCountry(Country);
		printers.setState(State);
		printers.setCity(City);
		printers.setBuilding(Building);
		printers.setFloor(Floor);
		printers.setDeviceName(DeviceName);
		printers.setStatus(Status);
		printers.setRoom(Room);
		printers.setRoomAccess(RoomAccess);
		printers.setLPName(LPName);
		printers.setPort(Port);
		printers.setDuplex(Duplex);
		printers.setDipp(Dipp);
		printers.setFaxNumber(FaxNumber);
		printers.setIPDomain(IPDomain);
		printers.setIPSubnet(IPSubnet);
		printers.setIPGateway(IPGateway);
		printers.setIPHostname(IPHostname);
		printers.setIPAddress(IPAddress);
		printers.setLANDrop(LANDrop);
		printers.setModel(Model);
		printers.setDriverSetName(DriverSetName);
		printers.setClientDefType(ClientDefType);
		printers.setServerName(ServerName);
		printers.setComm(Comm);
		printers.setCommPort(CommPort);
		printers.setSpooler(Spooler);
		printers.setSpoolerPort(SpoolerPort);
		printers.setSupervisor(Supervisor);
		printers.setSupervisorPort(SupervisorPort);
		printers.setFTPSite(FTPSite);
		printers.sethomeDirectory(homeDirectory);
		printers.setConfidentialPrint(ConfidentialPrint);
		printers.setIGSKeyop(IGSKeyop);
		printers.setIPDS(IPDS);
		printers.setSerialNumber(SerialNumber);
		printers.setWebVisible(WebVisible);
		printers.setInstallable(Installable);
		printers.setCountryAbbr(CountryAbbr);
		printers.setE2ECategory(E2ECategory);
		printers.setCS(CS);
		printers.setVM(VM);
		printers.setMVS(MVS);
		printers.setSAP(SAP);
		printers.setWTS(WTS);
		printers.setServerSDC(ServerSDC);
		printers.setInstallDate(InstallDate);
		printers.setModifiedDate(ModifiedDate);
		printers.setDeleteDate(DeleteDate);
		printers.setKOCompanyID(KOCompanyID);
		printers.setVendorName(VendorName);
		printers.setOS(OS);
		printers.setProtocolPackage(protocolPackage);
		printers.setProtocolVersion(protocolVersion);
		printers.setPackage(Package);
		printers.setVersion(Version);
		printers.setDriverName(DriverName);
		printers.setDataFile(DataFile);
		printers.setDriverPath(DriverPath);
		printers.setConfigFile(ConfigFile);
		printers.setHelpFile(HelpFile);
		printers.setMonitorFile(MonitorFile);
		printers.setFileList(FileList);
		printers.setDefaultType(DefaultType);
		printers.setProc(Proc);
		printers.setProcFile(ProcFile);
		printers.setPrtAttributes(PrtAttributes);
		printers.setChangeINI(ChangeINI);
		printers.setOptionsFileName(OptionsFileName);
		
		return printers;
	}

}
