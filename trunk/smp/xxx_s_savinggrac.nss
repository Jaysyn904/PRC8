/*:://////////////////////////////////////////////
//:: Spell Name Saving Grace
//:: Spell FileName XXX_S_SavingGrac
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 2, Clr 2, Pal 1, Wiz/Sor 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min/level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)
    Source: Various (Endarire)

    The touched creature gains a +2 resistance bonus on all saves.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it says, this is simple, yet effective and probably very balanced.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SAVING_GRACE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // Duration is 1 minute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    // Link effects
    effect eLink = EffectLinkEffects(eSave, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SAVING_GRACE, oTarget);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SAVING_GRACE, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
