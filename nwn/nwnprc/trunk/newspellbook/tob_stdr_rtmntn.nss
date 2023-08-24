/*
    ----------------
    Roots of the Mountain

    tob_stdr_rtmntn
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Roots of the Mountain

    Stone Dragon (Stance)
    Level: Crusader 3, Swordsage 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You crouch and set your feet flat on the ground, rooting yourself to the spot you stand. Nothing can move you from this place.
    
    You gain a +10 bonus on all ability checks for grapples, trips, overruns and bull rushes. Any creature that attempts
    to move past you gains a -10 penalty to Tumble, and you gain DR 2/-.
    This stance ends if you move more than 5 feet for any reason.
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
       	effect eLink =                          EffectAreaOfEffect(AOE_PER_ROOT_MOUNTAIN);
       	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
       	       eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    2));
	       eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    2));
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 2));    
       	       if (GetHasDefensiveStance(oInitiator, DISCIPLINE_STONE_DRAGON))
    		   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	       eLink = ExtraordinaryEffect(eLink);
       	       
       	InitiatorMovementCheck(oInitiator, move.nMoveId);

       	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}