//::///////////////////////////////////////////////
//:: Name           Blackrazor maintain script
//:: FileName       wol_m_blackrzr
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Fort Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th
  
LEGACY ITEM BONUSES
7th - +2 Greatsword
12th - +3 Greatsword
18th - +3 Vicious Greatsword
20th - +5 Vicious Greatsword

LEGACY ITEM ABILITIES
Mental Ward (Su): While wielding Blackrazor, you gain a bonus on saving throws against mind-affecting effects. When you attain 6th level, this bonus is +1, but it improves to +3 at 14th level and to +5 at 19th level.
Detect Life (Sp): Beginning at 9th level, three times per day, you can detect life. Caster level 5th.
Souldrinking (Sp): Beginning at 10th level, once per day, you can cast Death Knell. At 13th level, you can cast it three times per day. At 17th level, unlimited times per day. Caster level equals hit dice.
Haste (Sp): Beginning at 16th level, once per day, you can cast Haste. Caster level 10th.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_blackrzr running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_Blackrazor");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Blackrazor_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Blackrazor_Saves", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
        SetCompositeBonus(oSkin, "Blackrazor_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
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
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                SetCompositeAttackBonus(oPC, "Blackrazor_Atk", -1, ATTACK_BONUS_MISC);
                SetCompositeBonus(oSkin, "Blackrazor_Saves", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Blackrazor_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            } 
                if(nHD >= 8)
            {
                nHPPen += 2;
            } 
            if(nHD >= 9)
            {
               SetCompositeBonus(oSkin, "Blackrazor_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
               IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLACKRAZOR_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
            if(nHD >= 10)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLACKRAZOR_KNELL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
                SetCompositeAttackBonus(oPC, "Blackrazor_Atk", -2, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));  
            }    
            if(nHD >= 13)
            {
             
            }
            if(nHD >= 14)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Blackrazor_Saves", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "Blackrazor_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            }    
            if(nHD >= 16)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLACKRAZOR_HASTE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
                SetCompositeAttackBonus(oPC, "Blackrazor_Atk", -3, ATTACK_BONUS_MISC);
                if(DEBUG) DoDebug("wol_m_blackrzr: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_blackrzr", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_blackrzr", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_blackrzr", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                 
            } 
            if(nHD >= 19)
            {
             	SetCompositeBonus(oSkin, "Blackrazor_Saves", 3, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);   
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "Blackrazor_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
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
        if(DEBUG) DoDebug("wol_m_blackrzr - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_blackrzr", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_blackrzr - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_GREATSWORD)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_blackrzr", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_blackrzr: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Blackrazor
        if(oItem == oWOL)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_POSITIVE), oPC);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event       
}

