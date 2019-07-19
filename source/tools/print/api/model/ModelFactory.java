package tools.print.api.model;

import tools.print.api.model.Model;
import tools.print.api.model.ObjectFactory;

public class ModelFactory {
	public static Model ModelCreateList(ObjectFactory factory, int id, String Name, String Strategic, String ConfidentialPrint, String Color, int numLangDisplay) {
		Model model = factory.createModel();
		model.setId(id);
		model.setName(Name);
		model.setStrategic(Strategic);
		model.setConfidentialPrint(ConfidentialPrint);
		model.setColor(Color);
		model.setNumLangDis(numLangDisplay);
		
		return model;
	}

}
