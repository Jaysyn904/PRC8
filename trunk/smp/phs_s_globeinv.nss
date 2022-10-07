/*:://////////////////////////////////////////////
//:: Spell Name Globe of Invulnerability
//:: Spell FileName PHS_S_GlobeInv
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    4th level spells and lower are stopped. 1 round/level. Caster is target.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As lesser, but 4 or lower levels.

    Follows the caster around. Mainly as Bioware one.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GLOBE_OF_INVUNRABILITY)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eGlobe = EffectSpellLevelAbsorption(4, 0, SPELL_SCHOOL_GENERAL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
    // Link Effects
    effect eLink = EffectLinkEffects(eGlobe, eCessate);
    eLink = EffectLinkEffects(eLink, eDur);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GLOBE_OF_INVUNRABILITY, FALSE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_GLOBE_OF_INVUNRABILITY, oTarget);

    // Apply effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
