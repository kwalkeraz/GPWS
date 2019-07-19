package tools.print.api.country;

import tools.print.api.country.ObjectFactory;

public class CountryFactory {
	public static Country CountryCreateList(ObjectFactory factory, int id, String Name, String Abbr, String URL) {
		Country country = factory.createCountry();
		country.setId(id);
		country.setName(Name);
		country.setAbbr(Abbr);
		country.setURL(URL);
		
		return country;
	}

}
