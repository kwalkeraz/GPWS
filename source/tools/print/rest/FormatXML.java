package tools.print.rest;

import java.io.OutputStream;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import tools.print.api.invalid.Invalid;
import tools.print.api.invalid.ObjectFactory;

public class FormatXML {
	
	/**
	 * Creates a mashaller to display data in XML format
	 * @param packageName - The name of the package being used
	 * @return
	 */
	public Marshaller createMarshaller(String packageName) {
		//ObjectFactory factory = new ObjectFactory();
		JAXBContext jc;
		Marshaller marshaller = null;
		try {
			//jc = JAXBContext.newInstance("tools.print.api.device");
			jc = JAXBContext.newInstance(packageName);
			marshaller = jc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
		} catch (JAXBException e1) {
			e1.printStackTrace();
		}
		return marshaller;
	
	} //createMarshaller
	
	/**
	public Marshaller createInvalidMarshaller(OutputStream outStream, String packageName, String error) {
		ObjectFactory factory = new ObjectFactory();
		Marshaller marshaller = createMarshaller(packageName);
		//String error = "This is an error message";
		Invalid invalid = factory.createInvalid();
		invalid.getError().add(error);
	    
		try {
			//marshaller.marshal(invalid, System.out);
			marshaller.marshal(invalid, outStream);
		} catch (JAXBException e) {
			e.printStackTrace();
			System.out.println(e);
		}
		return marshaller;
	}
	**/
}
