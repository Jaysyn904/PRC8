package prc.autodoc;

import java.util.List;
import java.util.TreeMap;

/**
 * Data structure for a feat or masterfeat entry.
 */
public class FeatEntry extends GenericEntry {
    /**
     * A list of masterfeat's children
     */
    public TreeMap<String, FeatEntry> childFeats = new TreeMap<String, FeatEntry>();
    /**
     * A list of feats that have this feat as their prerequisite
     */
    public TreeMap<String, FeatEntry> requiredForFeats = new TreeMap<String, FeatEntry>();
    /**
     * A list of this feat's AND prerequisites
     */
    public TreeMap<String, FeatEntry> andRequirements = new TreeMap<String, FeatEntry>();
    /**
     * A list of this feat's OR prerequisites
     */
    public TreeMap<String, FeatEntry> orRequirements = new TreeMap<String, FeatEntry>();

    /**
     * This feat's masterfeat, if any
     */
    public FeatEntry master;
    /**
     * This feat's successor, if any
     */
    public FeatEntry successor;

    /**
     * Whether this feat is epic, as defined by feat.2da column PreReqEpic. For masterfeats, if any of the children are epic
     */
    public boolean isEpic;
    /**
     * Whether all of a masterfeat's children are epic. This is used to determine which menus a link to it will be printed
     */
    public boolean allChildrenEpic;
    /**
     * Whether the feat is a class-specific feat, as defined by feat.2da column ALLCLASSESCANUSE. For masterfeats, if any of the children are class-specific
     */
    public boolean isClassFeat;
    /**
     * Whether all of a masterfeat's children are class-specific. This is used to determine which menus a link to it will be printed
     */
    public boolean allChildrenClassFeat;
    /**
     * Whether this feat has a successor
     */
    public boolean isSuccessor;

    /**
     * The feat's subradials, if any. List of feat name, icon path tuples.
     */
    public final List<Tuple<String, String>> subradials;

    /**
     * The constructor.
     *
     * @param name        Name of the feat/masterfeat
     * @param text        Description of the feat
     * @param iconPath    Path of the feat's icon
     * @param filePath    Path where the html page for this feat will be written to
     * @param entryNum    feat.2da / masterfeats.2da index
     * @param isEpic      Whether the feat is an epic feat
     * @param isClassFeat Whether the feat is a class-specific feat
     * @param subradials  List of this feat's subradials, if any
     */
    public FeatEntry(String name, String text, String iconPath, String filePath,
                     int entryNum, boolean isEpic, boolean isClassFeat,
                     List<Tuple<String, String>> subradials) {
        super(name, text, iconPath, filePath, entryNum);
        this.isEpic = isEpic;
        this.isClassFeat = isClassFeat;
        this.subradials = subradials;

        master = null;
        successor = null;
        isSuccessor = false;
        allChildrenClassFeat = false;
        allChildrenEpic = false;
    }
}