package tools.print.api.administrator;

import tools.print.api.administrator.Administrator;
import tools.print.api.administrator.Administrator.Authorization;
import tools.print.api.administrator.ObjectFactory;

public class AdministratorFactory {
	public static Administrator AdministratorCreateList(ObjectFactory factory, int id, String FirstName, String LastName, String FullName, 
			String EmailAddress, String LoginID, String Pager, String sType, int authtypeid, String authgroupArray) {
		Administrator administrator = factory.createAdministrator();
		administrator.setId(id);
		administrator.setFirstName(FirstName);
		administrator.setLastName(LastName);
		administrator.setFullName(FullName);
		administrator.setEmailAddress(EmailAddress);
		administrator.setLoginID(LoginID);
		administrator.setPager(Pager);
		if (!sType.equals("")) { 
			administrator.getAuthorization().add(AuthorizationCreateList(factory, sType, authtypeid, authgroupArray));
		}
			
		return administrator;
	}
	
	public static Authorization AuthorizationCreateList(ObjectFactory factory, String sType, int authtypeid, String authgroupArray) {
		Authorization authorita = factory.createAdministratorAuthorization();
		authorita.setGroup(authgroupArray);
		//authorita.setId(authtypeid);
		
		return authorita;
	}

}
