/*:://////////////////////////////////////////////
//:: Spell Name Displacement
//:: Spell FileName PHS_S_Displacemt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 3, Sor/Wiz 3
    Components: V, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject of this spell appears to be about 2 feet away from its true
    location (not visibally in NwN). The creature benefits from 50% concealment
    as if it had total concealment. However, unlike actual total concealment,
    displacement does not prevent enemies from targeting the creature normally.

    Material Component: A small strip of leather twisted into a loop.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I don't think I can get it so True Seeing pierces this, nor the right
    visual effect.

    Can apply the 50% concealment fine.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DISPLACEMENT)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eMiss = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(SPELL_MAGE_ARMOR);
    // Link
    effect eLink = EffectLinkEffects(eMiss, eCessate);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISPLACEMENT, FALSE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DISPLACEMENT, oTarget);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
