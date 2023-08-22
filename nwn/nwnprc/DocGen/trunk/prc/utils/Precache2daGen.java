package prc.utils;

import prc.autodoc.*;

import java.io.File;
import java.io.FileFilter;
import java.util.HashSet;
import java.util.Set;

import static prc.Main.err_pr;

/**
 * A class that parses 2das and determines which rows need to be
 * cached for the spells / powers to work fast.
 *
 * @author Heikki 'Ornedan' Aitakangas
 */
public class Precache2daGen {
    private static String path2daDir = null;
    private static final Data_2da output = new Data_2da("precacherows");

    static {
        output.addColumn("RowNum");
        output.addColumn("Type");
    }

    private static Data_2da spells = null/*,
	                        feat   = null*/;

    private static int normalSpellMaxRow = 4200;

    /**
     * Ye olde maine methode.
     *
     * @param args The program arguments
     * @throws Throwable Any problems just crash the program
     */
    public static void main(String[] args) throws Throwable {
//		 parse args
        for (int i = 0; i < args.length; i++) {//[--help] | [--normalspellsmax #] pathto2dadir
            // Parameter parseage
            String param = args[i];
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else if (param.equals("--normalspellsmax")) {
                    try {
                        normalSpellMaxRow = Integer.parseInt(args[++i]);
                    } catch (NumberFormatException e) {
                        err_pr.println("Error: Invalid number given with parameter --normalspellsmax");
                        readMe();
                    }
                } else {
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
                if (path2daDir == null)
                    path2daDir = param;
            }
        }

        if (path2daDir == null)
            readMe();

        // Load a directory listing
        File dir = new File(path2daDir);
        if (!dir.isDirectory()) {
            err_pr.println("Error: Not a directory: " + path2daDir);
            System.exit(1);
        }

        // Load the main 2das
        spells = Data_2da.load2da(dir.getPath() + File.separator + "spells.2da");
        //feat   = Data_2da.load2da(dir.getPath() + File.separator + "feat.2da");

        handleNormalSpells();
        //should generalise all of the AMS ones later - Flaming_Sword
        handlePsionics(dir);
        handleTruenaming(dir);
        handleTob(dir);
        handleInvocations(dir);
        handleNewSpells();

        output.appendRow();

        output.save2da(".", false, true);
    }

    private static void readMe() {
        //					0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  [--help] | [--normalspellsmax #] pathto2dadir\n" +
                "\n" +
                " pathto2dadir  path of the directory containing the 2das that will be parsed\n" +
                "\n" +
                " normalspellsmax    The greatest index to which the normal spells seek will\n" +
                "                    reach to. Defaults to 5000\n" +
                "\n" +
                "\n" +
                "  --help  prints this text\n"
        );
        System.exit(0);
    }

    private static void handleNormalSpells() {
        int temp;
        for (int i = 0; i < normalSpellMaxRow; i++) {
            if (// Check the row i itself
                    !spells.getEntry("Bard", i).equals("****") ||
                            !spells.getEntry("Cleric", i).equals("****") ||
                            !spells.getEntry("Druid", i).equals("****") ||
                            !spells.getEntry("Paladin", i).equals("****") ||
                            !spells.getEntry("Ranger", i).equals("****") ||
                            !spells.getEntry("Wiz_Sorc", i).equals("****") ||
                            // Check the master
                            (// Make sure a master entry exists
                                    !spells.getEntry("Master", i).equals("****") &&
                                            (// See if it's a normal spell
                                                    !spells.getEntry("Bard", temp = Integer.parseInt(spells.getEntry("Master", i))).equals("****") ||
                                                            !spells.getEntry("Cleric", temp).equals("****") ||
                                                            !spells.getEntry("Druid", temp).equals("****") ||
                                                            !spells.getEntry("Paladin", temp).equals("****") ||
                                                            !spells.getEntry("Ranger", temp).equals("****") ||
                                                            !spells.getEntry("Wiz_Sorc", temp).equals("****")
                                            )
                            )
            ) {
                // It's a normal spell or a subradial of one
                output.appendRow();
                temp = output.getEntryCount() - 1;
                output.setEntry("RowNum", temp, Integer.toString(i));
                output.setEntry("Type", temp, "N");
            }
        }
    }

    private static void handlePsionics(File dir) {
        File[] files = dir.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.getName().toLowerCase().startsWith("cls_psipw_") &&
                        file.getName().toLowerCase().endsWith(".2da");
            }
        });

        Data_2da[] cls_psipw_2das = new Data_2da[files.length];
        for (int i = 0; i < files.length; i++)
            cls_psipw_2das[i] = Data_2da.load2da(files[i].getPath());

        int temp;
        Set<Integer> realEntriesHandled = new HashSet<Integer>();
        // First, spells.2da referencing entries
        for (Data_2da cls_psipw : cls_psipw_2das) {
            for (int i = 0; i < cls_psipw.getEntryCount(); i++) {
                // Add the feat-linked power's data
                if (!cls_psipw.getEntry("SpellID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_psipw.getEntry("SpellID", i));
                    output.setEntry("Type", temp, "P");
                }
                // Add the real entry's data
                if (!cls_psipw.getEntry("RealSpellID", i).equals("****")) {
                    temp = Integer.parseInt(cls_psipw.getEntry("RealSpellID", i));
                    if (!realEntriesHandled.contains(temp)) {
                        realEntriesHandled.add(temp);
                        output.appendRow();
                        temp = output.getEntryCount() - 1;
                        output.setEntry("RowNum", temp, cls_psipw.getEntry("RealSpellID", i));
                        output.setEntry("Type", temp, "PS");
                    }
                }
            }
        }
        // Feat.2da entries
        for (Data_2da cls_psipw : cls_psipw_2das) {
            for (int i = 0; i < cls_psipw.getEntryCount(); i++) {
                // The feat's data
                if (!cls_psipw.getEntry("FeatID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_psipw.getEntry("FeatID", i));
                    output.setEntry("Type", temp, "PF");
                }
            }
        }
    }

    private static void handleTob(File dir) {
        File[] files = dir.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.getName().toLowerCase().startsWith("cls_move_") &&
                        file.getName().toLowerCase().endsWith(".2da");
            }
        });

        Data_2da[] cls_psipw_2das = new Data_2da[files.length];
        for (int i = 0; i < files.length; i++)
            cls_psipw_2das[i] = Data_2da.load2da(files[i].getPath());

        int temp;
        Set<Integer> realEntriesHandled = new HashSet<Integer>();
        // First, spells.2da referencing entries
        for (Data_2da cls_psipw : cls_psipw_2das) {
            for (int i = 0; i < cls_psipw.getEntryCount(); i++) {
                // Add the feat-linked power's data
                if (!cls_psipw.getEntry("SpellID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_psipw.getEntry("SpellID", i));
                    output.setEntry("Type", temp, "P");
                }
                // Add the real entry's data
                if (!cls_psipw.getEntry("RealSpellID", i).equals("****")) {
                    temp = Integer.parseInt(cls_psipw.getEntry("RealSpellID", i));
                    if (!realEntriesHandled.contains(temp)) {
                        realEntriesHandled.add(temp);
                        output.appendRow();
                        temp = output.getEntryCount() - 1;
                        output.setEntry("RowNum", temp, cls_psipw.getEntry("RealSpellID", i));
                        output.setEntry("Type", temp, "PS");
                    }
                }
            }
        }
        // Feat.2da entries
        for (Data_2da cls_psipw : cls_psipw_2das) {
            for (int i = 0; i < cls_psipw.getEntryCount(); i++) {
                // The feat's data
                if (!cls_psipw.getEntry("FeatID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_psipw.getEntry("FeatID", i));
                    output.setEntry("Type", temp, "PF");
                }
            }
        }
    }

    private static void handleInvocations(File dir) {
        File[] files = dir.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.getName().toLowerCase().startsWith("cls_inv_") &&
                        file.getName().toLowerCase().endsWith(".2da");
            }
        });

        Data_2da[] cls_psipw_2das = new Data_2da[files.length];
        for (int i = 0; i < files.length; i++)
            cls_psipw_2das[i] = Data_2da.load2da(files[i].getPath());

        int temp;
        Set<Integer> realEntriesHandled = new HashSet<Integer>();
        // First, spells.2da referencing entries
        for (Data_2da cls_psipw : cls_psipw_2das) {
            for (int i = 0; i < cls_psipw.getEntryCount(); i++) {
                // Add the feat-linked power's data
                if (!cls_psipw.getEntry("SpellID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_psipw.getEntry("SpellID", i));
                    output.setEntry("Type", temp, "P");
                }
                // Add the real entry's data
                if (!cls_psipw.getEntry("RealSpellID", i).equals("****")) {
                    temp = Integer.parseInt(cls_psipw.getEntry("RealSpellID", i));
                    if (!realEntriesHandled.contains(temp)) {
                        realEntriesHandled.add(temp);
                        output.appendRow();
                        temp = output.getEntryCount() - 1;
                        output.setEntry("RowNum", temp, cls_psipw.getEntry("RealSpellID", i));
                        output.setEntry("Type", temp, "PS");
                    }
                }
            }
        }
        // Feat.2da entries
        for (Data_2da cls_psipw : cls_psipw_2das) {
            for (int i = 0; i < cls_psipw.getEntryCount(); i++) {
                // The feat's data
                if (!cls_psipw.getEntry("FeatID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_psipw.getEntry("FeatID", i));
                    output.setEntry("Type", temp, "PF");
                }
            }
        }
    }

    // Pretty much a copy of psionics, at least for now
    private static void handleTruenaming(File dir) {
        File[] files = dir.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.getName().toLowerCase().startsWith("cls_true_") &&
                        file.getName().toLowerCase().endsWith(".2da") &&
                        !file.getName().equalsIgnoreCase("cls_true_known.2da") && // Skip special cases
                        !file.getName().equalsIgnoreCase("cls_true_maxlvl.2da");
            }
        });

        Data_2da[] cls_true_2das = new Data_2da[files.length];
        for (int i = 0; i < files.length; i++)
            cls_true_2das[i] = Data_2da.load2da(files[i].getPath());

        int temp;
        Set<Integer> realEntriesHandled = new HashSet<Integer>();
        // First, spells.2da referencing entries
        for (Data_2da cls_true : cls_true_2das) {
            for (int i = 0; i < cls_true.getEntryCount(); i++) {
                // Add the feat-linked spells.2da data
                if (!cls_true.getEntry("SpellID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_true.getEntry("SpellID", i));
                    output.setEntry("Type", temp, "P");
                }
                // Add the real entry's data
                if (!cls_true.getEntry("RealSpellID", i).equals("****")) {
                    temp = Integer.parseInt(cls_true.getEntry("RealSpellID", i));
                    if (!realEntriesHandled.contains(temp)) {
                        realEntriesHandled.add(temp);
                        output.appendRow();
                        temp = output.getEntryCount() - 1;
                        output.setEntry("RowNum", temp, cls_true.getEntry("RealSpellID", i));
                        output.setEntry("Type", temp, "PS");
                    }
                }
            }
        }
        // Feat.2da entries
        for (Data_2da cls_true : cls_true_2das) {
            for (int i = 0; i < cls_true.getEntryCount(); i++) {
                // The feat's data
                if (!cls_true.getEntry("FeatID", i).equals("****")) {
                    output.appendRow();
                    temp = output.getEntryCount() - 1;
                    output.setEntry("RowNum", temp, cls_true.getEntry("FeatID", i));
                    output.setEntry("Type", temp, "PF");
                }
            }
        }
    }

    private static void handleNewSpells() {
        int begin = -1, end = -1;
        int temp, i = normalSpellMaxRow;
        while (i < spells.getEntryCount()) {
            if (spells.getEntry("Label", i).equals("####START_OF_NEW_SPELLBOOK_RESERVE"))
                begin = i + 1;
            if (spells.getEntry("Label", i).equals("####END_OF_NEW_SPELLBOOK_RESERVE"))
                end = i - 1;
            if (begin != -1 && end != -1)
                break;
            i += 1;
        }

        if (begin == -1 || end == -1) {
            err_pr.println("Error: Missing a new spellbook reserve marker");
            System.exit(1);
        }

        for (i = begin; i <= end; i++) {
            output.appendRow();
            temp = output.getEntryCount() - 1;
            output.setEntry("RowNum", temp, String.valueOf(i));
            output.setEntry("Type", temp, "NS");
        }
    }
}
