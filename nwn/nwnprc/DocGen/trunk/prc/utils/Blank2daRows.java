package prc.utils;

import prc.autodoc.*;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * A tool for blanking ranges of 2da rows.
 *
 * @author Ornedan
 */
public class Blank2daRows {

    /**
     * Ye olde maine methode.
     *
     * @param args The program arguments, as usual.
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        if (args.length == 0) readMe();
        String targetPath = null;
        List<int[]> ranges = new ArrayList<int[]>();

        for (String param : args) {//target B-E ... | [--help]
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            default:
                                System.err.println("Unknown parameter: " + c);
                                readMe();
                        }
                    }
                }
            } else
                // If the target file hasn't been specified, assume this is it
                if (targetPath == null)
                    targetPath = param;
                else {
                    try {
                        if (!param.contains("-")) throw new Exception(); // Missing -
                        String[] rawNums = param.split("-");
                        if (rawNums.length != 2) throw new Exception(); // More than two numbers(?) in the string
                        int[] range = new int[]{Integer.parseInt(rawNums[0]), Integer.parseInt(rawNums[1])};
                        ranges.add(range);
                    } catch (Exception e) {
                        System.err.println("Malformed number pair:" + param);
                        System.exit(1);
                    }
                }
        }

        // Load the 2da
        Data_2da target = Data_2da.load2da(targetPath);

        // Bounds checks
        for (int[] range : ranges) {
            if (range[0] > range[1]) { // Lower bound > upper bound
                System.err.println("Lower bound > upper bound in pair: " + range[0] + "-" + range[1]);
                System.exit(1);
            }
            if (range[0] < 0 || range[1] < 0 ||
                    range[0] >= target.getEntryCount() ||
                    range[1] >= target.getEntryCount()) { // Bound out of range
                System.err.println("Bound out of range in pair: " + range[0] + "-" + range[1]);
                System.exit(1);
            }
        }

        // Do blanking
        for (int[] range : ranges)
            blankRows(target, range[0], range[1]);

        // Save 2da back out
        target.save2da(new File(targetPath).getParent(), true, true);
    }

    /**
     * Does the row blanking - replaces the contents of each column in the affected row range with whatever
     * is the default value in this 2da.
     *
     * @param target Data_2da to perform the operation on
     * @param begin  Beginning of the range to blank, inclusive
     * @param end    End of the range to blank, inclusive
     */
    private static void blankRows(Data_2da target, int begin, int end) {
        for (int i = begin; i <= end; i++) {
            for (String label : target.getLabels())
                target.setEntry(label, i, null);
        }
    }

    private static void readMe() {
        //      0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  target B-E ... | [--help]\n" +
                "\n" +
                " This tool blanks rows in a 2da file, replacing the contents of given rows with\n" +
                " either **** or the 2da-specific default value if such is specified.\n" +
                "\n" +
                "  target Path to the 2da file to apply the blanking operation to\n" +
                "  B-E    Row number pair, specifying which rows in the file to blank. Inclusive,\n" +
                "         for example 1000-1002 would blank rows 1000, 1001 and 1002. Multiple\n" +
                "         ranges may be specified.\n" +
                "\n" +
                "  --help  prints this text\n"
        );
        System.exit(0);
    }
}
