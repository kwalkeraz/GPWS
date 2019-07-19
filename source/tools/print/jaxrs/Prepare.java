package tools.print.jaxrs;

import java.util.List;
import java.util.Map;

public interface Prepare {
	List<Map<String, Object>> prepareConnection();
	List<Map<String, Object>> prepareConnection2(int id);

}
