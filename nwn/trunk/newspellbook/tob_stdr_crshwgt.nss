/*
    ----------------
    Crushing Weight of the Mountain

    tob_stdr_crshwgt
    ----------------

    18/08/07 by Stratovarius
*/ /** @file

    Crushing Weight of the Mountain

    Stone Dragon (Stance)
    Level: Crusader 3, Swordsage 3, Warblade 3
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You crush your opponent beneath you, squeezing the life out of him as you pin him to the ground.
    
    While in this stance, once you have successfully initiated a grapple, you may constrict the target for
    2d6 + (1.5 * your strength modifier).
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
    		   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	       eLink = ExtraordinaryEffect(eLink);
       	       
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}