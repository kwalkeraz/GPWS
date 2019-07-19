package tools.print.jaxrs;

import javax.ws.rs.core.MediaType;

/*
 * This class initializes an array with all the accepted application types such as application/xml, application/json
 * @return An array with the media types
 */

public class MediaTypesArray {
	public static final String xmlType = MediaType.APPLICATION_XML + "; charset=UTF-8";
	public static final String jsonType = MediaType.APPLICATION_JSON + "; charset=UTF-8";
	public static final String textXmlType = MediaType.TEXT_XML + "; charset=UTF-8";
	public static final String textJsonType = "text/json; charset=UTF-8";
	
	public static String[] showMediaTypes() {
		String[] arrayMediaTypes = {xmlType, jsonType, textXmlType, textJsonType};
		return arrayMediaTypes;
	}
} //class MediaTypesArray
