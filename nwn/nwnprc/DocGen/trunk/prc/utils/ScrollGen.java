package prc.utils;

import prc.autodoc.*;
import prc.autodoc.Main.TwoDAStore;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import static prc.Main.err_pr;
import static prc.Main.verbose;

/**
 * Creates scrolls based on iprp_spells.2da and spells.2da.
 *
 * @author Ornedan
 */
public class ScrollGen {

    /**
     * Ye olde maine methode.
     *
     * @param args The arguments
     * @throws IOException Just toss any exceptions encountered
     */
    public static void main(String[] args) throws IOException {
        if (args.length == 0) readMe();
        String twoDAPath = null;
        String outPath = null;

        // parse args
        for (String param : args) {//2dadir outdir | [--help]
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

        doScrollGen(twoDA, twoDAPath, outPath);
    }

    /**
     * Performs the actual scroll generation. Made public for the purposes of BuildScrollHack.
     *
     * @param twoDA     A TwoDAStore for loading 2da data from
     * @param twoDAPath Path where the 2da files are located. For resaving
     * @param outPath   Path to directory to store the xml files in
     * @throws IOException Just tossed back up
     */
    public static void doScrollGen(TwoDAStore twoDA, String twoDAPath, String outPath) throws IOException {
        Data_2da spells = twoDA.get("spells"),
                des_crft_scroll = twoDA.get("des_crft_scroll"),
                des_crft_spells = twoDA.get("des_crft_spells"),
                iprp_spells = twoDA.get("iprp_spells");


        // For each spells.2da entry, find the iprp_spells.2da entry with lowest CasterLvl value
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


        /// For each scroll to make, find which spellcasting classes should be able to use that scroll
        // Map of spells.2da index -> (iprp_spells.2da index, list of classes.2da index)
        Map<Integer, Tuple<Integer, Set<Integer>>> scrolls = new HashMap<Integer, Tuple<Integer, Set<Integer>>>();

        for (int spellsIndex : lowestIndex.keySet()) {
            int iprpIndex = lowestIndex.get(spellsIndex).e1;
            Set<Integer> classList = getClassesForSpell(twoDA, spellsIndex).keySet();

            if (classList.size() > 0)
                scrolls.put(spellsIndex, new Tuple<Integer, Set<Integer>>(iprpIndex, classList));
        }

        // Do the scrolls
        for (int spellsIndex : scrolls.keySet()) {
            String scrollName = "prc_scr_" + scrolls.get(spellsIndex).e1.toString();
            String scrollXml = doScroll(spells, scrollName, spellsIndex, scrolls.get(spellsIndex).e1, scrolls.get(spellsIndex).e2);

            // Print the scroll
            printScroll(outPath, scrollName, scrollXml);

            // Update des_crft_scrolls accordingly
            Set<Integer> classList = scrolls.get(spellsIndex).e2;
            if (classList.contains(1))
                setScroll(des_crft_scroll, spells, spellsIndex, "Bard", scrollName);
            if (classList.contains(9) || classList.contains(10))
                setScroll(des_crft_scroll, spells, spellsIndex, "Wiz_Sorc", scrollName);
            if (classList.contains(2))
                setScroll(des_crft_scroll, spells, spellsIndex, "Cleric", scrollName);
            if (classList.contains(3))
                setScroll(des_crft_scroll, spells, spellsIndex, "Druid", scrollName);
            if (classList.contains(6))
                setScroll(des_crft_scroll, spells, spellsIndex, "Paladin", scrollName);
            if (classList.contains(7))
                setScroll(des_crft_scroll, spells, spellsIndex, "Ranger", scrollName);
        }

        // Save updated des_crft_scrolls.2da
        des_crft_scroll.save2da(twoDAPath, true, true);
    }

    public static Map<Integer, Integer> getClassesForSpell(TwoDAStore twoDA, int spellsIndex)
    {
        Data_2da spells = twoDA.get("spells");
        Map<Integer, Integer> classList = new TreeMap<Integer, Integer>();

        // BAD
        // Hardcoded classes.2da indexes
        String bardSpell = spells.getEntry("Bard", spellsIndex);
        String clericSpell = spells.getEntry("Cleric", spellsIndex);
        String druidSpell = spells.getEntry("Druid", spellsIndex);
        String paladinSpell = spells.getEntry("Paladin", spellsIndex);
        String rangerSpell = spells.getEntry("Ranger", spellsIndex);
        String wizSpell = spells.getEntry("Wiz_Sorc", spellsIndex);
        if (!bardSpell.equals("****"))
            classList.put(1, Integer.parseInt(bardSpell));
        if (!clericSpell.equals("****"))
            classList.put(2, Integer.parseInt(clericSpell));
        if (!druidSpell.equals("****"))
            classList.put(3, Integer.parseInt(druidSpell));
        if (!paladinSpell.equals("****"))
            classList.put(6, Integer.parseInt(paladinSpell));
        if (!rangerSpell.equals("****"))
            classList.put(7, Integer.parseInt(rangerSpell));
        if (!wizSpell.equals("****")) {
            classList.put(9, Integer.parseInt(wizSpell));
            classList.put(10, Integer.parseInt(wizSpell));
        }
        /// For each spell, find which new spellbooks have that spell
        // Map of spells.2da index -> (map of classes.2da index -> spell level)
        Map<Integer, Map<Integer, Integer>> newSpellBooks = getNewSpellbooksClasses(twoDA, spells);

        // New spellbooks
        Map<Integer, Integer> newSpellBookEntries = newSpellBooks.get(spellsIndex);
        if (newSpellBookEntries != null)
            for(Integer classId : newSpellBookEntries.keySet()) {
                classList.put(classId, newSpellBookEntries.get(classId));
            }
        
        return classList;

    }

    private static Map<Integer, Map<Integer, Integer>> newSpellbookCache = null;

    private static Map<Integer, Map<Integer, Integer>> getNewSpellbooksClasses(TwoDAStore twoDA, Data_2da spells) {
        if (newSpellbookCache != null) return newSpellbookCache;
        // Map of spells.2da index -> list of classes.2da index
        HashMap<Integer, Map<Integer, Integer>> toReturn = new HashMap<Integer, Map<Integer, Integer>>();
        String classAbrev = null;
        Data_2da classes = twoDA.get("classes"),
                spellList = null;
        Integer spellId;

        for (int classId = 0; classId < classes.getEntryCount(); classId++) {
            if (!classes.getEntry("PlayerClass", classId).equals("1")) continue;

            // Extract the class abbreviation
            classAbrev = classes.getEntry("FeatsTable", classId).toLowerCase().substring(9);

            // Attempt to load the spellbook 2da
            try {
                spellList = twoDA.get("cls_spcr_" + classAbrev);
            } catch (TwoDAReadException e) {
                continue;
            }

            for (int i = 0; i < spellList.getEntryCount(); i++) {
                String spellEntry = spellList.getEntry("SpellID", i);
                String spellLevelEntry = spellList.getEntry("Level", i);
                if (!spellEntry.equals("****")) {
                    spellId = Integer.parseInt(spellEntry);
                    int spellLevel = Integer.parseInt(spellLevelEntry);
                    if (toReturn.get(spellId) == null) {
                        toReturn.put(spellId, new TreeMap<Integer, Integer>());
                    }
                    toReturn.get(spellId).put(classId, spellLevel);
                }
            }
        }
        newSpellbookCache = toReturn;
        return toReturn;
    }

    private static void setScroll(Data_2da des_crft_scroll, Data_2da spells, int spellsIndex, String column, String scrollName) {
        // Set the main entry
        des_crft_scroll.setEntry(column, spellsIndex, scrollName);

        // Set each subradial's entry
        for (int i = 1; i <= 5; i++)
            if (!spells.getEntry("SubRadSpell" + i, spellsIndex).equals("****")) {
                des_crft_scroll.setEntry(column, Integer.parseInt(spells.getEntry("SubRadSpell" + i, spellsIndex)), scrollName);
            }
    }

    private static final String xmlPrefix =
            "<gff name=\"~~~Name~~~.uti\" type=\"UTI \" version=\"V3.2\" >" + "\n" +
                    "    <struct id=\"-1\" >" + "\n" +
                    "        <element name=\"TemplateResRef\" type=\"11\" value=\"~~~Name~~~\" />" + "\n" +
                    "        <element name=\"BaseItem\" type=\"5\" value=\"75\" />" + "\n" +
                    "        <element name=\"LocalizedName\" type=\"12\" value=\"~~~TLKName~~~\" />" + "\n" +
                    "        <element name=\"Description\" type=\"12\" value=\"-1\" />" + "\n" +
                    "        <element name=\"DescIdentified\" type=\"12\" value=\"~~~TLKDesc~~~\" />" + "\n" +
                    "        <element name=\"Tag\" type=\"10\" value=\"~~~Tag~~~\" />" + "\n" +
                    "        <element name=\"Charges\" type=\"0\" value=\"0\" />" + "\n" +
                    "        <element name=\"Cost\" type=\"4\" value=\"0\" />" + "\n" +
                    "        <element name=\"Stolen\" type=\"0\" value=\"0\" />" + "\n" +
                    "        <element name=\"StackSize\" type=\"2\" value=\"1\" />" + "\n" +
                    "        <element name=\"Plot\" type=\"0\" value=\"0\" />" + "\n" +
                    "        <element name=\"AddCost\" type=\"4\" value=\"0\" />" + "\n" +
                    "        <element name=\"Identified\" type=\"0\" value=\"1\" />" + "\n" +
                    "        <element name=\"Cursed\" type=\"0\" value=\"0\" />" + "\n" +
                    "        <element name=\"ModelPart1\" type=\"0\" value=\"1\" />" + "\n" +
                    "        <element name=\"PropertiesList\" type=\"15\" >" + "\n" +
                    "            <struct id=\"0\" >" + "\n" +
                    "                <element name=\"PropertyName\" type=\"2\" value=\"15\" />" + "\n" +
                    "                <element name=\"Subtype\" type=\"2\" value=\"~~~IPIndex~~~\" />" + "\n" +
                    "                <element name=\"CostTable\" type=\"0\" value=\"3\" />" + "\n" +
                    "                <element name=\"CostValue\" type=\"2\" value=\"1\" />" + "\n" +
                    "                <element name=\"Param1\" type=\"0\" value=\"255\" />" + "\n" +
                    "                <element name=\"Param1Value\" type=\"0\" value=\"0\" />" + "\n" +
                    "                <element name=\"ChanceAppear\" type=\"0\" value=\"100\" />" + "\n" +
                    "            </struct>" + "\n";
    private static final String xmlClass =
            "            <struct id=\"0\" >" + "\n" +
                    "                <element name=\"PropertyName\" type=\"2\" value=\"63\" />" + "\n" +
                    "                <element name=\"Subtype\" type=\"2\" value=\"~~~Class~~~\" />" + "\n" +
                    "                <element name=\"CostTable\" type=\"0\" value=\"0\" />" + "\n" +
                    "                <element name=\"CostValue\" type=\"2\" value=\"0\" />" + "\n" +
                    "                <element name=\"Param1\" type=\"0\" value=\"255\" />" + "\n" +
                    "                <element name=\"Param1Value\" type=\"0\" value=\"0\" />" + "\n" +
                    "                <element name=\"ChanceAppear\" type=\"0\" value=\"100\" />" + "\n" +
                    "            </struct>" + "\n";
    private static final String xmlSuffix =
            "        </element>" + "\n" +
                    "        <element name=\"PaletteID\" type=\"0\" value=\"26\" />" + "\n" +
                    "        <element name=\"Comment\" type=\"10\" value=\"1\" />" + "\n" +
                    "    </struct>" + "\n" +
                    "</gff>";

    private static String doScroll(Data_2da spells, String name, int spellsIndex, int iprpIndex, Set<Integer> classes) {
        // Determine TLK references
        int tlkName = Integer.parseInt(spells.getEntry("Name", spellsIndex));
        int tlkDesc = Integer.parseInt(spells.getEntry("SpellDesc", spellsIndex));

        // Build the string
        String toReturn = xmlPrefix.replaceAll("~~~Name~~~", name)
                .replaceAll("~~~Tag~~~", name.toUpperCase())
                .replaceAll("~~~IPIndex~~~", "" + iprpIndex)
                .replaceAll("~~~TLKName~~~", "" + tlkName)
                .replaceAll("~~~TLKDesc~~~", "" + tlkDesc);

        for (Integer classIndex : classes)
            toReturn += xmlClass.replaceAll("~~~Class~~~", classIndex.toString());

        toReturn += xmlSuffix;
        return toReturn;
    }

    private static void printScroll(String outDir, String scrollName, String scrollXml) {
        String path = outDir + File.separator + scrollName + ".uti.xml";
        try {
            File target = new File(path);
            // Clean up old version if necessary
            if (target.exists()) {
                if (verbose) System.out.println("Deleting previous version of " + path);
                target.delete();
            }
            target.createNewFile();

            // Creater the writer and print
            FileWriter writer = new FileWriter(target, false);
            writer.write(scrollXml);
            // Clean up
            writer.flush();
            writer.close();
        } catch (IOException e) {
            err_pr.println("Error: IOException when printing " + path + ":\n" + e);
        }
    }

    /**
     * Prints the use instructions for this program and kills execution.
     */
    private static void readMe() {
        //                  0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  java -jar prc.jar scrollgen 2dadir outdir | [--help]\n" +
                "\n" +
                "2dadir   Path to a directory containing 2da files\n" +
                "outdir   Path to the directory to save the new scroll xml files in\n" +
                "\n" +
                "--help      prints this info you are reading\n" +
                "\n" +
                "\n" +
                "A tool for automatically creating spell scrolls based on iprp_spells.2da\n" +
                "and spells.2da. Generates pspeed's modpacker -compatible XML\n" +
                "Also updates des_crft_scrolls with the new scroll resrefs.\n"
        );
        System.exit(0);
    }
}
