package tools.print.api.help;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.xml.bind.annotation.XmlRegistry;

import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;

@XmlRegistry
@Path("/help")
public class HelpJax  {
	//Global Variables
	AppTools tools = new AppTools();
	
	@GET
	@Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON, MediaType.TEXT_XML, "text/json"})
    public void getHelp(@Context HttpServletRequest req) {
		RespBuilder.createResponse(0);
    } 
} //HelpJax
