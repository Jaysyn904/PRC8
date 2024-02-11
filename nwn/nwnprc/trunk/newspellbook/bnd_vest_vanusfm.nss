/*
15/03/21 by Stratovarius

Vanus, the Reviled One
  
Hated out of proportion for his sins, the smiling Vanus remains an enigma to binders. Vanus provides binders with the ability to frighten and punish weaker foes, hear evil afoot with uncanny perception, and free allies from constraints.

Vestige Level: 6th
Binding DC: 29
Special Requirement: Vanus refuses to appear when summoned indoors, and will only answer the summoner's call when well away from buildings.

Influence: Under the influence of Vanus, you take every opportunity to revel. Even small victories seem like cause for grand celebrations, and if you’re happy, you want everyone around to share your joy. If you see others in the act of celebration, you must join in. If you achieve victory in combat, you must immediately spend a full-round action crowing about your triumph.

Granted Abilities: 
Vanus grants you tremendous hearing, the ability to foment fear by your presence alone, skill at fighting foes weaker than yourself, and the power to free allies from imprisonment.

Fear Aura: Enemies that you are aware of who come within 10 feet must succeed at a Will save. Those who fail are frightened. 
Foes remain frightened for a number of rounds equal to half your binder level. Creatures that fail the save must roll again if they again come within 10 feet. 
A creature that makes its save against this ability need not make another save for 24 hours. This is a mind-affecting fear effect.

Free Ally: You may designate any ally to gain the benefits of the freedom of movement spell for one round. You cannot use this ability on yourself. Once you have used this ability you cannot do so again for 5 rounds.

Noble Disdain: When attacking a foe of fewer Hit Dice than yourself with a ranged or melee weapon, you deal +1d6 points of damage.

Vanus’s Ears: Being bound to Vanus grants you a +10 bonus on Listen checks.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    if (oBinder == oTarget) return;
    if(!TakeSwiftAction(oBinder)) return;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_VANUS)) return;

    effect eLink =                          EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
           eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
           eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
           eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    // Search and remove effects of the types the target is being granted immunity to
    effect eLook = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eLook))
    {
        if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
           GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
           GetEffectType(eLook) == EFFECT_TYPE_SLOW     ||
           GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
           )
        {
            RemoveEffect(oTarget, eLook);
        }
        eLook = GetNextEffect(oTarget);
    }

    // Apply the effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, 6.0);
}