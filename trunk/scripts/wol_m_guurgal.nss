//::///////////////////////////////////////////////
//:: Name           Guurgal maintain script
//:: FileName       wol_m_guurgal
//:://////////////////////////////////////////////
/*
Show of Force (Sp): Beginning at 5th level, once per day on command, you can use mirror image as the spell. Caster level 5th. 
Incite Horde (Su): At 7th level and higher, Guurgal grants a +1 morale bonus on attack rolls and saving throws against fear to all orcs within 30 feet of you. This feature, however, does not affect you. 
Gather the Horde (Su): At 8th level, you gain a +5 bonus on Diplomacy and Intimidate checks made to influence orcs. 
Bloodlust (Su): Starting at 13th level, whenever you deal an opponent damage with Guurgal, you gain a +1 morale bonus on your next attack against the same opponent. The next attack must occur within 1 round, 
or the bonus is lost. The bonus is cumulative, so if your next attack hits, you gain a +2 morale bonus on your following attack against that opponent, and so on. 
Battlefield Fury (Su): At 14th level and higher, as long as you are leading at least three other orcs or half-orcs on the field of battle, you gain a +2 morale bonus to Strength. 
Rage of the Boar (Su): Beginning at 20th level, once per day as a swift action, for 10 rounds, you gain a +6 bonus to Strength and Constitution along with a +3 bonus on Will saves, but you take a –2 penalty to AC.  

LEGACY ITEM BONUSES
10th - +2 cold iron spear
16th - +3 cold iron spear
17th - +3 wounding cold iron spear
19th - +5 wounding cold iron spear
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_guurgal running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_Guurgal");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Guurgal_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Guurgal_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Guurgal_P", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "Guurgal_I", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE); 
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
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GUURGAL_FORCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                SetCompositeAttackBonus(oPC, "Guurgal_Atk", -1, ATTACK_BONUS_MISC);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Guurgal_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            } 
                if(nHD >= 8)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Guurgal_P", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
                SetCompositeBonus(oSkin, "Guurgal_I", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);            
            } 
            if(nHD >= 9)
            {
               SetCompositeBonus(oSkin, "Guurgal_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            }
            if(nHD >= 10)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
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
                SetCompositeAttackBonus(oPC, "Guurgal_Atk", -2, ATTACK_BONUS_MISC);
            }    
            if(nHD >= 13)
            {
                if(DEBUG) DoDebug("wol_m_guurgal: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_guurgal", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_guurgal", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_guurgal", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);              
            }
            if(nHD >= 14)
            {
                nHPPen += 2;
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "Guurgal_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
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
                SetCompositeAttackBonus(oPC, "Guurgal_Atk", -3, ATTACK_BONUS_MISC);
            } 
            if(nHD >= 19)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "Guurgal_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GUURGAL_RAGE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
        if(DEBUG) DoDebug("wol_m_guurgal - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_guurgal", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_guurgal - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_guurgal", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_guurgal: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Caput Mortuum
        if(oItem == oWOL)
        {
            // Bloodlust
            if (nHD >= 13)
                DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, VersusRacialTypeEffect(SupernaturalEffect(EffectAttackIncrease(1)), GetRacialType(oTarget)), oPC, 6.0));
            // Wounding only works on those not critical immune
            if (nHD >= 17 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) && GetHasFeat(FEAT_GREATER_LEGACY, oPC))
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 1, DURATION_TYPE_PERMANENT);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event   
    else if(nEvent == EVENT_ONHEARTBEAT && nHD >= 7)
    {
        location lTarget = GetLocation(oPC);
        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget))
        {
            int nRace = MyPRCGetRacialType(oAreaTarget);
            if(oAreaTarget != oPC && // Not you
               GetIsFriend(oAreaTarget, oPC) && // Only allies
              (nRace == RACIAL_TYPE_HUMANOID_ORC || nRace == RACIAL_TYPE_HALFORC)) // Only orcs
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR)), oAreaTarget, 6.0);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAttackIncrease(1)), oAreaTarget, 6.0);
            }
            //Select the next target within the spell shape.
            oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        } 
        
        if (nHD >= 14)
        {
            int nCount = 0;
            object oParty = GetFirstFactionMember(oPC);
            while(GetIsObjectValid(oParty))
            {
                int nRace = MyPRCGetRacialType(oParty);
                if(oParty != oPC && // Not you
                   (nRace == RACIAL_TYPE_HUMANOID_ORC || nRace == RACIAL_TYPE_HALFORC)) // Only allied orcs
                {
                    nCount++;
                }
        
                oParty = GetNextFactionMember(oPC);
            }     
            if (nCount >= 3)
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 2)), oPC, 6.0);
        }        
    }// end if - Running HB event      
}