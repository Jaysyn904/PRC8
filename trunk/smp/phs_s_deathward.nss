/*:://////////////////////////////////////////////
//:: Spell Name Death Ward
//:: Spell FileName PHS_S_DeathWard
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Target needs to be a living creature touched. Duration: 1 min./level.

    The subject is immune to all death spells, magical death effects, energy
    drain, and any negative energy effects. This spell doesn’t remove negative
    levels that the subject has already gained.

    Death ward does not protect against other sorts of attacks even if those
    attacks might be lethal.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_DEATH_WARD)) return;

    // Declare major varibles
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eImmunityDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
    effect eImmunityLevels = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eImmunityDeath, eImmunityLevels);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove all previous spell castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DEATH_WARD, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DEATH_WARD, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
