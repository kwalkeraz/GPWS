package tools.print.api.user;

import tools.print.api.user.User;
import tools.print.api.user.ObjectFactory;

public class UserFactory {
	public static User UserCreateList(ObjectFactory factory, String FullName, String FirstName, String LastName, String EmailAddress, String LoginID, String Phone, String TieLine, String Pager, String IsMgr) {
		User user = factory.createUser();
		user.setFullName(FullName);
		user.setFirstName(FirstName);
		user.setLastName(LastName);
		user.setEmailAddress(EmailAddress);
		user.setLoginID(LoginID);
		user.setPhone(Phone);
		user.setTieLine(TieLine);
		user.setPager(Pager);
		user.setIsMgr(IsMgr);
		
		return user;
	}
	
	public static User UserCreateErrorList (ObjectFactory factory, String Error) {
		User user = factory.createUser();
		user.setError(Error);
		
		return user;
	}

}
