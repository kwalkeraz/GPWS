package tools.print.api.state;

import tools.print.api.state.ObjectFactory;

public class StateFactory {
	public static State StateCreateList(ObjectFactory factory, int id, String Name, String URL) {
		State state = factory.createState();
		state.setId(id);
		state.setName(Name);
		state.setURL(URL);
		
		return state;
	}
}
