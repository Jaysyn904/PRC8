package prc.autodoc;

/**
 * An exception indicating failure while generating a page.
 */
public class PageGenerationException extends java.lang.RuntimeException{
	private static final long serialVersionUID = 0x2L;
	
	/**
	 * Creates a new exception.
	 * 
	 * @param message The message this exception is to carry
	 */
	public PageGenerationException(String message)                 { super(message); }
	
	/**
	 * Creates a new exception.
	 * 
	 * @param message The message this exception is to carry
	 * @param cause   Another exception that caused this one to be thrown
	 */
	public PageGenerationException(String message, Throwable cause){ super(message, cause); }
}