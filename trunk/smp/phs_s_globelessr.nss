/*:://////////////////////////////////////////////
//:: Spell Name Globe of Invulnerability, Lesser
//:: Spell FileName PHS_S_GlobeLessr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    3rd level spells and lower are stopped. 1 round/level. Caster is target.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    3rd or lower spells.

    As normal Globe, of course. :-) 3rd not 4th.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GLOBE_OF_INVUNRABILITY_LESSER)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eGlobe = EffectSpellLevelAbsorption(3, 0, SPELL_SCHOOL_GENERAL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
    // Link Effects
    effect eLink = EffectLinkEffects(eGlobe, eCessate);
    eLink = EffectLinkEffects(eLink, eDur);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GLOBE_OF_INVUNRABILITY_LESSER, FALSE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_GLOBE_OF_INVUNRABILITY_LESSER, oTarget);

    // Apply effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
