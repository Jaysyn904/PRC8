/*
   ----------------
   War Master's Charge

   tob_wtrn_warmtrc.nss
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    War Master's Charge

    White Raven (Strike)
    Level: Crusader 9, Warblade 9
    Prerequisite: Four White Raven maneuvers
    Initiation Action: 1 full-round action
    Range: Melee Attack; see text
    Target: One Creature; see text

    With a great battle cry, you lead your allies in a devastating charge. Fired by your commanding
    presence and deftly lead by your supreme grasp of tactics, you and your allies form an unstoppable wedge.
    
    You and all melee allies within 30 feet of you charge the target. All those who attack gain a +2 bonus
    to attack per ally charging. You deal an extra 50 damage, and your allies deal an extra 25. If you strike
    the foe, he is stunned for one round. Your and your allies do not block one another while charging.
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
	    location lTarget = GetLocation(oInitiator);
	    int nBonus = 0;
	    // Loop the allies to get the bonus
       	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
       	while(GetIsObjectValid(oAreaTarget))
       	{
       	    // Get Allies
       	    if(GetIsFriend(oAreaTarget, oInitiator))
       	    {
       	    	// Loop up, count the bonus
       	    	nBonus += 2;
       	    }

       	    //Select the next target within the spell shape.
       	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
       	}
       	
       	// Now, loop allies to attack the target. You attack last.
       	oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
       	while(GetIsObjectValid(oAreaTarget))
       	{
       	    // Get Allies, only affect melee guys (BAB >= 3/4 Hit Dice)
       	    int nHD = FloatToInt((GetHitDice(oAreaTarget) * 0.75));
       	    if(GetIsFriend(oAreaTarget, oInitiator) && (GetBaseAttackBonus(oAreaTarget) >= nHD) && oAreaTarget != oInitiator)
       	    {
       	    	// Effect Ghost to prevent blocking one another
       	    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectCutsceneGhost()), oAreaTarget, 6.0);
       	    	// Now the charge
       	    	DoCharge(oAreaTarget, oTarget, TRUE, FALSE, 25, -1, FALSE, 0, FALSE, FALSE, nBonus);
       	    }

       	    //Select the next target within the spell shape.
       	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
       	} 
        
        // Now the Charge. Post-charge effects are handled in prc_inc_combmove
	    DoCharge(oInitiator, oTarget, TRUE, FALSE, 50, -1, FALSE, 0, FALSE, FALSE, nBonus);
    }
}


