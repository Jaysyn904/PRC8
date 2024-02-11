/*
   ----------------
   Aura of Chaos
   
   tob_dvsp_chaos.nss
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Aura of Chaos

    Devoted Spirit (Stance)
    Level: Crusader 6
    Prerequisite: Two Devoted Spirit Maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    A coruscating aura of purple energy surrounds you as chaos
    runs rampant in the area immediately around you.
    
    Whenever you roll maximum damage on your weapon's dice, roll again and add the result. 
    Continue rolling until you no longer roll the maximum.
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
	SetLocalInt(oInitiator, "DSChaos", TRUE);
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
    }
}