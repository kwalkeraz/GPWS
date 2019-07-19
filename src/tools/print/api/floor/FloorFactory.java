package tools.print.api.floor;

import tools.print.api.floor.Floor;
import tools.print.api.floor.ObjectFactory;

public class FloorFactory {
	public static Floor FloorCreateList(ObjectFactory factory, int id, String Name, String Status, String URL) {
		Floor floor = factory.createFloor();
		floor.setId(id);
		floor.setName(Name);
		floor.setStatus(Status);
		floor.setURL(URL);
		
		return floor;
	}

}
