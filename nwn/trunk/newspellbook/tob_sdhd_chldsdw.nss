/*
   ----------------
   Child of Shadow

   tob_sdhd_chldsdw.nss
   ----------------

    31/03/07 by Stratovarius
*/ /** @file

    Child of Shadow

    Shadow Hand (Stance)
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    As you move, shadows flutter and swarm around you. Even under the bright
    desert sun, you are difficult to spot as long as you remain in motion.
    
    If you move more than 10 feet, you gain the effects of concealment.
    This is a supernatural maneuver.
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
	// Apply a marker effect
	effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)); 
	if (GetHasDefensiveStance(oInitiator, DISCIPLINE_SHADOW_HAND))
    		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
       	
       	// This will check for the distance and apply the conceal
       	InitiatorMovementCheck(oInitiator, move.nMoveId);
    }
}