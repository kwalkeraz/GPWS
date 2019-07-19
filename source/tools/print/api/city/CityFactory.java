package tools.print.api.city;

import tools.print.api.city.ObjectFactory;
import tools.print.api.city.City;

public class CityFactory {
	public static City CityCreateList(ObjectFactory factory, int id, String Name, String Status, String URL) {
		City city = factory.createCity();
		city.setId(id);
		city.setName(Name);
		city.setStatus(Status);
		city.setURL(URL);
		
		return city;
	}

}
