package tools.print.api.invalid;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBException;

import tools.print.api.invalid.ObjectFactory;

import tools.print.rest.FormatXML;

public class InvalidMessage {
	/**
	//public static Invalid createMessage(String error) {
	public List ErrorMsg (String error) {
		ObjectFactory factory = new ObjectFactory();
		//String packageName = "tools.print.api.invalid";
		//FormatXML2 marshaller = new FormatXML2();
		Invalid invalid = factory.createInvalid();
		List resultList = new ArrayList();
		
		resultList.add(invalid.getError().add(error));
		/**
		try {
			marshaller.createMarshaller(packageName).marshal(invalid, System.out);
			marshaller.createMarshaller(packageName).marshal(invalid, outStream);
		} catch (JAXBException e) {
			e.printStackTrace();
			System.out.println(e);
		}
		**/
	//	return resultList; 
	//}
	//public static void main(String[] args) {
	public static void InvMsg(OutputStream outStream) {
		ObjectFactory factory = new ObjectFactory();
		String error = "This is an error message";
		String packageName = "tools.print.api.invalid";
		FormatXML marshaller = new FormatXML();
		Invalid invalid = factory.createInvalid();
		
		invalid.getError().add(error);
		
		try {
			marshaller.createMarshaller(packageName).marshal(invalid, System.out);
			marshaller.createMarshaller(packageName).marshal(invalid, outStream);
		} catch (JAXBException e) {
			e.printStackTrace();
			System.out.println(e);
		}
	}

}
