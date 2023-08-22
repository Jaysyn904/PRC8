package prc.autodoc;

import java.io.FileOutputStream;
import java.io.PrintWriter;

/**
 * A convenience class for printing errors to both log and System.err
 */
public class ErrorPrinter {
    private PrintWriter writer;
    private boolean isInit = false;

    /**
     * Initializes the ErrorPrinter.
     * Attempts to open a log file by name of "errorlog" for writing. If this
     * fails, aborts the program.
     */
    private void init() {
        try {
            writer = new PrintWriter(new FileOutputStream("errorlog", false), true);
            isInit = true;
        } catch (Exception e) {
            System.err.println("Error while creating error logger. Yes, it's ironic. Now debug");
            e.printStackTrace();
            System.exit(1);
        }
    }


    /**
     * Prints the given string to both stderr and errorlog.
     *
     * @param toPrint string to write
     */
    public void print(String toPrint) {
        if (!isInit)
            init();
        writer.print(toPrint);
        System.err.print(toPrint);
    }

    /**
     * Prints the given string to both stderr and errorlog. In addition, adds
     * a line terminator to the end of the string.
     *
     * @param toPrint string to write
     */
    public void println(String toPrint) {
        if (!isInit)
            init();
        writer.println(toPrint);
        System.err.println(toPrint);
    }

    /**
     * Prints the given exception's stack trace to both stderr and errorlog.
     *
     * @param e exception to print
     */
    public void printException(Exception e) {
        if (!isInit)
            init();
        e.printStackTrace(System.out);
        e.printStackTrace(writer);
    }
}