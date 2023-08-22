package prc.utils;

import prc.autodoc.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;

import static prc.Main.err_pr;

/**
 * Checks the given column in the given 2da for duplicate entries.
 *
 * @author Ornedan
 */
public class Duplicate2daEntryDetector {

    private static boolean ignoreCase = false;
    private static boolean accountEmpty = false;

    /**
     * Ye olde main.
     *
     * @param args
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        String filePath = null;
        ArrayList<String> labels = new ArrayList<String>();

        // parse args
        for (String param : args) {//[--help] | [-i] pathof2da columnlabel+
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            case 'c':
                                ignoreCase = true;
                                break;
                            case 'e':
                                accountEmpty = true;
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

        // Load the 2da
        Data_2da file = Data_2da.load2da(filePath);

        // Test the columns
        for (String label : labels) {
            TreeMap<String, ArrayList<Integer>> duplicates = new TreeMap<String, ArrayList<Integer>>();
            // Examine column
            HashMap<String, Integer> entries = new HashMap<String, Integer>();
            String value;
            for (int i = 0; i < file.getEntryCount(); i++) {
                value = accountForCase(file, label, i);
                // Do not account for empty entries unless requested
                if (value.equals("****") && !accountEmpty)
                    continue;

                if (!entries.containsKey(value))
                    entries.put(value, i);
                else {
                    // If no duplicates of this value have yet been found, init the arraylist for it
                    if (!duplicates.containsKey(value)) {
                        duplicates.put(value, new ArrayList<Integer>());
                        duplicates.get(value).add(entries.get(value));
                    }
                    // Either way, add the current row to the list of duplicates
                    duplicates.get(value).add(i);
                }
            }

            for (ArrayList<Integer> duprows : duplicates.values()) {
                StringBuffer toPrint = new StringBuffer(file.getName() + ": duplicate " + label + " on rows");
                boolean first = true;
                for (int row : duprows) {
                    if (!first)
                        toPrint.append(',');
                    else
                        first = false;

                    toPrint.append(" " + row);
                }

                err_pr.println(toPrint.toString());
            }
        }
    }

    private static String accountForCase(Data_2da data, String label, int index) {
        return ignoreCase ?
                data.getEntry(label, index).toLowerCase() :
                data.getEntry(label, index);
    }

    private static void readMe() {
        System.out.println("Usage:\n" +
                "  [--help] | [-ce] pathof2da columnlabel+\n" +
                "\n" +
                " pathof2da   path of the 2da to check\n" +
                " columnlabel label of a column to test for duplicate entries\n" +
                "\n" +
                "  -c      ignores case of the entries testes for duplicacy\n" +
                "  -e      does not ignore empty entries. ie, ****\n" +
                "\n" +
                "  --help  prints this text\n" +
                "\n" +
                "Unless -e is specified, empty entries (****) do not count as duplicates\n"
        );
        System.exit(0);
    }
}
