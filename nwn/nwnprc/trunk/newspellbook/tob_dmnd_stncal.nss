/*
   ----------------
   Stance of Alacrity

   tob_dmnd_stncal.nss
   ----------------

    11/12/07 by Stratovarius
*/ /** @file

    Stance of Alacrity

    Diamond Mind (Stance)
    Level: Swordsage 8, Warblade 8
    Prerequisite: Three Diamond Mind maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    Your mind and body meld, granting you an edge in combat. You move slightly faster than normal due to a
    combination of confidence, training, and clarity of mind. This slight edge adds up with each action.
    
    You gain the ability to use a second counter each round when in this stance.
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
    	effect eLink = EffectVisualEffect(PSI_DUR_TEMPORAL_ACCELERATION);
    	if (GetHasDefensiveStance(oInitiator, DISCIPLINE_DIAMOND_MIND))
    		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oTarget);
    }
}