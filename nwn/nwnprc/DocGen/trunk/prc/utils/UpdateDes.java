package prc.utils;

import prc.autodoc.*;
import prc.autodoc.Main.TwoDAStore;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * A tool for automatically updating parts of des_crft_scrolls.2da
 * and des_crft_spells.2da based on spells.2da.
 *
 * @author Ornedan
 */
public class UpdateDes {

    /**
     * Ye olde maine methode.
     *
     * @param args The arguments
     * @throws IOException Just toss any exceptions encountered
     */
    public static void main(String[] args) throws IOException {
        if (args.length == 0) readMe();
        String twoDAPath = null;
        //String tlkPath   = null;

        // parse args
        for (String param : args) {//2dadir | [--help]
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
				/*else if(tlkPath == null)
					tlkPath = param;*/
                else {
                    System.out.println("Unknown parameter: " + param);
                    readMe();
                }
            }
        }

        TwoDAStore twoDA = new TwoDAStore(twoDAPath);

        doUpdateDes(twoDA, twoDAPath);
    }

    /**
     * Performs the actual 2da updating. Made public for the purposes of BuildScrollHack.
     *
     * @param twoDA     A TwoDAStore for loading 2da data from
     * @param twoDAPath Path where the 2da files are located. For resaving
     * @throws IOException Just tossed back up
     */
    public static void doUpdateDes(TwoDAStore twoDA, String twoDAPath) throws IOException {
        Data_2da spells = twoDA.get("spells"),
                des_crft_scroll = twoDA.get("des_crft_scroll"),
                des_crft_spells = twoDA.get("des_crft_spells"),
                iprp_spells = twoDA.get("iprp_spells");

        // First, find the highest entry in spells that should have a corresponding entry in des_crft_scroll
        // In other words, one that is cast by arcane or divine casters
        int highestScroll = -1;
        for (int i = 0; i < spells.getEntryCount(); i++) {
            if (!(spells.getEntry("Bard", i).equals("****") &&
                    spells.getEntry("Cleric", i).equals("****") &&
                    spells.getEntry("Druid", i).equals("****") &&
                    spells.getEntry("Paladin", i).equals("****") &&
                    spells.getEntry("Ranger", i).equals("****") &&
                    spells.getEntry("Wiz_Sorc", i).equals("****")))
                highestScroll = i;
        }
        //System.out.println("Highest entry that should have des_crft_scroll entry: " + highestScroll);

        // If des_crft_scroll size is under the number determined above, add entries
        while (des_crft_scroll.getEntryCount() <= highestScroll)
            des_crft_scroll.appendRow();

        // Next, do the same for des_crft_spells size. Except it should just be equal to spells size
        while (des_crft_spells.getEntryCount() < spells.getEntryCount())
            des_crft_spells.appendRow();

        // Next, update any case where Label of des_crft_scroll or des_crft_spells is **** and spells not ****
        for (int i = 0; i < des_crft_scroll.getEntryCount(); i++) {
            if (!spells.getEntry("Label", i).equals("****") &&
                    !spells.getEntry("Label", i).equals(des_crft_scroll.getEntry("Label", i))) {
                des_crft_scroll.setEntry("Label", i, spells.getEntry("Label", i));
            }
        }
        for (int i = 0; i < des_crft_spells.getEntryCount(); i++) {
            if (!spells.getEntry("Label", i).equals("****") &&
                    !spells.getEntry("Label", i).equals(des_crft_spells.getEntry("Label", i))) {
                des_crft_spells.setEntry("Label", i, spells.getEntry("Label", i));
            }
        }

        // Next, update all des_crft_spells Level column values to equal spells Innate values
        for (int i = 0; i < des_crft_spells.getEntryCount(); i++) {
            des_crft_spells.setEntry("Level", i, spells.getEntry("Innate", i));
        }


        // Update des_crft_spell IPRP_SpellIndex to be the one with lowest CasterLvl for that spell
        Map<Integer, Tuple<Integer, Integer>> lowestIndex = new HashMap<Integer, Tuple<Integer, Integer>>(); // Map of spells.2da index -> (iprp_spells.2da index, CasterLvl value)
        int spellID, casterLvl;
        for (int i = 0; i < iprp_spells.getEntryCount(); i++) {
            if (!iprp_spells.getEntry("SpellIndex", i).equals("****")) { // Only lines that are connected to spells.2da are scanned
                spellID = Integer.parseInt(iprp_spells.getEntry("SpellIndex", i));
                casterLvl = Integer.parseInt(iprp_spells.getEntry("CasterLvl", i));

                if (lowestIndex.get(spellID) == null || lowestIndex.get(spellID).e2 > casterLvl)
                    lowestIndex.put(spellID, new Tuple<Integer, Integer>(i, casterLvl));
            }
        }
        for (int i = 0; i < des_crft_spells.getEntryCount(); i++) {
            if (lowestIndex.get(i) != null) {
                des_crft_spells.setEntry("IPRP_SpellIndex", i, lowestIndex.get(i).e1.toString());
            }
        }


        // Update all des_crft_spells entries that define IPRP_SpellIndex based on that iprp_spells.2da data
        int iprp_index;
        for (int i = 0; i < des_crft_spells.getEntryCount(); i++) {
            // If there is an IP Cast Spell for this spell, see what uses it specifies and match them
            if (!des_crft_spells.getEntry("IPRP_SpellIndex", i).equals("****")) {
                iprp_index = Integer.parseInt(des_crft_spells.getEntry("IPRP_SpellIndex", i));

                if (iprp_spells.getEntry("GeneralUse", iprp_index).equals("1"))
                    des_crft_spells.setEntry("NoScroll", i, "0");
                else
                    des_crft_spells.setEntry("NoScroll", i, "1");

                if (iprp_spells.getEntry("PotionUse", iprp_index).equals("1"))
                    des_crft_spells.setEntry("NoPotion", i, "0");
                else
                    des_crft_spells.setEntry("NoPotion", i, "1");

                if (iprp_spells.getEntry("WandUse", iprp_index).equals("1"))
                    des_crft_spells.setEntry("NoWand", i, "0");
                else
                    des_crft_spells.setEntry("NoWand", i, "1");
            }
            // No IP, no item creation
            else {
                des_crft_spells.setEntry("NoScroll", i, "1");
                des_crft_spells.setEntry("NoPotion", i, "1");
                des_crft_spells.setEntry("NoWand", i, "1");
            }
        }

        des_crft_scroll.save2da(twoDAPath, true, true);
        des_crft_spells.save2da(twoDAPath, true, true);
    }

    /**
     * Prints the use instructions for this program and kills execution.
     */
    private static void readMe() {
        //                  0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                        "  java -jar prc.jar updatedescrft 2dadir | [--help]\n" +
                        "\n" +
                        "2dadir   Path to a directory containing 2da files\n" +
//		                   "tlkdir   Path to a directory containing dialog.tlk and prc_consortium.tlk\n" +
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
