/*
30/12/19 by Stratovarius

Displacer Mantle

Descriptors: None 
Classes: Totemist 
Chakra: Shoulders (totem)
Saving Throw: None

Chakra Bind (Totem) 

A pair of tentacles extends from your shoulder blades. They end in pads ridged with sharp horn, allowing you to lash out even at distant foes to batter and tear them.

As a full-round action, you can make two tentacle attacks using your full base attack bonus. Each tentacle deals 1d4 points of damage plus your Strength modifier. Every point of essentia invested in the displacer mantle grants you a +1 enhancement bonus on damage rolls made with the tentacle attacks. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_combat"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_BASILISK_MASK); 

    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);
    int nAtk = GetAttackRoll(oTarget, oMeldshaper, oWeap);
    if (nAtk > 0)
    {
        int nDam = d4() + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper) + nEssentia;
        int nDamType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper));
        
        effect eLink = EffectLinkEffects(EffectDamage(nDam * nAtk, nDamType), EffectVisualEffect(VFX_COM_HIT_ACID));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
    }
	nAtk = GetAttackRoll(oTarget, oMeldshaper, oWeap);
    if (nAtk > 0)
    {
        int nDam = d4() + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper) + nEssentia;
        int nDamType = GetWeaponDamageType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper));
        
        effect eLink = EffectLinkEffects(EffectDamage(nDam * nAtk, nDamType), EffectVisualEffect(VFX_COM_HIT_ACID));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
    }    
}