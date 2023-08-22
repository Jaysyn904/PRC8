/*
   ----------------
   Punishing Stance

   tob_irnh_pnshstn
   ----------------

   29/03/07 by Stratovarius
*/ /** @file

    Punishing Stance

    Iron Heart (Stance)
    Level: Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance

    You chop down violently with your weapon, lending extra force to your blows.
    These attacks comes at a cost, as your enemies slash at your undefended legs and flanks.
    
    You deal an extra 1d6 damage with melee attacks, but take a -2 AC penalty.
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
       	effect eLink =                          EffectACDecrease(2);
       	       eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1d6));
       	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
		if (GetLocalInt(oInitiator, "KamateStance"))  eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, GetLocalInt(oInitiator, "KamateStance")));       	       
       	       
       	       eLink = ExtraordinaryEffect(eLink);
       	       
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}