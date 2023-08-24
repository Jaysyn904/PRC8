/*
   ----------------
   Balance on the Sky

   tob_sdhd_balance.nss
   ----------------

    30/09/18 by Stratovarius
*/ /** @file

    Balance on the Sky

    Shadow Hand (Stance)
    Level: Swordsage 8
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    With arms spread wide, you step onto the air.
    
    You gain the ability to jump any distance at will.
    
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"

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
        effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_GLOW_GREY)); 
	    if (GetHasDefensiveStance(oInitiator, DISCIPLINE_SHADOW_HAND))
    		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
      	
    }
}