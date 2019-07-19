package tools.print.api.user;


import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

import tools.print.api.user.UserFactory;
import tools.print.api.user.Users;
import tools.print.api.user.ObjectFactory;
import tools.print.jaxrs.MediaTypesArray;
import tools.print.jaxrs.RespBuilder;
import tools.print.lib.AppTools;
import tools.print.lib.UserInfo;

@XmlRegistry
@Path("/user")
public class UserJax {
	//Global Variables
	AppTools tools = new AppTools();
	final static ObjectFactory factory = new ObjectFactory();
	static Users users = null;
	protected String emailValue = "";
    boolean nameFound = true;
	
	public String getEmail() {
    	return emailValue;
    }
    
    public void setEmail(String value) {
    	this.emailValue = value;
    }
    
	public void createUserList() {
		users = factory.createUsers();
		int iLength = 0; 
		int iComma = 0;
		UserInfo bpLookup = new UserInfo(emailValue);
		if (bpLookup.employeeName().equals("not found")) {
			nameFound = false;
		} //name was not found
		
		try {
			if (nameFound) {
				String lastname = "";
				String firstname = "";
				for(int j = 0; j < bpLookup.employeeName().length(); j++) {
					if (bpLookup.employeeName().substring(j, j + 1).equals(",")) {
						iComma = j;
					} //if
				} //for loop
					if (iComma != -1) {
	    			iLength = bpLookup.employeeName().length();
					lastname = bpLookup.employeeName().substring( 0, iComma );
	    			firstname = bpLookup.employeeName().substring( iComma + 1, iLength);
	    		} //if
	    		String fullname = bpLookup.employeeName();
	    		String phone = bpLookup.empXphone();
	    		String tieline = bpLookup.empTie();
	    		//String email = emailValue;
	    		String email = bpLookup.employeeEmail();
	    		//String login = emailValue;
	    		String login = bpLookup.employeeEmail();
	    		String pager = bpLookup.empPager();
	    		String isMgr = bpLookup.isMgr();
				
	    		users.getUser().add(UserFactory.UserCreateList(factory, fullname, firstname, lastname, email, login, phone, tieline, pager, isMgr));
			} else {
				users.getUser().add(UserFactory.UserCreateErrorList(factory, "Employee was not found."));
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		} //for loop
	}	
	
	@GET
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Users> getByEmailwParam(@Context HttpServletRequest req) throws IOException {
		setEmail(tools.nullStringConverter(req.getParameter("email")));
		if (emailValue.equals("")) {
			 RespBuilder.createResponse(412);
		} else {
			createUserList();
		}
		
		return createModels(users);
	}
	
	@GET
	@Path("/email/{email}")
	@Produces({MediaTypesArray.xmlType, MediaTypesArray.jsonType, MediaTypesArray.textXmlType, MediaTypesArray.textJsonType})
	public JAXBElement<Users> getByEmail(@PathParam("email") String name, @Context HttpServletRequest req) {
		setEmail(name); 
		createUserList();
		
		return createModels(users);
	}
	
	public JAXBElement<Users> createModels(Users value) {
		QName _var_QNAME = new QName(Users.class.getSimpleName());
		return new JAXBElement<Users>(_var_QNAME, Users.class, value);
	}
} //UserJax
