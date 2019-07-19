package tools.print.api.driver;

import tools.print.api.driver.Driver;
import tools.print.api.driver.ObjectFactory;

public class DriverFactory {
	public static Driver DriverCreateList(ObjectFactory factory, int id, String Name, String Model) {
		Driver driver = factory.createDriver();
		driver.setId(id);
		driver.setName(Name);
		driver.setModel(Model);
		
		return driver;
	}

}
