/*:://////////////////////////////////////////////
//:: Spell Name Touch of Idiocy
//:: Spell FileName PHS_S_TouchIdioc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    1d6 penalty to Int, Wis and Cha. Living creature needs to be touched. SR
    applies. 10 min/level duration. Mind affecting spell. Touch range.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Very simple :-) But effective.
    1d6 to int, wis and cha.

    Game will enforce the minimums, of course.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_TOUCH_OF_IDIOCY)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // 10 Min/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Work out amounts for each one. Each one is seperate, and does
    // metamagic seperatly!
    int nIntPenalty = PHS_MaximizeOrEmpower(6, 1, nMetaMagic);
    int nChaPenalty = PHS_MaximizeOrEmpower(6, 1, nMetaMagic);
    int nWisPenalty = PHS_MaximizeOrEmpower(6, 1, nMetaMagic);

    // Declare Effects
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nIntPenalty);
    effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, nChaPenalty);
    effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, nWisPenalty);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eInt);
    eLink = EffectLinkEffects(eLink, eCha);
    eLink = EffectLinkEffects(eLink, eWis);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_TOUCH_OF_IDIOCY);

    // Apply VFX (hit or not)
    PHS_ApplyTouchVisual(oTarget, VFX_IMP_DAZED_S, nTouch);

    // Melee touch attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
    {
        // Must check reaction type for PvP
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check spell resistance and immunities.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply VFX Impact and negative ability effect
                PHS_ApplyDuration(oTarget, eLink, fDuration);
            }
        }
    }
}
