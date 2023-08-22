package prc.utils;

import prc.autodoc.Data_2da;

import java.util.TreeSet;

/**
 * A class that parses spells.2da and lists used subradial feat ID ranges.
 *
 * @author Ornedan
 */
public class ListSubradials {

    /**
     * Main method
     *
     * @param args The program arguments
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        String pathtospells2da = null;

        // parse args
        for (String param : args) {//[--help] | pathtospells2da
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            default:
                                System.out.println("Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else {
                // It's a pathname
                if (pathtospells2da == null)
                    pathtospells2da = param;
            }
        }

        // Load the 2da to memory
        Data_2da feats = Data_2da.load2da(pathtospells2da);
        TreeSet<Integer> subrads = new TreeSet<Integer>();
        String entry;
        int subnum;
        // Parse through the 2da, looking for FeatID references that contain a subradial ID
        for (int i = 0; i < feats.getEntryCount(); i++) {
            entry = feats.getEntry("FeatID", i);
            // Skip blanks
            if (entry.equals("****")) continue;
            try {
                subnum = Integer.parseInt(entry);
            } catch (NumberFormatException e) {
                System.out.println("Corrupt value in FeatID on row " + i + ": " + entry);
                continue;
            }
            // Skip non-subradial FeatIDs
            if (subnum < 0x10000) continue;
            subnum = subnum >>> 16;

            subrads.add(subnum);
        }

        // Print the results
        System.out.println("Subradial IDs used:");
        if (subrads.isEmpty())
            System.out.println("None");
        else {
            Integer prev = null;
            for (Integer subrad : subrads) {
                // Detect if a new range is starting
                if (prev == null || // Special case - just starting
                        subrad != (prev + 1)   // There's a break in the series
                ) {
                    // Print the end of previous range
                    if (prev != null)
                        System.out.println(prev);

                    // Print the start of the new range
                    System.out.print(subrad + " - ");
                }

                // Update prev
                prev = subrad;
            }

            // Print the end of the last range
            System.out.println(prev);
        }
    }

    private static void readMe() {
        //                  0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  [--help] | pathtospells2da\n" +
                "\n" +
                " pathtospells2da  path of the spells.2da to check\n" +
                "\n" +
                "  --help  prints this text\n" +
                "\n" +
                "\n" +
                "Lists used subradial ID ranges in the FeatID column of the given spells.2da\n"
        );
        System.exit(0);
    }
}
