package tools.print.api.modeldriverset;

import tools.print.api.modeldriverset.ModelDriverset;
import tools.print.api.modeldriverset.ObjectFactory;

public class ModelDriverSetFactory {
	public static ModelDriverset ModelDriverCreateList(ObjectFactory factory, int id, String Model, int Modelid, String DriverSetName, int DriversetID) {
		ModelDriverset modeldriverset = factory.createModelDriverset();
		modeldriverset.setId(id);
		modeldriverset.setModel(Model);
		modeldriverset.setModelid(Modelid);
		modeldriverset.setDriverSetName(DriverSetName);
		modeldriverset.setDriversetid(DriversetID);
		
		return modeldriverset;
	}

}
