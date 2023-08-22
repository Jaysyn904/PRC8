package prc.autodoc;

import java.util.List;
import java.util.TreeMap;

/**
 * Data structure for a class entry.
 */
public class ClassEntry extends GenericEntry {
    /**
     * If <code>true</code>, this class is a base class.
     */
    public final boolean isBase;

    /**
     * List of BAB and saving throw values. Each list entry consists of the values
     * for the list indexth level. Order: BAB, Fort, Ref, Will.
     */
    public final List<String[]> babSav;

    /**
     * The list of this class's class and cross-class skills. First tuple member
     * cotnaints the class skills, the second cross-class skills.
     * Map keys are skill names.
     */
    public final Tuple<TreeMap<String, GenericEntry>, TreeMap<String, GenericEntry>> skillList;

    /**
     * Lists of this class's granted and selectable feats. First tuple member lists bonus feat
     * # at each level. First inner tuple member is the granted feats, second member is selectable feats.
     * Each list consists of the feats that are related to the list indexth level.
     * The map keys are feat names.
     */
    public final Tuple<List<Integer>, Tuple<List<TreeMap<String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>> featList;

    /**
     * The alternate magic systems available to this class. Each list entry describes one
     * magic system (though there will probably never be more than one per class).
     * First member of the outer tuple is the (magic system name, magic system spell-equivalent name)
     * pair. Second member is a map keyed to spell-equivalent level, with values being maps of
     * spell-equivalent name to the spell entry.
     */
    public final List<Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>> magics;

    /**
     * Create a new class entry.
     *
     * @param name      The name of this class.
     * @param text      The description of this class.
     * @param iconPath  The path of this class's icon.
     * @param filePath  The path of the html file that has been written for this class.
     * @param isBase    If <code>true</code>, this class is a base class.
     * @param entryNum  Index of the class in classes.2da.
     * @param babSav    The BAB and saves of this class.
     * @param skillList The skills of this class.
     * @param featList  The feats of this class.
     * @param magics    The alternate magics of this class.
     */
    public ClassEntry(String name, String text, String iconPath, String filePath,
                      int entryNum, boolean isBase, List<String[]> babSav,
                      Tuple<TreeMap<String, GenericEntry>, TreeMap<String, GenericEntry>> skillList,
                      Tuple<List<Integer>, Tuple<List<TreeMap<String, FeatEntry>>, List<TreeMap<String, FeatEntry>>>> featList,
                      List<Tuple<Tuple<String, String>, TreeMap<Integer, TreeMap<String, SpellEntry>>>> magics) {
        super(name, text, iconPath, filePath, entryNum);
        this.isBase = isBase;
        this.babSav = babSav;
        this.skillList = skillList;
        this.featList = featList;
        this.magics = magics;
    }
}