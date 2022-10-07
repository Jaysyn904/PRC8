/*
   ----------------
   Law Bearer

   tob_dvsp_lwbrr.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Law Bearer

    Devoted Spirit (Strike) [Law]
    Level: Crusader 5
    Prerequisite: One Devoted Spirit maneuver
    Initiation Action: 1 Full-round action
    Range: Melee
    Target: One creature
    Duration: 1 round

    The air arounds you hums with cosmic energy as the power of pure law surges
    through you. For a moment, you take on the aspect of a perfect being 
    as you charge forward to smite your foes.
    
    You make a charge attack. If the target is chaos aligned, you gain a +8 bonus on your attack
    and 4d6 damage. If it hits, you gain +5 saves and Armour class for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

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
    	int nAtk = 0;
    	int nDam = 0;
    	if (GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC)
    	{
    		nAtk = 8;
    		nDam = d6(4);
    	}
    	
        // Now the Charge. Post-charge effects are handled in prc_inc_combmove
    	DoCharge(oInitiator, oTarget, TRUE, TRUE, nDam, DAMAGE_TYPE_DIVINE, FALSE, 0, FALSE, FALSE, nAtk);
    }
}