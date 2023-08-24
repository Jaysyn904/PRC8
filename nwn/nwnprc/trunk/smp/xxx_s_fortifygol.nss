/*:://////////////////////////////////////////////
//:: Spell Name Fortify Golem
//:: Spell FileName XXX_S_FortifyGol
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 4
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One Golem
    Duration: 1 minute/level
    Saving Throw: Fortitude negates (harmless) (object)
    Spell Resistance: No (harmless) (object)
    Source: Various (Israfel666)

    This spell gives a target golem a +4 enhancement bonus to Strength and
    Dexterity, bypassing  any magical immunity the construct may have.

    Material component: an ounce of the material the target golem is mainly made
    of.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not got the material component in yet (although we can do it)

    As it is, its pretty simple. +4 Dexterity, Strength, to a construct-race creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_FORTIFY_GOLEM)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // Duration, 1 minute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eDexterity = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);

    // Link effects
    effect eLink = EffectLinkEffects(eStrength, eCessate);
    eLink = EffectLinkEffects(eLink, eDexterity);

    if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
    {
        // Remove previous castings
        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_FORTIFY_GOLEM, oTarget);

        // Signal event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_FORTIFY_GOLEM, FALSE);

        // Apply effects
        SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
    }
}
