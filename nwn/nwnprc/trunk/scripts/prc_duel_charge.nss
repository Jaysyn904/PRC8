/*
   ----------------
   Acrobatic Charge

   prc_duel_charge.nss
   ----------------

   Sep 5th, 2018 by Stratovarius

   Charge with freedom of movement.
    
*/

#include "prc_inc_combmove"

void main()
{
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
    effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    //Link effects
    effect eLink = EffectLinkEffects(eParal, eEntangle);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eMove);
    
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0,FALSE,-1,-1);  
    DoCharge(oInitiator, oTarget);
}