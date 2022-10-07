//::///////////////////////////////////////////////
//:: Name           Vicious maintain script
//:: FileName       wol_m_vicious
//:://////////////////////////////////////////////
/*
Vicious Synergy (Su): At 5th level, you gain a +5 competence bonus on Intimidate checks. When Vicious is within 30 feet of its twin, Devious, this bonus increases to +7. 
Vicious Intimidation (Sp): At 8th level and higher, the first time you successfully use Vicious to attack an opponent and deal damage, that opponent must save as if the target of a cause fear spell. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th. 
Completed Twin (Su): Once you reach 10th level, when Vicious is within 30 feet of Devious, its effective enhancement bonus is +1 better than normal.  
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_vicious running, event: " + IntToString(nEvent));

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
    object oItem;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Vicious");
    
    // You get nothing if you aren't wielding the legacy weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) && oWOL != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
    {
    	SetCompositeBonus(oSkin, "Vicious_Intim", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    	SetCompositeAttackBonus(oPC, "Vicious_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Vicious_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
        SetCompositeBonus(oSkin, "Vicious_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
        SetCompositeBonus(oSkin, "Vicious_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);    
        SetCompositeBonus(oSkin, "Devious_Intim", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
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
                SetCompositeBonus(oSkin, "Vicious_Intim", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;        
            }     
            if(nHD >= 7)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyKeen());
            } 
            if(nHD >= 8)
            {
                if(DEBUG) DoDebug("wol_m_vicious: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_vicious", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_vicious", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_vicious", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);     
            } 
            if(nHD >= 9)
            {
                SetCompositeAttackBonus(oPC, "Vicious_Atk", -1, ATTACK_BONUS_MISC);        
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);                
            }
            if(nHD >= 10)
            {
                SetCompositeBonus(oSkin, "Vicious_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                SetCompositeBonus(oSkin, "Vicious_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
                SetCompositeBonus(oSkin, "Vicious_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);                             
            }    
        }
            
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
        
        object oTwin = GetItemPossessedBy(oPC, "WOL_Devious");
        
        // You get none of this if you aren't wielding the twin
        if(oTwin != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) && oTwin != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) return;    
        // 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 5)
            {
                SetCompositeBonus(oSkin, "Devious_Intim", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
            }         
            if(nHD >= 10)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));                
            }    
        }    
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_vicious - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_vicious", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_vicious - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_KUKRI)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_vicious", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_vicious: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Vicious
        if(oItem == oWOL)
        {
            if (!GetLocalInt(oTarget, "Vicious_CauseFear"))
            {
                int nDC = 11;
                if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                    nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
                    
                ActionCastSpell(SPELL_SCARE, 5, 0, nDC, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oTarget);                      
                SetLocalInt(oTarget, "Vicious_CauseFear", TRUE);
            } 
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event       
}