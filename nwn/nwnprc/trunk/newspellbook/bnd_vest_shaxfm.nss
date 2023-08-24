/*
14/03/21 by Stratovarius

Shax, Sea Sister
  
Another giant among the vestiges, Shax gives her summoners the ability to laugh off lightning, to wriggle free of any bonds, and to strike foes like a thunderbolt.

Vestige Level: 6th
Binding DC: 26
Special Requirement: No

Influence: While under Shax’s influence, you become possessive and stingy, particularly about territory—be it actual land or simply a room in an inn. In addition, 
her influence requires you to demand compensation for any service rendered and to tax any use of your territory. However, you can accept nearly any item of value—be it material goods or a service—as payment.

Granted Abilities: 
Shax grants you the ability to strike foes with sonic force and electricity. She also gives you immunity to electricity and allows you to move freely despite restraints.

Freedom of Movement: As a swift action, you can give yourself the ability to ignore restraints. This effect functions like the freedom of movement spell, except that it 
lasts only 1 round. Once you have used this ability, you cannot do so again for 5 rounds.

Immunity to Electricity: You gain immunity to electricity damage.

Storm Strike: As a swift action, you can charge a melee attack or melee touch attack with electricity and sonic power. Your next melee attack deals an extra 1d6 points of electricity damage and 1d6 points of sonic damage.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!TakeSwiftAction(oBinder)) return;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_SHAX)) return;

    effect eLink =                          EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
           eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
           eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
           eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    // Search and remove effects of the types the target is being granted immunity to
    effect eLook = GetFirstEffect(oBinder);
    while(GetIsEffectValid(eLook))
    {
        if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
           GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
           GetEffectType(eLook) == EFFECT_TYPE_SLOW     ||
           GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
           )
        {
            RemoveEffect(oBinder, eLook);
        }
        eLook = GetNextEffect(oBinder);
    }

    // Apply the effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, 6.0);
}