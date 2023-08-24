/*:://////////////////////////////////////////////
//:: Spell Name Ray of Enfeeblement
//:: Spell FileName PHS_S_RayofEnfee
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes

    A coruscating ray springs from your hand. You must succeed on a ranged touch
    attack to strike a target. The subject takes a penalty to Strength equal to
    1d6+1 per two caster levels (maximum 1d6+5). The subject’s Strength score
    cannot drop below 1.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the description.

    Touch attack doesn't affect ability "damage".
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RAY_OF_ENFEEBLEMENT)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Amount of strength damage. 1d6, +1/2 caster levels
    int nExtra = PHS_LimitInteger(nCasterLevel/2, 5);// Max of 5

    // Penalty to strength determined
    int nStrength = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, nExtra);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nStrength);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eStr, eCessate);

    // Do ray visuals
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_ODD, nTouch);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RAY_OF_ENFEEBLEMENT);

    // Ray, ranged touch attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell Resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Remove previous spell effects (they don't stack anyway)
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_RAY_OF_ENFEEBLEMENT, oTarget);

                // Apply effects
                PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
            }
        }
    }
}
