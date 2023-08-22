package prc.utils;

/**
 * A class for generating subradial FeatID values when given a feat.2da index and
 * the first subradial value.
 *
 * @author Ornedan
 */
public class Radials {
    /**
     * Main method
     *
     * @param args The program arguments
     */
    public static void main(String[] args) {
        if (args.length == 0)
            readMe();

        int feat = Integer.parseInt(args[0]),
                radialrangestart = Integer.parseInt(args[1]);

        System.out.println("Five consecutive radialfeat FeatIDs for feat " + feat + " starting from " + radialrangestart + ":");

        for (int i = 0; i < 5; i++) {
            System.out.println((radialrangestart + i) + " & " + feat + ": " + ((radialrangestart + i) * 0x10000 + feat));
        }
    }

    private static void readMe() {
        System.out.println("Usage: java Radials featid subradnum");
        System.exit(0);
    }
}