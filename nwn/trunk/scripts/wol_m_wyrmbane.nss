//::///////////////////////////////////////////////
//:: Name           Wyrmbane Helm maintain script
//:: FileName       wol_m_wyrmbane
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 8th, -2 at 12th, -3 at 18th
Hit Point Penalty: -2 at 6th, -4 at 7th, -6 at 9th, -8 at 13th, -10 at 15th, -12 at 19th
Spell Slot Lost: 1st at 6th, 2nd at 8th, 3rd at 10th, 4th at 14th, 5th at 16th, 6th at 20th
  
LEGACY ITEM BONUSES
None
  
LEGACY ITEM ABILITIES
Cause Fear (Sp): Starling at 5th level, you can use cause fear as a spell-like ability five times per day (caster level 5th). The save DC is 11 or 11 + your Cha modifier, whichever is higher.
Courage (Su): Starting at 6th level, you gain a +4 morale bonus on saving throws against fear effects.
Lightning Bolt (Sp): Starting at 8th level, you can use lightning bolt as a spell-like ability once per day (caster level 7th). The save DC is 14 or 13 + your Cha modifier, whichever is higher.
Dragonbane (Su): Any melee weapon you wield gains a +2 enhancement bonus and deals an extra 2d6 points of damage when you attack a creature of the dragon type. 

In addition, any spell you cast that deals damage to a dragon deals an extra 2d6 points of damage to that dragon. If the spell allows a saving throw, the DC of the saving throw increases by 2. 
A single spell can never deal this extra damage more than once per casting. However, if a spell deals damage for more than 1 round, it deals the extra damage in each round.
Blindsense (Su): You gain Blindsense.
Charisma Boost (Su): Starting at 14th level, you gain a +4 enhancement bonus to your Charisma as long as you wear the Wyrmbane Helm.
Sudden Empower (Su): At 16th level, you gain the ability to apply the Empower Spell metamagic feat to any spell you cast without increasing the level of the spell or preparing it ahead of time. You can use this ability three times per day.
Frightful Presence (Su): When you charge, attack, or cast a spell while wearing the helm, you force nearby enemies to make a fear check.
Immune to Electricity: Starting at 18th level, you are immune to electricity damage as long as you wear the Wyrmbane Helm.
Strength Boost (Su): Starting at 19th level, you gain a +6 enhancement bonus to your Strength as long as you wear the helm.
Lightning Breath (Su): At 20th level, you gain a breath weapon that you can use three times per day and never in consecutive rounds. Your lightning breath deals I2d8 points of damage in a 100-foot line(DC25 or 20 + your Con modifier, whichever is higher). 
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_wyrmbane running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC, oItem;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    int nSlot = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Wyrmbane");
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_HEAD, oPC))
    {
    	SetCompositeBonus(oSkin, "Wyrmbane_Fear", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_FEAR);
    	SetCompositeAttackBonus(oPC, "Wyrmbane_Atk", 0, ATTACK_BONUS_MISC);
    	SetCompositeBonus(oSkin, "Wyrmbane_Cha", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CHA);
    	SetCompositeBonus(oSkin, "Wyrmbane_Str", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
    	return;
    }    
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
	    // 5th to 10th level abilities
	    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
	    {
	        if(nHD >= 5)
	        {
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WYRMBANE_FEAR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
	        }         
	        if(nHD >= 6)
	        {
	            nHPPen += 2;
	            nSlot = 1;
	            SetCompositeBonus(oSkin, "Wyrmbane_Fear", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_FEAR);
	        }     
	        if(nHD >= 7)
	        {
	            nHPPen += 2;
	        } 
	        if(nHD >= 8)
	        {
	            nSlot = 2;
	            SetCompositeAttackBonus(oPC, "Wyrmbane_Atk", -1, ATTACK_BONUS_MISC);
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WYRMBANE_BOLT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
	        } 
	        if(nHD >= 9)
	        {
	            nHPPen += 2;
	        }
	        if(nHD >= 10)
	        {
	            nSlot = 3;
                if(DEBUG) DoDebug("wol_m_wyrmbane: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_wyrmbane", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_wyrmbane", TRUE, FALSE); 	 
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BANE_MAGIC_DRAGON), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
	        }    
	    }
	    // 11th to 16th level abilities
	    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
	    {    
	        if(nHD >= 11)
	        {
	        }
	        if(nHD >= 12)
	        {
	            SetCompositeAttackBonus(oPC, "Wyrmbane_Atk", -2, ATTACK_BONUS_MISC);
	            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectUltravision()), "WOLEffect"), oPC);
	        }    
	        if(nHD >= 13)
	        {
	            nHPPen += 2;
	        }
	        if(nHD >= 14)
	        {
	            nSlot = 4;
	            SetCompositeBonus(oSkin, "Wyrmbane_Cha", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CHA);
	        }            
	        if(nHD >= 15)
	        {
	            nHPPen += 2;
	        }    
	        if(nHD >= 16)
	        {
	            nSlot = 5;
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WYRMBANE_EMP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
	        }     
	    }
	    // 17th+ level abilities
	    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
	    {    
	        if(nHD >= 17)
	        {    
	        	AddEventScript(oPC, EVENT_ONHEARTBEAT, "wol_m_wyrmbane", TRUE, FALSE);
	        }  
	        if(nHD >= 18)
	        {
	            SetCompositeAttackBonus(oPC, "Wyrmbane_Atk", -3, ATTACK_BONUS_MISC);
	            IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
	        } 
	        if(nHD >= 19)
	        {
	            nHPPen += 2;
	            SetCompositeBonus(oSkin, "Wyrmbane_Str", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
	        } 
	        if(nHD >= 20)
	        {
	            nSlot = 6;   
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WYRMBANE_BREATH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
	        } 
	    }    
	        
	    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
	    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
	    {
	        WoLHealthPenaltyHB(oPC);
	        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
	    }
	    WoLSpellSlotPenalty(oPC, nSlot); 
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_wyrmbane - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if((oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) || oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) && IPGetIsMeleeWeapon(oItem))
        {
        	int nEnhance = IPGetWeaponEnhancementBonus(oItem);
        	SetCompositeBonusT(oItem, "Wyrmbane_Dragonbane", nEnhance+2, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_DRAGON);
        	SetCompositeBonusT(oItem, "Wyrmbane_DragonbaneD", IP_CONST_DAMAGEBONUS_2d6, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_DRAGON);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_wyrmbane - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(IPGetIsMeleeWeapon(oItem))
        {
        	SetCompositeBonusT(oItem, "Wyrmbane_Dragonbane", 0, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_DRAGON);
        	SetCompositeBonusT(oItem, "Wyrmbane_DragonbaneD", 0, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_DRAGON);        
        }
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
		if (GetIsInCombat(oPC))
			ExecuteScript("prc_fright_pres", oPC);
    }// end if - Running HB event      
}