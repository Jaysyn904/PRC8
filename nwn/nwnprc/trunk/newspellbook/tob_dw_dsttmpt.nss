/*
   ----------------
   Desert Tempest

   tob_dw_dsttmpt.nss
   ----------------

    29/10/07 by Stratovarius
*/ /** @file

    Desert Tempest

    Desert Wind (Strike)
    Level: Swordsage 6
    Prerequisite: Two Desert Wind maneuvers
    Initiation Action: 1 Full-round Action
    Range: Personal
    Target: You
    Duration: 1 round.

    You move in a blur, leaving scorch marks in your wake as you twirl around 
    the battlefield, slicing into your foes as you move.
    
    Move up to your speed. Each time you move next to an enemy, make a single melee attack against him.
    No enemy can be struck more than once. 
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

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_DESERT_TEMPEST)), oTarget, 6.0);
    }
}