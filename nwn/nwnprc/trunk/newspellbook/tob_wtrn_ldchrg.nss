/*
   ----------------
   Leading the Charge

   tob_wtrn_ldchrg.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Leading the Charge

    White Raven (Stance)
    Level: Crusader 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: 60ft. 
    Area: 60 ft radius centred on you.
    Duration: Stance.

    You fire the confidence and martial spirit of your allies,
    giving them the energy and bravery needed to make a devastating charge
    against your enemies.
    
    All allies gain a +1 damage bonus on charge attacks per initiator level. 
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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_LEADING_CHARGE)), oTarget);
    }
}