package prc.autodoc;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static prc.Main.*;
import static prc.autodoc.EntryGeneration.*;
import static prc.autodoc.MenuGeneration.*;
import static prc.autodoc.PageGeneration.*;

/**
 * The main purpose of this autodocumenter is to create parts of the manual for
 * the PRC pack from 2da and TLK files. As a side effect of doing so, it finds
 * many errors present in the 2das.
 */
public class Main {
    public static ArrayList<String> getFoldersInFolder(String path) {
        var result = new ArrayList<String>();

        var folder = new File(path);
        for (var fileEntry : folder.listFiles()) {
            if (fileEntry.isDirectory()) {
                result.add(fileEntry.getAbsolutePath().toString());
            }
        }

        return result;
    }

    public static ArrayList<String> getFilesInFolder(String path) {
        var result = new ArrayList<String>();

        var folder = new File(path);
        for (var fileEntry : folder.listFiles()) {
            if (!fileEntry.isDirectory()) {
                result.add(fileEntry.getAbsolutePath().toString());
            }
        }

        return result;
    }


    /**
     * A small data structure class that gives access to both normal and custom
     * TLK with the same method
     */
    public static class TLKStore {
        private final Data_TLK normal;
		private final Data_TLK custom;

        /**
         * Creates a new TLKStore around the given two filenames. Equivalent to
         * TLKStore(normalName, customName, "tlk").
         *
         * @param normalName dialog.tlk or equivalent for the given language
         * @param customName prc8_consortium.tlk or equivalent for the given languag
         * @throws TLKReadException if there are any problems reading either TLK
         */
        public TLKStore(String normalName, String customName) {
            var baseDirectory = "../../trunk"; // @TODO: Move to a Configuration File
            this.normal = new Data_TLK(Paths.get(baseDirectory, "tlk", normalName).toAbsolutePath().toString());
            this.custom = new Data_TLK(Paths.get(baseDirectory, "tlk", customName).toAbsolutePath().toString());
        }

        /**
         * Creates a new TLKStore around the given two filenames.
         *
         * @param normalName dialog.tlk or equivalent for the given language
         * @param customName prc8_consortium.tlk or equivalent for the given languag
         * @param tlkDir     Directory containing the two .tlk files
         * @throws TLKReadException if there are any problems reading either TLK
         */
        public TLKStore(String normalName, String customName, String tlkDir) {
            var baseDirectory = "../../trunk"; // @TODO: Move to a Configuration File
            this.normal = new Data_TLK(Paths.get(baseDirectory, tlkDir, normalName).toAbsolutePath().toString());
            this.custom = new Data_TLK(Paths.get(baseDirectory, tlkDir, customName).toAbsolutePath().toString());
        }

        /**
         * Returns the TLK entry for the given StrRef. If there is nothing
         * at the location, returns Bad StrRef. Automatically picks between
         * normal and custom TLKs.
         *
         * @param num the line number in TLK
         * @return the contents of the given TLK slot, or Bad StrRef
         */
        public String get(int num) {
            return num < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
        }

        /**
         * See above, except that this one automatically parses the string for
         * the number.
         *
         * @param num the line number in TLK as string
         * @return as above, except it returns Bad StrRef in case parsing failed
         */
        public String get(String num) {
            try {
                return get(Integer.parseInt(num));
            } catch (NumberFormatException e) {
                return Main.badStrRef;
            }
        }
    }

    /**
     * Another data structure class. Stores 2das and handles loading them.
     */
    public static class TwoDAStore {
        private static class Loader implements Runnable {
            private final String pathToLoad;
            private final List<Data_2da> list;
            private final CountDownLatch latch;

            /**
             * Creates a new Loader to load the given 2da file
             *
             * @param pathToLoad path of the 2da to load
             * @param list       list to store the loaded data into
             * @param latch      latch to countdown on once loading is complete
             */
            public Loader(String pathToLoad, List<Data_2da> list, CountDownLatch latch) {
                this.pathToLoad = pathToLoad;
                this.list = list;
                this.latch = latch;
            }

            /**
             * @see java.lang.Runnable#run()
             */
            public void run() {
                try {
                    Data_2da data = Data_2da.load2da(pathToLoad, true);
                    list.add(data);
                    latch.countDown();
                } catch (Exception e) {
                    err_pr.println("Error: Failure while reading main 2das. Exception data:\n");
                    err_pr.printException(e);
                    System.exit(1);
                }
            }
        }

        private final HashMap<String, Data_2da> data = new HashMap<String, Data_2da>();
        private final String twoDAPath;

        /**
         * Creates a new TwoDAStore, without preloading anything.
         *
         * @param twoDAPath Path of the directory containing 2da files.
         */
        public TwoDAStore(String twoDAPath) {
            this.twoDAPath = twoDAPath;
        }

        /**
         * Generates a new TwoDAStore with all the main 2das preread in.
         * On a read failure, kills program execution, since there's nothing
         * that could be done anyway.
         */
        public TwoDAStore() {
            this("../../trunk/2das");
            //long start = System.currentTimeMillis();
            if (verbose) System.out.print("Loading main 2da files ");
            CountDownLatch latch = new CountDownLatch(7);
            List<Data_2da> list = Collections.synchronizedList(new ArrayList<Data_2da>());
            ArrayList<Thread> threads = new ArrayList<>();

            var baseDirectory = "../../trunk"; // @TODO: Move to a Configuration File
            var folders = getFoldersInFolder(baseDirectory);
            folders.add("base_nwn_files"); // this is where we store the base nwn 2da files
            for (var folder : folders) {
                if (folder.endsWith("2das")) {
                    var files = getFilesInFolder(folder);
                    for (var file : files) {
                        var thread = new Thread(new Loader(file, list, latch));
                        threads.add(thread);
                        thread.start();
                    }
                }
            }

            boolean oldVerbose = verbose;
            verbose = false;


//            // Read the main 2das
//            new Thread(new Loader("2da" + fileSeparator + "classes.2da", list, latch)).start();
//            new Thread(new Loader("2da" + fileSeparator + "domains.2da", list, latch)).start();
//            new Thread(new Loader("2da" + fileSeparator + "feat.2da", list, latch)).start();
//            new Thread(new Loader("2da" + fileSeparator + "masterfeats.2da", list, latch)).start();
//            new Thread(new Loader("2da" + fileSeparator + "racialtypes.2da", list, latch)).start();
//            new Thread(new Loader("2da" + fileSeparator + "skills.2da", list, latch)).start();
//            new Thread(new Loader("2da" + fileSeparator + "spells.2da", list, latch)).start();

            try {
                for (Thread thread : threads) {
                    thread.join();
                }
            } catch (InterruptedException e) {
                err_pr.println("Error: Interrupted while reading main 2das. Exception data:\n");
                err_pr.printException(e);
                System.exit(1);
            }

            for (Data_2da entry : list)
                data.put(entry.getName(), entry);
            verbose = oldVerbose;
            if (verbose) System.out.println("- Done");
			/*
			try{
				data.put("classes",     new Data_2da("2da" + fileSeparator + "classes.2da"));
				data.put("domains",     new Data_2da("2da" + fileSeparator + "domains.2da"));
				data.put("feat",        new Data_2da("2da" + fileSeparator + "feat.2da"));
				data.put("masterfeats", new Data_2da("2da" + fileSeparator + "masterfeats.2da"));
				data.put("racialtypes", new Data_2da("2da" + fileSeparator + "racialtypes.2da"));
				data.put("skills",      new Data_2da("2da" + fileSeparator + "skills.2da"));
				data.put("spells",      new Data_2da("2da" + fileSeparator + "spells.2da"));
			}catch(Exception e){
				err_pr.println("Error: Failure while reading main 2das. Exception data:\n");
				err_pr.printException(e);
				System.exit(1);
			}
			*/
            //System.out.println("Time taken: "  + (System.currentTimeMillis() - start));
        }

        /**
         * Gets a Data_2da structure wrapping the given 2da. If it hasn't been loaded
         * yet, the loading is done now.
         *
         * @param name name of the 2da to get. Without the file end ".2da".
         * @return a Data_2da structure
         * @throws TwoDAReadException if any errors are encountered while reading
         */
        public Data_2da get(String name) {
            if (data.containsKey(name))
                return data.get(name);
            else {
                Data_2da temp = null;
                try {
                    var basePath = "../../trunk";
                    var potentialPaths = getFoldersInFolder(basePath);
                    potentialPaths.add("base_nwn_files"); // this is where we store the base nwn 2da files
                    for (var folder : potentialPaths) {
                        var file = new File(Paths.get(folder, name + ".2da").toAbsolutePath().toString());
                        if (file.exists()) {
                            temp = Data_2da.load2da(file.getAbsolutePath().toString(), true);
                            break;
                        }
                    }
                    if (temp == null) {
                        throw new TwoDAReadException("File not found\n" + name);
                    }

                } catch (IllegalArgumentException e) {
                    throw new TwoDAReadException("Problem with filename when trying to read from 2da:\n" + e);
                }
                data.put(name, temp);
                return temp;
            }
        }

        public HashMap<String, Data_2da> findAll(String name) {
            HashMap<String, Data_2da> copy = new HashMap<String, Data_2da>(data);
            copy.keySet().removeIf(key -> !key.contains(name));
            return copy;
        }
    }

    /**
     * A class for handling the settings file.
     */
    public static class Settings {
        /* Some pattern matchers for use when parsing the settings file */
        private final Matcher mainMatch = Pattern.compile("\\S+:").matcher("");
		private final Matcher paraMatch = Pattern.compile("\"[^\"]+\"").matcher("");
		private final Matcher langMatch = Pattern.compile("\\w+=\"[^\"]+\"").matcher("");

        /* An enumeration of the possible setting types */
        private enum Modes {
            /**
             * The parser is currently working on lines specifying languages used.
             */
            LANGUAGE,
            /**
             * The parser is currently working on lines containing string patterns that are
             * used in differentiating between entries in spells.2da.
             */
            SIGNATURE,
            /**
             * The parser is currently working on lines listing spells.2da entries that contain
             * a significantly modified BW spell.
             */
            MODIFIED_SPELL
        }

		/* Settings data read in */
        /**
         * The settings for languages. An ArrayList of String[] containing setting for a specific language
         */
        public ArrayList<String[]> languages = new ArrayList<String[]>();
        /**
         * An ArrayList of Integers. Indices to spells.2da of standard spells modified by the PRC
         */
        public ArrayList<Integer> modifiedSpells = new ArrayList<Integer>();
        /**
         * A set of script name prefixes used to find epic spell entries in spells.2da
         */
        public String[] epicspellSignatures = null;
		/*/** A set of script name prefixes used to find psionic power entries in spells.2da *
		public String[] psionicpowerSignatures = null;*/

        /**
         * Read the settings file in and store the data for later access.
         * Terminates execution on any errors.
         */
        public Settings() {
            try {
                // The settings file should be present in the directory this is run from
                Scanner reader = new Scanner(new File("settings"));
                String check;
                Modes mode = null;
                while (reader.hasNextLine()) {
                    check = reader.nextLine();

                    // Skip comments and blank lines
                    if (check.startsWith("#") || check.trim().equals("")) continue;

                    // Check if a new rule is starting
                    mainMatch.reset(check);
                    if (mainMatch.find()) {
                        if (mainMatch.group().equals("language:")) mode = Modes.LANGUAGE;
                        else if (mainMatch.group().equals("signature:")) mode = Modes.SIGNATURE;
                        else if (mainMatch.group().equals("modified_spell:")) mode = Modes.MODIFIED_SPELL;
                        else {
                            throw new Exception("Unrecognized setting detected");
                        }

                        continue;
                    }

                    // Take action based on current mode
                    if (mode == Modes.LANGUAGE) {
                        String[] temp = new String[LANGDATA_NUMENTRIES];
                        String result;
                        langMatch.reset(check);
                        // parse the language entry
                        for (int i = 0; i < LANGDATA_NUMENTRIES; i++) {
                            if (!langMatch.find())
                                throw new Exception("Missing language parameter");
                            result = langMatch.group();

                            if (result.startsWith("name=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_LANGNAME] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("base=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_BASETLK] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("prc=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_PRCTLK] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("feats=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_FEATSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("allfeats=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_ALLFEATSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("epicfeats=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_EPICFEATSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("allepicfeats=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_ALLEPICFEATSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("baseclasses=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_BASECLASSESTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("prestigeclasses=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_PRESTIGECLASSESTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("spells=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_SPELLSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("epicspells=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_EPICSPELLSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("psipowers=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_PSIONICPOWERSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("modspells=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_MODIFIEDSPELLSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("skills=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_SKILLSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("domains=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_DOMAINSTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("races=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_RACESTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("spellbook=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_SPELLBOOKTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("powers=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_POWERTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("truenameutterances=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_TRUENAMEUTTERANCETXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("invocations=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_INVOCATIONTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("maneuvers=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_MANEUVERTXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else if (result.startsWith("utterances=")) {
                                paraMatch.reset(result);
                                paraMatch.find();
                                temp[LANGDATA_UTTERANCETXT] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
                            } else
                                throw new Exception("Unknown language parameter encountered\n" + check);
                        }
                        languages.add(temp);
                    }
                    // Parse the spell script name signatures
                    if (mode == Modes.SIGNATURE) {
                        String[] temp = check.trim().split("=");
                        if (temp[0].equals("epicspell")) {
                            epicspellSignatures = temp[1].replace("\"", "").split("\\|");
                        }/* Not needed anymore
						else if(temp[0].equals("psionicpower")){
							psionicpowerSignatures = temp[1].replace("\"", "").split("\\|");
						}*/ else
                            throw new Exception("Unknown signature parameter encountered:\n" + check);
                    }
                    // Parse the spell modified spell indices
                    if (mode == Modes.MODIFIED_SPELL) {
                        modifiedSpells.add(Integer.parseInt(check.trim()));
                    }
                }
            } catch (Exception e) {
                err_pr.println("Error: Failed to read settings file:\n" + e + "\nAborting");
                System.exit(1);
            }
        }
    }

    /**
     * A small enumeration for use in spell printing methods
     */
    public enum SpellType {
        /**
         * The spell is not a real spell or psionic power, instead specifies some feat's spellscript.
         */
        NONE,
        /**
         * The spell is a normal spell.
         */
        NORMAL,
        /**
         * The spell is an epic spell.
         */
        EPIC,
        /**
         * The spell is a psionic power.
         */
        PSIONIC,
        /**
         * The spell is a truename utterance.
         */
        UTTERANCE,
        /**
         * The spell is an invocation.
         */
        INVOCATION,
        /**
         * The spell is a maneuver.
         */
        MANEUVER
    }

	/**
     * A switche determinining how errors are handled
     */
    public static boolean tolErr = true;

    /**
     * A boolean determining whether to print icons for the pages or not
     */
    public static boolean icons = false;

    /**
     * A constant signifying Bad StrRef
     */
    public static final String badStrRef = "Bad StrRef";

    /**
     * The container object for general configuration data read from file
     */
    public static Settings settings;// = new Settings();

    /**
     * The file separator, given it's own constant for ease of use
     */
    public static final String fileSeparator = System.getProperty("file.separator");

    /**
     * Array of the settings for currently used language. Index with the LANGDATA_ constants
     */
    public static String[] curLanguageData = null;

    /**
     * Size of the curLanguageData array
     */
    public static final int LANGDATA_NUMENTRIES = 22;
    /**
     * curLanguageData index of the language name
     */
    public static final int LANGDATA_LANGNAME = 0;
    /**
     * curLanguageData index of the name of the dialog.tlk equivalent for this language
     */
    public static final int LANGDATA_BASETLK = 1;
    /**
     * curLanguageData index of the name of the prc8_consortium.tlk equivalent for this language
     */
    public static final int LANGDATA_PRCTLK = 2;
    /**
     * curLanguageData index of the name of the "All Feats" string equivalent for this language
     */
    public static final int LANGDATA_ALLFEATSTXT = 3;
    /**
     * curLanguageData index of the name of the "All Epic Feats" string equivalent for this language
     */
    public static final int LANGDATA_ALLEPICFEATSTXT = 4;
    /**
     * curLanguageData index of the name of the "Feats" string equivalent for this language
     */
    public static final int LANGDATA_FEATSTXT = 5;
    /**
     * curLanguageData index of the name of the "Epic Feats" string equivalent for this language
     */
    public static final int LANGDATA_EPICFEATSTXT = 6;
    /**
     * curLanguageData index of the name of the "Base Classes" string equivalent for this language
     */
    public static final int LANGDATA_BASECLASSESTXT = 7;
    /**
     * curLanguageData index of the name of the "Prestige Classes" string equivalent for this language
     */
    public static final int LANGDATA_PRESTIGECLASSESTXT = 8;
    /**
     * curLanguageData index of the name of the "Spells" string equivalent for this language
     */
    public static final int LANGDATA_SPELLSTXT = 9;
    /**
     * curLanguageData index of the name of the "Epic Spells" string equivalent for this language
     */
    public static final int LANGDATA_EPICSPELLSTXT = 10;
    /**
     * curLanguageData index of the name of the "Psionic Powers" string equivalent for this language
     */
    public static final int LANGDATA_PSIONICPOWERSTXT = 11;
    /**
     * curLanguageData index of the name of the "Modified Spells" string equivalent for this language
     */
    public static final int LANGDATA_MODIFIEDSPELLSTXT = 12;
    /**
     * curLanguageData index of the name of the "Domains" string equivalent for this language
     */
    public static final int LANGDATA_DOMAINSTXT = 13;
    /**
     * curLanguageData index of the name of the "Skills" string equivalent for this language
     */
    public static final int LANGDATA_SKILLSTXT = 14;
    /**
     * curLanguageData index of the name of the "Races" string equivalent for this language
     */
    public static final int LANGDATA_RACESTXT = 15;
    /**
     * curLanguageData index of the name of the "Spellbook" string equivalent for this language
     */
    public static final int LANGDATA_SPELLBOOKTXT = 16;
    /**
     * curLanguageData index of the name of the "Powers" string equivalent for this language
     */
    public static final int LANGDATA_POWERTXT = 17;
    /**
     * curLanguageData index of the name of the "Truename Utterances" string equivalent for this language
     */
    public static final int LANGDATA_TRUENAMEUTTERANCETXT = 18;
    /**
     * curLanguageData index of the name of the "Invocations" string equivalent for this language
     */
    public static final int LANGDATA_INVOCATIONTXT = 19;
    /**
     * curLanguageData index of the name of the "Maneuvers" string equivalent for this language
     */
    public static final int LANGDATA_MANEUVERTXT = 20;
    /**
     * curLanguageData index of the name of the "Utterances" string equivalent for this language
     */
    public static final int LANGDATA_UTTERANCETXT = 21;


    /**
     * Current language name
     */
    public static String curLanguage = null;

    /**
     * The base path.                  <code>"manual" + fileSeparator + curLanguage + fileSeparator</code>
     */
    public static String mainPath = null;
    /**
     * The path to content directory.  <code>mainPath + "content" + fileSeparator</code>
     */
    public static String contentPath = null;
    /**
     * The path to menu directory.     <code>mainPath + "mainPath" + fileSeparator</code>
     */
    public static String menuPath = null;
    /**
     * The path to the image directory. <code>"manual" + fileSeparator + "images" + fileSeparator</code>
     */
    public static String imagePath = "manual" + fileSeparator + "images" + fileSeparator;

    /**
     * Data structures for accessing TLKs
     */
    public static TwoDAStore twoDA;
    /**
     * Data structures for accessing TLKs
     */
    public static TLKStore tlk;


    /**
     * The template files
     */
    public static String babAndSavthrTableHeaderTemplate = null,
            classTemplate = null,
            classTablesEntryTemplate = null,
            domainTemplate = null,
            featTemplate = null,
            mFeatTemplate = null,
            menuTemplate = null,
            menuItemTemplate = null,
            prereqANDFeatHeaderTemplate = null,
            prereqORFeatHeaderTemplate = null,
            raceTemplate = null,
            spellTemplate = null,
            skillTableHeaderTemplate = null,
            skillTemplate = null,
            successorFeatHeaderTemplate = null,
            iconTemplate = null,
            listEntrySetTemplate = null,
            listEntryTemplate = null,
            alphaSortedListTemplate = null,
            requiredForFeatHeaderTemplate = null,
            pageLinkTemplate = null,
            featMenuTemplate = null,
            spellSubradialListTemplate = null,
            spellSubradialListEntryTemplate = null,
            classFeatTableTemplate = null,
            classFeatTableEntryTemplate = null,
            classMagicTableTemplate = null,
            classMagicTableEntryTemplate = null,
            craftTemplate = null;


    /* Data structures to store generated entry data in */
    public static HashMap<Integer, SpellEntry> spells;
    public static HashMap<Integer, FeatEntry> masterFeats,
            feats;
    public static HashMap<Integer, ClassEntry> classes;
    public static HashMap<Integer, DomainEntry> domains;
    public static HashMap<Integer, RaceEntry> races;
    public static HashMap<Integer, GenericEntry> skills;

    public static HashMap<Integer, GenericEntry> craft_armour;
    public static HashMap<Integer, GenericEntry> craft_weapon;
    public static HashMap<Integer, GenericEntry> craft_ring;
    public static HashMap<Integer, GenericEntry> craft_wondrous;

    /**
     * Map of psionic power names to the indexes of the spells.2da entries chosen to represent the power in question
     */
    public static HashMap<String, Integer> psiPowMap;

    /**
     * Map of truenaming utterance names to the spells.2da indexes that contain utterance feat-linked entries
     */
    public static HashMap<String, Integer> utterMap;

    /**
     * Map of invocations to spells.2da
     */
    public static HashMap<String, Integer> invMap;

    /**
     * Map of maneuvers to spells.2da
     */
    public static HashMap<String, Integer> maneuverMap;


    /**
     * Ye olde maine methode
     *
     * @param args
     */
    public static void main(String[] args) {
        /* Argument parsing */
        for (String opt : args) {
            if (opt.equals("--help"))
                readMe();

            if (opt.startsWith("-")) {
                if (opt.contains("a"))
                    tolErr = true;
                if (opt.contains("q")) {
                    verbose = false;
                    spinner.disable();
                }
                if (opt.contains("i"))
                    icons = true;
                if (opt.contains("s"))
                    spinner.disable();
                if (opt.contains("?"))
                    readMe();
            }
        }

        // Load the settings
        settings = new Settings();

        // Initialize the 2da container data structure
        twoDA = new TwoDAStore();


        // Print the manual files for each language specified
        for (int i = 0; i < settings.languages.size(); i++) {
            // Set language, path and load TLKs
            curLanguageData = settings.languages.get(i);
            curLanguage = curLanguageData[LANGDATA_LANGNAME];
            mainPath = "manual" + fileSeparator + curLanguage + fileSeparator;
            contentPath = mainPath + "content" + fileSeparator;
            menuPath = mainPath + "menus" + fileSeparator;

            // If we fail on a language, skip to next one
            try {
                tlk = new TLKStore(curLanguageData[LANGDATA_BASETLK], curLanguageData[LANGDATA_PRCTLK]);
            } catch (TLKReadException e) {
                err_pr.println("Error: Failure while reading TLKs for language: " + curLanguage + ":\n" + e);
                continue;
            }

            // Skip to next if there is any problem with directories or templates
            if (!(readTemplates() && buildDirectories())) continue;

            // Do the actual work
            createPages(twoDA);
            createMenus();
        }

        // Wait for the image conversion to finish before exiting main
        if (Icons.executor != null) {
            Icons.executor.shutdown();
            try {
                Icons.executor.awaitTermination(120, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                err_pr.println("Error: Interrupted while waiting for image conversion to finish");
            } finally {
                System.exit(0);
            }
        }
    }

    /**
     * Prints the use instructions for this program and kills execution.
     */
    private static void readMe() {
        System.out.println("Usage:\n" +
                "  java prc/autodoc/Main [--help][-aiqs?]\n" +
                "\n" +
                "-a     forces aborting printing on errors\n" +
                "-i     adds icons to pages\n" +
                "-q     quiet mode. Does not print any progress info, only failure messages\n" +
                "-s     disable the spinner. Useful when logging to file\n" +
                "\n" +
                "--help prints this info you are reading\n" +
                "-?     see --help\n"
        );
        System.exit(0);
    }

    /**
     * Reads all the template files for the current language.
     *
     * @return <code>true</code> if all the reads succeeded, <code>false</code> otherwise
     */
    private static boolean readTemplates() {
        String templatePath = Paths.get("templates", curLanguage).toAbsolutePath().toString();

        try {
            babAndSavthrTableHeaderTemplate = readTemplate(Paths.get(templatePath, "babNsavthrtableheader.html").toAbsolutePath().toString());
            classTablesEntryTemplate = readTemplate(Paths.get(templatePath, "classtablesentry.html").toAbsolutePath().toString());
            classTemplate = readTemplate(Paths.get(templatePath, "class.html").toAbsolutePath().toString());
            domainTemplate = readTemplate(Paths.get(templatePath, "domain.html").toAbsolutePath().toString());
            featTemplate = readTemplate(Paths.get(templatePath, "feat.html").toAbsolutePath().toString());
            mFeatTemplate = readTemplate(Paths.get(templatePath, "masterfeat.html").toAbsolutePath().toString());
            menuTemplate = readTemplate(Paths.get(templatePath, "menu.html").toAbsolutePath().toString());
            menuItemTemplate = readTemplate(Paths.get(templatePath, "menuitem.html").toAbsolutePath().toString());
            prereqANDFeatHeaderTemplate = readTemplate(Paths.get(templatePath, "prerequisiteandfeatheader.html").toAbsolutePath().toString());
            prereqORFeatHeaderTemplate = readTemplate(Paths.get(templatePath, "prerequisiteorfeatheader.html").toAbsolutePath().toString());
            raceTemplate = readTemplate(Paths.get(templatePath, "race.html").toAbsolutePath().toString());
            spellTemplate = readTemplate(Paths.get(templatePath, "spell.html").toAbsolutePath().toString());
            skillTableHeaderTemplate = readTemplate(Paths.get(templatePath, "skilltableheader.html").toAbsolutePath().toString());
            skillTemplate = readTemplate(Paths.get(templatePath, "skill.html").toAbsolutePath().toString());
            successorFeatHeaderTemplate = readTemplate(Paths.get(templatePath, "successorfeatheader.html").toAbsolutePath().toString());
            iconTemplate = readTemplate(Paths.get(templatePath, "icon.html").toAbsolutePath().toString());
            listEntrySetTemplate = readTemplate(Paths.get(templatePath, "listpageentryset.html").toAbsolutePath().toString());
            listEntryTemplate = readTemplate(Paths.get(templatePath, "listpageentry.html").toAbsolutePath().toString());
            alphaSortedListTemplate = readTemplate(Paths.get(templatePath, "alphasorted_listpage.html").toAbsolutePath().toString());
            requiredForFeatHeaderTemplate = readTemplate(Paths.get(templatePath, "reqforfeatheader.html").toAbsolutePath().toString());
            pageLinkTemplate = readTemplate(Paths.get(templatePath, "pagelink.html").toAbsolutePath().toString());
            featMenuTemplate = readTemplate(Paths.get(templatePath, "featmenu.html").toAbsolutePath().toString());
            spellSubradialListTemplate = readTemplate(Paths.get(templatePath, "spellsubradials.html").toAbsolutePath().toString());
            spellSubradialListEntryTemplate = readTemplate(Paths.get(templatePath, "spellsubradialsentry.html").toAbsolutePath().toString());
            classFeatTableTemplate = readTemplate(Paths.get(templatePath, "classfeattable.html").toAbsolutePath().toString());
            classFeatTableEntryTemplate = readTemplate(Paths.get(templatePath, "classfeattableentry.html").toAbsolutePath().toString());
            classMagicTableTemplate = readTemplate(Paths.get(templatePath, "classmagictable.html").toAbsolutePath().toString());
            classMagicTableEntryTemplate = readTemplate(Paths.get(templatePath, "classmagictableentry.html").toAbsolutePath().toString());
            craftTemplate = readTemplate(Paths.get(templatePath, "craftprop.html").toAbsolutePath().toString());
        } catch (IOException e) {
            return false;
        }
        return true;
    }

    /**
     * Reads the template file given as parameter and returns a string with it's contents
     * Kills execution if any operations fail.
     *
     * @param filePath string representing the path of the template file
     * @return the contents of the template file as a string
     * @throws IOException if the reading fails
     */
    private static String readTemplate(String filePath) throws IOException {
        try {
            Scanner reader = new Scanner(new File(filePath));
            StringBuffer temp = new StringBuffer();

            while (reader.hasNextLine()) temp.append(reader.nextLine() + "\n");

            return temp.toString();
        } catch (Exception e) {
            err_pr.println("Error: Failed to read template file:\n" + e);
            throw new IOException();
        }
    }

    /**
     * Creates the directory structure for the current language
     * being processed.
     *
     * @return <code>true</code> if all directories are successfully created,
     * <code>false</code> otherwise
     */
    private static boolean buildDirectories() {
        String dirPath = mainPath + "content";

        boolean toReturn = buildDir(dirPath);
        dirPath += fileSeparator;

        toReturn = toReturn
                && buildDir(dirPath + "base_classes")
                && buildDir(dirPath + "class_epic_feats")
                && buildDir(dirPath + "class_feats")
                && buildDir(dirPath + "domains")
                && buildDir(dirPath + "epic_feats")
                && buildDir(dirPath + "epic_spells")
                && buildDir(dirPath + "feats")
                && buildDir(dirPath + "itemcrafting")
                && buildDir(dirPath + "master_feats")
                && buildDir(dirPath + "prestige_classes")
                && buildDir(dirPath + "psionic_powers")
                && buildDir(dirPath + "races")
                && buildDir(dirPath + "skills")
                && buildDir(dirPath + "spells")
                && buildDir(dirPath + "utterances")
                && buildDir(dirPath + "invocations")
                && buildDir(dirPath + "maneuvers")

                && buildDir(mainPath + "menus");

        System.gc();

        return toReturn;
    }

    /**
     * Does the actual work of building the directories
     *
     * @param path the target directory to create
     * @return <code>true</code> if the directory was already present or was successfully created,
     * <code>false</code> otherwise
     */
    private static boolean buildDir(String path) {
        File builder = new File(path);
        if (!builder.exists()) {
            if (!builder.mkdirs()) {
                err_pr.println("Error: Failure creating directory:\n" + builder.getPath());
                return false;
            }
        } else {
            if (!builder.isDirectory()) {
                err_pr.println(builder.getPath() + " already exists as a file!");
                return false;
            }
        }
        return true;
    }


    /**
     * Replaces each line break in the given TLK entry with
     * a line break followed by <code>&lt;br /&gt;</code>.
     *
     * @param toHTML tlk entry to convert
     * @return the modified string
     */
    public static String htmlizeTLK(String toHTML) {
        return toHTML.replaceAll("\n", "\n<br />");
    }

    /**
     * Creates a new file at the given <code>path</code>, erasing previous file if present.
     * Prints the given <code>content</code> string into the file.
     *
     * @param path    the path of the file to be created
     * @param content the string to be printed into the file
     * @throws PageGenerationException if one of the file operations fails
     */
    public static void printPage(String path, String content) {
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
            writer.write(content);
            // Clean up
            writer.flush();
            writer.close();
        } catch (IOException e) {
            throw new PageGenerationException("IOException when printing " + path, e);
        }
    }


    /**
     * Page creation. Calls all the specific functions for different page types
     */
    private static void createPages(TwoDAStore twoDA) {
        /* First, do the pages that do not require linking to other pages */
        doSkills();
        doCrafting();
        listPsionicPowers(twoDA);
        listTruenameUtterances(twoDA);
        listInvocations(twoDA);
        listManeuvers(twoDA);
        doSpells();

        /* Then, build the feats */
        preliMasterFeats();
        preliFeats();
        linkFeats();

        /* Last, domains, races and classes, which all link to the previous */
        doDomains();
        doRaces();
        doClasses();

        /* Then, print all of it */
        printSkills();
        printSpells();
        printFeats();
        printDomains();
        printRaces();
        printClasses();
        printCrafting();
    }

    /**
     * Menu creation. Calls the specific functions for different menu types
     */
    private static void createMenus() {
        /* First, the types that do not need any extra data beyond name & path
         * and use GenericEntry
         */
        doGenericMenu(skills, curLanguageData[LANGDATA_SKILLSTXT], "manual_menus_skills.html");
        doGenericMenu(domains, curLanguageData[LANGDATA_DOMAINSTXT], "manual_menus_domains.html");
        doGenericMenu(races, curLanguageData[LANGDATA_RACESTXT], "manual_menus_races.html");
        doGenericMenu(craft_armour, curLanguageData[LANGDATA_SKILLSTXT], "manual_menus_craft_armour.html");
        doGenericMenu(craft_weapon, curLanguageData[LANGDATA_SKILLSTXT], "manual_menus_craft_weapon.html");
        doGenericMenu(craft_ring, curLanguageData[LANGDATA_SKILLSTXT], "manual_menus_craft_ring.html");
        doGenericMenu(craft_wondrous, curLanguageData[LANGDATA_SKILLSTXT], "manual_menus_craft_wondrous.html");
        /* Then the more specialised data where it needs to be split over several
         * menu pages
         */
        doSpellMenus();
        doFeatMenus();
        doClassMenus();
    }
}
