//::///////////////////////////////////////////////
//:: Skullclan Hunter
//:: prc_skullclan.nss
//:://////////////////////////////////////////////
//:: Check to see which Skullclan Hunter feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.
//:: Created On: July 12, 2006
//:://////////////////////////////////////////////

// To-Do: Use +20 / -20 Item prop vs undead on weapon

#include "prc_inc_combat"

//modification of GetWeaponAttackBonusProperty - hardcoded to NE Undead
//Used to make reduction adjust to match weapon, due to +20/-20 cap
int GetUndeadAttackBonusItemProperty(object oWeap)
{
	int iBonus = 0;
	int iPenalty = 0;
	int iTemp;

	int iRace = RACIAL_TYPE_UNDEAD;

	int iGoodEvil = 0;
	int iLawChaos = 50;
	int iAlignSpecific = GetItemPropAlignment(iGoodEvil, iLawChaos);
	int iAlignGroup;

	itemproperty ip = GetFirstItemProperty(oWeap);
	while(GetIsItemPropertyValid(ip))
	{
		iTemp = 0;
		int iIpType=GetItemPropertyType(ip);
		switch(iIpType)
		{
            case ITEM_PROPERTY_ATTACK_BONUS:
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                iTemp = GetItemPropertyCostTableValue(ip);
                break;

            case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
            case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
                iTemp - GetItemPropertyCostTableValue(ip);
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
                iAlignGroup = GetItemPropertySubType(ip);

                if (iAlignGroup == ALIGNMENT_NEUTRAL)
                {
                   if (iAlignGroup == iLawChaos)   iTemp = GetItemPropertyCostTableValue(ip);
                }
                else if (iAlignGroup == iGoodEvil || iAlignGroup == iLawChaos || iAlignGroup == IP_CONST_ALIGNMENTGROUP_ALL)
                {
                   iTemp = GetItemPropertyCostTableValue(ip);
                }
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
                if(GetItemPropertySubType(ip) == iRace )
                {
                     iTemp = GetItemPropertyCostTableValue(ip);
                 }
                 break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                if(GetItemPropertySubType(ip) == iAlignSpecific )
                {
                     iTemp = GetItemPropertyCostTableValue(ip);
                }
                break;
        }

		if (iTemp > iBonus)
			iBonus = iTemp;
		else if(iTemp < iPenalty)
			iPenalty = iTemp;

		ip = GetNextItemProperty(oWeap);
    }
	iBonus -= iPenalty;
    return iBonus;
}

//function to clear old penalty vs Undead
void ClearOldPenalties(object oPC)
{
   effect eLoop=GetFirstEffect(oPC);

   while (GetIsEffectValid(eLoop))
   {
      if (GetEffectType(eLoop)==EFFECT_TYPE_ATTACK_DECREASE 
          && GetEffectSubType(eLoop)==SUBTYPE_EXTRAORDINARY
          && GetEffectDurationType(eLoop)==DURATION_TYPE_PERMANENT
          && GetEffectSpellId(eLoop) == -1)
         RemoveEffect(oPC, eLoop);

      eLoop=GetNextEffect(oPC);
   }
}


// * Applies the Skullclan Hunters's immunities on the object's skin.
// * iType = IP_CONST_IMMUNITYMISC_*
// * sFlag = Flag to check whether the property has already been added
void SkullClanImmunity(object oPC, object oSkin, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(iType), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

/*void SkullClanAbilityDrain(object oPC, object oSkin, string sFlag)
{
	if(GetLocalInt(oSkin, sFlag) == TRUE) return;

	effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
	eAbil = SupernaturalEffect(eAbil);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbil, oPC);
	SetLocalInt(oSkin, sFlag, TRUE);
}*/

/*void SkullClanProtectionEvil(object oPC, object oSkin, string sFlag)
{
	if(GetLocalInt(oSkin, sFlag) == TRUE) return;

	effect eAC = VersusAlignmentEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS), ALIGNMENT_ALL, ALIGNMENT_EVIL);
	effect eSave = VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2), ALIGNMENT_ALL, ALIGNMENT_EVIL);
	effect eImmune = VersusAlignmentEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS), ALIGNMENT_ALL, ALIGNMENT_EVIL);

	effect eLink = EffectLinkEffects(eImmune, eSave);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = SupernaturalEffect(eLink);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SetLocalInt(oSkin, sFlag, TRUE);
}*/

// This is supposed to pierce all DR on undead only
void SkullClanSwordLight(object oPC, object oSkin, string sFlag)
{
	//if(GetLocalInt(oSkin, sFlag) == TRUE) return;

	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP, RACIAL_TYPE_UNDEAD, 20, -1, "", -1, DURATION_TYPE_TEMPORARY);
	int nBonusVsTarget = GetUndeadAttackBonusItemProperty(oItem);
	// Because there is no negative item property for attack vs race, we need to use a permanent effect.
	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonusVsRace(RACIAL_TYPE_UNDEAD, 20), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	// Now we check for left hand for duel wielders
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if(IPGetIsMeleeWeapon(oItem)) IPSafeAddItemProperty(oItem, ItemPropertyAttackBonusVsRace(RACIAL_TYPE_UNDEAD, 20), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	ClearOldPenalties(oPC);
	if (DEBUG) DoDebug("Bonus vs Undead: " + IntToString(nBonusVsTarget));
	
	SetLocalInt(oSkin, sFlag, TRUE);
	
	//if they're not getting any bonuses on weapons, they shouldn't get any penalties either.
	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if(oItem == OBJECT_INVALID) return;
	effect eAB = VersusRacialTypeEffect(EffectAttackDecrease(20 - nBonusVsTarget), RACIAL_TYPE_UNDEAD);
	eAB = ExtraordinaryEffect(eAB);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_skullclan running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    object oSkin = GetPCSkin(oPC);
    object oItem, oAmmo;
    int nClass = GetLevelByClass(CLASS_TYPE_SKULLCLAN_HUNTER, oPC);


    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        //Apply bonuses accordingly
        if(nClass >= 3) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_FEAR, "SkullClanFear");
        //if(nClass >= 4) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_DISEASE,  "SkullClanDisease");
        //if(nClass >= 4) SkullClanProtectionEvil(oPC, oSkin, "SkullClanProtectionEvil");
        if(nClass >= 5) SkullClanSwordLight(oPC, oSkin, "SkullClanSwordLight");
        //if(nClass >= 7) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_PARALYSIS,  "SkullClanParalysis");
        //if(nClass >= 8 && nClass < 10) SkullClanAbilityDrain(oPC, oSkin, "SkullClanAbilityDrain");
        //if(nClass >= 8) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN,  "SkullClanAbilityDrain");
        //Bioware doesn't have ability and level drain seperately. Damn them.
        //if(nClass >= 10) SkullClanImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, "SkullClanLevelDrain");


        // Set up the eventhooks, but don't start doing this until the Skullclan Hunter is level 2
        if(nClass >= 2)
        {
            if(DEBUG) DoDebug("prc_skullclan: Adding eventhooks");

            AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_skullclan", TRUE, FALSE);
            AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_skullclan", TRUE, FALSE);
        }
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        int nItemType = GetBaseItemType(oItem);
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_skullclan: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || IPGetIsProjectile(oItem))
        {
        	// Has to be able to sneak attack
        	// The target must be undead as well
        	if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && GetCanSneakAttack(oTarget, oPC))
        	{
        		// Get the total damage it can do
        		int nDam = d6(GetTotalSneakAttackDice(oPC));
        		if(DEBUG) DoDebug("prc_skullclan: OnHit Sneak Damage: " + IntToString(nDam));
        		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE);
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        	}
        }// end if - Item is a melee weapon and Two-Weapon Rend hasn't already been used up for the round
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_skullclan - OnEquip");if(DEBUG) DoDebug("Is Ranged? " + IntToString(GetWeaponRanged(oItem)));

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            // Makes sure to get ammo if its a ranged weapon
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_skullclan - OnUnEquip");

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, -1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP, RACIAL_TYPE_UNDEAD, 20, -1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, -1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, -1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, -1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_skullclan", TRUE, FALSE);
        }
    }
    if(DEBUG) DoDebug("prc_skullclan: Exiting");
}
