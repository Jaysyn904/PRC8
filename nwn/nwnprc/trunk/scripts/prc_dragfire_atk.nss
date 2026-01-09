//::///////////////////////////////////////////////  
//:: Dragonfire Strike  
//:: prc_dragfire_atk.nss  
//::///////////////////////////////////////////////  
/*  
    Handles converting the damage on Dragonfire Strike   
    and similar feats  
*/  
//:://////////////////////////////////////////////  
//:: Created By: Fox  
//:: Created On: Nov 23, 2007  
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-01-08 10:03:33
//::
//:: Added ItemProperty tagging and constants.
//:://////////////////////////////////////////////  
  
#include "prc_inc_combat"  
#include "prc_inc_sneak"  
  
// Constants 
const float DRAGONFIRE_DURATION = 99999.0;  
const string DRAGONFIRE_TAG = "DragonfireStrike";  
  
// Helper function for consistent weapon detection  
int IsDragonfireWeapon(object oItem, object oPC)  
{  
    return (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) ||  
            (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem)) ||  
            GetWeaponRanged(oItem));  
}  
  
// Helper function to safely add properties to ammo  
void AddAmmoProperties(object oPC, int nPropertyType, int nPropertyParam1)  
{  
    if (!GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))  
        return; // Only add ammo for ranged weapons  
          
    object oAmmo;  
      
    oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);  
    if (GetIsObjectValid(oAmmo))  
    {  
        itemproperty ip = ItemPropertyOnHitCastSpell(nPropertyType, nPropertyParam1);  
        ip = TagItemProperty(ip, DRAGONFIRE_TAG);  
        IPSafeAddItemProperty(oAmmo, ip, DRAGONFIRE_DURATION, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
    }  
  
    oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);  
    if (GetIsObjectValid(oAmmo))  
    {  
        itemproperty ip = ItemPropertyOnHitCastSpell(nPropertyType, nPropertyParam1);  
        ip = TagItemProperty(ip, DRAGONFIRE_TAG);  
        IPSafeAddItemProperty(oAmmo, ip, DRAGONFIRE_DURATION, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
    }  
  
    oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);  
    if (GetIsObjectValid(oAmmo))  
    {  
        itemproperty ip = ItemPropertyOnHitCastSpell(nPropertyType, nPropertyParam1);  
        ip = TagItemProperty(ip, DRAGONFIRE_TAG);  
        IPSafeAddItemProperty(oAmmo, ip, DRAGONFIRE_DURATION, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
    }  
}  
  
// Helper function to safely remove properties from ammo  
void RemoveAmmoProperties(object oPC)  
{  
    object oAmmo;  
      
    oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);  
    if (GetIsObjectValid(oAmmo))  
    {  
        itemproperty ipCheck = GetFirstItemProperty(oAmmo);  
        while (GetIsItemPropertyValid(ipCheck))  
        {  
            if (GetItemPropertyTag(ipCheck) == DRAGONFIRE_TAG)  
            {  
                RemoveItemProperty(oAmmo, ipCheck);  
            }  
            ipCheck = GetNextItemProperty(oAmmo);  
        }  
    }  
  
    oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);  
    if (GetIsObjectValid(oAmmo))  
    {  
        itemproperty ipCheck = GetFirstItemProperty(oAmmo);  
        while (GetIsItemPropertyValid(ipCheck))  
        {  
            if (GetItemPropertyTag(ipCheck) == DRAGONFIRE_TAG)  
            {  
                RemoveItemProperty(oAmmo, ipCheck);  
            }  
            ipCheck = GetNextItemProperty(oAmmo);  
        }  
    }  
  
    oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);  
    if (GetIsObjectValid(oAmmo))  
    {  
        itemproperty ipCheck = GetFirstItemProperty(oAmmo);  
        while (GetIsItemPropertyValid(ipCheck))  
        {  
            if (GetItemPropertyTag(ipCheck) == DRAGONFIRE_TAG)  
            {  
                RemoveItemProperty(oAmmo, ipCheck);  
            }  
            ipCheck = GetNextItemProperty(oAmmo);  
        }  
    }  
}  
  
// Helper function to add Dragonfire property to weapon  
void AddDragonfireProperty(object oItem)  
{  
    itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);  
    ip = TagItemProperty(ip, DRAGONFIRE_TAG);  
    IPSafeAddItemProperty(oItem, ip, DRAGONFIRE_DURATION, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
}  
  
// Helper function to remove Dragonfire property from weapon  
void RemoveDragonfireProperty(object oItem)  
{  
    itemproperty ipCheck = GetFirstItemProperty(oItem);  
    while (GetIsItemPropertyValid(ipCheck))  
    {  
        if (GetItemPropertyTag(ipCheck) == DRAGONFIRE_TAG)  
        {  
            RemoveItemProperty(oItem, ipCheck);  
        }  
        ipCheck = GetNextItemProperty(oItem);  
    }  
}  
  
void DoDragonfireSneak(object oPC, object oTarget, object oWeapon)  
{  
    if(DEBUG) DoDebug("Performing Strike");  
    effect eStrike;  
    int nType = GetDragonfireDamageType(oPC);  
    int nDice = GetTotalSneakAttackDice(oPC);  
    int nSneakDamage = GetSneakAttackDamage(nDice);  
    int nDamage = nSneakDamage;  
      
    struct DamageReducers drTotalReduced = GetTotalReduction(oPC, oTarget, oWeapon);  
    nDamage = nDamage * (100 - drTotalReduced.nPercentReductions) / 100;  
    nDamage -= drTotalReduced.nStaticReductions;  
    if(nDamage < 0) nDamage = 0;  
    effect eHealed = EffectHeal(nDamage);  
          
    if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))  
        nSneakDamage += d6();      
    if(GetHasFeat(FEAT_IMP_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))  
        nSneakDamage += nDice;  
  
    effect eSneakDamage = EffectDamage(nSneakDamage, nType);  
    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))  
        eStrike = EffectLinkEffects(eSneakDamage, eHealed);  
    else  
        eStrike = eSneakDamage;  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget);  
}  
  
void main()  
{  
    int nEvent = GetRunningEvent();  
    if(DEBUG) DoDebug("prc_dragfire_atk running, event: " + IntToString(nEvent));  
  
    object oPC;  
    switch(nEvent)  
    {  
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;  
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;  
        default:                        oPC = OBJECT_SELF;  
    }  
  
    object oItem;  
  
    if(nEvent == EVENT_ONPLAYEREQUIPITEM)  
    {  
        oItem = GetItemLastEquipped();  
        if(DEBUG) DoDebug("prc_dragfire_atk - OnEquip");  
  
        if(IsDragonfireWeapon(oItem, oPC))  
        {  
            // Add eventhook to the item  
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_dragfire_atk", TRUE, FALSE);  
  
            // Add the OnHitCastSpell: Unique needed to trigger the event  
            AddDragonfireProperty(oItem);  
  
            // Add properties to ammo only for ranged weapons  
            AddAmmoProperties(oPC, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);  
        }  
    }  
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)  
    {  
        oItem = GetItemLastUnequipped();  
        if(DEBUG) DoDebug("prc_dragfire_atk - OnUnEquip");  
  
        if(IsDragonfireWeapon(oItem, oPC))  
        {  
            // Remove eventhook from the item  
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_dragfire_atk", TRUE, FALSE);  
  
            // Remove the temporary OnHitCastSpell: Unique  
            RemoveDragonfireProperty(oItem);  
  
            // Remove properties from ammo  
            RemoveAmmoProperties(oPC);  
        }  
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)  
    {  
        object oTarget = PRCGetSpellTargetObject();  
        oItem = GetSpellCastItem();  
  
        if(!IsDragonfireWeapon(oItem, oPC))  
            return;  
  
        if(DEBUG) DoDebug("Weapon Used: " + GetName(oItem));  
        if(DEBUG) DoDebug("CanSneakAttack: " + IntToString(GetCanSneakAttack(oTarget, oPC)));  
        if(DEBUG) DoDebug("Dice: " + IntToString(GetTotalSneakAttackDice(oPC)));  
          
        if(GetCanSneakAttack(oTarget, oPC)  
          && GetTotalSneakAttackDice(oPC)  
          && GetLocalInt(oPC, "DragonFireOn"))  
            DoDragonfireSneak(oPC, oTarget, oItem);  
    }  
}

/* void DoDragonfireSneak(object oPC, object oTarget, object oWeapon)
{
	if(DEBUG) DoDebug("Performing Strike");
	effect eStrike;
	int nType = GetDragonfireDamageType(oPC);
	int nDice = GetTotalSneakAttackDice(oPC);
	int nSneakDamage = GetSneakAttackDamage(nDice);
	int nDamage = nSneakDamage;
	
	struct DamageReducers drTotalReduced= GetTotalReduction(oPC, oTarget, oWeapon);
	nDamage = nDamage * (100 - drTotalReduced.nPercentReductions) / 100;
	nDamage -= drTotalReduced.nStaticReductions;
	if(nDamage < 0 ) nDamage = 0;
	effect eHealed = EffectHeal(nDamage);
        
    if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))
        nSneakDamage += d6();    
	if(GetHasFeat(FEAT_IMP_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))
        nSneakDamage += nDice;

    effect eSneakDamage = EffectDamage(nSneakDamage, nType);
    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
        eStrike = EffectLinkEffects(eSneakDamage, eHealed);
    else
        eStrike = eSneakDamage;
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_dragfire_atk running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
    object oAmmo;

    if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_dragfire_atk - OnEquip");

        // Only applies to weapons - Note: IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)
        || (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem))
        || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_dragfire_atk", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            // Makes sure to get ammo if its a ranged weapon
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_dragfire_atk - OnUnEquip");

        // Only applies to weapons - Note: if statement still returns true for armor/shield? o.O
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_dragfire_atk", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        //get the thing hit
        object oTarget  = PRCGetSpellTargetObject();
        oItem           = GetSpellCastItem();

        if(!(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))) //Note: if statement still returns false for armor/shield? o.O
            return;

        if(DEBUG) DoDebug("Weapon Used: " + GetName(oItem));
        if(DEBUG) DoDebug("CanSneakAttack: " + IntToString(GetCanSneakAttack(oTarget, oPC)));
        if(DEBUG) DoDebug("Dice: " + IntToString(GetTotalSneakAttackDice(oPC)));
        //check to see if both Sneak Attack and DFS apply, and if so, strike
        if(GetCanSneakAttack(oTarget, oPC)
          && GetTotalSneakAttackDice(oPC)
          && GetLocalInt(oPC, "DragonFireOn"))
            DoDragonfireSneak(oPC, oTarget, oItem);
    }
} */