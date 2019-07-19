package tools.print.api.geo;


public class GeoFactory {
	public static Geography GeoCreateList(ObjectFactory factory, int id, String Name, String Abbr, String Email, String CCEmail, String URL) {
		Geography geo = factory.createGeography();
		geo.setId(id);
		geo.setName(Name);
		geo.setAbbr(Abbr);
		geo.setEmail(Email);
		geo.setCCEmail(CCEmail);
		geo.setURL(URL);
		
		return geo;
	}
} //main