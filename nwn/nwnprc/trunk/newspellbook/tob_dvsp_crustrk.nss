/*
   ----------------
   Crusader's Strike

   tob_dvsp_crustrk
   ----------------

   28/03/07 by Stratovarius
*/ /** @file

    Crusader's Strike

    Devoted Spirit (Strike)
    Level: Crusader 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Divine power surrounds your weapon as you strike, 
    This power washes over you as your weapon finds its mark,
    mending your wounds and giving you the strength to fight on.

    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you or an ally with 10 feet is healed 1d6 + 1 per
    initiator level (max of +5).
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator, struct maneuver move)
{
    effect eNone;
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Crusader's Strike Hit", "Crusader's Strike Miss");
    if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        if(GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget)
        || GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
        {
            int nHeal = d6() + PRCMin(move.nInitiatorLevel, 5);
            object oHeal = GetCrusaderHealTarget(oInitiator, FeetToMeters(10.0));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_L_LAW), oHeal);
        }
    }
}

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        DelayCommand(0.0, TOBAttack(oTarget, oInitiator, move));
    }
}