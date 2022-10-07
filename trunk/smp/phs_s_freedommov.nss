/*:://////////////////////////////////////////////
//:: Spell Name Freedom of Movement
//:: Spell FileName phs_s_freedommov
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    1 creature touched. 10 min/level duration.
    It removes slow, paralysis, entangle and movement speed decreases caused
    by spells and spell-like effects on the target. It also makes them immune
    to the same.
//:://///////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Almost like 3.5E, apart from no grappling or underwater stuff to worry
    about.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FREEDOM_OF_MOVEMENT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    effect eCheck;
    int nType;

    // Duration is 10 turns/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    effect eParalysis = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eParalysis, eDur);
    eLink = EffectLinkEffects(eLink, eEntangle);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eMove);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FREEDOM_OF_MOVEMENT, FALSE);

    // Remove previous castings of freedom of movement (even if it doesn't stack)
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_FREEDOM_OF_MOVEMENT, oTarget);

    // Remove slow, entangle (web), paralysis, and movement speed decreases.
    eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        if(nType == EFFECT_TYPE_PARALYZE ||
           nType == EFFECT_TYPE_ENTANGLE ||
           nType == EFFECT_TYPE_SLOW ||
           nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }

    // Apply immuntities and visuals.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
