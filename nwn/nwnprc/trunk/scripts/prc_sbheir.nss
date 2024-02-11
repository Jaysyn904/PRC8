//:://////////////////////////////////////////////
//:: Shining Blade of Heironeous - Class evaluation
//:: prc_sbheir
//:://////////////////////////////////////////////

#include "inc_eventhook"
#include "prc_inc_sbheir"

const int DEBUG_EVENTS = FALSE;

void main()
{
    int nEvent = GetRunningEvent();
    if(nEvent == FALSE) //We aren't being called from any event, instead from EvalPRCFeats
    {
        object oPC = OBJECT_SELF;

        AddEventScript(oPC, EVENT_ONHIT, "prc_sbheir", TRUE, FALSE);
        
        if(GetLocalInt(oPC,"ONEQUIP")) //2 = equip, 1 = unequip
        {
            if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: ONEQUIP/ONUNEQUIP");
            
            object oOnHandWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
            int bOnHand = (GetBaseItemType(oOnHandWeapon) == BASE_ITEM_LONGSWORD);
            object oOffHandWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            int bOffHand = (GetBaseItemType(oOffHandWeapon) == BASE_ITEM_LONGSWORD);
            
            int nDuration = GetLocalInt(oPC, PRC_ShiningBlade_Duration);
            int nLevel = GetLocalInt(oPC, PRC_ShiningBlade_Level);
            
            object oChangedWeapon = OBJECT_INVALID;
            switch (GetLocalInt(oPC,"ONEQUIP"))
            {
                case 1: //Unequip
                    oChangedWeapon = GetItemLastUnequipped();
                    if (GetBaseItemType(oChangedWeapon) == BASE_ITEM_LONGSWORD)
                    {
                        if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: Unequipping longsword");
                        ShiningBlade_ApplyProperties(oChangedWeapon, 0, nLevel);
                    }
                    else
                    {
                        if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: Unequipping non-longsword");                        
                    }
                    break;
                    
                case 2: //Equip
                    oChangedWeapon = GetItemLastEquipped();
                    if (GetBaseItemType(oChangedWeapon) == BASE_ITEM_LONGSWORD)
                    {
                        if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: Equipping longsword");
                        //Apply the bonuses with the full duration, even though part of that time has already been used up.
                        //The bonus expiration function will remove them at the proper time.
                        ShiningBlade_ApplyProperties(oChangedWeapon, nDuration, nLevel);
                    }
                    else
                    {
                        if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: Equipping non-longsword");                        
                    }
                    break;
            }
            
            ShiningBlade_ApplyAttackBonuses(oPC, bOnHand, bOffHand, nLevel);
        }
        else if(GetLocalInt(oPC,"ONREST"))
        {
            //Expire Shining Blade bonuses upon resting (this will happen due to time passing during normal resting, but not when ForceRest is called)
            int nGeneration = GetLocalInt(oPC, PRC_ShiningBlade_Generation);
            int nLevel = GetLocalInt(oPC, PRC_ShiningBlade_Level);
            ShiningBlade_ExpireBonuses(oPC, nGeneration, nLevel);
            SetLocalInt(oPC, PRC_ShiningBlade_Generation, PRC_NextGeneration(nGeneration));
        }
        else
        {
            if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: EvalPRCFeats");
        }
    }
    else
    {
        if (DEBUG_EVENTS) DoDebug("$$$  prc_sbheir: nEvent == " + IntToString(nEvent));        
    }
}
