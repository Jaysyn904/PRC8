//:://////////////////////////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////////////////////////
//::
/* 	
	Combat Focus
	Type of Feat: Combat Form, Fighter Bonus Feat.

	The way of the warrior requires more than simple, brute strength. 
	Some warriors bring their minds to such keen focus during the heat
	of battle that they can attain superhuman levels of endurance, 
	perception, and mental toughness. Through intense mental exercise 
	and training, you learn to enter a state of perfect martial 
	clarity.

	Prerequisite: WIS 13
	
	Specifics: In battle, you push aside the chaos of the fight and
	attain a focused state that grants you a keen, clear picture of
	the battle. Fear and pain ebb away as you focus solely on
	defeating your enemy. The first time you make a successful 
	attack during an encounter, you gain your combat focus. In this 
	state, your mind and body become one, allowing you to overcome 
	mundane physical limits. You can maintain your combat focus for 
	10 rounds after entering it, +1 additional round per combat form 
	feat you possess aside from this one. You can only gain your 
	combat focus once per encounter. While you are maintaining your 
	combat focus, you gain a +2 bonus on Will saves. If you have 
	three or more combat form feats, this bonus increases to +4.
	
	Use: Automatic.
	
	Special: A fighter can select Combat Focus as one of his fighter 
	bonus feats. 
*/
//::
//:://////////////////////////////////////////////////////////////////
//::	Script:     prc_combatfocus.nss
//::	Author:     Jaysyn
//::	Created:    2026-02-22 12:29:37
//:://////////////////////////////////////////////////////////////////
#include "prc_alterations"  
#include "prc_inc_function"  
#include "prc_inc_cmbtform"  
#include "inc_eventhook"  
  
void CombatFocus_AddOnHitToItem(object oItem)  
{  
    if (!GetIsObjectValid(oItem)) return;  
    itemproperty ipOnHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);  
    ipOnHit = TagItemProperty(ipOnHit, "Tag_PRC_OnHitKeeper");  
    IPSafeAddItemProperty(oItem, ipOnHit, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
    AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_combatfocus", TRUE, FALSE);  
} 
  
// Helper to remove OnHit property from a weapon/ammo  
void CombatFocus_RemoveOnHitFromItem(object oItem)  
{  
    if (!GetIsObjectValid(oItem)) return;  
    RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_combatfocus", TRUE, FALSE);  
    RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);  
}
  
void main()  
{  
    int nEvent = GetRunningEvent();  
    object oPC;  
  
    // Resolve the correct PC based on the event  
    switch (nEvent)  
    {  
        case EVENT_ONPLAYERREST_FINISHED: oPC = GetLastBeingRested(); break;  
        case EVENT_ONPLAYEREQUIPITEM:    oPC = GetItemLastEquippedBy(); break;  
        case EVENT_ONPLAYERUNEQUIPITEM:  oPC = GetItemLastUnequippedBy(); break;  
        case EVENT_ONHEARTBEAT:          oPC = OBJECT_SELF; break;  
        case EVENT_ITEM_ONHIT:           oPC = OBJECT_SELF; break;  
        default:                         oPC = OBJECT_SELF; break;  
    }  
  
    if (nEvent == FALSE) // EvalPRCFeats entry  
    {  
        if (!GetHasFeat(FEAT_COMBAT_FOCUS, oPC)) return;  
  
        // Register EVENT_ITEM_ONHIT once if not already registered  
        if (!GetLocalInt(oPC, "CmbtFocus_OnHit_Registered"))  
        {  
            AddEventScript(oPC, EVENT_ITEM_ONHIT, "prc_combatfocus", TRUE, FALSE);  
            SetLocalInt(oPC, "CmbtFocus_OnHit_Registered", TRUE);  
        }  
  
        // Register equip/unequip events once  
        if (!GetLocalInt(oPC, "CmbtFocus_EquipHooks_Registered"))  
        {  
            AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_combatfocus", TRUE, FALSE);  
            AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_combatfocus", TRUE, FALSE);  
            SetLocalInt(oPC, "CmbtFocus_EquipHooks_Registered", TRUE);  
        }  
  
        // Register rest-finished event once  
        if (!GetLocalInt(oPC, "CmbtFocus_RestHook_Registered"))  
        {  
            AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "prc_combatfocus", TRUE, FALSE);  
            SetLocalInt(oPC, "CmbtFocus_RestHook_Registered", TRUE);  
        }  
  
        // Apply Will bonus if focus is active  
        if (GetLocalInt(oPC, COMBAT_FOCUS_VAR))  
        {  
            ApplyCombatFocusWillBonus(oPC);  
            // Always ensure heartbeat is registered while focus is active  
            if (!GetLocalInt(oPC, "CmbtFocus_HB_Registered"))  
            {  
                AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_combatfocus", TRUE, FALSE);  
                SetLocalInt(oPC, "CmbtFocus_HB_Registered", TRUE);  
            }  
        }  
        else  
        {  
            // Remove Will bonus if focus is not active  
            if (GetLocalInt(oPC, "CombatFocus_Will"))  
                RemoveCombatFocusWillBonus(oPC);  
        }  
    }  
    else if (nEvent == EVENT_ONPLAYEREQUIPITEM)  
    {  
        object oItem = GetItemLastEquipped();  
        if (!GetIsObjectValid(oItem)) return;  
        // Skip VoP and Forsaker to avoid conflicts  
        if (GetHasFeat(FEAT_VOWOFPOVERTY, oPC) || GetLevelByClass(CLASS_TYPE_FORSAKER, oPC)) return;  
        if (IPGetIsMeleeWeapon(oItem))  
        {  
            CombatFocus_AddOnHitToItem(oItem);  
            // Also add to ammo if ranged  
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);  
            if (GetIsObjectValid(oAmmo)) CombatFocus_AddOnHitToItem(oAmmo);  
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);  
            if (GetIsObjectValid(oAmmo)) CombatFocus_AddOnHitToItem(oAmmo);  
            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);  
            if (GetIsObjectValid(oAmmo)) CombatFocus_AddOnHitToItem(oAmmo);  
        }  
    }  
    else if (nEvent == EVENT_ONPLAYERUNEQUIPITEM)  
    {  
        object oItem = GetItemLastUnequipped();  
        if (!GetIsObjectValid(oItem)) return;  
        if (IPGetIsMeleeWeapon(oItem))  
        {  
            CombatFocus_RemoveOnHitFromItem(oItem);  
            // Also remove from ammo if ranged  
            CombatFocus_RemoveOnHitFromItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC));  
            CombatFocus_RemoveOnHitFromItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC));  
            CombatFocus_RemoveOnHitFromItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC));  
        }  
    }  
	else if (nEvent == EVENT_ONHEARTBEAT)  
	{  
		if (!GetIsPC(oPC) || !GetLocalInt(oPC, COMBAT_FOCUS_VAR)) return;  
	  
		// Combat Awareness HP display only  
		if (GetHasFeat(FEAT_COMBAT_AWARENESS, oPC))  
			ShowAdjacentHP(oPC);  
	}
	else if (nEvent == EVENT_ONPLAYERREST_FINISHED)  
	{  
		RemoveCombatFocusWillBonus(oPC);  
		DeleteLocalInt(oPC, COMBAT_FOCUS_VAR);  
		DeleteLocalInt(oPC, "CombatFocus_RoundsRemaining");  
		DeleteLocalInt(oPC, COMBAT_FOCUS_ENC);  
		if (GetLocalInt(oPC, "CmbtFocus_HB_Registered"))  
		{  
			RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_combatfocus", TRUE, FALSE);  
			DeleteLocalInt(oPC, "CmbtFocus_HB_Registered");  
		}
			
		object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);  
		if (GetIsObjectValid(oRightHand) && IPGetIsMeleeWeapon(oRightHand))
		{  
			DelayCommand(1.0f, CombatFocus_AddOnHitToItem(oRightHand));  
		}  
	} 
	else if (nEvent == EVENT_ITEM_ONHIT)  
	{  
		if (!GetIsPC(oPC)) return;  
		if (!GetHasFeat(FEAT_COMBAT_FOCUS, oPC)) return;  
		if (GetLocalInt(oPC, COMBAT_FOCUS_VAR)) return;  
		if (GetLocalInt(oPC, COMBAT_FOCUS_ENC)) return;  
		  
		CombatFocus_OnAttackHit(oPC);  
		  
		// Start round decay heartbeat  
		if (!GetLocalInt(oPC, "CmbtFocus_HB_Registered"))  
		{  
			AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_combatfocus", TRUE, FALSE);  
			SetLocalInt(oPC, "CmbtFocus_HB_Registered", TRUE);  
			DelayCommand(6.0, CombatFocus_DecayRounds(oPC));  
		}  
		  
		// Start combat-end detection  
		DelayCommand(6.0, CombatFocus_CombatEndHeartbeat(oPC));  
	}  
}