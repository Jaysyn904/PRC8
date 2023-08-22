package prc.autodoc;

/**
 * An exception indicating TLK read failed.
 */
public class TLKReadException extends java.lang.RuntimeException{
	private static final long serialVersionUID = 0x0L;
	
	/**
	 * Creates a new exception.
	 * 
	 * @param message The message this exception is to carry
	 */
	public TLKReadException(String message)                 { super(message); }
	
	/**
	 * Creates a new exception.
	 * 
	 * @param message The message this exception is to carry
	 * @param cause   Another exception that caused this one to be thrown
	 */
	public TLKReadException(String message, Throwable cause){ super(message, cause); }
}