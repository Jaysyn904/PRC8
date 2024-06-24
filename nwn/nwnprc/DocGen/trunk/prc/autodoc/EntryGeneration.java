package prc.autodoc;

import java.io.*;
import java.util.*;

import prc.autodoc.Main.SpellType;
//import java.util.regex.*;

/* Static import in order to let me use the enum constants in switches */
import static prc.autodoc.Main.SpellType.*;

import static prc.Main.*;
import static prc.autodoc.Main.*;

/**
 * This class contains the methods for generation of the raw manual page contents.
 *
 * @author Ornedan
 */
public class EntryGeneration {
    /**
     * Handles creation of the skill pages.
     */
    public static void doSkills() {
        String skillPath = contentPath + "skills" + fileSeparator;
        String name = null,
                text = null,
                path = null,
                icon = null;
        boolean errored;

        skills = new HashMap<Integer, GenericEntry>();
        Data_2da skills2da = twoDA.get("skills");

        for (int i = 0; i < skills2da.getEntryCount(); i++) {
            errored = false;
            // Get the name of the skill and check if it's valid
            name = tlk.get(skills2da.getEntry("Name", i));
            if (verbose) System.out.println("Generating entry data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for skill " + i);
                errored = true;
            }

            // Same for description
            text = htmlizeTLK(tlk.get(skills2da.getEntry("Description", i)));
            // Again, check if we had a valid description
            if (tlk.get(skills2da.getEntry("Description", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for skill " + i + ": " + name);
                errored = true;
            }

            // And icon
            icon = skills2da.getEntry("Icon", i);
            if (icon.equals("****")) {
                err_pr.println("Error: Icon not defined for skill " + i + ": " + name);
                errored = true;
            }
            icon = Icons.buildIcon(icon);

            // Build the final path
            path = skillPath + i + ".html";

            // Check if we had any errors. If we did, and the error tolerance flag isn't up, skip generating this entry
            if (!errored || tolErr) {
                // Store a data structure represeting the skill into a hashmap
                skills.put(i, new GenericEntry(name, text, icon, path, i));
            } else
                err_pr.println("Error: Failed to generate entry for skill " + i + ": " + name);
        }
        // Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
        // hits the memory limit
        System.gc();
    }

    /**
     * Handles creation of the crafting itemprop pages.
     */
    public static void doCrafting() {
        String craftPath = contentPath + "itemcrafting" + fileSeparator;

        String name = null,
                text = null,
                path = null,
                icon = null;
        boolean errored;

        craft_armour = new HashMap<Integer, GenericEntry>();
        craft_weapon = new HashMap<Integer, GenericEntry>();
        craft_ring = new HashMap<Integer, GenericEntry>();
        craft_wondrous = new HashMap<Integer, GenericEntry>();
        Data_2da craft_armour_2da = twoDA.get("craft_armour");
        Data_2da craft_weapon_2da = twoDA.get("craft_weapon");
        Data_2da craft_ring_2da = twoDA.get("craft_ring");
        Data_2da craft_wondrous_2da = twoDA.get("craft_wondrous");

        icon = "";

        for (int i = 0; i < craft_armour_2da.getEntryCount(); i++) {
            errored = false;
            // Get the name of the skill and check if it's valid
            name = tlk.get(craft_armour_2da.getEntry("Name", i));
            if (verbose) System.out.println("Generating entry data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for property " + i);
                errored = true;
            }

            // Same for description
            text = htmlizeTLK(tlk.get(craft_armour_2da.getEntry("Description", i)));
            // Again, check if we had a valid description
            if (tlk.get(craft_armour_2da.getEntry("Description", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for property " + i + ": " + name);
                errored = true;
            }

            // Build the final path
            path = craftPath + "armour" + i + ".html";

            // Check if we had any errors. If we did, and the error tolerance flag isn't up, skip generating this entry
            if (!errored || tolErr) {
                // Store a data structure represeting the skill into a hashmap
                craft_armour.put(i, new GenericEntry(name, text, icon, path, i));
            } else
                err_pr.println("Error: Failed to generate entry for property " + i + ": " + name);
        }

        for (int i = 0; i < craft_weapon_2da.getEntryCount(); i++) {
            errored = false;
            // Get the name of the skill and check if it's valid
            name = tlk.get(craft_weapon_2da.getEntry("Name", i));
            if (verbose) System.out.println("Generating entry data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for property " + i);
                errored = true;
            }

            // Same for description
            text = htmlizeTLK(tlk.get(craft_weapon_2da.getEntry("Description", i)));
            // Again, check if we had a valid description
            if (tlk.get(craft_weapon_2da.getEntry("Description", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for property " + i + ": " + name);
                errored = true;
            }

            // Build the final path
            path = craftPath + "weapon" + i + ".html";

            // Check if we had any errors. If we did, and the error tolerance flag isn't up, skip generating this entry
            if (!errored || tolErr) {
                // Store a data structure represeting the skill into a hashmap
                craft_weapon.put(i, new GenericEntry(name, text, icon, path, i));
            } else
                err_pr.println("Error: Failed to generate entry for property " + i + ": " + name);
        }

        for (int i = 0; i < craft_ring_2da.getEntryCount(); i++) {
            errored = false;
            // Get the name of the skill and check if it's valid
            name = tlk.get(craft_ring_2da.getEntry("Name", i));
            if (verbose) System.out.println("Generating entry data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for property " + i);
                errored = true;
            }

            // Same for description
            text = htmlizeTLK(tlk.get(craft_ring_2da.getEntry("Description", i)));
            // Again, check if we had a valid description
            if (tlk.get(craft_ring_2da.getEntry("Description", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for property " + i + ": " + name);
                errored = true;
            }

            // Build the final path
            path = craftPath + "ring" + i + ".html";

            // Check if we had any errors. If we did, and the error tolerance flag isn't up, skip generating this entry
            if (!errored || tolErr) {
                // Store a data structure represeting the skill into a hashmap
                craft_ring.put(i, new GenericEntry(name, text, icon, path, i));
            } else
                err_pr.println("Error: Failed to generate entry for property " + i + ": " + name);
        }

        for (int i = 0; i < craft_wondrous_2da.getEntryCount(); i++) {
            errored = false;
            // Get the name of the skill and check if it's valid
            name = tlk.get(craft_wondrous_2da.getEntry("Name", i));
            if (verbose) System.out.println("Generating entry data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for property " + i);
                errored = true;
            }

            // Same for description
            text = htmlizeTLK(tlk.get(craft_wondrous_2da.getEntry("Description", i)));
            // Again, check if we had a valid description
            if (tlk.get(craft_wondrous_2da.getEntry("Description", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for property " + i + ": " + name);
                errored = true;
            }

            // Build the final path
            path = craftPath + "wondrous" + i + ".html";

            // Check if we had any errors. If we did, and the error tolerance flag isn't up, skip generating this entry
            if (!errored || tolErr) {
                // Store a data structure represeting the skill into a hashmap
                craft_wondrous.put(i, new GenericEntry(name, text, icon, path, i));
            } else
                err_pr.println("Error: Failed to generate entry for property " + i + ": " + name);
        }
        // Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
        // hits the memory limit
        System.gc();
    }

    /**
     * Prints normal & epic spells and psionic powers.
     * As of now, all of these are similar enough to share the same
     * template, so they can be done here together.
     * <p>
     * The enumeration class used here is found at the end of the file
     */
    public static void doSpells() {
        String spellPath = contentPath + "spells" + fileSeparator,
                epicPath = contentPath + "epic_spells" + fileSeparator,
                psiPath = contentPath + "psionic_powers" + fileSeparator,
                utterPath = contentPath + "utterances" + fileSeparator,
                invocPath = contentPath + "invocations" + fileSeparator,
                manPath = contentPath + "maneuvers" + fileSeparator;

        String path = null,
                name = null,
                text = null,
                icon = null,
                subradName = null,
                subradIcon = null;
        List<Tuple<String, String>> subradials = null;
        boolean errored;
        int subRadial;

        SpellType spelltype = NONE;

        spells = new HashMap<Integer, SpellEntry>();
        Data_2da spells2da = twoDA.get("spells");

        for (int i = 0; i < spells2da.getEntryCount(); i++) {
            spelltype = NONE;
            errored = false;

            if (isNormalSpell(spells2da, i)) spelltype = NORMAL;
            else if (isEpicSpell(spells2da, i)) spelltype = EPIC;
            else if (isPsionicPower(spells2da, i)) spelltype = PSIONIC;
            else if (isTruenameUtterance(spells2da, i)) spelltype = UTTERANCE;
            else if (isInvocation(spells2da, i)) spelltype = INVOCATION;
            else if (isManeuver(spells2da, i)) spelltype = MANEUVER;

            if (spelltype != NONE) {
                name = tlk.get(spells2da.getEntry("Name", i))
                        .replaceAll("/", " / "); // Let the UA insert line breaks if necessary
                if (verbose) System.out.println("Generating entry data for " + name);
                // Check the name for validity
                if (name.equals(badStrRef)) {
                    err_pr.println("Error: Invalid name for spell " + i);
                    errored = true;
                }

                // Handle the contents
                text = htmlizeTLK(tlk.get(spells2da.getEntry("SpellDesc", i)));
                // Check the description validity
                if (tlk.get(spells2da.getEntry("SpellDesc", i)).equals(badStrRef)) {
                    err_pr.println("Error: Invalid description for spell " + i + ": " + name);
                    errored = true;
                }

                // Do the icon
                icon = spells2da.getEntry("IconResRef", i);
                if (icon.equals("****")) {
                    err_pr.println("Error: Icon not defined for spell " + i + ": " + name);
                    errored = true;
                }
                icon = Icons.buildIcon(icon);

                // Handle subradials, if any
                subradials = null;
                // Assume that if there are any, the first slot is always non-****
                if (!spells2da.getEntry("SubRadSpell1", i).equals("****")) {
                    subradials = new ArrayList<Tuple<String, String>>(5);
                    for (int j = 1; j <= 5; j++) {
                        // Also assume that all the valid entries are in order, such that if Nth SubRadSpell entry
                        // is ****, all > N are also ****
                        if (spells2da.getEntry("SubRadSpell" + j, i).equals("****"))
                            break;
                        try {
                            subRadial = Integer.parseInt(spells2da.getEntry("SubRadSpell" + j, i));

                            // Try name
                            subradName = tlk.get(spells2da.getEntry("Name", subRadial))
                                    .replaceAll("/", " / ");
                            // Check the name for validity
                            if (subradName.equals(badStrRef)) {
                                err_pr.println("Error: Invalid Name entry for spell " + subRadial);
                                errored = true;
                            }

                            // Try icon
                            subradIcon = spells2da.getEntry("IconResRef", subRadial);
                            if (subradIcon.equals("****")) {
                                err_pr.println("Error: Icon not defined for spell " + subRadial + ": " + subradName);
                                errored = true;
                            }

                            // Build list
                            subradials.add(new Tuple<String, String>(subradName, Icons.buildIcon(subradIcon)));
                        } catch (NumberFormatException e) {
                            err_pr.println("Error: Spell " + i + ": " + name + " contains an invalid SubRadSpell" + j + " entry");
                            errored = true;
                        }
                    }
                }

                // Build the path
                switch (spelltype) {
                    case NORMAL:
                        path = spellPath + i + ".html";
                        break;
                    case EPIC:
                        path = epicPath + i + ".html";
                        break;
                    case PSIONIC:
                        path = psiPath + i + ".html";
                        break;
                    case UTTERANCE:
                        path = utterPath + i + ".html";
                        break;
                    case INVOCATION:
                        path = invocPath + i + ".html";
                        break;
                    case MANEUVER:
                        path = manPath + i + ".html";
                        break;

                    default:
                        throw new AssertionError("Unhandled spelltype: " + spelltype);
                }

                // Check if we had any errors. If we did, and the error tolerance flag isn't up, skip generating this entry
                if (!errored || tolErr) {
                    // Store a data structure represeting the entry into a hashmap
                    spells.put(i, new SpellEntry(name, text, icon, path, i, spelltype, subradials));
                } else
                    err_pr.println("Error: Failed to generate entry for spell " + i + ": " + name);
            }
        }
        System.gc();
    }

    /**
     * Creates a list of spells.2da rows that should contain a psionic power's class-specific
     * entry.
     */
    public static void listPsionicPowers(TwoDAStore twoDA) {
        // A map of power name to class-specific spells.2da entry
        psiPowMap = new HashMap<String, Integer>();

        HashMap<String, Data_2da> potentials = twoDA.findAll("cls_psipw_");

        listAMSEntries(potentials, psiPowMap);
    }

    /**
     * Creates a list of spells.2da rows that should contain a truenaming utterance's
     */
    public static void listTruenameUtterances(TwoDAStore twoDA) {
        // A map of power name to class-specific spells.2da entry
        utterMap = new HashMap<String, Integer>();

        // Load cls_*_utter.2da
        HashMap<String, Data_2da> potentials = twoDA.findAll("_utter");

        listAMSEntries(potentials, utterMap);
    }

    /**
     * Creates a list of spells.2da rows that should contain invocations
     */
    public static void listInvocations(TwoDAStore twoDA) {
        // A map of power name to class-specific spells.2da entry
        invMap = new HashMap<String, Integer>();

        var potentials = twoDA.findAll("cls_inv_");

        listAMSEntries(potentials, invMap);
    }

    /**
     * Creates a list of spells.2da rows that should contain maneuvers
     */
    public static void listManeuvers(TwoDAStore twoDA) {
        // A map of power name to class-specific spells.2da entry
        maneuverMap = new HashMap<String, Integer>();

        var potentials = twoDA.findAll("cls_move_");

        listAMSEntries(potentials, maneuverMap);
    }

    /**
     * Does the actual list generation for listPsionicPowers() and
     * listTruenameUtterances().
     *
     * @param fileNames List of 2da files that contain the entries to be listed
     * @param storeMap  Map to store the entries in
     */
    private static void listAMSEntries(HashMap<String, Data_2da> list2das, Map<String, Integer> storeMap) {
        Data_2da spells2da   = twoDA.get("spells");
        // Parse the 2das
        list2das.entrySet().stream().forEach(
                list2da -> {
            var value2da = list2da.getValue();
            for (int i = 0; i < value2da.getEntryCount(); i++) {
                // Column FeatID is used to determine if the row specifies the main entry of a power
                if (!value2da.getEntry("FeatID", i).equals("****")) {
                    try {
                        //look up spells.2da name of the realspellid if we don't have a name column
                        if (value2da.getEntry("Name", i) == null) {
                            storeMap.put(tlk.get(spells2da.getEntry("Name", value2da.getEntry("RealSpellID", i))), Integer.parseInt(value2da.getEntry("RealSpellID", i)));
                        } else {
                            storeMap.put(tlk.get(value2da.getEntry("Name", i)), Integer.parseInt(value2da.getEntry("SpellID", i)));
                        }
                    } catch (NumberFormatException e) {
                        err_pr.println("Error: Invalid SpellID entry in " + value2da.getName() + ", line " + i);
                    }
                }
            }
        });
    }

    /**
     * A small convenience method for wrapping all the normal spell checks into
     * one.
     *
     * @param spells2da the Data_2da entry containing spells.2da
     * @param entryNum  the line number to use for testing
     * @return <code>true</code> if any of the class spell level columns contain a number,
     * <code>false</code> otherwise
     */
    private static boolean isNormalSpell(Data_2da spells2da, int entryNum) {
        if (!spells2da.getEntry("Bard", entryNum).equals("****")) return true;
        if (!spells2da.getEntry("Cleric", entryNum).equals("****")) return true;
        if (!spells2da.getEntry("Druid", entryNum).equals("****")) return true;
        if (!spells2da.getEntry("Paladin", entryNum).equals("****")) return true;
        if (!spells2da.getEntry("Ranger", entryNum).equals("****")) return true;
        if (!spells2da.getEntry("Wiz_Sorc", entryNum).equals("****")) return true;

        return false;
    }


    /**
     * A small convenience method for testing if the given entry contains a
     * epic spell.
     *
     * @param spells2da the Data_2da entry containing spells.2da
     * @param entryNum  the line number to use for testing
     * @return <code>true</code> if the impactscript name starts with strings specified in settings,
     * <code>false</code> otherwise
     */
    private static boolean isEpicSpell(Data_2da spells2da, int entryNum) {
        for (String check : settings.epicspellSignatures)
            if (spells2da.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
        return false;
    }

    /**
     * A small convenience method for testing if the given entry contains a
     * psionic power. This is determined by whether the power's id is
     * in the psiPowMap Map.
     *
     * @param spells2da the Data_2da entry containing spells.2da
     * @param entryNum  the line number to use for testing
     * @return <code>true</code> if entryNum in spells2da contains a psionic power,
     * <code>false</code> otherwise
     */
    private static boolean isPsionicPower(Data_2da spells2da, int entryNum) {
        return psiPowMap.containsValue(entryNum);
    }

    /**
     * A small convenience method for testing if the given entry contains a
     * truenaming utterance. This is determined by whether the power's id is
     * in the utterMap Map.
     *
     * @param spells2da the Data_2da entry containing spells.2da
     * @param entryNum  the line number to use for testing
     * @return <code>true</code> if entryNum in spells2da contains an utterance,
     * <code>false</code> otherwise
     */
    private static boolean isTruenameUtterance(Data_2da spells2da, int entryNum) {
        return utterMap.containsValue(entryNum);
    }

    /**
     * A small convenience method for testing if the given entry contains an
     * invocation. This is determined by whether the power's id is
     * in the utterMap Map.
     *
     * @param spells2da the Data_2da entry containing spells.2da
     * @param entryNum  the line number to use for testing
     * @return <code>true</code> if entryNum in spells2da contains an utterance,
     * <code>false</code> otherwise
     */
    private static boolean isInvocation(Data_2da spells2da, int entryNum) {
        return invMap.containsValue(entryNum);
    }

    /**
     * A small convenience method for testing if the given entry contains a
     * maneuver. This is determined by whether the power's id is
     * in the utterMap Map.
     *
     * @param spells2da the Data_2da entry containing spells.2da
     * @param entryNum  the line number to use for testing
     * @return <code>true</code> if entryNum in spells2da contains an utterance,
     * <code>false</code> otherwise
     */
    private static boolean isManeuver(Data_2da spells2da, int entryNum) {
        return maneuverMap.containsValue(entryNum);
    }


    /**
     * Build the preliminary list of master feats, without the child feats
     * linked in.
     */
    public static void preliMasterFeats() {
        String mFeatPath = contentPath + "master_feats" + fileSeparator;
        String name = null,
                text = null,
                path = null;
        FeatEntry entry = null;
        boolean errored;

        masterFeats = new HashMap<Integer, FeatEntry>();
        Data_2da masterFeats2da = twoDA.get("masterfeats");

        for (int i = 0; i < masterFeats2da.getEntryCount(); i++) {
            // Skip blank rows
            if (masterFeats2da.getEntry("LABEL", i).equals("****")) continue;
            errored = false;

            // Get the name and validate it
            name = tlk.get(masterFeats2da.getEntry("STRREF", i));
            if (verbose) System.out.println("Generating preliminary data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for masterfeat " + i);
                errored = true;
            }

            // Build the entry data
            text = htmlizeTLK(tlk.get(masterFeats2da.getEntry("DESCRIPTION", i)));
            // Check the description validity
            if (tlk.get(masterFeats2da.getEntry("DESCRIPTION", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for masterfeat " + i + ": " + name);
                errored = true;
            }

            // Add in the icon
            String icon = masterFeats2da.getEntry("ICON", i);
            if (icon.equals("****")) {
                err_pr.println("Error: Icon not defined for masterfeat " + i + ": " + name);
                errored = true;
            }
            icon = Icons.buildIcon(icon);

            // Build the path
            path = mFeatPath + i + ".html";

            if (!errored || tolErr) {
                // Store the entry to wait for further processing
                // Masterfeats start as class feats and are converted into general feats if any child
                // is a general feat
                entry = new FeatEntry(name, text, icon, path, i, false, true, null);
                masterFeats.put(i, entry);
            } else
                err_pr.println("Error: Failed to generate entry data for masterfeat " + i + ": " + name);
        }
        System.gc();
    }


    /**
     * Build the preliminary list of feats, without master / successor / predecessor feats
     * linked in.
     */
    public static void preliFeats() {
        String featPath = contentPath + "feats" + fileSeparator,
                epicPath = contentPath + "epic_feats" + fileSeparator,
                classFeatPath = contentPath + "class_feats" + fileSeparator,
                classEpicPath = contentPath + "class_epic_feats" + fileSeparator;
        String name = null,
                text = null,
                icon = null,
                path = null,
                subradName = null,
                subradIcon = null;
        FeatEntry entry = null;
        List<Tuple<String, String>> subradials = null;
        boolean isEpic = false,
                isClassFeat = false;
        boolean errored;
        int featSpell,
                subRadial;

        feats = new HashMap<Integer, FeatEntry>();
        Data_2da feats2da = twoDA.get("feat");
        Data_2da spells2da = twoDA.get("spells");

        for (int i = 0; i < feats2da.getEntryCount(); i++) {
            // Skip blank rows and markers
            if (feats2da.getEntry("LABEL", i).equals("****") ||
                    feats2da.getEntry("FEAT", i).equals("****"))
                continue;
            // Skip the ISC & Epic spell markers
            if (feats2da.getEntry("LABEL", i).equals("ReservedForISCAndESS")) continue;
            errored = false;

            // Get the name and validate it
            name = tlk.get(feats2da.getEntry("FEAT", i));
            if (verbose) System.out.println("Generating preliminary data for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for feat " + i);
                errored = true;
            }

            // Build the entry data
            text = htmlizeTLK(tlk.get(feats2da.getEntry("DESCRIPTION", i)));
            // Check the description validity
            if (tlk.get(feats2da.getEntry("DESCRIPTION", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for feat " + i + ": " + name);
                errored = true;
            }
            // Add in the icon
            icon = feats2da.getEntry("ICON", i);
            if (icon.equals("****")) {
                err_pr.println("Error: Icon not defined for feat " + i + ": " + name);
                errored = true;
            }
            icon = Icons.buildIcon(icon);

            // Handle subradials, if any
            subradials = null;
            if (!feats2da.getEntry("SPELLID", i).equals("****")) {
                try {
                    featSpell = Integer.parseInt(feats2da.getEntry("SPELLID", i));
                    // Assume that if there are any, the first slot is always non-****
                    if (!spells2da.getEntry("SubRadSpell1", featSpell).equals("****")) {
                        subradials = new ArrayList<Tuple<String, String>>(5);
                        for (int j = 1; j <= 5; j++) {
                            // Also assume that all the valid entries are in order, such that if Nth SubRadSpell entry
                            // is ****, all > N are also ****
                            if (spells2da.getEntry("SubRadSpell" + j, featSpell).equals("****"))
                                break;
                            try {
                                subRadial = Integer.parseInt(spells2da.getEntry("SubRadSpell" + j, featSpell));

                                // Try name
                                subradName = tlk.get(spells2da.getEntry("Name", subRadial))
                                        .replaceAll("/", " / ");
                                // Check the name for validity
                                if (subradName.equals(badStrRef)) {
                                    err_pr.println("Error: Invalid Name entry for spell " + subRadial);
                                    errored = true;
                                }

                                // Try icon
                                subradIcon = spells2da.getEntry("IconResRef", subRadial);
                                if (subradIcon.equals("****")) {
                                    err_pr.println("Error: Icon not defined for spell " + subRadial + ": " + subradName);
                                    errored = true;
                                }

                                // Build list
                                subradials.add(new Tuple<String, String>(subradName, Icons.buildIcon(subradIcon)));
                            } catch (NumberFormatException e) {
                                err_pr.println("Error: Spell " + featSpell + ": " + name + " contains an invalid SubRadSpell" + j + " entry");
                                errored = true;
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Invalid SPELLID for feat " + i + ": " + name);
                    errored = true;
                }
            }

            // Classification
            isEpic = feats2da.getEntry("PreReqEpic", i).equals("1");
            isClassFeat = !feats2da.getEntry("ALLCLASSESCANUSE", i).equals("1");

            // Get the path
            if (isEpic) {
                if (isClassFeat) path = classEpicPath + i + ".html";
                else path = epicPath + i + ".html";
            } else {
                if (isClassFeat) path = classFeatPath + i + ".html";
                else path = featPath + i + ".html";
            }

            if (!errored || tolErr) {
                // Create the entry data structure
                entry = new FeatEntry(name, text, icon, path, i, isEpic, isClassFeat, subradials);
                // Store the entry to wait for further processing
                feats.put(i, entry);
            } else
                err_pr.println("Error: Failed to generate entry data for feat " + i + ": " + name);
        }
        System.gc();
    }


    /**
     * Builds the master - child, predecessor - successor and prerequisite links
     * and modifies the entry texts accordingly.
     */
    public static void linkFeats() {
        FeatEntry other = null;
        Data_2da feats2da = twoDA.get("feat");
        boolean allChildrenEpic, allChildrenClassFeat;

        // Link normal feats to each other and to masterfeats
        for (FeatEntry check : feats.values()) {
            if (verbose) System.out.println("Linking feat " + check.name);
            // Link to master
            if (!feats2da.getEntry("MASTERFEAT", check.entryNum).equals("****")) {
                try {
                    other = masterFeats.get(Integer.parseInt(feats2da.getEntry("MASTERFEAT", check.entryNum)));
                    other.childFeats.put(check.name, check);
                    check.master = other;
                    if (check.isEpic) other.isEpic = true;
                    if (!check.isClassFeat) other.isClassFeat = false;
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " contains an invalid MASTERFEAT entry");
                } catch (NullPointerException e) {
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " MASTERFEAT points to a nonexistent masterfeat entry");
                }
            }

            // Handle prerequisites
            buildPrerequisites(check, feats2da);

            // Handle successor feat, if any
            if (!feats2da.getEntry("SUCCESSOR", check.entryNum).equals("****")) {
                try {
                    other = feats.get(Integer.parseInt(feats2da.getEntry("SUCCESSOR", check.entryNum)));
                    // Check for feats that have themselves as successor
                    if (other == check)
                        err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " has itself as successor");
                    other.isSuccessor = true;
                    check.successor = other;
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " contains an invalid SUCCESSOR entry");
                } catch (NullPointerException e) {
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " SUCCESSOR points to a nonexistent feat entry");
                }
            }
        }

        // Masterfeat categorisation
        for (FeatEntry check : masterFeats.values()) {
            if (verbose) System.out.println("Linking masterfeat " + check.name);
            allChildrenEpic = allChildrenClassFeat = true;
            for (FeatEntry child : check.childFeats.values()) {
                if (!child.isEpic) allChildrenEpic = false;
                if (!child.isClassFeat) allChildrenClassFeat = false;
            }

            check.allChildrenClassFeat = allChildrenClassFeat;
            check.allChildrenEpic = allChildrenEpic;
        }
        System.gc();
    }

    /**
     * Links a feat and it's prerequisites.
     * Separated from the linkFeats method for improved readability.
     *
     * @param check    the feat entry to be examined
     * @param feats2da the data structure representing feat.2da
     */
    private static void buildPrerequisites(FeatEntry check, Data_2da feats2da) {
        FeatEntry andReq1 = null, andReq2 = null, orReq = null;
        String andReq1Num = feats2da.getEntry("PREREQFEAT1", check.entryNum),
                andReq2Num = feats2da.getEntry("PREREQFEAT2", check.entryNum);
        String[] orReqs = {feats2da.getEntry("OrReqFeat0", check.entryNum),
                feats2da.getEntry("OrReqFeat1", check.entryNum),
                feats2da.getEntry("OrReqFeat2", check.entryNum),
                feats2da.getEntry("OrReqFeat3", check.entryNum),
                feats2da.getEntry("OrReqFeat4", check.entryNum)};

        /* Handle AND prerequisite feats */
        // Some paranoia about bad entries
        if (!andReq1Num.equals("****")) {
            try {
                andReq1 = feats.get(Integer.parseInt(andReq1Num));
                if (andReq1 == null)
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " PREREQFEAT1 points to a nonexistent feat entry");
                else if (andReq1 == check)
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " has itself as PREREQFEAT1");
            } catch (NumberFormatException e) {
                err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " contains an invalid PREREQFEAT1 entry");
            }
        }
        if (!andReq2Num.equals("****")) {
            try {
                andReq2 = feats.get(Integer.parseInt(andReq2Num));
                if (andReq2 == null)
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " PREREQFEAT2 points to a nonexistent feat entry");
                else if (andReq2 == check)
                    err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " has itself as PREREQFEAT2");
            } catch (NumberFormatException e) {
                err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " contains an invalid PREREQFEAT2 entry");
            }
        }

        // Check if we had at least one valid entry. If so, link
        if (andReq1 != null || andReq2 != null) {
            if (andReq1 != null) {
                check.andRequirements.put(andReq1.name, andReq1);
                andReq1.requiredForFeats.put(check.name, check);
            }
            if (andReq2 != null) {
                check.andRequirements.put(andReq2.name, andReq2);
                andReq2.requiredForFeats.put(check.name, check);
            }
        }


        /* Handle OR prerequisite feats */
        // First, check if there are any
        boolean hasOrReqs = false;
        for (String orReqCheck : orReqs)
            if (!orReqCheck.equals("****")) hasOrReqs = true;

        if (hasOrReqs) {
            // Loop through each req and see if it's a valid link
            for (int i = 0; i < orReqs.length; i++) {
                if (!orReqs[i].equals("****")) {
                    try {
                        orReq = feats.get(Integer.parseInt(orReqs[i]));
                    } catch (NumberFormatException e) {
                        err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " contains an invalid OrReqFeat" + i + " entry");
                    }
                    if (orReq != null) {
                        if (orReq == check)
                            err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " has itself as OrReqFeat" + i);
                        check.orRequirements.put(orReq.name, orReq);
                        orReq.requiredForFeats.put(check.name, check);
                    } else
                        err_pr.println("Error: Feat " + check.entryNum + ": " + check.name + " OrReqFeat" + i + " points to a nonexistent feat entry");
                }
            }
        }
    }


    /**
     * Handles creation of the domain pages.
     * Kills page generation on bad strref for name.
     * Other errors are logged and prevent page write
     */
    public static void doDomains() {
        String domainPath = contentPath + "domains" + fileSeparator;
        String name = null,
                text = null,
                icon = null,
                path = null;
        List<SpellEntry> spellList = null;
        FeatEntry grantedFeat = null;
        SpellEntry grantedSpell = null;
        boolean errored;

        domains = new HashMap<Integer, DomainEntry>();
        Data_2da domains2da = twoDA.get("domains");

        for (int i = 0; i < domains2da.getEntryCount(); i++) {
            // Skip blank rows
            if (domains2da.getEntry("LABEL", i).equals("****")) continue;
            errored = false;

            // Get the name and validate it
            name = tlk.get(domains2da.getEntry("Name", i));
            if (verbose) System.out.println("Printing page for " + name);
            if (name.equals(badStrRef)) {
                err_pr.println("Error: Invalid name for domain " + i);
                errored = true;
            }

            // Build the entry data
            text = htmlizeTLK(tlk.get(domains2da.getEntry("Description", i)));
            // Check the description validity
            if (tlk.get(domains2da.getEntry("Description", i)).equals(badStrRef)) {
                err_pr.println("Error: Invalid description for domain " + i + ": " + name);
                errored = true;
            }

            // Add in the icon
            icon = domains2da.getEntry("Icon", i);
            if (icon.equals("****")) {
                err_pr.println("Error: Icon not defined for domain " + i + ": " + name);
                errored = true;
            }
            icon = Icons.buildIcon(icon);

            // Add a link to the granted feat
            try {
                grantedFeat = feats.get(Integer.parseInt(domains2da.getEntry("GrantedFeat", i)));
            } catch (NumberFormatException e) {
                err_pr.println("Error: Invalid entry in GrantedFeat of domain " + i + ": " + name);
                errored = true;
            } catch (NullPointerException e) {
                err_pr.println("Error: GrantedFeat entry for domain " + i + ": " + name + " points to non-existent feat: " + domains2da.getEntry("GrantedFeat", i));
                errored = true;
            }

            // Add links to the granted spells
            spellList = new ArrayList<SpellEntry>();
            for (int j = 1; j <= 9; j++) {
                // Skip blanks
                if (domains2da.getEntry("Level_" + j, i).equals("****")) continue;
                try {
                    grantedSpell = spells.get(Integer.parseInt(domains2da.getEntry("Level_" + j, i)));
                    if (grantedSpell != null)
                        spellList.add(grantedSpell);
                    else {
                        err_pr.println("Error: Level_" + j + " entry for domain " + i + ": " + name + " points to non-existent spell: " + domains2da.getEntry("Level_" + j, i));
                        errored = true;
                    }
                } catch (NumberFormatException e) {
                    err_pr.println("Error: Invalid entry in Level_" + j + " of domain " + i + ": " + name);
                    errored = true;
                }
            }

            // Build path and print
            path = domainPath + i + ".html";
            if (!errored || tolErr) {
                domains.put(i, new DomainEntry(name, text, icon, path, i, grantedFeat, spellList));
            } else
                err_pr.println("Error: Failed to generate entry for domain " + i + ": " + name);
        }
        System.gc();
    }


    /**
     * Handles creation of the race pages.
     */
    public static void doRaces() {
        String racePath = contentPath + "races" + fileSeparator;
        String name = null,
                text = null,
                path = null;
        TreeMap<String, FeatEntry> featList = null;
        FeatEntry grantedFeat = null;
        Data_2da featTable = null;
        boolean errored;

        races = new HashMap<Integer, RaceEntry>();
        Data_2da racialtypes2da = twoDA.get("racialtypes");

        for (int i = 0; i < racialtypes2da.getEntryCount(); i++) {
            // Skip non-player races
            if (!racialtypes2da.getEntry("PlayerRace", i).equals("1")) continue;
            errored = false;
            try {
                // Get the name and validate it
                name = tlk.get(racialtypes2da.getEntry("Name", i));
                if (verbose) System.out.println("Printing page for " + name);
                if (name.equals(badStrRef)) {
                    err_pr.println("Error: Invalid name for race " + i);
                    errored = true;
                }

                // Build the entry data
                text = htmlizeTLK(tlk.get(racialtypes2da.getEntry("Description", i)));
                // Check the description validity
                if (tlk.get(racialtypes2da.getEntry("Description", i)).equals(badStrRef)) {
                    err_pr.println("Error: Invalid description for race " + i + ": " + name);
                    errored = true;
                }


                // Add links to the racial feats
                try {
                    featTable = twoDA.get(racialtypes2da.getEntry("FeatsTable", i));
                } catch (TwoDAReadException e) {
                    throw new PageGenerationException("Failed to read RACE_FEAT_*.2da for race " + i + ": " + name + ":\n" + e);
                }

                featList = new TreeMap<String, FeatEntry>();
                for (int j = 0; j < featTable.getEntryCount(); j++) {
                    try {
                        grantedFeat = feats.get(Integer.parseInt(featTable.getEntry("FeatIndex", j)));
                        featList.put(grantedFeat.name, grantedFeat);
                    } catch (NumberFormatException e) {
                        err_pr.println("Error: Invalid entry in FeatIndex line " + j + " of " + featTable.getName());
                        errored = true;
                    } catch (NullPointerException e) {
                        err_pr.println("Error: FeatIndex line " + j + " of " + featTable.getName() + " points to non-existent feat: " + featTable.getEntry("FeatIndex", j));
                        errored = true;
                    }
                }

                // Build path and print
                path = racePath + i + ".html";
                if (!errored || tolErr) {
                    races.put(i, new RaceEntry(name, text, path, i, featList));
                } else
                    throw new PageGenerationException("Error(s) encountered while creating page");
            } catch (PageGenerationException e) {
                err_pr.println("Error: Failed to print page for race " + i + ": " + name + ":\n" + e);
            }
        }
        System.gc();
    }


    /**
     * Handles creation of the class pages.
     * Subsections handled by several following methods.
     */
    public static void doClasses() {
        String baseClassPath = contentPath + "base_classes" + fileSeparator,
                prestigeClassPath = contentPath + "prestige_classes" + fileSeparator;
        String name = null,
                text = null,
                icon = null,
                path = null,
                temp = null;
        List<String[]> babSav = null;
        Tuple<TreeMap<String, GenericEntry>, TreeMap<String, GenericEntry>> skillList = null;
        Tuple<List<Integer>, Tuple<List<TreeMap<String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>> featList = null;
        List<Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>> magics = null;

        boolean errored;

        classes = new HashMap<Integer, ClassEntry>();
        Data_2da classes2da = twoDA.get("classes");

        for (int i = 0; i < classes2da.getEntryCount(); i++) {
            // Skip non-player classes
            if (!classes2da.getEntry("PlayerClass", i).equals("1")) continue;
            errored = false;
            try {
                name = tlk.get(classes2da.getEntry("Name", i));
                if (verbose) System.out.println("Printing page for " + name);
                if (name.equals(badStrRef)) {
                    err_pr.println("Error: Invalid name for class " + i);
                    errored = true;
                }

                // Build the entry data
                text = htmlizeTLK(tlk.get(classes2da.getEntry("Description", i)));
                // Check the description validity
                if (tlk.get(classes2da.getEntry("Description", i)).equals(badStrRef)) {
                    err_pr.println("Error: Invalid description for class " + i + ": " + name);
                    errored = true;
                }

                // Add in the icon
                icon = classes2da.getEntry("Icon", i);
                if (icon.equals("****")) {
                    err_pr.println("Error: Icon not defined for class " + i + ": " + name);
                    errored = true;
                }
                icon = Icons.buildIcon(icon);

                // Add in the BAB and saving throws table
                babSav = buildBabAndSaveList(classes2da, i);

                // Add in the skills table
                skillList = buildSkillList(classes2da, i);

                // Add in the feat table
                featList = buildClassFeatList(classes2da, i);

                // Add in the spells / powers table
                magics = buildClassMagicList(classes2da, i);

                /* Check whether this is a base or a prestige class. No prestige
                 * class should give exp penalty (nor should any base class not give it),
                 * so it gan be used as an indicator.
                 */
                temp = classes2da.getEntry("XPPenalty", i);
                if (!(temp.equals("0") || temp.equals("1"))) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid List XPPenalty in classes.2da on row " + i + ": " + temp);
                        continue;
                    } else
                        throw new PageGenerationException("Invalid XPPenalty entry in classes.2da on row " + i + ": " + temp);
                }
                if (temp.equals("1"))
                    path = baseClassPath + i + ".html";
                else
                    path = prestigeClassPath + i + ".html";

                if (!errored || tolErr) {
                    classes.put(i, new ClassEntry(name, text, icon, path, i, temp.equals("1"),
                            babSav, skillList, featList, magics));
                } else
                    throw new PageGenerationException("Error(s) encountered while creating page");
            } catch (PageGenerationException e) {
                err_pr.println("Error: Failed to print page for class " + i + ": " + name + ":\n" + e);
            }
        }
        System.gc();
    }

    /**
     * Constructs a list of arrays containing the BAB and saving throw values
     * for the given class.
     *
     * @param classes2da data structure wrapping classes.2da
     * @param entryNum   number of the entry to generate list for
     * @return List<String [ ]> containing the values. BAB first, then saving throws (Fort, Ref, Will).
     * @throws PageGenerationException if there is an error while generating the list and error tolerance is off
     */
    private static List<String[]> buildBabAndSaveList(Data_2da classes2da, int entryNum) {
        Data_2da babTable = null,
                saveTable = null;
        try {
            babTable = twoDA.get(classes2da.getEntry("AttackBonusTable", entryNum));
        } catch (TwoDAReadException e) {
            throw new PageGenerationException("Failed to read CLS_ATK_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
        }
        try {
            saveTable = twoDA.get(classes2da.getEntry("SavingThrowTable", entryNum));
        } catch (TwoDAReadException e) {
            throw new PageGenerationException("Failed to read CLS_SAVTHR_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
        }

        /* Determine maximum level to print bab & save values to
         * The maximum level of the class, or the last non-epic level
         * whichever is lower
         */
        int maxToPrint = 0, maxLevel = 0, epicLevel = 0;
        try {
            maxLevel = Integer.parseInt(classes2da.getEntry("MaxLevel", entryNum));
        } catch (NumberFormatException e) {
            if (tolErr)
                err_pr.println("Error: Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
            else
                throw new PageGenerationException("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
        }
        try {
            epicLevel = Integer.parseInt(classes2da.getEntry("EpicLevel", entryNum));
        } catch (NumberFormatException e) {
            if (tolErr)
                err_pr.println("Error: Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
            else
                throw new PageGenerationException("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
        }

        // base classes have special notation for the epic level limit
        if (epicLevel == -1)
            maxToPrint = 20;
        else
            maxToPrint = maxLevel > epicLevel ? epicLevel : maxLevel;

        // If the class has any pre-epic levels
        List<String[]> toReturn = new ArrayList<String[]>(maxToPrint);
        if (maxToPrint > 0) {
            // Start building the table
            for (int i = 0; i < maxToPrint; i++) {
                toReturn.add(new String[]{
                        babTable.getEntry("BAB", i),
                        saveTable.getEntry("FortSave", i),
                        saveTable.getEntry("RefSave", i),
                        saveTable.getEntry("WillSave", i)
                });
            }
        }

        return toReturn;
    }

    /**
     * Constructs a list of the class and cross-class skills of the
     * given class
     *
     * @param classes2da data structure wrapping classes.2da
     * @param entryNum   number of the entry to generate table for
     * @return Tuple<TreeMap < String, GenericEntry>, TreeMap<String, GenericEntry>>
     * containing the class and cross-class skills of the given class. The
     * first tuple member contains the class skills, the second cross-class.
     * The map key is the name of the skill.
     * @throws PageGenerationException if there is an error while generating the list and error tolerance is off
     */
    private static Tuple<TreeMap<String, GenericEntry>, TreeMap<String, GenericEntry>> buildSkillList(Data_2da classes2da, int entryNum) {
        Data_2da skillTable = null;
        try {
            skillTable = twoDA.get(classes2da.getEntry("SkillsTable", entryNum));
        } catch (TwoDAReadException e) {
            throw new PageGenerationException("Failed to read CLS_SKILL_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
        }

        Tuple<TreeMap<String, GenericEntry>, TreeMap<String, GenericEntry>> toReturn =
                new Tuple<TreeMap<String, GenericEntry>, TreeMap<String, GenericEntry>>(
                        new TreeMap<String, GenericEntry>(), new TreeMap<String, GenericEntry>());
        String skillNum = null;
        GenericEntry skillEntry = null;

        for (int i = 0; i < skillTable.getEntryCount(); i++) {
            skillNum = skillTable.getEntry("ClassSkill", i);
            // Yet more validity checking :P
            if (!(skillNum.equals("0") || skillNum.equals("1"))) {
                if (tolErr) {
                    err_pr.println("Error: Invalid ClassSkill entry in " + skillTable.getName() + " on row " + i);
                    continue;
                } else
                    throw new PageGenerationException("Invalid ClassSkill entry in " + skillTable.getName() + " on row " + i);
            }

            try {
                skillEntry = skills.get(Integer.parseInt(skillTable.getEntry("SkillIndex", i)));
            } catch (NumberFormatException e) {
                if (tolErr) {
                    err_pr.println("Error: Invalid SkillIndex entry in " + skillTable.getName() + " on row " + i);
                    continue;
                } else
                    throw new PageGenerationException("Invalid SkillIndex entry in " + skillTable.getName() + " on row " + i);
            }
            if (skillEntry == null) {
                if (tolErr) {
                    err_pr.println("Error: SkillIndex entry in " + skillTable.getName() + " on row " + i + " points to non-existent skill");
                    continue;
                } else
                    throw new PageGenerationException("SkillIndex entry in " + skillTable.getName() + " on row " + i + " points to non-existent skill");
            }

            if (skillNum.equals("1"))
                toReturn.e1.put(skillEntry.name, skillEntry); // Class skill
            else
                toReturn.e2.put(skillEntry.name, skillEntry); // Cross-class skill
        }

        return toReturn;
    }

    /**
     * Constructs a pair of granted feat, selectable feat lists for
     * the given class.
     *
     * @param classes2da data structure wrapping classes.2da
     * @param entryNum   number of the entry to generate list for
     * @return Tuple<List < TreeMap < String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>.
     * The first list contains the granted feats, the second selectable feats.
     * Each list consists of TreeMaps containing the feats that are related to
     * the list indexth (+1) level, keyed by feat name.
     * @throws PageGenerationException if there is an error while generating the lists and error tolerance is off
     */
    private static Tuple<List<Integer>, Tuple<List<TreeMap<String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>>
    buildClassFeatList(Data_2da classes2da, int entryNum) {
        Data_2da featTable = null,
                bonusFeatTable = null;
        ArrayList<TreeMap<String, FeatEntry>> grantedFeatList = new ArrayList<TreeMap<String, FeatEntry>>(0),
                selectableFeatList = new ArrayList<TreeMap<String, FeatEntry>>(0);
        ArrayList<Integer> bonusFeatCounts = new ArrayList<Integer>();
        HashSet<FeatEntry> masterFeatsUsed = new HashSet<FeatEntry>();
        String listNum = null;
        FeatEntry classFeat = null;
        int maxLevel, epicLevel, grantedLevel;

        // Attempt to load the class feats table
        try {
            featTable = twoDA.get(classes2da.getEntry("FeatsTable", entryNum));
        } catch (TwoDAReadException e) {
            throw new PageGenerationException("Failed to read CLS_FEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
        }
        // Attempt to load the class bonus feat slots table
        try {
            bonusFeatTable = twoDA.get(classes2da.getEntry("BonusFeatsTable", entryNum));
        } catch (TwoDAReadException e) {
            throw new PageGenerationException("Failed to read CLS_BFEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
        }
        // Attempt to read the class epic level
        try {
            epicLevel = Integer.parseInt(classes2da.getEntry("EpicLevel", entryNum));
        } catch (NumberFormatException e) {
            throw new PageGenerationException("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
        }
        // Attempt to read the class maximum level
        try {
            if (epicLevel == -1)
                maxLevel = 40;
            else
                maxLevel = Integer.parseInt(classes2da.getEntry("MaxLevel", entryNum));
        } catch (NumberFormatException e) {
            throw new PageGenerationException("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
        }

        // Base classes have EpicLevel defined as -1, but become epic at L20
        if (epicLevel == -1) epicLevel = 20;
            // Sanity check
        else if (epicLevel > maxLevel) {
            if (tolErr) {
                err_pr.println("Error: EpicLevel value(" + epicLevel + ") greater than MaxLevel value(" + maxLevel + ") for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
                epicLevel = maxLevel;
            } else
                throw new PageGenerationException("EpicLevel value(" + epicLevel + ") greater than MaxLevel value(" + maxLevel + ") for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
        }


        // Init the lists
        for (int i = 0; i < maxLevel; i++) grantedFeatList.add(null);
        for (int i = 0; i < maxLevel; i++) selectableFeatList.add(null);


        // Build a level-sorted list of feats
        for (int i = 0; i < featTable.getEntryCount(); i++) {
            // Skip empty rows and comments
            if (featTable.getEntry("FeatLabel", i).equals("****") ||
                    featTable.getEntry("FeatIndex", i).equals("****"))
                continue;

            // Read the list number and validate
            listNum = featTable.getEntry("List", i);
            if (!(listNum.equals("0") || listNum.equals("1") || listNum.equals("2") || listNum.equals("3"))) {
                if (tolErr) {
                    err_pr.println("Error: Invalid List entry in " + featTable.getName() + " on row " + i + ": " + listNum);
                    continue;
                } else
                    throw new PageGenerationException("Invalid List entry in " + featTable.getName() + " on row " + i + ": " + listNum);
            }

            // Read the level granted on and validate
            try {
                grantedLevel = Integer.parseInt(featTable.getEntry("GrantedOnLevel", i));
            } catch (NumberFormatException e) {
                if (tolErr) {
                    err_pr.println("Error: Invalid GrantedOnLevel entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("GrantedOnLevel", i));
                    continue;
                } else
                    throw new PageGenerationException("Invalid GrantedOnLevel entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("GrantedOnLevel", i));
            }

            // Complain about a semantic error
            if (listNum.equals("3") && grantedLevel == -1) {
                if (tolErr) {
                    err_pr.println("Error: List value '3' combined with GrantedOnLevel value '-1' in " + featTable.getName() + " on row " + i);
                    continue;
                } else
                    throw new PageGenerationException("List value '3' combined with GrantedOnLevel value '-1' in " + featTable.getName() + " on row " + i);
            }

            // Get the feat on this row and validate
            try {
                classFeat = feats.get(Integer.parseInt(featTable.getEntry("FeatIndex", i)));
            } catch (NumberFormatException e) {
                if (tolErr) {
                    err_pr.println("Error: Invalid FeatIndex entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("FeatIndex", i));
                    continue;
                } else
                    throw new PageGenerationException("Invalid FeatIndex entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("FeatIndex", i));
            }
            if (classFeat == null) {
                if (tolErr) {
                    err_pr.println("Error: FeatIndex entry in " + featTable.getName() + " on row " + i + " points to non-existent feat: " + featTable.getEntry("FeatIndex", i));
                    continue;
                } else
                    throw new PageGenerationException("FeatIndex entry in " + featTable.getName() + " on row " + i + " points to non-existent feat: " + featTable.getEntry("FeatIndex", i));
            }


            // Skip feats that can never be gotten
            if (grantedLevel > 40) continue;
            if (grantedLevel > maxLevel) {
                // This is never a fatal error. It's merely bad practice to place the feat outside reachable bounds, but not obviously so (ex, value of 99)
                err_pr.println("Error: GrantedOnLevel entry in " + featTable.getName() + " on row " + i + " is greater than the class's maximum level, but not obviously unreachable: " + grantedLevel + " vs. " + maxLevel);
                continue;
            }

            // If the feat has a master, replace it with the master in the listing to prevent massive spammage
            if (classFeat.master != null) {
                // Only add masterfeats to the list once.
                if (masterFeatsUsed.contains(classFeat.master)) continue;
                masterFeatsUsed.add(classFeat.master);
                classFeat = classFeat.master;
            }

            // Freely selectable feats become available at L1
            if (grantedLevel == -1) {
                if (classFeat.isEpic) {
                    // Epic feats should be shown to become available on the level that is the first after the class's normal progression ends
                    // Sanity check here against bad class entries causing index violations
                    grantedLevel = Math.min(epicLevel + 1, maxLevel);
                } else
                    grantedLevel = 1;
            }
            grantedLevel -= 1; // Adjust to 0-based array index
            // Differentiate by automatically granted or selectable
            if (listNum.equals("3")) {
                // Create the map if missing
                if (grantedFeatList.get(grantedLevel) == null)
                    grantedFeatList.set(grantedLevel, new TreeMap<String, FeatEntry>());

                // Add the feat to the map
                grantedFeatList.get(grantedLevel).put(classFeat.name, classFeat);
            } else {
                // Create the map if missing
                if (selectableFeatList.get(grantedLevel) == null)
                    selectableFeatList.set(grantedLevel, new TreeMap<String, FeatEntry>());

                // Add the feat to the map
                selectableFeatList.get(grantedLevel).put(classFeat.name, classFeat);
            }
        }

        // Make sure there are enough entries in the bonus feat table
        if (bonusFeatTable.getEntryCount() < maxLevel) {
            throw new PageGenerationException("Too few entries in class bonus feat table " + bonusFeatTable.getName() + ": " + bonusFeatTable.getEntryCount() + ". Need " + maxLevel);
        }

        for (int i = 0; i < maxLevel; i++) {
            try {
                bonusFeatCounts.add(Integer.parseInt(bonusFeatTable.getEntry("Bonus", i)));
            } catch (NumberFormatException e) {
                if (tolErr) {
                    err_pr.println("Error: Invalid Bonus entry in " + bonusFeatTable.getName() + " on row " + i + ": " + bonusFeatTable.getEntry("Bonus", i));
                    continue;
                } else
                    throw new PageGenerationException("Invalid Bonus entry in " + bonusFeatTable.getName() + " on row " + i + ": " + bonusFeatTable.getEntry("Bonus", i));
            }
        }

        return new Tuple<List<Integer>, Tuple<List<TreeMap<String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>>(
                bonusFeatCounts,
                new Tuple<List<TreeMap<String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>(
                        grantedFeatList,
                        selectableFeatList));
    }

    private static int getIntFrom2DAColumn(Data_2da table, String column, int row) {
        return getIntFrom2DAColumn(table, column, row, false);
    }

    private static int getIntFrom2DAColumn(Data_2da table, String column, int row, boolean mayBeInvalid) {
        try {
            return Integer.parseInt(table.getEntry(column, row));
        } catch (NumberFormatException e) {
            if (mayBeInvalid) {
                // Caller indicated that it's okay if this value doesn't exist
                return -1;
            }

            if (tolErr) {
                err_pr.println("Error: Invalid " + column + " entry in " + table.getName() + " on row " + row + ": " + table.getEntry(column, row));
                return -1;
            } else
                throw new PageGenerationException("Invalid " + column + " entry in " + table.getName() + " on row " + row + ": " + table.getEntry(column, row));
        }
    }

    private static Map<Integer, String> baseClassIdsToSpellColumns = new HashMap<Integer, String>() {{
        put(1, "Bard");
        put(2, "Cleric");
        put(3, "Druid");
        put(6, "Paladin");
        put(7, "Ranger");
        put(9, "Wiz_Sorc");
        put(10, "Wiz_Sorc");
    }};

    /**
     * Constructs lists of the magics available to the given class.
     * The entries are ordered by spell / power level
     *
     * @param classes2da data structure wrapping classes.2da
     * @param entryNum   number of the entry to generate table for
     * @return List<Tuple < Tuple < String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>>.
     * Each list entry contains one magic type. The first tuple member consists of the
     * name of magic system, name of spell-equivalent pari. The second member contains
     * the magic entries. The Integer-keyed TreeMaps contain the spells
     * of each level. The integers are the spell levels.
     * @throws PageGenerationException if there is an error while generating the list and error tolerance is off
     */
    private static List<Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>> buildClassMagicList(Data_2da classes2da, int entryNum) {
        List<Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>> toReturn =
                new ArrayList<Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>>();
        String classAbrev = null;
        Data_2da spellList = null,
                powerList = null,
                utterList = null,
                //invocations and maneuvers are a bit different because they don't have their own name column
                invocList = null,
                maneuList = null,
                spells2da = twoDA.get("spells");


        // Check for correctly formed table name
        if (!classes2da.getEntry("FeatsTable", entryNum).toLowerCase().startsWith("cls_feat_")) {
            throw new PageGenerationException("Malformed FeatsTable entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
        }

        // Extract the class abbreviation
        classAbrev = classes2da.getEntry("FeatsTable", entryNum).toLowerCase().substring(9);

        // Attempt to load the class and power 2das - If these fail, assume it was just due to non-existent file
        try {
            spellList = twoDA.get("cls_spcr_" + classAbrev);
        } catch (TwoDAReadException e) { /* Ensure nullness */
            powerList = null;
        }
        try {
            powerList = twoDA.get("cls_psipw_" + classAbrev);
        } catch (TwoDAReadException e) { /* Ensure nullness */
            powerList = null;
        }
        try {
            utterList = twoDA.get("cls_" + classAbrev + "_utter");
        } catch (TwoDAReadException e) { /* Ensure nullness */
            utterList = null;
        }
        try {
            invocList = twoDA.get("cls_inv_" + classAbrev);
        } catch (TwoDAReadException e) { /* Ensure nullness */
            invocList = null;
        }
        try {
            maneuList = twoDA.get("cls_move_" + classAbrev);
        } catch (TwoDAReadException e) { /* Ensure nullness */
            maneuList = null;
        }

        // Do spellbook
        if (spellList == null && baseClassIdsToSpellColumns.containsKey(entryNum)) {
            // There's no custom spellbook for this class, so pull the info from spells.2da
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists = new TreeMap<Integer, TreeMap<String, SpellEntry>>();
            SpellEntry spell = null;
            String classColumnName = baseClassIdsToSpellColumns.get(entryNum);
            int level;

            for (int i = 0; i < spells2da.getEntryCount(); i++) {
                // Make sure the Level entry is a number
                level = getIntFrom2DAColumn(spells2da, classColumnName, i, true);
                if (level == -1) continue;

                spell = spells.get(i);

                // If no map for this level yet, fill it in
                if (!levelLists.containsKey(level))
                    levelLists.put(level, new TreeMap<String, SpellEntry>());

                // Add the spell to the map
                levelLists.get(level)
                        .put(spell.name, spell);
            }

            toReturn.add(new Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>(
                    new Tuple<String, String>(curLanguageData[LANGDATA_SPELLBOOKTXT], curLanguageData[LANGDATA_SPELLSTXT]),
                    levelLists));
        } else if (spellList != null) {
            // Map of level numbers to maps of spell names to html links
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists = new TreeMap<Integer, TreeMap<String, SpellEntry>>();
            SpellEntry spell = null;
            int level;

            for (int i = 0; i < spellList.getEntryCount(); i++) {
                // Make sure the Level entry is a number
                level = getIntFrom2DAColumn(spellList, "Level", i);
                if (level == -1) continue;

                // Make sure the SpellID is valid
                int spellId = getIntFrom2DAColumn(spellList, "SpellID", i);
                if (spellId == -1) continue;
                spell = spells.get(spellId);

                if (spell == null) {
                    if (tolErr) {
                        err_pr.println("Error: SpellID entry in " + spellList.getName() + " on row " + i + " points at nonexistent spell: " + spellList.getEntry("SpellID", i));
                        continue;
                    } else
                        throw new PageGenerationException("SpellID entry in " + spellList.getName() + " on row " + i + " points at nonexistent spell: " + spellList.getEntry("SpellID", i));
                }

                // If no map for this level yet, fill it in
                if (!levelLists.containsKey(level))
                    levelLists.put(level, new TreeMap<String, SpellEntry>());

                // Add the spell to the map
                levelLists.get(level)
                        .put(spell.name, spell);
            }

            toReturn.add(new Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>(
                    new Tuple<String, String>(curLanguageData[LANGDATA_SPELLBOOKTXT], curLanguageData[LANGDATA_SPELLSTXT]),
                    levelLists));
        }

        // Do psionics
        if (powerList != null) {
            // Map of level numbers to maps of spell names to html links
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists = new TreeMap<Integer, TreeMap<String, SpellEntry>>();
            SpellEntry power = null;
            int level;

            for (int i = 0; i < powerList.getEntryCount(); i++) {
                // Skip rows that do not define a power
                if (powerList.getEntry("Level", i).equals("****"))
                    continue;

                level = getIntFrom2DAColumn(powerList, "Level", i);
                if (level == -1) continue;

                // Make sure the SpellID is valid
                int realSpellId = getIntFrom2DAColumn(powerList, "RealSpellID", i);
                if (realSpellId < 0) continue;
                power = spells.get(realSpellId);

                if (power == null) {
                    if (tolErr) {
                        err_pr.println("Error: Unable to map Name entry in " + powerList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(powerList.getEntry("Label", i)));
                        continue;
                    } else
                        throw new PageGenerationException("Unable to map Name entry in " + powerList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(powerList.getEntry("Name", i)));
                }

                // If no map for this level yet, fill it in
                if (!levelLists.containsKey(level))
                    levelLists.put(level, new TreeMap<String, SpellEntry>());

                // Add the spell to the map
                levelLists.get(level)
                        .put(power.name, power);
            }

            toReturn.add(new Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>(
                    new Tuple<String, String>(curLanguageData[LANGDATA_PSIONICPOWERSTXT], curLanguageData[LANGDATA_POWERTXT]),
                    levelLists));
        }

        // Do truenaming
        if (utterList != null) {
            // Map of level numbers to maps of spell names to html links
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists = new TreeMap<Integer, TreeMap<String, SpellEntry>>();
            SpellEntry utterance = null;
            int level;

            for (int i = 0; i < utterList.getEntryCount(); i++) {
                // Skip rows that do not define a power
                if (utterList.getEntry("Level", i).equals("****"))
                    continue;

                // Make sure the Level entry is a number
                try {
                    level = Integer.parseInt(utterList.getEntry("Level", i));
                } catch (NumberFormatException e) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid Level entry in " + utterList.getName() + " on row " + i + ": " + utterList.getEntry("Level", i));
                        continue;
                    } else
                        throw new PageGenerationException("Invalid Level entry in " + utterList.getName() + " on row " + i + ": " + utterList.getEntry("Level", i));
                }

                // Make sure the SpellID is valid
                utterance = null;
                try {
                    // Attempt to get the spell entry via a mapping of power names to spellIDs
                    utterance = spells.get(utterMap.get(tlk.get(Integer.parseInt(utterList.getEntry("Name", i)))));
                } catch (NumberFormatException e) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid Name entry in " + utterList.getName() + " on row " + i + ": " + utterList.getEntry("Name", i));
                        continue;
                    } else
                        throw new PageGenerationException("Invalid Name entry in " + utterList.getName() + " on row " + i + ": " + utterList.getEntry("Name", i));
                }
                if (utterance == null) {
                    if (tolErr) {
                        err_pr.println("Error: Unable to map Name entry in " + utterList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(utterList.getEntry("Name", i)));
                        continue;
                    } else
                        throw new PageGenerationException("Unable to map Name entry in " + utterList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(utterList.getEntry("Name", i)));
                }

                // If no map for this level yet, fill it in
                if (!levelLists.containsKey(level))
                    levelLists.put(level, new TreeMap<String, SpellEntry>());

                // Add the spell to the map
                levelLists.get(level)
                        .put(utterance.name, utterance);
            }

            toReturn.add(new Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>(
                    new Tuple<String, String>(curLanguageData[LANGDATA_TRUENAMEUTTERANCETXT], curLanguageData[LANGDATA_UTTERANCETXT]),
                    levelLists));
        }

        // Do invocations
        if (invocList != null) {
            // Map of level numbers to maps of spell names to html links
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists = new TreeMap<Integer, TreeMap<String, SpellEntry>>();
            SpellEntry invocation = null;
            int level;

            for (int i = 0; i < invocList.getEntryCount(); i++) {
                // Skip rows that do not define a power
                if (invocList.getEntry("Level", i).equals("****"))
                    continue;

                // Make sure the Level entry is a number
                try {
                    level = Integer.parseInt(invocList.getEntry("Level", i));
                } catch (NumberFormatException e) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid Level entry in " + invocList.getName() + " on row " + i + ": " + invocList.getEntry("Level", i));
                        continue;
                    } else
                        throw new PageGenerationException("Invalid Level entry in " + invocList.getName() + " on row " + i + ": " + invocList.getEntry("Level", i));
                }

                // Make sure the SpellID is valid
                invocation = null;
                try {
                    // Look in spells.2da for name
                    invocation = spells.get(invMap.get(tlk.get(spells2da.getEntry("Name", invocList.getEntry("RealSpellID", i)))));
                } catch (NumberFormatException e) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid Name entry in " + invocList.getName() + " on row " + i + ": " + invocList.getEntry("Name", i));
                        continue;
                    } else
                        throw new PageGenerationException("Invalid Name entry in " + invocList.getName() + " on row " + i + ": " + invocList.getEntry("Name", i));
                }
                if (invocation == null) {
                    if (tolErr) {
                        err_pr.println("Error: Unable to map Name entry in " + invocList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(invocList.getEntry("Name", i)));
                        continue;
                    } else
                        throw new PageGenerationException("Unable to map Name entry in " + invocList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(invocList.getEntry("Name", i)));
                }

                // If no map for this level yet, fill it in
                if (!levelLists.containsKey(level))
                    levelLists.put(level, new TreeMap<String, SpellEntry>());

                // Add the spell to the map
                levelLists.get(level)
                        .put(invocation.name, invocation);
            }

            toReturn.add(new Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>(
                    new Tuple<String, String>(curLanguageData[LANGDATA_INVOCATIONTXT], curLanguageData[LANGDATA_INVOCATIONTXT]),
                    levelLists));
        }

        // Do maneuvers
        if (maneuList != null) {
            // Map of level numbers to maps of spell names to html links
            TreeMap<Integer, TreeMap<String, SpellEntry>> levelLists = new TreeMap<Integer, TreeMap<String, SpellEntry>>();
            SpellEntry maneuver = null;
            int level;

            for (int i = 0; i < maneuList.getEntryCount(); i++) {
                // Skip rows that do not define a power
                if (maneuList.getEntry("Level", i).equals("****"))
                    continue;

                // Make sure the Level entry is a number
                try {
                    level = Integer.parseInt(maneuList.getEntry("Level", i));
                } catch (NumberFormatException e) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid Level entry in " + maneuList.getName() + " on row " + i + ": " + maneuList.getEntry("Level", i));
                        continue;
                    } else
                        throw new PageGenerationException("Invalid Level entry in " + maneuList.getName() + " on row " + i + ": " + maneuList.getEntry("Level", i));
                }

                // Make sure the SpellID is valid
                maneuver = null;
                try {
                    // Look in spells.2da for name
                    maneuver = spells.get(maneuverMap.get(tlk.get(spells2da.getEntry("Name", maneuList.getEntry("RealSpellID", i)))));
                } catch (NumberFormatException e) {
                    if (tolErr) {
                        err_pr.println("Error: Invalid Name entry in " + maneuList.getName() + " on row " + i + ": " + maneuList.getEntry("Name", i));
                        continue;
                    } else
                        throw new PageGenerationException("Invalid Name entry in " + maneuList.getName() + " on row " + i + ": " + maneuList.getEntry("Name", i));
                }
                if (maneuver == null) {
                    if (tolErr) {
                        err_pr.println("Error: Unable to map Name entry in " + maneuList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(maneuList.getEntry("Name", i)));
                        continue;
                    } else
                        throw new PageGenerationException("Unable to map Name entry in " + maneuList.getName() + " on row " + i + " to a spellEntry: " + tlk.get(maneuList.getEntry("Name", i)));
                }

                // If no map for this level yet, fill it in
                if (!levelLists.containsKey(level))
                    levelLists.put(level, new TreeMap<String, SpellEntry>());

                // Add the spell to the map
                levelLists.get(level)
                        .put(maneuver.name, maneuver);
            }

            toReturn.add(new Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>(
                    new Tuple<String, String>(curLanguageData[LANGDATA_MANEUVERTXT], curLanguageData[LANGDATA_MANEUVERTXT]),
                    levelLists));
        }

        return toReturn;
    }
}
