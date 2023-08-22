package prc.utils;

import prc.autodoc.Main.TLKStore;
import prc.autodoc.Main.TwoDAStore;

import java.io.IOException;

/**
 * A class that combines Scrollgen, UpdateDes and ScrollMerchantGen. For use during
 * the build process to avoid loading the same 2da files several times.
 *
 * @author Ornedan
 */
public class BuildScrollHack {

    /**
     * Ye olde maine methode.
     *
     * @param args The arguments
     * @throws IOException Just toss any exceptions encountered
     */
    public static void main(String[] args) throws IOException {
        if (args.length == 0) readMe();
        String twoDAPath = null;
        String tlkPath = null;
        String outPath = null;

        // parse args
        for (String param : args) {//2dadir tlkdir outpath| [--help]
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
                if (twoDAPath == null)
                    twoDAPath = param;
                else if (tlkPath == null)
                    tlkPath = param;
                else if (outPath == null)
                    outPath = param;
                else {
                    System.out.println("Unknown parameter: " + param);
                    readMe();
                }
            }
        }

        // Load data
        TwoDAStore twoDA = new TwoDAStore(twoDAPath);
        TLKStore tlks = new TLKStore("dialog.tlk", "prc_consortium.tlk", tlkPath);

        ScrollGen.doScrollGen(twoDA, twoDAPath, outPath);
        UpdateDes.doUpdateDes(twoDA, twoDAPath);
        ScrollMerchantGen.doScrollMerchantGen(twoDA, tlks, outPath);
    }

    /**
     * Prints the use instructions for this program and kills execution.
     */
    private static void readMe() {
        //                  0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  java -jar prc.jar buildscrhack 2dadir tlkdir outpath| [--help]\n" +
                "\n" +
                "2dadir   Path to a directory containing 2da files\n" +
                "tlkdir   Path to a directory containing dialog.tlk and prc_consortium.tlk\n" +
                "outdir   Path to the directory to save the new scroll xml files in\n" +
                "\n" +
                "--help      prints this info you are reading\n" +
                "\n" +
                "\n" +
                "A tool for automatically updating parts of des_crft_scrolls.2da and\n" +
                "des_crft_spells.2da based on spells.2da\n"
        );
        System.exit(0);
    }
}
