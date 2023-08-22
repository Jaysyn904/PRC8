package prc.utils;

import prc.autodoc.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import static prc.Main.err_pr;
import static prc.autodoc.Main.TwoDAStore;

/**
 * Performs a bunch of cross-reference tests on 2das.
 *
 * @author Ornedan
 */
public class Validator {
    private static TwoDAStore twoDA;
    private static boolean pedantic = false;

    /**
     * Ye olde maine methode.
     *
     * @param args The arguments
     */
    public static void main(String[] args) {
        if (args.length == 0) readMe();
        String twoDAPath = null;
        String tlkPath = null;

        // parse args
        for (String param : args) {//2dadir tlkdir | [--help]
            // Parameter parseage
            if (param.startsWith("-")) {
                if (param.equals("--help")) readMe();
                else {
                    for (char c : param.substring(1).toCharArray()) {
                        switch (c) {
                            case 'p':
                                pedantic = true;
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
                else {
                    System.out.println("Unknown parameter: " + param);
                    readMe();
                }
            }
        }

        twoDA = new TwoDAStore(twoDAPath);

        doSpellsAndDes2dasTest(twoDAPath);

        doSpellsAndIprpSpellsTest(twoDAPath);

        doDesAndIprpTest(twoDAPath);
    }

    private static void doDesAndIprpTest(String twoDAPath) {
        Data_2da iprp_spells = twoDA.get("iprp_spells"),
                des_crft_spells = twoDA.get("des_crft_spells");

        // For each des_crft_spells entry, see if it points at the lowest CasterLvl entry
        Map<Integer, Tuple<Integer, Integer>> lowestIndex = new HashMap<Integer, Tuple<Integer, Integer>>(); // Map of spells.2da index -> (iprp_spells.2da index, CasterLvl value)
        int spellID, casterLvl;
        for (int i = 0; i < iprp_spells.getEntryCount(); i++) {
            if (!iprp_spells.getEntry("SpellIndex", i).equals("****")) { // Only lines that are connected to spells.2da are scanned
                try {
                    spellID = Integer.parseInt(iprp_spells.getEntry("SpellIndex", i));
                } catch (NumberFormatException e) {
                    // Logged already, just skip
                    continue;
                }
                try {
                    casterLvl = Integer.parseInt(iprp_spells.getEntry("CasterLvl", i));
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Error: Non-number value in iprp_spells.2da CasterLvl column on line " + i + ": " + iprp_spells.getEntry("CasterLvl", i));
                    continue;
                }

                if (lowestIndex.get(spellID) == null || lowestIndex.get(spellID).e2 > casterLvl)
                    lowestIndex.put(spellID, new Tuple<Integer, Integer>(i, casterLvl));
            }
        }
        for (int i = 0; i < des_crft_spells.getEntryCount(); i++) {
            if (!des_crft_spells.getEntry("IPRP_SpellIndex", i).equals("****")) {
                if (lowestIndex.get(i) == null)
                    err_pr.println("Error: Error: des_crft_spells.2da IPRP_SpellIndex defined for spell " + i + ", but no matching iprp_spells.2da entries exist");
                try {
                    if (lowestIndex.get(i).e1 != Integer.parseInt(des_crft_spells.getEntry("IPRP_SpellIndex", i)))
                        err_pr.println("Error: Warning: des_crft_spells.2da IPRP_SpellIndex entry on line " + i + " points at iprp_spells.2da entry with non-lowest CasterLvl value: " + des_crft_spells.getEntry("IPRP_SpellIndex", i) + " (lowest is on line: " + lowestIndex.get(i).e1 + ")");
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Error: Non-number value in des_crft_spells.2da IPRP_SpellIndex column on line " + i + ": " + iprp_spells.getEntry("SpellIndex", i));
                }
            } else if (lowestIndex.get(i) != null)
                err_pr.println("Error: Error: iprp_spells.2da entry defined for spell " + i + ", but des_crft_spells.2da IPRP_SpellIndex is not");
        }
    }

    private static void doSpellsAndIprpSpellsTest(String twoDAPath) {
        Data_2da spells = twoDA.get("spells"),
                iprp_spells = twoDA.get("iprp_spells");

        // For each iprp_spells entry, make sure InnateLevel matches spells Innate
        for (int i = 0; i < iprp_spells.getEntryCount(); i++) {
            if (!iprp_spells.getEntry("SpellIndex", i).equals("****")) { // Only lines that are connected to spells.2da are scanned
                try {
                    if (!iprp_spells.getEntry("InnateLvl", i).equals(spells.getEntry("Innate", Integer.parseInt(iprp_spells.getEntry("SpellIndex", i))))
                            &&
                            !(spells.getEntry("Innate", Integer.parseInt(iprp_spells.getEntry("SpellIndex", i))).equals("0") &&
                                    iprp_spells.getEntry("InnateLvl", i).equals("0.5")
                            )
                    )
                        err_pr.println("Error: Warning: Differing Innate and InnateLvl among spells.2da and iprp_spells.2da on iprp_spells.2da line " + i + ": " + "(" + spells.getEntry("Innate", Integer.parseInt(iprp_spells.getEntry("SpellIndex", i))) + "," + iprp_spells.getEntry("InnateLvl", i) + ")");
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Error: Non-number value in iprp_spells.2da SpellIndex column on line " + i + ": " + iprp_spells.getEntry("SpellIndex", i));
                }
            }
        }

        // For each iprp_spells entry, if GeneralUse is 1, check whether PotionUse and WandUse obey the standard level constraints
        if (pedantic) {
            int level;
            boolean targetSelf;
            for (int i = 0; i < iprp_spells.getEntryCount(); i++) {
                if (!iprp_spells.getEntry("SpellIndex", i).equals("****")) { // Only lines that are connected to spells.2da are scanned
                    if (!iprp_spells.getEntry("GeneralUse", i).equals("****") &&
                            !iprp_spells.getEntry("GeneralUse", i).equals("0")) {
                        try {
                            level = Integer.parseInt(iprp_spells.getEntry("InnateLvl", i));
                        } catch (NumberFormatException e) {
                            if (iprp_spells.getEntry("InnateLvl", i).equals("0.5"))
                                level = 0;
                            else {
                                err_pr.println("Error: Error: Non-number value in iprp_spells.2da InnateLvl column on line " + i + ": " + iprp_spells.getEntry("InnateLvl", i));
                                continue;
                            }
                        }
                        try {
                            targetSelf =
                                    (Integer.parseInt(spells.getEntry("TargetType",
                                            Integer.parseInt(iprp_spells.getEntry("SpellIndex", i)))
                                                    .substring(2),
                                            16)
                                            & 0x1) == 1;
                        } catch (NumberFormatException e) {
                            err_pr.println("Error: Error: Non-number value among iprp_spells.2da SpellIndex and spells.2da TargetType on iprp_spells.2da line " + i);
                            continue;
                        }

                        if (iprp_spells.getEntry("PotionUse", i).equals("0") && targetSelf && level <= 3)
                            err_pr.println("Error: Warning: PotionUse 0 in iprp_spells.2da when spell of 3rd level or less and self-targetable on line " + i);
                        if (iprp_spells.getEntry("PotionUse", i).equals("1") && (!targetSelf || level > 3))
                            err_pr.println("Error: Warning: PotionUse 1 in iprp_spells.2da when spell of level higher than 3rd or not self-targetable on line " + i);

                        if (iprp_spells.getEntry("WandUse", i).equals("0") && level <= 4)
                            err_pr.println("Error: Warning: WandUse 0 in iprp_spells.2da when spell of 4th level or less on line " + i);
                        if (iprp_spells.getEntry("WandUse", i).equals("1") && level > 4)
                            err_pr.println("Error: Warning: WandUse 1 in iprp_spells.2da when spell of level higher than 4th on line " + i);
                    }
                }
            }
        }

        // For each actual spell in spells.2da, make sure there is at least one iprp_spells.2da entry
        Set<Integer> spellIDs = new TreeSet<Integer>();
        for (int i = 0; i < spells.getEntryCount(); i++) {
            if (!spells.getEntry("Bard", i).equals("****") ||
                    !spells.getEntry("Cleric", i).equals("****") ||
                    !spells.getEntry("Druid", i).equals("****") ||
                    !spells.getEntry("Paladin", i).equals("****") ||
                    !spells.getEntry("Ranger", i).equals("****") ||
                    !spells.getEntry("Wiz_Sorc", i).equals("****"))
                spellIDs.add(i);
        }
        for (int i = 0; i < iprp_spells.getEntryCount(); i++) {
            if (!iprp_spells.getEntry("SpellIndex", i).equals("****")) {
                try {
                    spellIDs.remove(Integer.parseInt(iprp_spells.getEntry("SpellIndex", i)));
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Error: Non-number value in iprp_spells.2da SpellIndex column on line " + i + ": " + iprp_spells.getEntry("SpellIndex", i));
                }
            }
        }
        for (int spellID : spellIDs)
            err_pr.println("Error: Error: Spell " + spellID + " does not have any iprp_spells.2da entries");
    }

    private static void doSpellsAndDes2dasTest(String twoDAPath) {
        Data_2da spells = twoDA.get("spells"),
                des_crft_scroll = twoDA.get("des_crft_scroll"),
                des_crft_spells = twoDA.get("des_crft_spells");

        // First, whine about differing lengths on spells and des_crft_spells
        if (spells.getEntryCount() != des_crft_spells.getEntryCount())
            err_pr.println("Error: Warning: spells.2da and des_crft_spells.2da have different number of entries");

        int maxCommon = Math.min(Math.min(spells.getEntryCount(), des_crft_spells.getEntryCount()), des_crft_scroll.getEntryCount());

        // First, check labels up to the common max
        for (int i = 0; i < maxCommon; i++) {
            if (!(spells.getEntry("Label", i).equals(des_crft_spells.getEntry("Label", i)) &&
                    spells.getEntry("Label", i).equals(des_crft_scroll.getEntry("Label", i)) &&
                    des_crft_spells.getEntry("Label", i).equals(des_crft_scroll.getEntry("Label", i))))
                err_pr.println("Error: Warning: Differing Label among spells.2da, des_crft_scroll.2da and des_crft_spells.2da on line: " + i + "('" + spells.getEntry("Label", i) + "','" + des_crft_scroll.getEntry("Label", i) + "','" + des_crft_spells.getEntry("Label", i) + "')");
        }

        // Then, check spells.2da and des_crft_spells.2da
        int a = 0, b = 0;
        boolean spellsNum, desNum;
        for (int i = 0; i < Math.min(spells.getEntryCount(), des_crft_spells.getEntryCount()); i++) {
            spellsNum = desNum = true;
            // Here, we are only interested in lines that contain something
            if (!(spells.getEntry("Label", i).startsWith("**") ||
                    spells.getEntry("Label", i).equals("ReservedForISCAndESS"))
            ) {
                if (!spells.getEntry("Label", i).equals(des_crft_spells.getEntry("Label", i)))
                    err_pr.println("Error: Warning: Differing Label among spells.2da and des_crft_spells.2da on line: " + i + "('" + spells.getEntry("Label", i) + "','" + des_crft_spells.getEntry("Label", i) + "')");
                try {
                    a = Integer.parseInt(spells.getEntry("Innate", i));
                } catch (NumberFormatException e) {
                    spellsNum = false;
                }
                try {
                    b = Integer.parseInt(des_crft_spells.getEntry("Level", i));
                } catch (NumberFormatException e) {
                    desNum = false;
                }

                // If both are numeric, compare
                if (spellsNum && desNum) {
                    if (a != b)
                        err_pr.println("Error: Error: Differing Innate and Level values among spells.2da and des_crft_spells.2da on line " + i + ": " + "(" + a + "," + b + ")");
                } // Otherwise, erroneous cases are those where only one value is non-numeric
                else if (!spellsNum && desNum)
                    err_pr.println("Error: Error: Non-number value in spells.2da Innate column on line " + i + ": " + spells.getEntry("Innate", i));
                else if (spellsNum && !desNum)
                    err_pr.println("Error: Error: Non-number value in des_crft_spells.2da Level column on line " + i + ": " + des_crft_spells.getEntry("Level", i));
                    // Or where the non-numericity is not just ****
                else {
                    if (!spells.getEntry("Innate", i).equals("****"))
                        err_pr.println("Error: Error: Non-number value in spells.2da Innate column on line " + i + ": " + spells.getEntry("Innate", i));
                    if (!des_crft_spells.getEntry("Level", i).equals("****"))
                        err_pr.println("Error: Error: Non-number value in des_crft_spells.2da Level column on line " + i + ": " + des_crft_spells.getEntry("Level", i));
                }
            }
        }

        // Then check that all spells that have a scroll is are NoScroll 0
        for (int i = 0; i < des_crft_scroll.getEntryCount(); i++) {
            if ((!des_crft_scroll.getEntry("Wiz_Sorc", i).equals("****") ||
                    !des_crft_scroll.getEntry("Cleric", i).equals("****") ||
                    !des_crft_scroll.getEntry("Paladin", i).equals("****") ||
                    !des_crft_scroll.getEntry("Druid", i).equals("****") ||
                    !des_crft_scroll.getEntry("Ranger", i).equals("****") ||
                    !des_crft_scroll.getEntry("Bard", i).equals("****")
            ) &&
                    des_crft_spells.getEntry("NoScroll", i).equals("1")
            )
                err_pr.println("Error: Error: NoScroll 1 in des_crft_spells.2da when a scroll entry has been defined in des_crft_scroll.2da on line: " + i);
        }

        // Then check that all spells that should have a scroll do have a scroll
        for (int i = 0; i < spells.getEntryCount(); i++) {
            checkScrollsPresence(spells, des_crft_scroll, "Bard", i);
            checkScrollsPresence(spells, des_crft_scroll, "Cleric", i);
            checkScrollsPresence(spells, des_crft_scroll, "Druid", i);
            checkScrollsPresence(spells, des_crft_scroll, "Paladin", i);
            checkScrollsPresence(spells, des_crft_scroll, "Ranger", i);
            checkScrollsPresence(spells, des_crft_scroll, "Wiz_Sorc", i);
        }
    }

    private static void checkScrollsPresence(Data_2da spells, Data_2da des_crft_scroll, String column, int i) {
        if (!spells.getEntry(column, i).equals("****")) {
            if (i >= des_crft_scroll.getEntryCount() || des_crft_scroll.getEntry(column, i).equals("****")) {
                err_pr.println("Error: Error: No " + column + " scroll defined in des_crft_scroll when " + column + " level is defined in spells on line: " + i);
            }
        }
    }

    /**
     * Prints the use instructions for this program and kills execution.
     */
    private static void readMe() {
        //                  0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  java -jar prc.jar validate 2dadir tlkdir | [--help]\n" +
                "\n" +
                "2dadir   Path to a directory containing 2da files\n" +
                "tlkdir   Path to a directory containing dialog.tlk and prc_consortium.tlk\n" +
                "\n" +
                "-p       pedantic mode. Makes extra checks\n" +
                "\n" +
                "--help   prints this info you are reading\n" +
                "\n" +
                "\n" +
                "Performs a set of validation operations on 2da files.\n"
        );
        System.exit(0);
    }
}
