//::///////////////////////////////////////////////
//:: Name           Full Moon's Trick maintain script
//:: FileName       wol_m_fullmoon
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Reflex Save Penalty: -1 at 7th, -2 at 12th
Hit Point Penalty: -2 at 6th, -4 at 10th
Skill Check Penalty: -1 at 7th, -2 at 8th, -3 at 14th, -4 at 16th, -5 at 19th, -6 at 20th

LEGACY ITEM BONUSES
10th - +2 Short Sword
19th - +4 Short Sword

LEGACY ITEM ABILITIES
Wolfsbane (Su): Starting at 5th level, whenever you use Full Moon’s Trick to strike a creature that is not in its natural form, that creature must make a DC 15 Will save or return to its natural form. 
Quiet As a Shadow (Su): At 7th level, you gain a +5 bonus on Hide and Move Silently checks. This bonus improves to +10 at 18th level. 
Form Mastery (Su): Beginning at 8th level, you gain a +2 bonus on saving throws against transmutation magic. 
Darkvision (Su): At 11th level, you gain darkvision out to 60 feet.
Shifter’s Bane (Su): Once you have attained 16th level, Full Moon’s Trick becomes shapechanger bane. 
Feral Fury (Sp): Beginning at 17th level, three times per day on command, you can use rage as the spell. Caster level 15th. 
Shadows and Moonlight (Sp): At 20th level and higher, two times per day on command, you can use greater invisibility as the spell. You can use the spell only on yourself. Caster level 15th.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_fullmoon running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_FullMoon");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeBonus(oSkin, "FullMoon_HIDE", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        SetCompositeBonus(oSkin, "FullMoon_MS", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
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
                if(DEBUG) DoDebug("wol_m_fullmoon: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_fullmoon", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_fullmoon", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_fullmoon", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
            }     
            if(nHD >= 7)
            {
                if (8 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
                SetCompositeBonus(oSkin, "FullMoon_HIDE", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
                SetCompositeBonus(oSkin, "FullMoon_MS", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
            } 
            if(nHD >= 8)
            {
                if (14 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
                SetLocalInt(oPC, "FullMoon_Trans", TRUE);
            } 
            if(nHD >= 9)
            {

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
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectUltravision()), "WOLEffect"), oPC);
            }
            if(nHD >= 12)
            {

            }    
            if(nHD >= 13)
            {

            }
            if(nHD >= 14)
            {
                if (16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
            }            
            if(nHD >= 15)
            {
            }    
            if(nHD >= 16)
            {
                if (19 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 4)), "WOLEffect"), oPC);
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 4));
                IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6));                 
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FULLMOON_RAGE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }  
            if(nHD >= 18)
            {
                SetCompositeBonus(oSkin, "FullMoon_HIDE", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
                SetCompositeBonus(oSkin, "FullMoon_MS", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);            
            } 
            if(nHD >= 19)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));   
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_SHAPECHANGER, 6));
                if (20 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 5)), "WOLEffect"), oPC);
            } 
            if(nHD >= 20)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 6)), "WOLEffect"), oPC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FULLMOON_INVIS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
        if(DEBUG) DoDebug("wol_m_fullmoon - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_fullmoon", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_fullmoon - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_fullmoon", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_fullmoon: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Caput Mortuum
        if(oItem == oWOL)
        {
            effect eBad = GetFirstEffect(oTarget);
            //Search for negative effects
            while(GetIsEffectValid(eBad))
            {
                int nInt = GetEffectSpellId(eBad);
                if (GetEffectType(eBad) == EFFECT_TYPE_POLYMORPH)
                {
                    //Remove effect if they fail a save
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 15, SAVING_THROW_TYPE_NONE))
                    {
                        RemoveEffect(oTarget, eBad);
                    }
                }
                eBad = GetNextEffect(oTarget);
            }
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
}