package prc.autodoc;

//import java.io.*;

import java.util.HashMap;
import java.util.TreeMap;

import static prc.Main.verbose;
import static prc.autodoc.Main.*;
import static prc.autodoc.Main.SpellType.*;

public final class MenuGeneration {
    private MenuGeneration() {/* No instances */}

    /**
     * Sorts any of the pages for which GenericEntry is enough into alphabetic order
     * using a TreeMap, and prints a menu page out of the results.
     */
    public static void doGenericMenu(HashMap<Integer, ? extends GenericEntry> entries, String menuName, String menuFileName) {
        TreeMap<String, String> links = new TreeMap<String, String>();
        StringBuffer toPrint = new StringBuffer();

        if (verbose) System.out.println("Printing menu for " + menuName);

        for (GenericEntry entry : entries.values()) {
            links.put(entry.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                    entry.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                    .replaceAll("~~~targetName~~~", entry.name));
        }

        while (links.size() > 0) {
            toPrint.append(links.remove(links.firstKey()));
        }

        printPage(menuPath + menuFileName, menuTemplate.replaceAll("~~~menuName~~~", menuName)
                .replaceAll("~~~menuEntries~~~", toPrint.toString()));
    }

    /**
     * Sorts the spells into alphabetic order using a TreeMap, and prints a menu
     * page out of the results. Normal, epic and psionics get their own menus
     */
    public static void doSpellMenus() {
        TreeMap<String, String> normalSpellLinks = new TreeMap<String, String>(),
                epicSpellLinks = new TreeMap<String, String>(),
                psionicPowerLinks = new TreeMap<String, String>(),
                utteranceLinks = new TreeMap<String, String>(),
                invocationLinks = new TreeMap<String, String>(),
                maneuverLinks = new TreeMap<String, String>(),
                modSpellLinks = new TreeMap<String, String>();
        StringBuffer normalPrint = new StringBuffer(),
                epicPrint = new StringBuffer(),
                psionicPrint = new StringBuffer(),
                utterancePrint = new StringBuffer(),
                invocationPrint = new StringBuffer(),
                maneuverPrint = new StringBuffer(),
                modSpellPrint = new StringBuffer();
        String temp = null;

        if (verbose) System.out.println("Printing spell menus");

        for (SpellEntry spell : spells.values()) {
            switch (spell.type) {
                case NORMAL:
                    normalSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                            spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                            .replaceAll("~~~targetName~~~", spell.name));
                    break;
                case EPIC:
                    temp = spell.name.startsWith("Epic Spell: ") ? spell.name.substring(12) : spell.name;
                    epicSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                            spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                            .replaceAll("~~~targetName~~~", temp));
                    break;
                case PSIONIC:
                    psionicPowerLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                            spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                            .replaceAll("~~~targetName~~~", spell.name));
                    break;
                case UTTERANCE:
                    utteranceLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                            spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                            .replaceAll("~~~targetName~~~", spell.name));
                    break;
                case INVOCATION:
                    invocationLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                            spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                            .replaceAll("~~~targetName~~~", spell.name));
                    break;
                case MANEUVER:
                    maneuverLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                            spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                            .replaceAll("~~~targetName~~~", spell.name));
                    break;

                default:
                    throw new AssertionError("Unhandled spelltype: " + spell.type);
            }

            if (settings.modifiedSpells.contains(spell.entryNum))
                modSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", spell.name));
        }

        while (normalSpellLinks.size() > 0)
            normalPrint.append(normalSpellLinks.remove(normalSpellLinks.firstKey()));
        while (epicSpellLinks.size() > 0)
            epicPrint.append(epicSpellLinks.remove(epicSpellLinks.firstKey()));
        while (psionicPowerLinks.size() > 0)
            psionicPrint.append(psionicPowerLinks.remove(psionicPowerLinks.firstKey()));
        while (utteranceLinks.size() > 0)
            utterancePrint.append(utteranceLinks.remove(utteranceLinks.firstKey()));
        while (invocationLinks.size() > 0)
            invocationPrint.append(invocationLinks.remove(invocationLinks.firstKey()));
        while (maneuverLinks.size() > 0)
            maneuverPrint.append(maneuverLinks.remove(maneuverLinks.firstKey()));
        while (modSpellLinks.size() > 0)
            modSpellPrint.append(modSpellLinks.remove(modSpellLinks.firstKey()));

        printPage(menuPath + "manual_menus_spells.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_SPELLSTXT])
                .replaceAll("~~~menuEntries~~~", normalPrint.toString()));
        printPage(menuPath + "manual_menus_epic_spells.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_EPICSPELLSTXT])
                .replaceAll("~~~menuEntries~~~", epicPrint.toString()));
        printPage(menuPath + "manual_menus_psionic_powers.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_PSIONICPOWERSTXT])
                .replaceAll("~~~menuEntries~~~", psionicPrint.toString()));
        printPage(menuPath + "manual_menus_truename_utterances.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_TRUENAMEUTTERANCETXT])
                .replaceAll("~~~menuEntries~~~", utterancePrint.toString()));
        printPage(menuPath + "manual_menus_invocations.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_INVOCATIONTXT])
                .replaceAll("~~~menuEntries~~~", invocationPrint.toString()));
        printPage(menuPath + "manual_menus_maneuvers.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_MANEUVERTXT])
                .replaceAll("~~~menuEntries~~~", maneuverPrint.toString()));
        printPage(menuPath + "manual_menus_modified_spells.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_MODIFIEDSPELLSTXT])
                .replaceAll("~~~menuEntries~~~", modSpellPrint.toString()));
    }


    /**
     * Sorts the feats into alphabetic order using a TreeMap, and prints a menu
     * page out of the results. Normal and epic feats get their own menus and class feats
     * are skipped.
     */
    public static void doFeatMenus() {
        TreeMap<String, String> normalFeatLinks = new TreeMap<String, String>(),
                normalMasterfeatLinks = new TreeMap<String, String>(),
                epicFeatLinks = new TreeMap<String, String>(),
                epicMasterfeatLinks = new TreeMap<String, String>();
        StringBuffer normalList = new StringBuffer(),
                normalMasterList = new StringBuffer(),
                epicList = new StringBuffer(),
                epicMasterList = new StringBuffer();
        String temp = null;
        String normalMenu = featMenuTemplate,
                epicMenu = featMenuTemplate;

        if (verbose) System.out.println("Printing feat menus");

        // Print names
        normalMenu = normalMenu.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_FEATSTXT]);
        epicMenu = epicMenu.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_EPICFEATSTXT]);

        // Parse through feats
        for (FeatEntry feat : feats.values()) {
            // Skip class feats and feats with masterfeat or a predecessor
            if (feat.isClassFeat || feat.isSuccessor || feat.master != null) continue;
            if (!feat.isEpic)
                normalFeatLinks.put(feat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        feat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", feat.name));
            else
                epicFeatLinks.put(feat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        feat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", feat.name));
        }

        // Transfer the feat link lists into text form
        while (normalFeatLinks.size() > 0)
            normalList.append(normalFeatLinks.remove(normalFeatLinks.firstKey()));
        while (epicFeatLinks.size() > 0)
            epicList.append(epicFeatLinks.remove(epicFeatLinks.firstKey()));

        // Parse through masterfeats
        for (FeatEntry masterfeat : masterFeats.values()) {
            if (masterfeat.isClassFeat && masterfeat.allChildrenClassFeat) continue;
            if (masterfeat.isEpic)
                epicMasterfeatLinks.put(masterfeat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        masterfeat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", masterfeat.name));
            if (!masterfeat.allChildrenEpic)
                normalMasterfeatLinks.put(masterfeat.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        masterfeat.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", masterfeat.name));
        }

        // Transfer the masterfeat link lists into text form
        while (normalMasterfeatLinks.size() > 0)
            normalMasterList.append(normalMasterfeatLinks.remove(normalMasterfeatLinks.firstKey()));
        while (epicMasterfeatLinks.size() > 0)
            epicMasterList.append(epicMasterfeatLinks.remove(epicMasterfeatLinks.firstKey()));

        // Add in a link to the page listing *all* feats
        normalMenu = normalMenu.replaceAll("~~~allFeatsLink~~~", menuItemTemplate.replaceAll("~~~TargetPath~~~",
                (contentPath + "feats" + fileSeparator + "alphasortedfeats.html")
                        .replace(mainPath, "../").replaceAll("\\\\", "/"))
                .replaceAll("~~~targetName~~~", curLanguageData[LANGDATA_ALLFEATSTXT]));

        // Add in a link to the page listing all epic feats
        epicMenu = epicMenu.replaceAll("~~~allFeatsLink~~~", menuItemTemplate.replaceAll("~~~TargetPath~~~",
                (contentPath + "epic_feats" + fileSeparator + "alphasortedepicfeats.html")
                        .replace(mainPath, "../").replaceAll("\\\\", "/"))
                .replaceAll("~~~targetName~~~", curLanguageData[LANGDATA_ALLEPICFEATSTXT]));

        // Add in the masterfeat links
        normalMenu = normalMenu.replaceAll("~~~masterFeats~~~", normalMasterList.toString());
        epicMenu = epicMenu.replaceAll("~~~masterFeats~~~", epicMasterList.toString());

        // Add in the feat links
        normalMenu = normalMenu.replaceAll("~~~featLinks~~~", normalList.toString());
        epicMenu = epicMenu.replaceAll("~~~featLinks~~~", epicList.toString());

        // Print the pages
        printPage(menuPath + "manual_menus_feat.html", normalMenu);
        printPage(menuPath + "manual_menus_epic_feat.html", epicMenu);
    }

    //private static void doFeatMenusAux()


    /**
     * Sorts the classes into alphabetic order using a TreeMap, and prints a menu
     * page out of the results. Base and prestige classes get their own menus
     */
    public static void doClassMenus() {
        TreeMap<String, String> baseLinks = new TreeMap<String, String>(),
                prestigeLinks = new TreeMap<String, String>();
        StringBuffer basePrint = new StringBuffer(),
                prestigePrint = new StringBuffer();
        String temp = null;

        if (verbose) System.out.println("Printing class menus");

        for (ClassEntry clazz : classes.values()) {
            if (clazz.isBase)
                baseLinks.put(clazz.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        clazz.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", clazz.name));
            else
                prestigeLinks.put(clazz.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
                        clazz.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
                        .replaceAll("~~~targetName~~~", clazz.name));
        }

        while (baseLinks.size() > 0)
            basePrint.append(baseLinks.remove(baseLinks.firstKey()));
        while (prestigeLinks.size() > 0)
            prestigePrint.append(prestigeLinks.remove(prestigeLinks.firstKey()));

        printPage(menuPath + "manual_menus_base_classes.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_BASECLASSESTXT])
                .replaceAll("~~~menuEntries~~~", basePrint.toString()));
        printPage(menuPath + "manual_menus_prestige_classes.html", menuTemplate.replaceAll("~~~menuName~~~", curLanguageData[LANGDATA_PRESTIGECLASSESTXT])
                .replaceAll("~~~menuEntries~~~", prestigePrint.toString()));
    }
}