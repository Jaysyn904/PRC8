/*
   ----------------
   Giant Killing Style

   tob_stsn_gntkll
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Giant Killing Style

    Setting Sun (Stance)
    Level: Swordsage 3
    Prerequisite: One Setting Sun maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Stance

    You dart between a giant's legs, lashing at his inner ankles and other vulnerable areas while
    staying inside of his reach where he cannot hope to parry your attacks.
    
    You gain a +2 Attack, +4 Damage boost against creatures larger than you.
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
       	effect 	eLink = EffectAttackIncrease(2);                      
       	       	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_4));
       	       	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SHIELD_OF_FAITH));
       	       	if (GetHasDefensiveStance(oInitiator, DISCIPLINE_SETTING_SUN))
    		   	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
    		eLink = VersusSizeEffect(oInitiator, eLink, 1);
       	       	eLink = ExtraordinaryEffect(eLink);

       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}