#include "prc_inc_combat"    
#include "prc_inc_spells"    

/* Fiend Hammer (Su): Once per day, a maeluth can grant a melee 
weapon the unholy special ability. This effect lasts for 1 minute */

    
void main()    
{    
    // Declare major variables    
    object oPC = OBJECT_SELF;    
    object oTarget = GetSpellTargetObject();    
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);    
        
    // Check if target is a valid melee weapon    
    if(!GetIsObjectValid(oWeap) || GetWeaponRanged(oWeap))    
    {    
        SendMessageToPC(oPC, "You must be wielding a melee weapon to use this ability.");    
        IncrementRemainingFeatUses(oPC, FEAT_MAELUTH_FIEND_HAMMER);    
        return;    
    }    
        
    // Apply unholy property for 1 minute. 
    itemproperty ipUnholy = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6);    
        
    // Apply the property to the weapon    
    IPSafeAddItemProperty(oWeap, ipUnholy, 60.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);    
        
    // Visual and feedback effects    
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oWeap));    
    SendMessageToPC(oPC, "Your weapon glows with unholy power.");    
}