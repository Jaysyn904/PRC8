package prc.autodoc;

/**
 * Data structure for a skill /domain / race / class / whatever that doesn't need
 * the extra fields used for feats & spells & skills
 */
public class GenericEntry implements Comparable<GenericEntry> {
    /**
     * The name of this entry.
     */
    public final String name;

    /**
     * The contents of this entry.
     */
    public final String text;

    /**
     * The path of the icon file attached to this entry.
     */
    public final String iconPath;

    /**
     * The path of the html file that has been written for this entry.
     */
    public final String filePath;

    /**
     * Index of the entry in whichever 2da defines it.
     */
    public final int entryNum;

    /**
     * @param name     Name of the entry
     * @param text     Content of the entry
     * @param iconPath Path of this entry's icon
     * @param filePath Path the generated file will be located in
     * @param entryNum Number of the
     */
    public GenericEntry(String name, String text, String iconPath, String filePath, int entryNum) {
        this.name = name;
        this.text = text;
        this.iconPath = iconPath;
        this.filePath = filePath;
        this.entryNum = entryNum;
    }

    /**
     * Comparable implementation. Uses the name fields for comparison.
     *
     * @param other GenericEntry to compare this one to
     * @return @see java.lang.Comparable#compareTo
     */
    public int compareTo(GenericEntry other) {
        return name.compareTo(other.name);
    }
}