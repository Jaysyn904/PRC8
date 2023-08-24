//::///////////////////////////////////////////////
//:: Name           Hammer of Witches maintain script
//:: FileName       wol_m_witches
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 7th
Hit Point Penalty: -2 at 6th, -4 at 7th, -6 at 9th, -8 at 13th, -10 at 15th, -12 at 19th
Spell Slot Lost: 1st at 6th, 2nd at 8th, 3rd at 10th, 4th at 12th, 5th at 14th, 6th at 16th, 7th at 18th, 8th at 20th 
  
LEGACY ITEM BONUSES
10th - +2 Warhammer
14th - +3 Warhammer
17th - +4 Wizard Bane Warhammer
  
LEGACY ITEM ABILITIES
Magefinder (Sp): At 5th level and higher, at will on command, you can use detect magic as the spell. Caster level 5th. 
Spellbreaker (Su): Starting at 8th level, once per day upon making a successful attack roll with Hammer of Witches against an opponent, you can use the 
targeted form of dispel magic on that foe or item. Caster level 10th. Beginning at 11th level, you can use this feature two times per day. 
Witchmantle (Su): At 13th level, you gain spell resistance against arcane spells equal to 5 + your character level. 
Antimagic Field (Sp): Beginning at 16th level, once per day on command, you can use antimagic field as the spell. Caster level 11th. 
Countermagic (Su): At 18th level and higher, once per day as an immediate action, you can cast greater dispel magic. Caster level 15th. 
Greater Spell Immunity (Sp): Starting at 20th level, once per day on command, you can use greater spell mantle as the spell. Caster level 20th. 
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_witches running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_HammerWitches");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
        // 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 5)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WITCHES_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                nSlot = 1;
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeAttackBonus(oPC, "HammerWitches_Atk", -1, ATTACK_BONUS_MISC);
            } 
            if(nHD >= 8)
            {
                nSlot = 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WITCHES_SPELLBREAKER), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
            } 
            if(nHD >= 9)
            {
                nHPPen += 2;
            }
            if(nHD >= 10)
            {
                nSlot = 3;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));                
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WITCHES_AMF), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
            }
            if(nHD >= 12)
            {
                nSlot = 4;
            }    
            if(nHD >= 13)
            {
                nHPPen += 2;
                SetLocalInt(oPC, "HammerWitchesSR", TRUE);
            }
            if(nHD >= 14)
            {
                nSlot = 5;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));                
            }            
            if(nHD >= 15)
            {
                nHPPen += 2;
            }    
            if(nHD >= 16)
            {
                nSlot = 6;
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
                if(DEBUG) DoDebug("wol_m_witches: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_witches", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_witches", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_witches", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
            }  
            if(nHD >= 18)
            {
                nSlot = 7;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WITCHES_DISPEL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
            } 
            if(nHD >= 19)
            {
                nHPPen += 2;
            } 
            if(nHD >= 20)
            {
                nSlot = 8;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WITCHES_MANTLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);               
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
        if(DEBUG) DoDebug("wol_m_witches - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_witches", TRUE, FALSE);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_witches - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(GetBaseItemType(oItem) == BASE_ITEM_WARHAMMER)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_witches", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_witches: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Hammer of Witches
        if(oItem == oWOL)
        {
            if (GetLevelByTypeArcane(oTarget)) // Wizard bane
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2), DAMAGE_TYPE_POSITIVE), oTarget);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
}