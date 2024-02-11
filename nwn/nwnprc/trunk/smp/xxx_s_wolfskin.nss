/*:://////////////////////////////////////////////
//:: Spell Name Wolfskin
//:: Spell FileName XXX_S_Wolfskin
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 2, Rgr 3
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 minute/level (D)
    Saving Throw: None
    Spell Resistance: No (harmless)
    Source: Various (WotC)

    You take the shape of a normal wolf as if you had the wild shape ability of
    a 5th-level druid.

    Focus: The skin of a wolf, dire wolf, werewolf, worg, or winter wolf. The
    skin melds with your body while the spell is in  effect, and it returns to
    normal when you assume your own shape.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can even use Bioware's own defined Wolf for the Wild Shape ability for this,
    which is nice.

    It is not instant - it can still be dispelled normally, well, I interpert
    it that way.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!SMP_SpellHookCheck(SMP_SPELL_WOLFSKIN)) return;

    // Check focus component - Wolf Skin
    if(!SMP_ComponentFocusItem(SMP_ITEM_WOLFSKIN, "Wolfskin", "Wolfskin")) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Get duration - 1 minute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect eWolf = EffectPolymorph(POLYMORPH_TYPE_WOLF);// * Same as from nw_s2_wildshape

    // Signal Spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_WOLFSKIN, FALSE);

    // Apply polymorph
    SMP_ApplyPolymorphDurationAndVFX(oTarget, eVis, eWolf, fDuration);
}
