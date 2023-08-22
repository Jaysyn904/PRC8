package prc.utils;

import prc.autodoc.Data_2da;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * A class that performs some validation on spell.2da by checking if it contains duplicated
 * subradial IDs.
 * Also has capability to attempt to replace the duplicate IDs with unique ones selected
 * automatically starting from a given index.
 */
public class DuplicateSubradials {
    private static class DuplicateData {
        int subnum;
        //Set<Integer> indices = new HashSet<Integer>();
        List<Integer> indices = new ArrayList<Integer>();

        DuplicateData(int subnum) {
            this.subnum = subnum;
        }
    }

    /**
     * Main method
     *
     * @param args The program arguments
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        String pathtospells2da = null;
        boolean fixduplicates = false;
        int replacementstart = -1;

        // parse args
        for (String param : args) {//[--help] | [-f replacestart] pathtospells2da
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            case 'f':
                                fixduplicates = true;
                                break;
                            default:
                                System.out.println("Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else {
                // The option to attempt fixing the duplicates is on and the first replacement number hasn't been given yet
                if (fixduplicates == true && replacementstart == -1) {
                    try {
                        replacementstart = Integer.parseInt(param);
                    } catch (NumberFormatException e) {
                        System.out.println("replacestart value given is not numeric: " + param);
                        readMe();
                    }
                    if (replacementstart < 0 || replacementstart >= 0x10000) {
                        System.out.println("replacestart value given is not in valid range");
                        readMe();
                    }
                }
                // It's a pathname
                else if (pathtospells2da == null)
                    pathtospells2da = param;
            }
        }

        // Load the 2da to memory
        Data_2da spells = Data_2da.load2da(pathtospells2da);
        Map<Integer, Integer> subrads = new HashMap<Integer, Integer>(); // Map of subradial # to the first line it occurs on
        Map<Integer, DuplicateData> duplicates = new HashMap<Integer, DuplicateData>();
        String entry;
        int subnum = 0;
        // Parse through the 2da, looking for FeatID references that contain a subradial ID
        for (int i = 0; i < spells.getEntryCount(); i++) {
            entry = spells.getEntry("FeatID", i);
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

            if (subrads.containsKey(subnum)) {
                if (!duplicates.containsKey(subnum))
                    duplicates.put(subnum, new DuplicateData(subnum));

                duplicates.get(subnum).indices.add(i);
            } else subrads.put(subnum, i);
        }

        // Print the results
        int requiredtofix = 0;
        for (DuplicateData dup : duplicates.values()) {
            System.out.println("Duplicate subradial ID: " + dup.subnum + " first occurrence on row " + subrads.get(dup.subnum));
            for (int i : dup.indices)
                System.out.println("Duplicate subradial ID: " + dup.subnum + " on row " + i);
            requiredtofix += dup.indices.size();
        }
        if (requiredtofix > 0)
            System.out.println("\nNumber of new subradial IDs required to make all unique: " + requiredtofix);

        if (fixduplicates && requiredtofix > 0) {
            System.out.println("\n\nAttempting to fix.");

            // Construct a list of the replacement subradial IDs
            List<Integer> replacementlist = new ArrayList<Integer>();
            int replacementid = replacementstart;
            while (replacementlist.size() < requiredtofix) {
                if (replacementid >= 0x10000) {// Make sure we don't exceed the bounds
                    System.out.println("Not enough free subradial IDs in the range from " + replacementstart + " to " + 0x10000 + "!");
                    System.exit(1);
                }
                // Pick ones not already in use
                if (!subrads.containsKey(replacementid))
                    replacementlist.add(replacementid);

                replacementid++;
            }

            // Loop over the duplicates, fixing as we go
            Iterator<Integer> replacements = replacementlist.iterator();
            int featid;
            for (DuplicateData dup : duplicates.values()) {
                for (int i : dup.indices) {
                    // Extract the base featID. Low 16 bits
                    featid = Integer.parseInt(spells.getEntry("FeatID", i)) & 0x0000FFFF;
                    // Insert new subradial number
                    subnum = replacements.next();
                    featid = featid | (subnum << 16);

                    // Store the new subradial'd featid in spells.2da
                    spells.setEntry("FeatID", i, Integer.toString(featid));
                }
            }

            // Save the 2da
            try {
                spells.save2da((new File(pathtospells2da)).getParent(), true, true);
            } catch (IOException e) {
                System.err.println("Error while saving spells.2da!\n" + e);
                System.exit(1);
            }

            // List the used subradial IDs
            System.out.println("Subradial IDs used:");
            Integer prev = null;
            for (Integer subrad : replacementlist) {
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
        System.out.println("Usage:\n" +
                "  [--help] | [-f replacestart] pathtospells2da\n" +
                "\n" +
                " pathtospells2da  path of the spells.2da to check\n" +
                " replacestart     the first subradial ID to replace duplicates\n" +
                "                  with when fixing. optional, required if -f is set\n" +
                "\n" +
                "  --help  prints this text\n" +
                "  -f      attempt to replace the duplicate subradial IDs with new\n" +
                "          unused IDs starting with the value given as replacestart\n" +
                "\n" +
                "\n" +
                "Looks for duplicate subradial IDs in the FeatID column of the given\n" +
                "spells.2da. May optionally attempt to replace the duplicates with unique\n" +
                "values.\n"
        );
        System.exit(0);
    }
}