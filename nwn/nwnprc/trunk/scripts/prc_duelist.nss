//::///////////////////////////////////////////////
//:: [Duelist Feats]
//:: [prc_duelist.nss]
//:://////////////////////////////////////////////
//:: Check to see which Duelist feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 20, 2003
//:://////////////////////////////////////////////
//:: Fixed By: Stratovarius
//:: Fixed On: Sep 05, 2018
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "x0_i0_modes"

// * Applies the Duelist's AC bonuses as CompositeBonuses on the object's skin.
// * AC bonus is determined by object's int bonus
// * iOnOff = TRUE/FALSE
void DuelistCannyDefense(object oPC, object oSkin, int iOnOff)
{
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);

    // limits bonus to class level as per 3.5e rules.
    int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST,oPC);
    if(iIntBonus > iDuelistLevel) iIntBonus = iDuelistLevel;

    if(iOnOff){
        SetCompositeBonus(oSkin, "CannyDefenseBonus", iIntBonus, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != TRUE)
            SetLocalInt(oPC, "CannyDefense", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "CannyDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != FALSE)
            SetLocalInt(oPC, "CannyDefense", FALSE);
   }
}

// * Applies the Duelist's reflex bonuses as CompositeBonuses on the object's skin.
// Bonus is always 2
void DuelistGrace(object oPC, object oSkin)
{
    if(!GetLocalInt(oPC, "Grace"))
    {   
        SetCompositeBonus(oSkin, "GraceBonus", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetLocalInt(oPC, "Grace") != TRUE)
            SetLocalInt(oPC, "Grace", TRUE);
    }
    else 
    {
        SetCompositeBonus(oSkin, "GraceBonus", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetLocalInt(oPC, "Grace") != FALSE)
	        SetLocalInt(oPC, "Grace", FALSE);
   }
}


// Incorrect, archived
/*
void RemoveDuelistPreciseStrike(object oWeap)
{
   int iSlashBonus = GetLocalInt(oWeap,"DuelistPreciseSlash");
   if (iSlashBonus) RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, iSlashBonus, 1, "DuelistPreciseSlash", -1, DURATION_TYPE_TEMPORARY);
}

void DuelistPreciseStrike(object oPC, object oWeap)
{
   int iSlashBonus = 0;
   int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST,oPC);

   RemoveDuelistPreciseStrike(oWeap);

   // since new duelist gains it every 5 levels
   iDuelistLevel /= 5;

   switch(iDuelistLevel)
   {
      case 1:
           iSlashBonus = IP_CONST_DAMAGEBONUS_1d4;
           break;
      case 2:
           iSlashBonus = IP_CONST_DAMAGEBONUS_2d4;
           break;
      case 3:
           iSlashBonus = IP_CONST_DAMAGEBONUS_3d4;
           break;
      case 4:
           iSlashBonus = IP_CONST_DAMAGEBONUS_4d4;
           break;
      case 5:
           iSlashBonus = IP_CONST_DAMAGEBONUS_5d4;
           break;
      case 6:
           iSlashBonus = IP_CONST_DAMAGEBONUS_6d4;
           break;
   }

   int nDamageType = GetWeaponDamageType(oWeap);
   if(iSlashBonus) 
   {
   	SetLocalInt(oWeap,"DuelistPreciseSlash",iSlashBonus); // misnomer for simplicity's sake
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(nDamageType, iSlashBonus), oWeap, 99999.9);
   }
}

    if(bPStrk > 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD &&
      (GetBaseItemType(oWeapon) == BASE_ITEM_RAPIER ||
       GetBaseItemType(oWeapon) == BASE_ITEM_DAGGER ||
       GetBaseItemType(oWeapon) == BASE_ITEM_SHORTSWORD))
          DuelistPreciseStrike(oPC, oWeapon);

    if(GetLocalInt(oPC,"ONEQUIP") == 1)
       RemoveDuelistPreciseStrike(GetItemLastUnequipped());

    if(GetBaseAC(oArmor) != 0 ||
       GetBaseItemType(oLefthand) == BASE_ITEM_SMALLSHIELD ||
       GetBaseItemType(oLefthand) == BASE_ITEM_LARGESHIELD ||
       GetBaseItemType(oLefthand) == BASE_ITEM_TOWERSHIELD)
          RemoveDuelistPreciseStrike(oWeapon);
*/

void main()
{
    int nEvent = GetRunningEvent();
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
    int nDuel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    if(nEvent == FALSE)
    {
    	//Determine which duelist feats the character has
    	int bCanDef = GetHasFeat(FEAT_CANNY_DEFENSE, oPC);
    	int bGrace = GetHasFeat(FEAT_GRACE, oPC);
    	int iLefthand = GetBaseItemType(oLefthand);

    	//Apply bonuses accordingly
    	if(bCanDef > 0 && GetBaseAC(oArmor) == 0 &&
    	GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
       	GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       	GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD)
        	DuelistCannyDefense(oPC, oSkin, TRUE);
    	else
        	DuelistCannyDefense(oPC, oSkin, FALSE);            
            
        if(bGrace > 0 && GetBaseAC(oArmor) == 0 &&
	    GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
	    GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
	    GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD)
	    	DuelistGrace(oPC, oSkin);
	    else
          	DuelistGrace(oPC, oSkin);

        //Defensive Strike
        /*if(nDuel >= 7 && GetHasFeat(FEAT_EXPERTISE, oPC))
        {
            if(DEBUG) DoDebug("prc_duelist: Adding eventhooks");
            AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_duelist", TRUE, FALSE);
        }*/
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_duelist", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_duelist", TRUE, FALSE);  
    }
    // We're being called from the OnHeartbeat eventhook, so check or skip
    /*if(nEvent == EVENT_ONHEARTBEAT)
    {
        // Only applies when using expertise
        if(GetModeActive(ACTION_MODE_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_EXPERTISE) || GetLastAttackMode(oPC) == COMBAT_MODE_EXPERTISE ||
           GetModeActive(ACTION_MODE_IMPROVED_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE) || GetLastAttackMode(oPC) == COMBAT_MODE_IMPROVED_EXPERTISE)
        {
           effect eAC = EffectACIncrease(nDuel, AC_DODGE_BONUS);
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0);
        }
    }// end if - Running OnHeart event*/
    else if(nEvent == EVENT_ITEM_ONHIT && !GetIsObjectValid(oLefthand) && nDuel >= 5) // Left hand must be empty, Duelist must be at least level 5
    {
        oWeapon        = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_duelist: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oWeapon = " + DebugObject2Str(oWeapon) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons, target must not be immune to criticals/sneak attacks
        if(IPGetIsMeleeWeapon(oWeapon) && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) && !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK))
        {
            // Calculate Precise Strike damage and apply
            int nDam = d6(nDuel/5);
            effect eDam = EffectDamage(IPDamageConstant(nDam), DAMAGE_TYPE_MAGICAL); //Using this because any DR has already taken piercing damage
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            FloatingTextStringOnCreature("Precise Strike Damage: "+IntToString(nDam), oPC, FALSE); 
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM && nDuel >= 5) //Duelist has to be at least level 5
    {
        oPC   = GetItemLastEquippedBy();
        oWeapon = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_duelist - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oWeapon = " + DebugObject2Str(oWeapon) + "\n"
                          );

        // Only applies to one handed piercing weapons
        if(GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
           GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
           GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD &&
          (GetBaseItemType(oWeapon) == BASE_ITEM_RAPIER ||
			GetBaseItemType(oWeapon) == BASE_ITEM_DAGGER ||
			GetBaseItemType(oWeapon) == BASE_ITEM_ELVEN_THINBLADE ||
			GetBaseItemType(oWeapon) == BASE_ITEM_KATAR ||
			GetBaseItemType(oWeapon) == BASE_ITEM_LIGHT_PICK ||
			GetBaseItemType(oWeapon) == BASE_ITEM_ELVEN_LIGHTBLADE ||
			GetBaseItemType(oWeapon) == BASE_ITEM_SHORTSWORD))
        {
        
            // Add eventhook to the item
            AddEventScript(oWeapon, EVENT_ITEM_ONHIT, "prc_duelist", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM && nDuel >= 5) //Duelist has to be at least level 5
    {
        oPC   = GetItemLastUnequippedBy();
        oWeapon = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_duelist - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oWeapon = " + DebugObject2Str(oWeapon) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oWeapon))
        {
            // Add eventhook to the item
            RemoveEventScript(oWeapon, EVENT_ITEM_ONHIT, "prc_duelist", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oWeapon, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}
