package tools.print.api.server;

import tools.print.api.server.Server;
import tools.print.api.server.ObjectFactory;

public class ServerFactory {
	public static Server ServerCreateList(ObjectFactory factory, int id, String Name, String SDC, String Customer, String ContactEmail, String VPSXServer) {
		Server server = factory.createServer();
		server.setId(id);
		server.setName(Name);
		server.setSDC(SDC);
		server.setCustomer(Customer);
		server.setContactEmail(ContactEmail);
		server.setVPSXServer(VPSXServer);
		
		return server;
	}

}
