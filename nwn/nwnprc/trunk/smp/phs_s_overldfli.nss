/*:://////////////////////////////////////////////
//:: Spell Name Overland Flight
//:: Spell FileName PHS_S_OverldFli
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like a fly spell, except you can fly much faster, and
    can cover 40 meters in one go. Using a flying spell requires only as much
    concentration as walking, so the subject can just select a point and instantly
    fly there, unless there are inhibiting winds. You can only fly outside,
    above ground.

    Arcane Focus: A wing feather from any bird.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As Fly, except a 40M range, and only targetable on self.

    Fairly simple. Uses a similar "Fly" thing, but a seperate power on the
    class item, as it is a longer range.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_OVERLAND_FLIGHT)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_OVERLAND_FLIGHT, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_OVERLAND_FLIGHT, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
}
