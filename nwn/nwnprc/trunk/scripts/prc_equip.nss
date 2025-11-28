//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "prc_inc_function"
#include "prc_inc_wpnrest"
#include "inc_timestop"
#include "prc_inc_itmrstr"
#include "prc_inc_template"

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - 6 Jan 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004
//Removed the delay. It was messing up evaluation scripts that use GetItemLastEquipped(By)
//  Ornedan - 07.03.2005

void main()
{
    object oItem = GetItemLastEquipped();
    object oPC   = GetItemLastEquippedBy();

    if(!GetIsObjectValid(oPC))
        return;
	
	//:: Use with bioware polymorphs
	DetectMonkGloveEquip(oItem);

    //if(DEBUG) DoDebug("Running OnEquip, creature = '" + GetName(oPC) + "' is PC: " + DebugBool2String(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    SetLocalInt(oPC, "ONEQUIP", 2); // Ugly hack to work around event detection in CheckPRCLimitations() - Ornedan

    // Handle custom limitation itemproperties and other itemproperties that trigger when equipped, like PnP Holy Avenger and speed modifications
    if(!CheckPRCLimitations(oItem, oPC))
    {
        // "You cannot equip " + GetName(oItem)
        SendMessageToPC(oPC, ReplaceChars(GetStringByStrRef(16828407), "<itemname>", GetName(oItem)));
        int i;
        object oTest;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oTest = GetItemInSlot(i, oPC);
            if(oTest == oItem)
            {
                DelayCommand(0.3f, ForceUnequip(oPC, oItem, i));
                return;
            }
        }
    }

    EvalPRCFeats(oPC);
    DeleteLocalInt(oPC, "ONEQUIP");

    //Handle lack of fingers/hands
    if(GetPersistantLocalInt(oPC, "LEFT_HAND_USELESS"))
    {
        //Force unequip
        ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), INVENTORY_SLOT_LEFTHAND);
        SendMessageToPC(oPC, "You cannot use your left hand");
    }

    if(GetPersistantLocalInt(oPC, "RIGHT_HAND_USELESS"))
    {
        //Force unequip
        ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), INVENTORY_SLOT_RIGHTHAND);
        SendMessageToPC(oPC, "You cannot use your right hand");
    }
    if (GetHasSpellEffect(SPELL_LUMINOUS_ARMOR, oPC) || GetHasSpellEffect(SPELL_GREATER_LUMINOUS_ARMOR, oPC))
    {
        object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        if (GetBaseAC(oArmour) > 0)
        {
            ForceUnequip(oPC, oArmour, INVENTORY_SLOT_CHEST);
            SendMessageToPC(oPC, "You cannot wear armor while under the effects of Luminous Armour");          
        }   
    }

    DelayCommand(0.2, DoWeaponsEquip(oPC));        

    //timestop noncombat equip
    DoTimestopEquip(oPC, oItem);
	
//:: Saint / Holy Touch doesn't work w/ ranged weapons
	if (GetHasTemplate(TEMPLATE_SAINT, oPC))
	{
	//:: Setup Holy Touch extra damage vs evil
		effect eEffect1 = VersusAlignmentEffect(EffectDamageIncrease(7, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
		effect eEffect2 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
		       eEffect2 = VersusRacialTypeEffect(eEffect2, RACIAL_TYPE_OUTSIDER);
		effect eEffect3 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
		       eEffect3 = VersusRacialTypeEffect(eEffect3, RACIAL_TYPE_UNDEAD);
		effect eLink = EffectLinkEffects(eEffect1, eEffect2);
		       eLink = EffectLinkEffects(eLink, eEffect3);
		       eLink = SupernaturalEffect(eLink);
		       eLink = TagEffect(eLink, "EffectHolyTouch");

	//:: Clear the effect to be safe and prevent stacking
		effect eCheckEffect = GetFirstEffect(oPC);
            
		while (GetIsEffectValid(eCheckEffect))
		{
			if (GetEffectTag(eCheckEffect) == "EffectHolyTouch")
			{
				RemoveEffect(oPC, eCheckEffect);
			
			}
			
		eCheckEffect = GetNextEffect(oPC);
		
		}

	//:: Check if equipped with a ranged weapon and apply effect again if not
        if (!GetWeaponRanged(oItem))
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	}

//:: Clear Echoblade effect if weapon is changed
	int nBaseItem = GetBaseItemType(oItem);
	
	effect eEffect = GetFirstEffect(oPC);
	
	if (nBaseItem == BASE_ITEM_AMULET || nBaseItem == BASE_ITEM_ARMOR ||  nBaseItem == BASE_ITEM_ARROW ||  nBaseItem == BASE_ITEM_BELT ||  nBaseItem == BASE_ITEM_BOLT ||  nBaseItem == BASE_ITEM_BOOTS 
	||  nBaseItem == BASE_ITEM_BRACER ||  nBaseItem == BASE_ITEM_BULLET ||  nBaseItem == BASE_ITEM_CBLUDGWEAPON ||  nBaseItem == BASE_ITEM_CLOAK ||  nBaseItem == BASE_ITEM_CPIERCWEAPON 
	||  nBaseItem == BASE_ITEM_CREATUREITEM ||  nBaseItem == BASE_ITEM_CSLASHWEAPON ||  nBaseItem == BASE_ITEM_CSLSHPRCWEAP ||  nBaseItem == BASE_ITEM_GLOVES ||  nBaseItem == BASE_ITEM_HELMET 
	||  nBaseItem == BASE_ITEM_RING ||  nBaseItem == BASE_ITEM_LARGESHIELD ||  nBaseItem == BASE_ITEM_RING ||  nBaseItem == BASE_ITEM_SMALLSHIELD ||  nBaseItem == BASE_ITEM_TOWERSHIELD)  
	{
		return;
	}
	else
	{
		while(GetIsEffectValid(eEffect))
		{
			if(GetEffectTag(eEffect) == "Echoblade")
			RemoveEffect(oPC, eEffect);
			eEffect = GetNextEffect(oPC);
		}	
	}	
	
//:: Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYEREQUIPITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONPLAYEREQUIPITEM);

    // Tag-based scripting hook for PRC items
    SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
    ExecuteScript("is_"+GetTag(oItem), OBJECT_SELF);
}