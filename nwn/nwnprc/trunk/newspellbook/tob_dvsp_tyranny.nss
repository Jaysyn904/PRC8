/*
   ----------------
   Aura of Tyranny

   tob_dvsp_tyranny.nss
   ----------------

    19/09/07 by Stratovarius
*/ /** @file

    Aura of Tyranny

    Devoted Spirit (Stance)
    Level: Crusader 6
    Prerequisite: Two Devoted Spirit maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    A sickly grey radiance surrounds you, sapping the strength of your allies and funneling it to you.
    
    Each round, you damage all allies within 10 feet 2 hit points, and you heal 1 hit point for each ally struck.
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
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_AURA_TYRANNY)), oTarget);
    }
}