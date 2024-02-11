/*
    ----------------
    Burning Brand

    tob_dw_brnbrnd.nss
    ----------------

    05/05/07 by Stratovarius
*/ /** @file

    Flashing Sun

    Desert Wind (Boost)
    Level: Swordsage 2
    Initiation Action: 1 Swift action
    Range: Personal
    Target: You
    Duration: End of Turn

    Your weapon transforms into a roaring gout of flame. As you swing your 
    burning blade, it stretches out beyond your normal reach to scorch your foes.
    
    You take a full attack action, with your reach increasing by 5 feet.
    Your weapon deals fire damage instead of normal damage for this round.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"

void main()
{
    if (!PreManeuverCastCode()) return;

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        // Extra attack during the round
        SetLocalInt(oInitiator, "DWBurningBrand", TRUE);
        effect eNone;
        DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, -2, 0, 0, FALSE, "Burning Brand Hit", "Burning Brand Miss"));
        DelayCommand(6.0, DeleteLocalInt(oInitiator, "DWBurningBrand"));
    }
}