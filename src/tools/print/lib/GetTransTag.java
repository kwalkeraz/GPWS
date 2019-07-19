package tools.print.lib;

import java.util.Locale;
import java.util.ResourceBundle;

/****************************************************************************************
 * GetTransTag																			*
 * 																						*
 * Copyright IBM																		*
 * 																						*
 * This class gets the translation tags from the gpws.properties file.  It takes your   *
 * current locale (browser) and a key string (ie global_print) and finds the correct    *
 * phrase and translation in the properties file.                                    	*
 ****************************************************************************************/

public class GetTransTag {
	
	Locale currentLocale = null;
	
	public final Locale setLocale(Locale l) { currentLocale = l; return currentLocale; }
	
	String sKey = "";
	
	/**
	 *  This method takes 1 argument, the key tag in the properties file
	 *  It then returns the translation tag
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public String getString(String key) throws Exception {
		ResourceBundle messages = ResourceBundle.getBundle("tools.print.translations.gpws", currentLocale);
		//System.out.println("Current locale is: " + currentLocale);
		try {
			sKey = messages.getString(key);
		} catch (java.util.MissingResourceException mre) {
			System.out.println("Missing translation tag for key: " + key + ". " + mre);
			sKey = ">>" + key + "<<";
		} //try & catch
			return sKey;
	} //getString method
	
	/**
	 * This method takes 2 arguments, the key tag in the properties file and an array of values to pass as arguments
	 * It then returns the translation tag along with the proper values.
	 * @param key
	 * @param args
	 * @return
	 * @throws Exception
	 */
	public String getStringArgs(String key, String[] args) throws Exception {
		ResourceBundle messages = ResourceBundle.getBundle("tools.print.translations.gpws", currentLocale);
		//System.out.println("Current locale is: " + currentLocale);
		try {
			sKey = messages.getString(key);
		} catch (java.util.MissingResourceException mre) {
			System.out.println("Missing translation tag for key: " + key + ". " + mre);
			sKey = ">>" + key + "<<";
		} //try & catch
		for (int i=0; i < args.length; i++ ) {
			sKey = sKey.replace("{"+i+"}",args[i]);
		} //for loop
			return sKey;
	} //getStringArgs method
	
} //class GetTransTag