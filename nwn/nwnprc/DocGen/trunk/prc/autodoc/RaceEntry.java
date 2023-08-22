package prc.autodoc;

import java.util.TreeMap;

/**
 * Data structure for a race entry.
 */
public class RaceEntry extends GenericEntry {

    /**
     * A list of masterfeat's children
     */
    public final TreeMap<String, FeatEntry> raceFeats;

    /**
     * The constructor.
     *
     * @param name      Name of the race
     * @param text      Description of the race
     * @param filePath  Path where the html page for this race will be written to
     * @param entryNum  racialtypes.2da index
     * @param raceFeats Racial feat list
     */
    public RaceEntry(String name, String text, String filePath,
                     int entryNum, TreeMap<String, FeatEntry> raceFeats) {
        super(name, text, null, filePath, entryNum);
        this.raceFeats = raceFeats;
    }
}
