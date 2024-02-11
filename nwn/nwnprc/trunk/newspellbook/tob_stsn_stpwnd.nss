/*
   ----------------
   Step of the Wind

   tob_stsn_stpwnd.nss
   ----------------

    31/03/07 by Stratovarius
*/ /** @file

    Step of the Wind

    Setting Sun (Stance)
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You walk across rubble and other broken terrain with deceptive ease, allowing you to take
    advantage of your opponents as they struggle to move at full speed.
    
    You become immune to movement speed decreases and being slowed, and gain a +2 bonus
    to attack and a +4 bonus on Bull Rush attempts, both to attack and to defend.
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
       	effect eLink =                          EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
       	       eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
       	       eLink = EffectLinkEffects(eLink, EffectAttackIncrease(2));
       	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
       	       if (GetHasDefensiveStance(oInitiator, DISCIPLINE_SETTING_SUN))
    			eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	       eLink = ExtraordinaryEffect(eLink);
       	       
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);	
    }
}