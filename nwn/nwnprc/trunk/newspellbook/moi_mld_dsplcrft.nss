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
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:12:16
//::
//:: Double Totem Bind support added
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"
#include "prc_inc_combat"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_DISPLACER_MANTLE;  
  
    // Check if bound to Totem chakra (regular or double)  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (!nBoundToTotem) return; // Exit if not bound to Totem  
  
    object oTarget = PRCGetSpellTargetObject();  
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DISPLACER_MANTLE);  
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper);  
  
    // First tentacle attack  
    int nAtk = GetAttackRoll(oTarget, oMeldshaper, oWeap);  
    if (nAtk > 0)  
    {  
        int nDam = d4() + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper) + nEssentia;  
        int nDamType = GetWeaponDamageType(oWeap);  
        effect eLink = EffectLinkEffects(EffectDamage(nDam * nAtk, nDamType), EffectVisualEffect(VFX_COM_HIT_ACID));  
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);  
    }  
  
    // Second tentacle attack  
    nAtk = GetAttackRoll(oTarget, oMeldshaper, oWeap);  
    if (nAtk > 0)  
    {  
        int nDam = d4() + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper) + nEssentia;  
        int nDamType = GetWeaponDamageType(oWeap);  
        effect eLink = EffectLinkEffects(EffectDamage(nDam * nAtk, nDamType), EffectVisualEffect(VFX_COM_HIT_ACID));  
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);  
    }  
}

/* void main()
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
} */