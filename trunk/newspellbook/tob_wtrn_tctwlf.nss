/*
   ----------------
   Tactics of the Wolf

   tob_wtrn_tctwlf.nss
   ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Tactics of the Wolf

    White Raven (Stance)
    Level: Crusader 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: 10ft. 
    Area: 10 ft radius centred on you.
    Duration: Stance.

    You shout orders that help coordinate your allies's efforts. They harass their
    enemies, shield each other from attacks. and otherwise maximize the support they lend to each other.
    
    All allies gain a bonus while flanking equal to +1/2 per your initiator level. 
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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_TACTICS_WOLF)), oTarget);
    }
}