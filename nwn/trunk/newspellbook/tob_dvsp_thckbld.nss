/*
   ----------------
   Thicket of Blades

   tob_dvsp_thckbld.nss
   ----------------

    15/07/07 by Stratovarius
*/ /** @file

    Thicket of Blades

    Devoted Spirit (Stance)
    Level: Crusader 3
    Prerequisite: One Devoted Spirit maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You maintain a careful guard as you search for any gaps in your opponent's
    awarness. Even the slightest move provokes a stinging counter from you.
    
    Any creature who attempts to move near you provokes an AoO.
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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_THICKET_BLADES)), oTarget);
    }
}