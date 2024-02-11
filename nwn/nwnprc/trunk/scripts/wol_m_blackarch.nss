//::///////////////////////////////////////////////
//:: Name           Bow of the Black Archer maintain script
//:: FileName       wol_m_blackarch
//:://////////////////////////////////////////////
/*
Drowseeker (Su): At 5th level and higher, while wielding the Bow of the Black Archer, you can detect any drow within 60 feet, although you must concentrate (a standard action) to do so. 

Eyes of Shadow (Sp): Beginning at 6th level, once per day on command, you can use darkvision as the spell. Caster level 5th. 

Longstrider (Sp): At 8th level and higher, three times per day on command, you can use longstrider as the spell. Caster level 5th. 

Hidden Hunter (Su): At 9th level, you gain a +5 competence bonus on Hide and Move Silently checks. 

Solace from Weakness (Sp): You gain power against the poisons and necromancy so commonly used by drow. Starting at 12th level, two times per day on command, 
you can use lesser restoration as the spell (self only). Caster level 5th. 

Friend to Shadows (Sp): In near-lightless conditions, you can strike with relative impunity and then vanish without a trace. 
At 13th level and higher, once per day on command, you can use shadow walk as the spell. Caster level 11th. 

Shocking Shot (Su): Beginning at 14th level, as a standard action, you can imbue an arrow nocked on the Bow of the Black Archer with electricity. 
If your shot with this arrow hits, the arrow deals an extra 5d6 points of electricity damage. This ability can be used ?ve times per day, and a use is wasted if the charged arrow misses. 

Deny the Demonweb Pits (Sp): Lolth’s servants have many powerful allies in the Abyss. At 16th level and higher, you gain a measure of defense against them. 
Two times per day on command, you can use protection from evil as the spell. Caster level 10th. 

Escape the Spider’s Bonds (Su): Webs and other entanglements hold no more fear for a wielder of the Bow of the Black Archer. Starting at 17th level, you 
constantly benefit from the effects of freedom of movement while you hold the bow in hand. Caster level 15th.

Mindarmor (Su): At 18th level, you gain a +3 insight bonus on Will saving throws to resist mindaffecting and compulsion effects. 

Fast Movement (Su): Once you attain 18th level, your base land speed increases by 10 feet. 

Pierce the Black Heart (Su): You and the Bow of the Black Archer become the ultimate expression of Shevarash’s fury. At 20th level and higher, once per day, 
you can fire an arrow from the Bow of the Black Archer that kills any drow struck by it, as if by a finger of death spell. You must declare that you are using this ability before making the attack. 
If the arrow misses, the effect is wasted for the day. The save DC is 20, or 17 + your Charisma modi?er, whichever is higher. Caster level 15th. 
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_blackarch running, event: " + IntToString(nEvent));

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
    itemproperty ipIP;
    int nMaxHP = GetMaxHitPoints(oPC);
    int nCurHP = GetCurrentHitPoints(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "BowoftheBlackArcher");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "WeaponofLegacy", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "WeaponofLegacy_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "WeaponofLegacy_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "WeaponofLegacy_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "BowBlackArch_H", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        SetCompositeBonus(oSkin, "BowBlackArch_MS", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
        SetCompositeBonus(oSkin, "BowBlackArch_MindSaves", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
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
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DROWSEEKER), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                nHPPen += 4;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EYES_SHADOW), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(2));
            } 
                if(nHD >= 8)
            {
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LONGSTRIDER), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 9)
            {
                SetCompositeBonus(oSkin, "BowBlackArch_H", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
                SetCompositeBonus(oSkin, "BowBlackArch_MS", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
                SetCompositeAttackBonus(oPC, "WeaponofLegacy", -1, ATTACK_BONUS_MISC);
            }
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 4));
                oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ELF,IP_CONST_DAMAGETYPE_PIERCING,IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
                if(DEBUG) DoDebug("wol_m_blackarch: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_blackarch", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_blackarch", TRUE, FALSE);                
            }
            if(nHD >= 12)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SOLACE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
            if(nHD >= 13)
            {
                SetCompositeAttackBonus(oPC, "WeaponofLegacy", -2, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FRIEND_SHADOWS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
            if(nHD >= 14)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SHOCKING_SHOT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }            
            if(nHD >= 15)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(3));
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 5));
            }    
            if(nHD >= 16)
            {
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DENY_DEMONWEB), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
                effect eLink =                          EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
                       eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
                       eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
                       eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
                       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
                       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        
                // Search and remove effects of the types the target is being granted immunity to
                effect eLook = GetFirstEffect(oPC);
                while(GetIsEffectValid(eLook))
                {
                    if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
                       GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
                       GetEffectType(eLook) == EFFECT_TYPE_SLOW     ||
                       GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
                       )
                    {
                        RemoveEffect(oPC, eLook);
                    }
                    eLook = GetNextEffect(oPC);
                }
        
                // Apply the effects
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(eLink), "WOLEffect"), oPC);    
            }  
            if(nHD >= 18)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "BowBlackArch_MindSaves", 3, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
            } 
            if(nHD >= 19)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "WeaponofLegacy_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(4));
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ELF, 6));
            } 
            if(nHD >= 20)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PIERCE_BLACK_HEART), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
        if(DEBUG) DoDebug("wol_m_blackarch - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            if(nHD >= 11 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))
            {            
                oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ELF,IP_CONST_DAMAGETYPE_PIERCING,IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_blackarch - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to longbows, since we know that's what the Bow of the Black Archer is
        if(GetBaseItemType(oItem) == BASE_ITEM_ARROW)
        {
            if(nHD >= 11 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))
            {
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_ELF,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_PIERCING,DURATION_TYPE_TEMPORARY);
            }    
        }
    }    
    
/*   
    int nLegacy = GetPersistantLocalInt(oPC, "LegacyRitual");
    if (nLegacy == 1)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LEAST_LEGACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    else if (nLegacy == 2)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LESSER_LEGACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    else if (nLegacy == 3)
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREATER_LEGACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
*/
}