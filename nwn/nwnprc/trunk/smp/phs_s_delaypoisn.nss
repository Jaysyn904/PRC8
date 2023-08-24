/*:://////////////////////////////////////////////
//:: Spell Name Delay Poison
//:: Spell FileName PHS_S_DelayPoisn
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Brd 2, Clr 2, Drd 2, Pal 2, Rgr 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 hour/level
    Saving Throw: Fortitude negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject becomes temporarily immune to poison. Delay poison does not cure
    any damage that poison may have already done.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy peasy.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_DELAY_POISON)) return;

    // Declare major varibles
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eImmunity = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eImmunity, eCessate);

    // Remove all previous spell castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DELAY_POISON, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DELAY_POISON, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
