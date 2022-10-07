/*
   ----------------
   Wind Stride

   tob_dw_wndstrd.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Wind Stride

    Desert Wind (Boost) 
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round.

    A warm breeze swirls about you as you move speedily away.
    
    You gain +10 feet to your move speed.
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
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eFast = EffectMovementSpeedIncrease(150);
	effect eLink = EffectLinkEffects(eFast, eDur);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
    }
}