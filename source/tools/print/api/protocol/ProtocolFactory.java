package tools.print.api.protocol;

import tools.print.api.protocol.Protocol;
import tools.print.api.protocol.ObjectFactory;

public class ProtocolFactory {
	public static Protocol ProtocolCreateList(ObjectFactory factory, String name, String type, String hostPortConfig, String protocolVersion, String protocolPackage,
    int protocolID, int osid, String osName, String osabbr, int sequenceNumber, int osProtocolID) {
		Protocol protocol = factory.createProtocol();
		protocol.setProtocolName(name);
		protocol.setProtocolType(type);
		protocol.setHostPortConfig(hostPortConfig);
		protocol.setProtocolVersion(protocolVersion);
		protocol.setProtocolPackage(protocolPackage);
		protocol.setProtocolID(protocolID);
		protocol.setOSID(osid);
		protocol.setOSName(osName);
		protocol.setOSABBR(osabbr);
		protocol.setSequenceNumber(sequenceNumber);
		protocol.setOSProtocolID(osProtocolID);
		
		return protocol;
	}

}
