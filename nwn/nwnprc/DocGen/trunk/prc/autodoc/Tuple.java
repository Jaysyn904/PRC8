package prc.autodoc;

/**
 * A simple tuple class
 *
 * @param <T1> The type of the first element of the tuple
 * @param <T2> The type of the second element of the tuple
 * @author Ornedan
 */
public class Tuple<T1, T2> {
    /**
     * The first element
     */
    public final T1 e1;
    /**
     * The second element
     */
    public final T2 e2;

    /**
     * Generates a new tuple out of the given two objects.
     *
     * @param e1 The object to become the first element of the new tuple
     * @param e2 The object to become the second element of the new tuple
     */
    public Tuple(T1 e1, T2 e2) {
        this.e1 = e1;
        this.e2 = e2;
    }
}
