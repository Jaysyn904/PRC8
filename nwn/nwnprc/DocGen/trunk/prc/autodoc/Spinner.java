package prc.autodoc;

import java.util.Date;

/**
 * An absolutely critical part of the Document Creator, not. Prints a spinning line
 * for the user to look at while the program is working.
 */
public final class Spinner {
    private final char[] states = new char[]{'|', '/', '-', '\\'};
    private int curState = 0;
    private boolean active = true;
    private Date lastSpinTime = new Date();


    /**
     * Spins the spinner.
     */
    public void spin() {
        long minTimeBetweenSpinsInMS = 300;
        if (active && new Date().getTime() - lastSpinTime.getTime() > minTimeBetweenSpinsInMS) {
            System.out.print(states[curState = ++curState % states.length] + "\u0008");
            lastSpinTime = new Date();
        }
    }


    /**
     * Turns the spinner off.
     */
    public void disable() {
        active = false;
    }
}