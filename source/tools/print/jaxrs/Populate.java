package tools.print.jaxrs;

import java.util.List;
import java.util.Map;

public class Populate implements Prepare, CreateList{
	public final void populateList() {
		List<Map<String, Object>> columns = prepareConnection();
		createList(columns);
	}
	
	public final void populateListbyName(int id) {
		List<Map<String, Object>> columns = prepareConnection2(id);
		createList(columns);
	}

	@Override
	public void createList(List<Map<String, Object>> columns) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Map<String, Object>> prepareConnection() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Map<String, Object>> prepareConnection2(int id) {
		// TODO Auto-generated method stub
		return null;
	}

}
