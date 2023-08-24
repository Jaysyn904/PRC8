//::///////////////////////////////////////////////
//:: Soulknife multi-event handler
//:: psi_sk_event
//::///////////////////////////////////////////////
/*
    Handles Soulknife stuff for events:

    OnRest
    - Changes mindblade enhancement to new settings.

    OnEquip
    - Handles prevention of equipping anything in
      left hand if using bastard sword without
      Exotic Prof.

    OnUnEquip
    - Destroys any mindblades unequipped.

    OnUnAquire
    - Destroys any mindblades lost. Should never
      happen, but paranoia is good.

    OnDeath
    - Destroy mindblade on death, just in case.


    @author Ornedan
    @date   Created  - 2005.04.06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations" Provided by prc_alterations
#include "psi_inc_soulkn"

int LOCAL_DEBUG = DEBUG;


void BastardSword2hHandler(object oPC)
{
    object oRightH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(LOCAL_DEBUG) DoDebug("GetBaseItemType(oRightH) == BASE_ITEM_BASTARDSWORD : " + (GetBaseItemType(oRightH) == BASE_ITEM_BASTARDSWORD ? "TRUE":"FALSE") + "\n"
                          + "GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) : " + (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) ? "TRUE":"FALSE") + "\n"
                          + "GetLocalInt(oRightH, 'PRC_SK_BastardSword_2h_Fudge') : " + IntToString(GetLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge")) + "\n"
                            );

    // Apply 1.5x STR damage to the bastard sword when wielded with 2 hands
    /// @todo Remove this once Silver finishes his weapons modification
    if(GetBaseItemType(oRightH) == BASE_ITEM_BASTARDSWORD            &&
       !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))&& // The bsword will always be in mainhand when this applies, so just check for offhand's emptiness
       !GetLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge"))           // The bonus isn't already applied
    {
        if(LOCAL_DEBUG) DoDebug("Applying +0.5x STR for a bastard sword being wielded 2-h");
        if(LOCAL_DEBUG) DoDebug("Bonus was already applied according to local variable: " + (GetLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge") ? "Yes":"No"));
        int nDamBon = min((GetAbilityModifier(ABILITY_STRENGTH, oPC) / 2) // Round down
                          + GetLocalInt(oRightH, "PRC_SK_BSwd_EnhBonus")  // Add in the enhancement bonus, since they don't stack
                          , 20);                                          // And limit to 20
        // No increased damage penalty for negative STR mod
        if(nDamBon > 0)
        {
            switch(nDamBon)
            {
                case 1:  nDamBon = IP_CONST_DAMAGEBONUS_1;  break;
                case 2:  nDamBon = IP_CONST_DAMAGEBONUS_2;  break;
                case 3:  nDamBon = IP_CONST_DAMAGEBONUS_3;  break;
                case 4:  nDamBon = IP_CONST_DAMAGEBONUS_4;  break;
                case 5:  nDamBon = IP_CONST_DAMAGEBONUS_5;  break;
                case 6:  nDamBon = IP_CONST_DAMAGEBONUS_6;  break;
                case 7:  nDamBon = IP_CONST_DAMAGEBONUS_7;  break;
                case 8:  nDamBon = IP_CONST_DAMAGEBONUS_8;  break;
                case 9:  nDamBon = IP_CONST_DAMAGEBONUS_9;  break;
                case 10: nDamBon = IP_CONST_DAMAGEBONUS_10; break;
                case 11: nDamBon = IP_CONST_DAMAGEBONUS_11; break;
                case 12: nDamBon = IP_CONST_DAMAGEBONUS_12; break;
                case 13: nDamBon = IP_CONST_DAMAGEBONUS_13; break;
                case 14: nDamBon = IP_CONST_DAMAGEBONUS_14; break;
                case 15: nDamBon = IP_CONST_DAMAGEBONUS_15; break;
                case 16: nDamBon = IP_CONST_DAMAGEBONUS_16; break;
                case 17: nDamBon = IP_CONST_DAMAGEBONUS_17; break;
                case 18: nDamBon = IP_CONST_DAMAGEBONUS_18; break;
                case 19: nDamBon = IP_CONST_DAMAGEBONUS_19; break;
                case 20: nDamBon = IP_CONST_DAMAGEBONUS_20; break;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, nDamBon), oRightH);
            SetLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge", nDamBon); // Store the damage bonus value, so it can be used for removing the property later on
        }
    }
    // Remove the +0.5x STR bonus for wielding bastard swords 2-handed if something is equipped in the offhand
    if(GetBaseItemType(oRightH) == BASE_ITEM_BASTARDSWORD              &&
       GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
    {
        if(LOCAL_DEBUG) DoDebug("Removing +0.5x STR for a bastard sword being wielded 2-h");
        if(LOCAL_DEBUG) DoDebug("Bonus was present according to local variable: " + (GetLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge") ? "Yes":"No"));
        int nDamBon = GetLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge");
        RemoveSpecificProperty(oRightH, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, nDamBon, 1);
        DeleteLocalInt(oRightH, "PRC_SK_BastardSword_2h_Fudge");
    }
}


void main()
{
    object oPC;
    int nEvent = GetRunningEvent();
    int nHand;

    if(LOCAL_DEBUG) DoDebug("psi_sk_event running");

    /* Probably unnecessary, uncomment if mindblades turn out to become permanent when a part of a saved character
    if(nEvent == EVENT_ONCLIENTENTER)
    {
        if(LOCAL_DEBUG) DoDebug("Character with soulknife levels entered module, destroying mindblades");
        oPC = GetEnteringObject();
        object oItem;
        if(GetStringLeft(GetTag(oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying mindblade in right hand");
            MyDestroyObject(oItem);
        }
        if(GetStringLeft(GetTag(oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying mindblade in left hand");
            MyDestroyObject(oItem);
        }
    }
    else */
    if(nEvent == EVENT_ONPLAYERREST_FINISHED)
    {
        if(LOCAL_DEBUG) DoDebug("psi_sk_event: Rest finished, applying new mindblade settings");
        oPC = GetLastBeingRested();
        SetPersistantLocalInt(oPC, MBLADE_FLAGS, GetLocalInt(oPC, MBLADE_FLAGS + "_Q"));

        // Make the new settings visible by running the manifesting script
        DelayCommand(0.5f, ExecuteScript("psi_sk_manifmbld", oPC));
    }
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        if(LOCAL_DEBUG) DoDebug("psi_sk_event: Equip");
        oPC = GetItemLastEquippedBy();
        object oItem   = GetItemLastEquipped(),
               oRightH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

        // One must wield the bastard sword with 2 hands when lacking exotic weapon proficiency
        if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) &&
           GetBaseItemType(oRightH) == BASE_ITEM_BASTARDSWORD            &&
           !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
        {
            SendMessageToPCByStrRef(oPC, 16824510);
            ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), INVENTORY_SLOT_LEFTHAND);
        }
        // May be wielding a bastard sword with 2 hands
        else
            // Run the 2h bastard sword bonus handler
            BastardSword2hHandler(oPC);

        // Lacking the correct proficiency to wield non-mindblade version of a short sword
        if(GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD     &&
           GetTag(oItem) != "prc_sk_mblade_ss"                &&
           !(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) ||
             GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC) ||
             GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTSWORD, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // Check which slot the weapon got equipped into
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                nHand = INVENTORY_SLOT_RIGHTHAND;
            else
                nHand = INVENTORY_SLOT_LEFTHAND;
            SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(nHand), -4, nHand);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a longsword
        if(GetBaseItemType(oItem) == BASE_ITEM_LONGSWORD      &&
           GetTag(oItem) != "prc_sk_mblade_ls"                &&
           !(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) ||
             GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC) ||
             GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // Check which slot the weapon got equipped into
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                nHand = INVENTORY_SLOT_RIGHTHAND;
            else
                nHand = INVENTORY_SLOT_LEFTHAND;
            SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(nHand), -4, nHand);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a bastard sword
        if(GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD   &&
           GetTag(oItem) != "prc_sk_mblade_bs"                &&
           !(GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC) ||
           GetHasFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                nHand = INVENTORY_SLOT_RIGHTHAND;
            else
                nHand = INVENTORY_SLOT_LEFTHAND;
            SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(nHand), -4, nHand);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a throwing axe
        if(GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE    &&
           GetTag(oItem) != "prc_sk_mblade_th"                &&
           !(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) ||
            GetHasFeat(FEAT_WEAPON_PROFICIENCY_THROWING_AXE, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                nHand = INVENTORY_SLOT_RIGHTHAND;
            else
                nHand = INVENTORY_SLOT_LEFTHAND;
            SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(nHand), -4, nHand);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a small shield
        if(GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD    &&
           GetTag(oItem) != "psi_sk_tshield_0"                &&
           !GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // unequip the shield
            ForceUnequip(oPC, oItem, INVENTORY_SLOT_LEFTHAND);
        }
    }
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        if(LOCAL_DEBUG) DoDebug("psi_sk_event: OnUnequip");
        object oItem = GetItemLastUnequipped();
        oPC = GetItemLastUnequippedBy();
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying unequipped mindblade");
            MyDestroyObject(oItem);
        }
        if(GetStringLeft(GetTag(oItem), 15) == "psi_sk_tshield_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying unequipped thought shield");
            MyDestroyObject(oItem);
        }

        // Remove the +0.5x STR bonus for wielding bastard swords 2-handed if the sword is unequipped
        if(GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD  && // Unequipped a bastard sword
           GetLocalInt(oItem, "PRC_SK_BastardSword_2h_Fudge")   // That has the 2h bonus on it
           )
        {
            if(LOCAL_DEBUG) DoDebug("Removing +0.5x STR for a bastard sword being wielded 2-h due to it being unequipped");
            if(LOCAL_DEBUG) DoDebug("Bonus was present according to local variable: " + (GetLocalInt(oItem, "PRC_SK_BastardSword_2h_Fudge") ? "Yes":"No"));
            int nDamBon = GetLocalInt(oItem, "PRC_SK_BastardSword_2h_Fudge");
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, nDamBon, 1);
            DeleteLocalInt(oItem, "PRC_SK_BastardSword_2h_Fudge");
        }

        // Run the 2h bastard sword bonus handler. Delay a bit so that the item can actually vacate the slot. Yay for firing the event before the unequipping has actually occurred
        DelayCommand(0.4f, BastardSword2hHandler(oPC));
    }
    else if(nEvent == EVENT_ONUNAQUIREITEM)
    {
        if(LOCAL_DEBUG) DoDebug("psi_sk_event: OnUnAcquire");
        object oItem = GetModuleItemLost();
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying lost mindblade");
            MyDestroyObject(oItem);
        }
        if(GetStringLeft(GetTag(oItem), 15) == "psi_sk_tshield_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying lost thought shield");
            MyDestroyObject(oItem);
        }
    }
    else if(nEvent == EVENT_ONPLAYERDEATH)
    {
        if(LOCAL_DEBUG) DoDebug("psi_sk_event: OnDeath");
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, GetLastBeingDied());
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying mindblade from right hand");
            MyDestroyObject(oItem);
        }
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, GetLastBeingDied());
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying mindblade from left hand");
            MyDestroyObject(oItem);
        }
        if(GetStringLeft(GetTag(oItem), 15) == "psi_sk_tshield_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying thought shield from left hand");
            MyDestroyObject(oItem);
        }
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        oPC = OBJECT_SELF;
        if(DEBUG) DoDebug("psi_sk_event: OnLevelDown, deleting mindblade settings and existing blades");

        SendMessageToPCByStrRef(oPC, 16824530); // "Your mindblade enhancements have been reset and your mindblades destroyed due to level loss."

        SetPersistantLocalInt(oPC, MBLADE_FLAGS, 0x00000000);

        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying mindblade from right hand");
            MyDestroyObject(oItem);
        }
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying mindblade from left hand");
            MyDestroyObject(oItem);
        }
        if(GetStringLeft(GetTag(oItem), 15) == "psi_sk_tshield_")
        {
            if(LOCAL_DEBUG) DoDebug("Destroying thought shield from left hand");
            MyDestroyObject(oItem);
        }

        // If the character has lost all levels in Soulknife, remove eventhooks
        if(GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC) == 0)
        {
            RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "psi_sk_event", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "psi_sk_event", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONUNAQUIREITEM,      "psi_sk_event", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONPLAYERDEATH,       "psi_sk_event", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONPLAYERLEVELDOWN,   "psi_sk_event", TRUE, FALSE);
        }
    }
}