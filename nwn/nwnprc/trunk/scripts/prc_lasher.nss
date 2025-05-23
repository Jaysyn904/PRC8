//::///////////////////////////////////////////////
//:: Lasher
//:://////////////////////////////////////////////
/*
    Script to add lasher bonuses

    Improved Knockdown (Whip)
    Crack of Fate
    Lashing Whip
    Improved Disarm (Whip)
    Crack of Doom

    code "borrowed" from tempest, stormlord,
        soulknife

    modified to allow toggling of crack of fate/doom
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: May 24, 2006
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
//#include "prc_alterations"
//#include "inc_2dacache"
#include "prc_inc_spells"

/* void ApplyLashing(object oPC) //ripped off the tempest
{
    if(!GetHasSpellEffect(SPELL_LASHER_LASHW, oPC))
        ActionCastSpellOnSelf(SPELL_LASHER_LASHW);
} */

/* void ApplyBonuses(object oPC, object oWeapon)
{
    object oSkin = GetPCSkin(oPC);
    int iClassLevel = GetLevelByClass(CLASS_TYPE_LASHER, oPC);

    object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    //counters the +2 damage on the offhand weapon
    if(GetIsObjectValid(oOffHand) && oOffHand == oWeapon)
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(2), oOffHand, 9999.0);

    if(GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)  //assumes off-hand can't be whip
        return;

    if(iClassLevel > 1 && !GetHasFeat(FEAT_IMPROVED_TRIP))    //improved trip (whip)
    {
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_TRIP));
    }

    if(iClassLevel > 3)    //lashing whip
    {
        DelayCommand(0.1, ApplyLashing(oPC));
        //counters the +2 damage on the offhand weapon
        if(GetIsObjectValid(oOffHand))
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(2), oOffHand, 9999.0);
    }

    if(iClassLevel > 5 && !GetHasFeat(FEAT_PRC_IMP_DISARM))    //improved disarm (whip)
    {
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PRC_IMPROVED_DISARM));
    }
}
 */

/* void RemoveBonuses(object oPC, object oWeapon)
{
    object oSkin = GetPCSkin(oPC);

    object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    //counters the +2 damage on the offhand weapon
    RemoveSpecificProperty(oOffHand, ITEM_PROPERTY_DECREASED_DAMAGE, -1, 2, 1, "", -1, DURATION_TYPE_TEMPORARY);
    if(oOffHand == oWeapon)
        return;     //it's the off-hand weapon being equipped here

    int iClassLevel = (GetLevelByClass(CLASS_TYPE_LASHER));

    if (GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)
        return;

        if(iClassLevel > 1)    //improved knockdown (whip)
        {
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_IMPROVED_KNOCKDOWN
                );
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_KNOCKDOWN
                );
        }

        if(GetHasSpellEffect(SPELL_LASHER_LASHW, oPC)) //lashing whip
            PRCRemoveEffectsFromSpell(oPC, SPELL_LASHER_LASHW);

        if(iClassLevel > 5)    //improved disarm (whip)
        {
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_IMPROVED_DISARM
                );
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_DISARM
                );
        }

        if(GetHasSpellEffect(SPELL_LASHER_CRACK_FATE, oPC))
        {
            PRCRemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK_FATE);
            FloatingTextStringOnCreature("*Crack of Fate Deactivated*", oPC, FALSE);
        }
        if(GetHasSpellEffect(SPELL_LASHER_CRACK_DOOM, oPC))
        {
            PRCRemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK_DOOM);
            FloatingTextStringOnCreature("*Crack of Doom Deactivated*", oPC, FALSE);
        }
}
 */

void RemoveFeatBonuses(object oPC)
{
    object oSkin = GetPCSkin(oPC);
	
	if(DEBUG) DoDebug("prc_lasher: Running RemoveFeatBonuses");

	if(GetHasSpellEffect(SPELL_LASHER_CRACK_FATE, oPC))
	{
		PRCRemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK_FATE);
		FloatingTextStringOnCreature("*Crack of Fate Deactivated*", oPC, FALSE);
	}
	if(GetHasSpellEffect(SPELL_LASHER_CRACK_DOOM, oPC))
	{
		PRCRemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK_DOOM);
		FloatingTextStringOnCreature("*Crack of Doom Deactivated*", oPC, FALSE);
	}
}

void ApplyWhipBonuses(object oPC, object oWhip, int iClassLevel)
{
    if (!GetIsObjectValid(oWhip)) return;
	
    // Only apply bonuses if the item is a whip
    if (GetBaseItemType(oWhip) != BASE_ITEM_WHIP) return;

    if(DEBUG) DoDebug("prc_lasher: Running ApplyWhipBonuses");

    RemoveSpecificProperty(oWhip, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2, 1, "SLASHING_WHIP", -1, DURATION_TYPE_TEMPORARY);		

    object oSkin = GetPCSkin(oPC);

    if(iClassLevel > 1 /* && !GetHasFeat(FEAT_IMPROVED_TRIP) */)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_TRIP));

    if(iClassLevel > 5 /* && !GetHasFeat(FEAT_PRC_IMP_DISARM) */)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PRC_IMPROVED_DISARM));

    itemproperty ip = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2);
    IPSafeAddItemProperty(oWhip, ip, 9999.0f);
    SetLocalInt(oWhip, "SLASHING_WHIP", 1);
}

void main()
{
    //Declare main variables.
    int nEvent = GetRunningEvent();
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        //case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
	
	object oSkin = GetPCSkin(oPC);
	
    int iClassLevel = GetLevelByClass(CLASS_TYPE_LASHER, oPC);
	
	if (nEvent == FALSE)
	{
		if(DEBUG) DoDebug("prc_lasher: Registering Events");
		AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_lasher", TRUE, FALSE);
		AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_lasher", TRUE, FALSE);			
	}	
	else if (nEvent == EVENT_ONPLAYEREQUIPITEM)
	{
		if (!GetIsObjectValid(oPC)) return;
		{	
			if(DEBUG) DoDebug("prc_lasher: Running EVENT_ONPLAYEREQUIPITEM");
				
			object oMain = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
			object oOff  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

			ApplyWhipBonuses(oPC, oMain, iClassLevel);
			ApplyWhipBonuses(oPC, oOff, iClassLevel);			
		}
	}
	else if (nEvent == EVENT_ONPLAYERUNEQUIPITEM)
	{
		if(DEBUG) DoDebug("prc_lasher: Running EVENT_ONPLAYERUNEQUIPITEM");
					
		object oItem = GetItemLastUnequipped();
		object oMain = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		
		if (GetIsObjectValid(oItem) && GetBaseItemType(oItem) == BASE_ITEM_WHIP)
		{
			if(iClassLevel > 1)    //improved knockdown (whip)
			{
				if(DEBUG) DoDebug("prc_lasher: Removing Improved Trip (Whip)");
				RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,	IP_CONST_FEAT_IMPROVED_TRIP);
			}						
					
			if(iClassLevel > 5)    //improved disarm (whip)
			{
				if(DEBUG) DoDebug("prc_lasher: Removing Improved Disarm (Whip)");
				RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_IMPROVED_DISARM);
			}	

			RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2, 1, "SLASHING_WHIP", -1, DURATION_TYPE_TEMPORARY);

			if(DEBUG) DoDebug("prc_lasher: Removing Class Ability Bonuses");
			RemoveFeatBonuses(oPC);	
						
		}	
	}
}



		// OFF HAND
/* 		if (GetIsObjectValid(oOff) && GetBaseItemType(oOff) == BASE_ITEM_WHIP)
		{
			itemproperty ipCheck = GetFirstItemProperty(oOff);
			while (GetIsItemPropertyValid(ipCheck))
			{
				if (GetItemPropertyType(ipCheck) == ITEM_PROPERTY_DAMAGE_BONUS &&
					GetItemPropertySubType(ipCheck) == IP_CONST_DAMAGETYPE_SLASHING &&
					GetItemPropertyCostTableValue(ipCheck) == IP_CONST_DAMAGEBONUS_2)
				{
					RemoveItemProperty(oOff, ipCheck);
				}
				ipCheck = GetNextItemProperty(oOff);
			}

			itemproperty ip = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2);
			AddItemProperty(DURATION_TYPE_PERMANENT, ip, oOff);
		}
	} */


/* void main()
{
    object oPC = OBJECT_SELF;
    object oWeapon;
    int iEquip = GetLocalInt(oPC,"ONEQUIP");  //2 = equip, 1 = unequip

    if(iEquip == 2) //OnEquip
    {
        oWeapon = GetPCItemLastEquipped();
        ApplyBonuses(oPC, oWeapon);
    }
    else if (iEquip == 1) //OnUnEquip
    {
        oWeapon = GetPCItemLastUnequipped();
        RemoveBonuses(oPC, oWeapon);
    }
    if(GetLocalInt(oPC,"ONENTER") == 1)
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        ApplyBonuses(oPC, oWeapon);
    }

} */
