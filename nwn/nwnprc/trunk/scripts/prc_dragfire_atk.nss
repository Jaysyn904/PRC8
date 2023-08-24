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
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_inc_sneak"

void DoDragonfireSneak(object oPC, object oTarget, object oWeapon)
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
}