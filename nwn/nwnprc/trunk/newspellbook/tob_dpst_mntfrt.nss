/*
    ----------------
    Mountain Fortress Stance

    tob_dpst_mntfrt
    ----------------

    27/01/08 by Stratovarius
*/ /** @file

    Mountain Fortress Stance

    Deepstone Sentinel level 1

    You crouch and set your feet flat on the ground, drawing 
    the resilience of the earth into your body.
    
    You gain a +1 bonus to attacks from being on higher ground, and any creature attempting to fight you in
    melee combat must attempt a DC 10 Balance check or fall prone.
    This stance ends if you move more than 5 feet for any reason.
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
       	effect eLink = EffectLinkEffects(EffectAttackIncrease(1), EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
       	       eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(AOE_PER_MOUNTAIN_FORTRESS));
       	       if (GetHasDefensiveStance(oInitiator, DISCIPLINE_STONE_DRAGON))
    		   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	       eLink = ExtraordinaryEffect(eLink);
       	       
       	InitiatorMovementCheck(oInitiator, move.nMoveId);

       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}