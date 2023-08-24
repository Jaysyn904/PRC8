/*
   ----------------
   Dance of the Spider

   tob_sdhd_dncspdr
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Dance of the Spider

    Shadow Hand (Stance)
    Level: Swordsage 3
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You
    Duration: Stance

    Black, shadowy energy covers your hands and feet, giving you a touch
    of the grace and skill of the spider.
    
    You become immune to the web spell and poison.
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
       	effect 	eLink = EffectVisualEffect(PSI_DUR_SHADOW_BODY);
       		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
       		eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_WEB));

       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}

