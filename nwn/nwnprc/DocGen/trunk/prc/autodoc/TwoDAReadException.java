package prc.autodoc;

/**
 * An exception indicating 2da read failed.
 */
public class TwoDAReadException extends java.lang.RuntimeException{
	private static final long serialVersionUID = 0x1L;
	
	/**
	 * Creates a new exception.
	 * 
	 * @param message The message this exception is to carry
	 */
	public TwoDAReadException(String message)                 { super(message); }
	
	/**
	 * Creates a new exception.
	 * 
	 * @param message The message this exception is to carry
	 * @param cause   Another exception that caused this one to be thrown
	 */
	public TwoDAReadException(String message, Throwable cause){ super(message, cause); }
}