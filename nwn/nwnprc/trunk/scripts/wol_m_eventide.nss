//::///////////////////////////////////////////////
//:: Name           Eventide's Edge maintain script
//:: FileName       wol_m_eventide
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
7th  - +1 Defending Mithral Short Sword
13th - +2 Defending Mithral Short Sword
16th - +3 Defending Mithral Short Sword
19th - +4 Defending Mithral Short Sword

LEGACY ITEM ABILITIES
Crux of Balance (Ex): At 5th level, you gain a +4 bonus on checks made to execute a bull rush, overrun, or trip, and to resist those maneuvers. 
Sting Like a Bee (Ex): Beginning at 8th level, you deal an extra 1d6 points of damage when you use Eventide’s Edge to make a melee attack against a foe of a larger size category than yours. When you attain 17th level, this extra damage increases to 2d6, provided you have performed Eventide’s Edge’s greater legacy ritual.
AC Bonus (Ex): Starting at 10th level, you add your Wisdom bonus (if any) to your AC when you are unarmored, unencumbered, and wielding Eventide’s Edge.
Baffling Defense (Ex): At 11th level, you can use the comet throw maneuver at will. If you already know comet throw, you gain a +2 bonus on melee touch attacks made while initiating the maneuver.
Evasive Defense (Ex): At 14th level, you can automatically succeed on your Sense Motive check when using baffling defense against an opponent of a larger size category than yours. This ability is usable three times per day.
Dance into the Sun (Su): At 20th level, you can cast improved invisibility two times per day. Caster level 10th.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_eventide running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
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
    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    int nSlot = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Eventide");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeAttackBonus(oPC, "Eventide_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Eventide_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "EventideACBonus", 0, ITEM_PROPERTY_AC_BONUS);
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
	            SetLocalInt(oPC, "EventideCrux", TRUE);
	        }         
	        if(nHD >= 6)
	        {
	            SetCompositeAttackBonus(oPC, "Eventide_Atk", -1, ATTACK_BONUS_MISC);
	        }     
	        if(nHD >= 7)
	        {
	            nHPPen += 2;
	            SetCompositeBonus(oSkin, "Eventide_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
                IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(1));
	        } 
	        if(nHD >= 8)
	        {
	            nHPPen += 2;
                if(DEBUG) DoDebug("wol_m_eventide: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_eventide", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_eventide", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_eventide", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                    
	        } 
	        if(nHD >= 9)
	        {
	           SetCompositeBonus(oSkin, "Eventide_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
	        }
	        if(nHD >= 10)
	        {
	            nHPPen += 2;
				object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
				int nArmour = GetItemACBase(oArmour);
		
				if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0 || GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 1)
					SetCompositeBonus(oSkin, "EventideACBonus", 1, ITEM_PROPERTY_AC_BONUS);
				else if (1 > nArmour) // No armour only
					SetCompositeBonus(oSkin, "EventideACBonus", GetAbilityModifier(ABILITY_WISDOM, oPC), ITEM_PROPERTY_AC_BONUS);
	        }    
	    }
	    // 11th to 16th level abilities
	    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
	    {    
	        if(nHD >= 11)
	        {
	        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVENTIDE_COMET), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }
	        if(nHD >= 12)
	        {
	        }    
	        if(nHD >= 13)
	        {
	        	SetCompositeAttackBonus(oPC, "Eventide_Atk", -2, ATTACK_BONUS_MISC);
	        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2)); 
	        }
	        if(nHD >= 14)
	        {
	            nHPPen += 2;
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVENTIDE_BAFFLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }            
	        if(nHD >= 15)
	        {
	            SetCompositeBonus(oSkin, "Eventide_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	        }    
	        if(nHD >= 16)
	        {
	            nHPPen += 2;
	           	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3)); 
	        }     
	    }
	    // 17th+ level abilities
	    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
	    {    
	        if(nHD >= 17)
	        {    
	        }  
	        if(nHD >= 18)
	        {
	        } 
	        if(nHD >= 19)
	        {
	        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4)); 
	        } 
	        if(nHD >= 20)
	        {
	            SetCompositeBonus(oSkin, "Eventide_SavesF", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
	            nHPPen += 2;
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVENTIDE_INVIS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
        if(DEBUG) DoDebug("wol_m_eventide - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_eventide", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_eventide - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_eventide", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_eventide: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Eventide's Edge
        if(oItem == oWOL)
        {
        	if (PRCGetCreatureSize(oTarget) > PRCGetCreatureSize(oPC) && GetHasFeat(FEAT_GREATER_LEGACY, oPC))
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), DAMAGE_TYPE_POSITIVE), oTarget);
        	else if (PRCGetCreatureSize(oTarget) > PRCGetCreatureSize(oPC))
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_POSITIVE), oTarget);            	
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
}