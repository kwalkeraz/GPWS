package tools.print.api.invalid;

import tools.print.api.invalid.Invalid;
import tools.print.api.invalid.ObjectFactory;

public class InvalidFactory {
	public static Invalid InvalidCreateList(ObjectFactory factory, String error) {
		Invalid invalid = factory.createInvalid();
		invalid.getError().add(error);
		
		return invalid;
	}

}
