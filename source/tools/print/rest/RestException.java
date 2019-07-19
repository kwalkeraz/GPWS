/**
 * 
 */
package tools.print.rest;

public class RestException extends Exception {

	private static final long serialVersionUID = 100L;

	/**
	 * 
	 */
	public RestException() {
		super();
	}

	public RestException(String message) {
		super(message);
	}

	public RestException(Throwable cause) {
		super(cause);
	}

	public RestException(String message, Throwable cause) {
		super(message, cause);
	}

}
