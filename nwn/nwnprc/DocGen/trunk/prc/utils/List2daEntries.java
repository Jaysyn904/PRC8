package prc.utils;

import prc.Main;
import prc.autodoc.Data_2da;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

/**
 * A class that lists the unique entries found in the given column of the given 2da file.
 *
 * @author Ornedan
 */
public class List2daEntries {

    /**
     * Ye olde main.
     *
     * @param args Program arguments
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        String filePath = null;
        ArrayList<String> labels = new ArrayList<String>();
        boolean quiet = false;

        // parse args
        for (String param : args) {//[--help] | pathof2da columnlabel+
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            case 'q':
                                quiet = true;
                                break;
                            default:
                                System.out.println("Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else {
                // It's a pathname
                if (filePath == null)
                    filePath = param;
                else
                    labels.add(param);
            }
        }

        if (quiet) {
            Main.verbose = false;
            Main.spinner.disable();
        }

        // Load the 2da
        Data_2da file = Data_2da.load2da(filePath);

        // Loop over the columns
        for (String label : labels) {
            Set<String> entries = new HashSet<String>();
            String value;

            for (int i = 0; i < file.getEntryCount(); i++) {
                value = file.getEntry(label, i);

                entries.add(value);
            }

            StringBuffer toPrint = new StringBuffer(quiet ? "" : (file.getName() + ": entries on column " + label + "\n"));
            for (String entry : entries) {
                toPrint.append(entry + "\n");
            }

            System.out.println(toPrint.toString());
        }
    }

    private static void readMe() {
        System.out.println("Usage:\n" +
                "  [--help] | [-q] pathof2da columnlabel+\n" +
                "\n" +
                " pathof2da   path of the 2da to check\n" +
                " columnlabel label of a column to list entries of\n" +
                "\n" +
                "  -q      silent mode. Only prints the results" +
                "  --help  prints this text\n"
        );
        System.exit(0);
    }
}
