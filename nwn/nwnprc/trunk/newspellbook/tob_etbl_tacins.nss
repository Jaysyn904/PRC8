/*
   ----------------
   Tactical Insight
   tob_etbl_tacins.nss
   ----------------

    10 MAR 09 by GC
*/ /** @file

    Although you may be young by the elves' reckoning,
    your blade guide lends you the experience and wisdom
    of one who has fought battles across countless fields.

    For the rest of your turn, any opponent you hit with
    a melee attack takes a penalty to AC equal to your
    Intelligence bonus (if any) for 1 round.

    If you lose access to your blade guide, you lose
    this ability until it returns.

*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    if (!PreManeuverCastCode())
    {
        // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    
    if(!TakeSwiftAction(oInitiator)) return;
    
    // Blade guide check
    if(GetLocalInt(oInitiator, "ETBL_BladeGuideDead"))
    {
        FloatingTextStringOnCreature("*Cannot use ability without blade guide*", oInitiator, FALSE);
        return;
    }

    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
    effect eNone;

    if(move.bCanManeuver)
    {
        effect eAC;
        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oInitiator);
        if(nInt >= 1) eAC = EffectACDecrease(nInt);
            PerformAttackRound(oTarget, oInitiator, eAC, 6.0, 0, 0, 0, FALSE, "Tactical Insight: Hit!", "Tactical Insight: Miss!", FALSE, FALSE, TRUE);

    // Expend ability
    SetLocalInt(oInitiator, "ETBL_Tactical_Insight_Expended", TRUE);
    }
}