package prc.autodoc;

import java.util.List;

/**
 * Data structure for a domain entry.
 */
public class DomainEntry extends GenericEntry {

    /**
     * This domain's domain power, if any
     */
    public final FeatEntry grantedFeat;
    /**
     * The domain's spells. List of spell entry.
     */
    public final List<SpellEntry> spells;

    /**
     * The constructor.
     *
     * @param name        Name of the domain
     * @param text        Description of the domain
     * @param iconPath    Path of the domain's icon
     * @param filePath    Path where the html page for this domain will be written to
     * @param entryNum    domains.2da index
     * @param grantedFeat Domain power feat
     * @param spells      The domain spells
     */
    public DomainEntry(String name, String text, String iconPath, String filePath,
                       int entryNum, FeatEntry grantedFeat,
                       List<SpellEntry> spells) {
        super(name, text, iconPath, filePath, entryNum);
        this.grantedFeat = grantedFeat;
        this.spells = spells;
    }
}