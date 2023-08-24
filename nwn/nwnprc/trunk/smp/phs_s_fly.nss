/*:://////////////////////////////////////////////
//:: Spell Name Fly
//:: Spell FileName PHS_S_Fly
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 3, Travel 3
    Components: V, S, F/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject can fly from point to point. Using a fly spell requires only as
    much concentration as walking, so the subject can just select a point and
    instantly fly there, unless there are inhibiting winds. You can fly a total
    of 20 meters in one go. You can only fly outside, above ground.

    Arcane Focus: A wing feather from any bird.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    New trigger for "No flying".

    Cannot fly in high-wind areas (local variable on the area too).

    Teleport stuff applies too.

    Flying is 20M range, anyone can be targeted. Overland Flight is 40M range.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FLY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_FLY, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FLY, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
}
