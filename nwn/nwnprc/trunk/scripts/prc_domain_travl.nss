//::///////////////////////////////////////////////
//:: Travel Domain Power
//:: prc_domain_travl.nss
//::///////////////////////////////////////////////
/*
    Grants Freedom of Movement for 1 round a level
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"

void main()
{
    object oTarget = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(PRC_DOMAIN_TRAVEL, oTarget)) return;

    //Declare major variables
    int nDuration = GetHitDice(oTarget);
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
           eLink = SupernaturalEffect(eLink);

    //Search for and remove the above negative effects
    effect eLook = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eLook))
    {
        if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
            GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
            GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
        {
            RemoveEffect(oTarget, eLook);
        }
        eLook = GetNextEffect(oTarget);
    }

    //Apply Linked Effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

