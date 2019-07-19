package tools.print.jaxrs;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

@ApplicationPath("/servlet/api.wss/*")
public class GPWSApplication extends Application {
	
	//@Override
	//public Set<Class<?>> getClasses() {
	//	Set<Class<?>> classes = new HashSet<Class<?>>();
		
	//	return classes;
	//}
}
