package tools.print.api.modeldriver;

import tools.print.api.modeldriver.Modeldriver;
import tools.print.api.modeldriver.ObjectFactory;

public class ModelDriverFactory {
	public static Modeldriver ModelDriverCreateList(ObjectFactory factory, int id, String Model, int Modelid, String DriverModel, String DriverName, int DriverID) {
		Modeldriver modeldriver = factory.createModeldriver();
		modeldriver.setId(id);
		modeldriver.setModel(Model);
		modeldriver.setModelid(Modelid);
		modeldriver.setDriverModel(DriverModel);
		modeldriver.setDriverName(DriverName);
		modeldriver.setDriverid(DriverID);
		
		return modeldriver;
	}

}
