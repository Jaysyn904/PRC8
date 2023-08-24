/*
   ----------------
   Aura of Perfect Order
   
   tob_dvsp_prford.nss
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Aura of Perfect Order

    Devoted Spirit (Stance)
    Level: Crusader 6
    Prerequisite: Two Devoted Spirit Maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    A perfect, hazy square of golden energy surrounds you as you enter this stance
    
    Whenever you initiate a strike, your attack roll is always 11.
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
	SetLocalInt(oInitiator, "DSPerfectOrder", TRUE);
        effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
    }
}