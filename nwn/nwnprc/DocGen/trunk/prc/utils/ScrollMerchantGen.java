package prc.utils;

import prc.autodoc.*;
import prc.autodoc.Main.TLKStore;
import prc.autodoc.Main.TwoDAStore;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.TreeMap;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static prc.Main.verbose;


/**
 * A little tool that parses des_crft_scroll, extracts unique item resrefs from it and
 * makes a merchant selling those resrefs.
 *
 * @author Heikki 'Ornedan' Aitakangas
 */
public class ScrollMerchantGen {

    /**
     * Ye olde maine methode.
     *
     * @param args The arguments
     * @throws IOException If the writing fails, just die on the exception
     */
    public static void main(String[] args) throws IOException {
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

        // Load data
        TwoDAStore twoDA = new TwoDAStore(twoDAPath);
        TLKStore tlks = new TLKStore("dialog.tlk", "prc8_consortium.tlk", tlkPath);

        doScrollMerchantGen(twoDA, tlks, "scrolltemp");
    }
    public static Set<Integer> getAllSpellCastingClasses(TwoDAStore twoDA)
    {
        Set<Integer> vanillaSpellcasterClasses = Set.of(1,2,3,6,7,9,10);
        HashSet<Integer> result = new HashSet<Integer>();
        Data_2da classes = twoDA.get("classes");
        for(int i = 0; i < classes.getEntryCount(); i++) {
            // handle the vanilla spellcasters
            if (vanillaSpellcasterClasses.contains(i)) {
                result.add(i);
                continue;
            }
            
            boolean isSpellCaster = classes.getEntry("SpellCaster", i).equals("1");
            boolean isPlayerClass = classes.getEntry("PlayerClass", i).equals("1");
            if (!isSpellCaster || !isPlayerClass) continue;

            // Attempt to load the spellbook 2da for the class. If it fails, not a spellcaster,
            // or a spellcaster that reuses another book (so we don't need a shop for them).
            try {
                String classAbrev = classes.getEntry("FeatsTable", i).toLowerCase().substring(9);
                twoDA.get("cls_spcr_" + classAbrev);
            } catch (TwoDAReadException e) {
                continue;
            }

            String label = classes.getEntry("Label", i);
            if (!label.equals("****")) result.add(i);
        }
        return result;
    }
    /**
     * Performs the scroll merchant generation for all scroll shops.
     * @param twoDA A TwoDAStore for loading 2da data from
     * @param tlks  A TLKStore for reading tlk data from
     * @throws IOException Just tossed back up
     */
    public static void doScrollMerchantGen(TwoDAStore twoDA, TLKStore tlks, String outPath) throws IOException {
        String shopPrefix = "prcSS_";
        List<ScrollInfo> allScrolls = getAllScrolls(twoDA, tlks);
        doScrollMerchantGenShop(twoDA, tlks, outPath, false, allScrolls, "prc_scrolls", scroll -> true);
        for(int classId : getAllSpellCastingClasses(twoDA)) {
            String allClassSpellsShop = shopPrefix + "C" + classId;


            doScrollMerchantGenShop(twoDA, tlks, outPath, false, allScrolls, allClassSpellsShop, 
                scroll -> scroll.classesForSpellWithLevel.containsKey(classId));

            for(int level = 0; level <= 9; level++) {
                final int spellLevel = level;
                String shopName = shopPrefix + "C" + classId + "L" + level;
                doScrollMerchantGenShop(twoDA, tlks, outPath, false, allScrolls, shopName, 
                    scroll -> {
                        Map<Integer, Integer> classSpellInfo = scroll.classesForSpellWithLevel;
                        return classSpellInfo.containsKey(classId) && classSpellInfo.get(classId).equals(spellLevel);
                    });
            }
        }
        char[] letters = "abcdefghijklmnopqrstuvwxyz".toCharArray();
        for(char letter : letters) {
            String shopName = "prcSS_alpha_" + letter;
            doScrollMerchantGenShop(twoDA, tlks, outPath, true, allScrolls, shopName,
                scroll -> scroll.Name.toLowerCase().startsWith("" + letter));

        }
    }


    private static List<ScrollInfo> getAllScrolls(TwoDAStore twoDA, TLKStore tlks)
    {
        Data_2da spells2da = twoDA.get("spells");
        Data_2da scrolls2da = twoDA.get("des_crft_scroll");
        // Loop over the scroll entries and get a list of unique resrefs
        TreeMap<Integer, TreeMap<String, ScrollInfo>> arcaneScrollResRefs = new TreeMap<Integer, TreeMap<String, ScrollInfo>>();
        TreeMap<Integer, TreeMap<String, ScrollInfo>> divineScrollResRefs = new TreeMap<Integer, TreeMap<String, ScrollInfo>>();
        String entry;
        for (int i = 0; i < scrolls2da.getEntryCount(); i++) {
            // Skip subradials
            if (spells2da.getEntry("Master", i).equals("****")) {
                if (!(entry = scrolls2da.getEntry("Wiz_Sorc", i)).equals("****"))
                    addScroll(arcaneScrollResRefs, twoDA, tlks, i, entry.toLowerCase());
                if (!(entry = scrolls2da.getEntry("Cleric", i)).equals("****"))
                    addScroll(divineScrollResRefs, twoDA, tlks, i, entry.toLowerCase());
                if (!(entry = scrolls2da.getEntry("Paladin", i)).equals("****"))
                    addScroll(divineScrollResRefs, twoDA, tlks, i, entry.toLowerCase());
                if (!(entry = scrolls2da.getEntry("Druid", i)).equals("****"))
                    addScroll(divineScrollResRefs, twoDA, tlks, i, entry.toLowerCase());
                if (!(entry = scrolls2da.getEntry("Ranger", i)).equals("****"))
                    addScroll(divineScrollResRefs, twoDA, tlks, i, entry.toLowerCase());
                if (!(entry = scrolls2da.getEntry("Bard", i)).equals("****"))
                    addScroll(arcaneScrollResRefs, twoDA, tlks, i, entry.toLowerCase());
            }
        }
        //int posCounter = 0;
        Stream<ScrollInfo> arcaneLevelScrollRefRefs = arcaneScrollResRefs.values()
            .stream().flatMap(scrollMap -> scrollMap.values().stream());
        Stream<ScrollInfo> divineLevelScrollRefRefs = divineScrollResRefs.values()
            .stream().flatMap(scrollMap -> scrollMap.values().stream());
        Stream<ScrollInfo> allScrollInfos = Stream.concat(arcaneLevelScrollRefRefs, divineLevelScrollRefRefs)
            .distinct()
            .sorted((scroll1, scroll2) -> -scroll1.Name.compareTo(scroll2.Name));

        return allScrollInfos.collect(Collectors.toList());

    }

    /**
     * Performs the scroll merchant generation. Made public for the purposes of BuildScrollHack.
     *
     * @param twoDA A TwoDAStore for loading 2da data from
     * @param tlks  A TLKStore for reading tlk data from
     * @param allScrolls A list containing ScrollInfo for all scrolls
     * @param shopName The name of the shop (will generate a <shopName>.utm.xml file)
     * @param scrollFilter A predicate used to filter the scrolls for the given shop
     * @throws IOException Just tossed back up
     */
    private static void doScrollMerchantGenShop(TwoDAStore twoDA, TLKStore tlks, String outPath,
            boolean generateEmptyShops,
            List<ScrollInfo> allScrolls, String shopName, Predicate<ScrollInfo> scrollFilter) throws IOException {
        // Load the 2da file
        Data_2da scrolls2da = twoDA.get("des_crft_scroll");
        Data_2da spells2da = twoDA.get("spells");



        String xmlPrefix =
                "<gff name=\"" + shopName + ".utm\" type=\"UTM \" version=\"V3.2\" >" + "\n" +
                        "    <struct id=\"-1\" >" + "\n" +
                        "        <element name=\"ResRef\" type=\"11\" value=\"" + shopName + "\" />" + "\n" +
                        "        <element name=\"LocName\" type=\"12\" value=\"64113\" >" + "\n" +
                        "            <localString languageId=\"0\" value=\"" + shopName + "\" />" + "\n" +
                        "        </element>" + "\n" +
                        "        <element name=\"Tag\" type=\"10\" value=\"" + shopName + "\" />" + "\n" +
                        "        <element name=\"MarkUp\" type=\"5\" value=\"100\" />" + "\n" +
                        "        <element name=\"MarkDown\" type=\"5\" value=\"100\" />" + "\n" +
                        "        <element name=\"BlackMarket\" type=\"0\" value=\"0\" />" + "\n" +
                        "        <element name=\"BM_MarkDown\" type=\"5\" value=\"15\" />" + "\n" +
                        "        <element name=\"IdentifyPrice\" type=\"5\" value=\"-1\" />" + "\n" +
                        "        <element name=\"MaxBuyPrice\" type=\"5\" value=\"-1\" />" + "\n" +
                        "        <element name=\"StoreGold\" type=\"5\" value=\"-1\" />" + "\n" +
                        "        <element name=\"OnOpenStore\" type=\"11\" value=\"\" />" + "\n" +
                        "        <element name=\"OnStoreClosed\" type=\"11\" value=\"\" />" + "\n" +
                        "        <element name=\"WillNotBuy\" type=\"15\" />" + "\n" +
                        "        <element name=\"WillOnlyBuy\" type=\"15\" >" + "\n" +
                        "            <struct id=\"97869\" >" + "\n" +
                        "                <element name=\"BaseItem\" type=\"5\" value=\"29\" />" + "\n" +
                        "            </struct>" + "\n" +
                        "        </element>" + "\n" +
                        "        <element name=\"StoreList\" type=\"15\" >" + "\n" +
                        "            <struct id=\"0\" />" + "\n" +
                        "            <struct id=\"4\" />" + "\n" +
                        "            <struct id=\"2\" >" + "\n" +
                        "                <element name=\"ItemList\" type=\"15\" >" + "\n";
        String xmlSuffix =
                "                </element>" + "\n" +
                        "			 </struct>" + "\n" +
                        "            <struct id=\"3\" />" + "\n" +
                        "            <struct id=\"1\" />" + "\n" +
                        "        </element>" + "\n" +
                        "        <element name=\"ID\" type=\"0\" value=\"5\" />" + "\n" +
                        "        <element name=\"Comment\" type=\"10\" value=\"\" />" + "\n" +
                        "    </struct>" + "\n" +
                        "</gff>" + "\n";

        StringBuffer xmlString = new StringBuffer();

        Stream<ScrollInfo> allScrollRefRefs = allScrolls.stream().filter(scrollFilter);
        int[] posCounterRef = new int[] { 0 };
        allScrollRefRefs.forEach(scroll -> {
            int posCounter = posCounterRef[0];
            String resref = scroll.ScrollResRef;
            String name = scroll.Name;
            xmlString.append(
                    "                    <struct id=\"" + posCounter + "\" >" + "\n" +
                            "                        <element name=\"InventoryRes\" type=\"11\" value=\"" + resref + "\" />" + "<!-- " + name + " -->" + "\n" +
                            "                        <element name=\"Repos_PosX\" type=\"2\" value=\"" + (posCounter % 10) + "\" />" + "\n" +
                            "                        <element name=\"Repos_Posy\" type=\"2\" value=\"" + (posCounter / 10) + "\" />" + "\n" +
                            "                        <element name=\"Infinite\" type=\"0\" value=\"1\" />" + "\n" +
                            "                    </struct>" + "\n"
            );
            posCounterRef[0]+= 1;

        });
        if (posCounterRef[0] == 0) {
            System.out.println("No scrolls found for shop " + shopName);
            if (!generateEmptyShops) return;
        }

        // // Then divine scrolls
        // for (Map<String, String> levelScrollResRefs : divineScrollResRefs.values())
        //     for (String name : levelScrollResRefs.keySet()) {
        //         String resref = levelScrollResRefs.get(name);
        //         xmlString.append(
        //                 "                    <struct id=\"" + posCounter + "\" >" + "\n" +
        //                         "                        <element name=\"InventoryRes\" type=\"11\" value=\"" + resref + "\" />" + "<!-- " + name + " -->" + "\n" +
        //                         "                        <element name=\"Repos_PosX\" type=\"2\" value=\"" + (posCounter % 10) + "\" />" + "\n" +
        //                         "                        <element name=\"Repos_Posy\" type=\"2\" value=\"" + (posCounter / 10) + "\" />" + "\n" +
        //                         "                        <element name=\"Infinite\" type=\"0\" value=\"1\" />" + "\n" +
        //                         "                    </struct>" + "\n"
        //         );
        //         posCounter++;
        //     }

        String shopFilePath = outPath + File.separator + shopName + ".utm.xml";
        File target = new File(shopFilePath);
        // Clean up old version if necessary
        if (target.exists()) {
            if (verbose) System.out.println("Deleting previous version of " + target.getName());
            target.delete();
        }
        if (verbose) System.out.println("Writing brand new version of " + target.getName());
        target.createNewFile();

        // Creater the writer and print
        FileWriter writer = new FileWriter(target, true);
        writer.write(xmlPrefix + xmlString.toString() + xmlSuffix);
        // Clean up
        writer.flush();
        writer.close();
    }

    private static class ScrollInfo {
        private TwoDAStore twoDAStore;

        public ScrollInfo(TwoDAStore twoDA, int rowNum, String scrollResRef, String name) {
            this.twoDAStore = twoDA;
            this.ScrollResRef = scrollResRef;
            this.Name = name;

            Data_2da spells2da = twoDA.get("spells");

            
            try {
                this.SpellLevel = Integer.parseInt(spells2da.getEntry("Innate", rowNum));
            } catch (NumberFormatException e) {
                System.err.println("Non-number value in spells.2da Innate column on line " + rowNum + ": " + spells2da.getEntry("Innate", rowNum));
                return;
            }

            Data_2da classes = twoDA.get("classes");
            this.classesForSpellWithLevel = ScrollGen.getClassesForSpell(twoDA, rowNum);

        }
        public int SpellLevel = -1;
        public String ScrollResRef;
        public String Name;
        public Map<Integer, Integer> classesForSpellWithLevel;

        public boolean equals(Object other)
        {
            if (this == other) return true;
            if (other == null) return false;
            if (getClass() != other.getClass()) return false;
            ScrollInfo otherScroll = (ScrollInfo)other;
            return ScrollResRef.equals(otherScroll.ScrollResRef);
        }
        public int hashCode() {
            return Objects.hash(ScrollResRef);
        }
    }

    private static void addScroll(TreeMap<Integer, TreeMap<String, ScrollInfo>> scrollResRefs,
                                  TwoDAStore twoDAStore, TLKStore tlks, int rowNum, String scrollResRef) {
        int innateLevel = -1,
                tlkRef = -1;

        Data_2da spells2da = twoDAStore.get("spells");
        // HACK - Skip non-PRC scrolls
        if (!scrollResRef.startsWith("prc_scr_"))
            return;


        try {
            tlkRef = Integer.parseInt(spells2da.getEntry("Name", rowNum));
        } catch (NumberFormatException e) {
            System.err.println("Non-number value in spells.2da Name column on line " + rowNum + ": " + spells2da.getEntry("Name", rowNum));
            return;
        }
        ScrollInfo scroll = new ScrollInfo(twoDAStore, rowNum, scrollResRef, tlks.get(tlkRef));
        scroll.SpellLevel = innateLevel;

        innateLevel = scroll.SpellLevel;

        if (scrollResRefs.get(innateLevel) == null)
            scrollResRefs.put(innateLevel, new TreeMap<String, ScrollInfo>());

        scrollResRefs.get(innateLevel).put(tlks.get(tlkRef), scroll);
    }

    /**
     * Prints the use instructions for this program and kills execution.
     */
    private static void readMe() {
        //                  0        1         2         3         4         5         6         7         8
        //					12345678901234567890123456789012345678901234567890123456789012345678901234567890
        System.out.println("Usage:\n" +
                "  java -jar prc.jar scrmrchgen 2dadir tlkdir | [--help]\n" +
                "\n" +
                "2dadir   Path to a directory containing des_crft_scroll.2da and spells.2da.\n" +
                "tlkdir   Path to a directory containing dialog.tlk and prc8_consortium.tlk\n" +
                "\n" +
                "--help      prints this info you are reading\n" +
                "\n" +
                "\n" +
                "Generates a merchant file - prc_scrolls.utm - based on the given scroll list\n" +
                "2da file. The merchant file will be written to current directory in Pspeed's\n" +
                "XML <-> Gff -xml format\n"
        );
        System.exit(0);
    }
}
    