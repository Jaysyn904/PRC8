//::///////////////////////////////////////////////
//:: Name           Mindsplinter maintain script
//:: FileName       wol_m_mndsplntr
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Reflex Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th
  
LEGACY ITEM BONUSES
8th - +2 Morningstar
11th - +3 Morningstar
16th - +4 Thundering Morningstar

LEGACY ITEM ABILITIES
Bleak Future (Su): At 5th level and higher, when you successfully strike an opponent with Mindsplinter, that opponent becomes shaken for 1 round. The effects of successive strikes in the same round are not cumulative. The save DC is 11, or 11 + your Charisma modifier, whichever is higher.
Virtue Denied (Su): Starting at 6th level, once per day, you can cast a protection from good spell. Caster level 5th. 
Kiss of Death (Sp): At 9th level, two times per day, you can use death knell as the spell. The save DC is 13, or 12 + your Charisma modifier, whichever is higher. If the spell is successful, the DC of Mindsplinter’s legacy abilities increases by 2 for the duration of the death knell effect. Caster level 5th. 
Futile Struggle (Su): Beginning at 10th level, when you successfully damage an opponent with Mindsplinter, that enemy is affected as if by the cause fear spell. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th. 
Battle Shriek (Sp): At 14th level and higher, once per day on command, you can use shout as the spell. The save DC is 16, or 14 + your Charisma modifier, whichever is higher. Caster level 11th. 
Fierce Battle Shriek (Sp): Starting at 17th level, the Battle Shriek ability of Mindsplinter improves, meaning you instead use greater shout as the spell. The save DC is 22, or 18 + your Charisma modifier, whichever is higher. Caster level 15th. 
Ruinous Howl (Su): At 20th level and higher, once per day, if you succesfully strike a creature, they must save or die vs a death effect. The save DC is 23, or 19 + your Charisma modifier, whichever is higher.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_mndsplntr running, event: " + IntToString(nEvent));

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
    int nHPPen, nDC;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Mindsplinter");
    object oItem;
    int nKnell = GetHasSpellEffect(SPELL_DEATH_KNELL, oPC);
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Mindsplinter_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Mindsplinter_R", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
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
                if(DEBUG) DoDebug("wol_m_mndsplntr: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_mndsplntr", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_mndsplntr", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_mndsplntr", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
            }         
            if(nHD >= 6)
            {
                SetCompositeAttackBonus(oPC, "Mindsplinter_Atk", -1, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MS_VIRTUE_DENIED), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Mindsplinter_R", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            } 
            if(nHD >= 8)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
            } 
            if(nHD >= 9)
            {
                SetCompositeBonus(oSkin, "Mindsplinter_R", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MS_KISS_DEATH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
            if(nHD >= 10)
            {
                nHPPen += 2;
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
                SetCompositeAttackBonus(oPC, "Mindsplinter_Atk", -2, ATTACK_BONUS_MISC);
            }    
            if(nHD >= 13)
            {
                             
            }
            if(nHD >= 14)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MS_BATTLE_SHRIEK), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "Mindsplinter_R", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            }    
            if(nHD >= 16)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6));
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4)); 
                nHPPen += 2;
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
                SetCompositeAttackBonus(oPC, "Mindsplinter_Atk", -3, ATTACK_BONUS_MISC);
            } 
            if(nHD >= 19)
            {
                
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "Mindsplinter_R", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MS_RUINOUS_HOWL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
        if(DEBUG) DoDebug("wol_m_mndsplntr - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_mndsplntr", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_mndsplntr - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_mndsplntr", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_mndsplntr: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Mindsplinter
        if(oItem == oWOL)
        {
            if (!GetLocalInt(oTarget, "MindsplinterRound"))
            {
                nDC = 11;            
                if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                    nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
                if (nKnell) nDC += 2;
                effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
                
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
                {           
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, 6.0);  
                    SetLocalInt(oTarget, "MindsplinterRound", TRUE);
                    DelayCommand(5.9, DeleteLocalInt(oTarget, "MindsplinterRound"));
                }
            }    
            if(nHD >= 10)
            {
                nDC = 11;            
                if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                    nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
                if (nKnell) nDC += 2;
                
                effect eScare = EffectFrightened();
                effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                effect eLink = EffectLinkEffects(eMind, eScare);

                //Make Will save versus fear
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
                {
                   //Apply frightened effect on failed save
                   SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5),TRUE,-1,5);
                }
                else // apply shaken effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, RoundsToSeconds(5),TRUE,-1,5);
            }              
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
}