/*
   ----------------
   Strike of Righteous Vitality

   tob_dvsp_rghtvt
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Strike of Righteous Vitality

    Devoted Spirit (Strike)
    Level: Crusader 9
    Prerequisite: Three Devoted Spirit maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    As your enemy reels from your mighty blow, an ally nearby is simultaneously healed
    and cleansed of its wounds by the power of your faith.
    
    You make a single attack against an enemy who's alignment has at least one component
    different from yours. If you hit, you or an ally with 10 feet is healed, as per the heal spell.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator, struct maneuver move)
{
    effect eNone;
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Strike of Righteous Vitality Hit", "Strike of Righteous Vitality Miss");
    if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        if(GetAlignmentGoodEvil(oInitiator) != GetAlignmentGoodEvil(oTarget)
        || GetAlignmentLawChaos(oInitiator) != GetAlignmentLawChaos(oTarget))
        {
            int nHeal = 10 * move.nInitiatorLevel;
            // Max for the spell
            if(nHeal > 150) nHeal = 150;
            object oHeal = GetCrusaderHealTarget(oInitiator, FeetToMeters(10.0));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X_LAW), oHeal);
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