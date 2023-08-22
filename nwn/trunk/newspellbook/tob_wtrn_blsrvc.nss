/*
   ----------------
   Bolstering Voice

   tob_wtrn_blsrvc.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Bolstering Voice

    White Raven (Stance)
    Level: Crusader 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: 60ft. 
    Area: 60 ft radius centred on you.
    Duration: Stance.

    Your clarion voice strengthens the will of your comrades. So long
    as you remain on the field of battle, your allies are strengthened against
    attacks and effects that seek to subvert their willpower.
    
    All allies gain a +2 Will save bonus.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_BOLSTERING_VOICE)), oTarget);
    }
}