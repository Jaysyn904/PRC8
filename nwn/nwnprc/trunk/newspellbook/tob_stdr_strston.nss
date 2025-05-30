//////////////////////////////////////////////////
// Strength of Stone
// tob_stdr_strston.nss
// Tenjac  9/12/07
//////////////////////////////////////////////////
/** @file Strength of Stone
Stone Dragon (Stance)
Level: Crusader 8, swordsage 8, warblade 8
Prerequisite: Three Stone Dragon maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

You enter an impenetrable defensive stance, making it almost impossible for an attack to 
strike you in a vulnerable area.

While you are in this stance, you focus your efforts on preventing any devastating attacks from 
penetrating your defenses. You are immune to critical hits while you are in this stance.

This stance immediately ends if you move more than 5 feet for any reason, such as from a 
bull rush attack, a telekinesis spell, and so forth.
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
		effect eLink = EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT);

		if (GetHasDefensiveStance(oInitiator, DISCIPLINE_STONE_DRAGON))    
		{
			eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2));
		}

		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
		
		eLink = ExtraordinaryEffect(eLink);

		InitiatorMovementCheck(oInitiator, move.nMoveId, 5.0);

		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);        
	}
}