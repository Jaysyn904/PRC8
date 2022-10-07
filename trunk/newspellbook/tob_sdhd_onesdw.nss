/*
   ----------------
   One with Shadow
   
   tob_sdhd_onesdw.nss
   ----------------

    Sep 9th 18 by Stratovarius

    One with Shadow

    Shadow Hand (Counter)
    Level: Swordsage 8
    Initiation Action: 1 Immediate Action
    Range: Personal
    Target: You
    Duration: One round

    As an immediate action, you become incorporeal.
*/

#include "tob_inc_move"
#include "tob_movehook"

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
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        SetIncorporeal(oInitiator, 6.0f, 2);
    }
}