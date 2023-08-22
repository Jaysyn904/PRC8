/*:://////////////////////////////////////////////
//:: Spell Name Ray of Withering
//:: Spell FileName XXX_S_RayofWithe
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Mind-Affecting]
    Level: Sor/Wiz 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes
    Source: Various (schulerta)

    A ray of black energy springs from your hand. You must succeed on a ranged
    touch attack to strike a target. The subject takes a penalty to Fortitude
    Saves equal to 1d4+1.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says.

    Apart from, originally, it was a Gray (or even Grey) ray.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_RAY_OF_WITHERING)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // Touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_RAY, oTarget, TRUE);

    // Duration in minutes
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Amount of save damage. 1d4 +1
    int nDamage = SMP_MaximizeOrEmpower(4, 1, nMetaMagic, 1);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_FORT, nDamage, SAVING_THROW_TYPE_ALL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSave, eCessate);

    // Do ray visuals
    SMP_ApplyTouchBeam(oTarget, VFX_BEAM_BLACK, nTouch);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_RAY_OF_WITHERING);

    // Touch attack
    if(nTouch)
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget) &&
           !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
           !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_SAVING_THROW_DECREASE))
        {
            // Resistance
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Remove previous spell effects (they don't stack anyway)
                SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_RAY_OF_CLUMSINESS, oTarget);

                // Apply effects
                SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
            }
        }
    }
}
