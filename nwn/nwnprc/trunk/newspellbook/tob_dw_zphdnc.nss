/*
   ----------------
   Zephyr Dance

   tob_dw_zphdnc
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Zephyr Dance

    Desert Wind (Counter)
    Level: Swordsage 3
    Prerequisite: One Desert Wind Maneuver
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    
    You spin gracefully away from a foe's attack, whirling like the desert
    zephyr racing across the sands. Your enemy's blade barely touches your
    cloak as you nimbly dodge aside.
    
    You gain a +4 bonus to AC versus one attack.
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
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_IMP_WIND), oTarget);
       	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(4), oTarget, 3.0);
    }
}