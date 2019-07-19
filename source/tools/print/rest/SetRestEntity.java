package tools.print.rest;

public class SetRestEntity {
	public static RestEntity checkEntity(String path) {
		RestEntity restEnt = new RestEntity();
		int index = -1;
		index = Integer.parseInt(path.substring(1))-1;
		restEnt.setIndex(index);
		restEnt.setType(1);
		return restEnt;
	}
}
