//::///////////////////////////////////////////////
//:: Name           Caput Mortuum maintain script
//:: FileName       wol_m_dymond
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 7th, -2 at 16th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th

LEGACY ITEM BONUSES
7th - +2 Longsword
11th - +3 Longsword
16th - +4 Longsword
17th - +5 Longsword

LEGACY ITEM ABILITIES
Shed Bolts (Sp): Starting at 5th level, once per day as an immediate action, you can use protection from arrows. Caster level 5th.
Deflect Attack (Su): At 6th level and higher, once per day you can deflect the next ranged touch attack that would otherwise hit you.
Daylight (Sp): Beginning at 9th level, once per day, you can cast Daylight as the spell. Caster level 5th.
Green Flame (Su): At 13th level and higher, a successful attack causes that creature to be outlined in faerie fire, as per the spell. Caster level 10th.
Shielding Beneficence of the Green Powers (Su): At 14th level, you gain a +3 deflection bonus to Armor Class.
Healing Grace of the Green Powers (Sp): At 18th level, you can cast cure critical wounds four times per day. Caster level 10th.
Protective Embrace of the Green Powers (Su): At 19th level, you gain a +5 resistance bonus to all saving throws.
Ban of the Green Powers (Sp): Starting at 20th level, once per day you may cast banishment. The save DC is 20, or 17 + your Charisma modifier, whichever is higher. Caster level 15th.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_dymond running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_Dymondheart");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeAttackBonus(oPC, "Dymond_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Dymond_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Dymond_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Dymond_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
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
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DYMOND_BOLTS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }         
	        if(nHD >= 6)
	        {
	            nHPPen += 4;
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DYMOND_DEFLECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }     
	        if(nHD >= 7)
	        {
	            SetCompositeBonus(oSkin, "Dymond_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	            SetCompositeBonus(oSkin, "Dymond_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
	            SetCompositeBonus(oSkin, "Dymond_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);	  
	            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));  
	        } 
	        if(nHD >= 8)
	        {

	        } 
	        if(nHD >= 9)
	        {
	            SetCompositeAttackBonus(oPC, "Dymond_Atk", -1, ATTACK_BONUS_MISC);
	            nHPPen += 2;
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DYMOND_DAYLIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        }
	        if(nHD >= 10)
	        {
          
	        }            
	    }
	    // 11th to 16th level abilities
	    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
	    {    
	        if(nHD >= 11)
	        {
	            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));	            
	        }
	        if(nHD >= 12)
	        {
	            nHPPen += 2;
	        }    
	        if(nHD >= 13)
	        {
	            SetCompositeAttackBonus(oPC, "Dymond_Atk", -2, ATTACK_BONUS_MISC);
                if(DEBUG) DoDebug("wol_m_dymond: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_dymond", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_dymond", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_dymond", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  	            
	        }
	        if(nHD >= 14)
	        {
	        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(3, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
	        }            
	        if(nHD >= 15)
	        {
	            nHPPen += 2;
	        }    
	        if(nHD >= 16)
	        {
	            SetCompositeBonus(oSkin, "Dymond_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	            SetCompositeBonus(oSkin, "Dymond_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
	            SetCompositeBonus(oSkin, "Dymond_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
	            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
	        }     
	    }
	    // 17th+ level abilities
	    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
	    {    
	        if(nHD >= 17)
	        {       
	            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
	        }  
	        if(nHD >= 18)
	        {
	            nHPPen += 2;
	            SetCompositeBonus(oSkin, "Dymond_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
	            SetCompositeBonus(oSkin, "Dymond_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
	            SetCompositeBonus(oSkin, "Dymond_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
	            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DYMOND_CURE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	        if(nHD >= 19)
	        {
	            nHPPen += 2;
	            IPSafeAddItemProperty(oSkin, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5));
	        } 
	        if(nHD >= 20)
	        {
	            nHPPen += 2;
	            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DYMOND_BANISH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        } 
	    }   
            
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_dymond - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_dymond", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_dymond - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_SCYTHE)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_dymond", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_dymond: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Dymondheart
        if(oItem == oWOL)
        {
            // Faerie Fire
            if (nHD >= 13)
                ActionCastSpell(SPELL_FAERIE_FIRE, 10, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oTarget);  
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
}