#include "inc_newspellbook"

void main()
{
    int nOneShotMetamagic;
    if (GetLocalInt(OBJECT_SELF, "PRC_metamagic_state") == 1)
        nOneShotMetamagic = GetLocalInt(OBJECT_SELF, "MetamagicFeatAdjust");

    // NewSpellbookSpell historically clears a valid one-shot before checking
    // that the adjusted tier has a slot, but leaves invalid/level-10 fallback
    // selections armed. Fence that legacy behavior for Sublime Chord: retain
    // the selection on a rejected cast and consume it on an accepted cast.
    if (nOneShotMetamagic)
        DeleteLocalInt(OBJECT_SELF, "NSB_Cast");

    NewSpellbookSpell(CLASS_TYPE_SUBLIME_CHORD, SPELLBOOK_TYPE_SPONTANEOUS);

    if (nOneShotMetamagic)
    {
        if (GetLocalInt(OBJECT_SELF, "NSB_Cast"))
            SetLocalInt(OBJECT_SELF, "MetamagicFeatAdjust", 0);
        else
            SetLocalInt(OBJECT_SELF, "MetamagicFeatAdjust", nOneShotMetamagic);
    }
}
