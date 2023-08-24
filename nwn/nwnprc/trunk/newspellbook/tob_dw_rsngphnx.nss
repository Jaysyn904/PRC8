/*
   ----------------
   Rising Phoenix
   
   tob_dw_rsngphnx.nss
   ----------------

    01/11/07 by Stratovarius
*/ /** @file

    Rising Phoenix

    Desert Wind (Stance) [Fire]
    Level: Swordsage 8
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance
    
    Hot winds swirl about your feet, lifting you skyward as flames begin to flick below.
    
    You gain freedom of movement. If you make a full attack, the column of air becomes superheated, dealing 3d6 points of fire damage to creatures adjacent to your square. You are not harmed by this effect.
    (Use the feat added).
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
        effect eLink =                          EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));	
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));	
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);
        object oSkin = GetPCSkin(oInitiator);
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RISING_PHOENIX), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}