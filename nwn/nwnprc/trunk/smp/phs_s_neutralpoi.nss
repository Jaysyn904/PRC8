/*:://////////////////////////////////////////////
//:: Spell Name Neutralize Poison
//:: Spell FileName phs_s_neutralpoi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Removes all poison, and made immune to poison for the rest of the duration.
    10 min/level duration.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Removes:

    - All poison effects
    - Ghoul touch effects (not the paralysis)

    Not got the "remove poison" such as from a spiders attacks, as it is probably
    not possible.

    Also, immunity is automatic, as in NwN, poison isn't too deadly.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_NEUTRALIZE_POISON)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nType, nSpell;

    // 10 turns/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Delcare immunity effects
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImmunity = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eLink = EffectLinkEffects(eCessate, eImmunity);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_NEUTRALIZE_POISON, FALSE);

    // We remove all effect of poison, and some other spell effects too.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        nSpell = GetEffectSpellId(eCheck);
        // Special case spells
        // - Sickening from Ghoul Touch
        if(nSpell == PHS_SPELL_GHOUL_TOUCH)
        {
            // - Removes all but the paralysis.
            if(nType != EFFECT_TYPE_PARALYZE &&
               nType != EFFECT_TYPE_VISUALEFFECT)
            {
                RemoveEffect(oTarget, eCheck);
            }
        }
        // - Remove all poison
        else if(nType == EFFECT_TYPE_POISON)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_NEUTRALIZE_POISON, oTarget);

    // Apply immunity and visual effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
