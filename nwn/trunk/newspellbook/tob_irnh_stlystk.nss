/*
   ----------------
   Steely Strike

   tob_irnh_stlystk
   ----------------

   29/03/07 by Stratovarius
*/ /** @file

    Steely Strike

    Iron Heart (Strike)
    Level: Warblade 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creatures
    Duration: 1 Round.

    You focus yourself for a single, accurate, shrugging off your opponent's blows
    and ignoring the need for defense as you make your assault.
    
    Make a single attack with a +4 bonus on the attack roll. All other opponents than 
    the one you struck get a +4 bonus to hit you for one round.
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
    	effect eNone;
	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 4, 0, 0, "Steely Strike Hit", "Steely Strike Miss"));
        effect eLink =                          EffectACDecrease(4);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
	       eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);
        // Target that was attacked gets no bonus against you
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(4), oTarget, 6.0);
    }
}