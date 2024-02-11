/*
   ----------------
   Shield Block

   tob_dvsp_shldblk
   ----------------

   05/06/07 by Stratovarius
*/ /** @file

    Shield Block

    Devoted Spirit (Counter)
    Level: Crusader 2
    Initiation Action: 1 Immediate Action
    Range: Touch
    Target: One Ally
    Duration: One Attack

    With a heroic burst of effort, you thrust your shield
    between your defenseless ally and your enemy.
    
    Your grant your ally a +4 shield bonus against the next attack made against him.
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
    	effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    	effect eAC = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eAC), oTarget, 3.0);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(eVis), oTarget);
    }
}