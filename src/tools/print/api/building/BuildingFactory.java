package tools.print.api.building;

import tools.print.api.building.Building;
import tools.print.api.building.ObjectFactory;

public class BuildingFactory {
	public static Building BuildingCreateList(ObjectFactory factory, int id, String Name, String Tier, String sdc, String SiteCode, String WorkLocCode, String Status, String URL) {
		Building building = factory.createBuilding();
		building.setId(id);
		building.setName(Name);
		building.setTier(Tier);
		building.setSDC(sdc);
		building.setSiteCode(SiteCode);
		building.setWorkLoc(WorkLocCode);
		building.setStatus(Status);
		building.setURL(URL);
		
		return building;
	}

}
