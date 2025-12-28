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


//:: Shield Specialization moved here to stop Shield AC message spam
void ApplyShieldSpecialization(object oPC, object oItem)
{
	itemproperty ip = GetFirstItemProperty(oItem);
	int iTemp;
	while(GetIsItemPropertyValid(ip))
	{
		int iIpType = GetItemPropertyType(ip);
		if (iIpType == ITEM_PROPERTY_AC_BONUS)
		{
			iTemp = GetItemPropertyCostTableValue(ip);
			break;
		}    

		ip = GetNextItemProperty(oItem);
	}	
	
	// Remove any existing shield specialization effect to prevent stacking
	effect eOldEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eOldEffect))
	{
		if (GetEffectTag(eOldEffect) == "ShieldSpecialization")
		{
			RemoveEffect(oPC, eOldEffect);
		}
		eOldEffect = GetNextEffect(oPC);
	}
	
	// Apply the shield specialization bonus with TagEffect
	effect eShieldBonus = EffectACIncrease(iTemp+1, AC_SHIELD_ENCHANTMENT_BONUS);
	UnyieldingEffect(eShieldBonus);
	//effect eShieldBonus = EffectACIncrease(iTemp+1, AC_DODGE_BONUS);
	eShieldBonus = TagEffect(eShieldBonus, "ShieldSpecialization");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShieldBonus, oPC);
  	 		 
}


void main()
{
    object oItem = GetItemLastEquipped();
    object oPC   = GetItemLastEquippedBy();

    if(!GetIsObjectValid(oPC))
        return;
	
	if(DEBUG) DoDebug("prc_equip: Running event script.");
	
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
	int nBaseItemType = GetBaseItemType(oItem);
	
	effect eEffect = GetFirstEffect(oPC);
	
	if (nBaseItemType != BASE_ITEM_AMULET && nBaseItemType != BASE_ITEM_ARMOR &&  nBaseItemType != BASE_ITEM_ARROW &&  nBaseItemType != BASE_ITEM_BELT &&  nBaseItemType != BASE_ITEM_BOLT &&  nBaseItemType != BASE_ITEM_BOOTS 
	&&  nBaseItemType != BASE_ITEM_BRACER &&  nBaseItemType != BASE_ITEM_BULLET &&  nBaseItemType != BASE_ITEM_CBLUDGWEAPON &&  nBaseItemType != BASE_ITEM_CLOAK &&  nBaseItemType != BASE_ITEM_CPIERCWEAPON 
	&&  nBaseItemType != BASE_ITEM_CREATUREITEM &&  nBaseItemType != BASE_ITEM_CSLASHWEAPON &&  nBaseItemType != BASE_ITEM_CSLSHPRCWEAP &&  nBaseItemType != BASE_ITEM_GLOVES &&  nBaseItemType != BASE_ITEM_HELMET 
	&&  nBaseItemType != BASE_ITEM_RING &&  nBaseItemType != BASE_ITEM_LARGESHIELD &&  nBaseItemType != BASE_ITEM_RING &&  nBaseItemType != BASE_ITEM_SMALLSHIELD &&  nBaseItemType != BASE_ITEM_TOWERSHIELD) 
	{
		// Only remove echoblade for weapon types
		while(GetIsEffectValid(eEffect))
		{
			if(GetEffectTag(eEffect) == "Echoblade")
				RemoveEffect(oPC, eEffect);
			eEffect = GetNextEffect(oPC);
		}
	}

/* 	if((nBaseItemType == BASE_ITEM_SMALLSHIELD && GetHasFeat(FEAT_SHIELD_SPECIALIZATION_LIGHT, oPC)) 
	|| (nBaseItemType == BASE_ITEM_LARGESHIELD && GetHasFeat(FEAT_SHIELD_SPECIALIZATION_HEAVY, oPC))) */

	if(DEBUG) DoDebug("prc_equip: nBaseItemType is: "+ IntToString(nBaseItemType) +".");
	
	if(nBaseItemType == BASE_ITEM_SMALLSHIELD || nBaseItemType == BASE_ITEM_LARGESHIELD)
    {
		if(DEBUG) DoDebug("prc_equip: Large or Small Shield found.");
		
		if(GetHasFeat(FEAT_SHIELD_SPECIALIZATION_LIGHT, oPC) || GetHasFeat(FEAT_SHIELD_SPECIALIZATION_HEAVY, oPC))
		{
			if(DEBUG) DoDebug("prc_equip: Shield Specialization found.");
			
			ApplyShieldSpecialization(oPC, oItem);
		}
	}
	
	
//:: Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYEREQUIPITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONPLAYEREQUIPITEM);

    // Tag-based scripting hook for PRC items
    SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
    ExecuteScript("is_"+GetTag(oItem), OBJECT_SELF);
}