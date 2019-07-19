package tools.print.jaxrs;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;

import tools.print.printer.PrinterTools;


/** This class creates a response based on the arguments passed by a web service
 * Responses range from server not found all the way to pre-conditions not met
 * @author ganunez
 *
 */
public class RespBuilder {
	
	
	public static void createResponse(int code) {
		PrinterTools tool = new PrinterTools();
		Status status = null;
		String message = "";
		String displayType = "text/html";
		
		switch (code){
			case 412:{
				status = Response.Status.PRECONDITION_FAILED;
				message = "<p>Invalid filter passed.</p>";
				break;
			}
			case 404:{
				status = Response.Status.NOT_FOUND;
				message = "<p>Page was not found.</p>";
				break;
			}
			case 500:{
				status = Response.Status.INTERNAL_SERVER_ERROR;
				message = "<p>An error has occurred</p>";
				break;
			}
			case 401:{
				status = Response.Status.FORBIDDEN;
				message = "<p>Unauthorized access.  Please log in to IBM Intranet and try again.</p>";
				break;
			}
			default:{
				String url = "";
				try {
					url = tool.getServerName();
				} catch (Exception e) {
					System.out.println("Error getting server name in RespBuilder, " + e);
					url = "w3.ibm.com";
				}
				String urlHelpPage = "http://" + url + "/tools/print/GPWSAPIs.html";
				status = Response.Status.OK;
				message = "<html>" +
						"<head><title>GPWS API Help</title></head>" +
						"<body>" +
						"<p>For more information on how to use the GPWS API, please visit the following page<br />" +
						"<a href=\""+urlHelpPage+"\">GPWS API Help</a>" +
						"</p>" +
						"</body>" +
						"</html>";
				break;
			}

		} //switch
		//ResponseBuilder builder = Response.status(Response.Status.PRECONDITION_FAILED);
		ResponseBuilder builder = Response.status(status);
	    builder.type(displayType);
	    builder.entity(message);
	    throw new WebApplicationException(builder.build());
	}
}
