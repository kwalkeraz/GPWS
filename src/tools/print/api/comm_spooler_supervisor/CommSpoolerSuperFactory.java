package tools.print.api.comm_spooler_supervisor;

import tools.print.api.comm_spooler_supervisor.CommSpoolerSuperFactory;
import tools.print.api.comm_spooler_supervisor.ObjectFactory;

public class CommSpoolerSuperFactory {
	public static CommSpoolerSupervisor CityCreateList(ObjectFactory factory, int id, String Name, String Process) {
		CommSpoolerSupervisor commspoolersuper = factory.createCommSpoolerSupervisor();
		commspoolersuper.setId(id);
		commspoolersuper.setName(Name);
		commspoolersuper.setProcess(Process);
		
		return commspoolersuper;
	}

}
