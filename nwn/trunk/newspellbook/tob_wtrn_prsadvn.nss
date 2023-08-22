/*
   ----------------
   Press the Advantage

   tob_wtrn_prsadvn.nss
   ----------------

    29/09/07 by Stratovarius
*/ /** @file

    Press the Advantage

    White Raven (Stance)
    Level: Crusader 5, Warblade 5
    Prerequisite: Two White Raven Maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You fire the confidence and martial spirit of your allies,
    giving them the energy and bravery needed to make a devastating charge
    against your enemies.
    
    You gain a 5 foot increase to your land speed.
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
    	effect eLink = EffectLinkEffects(EffectMovementSpeedIncrease(20), EffectVisualEffect(VFX_DUR_SEEN));
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oTarget);
    }
}