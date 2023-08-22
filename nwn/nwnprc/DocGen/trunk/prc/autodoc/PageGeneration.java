package prc.autodoc;

import java.util.List;
import java.util.TreeMap;

import static prc.Main.err_pr;
import static prc.Main.verbose;
import static prc.autodoc.Main.*;

/**
 * This class contains the methods for manual page generation.
 *
 * @author Ornedan
 */
public final class PageGeneration {
    private PageGeneration() {/* No need for instantiation */}

    /**
     * Handles printing of the skill pages.
     */
    public static void printSkills() {
        String text = null;

        for (GenericEntry skill : skills.values()) {
            if (verbose) System.out.println("Printing page for " + skill.name);
            // Start building the entry data. First, place in the name
            text = skillTemplate;
            text = text.replaceAll("~~~SkillName~~~", skill.name);
            // Then, put in the description
            text = text.replaceAll("~~~SkillTLKDescription~~~",
                    skill.text);
            // Add in the icon
            text = text.replaceAll("~~~Icon~~~", skill.iconPath);

            // Print the page
            try {
                printPage(skill.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for skill " + skill.entryNum + ": " + skill.name + ":\n" + e);
            }
        }
        System.gc();
    }

    /**
     * Handles printing of the crafting property pages.
     */
    public static void printCrafting() {
        String text = null;

        for (GenericEntry craft_armour_var : craft_armour.values()) {
            if (verbose) System.out.println("Printing page for " + craft_armour_var.name);
            // Start building the entry data. First, place in the name
            text = craftTemplate;
            text = text.replaceAll("~~~CraftPropName~~~", craft_armour_var.name);
            // Then, put in the description
            text = text.replaceAll("~~~CraftPropTLKDescription~~~",
                    craft_armour_var.text);
            // Print the page
            try {
                printPage(craft_armour_var.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for skill " + craft_armour_var.entryNum + ": " + craft_armour_var.name + ":\n" + e);
            }
        }
        for (GenericEntry craft_weapon_var : craft_weapon.values()) {
            if (verbose) System.out.println("Printing page for " + craft_weapon_var.name);
            // Start building the entry data. First, place in the name
            text = craftTemplate;
            text = text.replaceAll("~~~CraftPropName~~~", craft_weapon_var.name);
            // Then, put in the description
            text = text.replaceAll("~~~CraftPropTLKDescription~~~",
                    craft_weapon_var.text);
            // Print the page
            try {
                printPage(craft_weapon_var.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for skill " + craft_weapon_var.entryNum + ": " + craft_weapon_var.name + ":\n" + e);
            }
        }
        for (GenericEntry craft_ring_var : craft_ring.values()) {
            if (verbose) System.out.println("Printing page for " + craft_ring_var.name);
            // Start building the entry data. First, place in the name
            text = craftTemplate;
            text = text.replaceAll("~~~CraftPropName~~~", craft_ring_var.name);
            // Then, put in the description
            text = text.replaceAll("~~~CraftPropTLKDescription~~~",
                    craft_ring_var.text);
            // Print the page
            try {
                printPage(craft_ring_var.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for skill " + craft_ring_var.entryNum + ": " + craft_ring_var.name + ":\n" + e);
            }
        }
        for (GenericEntry craft_wondrous_var : craft_wondrous.values()) {
            if (verbose) System.out.println("Printing page for " + craft_wondrous_var.name);
            // Start building the entry data. First, place in the name
            text = craftTemplate;
            text = text.replaceAll("~~~CraftPropName~~~", craft_wondrous_var.name);
            // Then, put in the description
            text = text.replaceAll("~~~CraftPropTLKDescription~~~",
                    craft_wondrous_var.text);
            // Print the page
            try {
                printPage(craft_wondrous_var.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for skill " + craft_wondrous_var.entryNum + ": " + craft_wondrous_var.name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Prints all spells and spell-likes (psionics, truenaming).
     * As of now, all of these are similar enough to share the same
     * template, so they can be done here together.
     */
    public static void printSpells() {
        String text = null;
        StringBuilder subradialText = null;

        for (SpellEntry spell : spells.values()) {
            if (verbose) System.out.println("Printing page for " + spell.name);
            // Start building the entry data. First, place in the name
            text = spellTemplate;
            text = text.replaceAll("~~~SpellName~~~", spell.name);
            // Then, put in the description
            text = text.replaceAll("~~~SpellTLKDescription~~~",
                    spell.text);
            // Add in the icon
            text = text.replaceAll("~~~Icon~~~", spell.iconPath);

            // Handle subradials, if any
            subradialText = new StringBuilder();
            if (spell.subradials != null) {
                for (Tuple<String, String> subradial : spell.subradials) {
                    subradialText.append(spellSubradialListEntryTemplate.replaceAll("~~~Icon~~~", subradial.e2)
                            .replaceAll("~~~SubradialName~~~", subradial.e1));
                }
                subradialText = new StringBuilder(spellSubradialListTemplate.replaceAll("~~~EntryList~~~", subradialText.toString()));
            }
            text = text.replaceAll("~~~SubradialNames~~~", subradialText.toString());

            // Print the page
            try {
                printPage(spell.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for spell " + spell.entryNum + ": " + spell.name + ":\n" + e);
            }
        }
        // Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
        // hits the memory limit
        System.gc();
    }

    /**
     * A simple method for printing out all the feat pages.
     */
    public static void printFeats() {
        // Print feats
        printFeatsAux();

        // Print masterfeats
        printMasterFeatsAux();

        // Print a page with alphabetically sorted list of all feats
        printPage(contentPath + "feats" + fileSeparator + "alphasortedfeats.html", buildAllFeatsList(false));

        // Print a page with alphabetically sorted list of all epic feats
        printPage(contentPath + "epic_feats" + fileSeparator + "alphasortedepicfeats.html", buildAllFeatsList(true));
    }


    /**
     * Prints the masterfeat pages.
     */
    private static void printMasterFeatsAux() {
        String text = null,
                temp = null;

        for (FeatEntry masterfeat : masterFeats.values()) {
            if (verbose) System.out.println("Printing page for " + masterfeat.name);
            // Build the entry data
            text = mFeatTemplate;
            text = text.replaceAll("~~~FeatName~~~",
                    masterfeat.name);
            text = text.replaceAll("~~~FeatTLKDescription~~~",
                    masterfeat.text);
            // Add in the icon
            text = text.replaceAll("~~~Icon~~~", masterfeat.iconPath);

            // Add in child feats
            temp = "";
            for (FeatEntry child : masterfeat.childFeats.values()) {
                temp += pageLinkTemplate.replace("~~~Path~~~", child.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                        .replace("~~~Name~~~", child.name);
            }
            text = text.replaceAll("~~~MasterFeatChildList~~~", temp);

            // Print the page
            try {
                printPage(masterfeat.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for masterfeat " + masterfeat.entryNum + ": " + masterfeat.name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Prints the feat pages.
     */
    private static void printFeatsAux() {
        String text = null,
                temp = null;
        StringBuilder subradialText = null;

        for (FeatEntry feat : feats.values()) {
            if (verbose) System.out.println("Printing page for " + feat.name);
            // Build the entry data
            text = featTemplate;
            text = text.replaceAll("~~~FeatName~~~",
                    feat.name);
            text = text.replaceAll("~~~FeatTLKDescription~~~",
                    feat.text);
            // Add in the icon
            text = text.replaceAll("~~~Icon~~~", feat.iconPath);

            // Print prerequisites into the entry
            temp = "";
            if (feat.andRequirements.size() != 0) {
                temp += prereqANDFeatHeaderTemplate;
                for (FeatEntry andReq : feat.andRequirements.values())
                    temp += pageLinkTemplate.replace("~~~Path~~~", andReq.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", andReq.name);
            }
            if (feat.orRequirements.size() != 0) {
                temp += prereqORFeatHeaderTemplate;
                for (FeatEntry orReq : feat.orRequirements.values())
                    temp += pageLinkTemplate.replace("~~~Path~~~", orReq.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", orReq.name);
            }
            text = text.replaceAll("~~~PrerequisiteFeatList~~~", temp);

            // Print the successor, if any, into the entry
            temp = "";
            if (feat.successor != null) {
                temp += successorFeatHeaderTemplate + pageLinkTemplate.replace("~~~Path~~~", feat.successor.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                        .replace("~~~Name~~~", feat.successor.name);
            }
            text = text.replaceAll("~~~SuccessorFeat~~~", temp);

            // Handle subradials, if any
            subradialText = new StringBuilder();
            if (feat.subradials != null) {
                for (Tuple<String, String> subradial : feat.subradials) {
                    subradialText.append(spellSubradialListEntryTemplate.replaceAll("~~~Icon~~~", subradial.e2)
                            .replaceAll("~~~SubradialName~~~", subradial.e1));
                }
                subradialText = new StringBuilder(spellSubradialListTemplate.replaceAll("~~~EntryList~~~", subradialText.toString()));
            }
            text = text.replaceAll("~~~SubradialNames~~~", subradialText.toString());

            // Handle feats that have this as their prerequisite
            temp = "";
            if (feat.requiredForFeats.size() != 0) {
                temp += requiredForFeatHeaderTemplate;
                for (FeatEntry req : feat.requiredForFeats.values()) {
                    temp += pageLinkTemplate.replace("~~~Path~~~", req.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", req.name);
                }
            }
            text = text.replaceAll("~~~RequiredForFeatList~~~", temp);

            // Print the page
            try {
                printPage(feat.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for feat " + feat.entryNum + ": " + feat.name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Constructs an alphabetically sorted list of all (or only all epic) feats.
     *
     * @param epicOnly if <code>true</code>, only feats that are epic are placed in the list. Otherwise, all feats.
     * @return an html page containing the list
     */
    private static String buildAllFeatsList(boolean epicOnly) {
        TreeMap<String, FeatEntry> sorted = new TreeMap<String, FeatEntry>(String.CASE_INSENSITIVE_ORDER);
        for (FeatEntry entry : feats.values())
            if (!epicOnly || (epicOnly && entry.isEpic))
                sorted.put(entry.name, entry);
        String toReturn = alphaSortedListTemplate,
                entrySet;
        FeatEntry entry;
        char cha = (char) 0;
        int counter = 0;
        boolean addedAny;
        while (sorted.size() > 0) {
            // Build the list for a single letter
            entrySet = listEntrySetTemplate.replace("~~~LinkId~~~", new String(new char[]{cha}))
                    .replace("~~~EntrySetName~~~", new String(new char[]{cha}).toUpperCase());
            addedAny = false;
            while (sorted.size() > 0 &&
                    sorted.firstKey().toLowerCase().startsWith(new String(new char[]{cha}))) {
                addedAny = true;
                entry = sorted.remove(sorted.firstKey());

                entrySet = entrySet.replace("~~~FeatList~~~", listEntryTemplate.replace("~~~EvenOrOdd~~~", (counter++ % 2) == 0 ? "even" : "odd")
                        .replace("~~~EntryPath~~~",
                                entry.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                        .replace("~~~EntryName~~~", entry.name)
                        + "~~~FeatList~~~");
            }
            entrySet = entrySet.replace("~~~FeatList~~~", "");
            cha++;

            // Add the sublist to the page
            if (addedAny)
                toReturn = toReturn.replace("~~~Content~~~", entrySet + "\n" + "~~~Content~~~");
        }
        // Clear off the last replacement marker
        toReturn = toReturn.replace("~~~Content~~~", "");

        return toReturn;
    }


    /**
     * Handles creation of the domain pages.
     */
    public static void printDomains() {
        String text = null;
        StringBuffer spellList = null;

        for (DomainEntry domain : domains.values()) {
            if (verbose) System.out.println("Printing page for " + domain.name);
            // Build the entry data
            text = domainTemplate;
            text = text.replaceAll("~~~DomainName~~~",
                    domain.name);
            text = text.replaceAll("~~~DomainTLKDescription~~~",
                    domain.text);
            // Add in the icon
            text = text.replaceAll("~~~Icon~~~", domain.iconPath);

            // Add a link to the granted feat
            text = text.replaceAll("~~~DomainFeat~~~",
                    pageLinkTemplate.replace("~~~Path~~~", domain.grantedFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", domain.grantedFeat.name));

            // Add links to the granted spells
            spellList = new StringBuffer();
            for (SpellEntry grantedSpell : domain.spells) {
                spellList.append(pageLinkTemplate.replace("~~~Path~~~", grantedSpell.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                        .replace("~~~Name~~~", grantedSpell.name));
            }
            text = text.replaceAll("~~~DomainSpellList~~~", spellList.toString());

            // Print the page
            try {
                printPage(domain.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for domain " + domain.entryNum + ": " + domain.name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Handles creation of the race pages.
     */
    public static void printRaces() {
        String text = null;
        StringBuffer featList = null;

        for (RaceEntry race : races.values()) {
            if (verbose) System.out.println("Printing page for " + race.name);
            // Build the entry data
            text = raceTemplate;
            text = text.replaceAll("~~~RaceName~~~",
                    race.name);
            text = text.replaceAll("~~~RaceTLKDescription~~~",
                    race.text);

            // Add links to the racial feats
            featList = new StringBuffer();
            for (FeatEntry grantedFeat : race.raceFeats.values()) {
                featList.append(pageLinkTemplate.replace("~~~Path~~~", grantedFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                        .replace("~~~Name~~~", grantedFeat.name));
            }
            text = text.replaceAll("~~~RaceFeats~~~", featList.toString());

            // Print the page
            try {
                printPage(race.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for race " + race.entryNum + ": " + race.name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Handles creation of the class pages.
     * Subsections handled by several following methods.
     */
    public static void printClasses() {
        String text = null,
                temp = null;
        String[] tempArr = null;

        for (ClassEntry class_ : classes.values()) {
            if (verbose) System.out.println("Printing page for " + class_.name);
            // Build the entry data
            text = classTemplate;
            text = text.replaceAll("~~~ClassName~~~",
                    class_.name);
            text = text.replaceAll("~~~ClassTLKDescription~~~",
                    class_.text);
            // Add in the icon
            text = text.replaceAll("~~~Icon~~~", class_.iconPath);

            // Add in the BAB and saving throws table
            text = text.replaceAll("~~~ClassBABAndSavThrTable~~~", buildBabAndSaveTable(class_));

            // Add in the skills table
            text = text.replaceAll("~~~ClassSkillTable~~~", buildSkillTable(class_));

            // Add in the feat table
            text = text.replaceAll("~~~ClassFeatTable~~~", buildClassFeatTables(class_));

            // Add in the spells / powers table
            text = text.replaceAll("~~~ClassSpellAndPowerTables~~~", buildClassSpellAndPowerTables(class_));


            // Print the page
            try {
                printPage(class_.filePath, text);
            } catch (PageGenerationException e) {
                err_pr.println("Error: Exception when writing page for class " + class_.entryNum + ": " + class_.name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Constructs the html table of levels and their bab + saving throw bonus values.
     *
     * @param class_ The class entry data structure of the class to generate the table for
     * @return string representation of the table
     */
    private static String buildBabAndSaveTable(ClassEntry class_) {
        String toReturn = "";
        if (class_.babSav.size() != 0) {
            toReturn += babAndSavthrTableHeaderTemplate + "\n";
            // Start building the table
            for (int i = 0; i < class_.babSav.size(); i++) {
                toReturn += "<tr>\n";
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", (i + 1) + "");
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", class_.babSav.get(i)[0]);
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", class_.babSav.get(i)[1]);
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", class_.babSav.get(i)[2]);
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", class_.babSav.get(i)[3]);
                toReturn += "</tr>\n";
            }
            toReturn += "</table>\n";
        }

        return toReturn;
    }

    /**
     * Constructs the html table of the class & cross-class skills of this class.
     * TreeMaps are used to arrange the printed skills in alphabetic order.
     *
     * @param class_ The class entry data structure of the class to generate the table for
     * @return string representation of the table
     */
    private static String buildSkillTable(ClassEntry class_) {
        String toReturn = skillTableHeaderTemplate;
        GenericEntry tempSkill = null;
        // Clone the maps, since we'll be performing destructive operations on them
        TreeMap<String, GenericEntry> classSkills = new TreeMap<String, GenericEntry>(class_.skillList.e1),
                crossClassSkills = new TreeMap<String, GenericEntry>(class_.skillList.e2);

        while (classSkills.size() > 0 || crossClassSkills.size() > 0) {
            toReturn += "<tr>\n";

            if (classSkills.size() > 0) {
                tempSkill = classSkills.remove(classSkills.firstKey());
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempSkill.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempSkill.name + "</a>");
            } else
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");

            if (crossClassSkills.size() > 0) {
                tempSkill = crossClassSkills.remove(crossClassSkills.firstKey());
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempSkill.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempSkill.name + "</a>");
            } else
                toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");

            toReturn += "</tr>\n";
        }

        toReturn += "</table>\n";
        return toReturn;
    }


    /**
     * Constructs the html table of the bonus and selectable class feats of the given class.
     * TreeMaps are used to arrange the printed feats in alphabetic order.
     *
     * @param class_ The class entry data structure of the class to generate the table for
     * @return String that contains the table
     */
    private static String buildClassFeatTables(ClassEntry class_) {
        List<TreeMap<String, FeatEntry>> grantedFeatList = class_.featList.e2.e1,
                selectableFeatList = class_.featList.e2.e2;
        List<Integer> bonusFeatCounts = class_.featList.e1;

        // Start constructing the table
        StringBuffer tableText = new StringBuffer();
        StringBuffer linkList = null;
        String tableLine = null;
        for (int i = 0; i < grantedFeatList.size(); i++) {
            tableLine = classFeatTableEntryTemplate.replace("~~~Level~~~", String.valueOf(i + 1))
                    .replace("~~~NumberOfBonusFeats~~~", bonusFeatCounts.get(i).toString());
            // Generate the granted feats list
            linkList = new StringBuffer();
            if (grantedFeatList.get(i) != null)
                for (FeatEntry feat : grantedFeatList.get(i).values()) {
                    linkList.append(pageLinkTemplate.replace("~~~Path~~~", feat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", feat.name));
                }
            else
                linkList.append("&nbsp;");
            tableLine = tableLine.replace("~~~FeatsGrantedList~~~", linkList.toString());

            // Generate the granted feats list
            linkList = new StringBuffer();
            if (selectableFeatList.get(i) != null)
                for (FeatEntry feat : selectableFeatList.get(i).values()) {
                    linkList.append(pageLinkTemplate.replace("~~~Path~~~", feat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", feat.name));
                }
            else
                linkList.append("&nbsp;");
            tableLine = tableLine.replace("~~~SelectableFeatsList~~~", linkList.toString());

            // Append the line to the table
            tableText.append(tableLine);
        }

        return classFeatTableTemplate.replace("~~~TableContents~~~", tableText.toString());
    }

    /**
     * Constructs the html table of the new spellbook spells and psionic powers lists of
     * the given class. The entries are ordered by spell / power level
     *
     * @param class_ The class entry data structure of the class to generate the table for
     * @return String that contains the table
     */
    private static String buildClassSpellAndPowerTables(ClassEntry class_) {
        StringBuffer toReturn = new StringBuffer();

        for (Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>> magicData : class_.magics) {
            // Map of level numbers to maps of spell names to html links. Cloned due to destructive operations
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists =
                    new TreeMap<Integer, TreeMap<String, SpellEntry>>(magicData.e2);

            StringBuffer tableLines = new StringBuffer(),
                    spellLinks;
            String tableLine;
            while (levelLists.size() > 0) {
                tableLine = classMagicTableEntryTemplate.replace("~~~Level~~~", levelLists.firstKey().toString());
                spellLinks = new StringBuffer();
                for (SpellEntry spell : levelLists.remove(levelLists.firstKey()).values())
                    spellLinks.append(pageLinkTemplate.replace("~~~Path~~~", spell.filePath.replace(contentPath, "../").replaceAll("\\\\", "/"))
                            .replace("~~~Name~~~", spell.name));
                tableLines.append(tableLine.replace("~~~EntryList~~~", spellLinks.toString()));
            }

            toReturn.append(classMagicTableTemplate.replace("~~~TableName~~~", magicData.e1.e1)
                    .replace("~~~Type~~~", magicData.e1.e2)
                    .replace("~~~TableContents~~~", tableLines.toString()));
        }

        return toReturn.toString();
    }
}