package prc.autodoc;

import prc.autodoc.Main.SpellType;

import java.util.List;

/**
 * Data structure for a spell entry.
 */
public class SpellEntry extends GenericEntry {
    /**
     * Type of this spell entry
     */
    public final SpellType type;

    /**
     * The spell's subradials, if any. List of spell name, icon path tuples.
     */
    public final List<Tuple<String, String>> subradials;

    /**
     * The constructor.
     *
     * @param name       Name of the spell
     * @param text       Description of the spell
     * @param iconPath   Path of the spell's icon
     * @param filePath   Path of the html file describing the spell.
     * @param entryNum   spells.2da index
     * @param type       Type of the spell: Normal / Epic / Psionic / whatever
     * @param subradials
     */
    public SpellEntry(String name, String text, String iconPath, String filePath,
                      int entryNum, SpellType type, List<Tuple<String, String>> subradials) {
        super(name, text, iconPath, filePath, entryNum);
        this.type = type;
        this.subradials = subradials;
    }
}